// Run native event/ambition managers in their real world-frame order.
local checks=0,origin=true,now=1000.0,finished=7,fired=0,blocked=false;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Math <- {min=function(a,b){return a<b?a:b;},maxf=function(a,b){return a>b?a:b;}};
::Time <- {getVirtualTimeF=function(){return now;}};
::Tactical <- {};::LoadingScreen <- null;
::Const <- {Events={GlobalMinDelay=100},World={Assets={}}};
::AfeixExpedition <- {isOrigin=function(){return origin;}};
::World <- {State={m={EventScreen={isVisible=function(){return blocked;},isAnimating=function(){return false;}}},
    getMenuStack=function(){return {hasBacksteps=function(){return false;}};},
    getPlayer=function(){return {m={Destination={X=1,Y=2}},getPos=function(){return {};}};}},
    getTime=function(){return {Days=10,SecondsPerHour=25};},getAllEntitiesAtPos=function(...){return [];},
    Contracts={getActiveContract=function(){return null;},getContractsFinished=function(){return finished;}},
    Assets={resetToDefaults=function(){},getOrigin=function(){return {getID=function(){return "scenario.afeix_expedition";}};}},
    TopbarAmbitionModule={setText=function(t){}}};
dofile(".cache/afei-art/native-contract-fixture/ambition.nut");
::inherit <- function(path,body){
    local o=clone ::ambition;o.m=clone ::ambition.m;
    foreach(k,v in body){if(k=="m"){foreach(n,x in v)o.m[n]<-x;}else o[k]<-v;}
    o.setdelegate(getroottable());return o;
};
dofile(".cache/afei-art/native-contract-fixture/contracts_ambition.nut");
dofile(".cache/afei-art/native-contract-fixture/ambition_manager.nut");
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
dofile("src/scripts/mods/afeix/ideas_core.nut");
local events=clone ::event_manager;events.m=clone events.m;events.setdelegate(getroottable());
events.updateSpecialEvents=function(){return false;};events.m.LastEventTime=now;
events.fire=function(id){if(id!="event.ambition_fulfilled")throw "wrong event";fired++;return true;};
::World.Events <- events;
local ambition=::contracts_ambition;ambition.m.ContractsToComplete=8;ambition.m.UIText="Complete more contracts";
local manager=clone ::ambition_manager;manager.m=clone manager.m;manager.setdelegate(getroottable());
manager.m.ActiveAmbition=ambition;::World.Ambitions <- manager;
local dead=function(){yield false;throw "old isMoving exception";};
local broken=dead();resume broken;try{resume broken;}catch(e){}
check(broken.getstatus()=="dead","reproduce poisoned event generator");
events.m.Thread=broken;
local nativeUpdate=events.update;
local threw=false;try{events.update();manager.update();}catch(e){threw=true;}
check(threw&&manager.getCompleted()==0,"native event exception aborts frame before ambitions");
::mods_hookExactClass <- function(...){};::mods_hookBaseClass <- function(...){};
::mods_hookNewObject <- function(path,cb){if(path=="events/event_manager")cb(events);};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
events.update();manager.update();
check(events.m.Thread==null&&fired==0&&manager.m.ActiveAmbition==ambition,"repair generator without rewarding incomplete 7 of 8");
check(ambition.getUIText().find("7/8")!=null,"native counter unchanged");
finished=8;now+=26;blocked=true;manager.update();
check(fired==0,"keep screen safety checks");
blocked=false;now+=26;events.update();manager.update();
check(fired==1&&manager.getCompleted()==1&&manager.m.ActiveAmbition==null,"8 of 8 completes via native manager once");
events.update();manager.update();check(fired==1,"no duplicate completion on next frame");
local live=function(){yield false;yield false;};local pending=live();resume pending;
events.m.Thread=pending;events.update();
check(events.m.Thread==pending&&pending.getstatus()=="suspended","live event evaluation preserved");
origin=false;events.m.Thread=broken;threw=false;try{events.update();}catch(e){threw=true;}
check(threw&&events.m.Thread==broken,"other origin untouched");
origin=true;
local party=::World.State.getPlayer();::World.State.getPlayer=function(){return party;};
check(::AfeixExpedition.isWorldPartyMoving(),"movement uses native Destination without invented isMoving");
party.m.Destination=null;check(!::AfeixExpedition.isWorldPartyMoving(),"stopped party does not trigger road events");
print("TESTS_PASSED="+checks+"\n");
