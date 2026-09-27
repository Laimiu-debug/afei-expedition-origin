// Native 1.5.2.3 attribute order/ranges, from scripts/config/character.nut.
::Const.Attributes <- { COUNT=8, Hitpoints=0, Fatigue=1, Bravery=2, Initiative=3, MeleeSkill=4, RangedSkill=5, MeleeDefense=6, RangedDefense=7 };
::Const.XP <- { MaxLevelWithPerkpoints=11 };
::Const.AttributesLevelUp <- [{Min=2,Max=4},{Min=2,Max=4},{Min=2,Max=4},{Min=3,Max=5},{Min=1,Max=3},{Min=2,Max=4},{Min=1,Max=3},{Min=2,Max=4}];
::talentRng <- { calls=0, fail=false };
::Math <- { rand=function(lo,hi) {
    if (::talentRng.fail) { ::talentRng.fail=false; throw "injected roll failure"; }
    ::talentRng.calls++;
    return ::talentRng.calls % 2 == 0 ? lo : hi;
} };
function equalTalentData(a,b) {
    if (typeof a != typeof b) return false;
    if (typeof a != "array") return a == b;
    if (a.len()!=b.len()) return false;
    foreach(i,v in a) if (!equalTalentData(v,b[i])) return false;
    return true;
}
function addTalentFixture(actor, stars, count=10) {
    actor.m <- {Attributes=[],LevelUps=0};
    actor.talents <- array(8,0);
    foreach(field,value in stars) actor.talents[::Const.Attributes[field=="Stamina"?"Fatigue":field]]=value;
    for(local i=0;i<8;i++) actor.m.Attributes.push(array(count,::Const.AttributesLevelUp[i].Min));
    actor.getTalents <- function(){return this.talents;};
    actor.dirty <- 0;
    actor.failDirty <- false;
    actor.setDirty <- function(value){this.dirty++;if(this.failDirty){this.failDirty=false;throw "dirty failed";}};
    return actor;
}
