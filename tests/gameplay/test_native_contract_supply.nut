// Actual native supply predicates and contract registration, through our hooks.
local passed=0, now=6000.0, origin=true, size=1, currentFaction=null;
local check=function(ok,label){if(!ok)throw "FAIL "+label;passed++;};
::Const <- {GenericFootprints=[],FactionType={None=0},Factions={RelationDecayPerDay=0}};
::Math <- {function rand(a,b){return 100;}};
::Time <- {function getVirtualTimeF(){return now;}};
::logDebug <- function(message){};
dofile(".cache/afei-art/native-contract-fixture/faction.nut");
::inherit <- function(path,body){
    local result=clone ::faction;result.m=clone ::faction.m;
    foreach(k,v in body){if(k=="m"){foreach(field,value in v)result.m[field]<-value;}else result[k]<-v;}
    result.setdelegate(getroottable());return result;
};
dofile(".cache/afei-art/native-contract-fixture/settlement_faction.nut");
dofile(".cache/afei-art/native-contract-fixture/city_state_faction.nut");
dofile(".cache/afei-art/native-contract-fixture/contract_manager.nut");
local manager=::contract_manager;manager.setdelegate(getroottable());
::World <- {Contracts=manager,FactionManager={function getFaction(id){return currentFaction;}},
    function getTime(){return {Days=1+now/600,SecondsPerDay=600};}};
::AfeixExpedition <- {function isOrigin(){return origin;}};
dofile("src/scripts/mods/afeix/quests.nut");
local A=::AfeixExpedition;
::mods_hookExactClass <- function(path,cb){
    if(path=="factions/settlement_faction")cb(::settlement_faction);
    if(path=="factions/city_state_faction")cb(::city_state_faction);
};
::mods_hookNewObject <- function(...){};::mods_hookBaseClass <- function(...){};
dofile("src/scripts/mods/afeix/hooks.nut");
function offer(kind){return {m={ID=0,TimeOut=9000,Faction=7},function isValid(){return true;},
    function getType(){return kind;},function getName(){return kind;},function getFaction(){return this.m.Faction;},
    function setFaction(id){this.m.Faction=id;}};}
local reset=function(nativeClass){
    currentFaction=clone nativeClass;currentFaction.m=clone nativeClass.m;
    currentFaction.m.ID=7;currentFaction.m.Contracts=[];currentFaction.m.LastContractTime=0;
    currentFaction.m.Settlements=[{function getSize(){return size;}}];
    manager.m.Open=[];manager.m.NextContractID=1;origin=true;size=1;now=6000;
};
reset(::settlement_faction);
local letter=offer("contract.afeix_letter"), originalPool=currentFaction.m.Contracts;
A.registerTownLetter(currentFaction,letter);
check(letter.m.ID==1 && manager.m.Open[0]==letter && originalPool[0]==letter,"supplementary letter keeps native ID and both registrations");
check(currentFaction.m.LastContractTime==0,"letter does not restart ordinary supply clock");
check(currentFaction.isReadyForContract(),"size-one village can generate normal work while offering a mod letter");
check(currentFaction.m.Contracts==originalPool && originalPool.len()==1,"readiness restores original array for display and saving");
local job=offer("contract.escort_caravan");manager.addContract(job);
check(currentFaction.m.LastContractTime==now && originalPool.len()==2,"native paid job still uses normal supply clock and capacity");
check(!currentFaction.isReadyForContract(),"one native job fills a size-one village");
currentFaction.removeContract(job);now+=2999;
check(!currentFaction.isReadyForContract(),"normal completed job still enforces native five-day delay");
now+=2;check(currentFaction.isReadyForContract(),"native supply resumes after its normal delay with mod letter retained");
local normalLetter=offer("contract.deliver_item");currentFaction.addContract(normalLetter);
check(!currentFaction.isReadyForContract(),"vanilla courier remains part of native supply limits");
currentFaction.removeContract(normalLetter);origin=false;
check(!currentFaction.isReadyForContract(),"other origins retain native counting unchanged");origin=true;
local threw=false;try{A.withNativeContractSupply(currentFaction,function(){throw "predicate failure";});}catch(error){threw=true;}
check(threw && currentFaction.m.Contracts==originalPool,"exception restores original contract pool");
local add=manager.addContract, oldTime=currentFaction.m.LastContractTime;
manager.addContract=function(c){currentFaction.m.LastContractTime=now;throw "registration failure";};
threw=false;try{A.registerTownLetter(currentFaction,letter);}catch(error){threw=true;}
check(threw && currentFaction.m.LastContractTime==oldTime,"failed registration restores prior supply timer");manager.addContract=add;
reset(::city_state_faction);A.registerTownLetter(currentFaction,offer("contract.afeix_letter"));
currentFaction.addContract(offer("contract.drive_away_nomads"));currentFaction.addContract(offer("contract.escort_caravan"));
check(currentFaction.isReadyForContract(),"city-state has room for a third normal contract alongside extra letter after day five");
now=600;check(!currentFaction.isReadyForContract(),"early city-state still caps normal contracts at two");
// Prove that neutral relations qualify; no high-favor gate is required.
reset(::settlement_faction);currentFaction.m.Allies=[];currentFaction.m.Settlements=[];currentFaction.m.Units=[];
check(currentFaction.m.PlayerRelation==50,"native default relations start neutral at fifty");
currentFaction.updatePlayerRelation();check(currentFaction.isAlliedWithPlayer(),"neutral default passes the exact alliance predicate used by recruitment");
currentFaction.m.PlayerRelation=20;currentFaction.updatePlayerRelation();check(currentFaction.isAlliedWithPlayer(),"non-hostile threshold is twenty");
currentFaction.m.PlayerRelation=19;currentFaction.updatePlayerRelation();check(!currentFaction.isAlliedWithPlayer(),"hostile relations fail recruitment gate");
print("TESTS_PASSED="+passed+"\n");
