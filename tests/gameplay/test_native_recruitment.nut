// Real native hire dialog + production hooks/queue/character construction.
// Engine actor persistence and drawing still require a game run.
local checks=0;
function check(value, message) { if (!value) throw "FAIL " + message; }
local expect=function(value,message){checks++;check(value,message);};
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){}; ::mods_queue <- function(...){};
::Math <- {function max(a,b){return a>b?a:b;},function min(a,b){return a<b?a:b;},function ceil(n){return ::ceil(n);}};
::Const <- {Attributes={COUNT=8,Hitpoints=0,Fatigue=1,Bravery=2,Initiative=3,MeleeSkill=4,RangedSkill=5,MeleeDefense=6,RangedDefense=7},
    LevelXP=[0],XP={MaxLevelWithPerkpoints=11},UI={Error={NotEnoughMoney=1,NotEnoughRosterSpace=2,RosterEntryNotFound=3}}};
local now=0.0, serial=0, origin=true, failItem=false, failures=0;
::Time <- {function getVirtualTimeF(){return now;}};
::logError <- function(message){failures++;};
function flags(){return {values={},function has(k){return k in this.values;},function get(k){return k in this.values?this.values[k]:0;},
    function set(k,v){this.values[k]<-v;},function increment(k){this.set(k,this.get(k)+1);}};}
