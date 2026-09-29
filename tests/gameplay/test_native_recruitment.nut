// Real native hire dialog + production hooks/queue/character construction.
// Engine actor persistence and drawing still require a game run.
local checks=0;
function check(value, message) { if (!value) throw "FAIL " + message; }
local expect=function(value,message){checks++;check(value,message);};
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){}; ::mods_queue <- function(...){};
::Math <- {function max(a,b){return a>b?a:b;},function min(a,b){return a<b?a:b;},function ceil(n){return ::ceil(n);},function floor(n){return ::floor(n);}};
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
// This suite isolates FIFO/native payment with its original eligibility schedule;
// all V2 day/AND boundaries are covered by test_discovery and test_balance_v26.
dofile("src/scripts/mods/afeix/discovery.nut");
// Preserve this legacy payment/slot fixture; production visitor lanes and the
// current AND gates have their own integrated pacing suite.
A.RandomRecruitKeys=[];A.RandomRecruits={};A.RecruitOfferCount=3;
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
expect(result.Roster.len()==2 && result.Roster[0]==candidate && townRosters[1].getSize()==0,"another village moves existing offer and fills an unused slot");
expect(A.get("recruit_towns")==2 && A.isCharacterKnown("shuaizi"),"second eligible person appears immediately in another slot");
candidate.m.HiringCost=9999;candidate.m.XP=123;candidate.m.Level=2;
local expiry=A.getRecruitSlot(0).expires, ready=A.getRecruitSlot(0).ready;
dofile("src/scripts/mods/afeix/recruitment.nut");A.restoreHireCandidate();
expect(candidate.getHiringCost()==price && candidate.m.XP==123 && candidate.m.Level==2 && candidate.getItems()==gear,"reload restores price while keeping growth and gear");
expect(A.getRecruitSlot(0).expires==expiry && A.getRecruitSlot(0).ready==ready,"reload cannot reset timer or queue");
A.findCharacter("afei").battles=3;hire.queryHireInformation();
local third=A.candidateInRoster(townRosters[2],"yuchujiu");
expect(third!=null && townRosters[2].getSize()==3,"three eligible recruits coexist");
foreach(key in ["bottle","shuaizi","yuchujiu"])
    expect(A.characterStatus(key)=="available" && A.recruitHint(key).find("费用")!=null,"ledger recognizes every active slot "+key);
