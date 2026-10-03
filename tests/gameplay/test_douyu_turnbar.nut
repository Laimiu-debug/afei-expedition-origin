// Exercise the installed native turn bar with a death inside onTurnStart.
// Only rendering/scheduled combat-check events are explicit engine seams.
::checks <- 0;
function check(ok, text) { if (!ok) throw "FAIL Douyu turn bar: " + text; ++::checks; }
::barTest <- { dream=true, origin=true, combat="", schedules=0, logs=[] };
::Math <- { min=function(a,b){return a<b?a:b;} };
::TimeUnit <- { Real=1 };
::Time <- { getRealTimeF=function(){return 1.0;}, scheduleEvent=function(...){++::barTest.schedules;} };
::logInfo <- function(t){::barTest.logs.push(t);};
::logDebug <- function(...){};
::AfeixExpedition <- { DreamSession={ending=false}, isDreamCombat=function(){return ::barTest.dream;}, isOrigin=function(){return ::barTest.origin;} };
::Tactical <- { State={getStrategicProperties=function(){return {CombatID=::barTest.combat};}} };
::inherit <- function(path, o){o.setdelegate(getroottable());return o;};
dofile(".cache/afei-art/dream-native/turn_sequence_bar.nut");
::barHook <- null;
::bar <- null;
::mods_hookExactClass <- function(path, callback){
    check(path=="ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar","installed native hook path");::barHook=callback;
};
dofile("src/scripts/mods/afeix/douyu_turnbar_hooks.nut");
function actor(id, die=false) {
    return {id=id,alive=true,placed=true,started=false,die=die,before=0,starts=0,resumes=0,ap=5,fatigue=37,
        getID=function(){return this.id;},isAlive=function(){return this.alive;},isDying=function(){return false;},isPlacedOnMap=function(){return this.placed;},
        isWaitActionSpent=function(){return false;},isTurnStarted=function(){return this.started;},
        onBeforeActivation=function(){++this.before;},onTurnResumed=function(){++this.resumes;},
        onTurnStart=function(){++this.starts;this.started=true;if(this.die){this.alive=false;this.placed=false;::bar.removeEntity(this);}}};
}
function setup() {
    ::barTest.dream=true;::barTest.origin=true;::barTest.combat="";::AfeixExpedition.DreamSession.ending=false;
    local b=clone ::turn_sequence_bar;b.setdelegate(getroottable());b.m=clone ::turn_sequence_bar.m;
    b.m.AllEntities=[];b.m.CurrentEntities=[];b.m.IsLocked=true;b.m.TurnPosition=0;
    b.uiCalls <- [];b.moves <- 0;
    b.m.JSHandle <- {call=function(name,data){::bar.uiCalls.push({name=name,data=data});},asyncCall=function(name,data){::bar.uiCalls.push({name=name,data=data});}};
    b.moveToEntity=function(...){++this.moves;};
    b.convertEntityToUIData=function(a,last=false){return {id=a.id,last=last};};
    ::barHook(b);::bar=b;return b;
}
local b=setup(),dead=actor(1,true),next=actor(2);b.m.AllEntities=[dead,next];b.m.CurrentEntities=[dead,next];
local data=b.onEntityEntersFirstSlot(1);
check(data.AfeixRemovedFirstSlot,"dead first slot returns scoped frontend marker");
check(dead.starts==1&&b.m.AllEntities.len()==1,"native turn-start death removes actor from all entities");
check(b.m.CurrentEntities.len()==1&&b.m.CurrentEntities[0]==next,"locked corpse removed from current entities");
check(next.before==1&&next.starts==0,"next actor prepared but not granted a turn during repair");
check(next.ap==5&&next.fatigue==37,"repair preserves native AP and fatigue");
check(b.m.TurnPosition==1&&b.m.IsLocked,"native frontend remains selection lock owner");
check(b.uiCalls.len()==3&&b.uiCalls[0].name=="afeixInvalidateFirstSlot"&&b.uiCalls[1].name=="clear"&&b.uiCalls[2].data.id==2,"pending callback and old selection timer invalidated before native UI reload");
data=b.onEntityEntersFirstSlot(2);check(data.id==2&&next.starts==1,"frontend can start the real next living actor");
b.onEntityEnteredFirstSlotFully(2);check(!b.m.IsLocked,"normal native completed callback unlocks progression");
check(next.ap==5&&next.fatigue==37,"callbacks do not reset spent AP or fatigue");

