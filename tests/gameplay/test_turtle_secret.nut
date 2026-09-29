dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,checks=0;
local check=function(ok,label){++checks;if(!ok)throw "FAIL turtle secret: "+label;};
::Const.MoraleState.Confident <- 5;
::Tactical.Entities.getAllInstances <- function(){return [::state.actors];};
::Tactical.EventLog <- {log=function(text){}};
function secretActor(key,faction=1){
    local a=makeActor(key,0,faction);
    a.allied <- faction==1;
    a.isAlliedWithPlayer <- function(){return this.allied;};
    a.setHitpoints <- function(v){this.hp=v;};
    a.setDirty <- function(v){};
    a.baseProps.Hitpoints <- 100;
    a.baseProps.Stamina <- 100;
    a.baseProps.InitiativeMult <- 1.0;
    a.getHitpointsMax=function(){return this.props.Hitpoints;};
    local update=a.skills.update;
    a.skills.update=function(){
        foreach(s in clone this.m.Skills)if(s.isGarbage())s.onRemoved();
        update.bindenv(this)();
    };
    a.skills.update();return a;
}
fresh();local afei=secretActor("afei"),turtle=secretActor("xiaogui"),enemy=secretActor("enemy",2);
::state.origin=false;check(!A.tryTurtleAwakening(),"other origins excluded");::state.origin=true;
::state.tactical=false;check(!A.tryTurtleAwakening(),"world map excluded");::state.tactical=true;
local third=secretActor("third");check(!A.tryTurtleAwakening(),"third brother blocks");
third.placed=false;local dog=secretActor("dog");check(!A.tryTurtleAwakening(),"living dog blocks");dog.dying=true;
local npc=secretActor("ally_npc",3);npc.allied=true;check(!A.tryTurtleAwakening(),"allied other-faction soldier blocks");npc.alive=false;
enemy.alive=false;check(!A.tryTurtleAwakening(),"no enemies no awakening");enemy.alive=true;
foreach(actor in [afei,turtle]){
    actor.alive=false;check(!A.tryTurtleAwakening(),"dead required actor excluded");actor.alive=true;
    actor.dying=true;check(!A.tryTurtleAwakening(),"dying required actor excluded");actor.dying=false;
    actor.placed=false;check(!A.tryTurtleAwakening(),"off-map required actor excluded");actor.placed=true;
}
turtle.hp=4;turtle.fatigue=80;turtle.morale=0;
check(A.tryTurtleAwakening(),"last allied pair awaken with reserves/dead/dying excluded");
check(turtle.hp==500 && turtle.props.Hitpoints==500,"expanded life fully filled");
check(turtle.fatigue==0 && turtle.props.Stamina==220,"fatigue relief and capacity");
check(turtle.props.MeleeDefense==110 && turtle.props.RangedDefense==108,"both defenses raised");
check(turtle.props.MeleeSkill==120 && turtle.props.RangedSkill==90,"both attack stats raised");
check(turtle.props.Bravery==150 && turtle.morale==5,"rescue courage");
check(turtle.props.Initiative==20 && turtle.props.MeleeDamageMult==1.5,"slow but stronger attacks");
check(turtle.props.FatigueRecoveryRate==25,"endurance recovery");
local props=turtle.props;
turtle.hp=360;turtle.fatigue=30;
check(!A.tryTurtleAwakening() && turtle.hp==360 && turtle.fatigue==30,"cannot repeat free recovery");
turtle.skills.update();check(turtle.props.Hitpoints==500 && turtle.props.MeleeDefense==110,"updates never stack");
local e=turtle.skills.getSkillByID("effects.afeix_turtle_awakening");
local restored=roundtrip(e,"scripts/skills/effects/afeix_turtle_awakening");
local memory=roundtrip(A.catalogMemory(turtle),"scripts/skills/special/afeix_combat_memory");
check(restored.m.NormalHitpointsMax==100 && memory.m.State.turtle_awakened==1,"combat save preserves cleanup cap and single activation");
e.m.Container=null; // Replace deserialized objects without simulating removal.
turtle.skills.m.Skills=[];turtle.skills.add(restored);turtle.skills.add(memory);
check(!A.tryTurtleAwakening() && turtle.hp==360,"combat load cannot refill again");
foreach(s in clone turtle.skills.m.Skills)s.onCombatFinished();turtle.skills.update();
check(turtle.props.Hitpoints==100 && turtle.hp==100,"battle finish removes bonus and clamps expanded health");
check(turtle.props.MeleeDefense==10 && turtle.props.Initiative==100,"battle finish restores ordinary stats");
check(!turtle.skills.hasSkill("effects.afeix_turtle_awakening"),"temporary effect removed");
// Each route may qualify in a later fresh battle.
foreach(route in ["","toad","jiahao","feidie"]){
    fresh();afei=secretActor("afei");turtle=secretActor("xiaogui");enemy=secretActor("enemy",2);A.set("route",route);
    check(A.tryTurtleAwakening(),"not gated on captain promotion");
}
// Real actor hooks must invoke detection, including before the first enemy turn.
local hooks={};
::mods_hookExactClass <- function(path,cb){hooks[path]<-cb;};
::mods_hookBaseClass <- function(...){};::mods_hookNewObject <- function(...){};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
local order=[];
A.ideaBattleTurn=function(){};
local wrapper={onTurnStart=function(){order.push("native_turn");},onDamageReceived=function(...) {},onOtherActorDeath=function(...) {order.push("native_death");}};
hooks["entity/tactical/actor"](wrapper);
local real=A.tryTurtleAwakening;A.tryTurtleAwakening=function(){order.push("detect");return false;};
wrapper.onTurnStart();check(order[0]=="detect" && order[1]=="native_turn","before enemy action");
order=[];wrapper.onOtherActorDeath(null,null,null);check(order[0]=="native_death" && order[1]=="detect","death callback detects immediately");
A.tryTurtleAwakening=real;
print("TESTS_PASSED="+checks+"\n");
