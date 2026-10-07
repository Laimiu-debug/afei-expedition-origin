// Native narrative/ending hooks and explicit UI bridge. Timing stays real
// while virtual battle time is frozen; only temporary dream actors can fall.
dofile("tests/gameplay/test_dream_flow.nut");
local baseline=::checks,A=::AfeixExpedition;
function launchTide(){
    resetDream();local A=::AfeixExpedition;A.initializeDreamOpening();A.set("dream_stage",3);
    check(A.startDreamCombat(3),"launch final dream tableau");::World.State.loading_screen_onScreenShown();
    ::dreamTest.round=6;::Tactical.State.onUpdate();return ::Tactical.State;
}
function starts(){local n=0;foreach(c in ::dreamTest.tideCalls)if(c.method=="afeixStartDreamTide")n++;return n;}
function frames(){local n=0;foreach(c in ::dreamTest.tideCalls)if(c.method=="afeixDreamTideFrame")n++;return n;}
function stops(){local n=0;foreach(c in ::dreamTest.tideCalls)if(c.method=="afeixStopDreamTide")n++;return n;}
local t=launchTide();
check(A.DreamSession.tide==null&&starts()==0&&::dreamTest.kills==0,"reading monologue has no tide or death");
t.onProcessAI();check(::dreamTest.nativeAIUpdates==0&&t.m.IsInputLocked,"reading freezes parallel AI and tactical input");
::dreamTest.realTime=30.0;t.onUpdate();t.onBattleEnded();
check(starts()==0&&::dreamTest.kills==0&&!A.DreamSession.exitStarted,"slow reading does not consume animation duration");
::DialogScreen.onOkPressed();local tide=A.DreamSession.tide;
check(starts()==1&&tide.StartedAt==30.0,"animation begins at native dialog close");
check(::dreamTest.tideCalls[0].data.SweepSeconds==2.4&&::dreamTest.tideCalls[0].data.Duration==4.6,"native bridge sends complete timeline to frontend");
check(::dreamTest.tideCalls[0].data.Direction=="right-to-left","native bridge selects right-to-left horizontal sweep");
check(::dreamTest.tideCalls[0].data.ViewportWidth==2560&&::dreamTest.tideCalls[0].data.ViewportHeight==1440,"native bridge sends physical video resolution instead of UI-scaled viewport");
check(::dreamTest.kills==0&&A.DreamSession.collapseStarted,"all actors remain visible when tide starts");
::dreamTest.realTime=32.39;t.onUpdate();
check(::dreamTest.kills==0&&frames()==1,"water crosses scene before first fall");
::dreamTest.video.Width=1920;::dreamTest.video.Height=1080;
local frozenVirtual=::dreamTest.virtualTime;::dreamTest.virtualTime+=10000.0;t.onUpdate();
check(::dreamTest.kills==0&&!A.DreamSession.exitStarted,"virtual time jump cannot skip water tableau");
check(frames()==1,"identical frame is not resent");
::dreamTest.virtualTime=frozenVirtual;::dreamTest.realTime=32.45;t.onUpdate();
check(::dreamTest.kills==1&&::dreamTest.killOrder[0]=="wangduidui","first actor falls only after water arrives");
local resizeFrame=::dreamTest.tideCalls[::dreamTest.tideCalls.len()-1].data;
check(resizeFrame.ViewportWidth==1920&&resizeFrame.ViewportHeight==1080,"native frame refreshes video size during the animation");
check(::dreamTest.nativeUpdates==0,"ending never advances native actor queue");
t.onProcessAI();check(::dreamTest.nativeAIUpdates==0,"tide freezes parallel AI as well as actor queue");
check(::dreamTest.turnBarClears==1,"native selection timer cleared once before animation");
for(local i=2;i<=10;i++){
    ::dreamTest.realTime=32.4+(i-1)*0.1+0.01;t.onUpdate();
    check(::dreamTest.kills==i,"each subsequent actor falls once on staggered timeline");
    check(!A.DreamSession.exitStarted,"falling actors do not trigger premature native exit");
}
check(::dreamTest.killOrder[9]=="afei","black flag captain is last to fall");
foreach(a in ::dreamTest.realActors)check(a.isAlive(),"real captain survives tableau "+a.key);
check(!A.collapseDreamTactical(t)&&starts()==1,"replayed dialog continuation cannot restart tide");
t.onBattleEnded();check(::dreamTest.kills==10&&starts()==1,"native death reentry does not restart ending");
::dreamTest.realTime=34.59;t.onUpdate();check(!A.DreamSession.exitStarted,"last fade frame precedes departure");
::dreamTest.realTime=34.61;t.onUpdate();check(A.DreamSession.exitStarted,"real-time duration triggers native loading exit");
local shown=::LoadingScreen.shown,nframes=frames();t.onUpdate();
check(::LoadingScreen.shown==shown&&frames()==nframes,"ending cannot queue repeated exits or post-exit frames");
::World.State.onReturnedFromTactical();
check(stops()==1,"world restoration tells native tactical UI to remove water layer");
t.onProcessAI();check(::dreamTest.nativeAIUpdates==1,"ordinary native AI forwarding resumes outside dream ending");
assertReality("tide tableau");

