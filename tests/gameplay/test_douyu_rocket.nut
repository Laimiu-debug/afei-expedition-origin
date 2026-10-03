// Hold real production callbacks at the camera/landing boundary. Native turn
// processing below verifies that no actor advances while the rocket falls.
dofile("tests/gameplay/douyu_combat_fixture.nut");
local D=::AfeixExpedition.Douyu;
function releaseRocket(a){a.ap=9;::state.round++;::AfeixExpedition.Douyu.startTurn(a);a.skills.update();}
function readyRocket(){
    reset();local b=boss(),t=actor("landing target",2);turn(b);
    check(special(b,"rocket").use(t.tile),"warning uses native costs");
    // Exclude the firing effect; the next events must be fall then impact.
    ::rocketFixture.impacts=[];::rocketFixture.now=0;
    return {b=b,t=t};
}
local pair=readyRocket(),b=pair.b,t=pair.t;
eq(::state.attacks.len(),0,"telegraph never damages immediately");
check(!D.hasRocketFlight(::Tactical.State),"warning does not freeze the response turn");
eq(b.ap,0,"warning spends nine AP");eq(b.fatigue,25,"warning spends native fatigue once");
releaseRocket(b);local tag=D.state(b).RocketFlight;
check(tag!=null&&D.hasRocketFlight(::Tactical.State),"mature warning starts flight");
eq(::rocketFixture.cameras.len(),1,"focus visible landing tile before animation");
check(::rocketFixture.cameras[0].tile==t.tile,"focus points to fixed warning center");
eq(::rocketFixture.particles.len(),0,"camera pending creates no offscreen fall");
eq(::rocketFixture.timers.len(),0,"flight duration begins after camera focus");
eq(::state.attacks.len(),0,"camera wait does not damage");
check(t.tile.Properties.IsMarkedForImpact,"warning persists during camera wait");
check(!special(b,"rocket").isUsable()&&!special(b,"mark").isUsable(),"specials gated during pending flight");
focusRocket();eq(::rocketFixture.particles.len(),1,"single falling rocket emitted");
local particle=::rocketFixture.particles[0],stage=particle.stages[0];
eq(particle.brushes[0],"afeix_douyu_rocket_falling","uses standalone rocket rather than UI icon");
eq(particle.quantity,1,"one projectile per seven-tile blast");eq(particle.total,1,"projectile does not respawn");
check(particle.tile==t.tile,"projectile lands on marked center");
eq(stage.DirectionMin.X,0,"no lateral scatter");eq(stage.DirectionMax.Y,-1,"falls toward ground");
eq(stage.RotationMin,0,"nose-down sprite not randomly rotated");eq(stage.RotationMax,0,"fixed orientation for every launch");
eq(stage.ScaleMin,1.0,"visible sprite keeps exported size");eq(stage.ScaleMax,1.0,"size does not randomly shrink");
eq(stage.ColorMin,"ffffffff","fully opaque particle");
eq(stage.SpawnOffsetMin.Y-stage.VelocityMin*stage.LifeTimeMin,0.0,"nose reaches ground at stage end");
eq(stage.SpawnOffsetMax.Y-stage.VelocityMax*stage.LifeTimeMax,0.0,"no lifetime or velocity jitter");
eq(stage.ForceMin.Y,0,"no acceleration separates landing from timer");
eq(::rocketFixture.timers[0].unit,::TimeUnit.Virtual,"animation uses tactical virtual time");
eq(::rocketFixture.timers[0].due,750,"landing scheduled after full fall");
eq(::rocketFixture.impacts.len(),0,"no explosion or impact sound before landing");
advanceRocket(749);eq(::state.attacks.len(),0,"no early damage at 749 ms");
check(t.tile.Properties.IsMarkedForImpact,"warning remains throughout fall");
eq(::rocketFixture.quakes,0,"no camera shake before landing");
advanceRocket(1);eq(::state.attacks.len(),1,"damage resolves on landing at 750 ms");
eq(::rocketFixture.impacts.len(),2,"impact sound and explosion resolve together");
foreach(e in ::rocketFixture.impacts)eq(e.at,750,"impact effect shares landing time");
eq(::rocketFixture.quakes,1,"landing shakes visible camera once");
check(!t.tile.Properties.IsMarkedForImpact&&!D.hasRocketFlight(::Tactical.State),"landing clears warning and action gate");
check(b.props.DamageReceivedTotalMult>1.34,"landing opens normal exposure window");
eq(b.ap,9,"animation does not spend next turn AP");eq(b.fatigue,25,"animation does not charge fatigue again");
check(!D.landRocket(tag)&&!D.launchRocket(tag),"repeated callbacks are harmless");
eq(::state.attacks.len(),1,"replayed callback never double damages");
eq(::rocketFixture.particles.len(),1,"replayed callback never creates extra rocket");