result=hire.onHireRosterEntry(id);
expect(result.Result==0 && ::World.Assets.money==100000-price && candidate.hired==1 && A.findCharacter("bottle")==candidate,"real native hire debits once and transfers same entity");
expect(A.get("ever_bottle",false) && !candidate.getFlags().get("afeix_candidate") && candidate.place<18,"native hire commits identity and formation");
expect(hire.onHireRosterEntry(id).Result==3 && ::World.Assets.money==100000-price,"stale double click cannot charge or duplicate");
now=100;local second=A.candidateInRoster(townRosters[2],"shuaizi");
expect(hire.onHireRosterEntry(second.getID()).Result==0,"remaining offer can be hired during another slot cooldown");
A.set("qualified_contracts",1);hire.setRosterID(3);
expect(hire.queryHireInformation().Roster.len()==1 && A.recruitOfferSlot("yuchujiu")==2,"moving villages preserves offers without bypassing cooldown");
expect(!A.isCharacterKnown("lili") && !A.isCharacterKnown("xiaoyueya"),"queued names stay hidden until a slot is ready");
now=599;expect(hire.queryHireInformation().Roster.len()==1,"no refill before one full day");
now=600;expect(hire.queryHireInformation().Roster.len()==2 && A.recruitOfferSlot("xiaoyubeike")==0,"first slot refills from FIFO exactly one day after its own hire");
expect(A.getRecruitSlot(1).ready==700,"a later hire cannot postpone another slot");
now=699;expect(hire.queryHireInformation().Roster.len()==2,"second slot keeps independent cooldown");
now=700;expect(hire.queryHireInformation().Roster.len()==3 && A.recruitOfferSlot("lili")==1,"second slot refills on its own boundary");
local allThree=clone townRosters[3].actors;
A.withProtectedCandidates(towns[3],function(force){townRosters[3].actors=[];},true);
foreach(b in allThree)expect(townRosters[3].actors.find(b)!=null,"native refresh preserves all three actors");
for(local i=0;i<5;i++)hire.queryHireInformation();
expect(townRosters[3].getSize()==3,"repeated queries never exceed three offers");
// A creation failure cannot consume eligibility or leave a partial actor.
reset();A.findCharacter("afei").battles=1;failItem=true;
hire.queryHireInformation();expect(A.get("recruit_order_bottle")>0 && A.recruitOfferSlot("bottle")<0 && townRosters[1].getSize()==0,"failed construction leaves queue intact without orphan");
failItem=false;hire.queryHireInformation();expect(A.recruitOfferSlot("bottle")==0,"retry can fulfill retained eligibility");
// All requirements can be reached, all queued people are served, independent of RNG.
reset();A.findCharacter("afei").battles=99;A.findCharacter("afei").m.Level=11;
A.set("qualified_contracts",99);A.set("qualified_types",9);
foreach(t in towns)A.visitRecruitTown(t);
local seen={};
for(local i=0;i<31;i++){
    hire.setRosterID(1+i%7);hire.queryHireInformation();
    local key="";for(local s=0;s<3;s++)if(A.getRecruitSlot(s).key!=""){key=A.getRecruitSlot(s).key;break;}
    expect(key!="" && !(key in seen),"finite queue serves a new eligible member "+i);
    local b=A.candidateInRoster(townRosters[1+i%7],key);seen[key]<-true;
    expect(b!=null && hire.onHireRosterEntry(b.getID()).Result==0,"native hiring completes member "+key);
    now+=600;
}
expect(player.getSize()==34 && A.deployedIds().len()==12 && seen.len()==31,"all 34 coexist with exactly twelve deployed");
// Passing over a candidate rotates it behind others, never permanently locks it.
reset();A.findCharacter("afei").battles=3;A.set("qualified_contracts",1);
foreach(t in towns)A.visitRecruitTown(t);hire.queryHireInformation();
local missed=A.getRecruitSlot(0).key, expired=clone townRosters[1].actors;
now=600*4;hire.queryHireInformation();
expect(A.recruitOfferSlot(missed)<0 && A.get("recruit_order_"+missed)>0,"expired offers rotate behind queued people");
foreach(b in expired)expect(townRosters[1].actors.find(b)==null,"expired actor is removed before replacement");
expect(A.characterStatus(missed)=="waiting","ledger marks an expired queued member waiting");
now+=600*4;hire.queryHireInformation();
expect(A.recruitOfferSlot(missed)>=0,"missed candidate returns after intervening offers");
// A destroyed settlement can lose actors, but not the entitlement.
townRosters[1].actors=[];towns[1].alive=false;hire.setRosterID(2);hire.queryHireInformation();
expect(A.candidateInRoster(townRosters[2],missed)!=null,"lost town roster can rebuild an unconsumed offer");
// Upgrade a real old-format offer without recreating it or resetting its expiry.
reset();A.findCharacter("afei").battles=3;A.visitRecruitTown(towns[2]);
local legacy=A.createHireCandidate("bottle",townRosters[1]);
A.set("recruit_offer_key","bottle");A.set("recruit_offer_town",1);
A.set("recruit_offer_until",2400);A.set("recruit_next_time",1800);A.set("met_bottle",true);
now=300;A.restoreHireCandidate();hire.queryHireInformation();
expect(A.candidateInRoster(townRosters[1],"bottle")==legacy && A.getRecruitSlot(0).expires==2400,"old save keeps candidate identity and original expiry");
expect(townRosters[1].getSize()==3 && A.get("recruit_offer_key","")=="","upgrade adds two slots and clears legacy ownership");
local savedFlags=clone ::World.Flags.values;
::World.Flags.values=clone savedFlags;dofile("src/scripts/mods/afeix/recruitment.nut");A.restoreHireCandidate();
hire.queryHireInformation();expect(townRosters[1].getSize()==3 && A.getRecruitSlot(0).expires==2400,"persisted scalar slot flags survive reload without duplicates");
reset();A.set("recruit_next_time",1800);now=100;A.restoreHireCandidate();
expect(A.getRecruitSlot(0).ready==600 && A.getRecruitSlot(1).ready==0 && A.getRecruitSlot(2).ready==0,"old cooldown shortens to one day and does not block new slots");
now=500;A.restoreHireCandidate();expect(A.getRecruitSlot(0).ready==600,"repeated migration cannot shorten cooldown twice");
reset();A.set("recruit_next_time",1800);now=2000;A.restoreHireCandidate();
expect(A.getRecruitSlot(0).ready<=now,"elapsed legacy cooldown does not start a new wait on loading");
// Native crowd artwork is the clickable hire entrance. An empty ordinary pool
// must be filled on settlement entry, before any hire query can happen.
reset();A.findCharacter("afei").battles=1;
dofile(".cache/afei-art/native-contract-fixture/crowd_building.nut");
local crowd=::crowd_building;crowd.setdelegate(getroottable());crowd.m.Settlement<-towns[1];
expect(crowd.getUIImage()==null,"native empty village hides the hire entrance");
local entering=clone towns[1];entering.onEnter<-function(){return true;};entering.updateRoster<-function(force=false){};
settlementHook(entering);
local originalLetter=A.ensureTownLetter;A.ensureTownLetter=function(t){};
expect(entering.onEnter() && crowd.getUIImage()!=null && townRosters[1].getSize()==1,"entry prepares eligible member before native entrance visibility");
A.ensureTownLetter=originalLetter;
reset();origin=false;A.set("qualified_contracts",99);A.set("qualified_types",9);
expect(hire.queryHireInformation().Roster.len()==0 && A.get("recruit_towns")==0,"other origin never gains named candidates or visit flags");
origin=true;towns[1].friendly=false;expect(hire.queryHireInformation().Roster.len()==0,"hostile town cannot present candidate");
towns[1].friendly=true;towns[1].military=true;expect(hire.queryHireInformation().Roster.len()==0,"military settlement excluded");
// Reproduce the installed display mod replacing our query on the live module.
reset();A.findCharacter("afei").battles=2;A.findCharacter("afei").m.Level=2;
A.set("qualified_contracts",3);A.visitRecruitTown(towns[1]);A.visitRecruitTown(towns[2]);
foreach(key in ["shuaizi","lili","bottle","xiaoyubeike"])A.queueRecruit(key);
local oldQuery=hire.queryHireInformation,displayModLoaded=false;
// Engine methods captured by NewObject hooks are bound to the live instance.
hire.onHireRosterEntry=hire.onHireRosterEntry.bindenv(hire);
::mods_hookNewObjectOnce <- function(path,callback){
    if(path=="ui/screens/world/modules/world_town_screen/town_hire_dialog_module"){callback(hire);displayModLoaded=true;}
};
try {dofile(".cache/afei-art/native-contract-fixture/alternative_hire.nut");}
catch(error){throw "Installed display-mod fixture could not load: "+error;}
if (!::AFEIX_InstalledRecruitDisplay) {
    // Keep the replacement regression runnable on machines without this mod.
    hire.queryHireInformation=function(){return {Roster=this.convertHireRosterToUIDataAltered(this.m.RosterID),Assets=this.m.Parent.queryAssetsInformation()};};
    hire.convertHireRosterToUIDataAltered<-function(id){local data=[];foreach(b in ::World.getRoster(id).getAll())data.push(this.convertEntityHireInformationToUIDataAltered(b));return data;};
    hire.convertEntityHireInformationToUIDataAltered<-null;
    displayModLoaded=true;
}
expect(displayModLoaded && hire.queryHireInformation!=oldQuery,"display override replaces production hire-query hook");
// Keep the real third-party query and roster conversion; art/text rendering is
// outside this fixture's engine substitutes and has no bearing on generation.
hire.convertEntityHireInformationToUIDataAltered=function(b){return {ID=b.getID(),Name=b.name,DisplayMod=true};};
local alternateQuery=hire.queryHireInformation,payload=null;
::Tooltip <- {function hide(){}};
dofile(".cache/afei-art/native-contract-fixture/world_town_screen.nut");
local townScreen=::world_town_screen;townScreen.setdelegate(getroottable());
townScreen.m.Visible=true;townScreen.m.HireDialogModule=hire;
townScreen.m.JSHandle={function asyncCall(method,data){payload=data;}};
townScreen.showHireDialog();
expect(payload.Roster.len()==0 && A.get("recruit_queue_serial")==4,"old native screen plus installed override reproduces four queued people and no candidates");
expect(townScreenHook!=null,"bare town-screen entry is registered via NewObject");
townScreenHook(townScreen);townScreen.showHireDialog();
expect(payload.Roster.len()==3 && payload.Roster[0].DisplayMod && hire.queryHireInformation==alternateQuery,"screen entry fills three slots while retaining the installed converter");
foreach(key in ["shuaizi","lili","bottle"])expect(A.recruitOfferSlot(key)>=0,"saved FIFO queue is honored under display override "+key);
local hired=A.candidateInRoster(townRosters[1],"shuaizi");
expect(hire.onHireRosterEntry(hired.getID()).Result==0 && A.get("ever_shuaizi",false),"actual third-party hire wrapper still commits native hire and identity");
now=599;townScreen.showHireDialog();expect(payload.Roster.len()==2,"override cannot bypass one-day refill");
now=600;townScreen.showHireDialog();
expect(payload.Roster.len()==3 && A.recruitOfferSlot("xiaoyubeike")>=0,"reopening same screen after one day refills despite replaced query");
hire.setRosterID(3);townScreen.showHireDialog();
expect(payload.Roster.len()==3 && townRosters[1].getSize()==0,"cross-village transfer still works with display mod");
reset();origin=false;townScreen.showHireDialog();
expect(payload.Roster.len()==0 && A.get("recruit_towns")==0,"screen compatibility hook leaves other origins untouched");
print("TESTS_PASSED="+checks+"\n");
