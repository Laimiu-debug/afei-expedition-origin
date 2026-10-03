// Exercise the installed game's complete damage method, including armor and
// injury selection. Only rendering, audio, morale and engine entities are stubbed.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,checks=0;
local check=function(ok,label){++checks;if(!ok)throw "FAIL native turtle head hit: "+label;};
local savedInherit=::inherit;
::Const.BloodType <- {None=0};::Const.MoraleState.Confident <- 5;
::Const.DefaultMovementAPCost <- [];::Const.DefaultMovementFatigueCost <- [];
::Const.Movement <- {LevelDifferenceActionPointCost=0,LevelDifferenceFatigueCost=0};
::Const.Tactical.MovementType <- {Default=0};::Const.ShakeCharacterLayers <- [];
::Const.MoraleCheckType.Default <- 0;
::Const.FatalityType <- {None=0};
::createColor <- function(v){return v;};
::inherit=function(path,child){return child;};
dofile(".cache/afei-art/native-contract-fixture/actor.nut");
local nativeDamage=::actor.onDamageReceived;
::inherit=savedInherit;
::Const.MoraleState.Ignore <- 9;
::Const.Combat.InjuryMinDamage <- 1;
::Const.Combat.InjuryThresholdMult <- 1.0;
::Const.Combat.ArmorDirectDamageMitigationMult <- 0.1;
::Const.Combat.SpawnBloodMinDamage <- 9999;
::Const.Combat.SpawnBloodEffectMinDamage <- 9999;
::Const.Combat.PlayPainSoundMinDamage <- 9999;
::Const.Sound <- {ActorEvent={DamageReceived=0},Volume={ActorArmorHit=0}};
::Const.UI <- {getColorizedEntityName=function(a){return a.key;}};
::Tactical.State <- {getStrategicProperties=function(){return null;}};
::Tactical.EventLog <- {logEx=function(text){}};
local roll=26,rolls=0;
::Math.rand=function(a,b){++rolls;return a==1&&b==100?roll:a;};
local hooks={},baseHooks={};
::mods_hookExactClass <- function(path,cb){hooks[path]<-cb;};
::mods_hookBaseClass <- function(path,cb){baseHooks[path]<-cb;};
::mods_hookNewObject <- function(...){};
::mods_getMember <- function(o,k){return o[k];};
::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
function target(key="xiaogui",protected=true) {
    local a=makeActor(key);a.setdelegate(getroottable());
    a.m <- {Hitpoints=200,Fatigue=0,MoraleState=9,IsAbleToDie=true,IsFlashingOnHit=false,Sound=[[]],ExcludedInjuries=[]};
    a.getHitpoints=function(){return this.m.Hitpoints;};a.getHitpointsMax=function(){return 200;};
    a.getFatigueMax=function(){return 200;};a.getFaction=function(){return 9;};
    a.isHiddenToPlayer=function(){return true;};a.isPlayerControlled=function(){return false;};
    a.onUpdateInjuryLayer <- function(){};a.setDirty <- function(v){};
    a.onTurnStart <- function(){};a.onOtherActorDeath <- function(...){};
    a.getCurrentProperties=function(){return this.m.CurrentProperties;};
    local p=properties();
    foreach(k,v in {IsImmuneToCriticals=false,IsImmuneToHeadshots=false,DamageReceivedRangedMult=1.0,
        DamageReceivedMeleeMult=1.0,DamageRegularReduction=0.0,DamageArmorReduction=0.0,
        DamageReceivedArmorMult=1.0,DamageReceivedDirectMult=1.0,FatigueReceivedPerHitMult=1.0,
        FatigueLossOnAnyAttackMult=1.0,Armor=[95.0,0.0],ArmorMult=[1.0,1.0],
        IsAffectedByInjuries=true,ThresholdToReceiveInjuryMult=1.0,IsAffectedByLosingHitpoints=false})p[k]<-v;
    p.getClone <- function(){return clone this;};
    a.m.BaseProperties <- clone p;a.m.CurrentProperties <- p;a.m.Skills <- a.skills;a.m.Items <- a.items;
    a.skills.buildPropertiesForBeingHit <- function(attacker,skill,hit){
        local result=this.actor.m.CurrentProperties.getClone();
        foreach(s in this.m.Skills)s.onBeforeDamageReceived(attacker,skill,hit,result);
        return result;
    };
    a.skills.onDamageReceived <- function(...){};a.skills.onAfterDamageReceived <- function(){};
    a.skills.update=function(){};
    a.skills.add=function(s){s.m.Container<-this;this.m.Skills.push(s);};
    a.items.onBeforeDamageReceived <- function(...){};
    a.items.onDamageReceived <- function(amount,fatality,slot,attacker){this.actor.lastArmorSlot<-slot;};
    if(protected){a.skills.add(::new("scripts/skills/traits/afeix_turtle_retract"));a.skills.add(::new("scripts/skills/traits/afeix_turtle_body"));}
    a.onDamageReceived=nativeDamage;hooks["entity/tactical/actor"](a);
    return a;
}
local headInjuries=[{ID="injury.split_ear",Script="test_head",Threshold=0.01}];
local bodyInjuries=[{ID="injury.deep_cut",Script="test_body",Threshold=0.01}];
local skill={m={IsWeaponSkill=true,InjuriesOnBody=bodyInjuries},isAttack=function(){return true;},isRanged=function(){return false;}};
local realNew=::new;
::new=function(path){
    if(path.find("scripts/skills/test_")==0)return {getID=function(){return this.id;},id=path,
        isValid=function(a){return true;},isGarbage=function(){return false;},m={},onBeforeDamageReceived=function(...) {}};
    return realNew(path);
};
function hit(part=1,direct=0.0){return {BodyPart=part,BodyDamageMult=part==1?2.0:1.0,
    DamageRegular=60.0,DamageArmor=80.0,DamageDirect=direct,DamageFatigue=4,DamageMinimum=0,
    InjuryThresholdMult=1.0,Injuries=part==1?headInjuries:bodyInjuries,IsPlayingArmorSound=false,
    DamageInflictedHitpoints=0,DamageInflictedArmor=0};}
