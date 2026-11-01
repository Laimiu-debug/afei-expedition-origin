// Real native skill.use/range/AP/fatigue with isolated engine geometry and hit
// resolution. This verifies the warnings/counters and production AI lifecycle;
// it does not certify engine rendering or live twelve-person balance.
dofile("tests/gameplay/member_skill_fixture.nut");
dofile("src/scripts/mods/afeix/douyu_combat.nut");
dofile("src/scripts/mods/afeix/douyu_rocket.nut");
dofile("tests/gameplay/douyu_rocket_fixture.nut");
::Const.MoraleState.Ignore <- 99;
::Const.Injury.CuttingAndPiercingBody <- []; ::Const.Injury.CuttingAndPiercingHead <- [];
::Const.Tactical.DetailFlag <- {SpecialOverlay=16,Corpse=8};
::Const.AI <- {Behavior={ID={AttackSpecial=2,AttackDefault=1,Idle=0,EngageMelee=3,BreakFree=4},Order={AttackSpecial=2}}};
::Tactical.State <- {getStrategicProperties=function(){return {CombatID=::combatID};}};
::combatID <- "afeix_douyu_final";
::logs <- [];
::Tactical.EventLog <- {log=function(text){::logs.push(text);}};
::checks <- 0;
function check(ok,label){if(!ok)throw "FAIL douyu: "+label;::checks++;}
function eq(a,b,label){check(a==b,label+" expected="+b+" actual="+a);}
function fixActor(a) {
    a.baseProps.MeleeSkillMult <- 1.0; a.baseProps.RangedSkillMult <- 1.0;
    a.baseProps.IsAffectedByLosingHitpoints <- true; a.baseProps.IsAffectedByDyingAllies <- true;
    a.baseProps.IsAffectedByFreshInjuries <- true; a.baseProps.IsImmuneToStun <- false;
    a.baseProps.IsImmuneToDisarm <- false;
    a.tile.Properties <- {IsMarkedForImpact=false}; a.tile.decals <- []; a.tile.clears <- 0;
    a.tile.spawnDetail <- function(brush,flag,flip,force=false){this.decals.push(brush);return {};};
    a.tile.clear <- function(flag){this.clears++;this.decals=[];};
    a.getSkills().removeByID <- a.getSkills().removeAllByID;
    a.moraleChecks <- 0;
    a.checkMorale <- function(...) {this.moraleChecks++;return true;};
    a.neighbors = [];
    return a;
}
function actor(key,pos=0,faction=1) {return fixActor(makeActor(key,pos,faction));}
function boss() {
    local a=actor("douyu",0,2); a.hp=4800;
    a.getHitpointsMax=function(){return 4800;}; a.fatigueMax=400;
    foreach(path in ["effects/afeix_douyu_core_effect","actives/afeix_douyu_bite_skill","actives/afeix_douyu_mark_skill","actives/afeix_douyu_barrage_skill","actives/afeix_douyu_rocket_skill"])
        a.skills.add(::new("scripts/skills/"+path));
    foreach(skill in a.skills.m.Skills) skill.attackEntity=function(user,target,diversion=true) {
        local p=user.getSkills().buildPropertiesForUse(this,target);
        ::state.attacks.push({source=user.id,target=target.id,kind=this.getID(),min=p.DamageRegularMin,max=p.DamageRegularMax});
        return true;
    };
    return a;
}
function turn(a) {a.ap=9;::state.round++;::AfeixExpedition.Douyu.startTurn(a);finishRocket();a.skills.update();}
function special(a,key){return a.skills.getSkillByID("actives.afeix_douyu_"+key);}
function reset(){resetRocketFixture();fresh();::logs=[];::state.tactical=true;}
