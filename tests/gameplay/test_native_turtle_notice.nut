// Native tactical state layout and popup/pause/menu methods. Engine drawing
// and frame work are simulated; the state deliberately has no root delegate.
local checks=0;
local expect=function(ok,label){if(!ok)throw "FAIL native turtle notice: "+label;checks++;};
::inherit <- function(path,child){return child;};
::Const <- {UI={Cursor={Hand=0}},Combat={MiasmaTimeout=3,FireTimeout=3,SmokeTimeout=3}};
::Cursor <- {setCursor=function(value){}};
::Time <- {speed=1.0,setVirtualSpeed=function(value){this.speed=value;}};
::Tactical <- {active=true,isActive=function(){return this.active;},
    Entities={actors=[],getAllInstances=function(){return [this.actors];},isCombatFinished=function(){return false;}}};
::AfeixExpedition <- {isOrigin=function(){return true;},characterId=function(actor){return actor.key;},
    turtleFlag=function(actor,key,fallback=0){return key in actor.flags?actor.flags[key]:fallback;},
    setTurtleFlag=function(actor,key,value){actor.flags[key]<-value;}};
dofile("src/scripts/mods/afeix/turtle_secret.nut");
dofile(".cache/afei-art/native-contract-fixture/tactical_state.nut");
dofile(".cache/afei-art/native-contract-fixture/menu_stack.nut");
local S=::tactical_state,M=::menu_stack,A=::AfeixExpedition;
M.create();M.setEnviroment(S);S.m.MenuStack=M;
S.isInLoadingScreen <- function(){return false;};
S.m.IsBattleEnded=false;S.setPause(false);
S.m.TacticalScreen={visible=true,show=function(){this.visible=true;},hide=function(){this.visible=false;}};
local modal={visible=false,animating=false,shows=0,
    isVisible=function(){return this.visible;},isAnimating=function(){return this.animating;},
    show=function(title,text,hidden,ok,cancel){this.visible=true;this.shows++;},
    hide=function(){this.visible=false;this.animating=true;}};
::DialogScreen <- modal;
expect(!("DialogScreen" in S),"native state does not own the global dialog");

// The production wrapper must reach native frame work even with no turtle
// or pending notice. This used to throw on every frame immediately on combat.
local nativeFrames=0;
S.onUpdate=function(){nativeFrames++;return "frame completed";};
::mods_hookExactClass <- function(path,callback){if(path=="states/tactical_state")callback(S);};
::mods_hookNewObject <- function(...){};::mods_hookBaseClass <- function(...){};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
for(local i=0;i<10;i++)expect(S.onUpdate()=="frame completed","combat update continues without a pending notice");
expect(nativeFrames==10&&M.m.Stack.len()==0&&!S.isPaused(),"no popup or pause inserted at combat entry");
::DialogScreen=null;
expect(S.onUpdate()=="frame completed","uninitialized global screen does not block native update");
::DialogScreen=modal;
S.m.TacticalDialogScreen={isVisible=function(){return false;},isAnimating=function(){return false;}};
local turtle={key="xiaogui",flags={afeix_turtle_notice=1},getFlags=function(){return {
    owner=this,has=function(key){return key in this.owner.flags;},
    get=function(key){return this.owner.flags[key];},set=function(key,value){this.owner.flags[key]<-value;}};}};
::Tactical.Entities.actors=[turtle];
modal.visible=true;
expect(!A.showTurtleAwakeningNotice(S)&&A.turtleFlag(turtle,"notice")==1,"busy global dialog preserves pending notice");
modal.visible=false;
expect(A.showTurtleAwakeningNotice(S)&&modal.shows==1,"native popup opens using the global dialog");
expect(S.isPaused()&&S.m.IsAIPaused&&::Time.speed==0.0,"popup pauses native time and AI");
expect(M.m.Stack.len()==1&&A.turtleFlag(turtle,"notice")==0&&!S.m.TacticalScreen.visible,"native popup installs one backstep and clears notice");
expect(!A.showTurtleAwakeningNotice(S)&&modal.shows==1,"open notice is not repeated");
M.pop();
expect(!A.showTurtleAwakeningNotice(S)&&S.isPaused(),"close animation retains pause");
modal.animating=false;
expect(!A.showTurtleAwakeningNotice(S)&&!S.isPaused()&&!S.m.IsAIPaused&&::Time.speed==1.0,
    "finished native close restores time and AI");
expect(S.m.TacticalScreen.visible&&M.m.Stack.len()==0,"tactical UI restored after notice");
foreach(pair in [[true,false],[false,true],[true,true]]) {
    S.setPause(pair[0]);S.m.IsAIPaused=pair[1];A.setTurtleFlag(turtle,"notice",2);
    expect(A.showTurtleAwakeningNotice(S),"notice opens over existing pause configuration");
    M.pop();modal.animating=false;A.showTurtleAwakeningNotice(S);
    expect(S.isPaused()==pair[0]&&S.m.IsAIPaused==pair[1],"previous manual game and AI pauses restored independently");
}
print("TESTS_PASSED="+checks+"\n");