// Existing response options remain usable for a whole turn.
pair=readyRocket();b=pair.b;t=pair.t;D.interrupt(b,t,300,400);releaseRocket(b);finishRocket();
eq(::state.attacks.len(),0,"700 actual HP plus armor cancels before launch");
eq(::rocketFixture.particles.len(),0,"interrupted warning emits no projectile");
check(!D.hasRocketFlight(::Tactical.State),"interruption leaves actor processing free");
pair=readyRocket();b=pair.b;t=pair.t;t.tile.IsOccupiedByActor=false;releaseRocket(b);finishRocket();
eq(::state.attacks.len(),0,"moving out of fixed warning still evades damage");
eq(::rocketFixture.particles.len(),1,"empty center still gets visible rocket");
pair=readyRocket();b=pair.b;t=pair.t;
local allies=[];for(local i=0;i<6;i++)allies.push(actor("surrounding "+i,3+i));t.neighbors=allies;
D.clearWarning(b);D.beginArea(b,t.tile,"rocket");releaseRocket(b);focusRocket();
eq(::state.attacks.len(),0,"all seven tiles wait for landing");advanceRocket(750);
eq(::state.attacks.len(),7,"landing preserves seven-tile blast coverage");
eq(::rocketFixture.particles.len(),1,"seven-tile blast still has one central rocket");
pair=readyRocket();b=pair.b;t=pair.t;D.beginMark(b,t);releaseRocket(b);focusRocket();
check(t.skills.hasSkill("effects.afeix_douyu_mark"),"combo mark persists through fall");advanceRocket(750);
eq(::state.attacks.len(),1,"combo does not add a second hit on landing");
check(!t.skills.hasSkill("effects.afeix_douyu_mark"),"landing consumes combo warning");

// Native callbacks may race with ending/death; do not retain delayed damage.
foreach(launch in [false,true]){
    pair=readyRocket();b=pair.b;t=pair.t;D.beginMark(b,t);releaseRocket(b);
    if(launch)focusRocket();
    b.alive=false;b.placed=false;b.skills.getSkillByID("effects.afeix_douyu_core").onDeath(0);
    finishRocket();eq(::state.attacks.len(),0,"boss death cancels camera or landing callback");
    check(!D.hasRocketFlight(::Tactical.State)&&D.state(b).RocketFlight==null,"death releases action gate");
    check(!t.tile.Properties.IsMarkedForImpact&&!t.skills.hasSkill("effects.afeix_douyu_mark"),"death removes both ground and combo warnings");
}
foreach(launch in [false,true]){
    pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);if(launch)focusRocket();
    D.cancelRocketFlights(::Tactical.State);finishRocket();
    eq(::state.attacks.len(),0,"battle exit cancels either callback stage");
    check(!D.hasRocketFlight(::Tactical.State)&&!t.tile.Properties.IsMarkedForImpact,"battle exit clears gate and markers");
}
pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);focusRocket();
::AfeixExpedition.DreamSession={ending=true};advanceRocket(750);
eq(::state.attacks.len(),0,"dream ending rejects delayed impact");
check(!D.hasRocketFlight(::Tactical.State)&&D.state(b).RocketFlight==null,"rejected dream callback releases action gate");
check(!t.tile.Properties.IsMarkedForImpact,"rejected dream callback clears markers");
::AfeixExpedition.DreamSession=null;
pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);focusRocket();
::state.tactical=false;advanceRocket(750);
eq(::state.attacks.len(),0,"inactive tactical scene rejects damage");
check(!D.hasRocketFlight(::Tactical.State),"inactive scene releases action gate");
pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);focusRocket();tag=D.state(b).RocketFlight;
local oldScene=::Tactical.State;
::Tactical.State={getStrategicProperties=function(){return {CombatID="unrelated"};}};
fresh();local newBoss=boss();newBoss.id=tag.ActorID;local newTarget=actor("new battle target",2);
advanceRocket(750);eq(::state.attacks.len(),0,"new battle reusing actor ID receives no old damage");
check(D.state(newBoss).RocketFlight==null,"old callback does not touch new boss state");
check(!D.hasRocketFlight(oldScene)&&!D.hasRocketFlight(::Tactical.State),"stale scene callback removed from flight registry");
::Tactical.State=oldScene;

