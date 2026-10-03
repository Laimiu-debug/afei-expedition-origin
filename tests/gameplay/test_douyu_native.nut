// Real native WeakTableRef and skill_container test the callback/collection
// boundaries that a lightweight skill list cannot reproduce.
dofile("tests/gameplay/member_skill_fixture.nut");
dofile(".cache/afei-art/native-contract-fixture/weak_table_ref.nut");
dofile(".cache/afei-art/native-contract-fixture/skill_container.nut");
dofile("src/scripts/mods/afeix/douyu_combat.nut");
::Const.MoraleState.Ignore <- 99;
::Const.Injury.CuttingAndPiercingBody <- []; ::Const.Injury.CuttingAndPiercingHead <- [];
::Const.Tactical.DetailFlag <- {SpecialOverlay=16};
::Tactical.EventLog <- {log=function(text){}};
::Tactical.spawnIconEffect <- function(...){};
::Const.Tactical.Settings <- {SkillIconOffsetX=0,SkillIconOffsetY=0,SkillIconScale=1.0,
    SkillIconFadeInDuration=0,SkillIconStayDuration=0,SkillIconFadeOutDuration=0,SkillIconMovement=null};
::isKindOf <- function(a,kind){return typeof a=="table" && kind=="skill" && "getContainer" in a;};
::checks <- 0;
function check(ok,text){if(!ok)throw "FAIL native douyu: "+text;::checks++;}
function nativeActor(name,pos=0,faction=1) {
    local a=makeActor(name,pos,faction);
    a.baseProps.MeleeSkillMult <- 1.0; a.baseProps.RangedSkillMult <- 1.0;
    a.baseProps.IsImmuneToStun <- false; a.baseProps.IsImmuneToDisarm <- false;
    a.baseProps.IsAffectedByLosingHitpoints <- true; a.baseProps.IsAffectedByDyingAllies <- true;
    a.baseProps.IsAffectedByFreshInjuries <- true;
    // Mirror native CharacterProperties rather than the broad companion fixture.
    delete a.baseProps.IsImmuneToFearAndPanic;
    a.baseProps.getClone <- function(){return clone this;};
    a.baseProps.getMeleeSkill <- function(){return this.MeleeSkill;};
    a.setCurrentProperties <- function(p){this.props=p;};
    a.getHitpointsPct <- function(){return this.hp/100.0;};
    a.setHitpointsPct <- function(p){this.hp=p*100.0;};
    a.getActionPointsMax <- function(){return 9;};
    a.onSkillsUpdated <- function(){}; a.updateOverlay <- function(){};
    a.isAlliedWithPlayer <- function(){return this.faction==1;};
    a.tile.Properties <- {IsMarkedForImpact=false};
    a.tile.spawnDetail <- function(...){return {};}; a.tile.clear <- function(...){};
    a.checkMorale <- function(...){return true;};
    local c=clone ::skill_container;c.setdelegate(getroottable());c.m=clone ::skill_container.m;
    c.m.Skills=[];c.m.SkillsToAdd=[];c.setActor(a);a.skills=c;
    return a;
}
::state.tactical=true;
local b=nativeActor("douyu",0,2),t=nativeActor("ranged",2),D=::AfeixExpedition.Douyu;
foreach(path in ["effects/afeix_douyu_core_effect","actives/afeix_douyu_mark_skill","actives/afeix_douyu_rocket_skill"])
    b.skills.add(::new("scripts/skills/"+path));
local core=b.skills.getSkillByID("effects.afeix_douyu_core"),rocket=b.skills.getSkillByID("actives.afeix_douyu_rocket");
check(!("getSkills" in b.skills.getActor()),"native wrapper does not support table membership");
check(D.state(b.skills.getActor())==core.m,"core state resolves through native wrapper");
check(b.props.IsImmuneToFearAndPanic,"boss defines missing native mental-target compatibility property");
check(!::AfeixExpedition.memberMentalTarget(b.skills.getActor()),"production origin mental targeting safely rejects boss through native reference");
local properties=b.skills.buildPropertiesForUse(rocket,::WeakTableRef(t));
check(properties.DamageRegularMin==90&&properties.DamageRegularMax==120,"native properties dispatches rocket damage hook");
check(properties.DamageArmorMult==1.1,"native properties dispatches rocket armor damage");
b.skills.onTurnStart();check(core.m.Turn==1,"native container dispatches one boss turn");
check(rocket.use(t.tile),"native container rocket use succeeds");
check(core.m.Charging&&t.tile.Properties.IsMarkedForImpact,"native container keeps warning between turns");
// Container sets IsUpdating=true around callbacks: interrupt/update must defer.
b.skills.onDamageReceived(::WeakTableRef(t),0,160);
check(!core.m.Charging&&core.m.BlastTiles.len()==0,"native damage callback interrupts and clears warning");
check(!b.skills.m.IsUpdating,"native callback releases update lock");
check(b.props.DamageReceivedTotalMult>1.34,"deferred update applies exposed multiplier");
::state.round++;b.ap=9;b.skills.onTurnStart();
check(core.m.Turn==2&&b.props.DamageReceivedTotalMult==1.0,"exposure expires through native turn update");
check(b.skills.getSkillByID("actives.afeix_douyu_mark").use(t.tile),"native mark use succeeds");
local mark=t.skills.getSkillByID("effects.afeix_douyu_mark");
check(mark!=null&&!mark.getContainer().isNull(),"native target mark has valid weak container");
D.removeMark(b.skills.getActor());
check(t.skills.getSkillByID("effects.afeix_douyu_mark")==null,"native mark removal collects status");
check(mark.getContainer().isNull(),"collected mark safely detaches from target");
core.m.SpecialTurn=-1;core.m.ExposedUntil=0;core.m.NextRocket=0;b.ap=9;
check(rocket.use(t.tile),"rearmed rocket queues second warning");
D.beginMark(b,t);check(t.skills.hasSkill("effects.afeix_douyu_mark"),"combo mark present before death");
b.skills.onDeath(0);
check(core.m.BlastTiles.len()==0&&!t.tile.Properties.IsMarkedForImpact,"native death cleans ground warnings");
check(core.m.MarkID==0&&!t.skills.hasSkill("effects.afeix_douyu_mark"),"native death cleans surviving target warning");
check(!b.skills.m.IsUpdating&&!t.skills.m.IsUpdating,"death callbacks leave both native containers unlocked");
print("TESTS_PASSED="+::checks+"\n");
