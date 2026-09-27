// Exercise actual preload, metadata restore, native queue semantics and migration.
::Const <- {};
dofile("tests/gameplay/talent_fixture.nut");
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){};
::mods_queue <- function(...){};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition, checks=0;
local expect=function(v,label){checks++;if(!v)throw "FAIL "+label;};
::talentOrigin <- true;
A.isOrigin=function(){return ::talentOrigin;};
A.syncPersonalGrowth=function(bro){};
A.syncMemberSkills=function(bro){}; // Exercised with native skill base in test_member_skills.nut.
A.syncPromotion=function(bro){};
A.syncCharacterArt=function(bro){};
function talentActor(key,stars,count=10) {
    local flags={values={afeix_character=key},has=function(k){return k in this.values;},get=function(k){return this.values[k];},set=function(k,v){this.values[k]<-v;}};
    return addTalentFixture({level=1,props={Hitpoints=83,MeleeSkill=77},hp=22,xp=999,gear=["mail"],perks=["gifted"],
        background={m={DailyCost=1,RawDescription=""},buildDescription=function(_){}},
        getFlags=function(){return flags;},getLevel=function(){return this.level;},
        getBackground=function(){return this.background;},getSkills=function(){return {update=function(){}};}
    },stars,count);
}
local old={
    bottle={MeleeSkill=1,Bravery=2},yuchujiu={Initiative=2,RangedDefense=1},xiaoyubeike={Hitpoints=2,Stamina=1},yaoyaoya={MeleeSkill=1,Stamina=2},
    damou={MeleeSkill=1,MeleeDefense=1},laocai={MeleeSkill=1,Bravery=1,MeleeDefense=1},dae={Hitpoints=1,MeleeDefense=2},
    keke={RangedSkill=1,MeleeDefense=1,Bravery=1},xiaogui={RangedDefense=2,Stamina=1}
};
foreach(key,profile in old) {
    local bro=talentActor(key,profile), before=A.captureTalentState(bro), props=bro.props, gear=bro.gear;
    A.restoreCharacterMetadata(bro);
    local total=0;
    foreach(field,stars in A.Characters[key].stars) {
        total+=stars;
        expect(bro.talents[::Const.Attributes[field=="Stamina"?"Fatigue":field]]==stars,"metadata restore applies "+key+" / "+field);
    }
    local core=["bottle","yuchujiu","xiaoyubeike","yaoyaoya"].find(key)!=null;
    expect(total==(core?9:6),"correct star budget "+key);
    expect(bro.talents[6]==3 && (core?bro.talents[4]==3:bro.talents[2]==2),"core or shield essential talents "+key);
    foreach(i,prior in before.talents) if(prior==bro.talents[i])
        expect(equalTalentData(before.attributes[i],bro.m.Attributes[i]),"unchanged attribute rolls preserved "+key);
    expect(bro.m.Attributes[6][0]>=3 && bro.m.Attributes[6][0]<=4,"next actual defense upgrade has three-star value "+key);
    expect(bro.props==props && bro.props.Hitpoints==83 && bro.props.MeleeSkill==77 && bro.hp==22 && bro.xp==999 && bro.gear==gear && bro.perks[0]=="gifted","no earned points or possessions reset "+key);
    local snapshot=A.captureTalentState(bro), rolls=::talentRng.calls;
    A.restoreCharacterMetadata(bro); A.syncRosterTalents(bro);
    expect(::talentRng.calls==rolls && equalTalentData(snapshot.attributes,bro.m.Attributes),"repeated load cannot reroll "+key);
}
foreach(key in A.CharacterOrder) if(!(key in old)) {
    local bro=talentActor(key,A.Characters[key].stars), before=A.captureTalentState(bro), rolls=::talentRng.calls;
    A.restoreCharacterMetadata(bro);
    expect(equalTalentData(before.talents,bro.talents) && equalTalentData(before.attributes,bro.m.Attributes) && ::talentRng.calls==rolls,"other members including normal Afei untouched "+key);
}
local candidate=talentActor("bottle",old.bottle);
candidate.getFlags().set("afeix_candidate",true);
A.recruitPrice=function(key){return 220;};
A.restoreCharacterMetadata(candidate);
expect(candidate.talents[4]==3 && candidate.m.HiringCost==220,"old town hire candidate migrates without recruitment");
foreach(key in ["bottle","yanzi",""]) {
    local bro=talentActor(key,{MeleeSkill=1}), before=A.captureTalentState(bro);
    ::talentOrigin=false; A.syncRosterTalents(bro); ::talentOrigin=true;
    if(key!="bottle") A.syncRosterTalents(bro);
    expect(equalTalentData(before.talents,bro.talents) && equalTalentData(before.attributes,bro.m.Attributes),"other origins retired and ordinary actors unchanged "+key);
}
local pending=talentActor("bottle",old.bottle,5);pending.level=12;pending.m.LevelUps=3;
foreach(row in pending.m.Attributes) foreach(i,v in row) row[i]=1;
A.syncRosterTalents(pending);
expect(pending.m.Attributes[4][0]>=3 && pending.m.Attributes[4][1]>=3,"pending ordinary upgrades receive new talents");
expect(pending.m.Attributes[4][2]==1 && pending.m.Attributes[4][4]==1 && pending.m.LevelUps==3,"queued veteran values and unspent count preserved");
local veteran=talentActor("bottle",old.bottle,1);veteran.level=14;
foreach(row in veteran.m.Attributes)row[0]=1;
local rolls=::talentRng.calls;A.syncRosterTalents(veteran);
expect(veteran.talents[4]==3 && veteran.m.Attributes[4][0]==1 && ::talentRng.calls==rolls,"veteran stars change without boosted veteran rolls");
local empty=talentActor("bottle",old.bottle,0);empty.level=11;A.syncRosterTalents(empty);
expect(empty.m.Attributes[4].len()==0,"exhausted ordinary queue is not replenished");
foreach(failure in ["roll","dirty"]) {
    local bro=talentActor("bottle",old.bottle), before=A.captureTalentState(bro), threw=false;
    if(failure=="roll")::talentRng.fail=true;else bro.failDirty=true;
    try{A.syncRosterTalents(bro);}catch(e){threw=true;}
    expect(threw && equalTalentData(before.talents,bro.talents) && equalTalentData(before.attributes,bro.m.Attributes) && !bro.getFlags().has("afeix_talent_revision"),"migration failure is atomic "+failure);
    A.syncRosterTalents(bro);expect(bro.talents[4]==3,"failed migration is retryable "+failure);
}
print("TESTS_PASSED="+checks+"\n");