function brother(){
    local f=flags(), talents=[], props={Hitpoints=0,Stamina=0,Bravery=0,Initiative=0,MeleeSkill=0,RangedSkill=0,MeleeDefense=0,RangedDefense=0};
    local bg={m={DailyCost=0,DailyCostMult=1.0,RawDescription=""},function buildDescription(final){}};
    local items={equipped=[],bag=[],function clear(){this.equipped=[];this.bag=[];},function equip(v){this.equipped.push(v);},function addToBag(v){this.bag.push(v);}};
    return {id=++serial,m={Level=1,XP=0,LevelUps=0,HireTime=0,HiringCost=99},place=255,name="",battles=0,hired=0,
        function getID(){return this.id;},function getFlags(){return f;},function getBackground(){return bg;},function getTalents(){return talents;},
        function getBaseProperties(){return props;},function getItems(){return items;},function getSkills(){return {function update(){}};},
        function getHitpointsMax(){return props.Hitpoints;},function setHitpoints(n){},function getLevel(){return this.m.Level;},
        function getLifetimeStats(){return {Battles=this.battles};},function isAlive(){return true;},
        function getPlaceInFormation(){return this.place;},function setPlaceInFormation(n){this.place=n;},
        function setStartValuesEx(backgrounds,traits){check(!traits,"no random traits on named candidates");},function fillAttributeLevelUpValues(n){},
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
    function getTime(){return {Days=1+now/600,SecondsPerDay=600};},
    Assets={m={HiringCostMult=1.0},money=100000,function getMoney(){return this.money;},function getFood(){return 100;},
        function getBrothersMax(){return 40;},function addMoney(n){this.money+=n;}}
};
::new <- function(path){if(failItem)throw "injected item failure";return {path=path};};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition;A.isOrigin=function(){return origin;};A.syncCharacterFeatures=function(bro){};
A.ensureStoryItems=function(){}; // inventory migration is exercised by test_keepsakes.nut
::inherit <- function(path,child){return child;};
dofile(".cache/afei-art/native-contract-fixture/town_hire_dialog_module.nut");
local hire=::town_hire_dialog_module;hire.setdelegate(getroottable());
hire.m.Parent <- {function queryAssetsInformation(){return {Money=::World.Assets.getMoney()};},
    function getMainDialogModule(){return {function reload(){}};}};
::UIDataHelper <- {function convertHireRosterToUIData(id){return ::World.getRoster(id).getAll();}};
local settlementHook=null;
::mods_hookExactClass <- function(path,callback){
    if(path=="ui/screens/world/modules/world_town_screen/town_hire_dialog_module")callback(hire);
    if(path=="entity/world/settlement")settlementHook=callback;
};
::mods_hookNewObject <- function(...){};::mods_hookBaseClass <- function(...){};
dofile("src/scripts/mods/afeix/hooks.nut");
local reset=function(){
    now=0;origin=true;failItem=false;player.actors=[];temporary.actors=[];::World.Flags.values={};::World.Assets.money=100000;
    foreach(r in townRosters)r.actors=[];
    foreach(t in towns){t.friendly=true;t.alive=true;t.military=false;}
    foreach(key in ["afei","damou","mocha"])A.makeCharacter(key);
    hire.setRosterID(1);
};
reset();
local ordinary=brother();townRosters[1].add(ordinary);
local initial=hire.queryHireInformation();
expect(initial.Roster.len()==1 && initial.Roster[0]==ordinary,"fresh recruit screen preserves ordinary pool and hides locked names");
expect(A.get("recruit_towns")==1 && A.knownMembers().len()==3,"only actual visits and captains recorded");
hire.queryHireInformation();expect(A.get("recruit_towns")==1,"reopening a town does not inflate exploration");
A.findCharacter("afei").battles=1;
local result=hire.queryHireInformation(), candidate=A.candidateInRoster(townRosters[1],"bottle");
expect(candidate!=null && result.Roster.len()==2,"qualified bottle appears directly alongside native recruits");
expect(player.getSize()==3 && !A.get("ever_bottle",false) && A.get("met_bottle",false),"preview is known but neither hired nor counted as companion");
expect(candidate.name==A.Characters.bottle.name && candidate.getHiringCost()==A.recruitPrice("bottle"),"fixed identity and cost on actual hire entry");
expect(!A.recruit("bottle").ok && !A.resolveEncounter("bottle",0).ok,"legacy entry cannot bypass native payment or pacing");
local id=candidate.getID(), gear=candidate.getItems(), price=candidate.getHiringCost();
::World.Assets.money=price-1;
expect(hire.onHireRosterEntry(id).Result==1 && candidate.hired==0 && player.getSize()==3,"insufficient money leaves candidate and identity intact");
::World.Assets.money=100000;
while(player.getSize()<40)player.add(brother());
expect(hire.onHireRosterEntry(id).Result==2 && ::World.Assets.money==100000 && !A.get("ever_bottle",false),"full roster causes no payment or consumed invitation");
while(player.getSize()>3)player.actors.pop();
// Native town refresh can clear its pool. Keep the same actor out of that clear.
local otherTemporary=brother();temporary.add(otherTemporary);
local refresh=function(force){check(this==towns[1] && force,"bound original receives town and force");townRosters[1].actors=[];return 17;};
expect(A.withProtectedCandidates(towns[1],refresh,true)==17,"native refresh return preserved");
expect(townRosters[1].getSize()==1 && townRosters[1].actors[0]==candidate && temporary.getSize()==1 && temporary.actors[0]==otherTemporary,"candidate survives refresh without clearing others in temporary roster");
local threw=false;
try {A.withProtectedCandidates(towns[1],function(force){townRosters[1].actors=[];throw "native refresh failed";},false);}catch(e){threw=true;}
expect(threw && townRosters[1].actors[0]==candidate && temporary.getSize()==1,"refresh failure restores held actor before rethrow");
hire.setRosterID(2);result=hire.queryHireInformation();
expect(result.Roster.len()==1 && result.Roster[0]==candidate && townRosters[1].getSize()==0,"another city moves the same offer rather than rerolling it");
expect(A.get("recruit_towns")==2 && A.get("recruit_order_shuaizi")>0 && !A.isCharacterKnown("shuaizi"),"second eligible person waits without spoilers");
candidate.m.HiringCost=9999;candidate.m.XP=123;candidate.m.Level=2;
local expiry=A.get("recruit_offer_until"), ready=A.get("recruit_next_time");
dofile("src/scripts/mods/afeix/recruitment.nut");A.restoreHireCandidate();
expect(candidate.getHiringCost()==price && candidate.m.XP==123 && candidate.m.Level==2 && candidate.getItems()==gear,"reload restores price while keeping growth and gear");
expect(A.get("recruit_offer_until")==expiry && A.get("recruit_next_time")==ready,"reload cannot reset timer or queue");
result=hire.onHireRosterEntry(id);
expect(result.Result==0 && ::World.Assets.money==100000-price && candidate.hired==1 && A.findCharacter("bottle")==candidate,"real native hire debits once and transfers same entity");
expect(A.get("ever_bottle",false) && !candidate.getFlags().get("afeix_candidate") && candidate.place<18,"native hire commits identity and formation");
expect(hire.onHireRosterEntry(id).Result==3 && ::World.Assets.money==100000-price,"stale double click cannot charge or duplicate");
hire.setRosterID(1);expect(hire.queryHireInformation().Roster.len()==0,"changing city cannot bypass three-day interval");
now=600*3-1;expect(hire.queryHireInformation().Roster.len()==0,"no early offer at interval boundary");
now++;hire.queryHireInformation();expect(A.get("recruit_offer_key","")=="shuaizi","queued recruit appears exactly at eligible next visit");
// A creation failure cannot consume eligibility or leave a partial actor.
reset();A.findCharacter("afei").battles=1;failItem=true;
hire.queryHireInformation();expect(A.get("recruit_order_bottle")>0 && A.get("recruit_offer_key","")=="" && townRosters[1].getSize()==0,"failed construction leaves queue intact without orphan");
failItem=false;hire.queryHireInformation();expect(A.get("recruit_offer_key","")=="bottle","retry can fulfill retained eligibility");
// All requirements can be reached, all queued people are served, independent of RNG.
reset();A.findCharacter("afei").battles=99;A.findCharacter("afei").m.Level=11;
A.set("qualified_contracts",99);A.set("qualified_types",9);
foreach(t in towns)A.visitRecruitTown(t);
local seen={};
for(local i=0;i<31;i++){
    hire.setRosterID(1+i%7);hire.queryHireInformation();
    local key=A.get("recruit_offer_key","");expect(key!="" && !(key in seen),"finite queue serves a new eligible member "+i);
    local b=A.candidateInRoster(townRosters[1+i%7],key);seen[key]<-true;
    expect(b!=null && hire.onHireRosterEntry(b.getID()).Result==0,"native hiring completes member "+key);
    now+=600*3;
}
expect(player.getSize()==34 && A.deployedIds().len()==10 && seen.len()==31,"all 34 coexist with exactly ten deployed");
// Passing over a candidate rotates it behind others, never permanently locks it.
reset();A.findCharacter("afei").battles=1;A.visitRecruitTown(towns[2]);hire.queryHireInformation();
local missed=A.get("recruit_offer_key","");now=600*4;
hire.queryHireInformation();expect(A.get("recruit_offer_key","")!=missed && A.get("recruit_order_"+missed)>0,"expired offer returns to the queue tail");
local replacement=A.candidateInRoster(townRosters[1],A.get("recruit_offer_key",""));hire.onHireRosterEntry(replacement.getID());
now+=600*3;hire.queryHireInformation();expect(A.get("recruit_offer_key","")==missed,"missed candidate returns after intervening offer");
// A destroyed settlement can lose actors, but not the entitlement.
townRosters[1].actors=[];towns[1].alive=false;hire.setRosterID(2);hire.queryHireInformation();
expect(A.candidateInRoster(townRosters[2],missed)!=null,"lost town roster can rebuild an unconsumed offer");
reset();origin=false;A.set("qualified_contracts",99);A.set("qualified_types",9);
expect(hire.queryHireInformation().Roster.len()==0 && A.get("recruit_towns")==0,"other origin never gains named candidates or visit flags");
origin=true;towns[1].friendly=false;expect(hire.queryHireInformation().Roster.len()==0,"hostile town cannot present candidate");
towns[1].friendly=true;towns[1].military=true;expect(hire.queryHireInformation().Roster.len()==0,"military settlement excluded");
print("TESTS_PASSED="+checks+"\n");