pair=readyRocket();b=pair.b;t=pair.t;t.tile.IsVisibleForPlayer=false;releaseRocket(b);
eq(::rocketFixture.cameras.len(),0,"hidden landing does not reveal camera location");
eq(::rocketFixture.particles.len(),0,"hidden landing has no visible rocket");
advanceRocket(750);eq(::state.attacks.len(),1,"hidden area preserves normal damage timing");
eq(::rocketFixture.quakes,0,"hidden landing does not shake camera");
pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);
local schedule=::Time.scheduleEvent;
::Time.scheduleEvent=function(...){throw "injected scheduler failure";};
local caught=false;try{focusRocket();}catch(error){caught=true;}
::Time.scheduleEvent=schedule;
check(caught&&!D.hasRocketFlight(::Tactical.State),"scheduler failure cannot leave permanent action freeze");
check(D.state(b).RocketFlight==null&&!t.tile.Properties.IsMarkedForImpact,"failed animation scheduling clears warning state");

// Use the installed game's actual turn/parallel-AI methods with the production
// hook. Only teardown/UI/agent engine edges are stand-ins.
::definitions["scripts/states/state"] <- {m={}};
::Const.Combat.MiasmaTimeout <- 1;::Const.Combat.FireTimeout <- 1;::Const.Combat.SmokeTimeout <- 1;
dofile(".cache/afei-art/native-contract-fixture/tactical_state.nut");
::Const.AI.ParallelizationMode <- false;
::Tactical.Entities.isCombatFinished <- function(){return false;};
::nativeRocket <- {active=null,updates=0,thinks=0,next=0,locked=false,ends=0,finishes=0};
::Tactical.TurnSequenceBar <- {getActiveEntity=function(){return ::nativeRocket.active;},initNextTurn=function(){::nativeRocket.next++;}};
::tactical_state.setInputLocked=function(value){::nativeRocket.locked=value;};
::tactical_state.onBattleEnded=function(){::nativeRocket.ends++;};
::tactical_state.onFinish=function(){::nativeRocket.finishes++;};
::mods_hookExactClass <- function(path,callback){eq(path,"states/tactical_state","hook targets tactical state only");callback(::tactical_state);};
dofile("src/scripts/mods/afeix/douyu_rocket_hooks.nut");
local scene=clone ::tactical_state;scene.m=clone ::tactical_state.m;scene.setdelegate(getroottable());
::Tactical.State=scene;pair=readyRocket();b=pair.b;t=pair.t;
b.controlled=false;b.onUpdate <- function(){::nativeRocket.updates++;};
b.getAIAgent <- function(){return {isEvaluating=function(){return true;},isFinished=function(){return false;},think=function(...){::nativeRocket.thinks++;}};};
::nativeRocket.active=b;releaseRocket(b);
::nativeFrames <- {camera=0,particles=0};
::Tactical.CameraDirector.update <- function(){::nativeFrames.camera++;};
::Tactical.TurnSequenceBar.update <- function(){};
::Tactical.getCamera=function(){return {update=function(){},quake=function(...){::rocketFixture.quakes++;}};};
::Tactical.update <- function(){::nativeFrames.particles++;};
scene.updateScene <- function(){};scene.updateOrientationOverlays=function(){};scene.updateCameraScrolling=function(){};
scene.m.Factions={update=function(){}};
scene.onUpdate();
eq(::nativeFrames.camera,1,"native frame still advances camera while actors wait");
eq(::nativeFrames.particles,1,"native frame still advances particles while actors wait");
scene.updateCurrentEntity();scene.onProcessAI();
eq(::nativeRocket.updates,0,"pending camera prevents native actor update");
eq(::nativeRocket.thinks,0,"pending camera prevents serial and parallel AI");
check(::nativeRocket.locked,"input stays locked during fall");
local otherScene=clone scene;otherScene.m=clone scene.m;
otherScene.updateCurrentEntity();eq(::nativeRocket.updates,1,"flight gate does not freeze another tactical state");
::nativeRocket.updates=0;::nativeRocket.thinks=0;
focusRocket();advanceRocket(749);scene.updateCurrentEntity();scene.onProcessAI();
eq(::nativeRocket.thinks,0,"native AI remains blocked for whole flight");
advanceRocket(1);scene.updateCurrentEntity();scene.onProcessAI();
eq(::nativeRocket.updates,1,"native actor update resumes after impact");
eq(::nativeRocket.thinks,2,"native serial and parallel AI resume after impact");
foreach(method in ["onBattleEnded","onFinish"]){
    pair=readyRocket();b=pair.b;t=pair.t;releaseRocket(b);focusRocket();scene[method]();finishRocket();
    eq(::state.attacks.len(),0,"native lifecycle hook cancels pending landing");
    check(!D.hasRocketFlight(scene)&&!t.tile.Properties.IsMarkedForImpact,"native lifecycle clears gate and warning");
}
eq(::nativeRocket.ends,1,"native battle-end method still runs once");
eq(::nativeRocket.finishes,1,"native finish method still runs once");
::nativeRocket.active=null;scene.updateCurrentEntity();
eq(::nativeRocket.next,1,"ordinary empty actor queue advances normally");
print("TESTS_PASSED="+::checks+"\n");