fresh();local turtle=target(),info=hit();roll=25;
check(turtle.onDamageReceived(null,skill,info)==0&&turtle.getHitpoints()==200
    &&turtle.m.BaseProperties.Armor[0]==95&&turtle.m.Fatigue==0,"immune hit consumes no HP armor or fatigue");
check(info.DamageInflictedHitpoints==0&&info.DamageInflictedArmor==0&&turtle.skills.m.Skills.len()==2,"immune hit cannot apply ear injury");
roll=26;info=hit();local count=rolls;turtle.onDamageReceived(null,skill,info);
check(rolls==count+1,"one immunity roll per armored head hit");
check(info.BodyPart==0&&info.BodyDamageMult==1.0&&info.Injuries==bodyInjuries,"head multiplier and injury table become body values");
check(info.DamageInflictedHitpoints==0&&info.DamageInflictedArmor==64&&turtle.m.BaseProperties.Armor[0]==31,
    "redirected blow spends real body armor with20 percent shell reduction");
check(turtle.m.BaseProperties.Armor[1]==0,"helmet armor remains unchanged");
local reference=target();info=hit(0);reference.onDamageReceived(null,skill,info);
check(reference.m.BaseProperties.Armor[0]==turtle.m.BaseProperties.Armor[0]&&reference.getHitpoints()==turtle.getHitpoints(),
    "redirect equals native ordinary body damage");
info=hit();turtle.onDamageReceived(null,skill,info);
check(turtle.lastArmorSlot==::Const.ItemSlot.Body,"body item slot receives overflow damage");
local penetrated=target();info=hit(1,1.0);penetrated.onDamageReceived(null,skill,info);
check(info.DamageInflictedHitpoints==48&&penetrated.getHitpoints()==152,"armor piercing keeps native body HP formula");
check(penetrated.skills.hasSkill("scripts/skills/test_body")&&!penetrated.skills.hasSkill("scripts/skills/test_head"),
    "heavy redirected hit may inflict body injury but never ear injury");
local ordinary=target("ordinary",false);info=hit(1,1.0);count=rolls;ordinary.onDamageReceived(null,skill,info);
check(info.BodyPart==1&&info.DamageInflictedHitpoints==120&&ordinary.skills.hasSkill("scripts/skills/test_head"),"other members retain native critical head hit");
local noTrait=target("xiaogui",false);info=hit(1,1.0);noTrait.onDamageReceived(null,skill,info);
check(info.DamageInflictedHitpoints==120,"requires visible retract trait");
::state.origin=false;ordinary=target();info=hit(1,1.0);ordinary.onDamageReceived(null,skill,info);
check(info.DamageInflictedHitpoints==120,"other origins excluded");::state.origin=true;
// The native scheduled hit supplies its exact already-built body multiplier.
local scheduled={onScheduledTargetHit=function(i){return i.TargetEntity.onDamageReceived(null,skill,hit(1,1.0));}};
baseHooks["skills/skill"](scheduled);turtle=target();count=rolls;
scheduled.onScheduledTargetHit({TargetEntity=turtle,Properties={DamageAgainstMult=[1.25,2.0]}});
check(turtle.getHitpoints()==140&&rolls==count+2,"snapshot body damage bonus used without rebuilding attacker properties");
check(!("afeixTurtleBodyHitMult" in turtle.m),"snapshot field cleared after hit");
local failing={onScheduledTargetHit=function(i){throw "injected";}};baseHooks["skills/skill"](failing);
turtle.m.afeixTurtleBodyHitMult<-1.7;local failed=false;
try{failing.onScheduledTargetHit({TargetEntity=turtle,Properties={DamageAgainstMult=[1.25,2.0]}});}catch(e){failed=true;}
check(failed&&turtle.m.afeixTurtleBodyHitMult==1.7,"nested snapshot restored on native exception");
print("TESTS_PASSED="+checks+"\n");