foreach(cause in ["retreat","skip","defeat","victory"]){
    resetDream();A.initializeDreamOpening();A.set("dream_stage",3);A.startDreamCombat(3);::World.State.loading_screen_onScreenShown();t=::Tactical.State;
    if(cause=="retreat")t.flee();else if(cause=="skip")t.main_menu_module_onQuitPressed();
    else {::Tactical.Entities.result=cause=="victory"?1:3;t.onBattleEnded();}
    check(starts()==0&&::dreamTest.kills==0,"alternate ending waits for reading "+cause);
    t.onKeyInput({getState=function(){return 0;},getKey=function(){return 41;}});
    check(starts()==1&&::dreamTest.kills==0,"Escape closes monologue and begins tide "+cause);
    ::dreamTest.realTime+=4.61;t.onUpdate();
    check(::dreamTest.kills==10&&A.DreamSession.exitStarted,"large real-time frame safely completes ending "+cause);
    ::World.State.onReturnedFromTactical();assertReality("tide "+cause);
}

t=launchTide();::DialogScreen.onOkPressed();tide=A.DreamSession.tide;
local current=::Tactical.State;::Tactical.State={};::dreamTest.realTime=1000.0;
check(!A.updateDreamTideAnimation(t)&&::dreamTest.kills==0,"old tableau cannot kill after tactical state replacement");
::Tactical.State=current;A.restoreDreamSession();
check(stops()==1&&A.DreamSession==null,"restoration cancels old UI without delayed actor work");

t=launchTide();t.m.TacticalScreen.m.JSHandle=null;::DialogScreen.onOkPressed();
::dreamTest.realTime+=4.61;t.onUpdate();
check(A.DreamSession.exitStarted&&::dreamTest.kills==10,"missing UI handle cannot hang dream restoration");
check(starts()==0,"missing UI handle never dereferenced");::World.State.onReturnedFromTactical();assertReality("missing UI");

// Observe the actual onFinish wrapper before the native state clears its UI.
local originalFinish=::tactical_state.onFinish;::finishedTideNative <- 0;
::tactical_state.onFinish=function(){++::finishedTideNative;};
t=launchTide();::DialogScreen.onOkPressed();::dreamTest.realTime+=1.0;t.onUpdate();t.onFinish();
check(stops()==1&&A.DreamSession.tide==null,"native state finish clears unfinished tide first");
check(::finishedTideNative==1&&::dreamTest.kills==0,"native finish still runs and does not force early deaths");
::dreamTest.realTime+=100.0;t.onUpdate();check(::dreamTest.kills==0,"finished tableau has no timer to fire later");
::tactical_state.onFinish=originalFinish;A.restoreDreamSession();

t=launchTide();local real=A.DreamSession.actors[0];real.alive=false;
local captain=::dreamTest.realActors[0];captain.getFlags <- function(){return {get=function(k){return false;}};};
A.DreamSession.actors.push(captain);::DialogScreen.onOkPressed();::dreamTest.realTime+=4.61;t.onUpdate();
check(::dreamTest.kills==9&&captain.isAlive(),"dead actors and non-dream actors are never killed by tableau");
::World.State.onReturnedFromTactical();assertReality("guarded actor queue");
A.DreamTideDirection="left-to-right";t=launchTide();::DialogScreen.onOkPressed();
check(::dreamTest.tideCalls[0].data.Direction=="left-to-right","opposite sweep direction reaches native frontend unchanged");
A.restoreDreamSession();A.DreamTideDirection="right-to-left";
print("TESTS_PASSED="+(::checks-baseline)+"\n");
