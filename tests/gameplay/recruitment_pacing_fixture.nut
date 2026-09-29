// Real native hire dialog + production hooks/queue/character construction.
// Engine actor persistence and drawing still require a game run.
::pacingChecks<-0;
function check(value, message) { if (!value) throw "FAIL " + message; }
::expect<-function(value,message){::pacingChecks++;check(value,message);};
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){}; ::mods_queue <- function(...){};
::Math <- {function max(a,b){return a>b?a:b;},function min(a,b){return a<b?a:b;},function ceil(n){return ::ceil(n);},function pow(a,b){return ::pow(a,b);},function rand(a,b){return b;},function floor(n){return ::floor(n);}};
::Const <- {Attributes={COUNT=8,Hitpoints=0,Fatigue=1,Bravery=2,Initiative=3,MeleeSkill=4,RangedSkill=5,MeleeDefense=6,RangedDefense=7},
    LevelXP=[0,200,500,1000,2000,3500,5000,7000,9000,12000,15000],XP={MaxLevelWithPerkpoints=11},UI={Error={NotEnoughMoney=1,NotEnoughRosterSpace=2,RosterEntryNotFound=3}}};
local now=0.0, serial=0, origin=true, failItem=false, failures=0;
::Time <- {function getVirtualTimeF(){return now;}};
::logError <- function(message){failures++;};
function flags(){return {values={},function has(k){return k in this.values;},function get(k){return k in this.values?this.values[k]:0;},
    function set(k,v){this.values[k]<-v;},function increment(k){this.set(k,this.get(k)+1);}};}
function brother(){
    local f=flags(), talents=[], props={Hitpoints=0,Stamina=0,Bravery=0,Initiative=0,MeleeSkill=0,RangedSkill=0,MeleeDefense=0,RangedDefense=0};
    local bg={m={ID="",Name="",BackgroundDescription="",Description="",DailyCost=0,DailyCostMult=1.0,RawDescription=""},function getID(){return this.m.ID;},function buildDescription(final){},
        function getDescription(){return this.m.Description;},function onChangeAttributes(){local r={};foreach(k,v in props)r[k]<-[0,0];return r;}};
    local items={equipped=[],bag=[],function clear(){this.equipped=[];this.bag=[];},function equip(v){this.equipped.push(v);},function addToBag(v){this.bag.push(v);}};
    return {id=++serial,m={Level=1,XP=0,LevelUps=0,PerkPoints=0,PerkPointsSpent=0,HireTime=0,HiringCost=99},place=255,name="",battles=0,hired=0,
        function getID(){return this.id;},function getFlags(){return f;},function getBackground(){return bg;},function getTalents(){return talents;},
        function getBaseProperties(){return props;},function getItems(){return items;},function getSkills(){return {function update(){}};},
        function getHitpointsMax(){return props.Hitpoints;},function setHitpoints(n){},function getLevel(){return this.m.Level;},
        function getLifetimeStats(){return {Battles=this.battles};},function isAlive(){return true;},
        function getPlaceInFormation(){return this.place;},function setPlaceInFormation(n){this.place=n;},
        function setStartValuesEx(backgrounds,traits){check(!traits,"no random traits on named candidates");bg.m.ID="background."+backgrounds[0].slice(0,backgrounds[0].len()-11);},function fillAttributeLevelUpValues(n){},
        function setName(s){this.name=s;},function setTitle(s){},function getHiringCost(){return this.m.HiringCost;},function onHired(){this.hired++;}
    };
}
function roster(){return {actors=[],function create(path){local b=brother();this.add(b);return b;},function add(b){if(this.actors.find(b)==null)this.actors.push(b);},
    function remove(b){local i=this.actors.find(b);if(i!=null)this.actors.remove(i);},function getAll(){return clone this.actors;},
    function getSize(){return this.actors.len();}};}
local player=roster(), temporary=roster(), townRosters={}, towns={};
function town(id){return {friendly=true,alive=true,military=false,function getID(){return id;},function getNameOnly(){return "Town"+id;},
    function isAlliedWithPlayer(){return this.friendly;},function isAlive(){return this.alive;},function isMilitary(){return this.military;}};}
foreach(id in [1,2,3,4,5,6,7]){townRosters[id]<-roster();towns[id]<-town(id);}
::World <- {
    Flags=flags(),Statistics={getFlags=function(){return ::World.Flags;}},
    function getPlayerRoster(){return player;},function getTemporaryRoster(){return temporary;},
    function getRoster(id){return id in townRosters?townRosters[id]:null;},function getEntityByID(id){return id in towns?towns[id]:null;},
    function getTime(){return {Days=1+now/600,SecondsPerDay=600,IsDaytime=true};},
    Assets={m={HiringCostMult=1.0},money=100000,function getMoney(){return this.money;},function getFood(){return 100;},
        function getBrothersMax(){return 40;},function addMoney(n){this.money+=n;}}
};
::new <- function(path){if(failItem)throw "injected item failure";return {path=path};};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition;A.isOrigin=function(){return origin;};A.syncCharacterFeatures=function(bro){};
A.balanceTraits=function(bro,fresh=false){};
A.ensureStoryItems=function(){}; // inventory migration is exercised by test_keepsakes.nut
::inherit <- function(path,child){return child;};
dofile(".cache/afei-art/native-contract-fixture/town_hire_dialog_module.nut");
local hire=::town_hire_dialog_module;hire.setdelegate(getroottable());
hire.m.Parent <- {function queryAssetsInformation(){return {Money=::World.Assets.getMoney()};},
    function getMainDialogModule(){return {function reload(){}};}};
::UIDataHelper <- {function convertHireRosterToUIData(id){return ::World.getRoster(id).getAll();}};
local settlementHook=null,townScreenHook=null;
::mods_hookExactClass <- function(path,callback){
    if(path=="ui/screens/world/modules/world_town_screen/town_hire_dialog_module")callback(hire);
    if(path=="entity/world/settlement")settlementHook=callback;
};
::mods_hookNewObject <- function(path,callback){if(path=="ui/screens/world/world_town_screen")townScreenHook=callback;};
::mods_hookBaseClass <- function(...){};
dofile("src/scripts/mods/afeix/hooks.nut");
local reset=function(){
    now=0;origin=true;failItem=false;player.actors=[];temporary.actors=[];::World.Flags.values={};::World.Assets.money=100000;
    foreach(r in townRosters)r.actors=[];
    foreach(t in towns){t.friendly=true;t.alive=true;t.military=false;}
    foreach(key in ["afei","damou","mocha"])A.makeCharacter(key);
    hire.setRosterID(1);
};

::PacingFixture <- { A=A, hire=hire, towns=towns, townRosters=townRosters, player=player,
    reset=reset, advance=function(day){now=(day-1)*600;},
    failItems=function(value){failItem=value;}, failures=function(){return failures;},
    query=function(){hire.setRosterID(1);return hire.queryHireInformation();},
    progress=function(battles,jobs,visits,level){A.findCharacter("afei").battles=battles;A.findCharacter("afei").m.Level=level;A.set("qualified_contracts",jobs);A.set("recruit_towns",visits);},
    hireKey=function(key){local b=A.candidateInRoster(townRosters[1],key);return b==null?-1:hire.onHireRosterEntry(b.getID()).Result;}
};