b=setup();next=actor(3);b.m.AllEntities=[next];b.m.CurrentEntities=[next];
data=b.onEntityEntersFirstSlot(3);check(data.id==3&&b.uiCalls.len()==0,"healthy dream selection unchanged");
b=setup();next=actor(4);next.started=true;b.m.AllEntities=[next];b.m.CurrentEntities=[next];
data=b.onEntityEntersFirstSlot(999);check(data.AfeixRemovedFirstSlot&&b.m.CurrentEntities[0]==next,"late stale request reloads existing living first slot");
check(next.before==0&&next.starts==0&&next.resumes==0,"late request does not repeat actor callbacks");

b=setup();::barTest.dream=false;::barTest.combat="afeix_douyu_final";dead=actor(5,true);next=actor(6);
b.m.AllEntities=[dead,next];b.m.CurrentEntities=[dead,next];data=b.onEntityEntersFirstSlot(5);
check(data.AfeixRemovedFirstSlot&&b.m.CurrentEntities[0]==next,"real Douyu fight uses same native recovery");
b=setup();::barTest.dream=false;::barTest.combat="ordinary";dead=actor(7,true);next=actor(8);
b.m.AllEntities=[dead,next];b.m.CurrentEntities=[dead,next];data=b.onEntityEntersFirstSlot(7);
check(data==null&&b.m.CurrentEntities[0]==dead&&b.uiCalls.len()==0,"ordinary encounters keep native behavior");
b=setup();::barTest.dream=false;::barTest.origin=false;::barTest.combat="afeix_douyu_final";
check(b.onEntityEntersFirstSlot(999)==null&&b.uiCalls.len()==0,"other origins keep native null behavior");

b=setup();dead=actor(9,true);next=actor(10);b.m.AllEntities=[dead,next];b.m.CurrentEntities=[dead];
data=b.onEntityEntersFirstSlot(9);check(data.AfeixRemovedFirstSlot&&!b.m.IsLocked&&b.m.IsInitNextRound&&b.m.CheckEnemyRetreat,"last current death schedules native next round");
check(next.ap==5&&next.fatigue==37,"scheduled next round has not reset actor stats early");
b=setup();dead=actor(11,true);b.m.AllEntities=[dead];b.m.CurrentEntities=[dead];local schedules=::barTest.schedules;
data=b.onEntityEntersFirstSlot(11);check(data.AfeixRemovedFirstSlot&&b.m.AllEntities.len()==0&&!b.m.IsLocked,"all dead releases lock");
check(::barTest.schedules==schedules+2,"native removal and recovery request native battle-ended checks");
b=setup();::AfeixExpedition.DreamSession.ending=true;data=b.onEntityEntersFirstSlot(999);
check(data.AfeixRemovedFirstSlot&&b.uiCalls.len()==0,"scripted tableau never restarts a turn or UI timer");
b=setup();next=actor(12);b.m.AllEntities=[next];b.m.CurrentEntities=[next];
::AfeixExpedition.DreamSession.ending=true;data=b.onEntityEntersFirstSlot(12);
check(data.AfeixRemovedFirstSlot&&next.starts==0,"ending rejects even a still-living first-slot request");
b.removeEntities();
check(b.m.AllEntities.len()==0&&b.uiCalls.len()==2&&b.uiCalls[0].name=="afeixInvalidateFirstSlot"&&b.uiCalls[1].name=="clear","dream ending invalidates pending native queries before clearing DOM");
b=setup();::barTest.dream=false;::barTest.combat="ordinary";b.removeEntities();
check(b.uiCalls.len()==1&&b.uiCalls[0].name=="clear","ordinary combat clearing keeps native behavior");
print("TESTS_PASSED="+::checks+"\n");
