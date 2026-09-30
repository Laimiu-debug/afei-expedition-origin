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
A.syncBalance=function(bro){}; // Dedicated base/trait migration suite.
A.syncMemberSkills=function(bro){}; // Exercised with native skill base in test_member_skills.nut.
A.syncPromotion=function(bro){};
A.syncCharacterArt=function(bro){};
A.syncIdeasCharacter=function(bro){}; // Intrinsic turtle mechanics have a dedicated suite.
function talentActor(key,stars,count=10) {
    // Starting-stat migration is covered by test_roster; isolate talent queue changes here.
    local flags={values={afeix_character=key,afeix_damou_balance_v17=true,afeix_balance_v18=true},has=function(k){return k in this.values;},get=function(k){return this.values[k];},set=function(k,v){this.values[k]<-v;}};
    return addTalentFixture({level=1,props={Hitpoints=83,MeleeSkill=77},hp=22,xp=999,gear=["mail"],perks=["gifted"],
        background={m={DailyCost=1,RawDescription="",Name="",BackgroundDescription="",Description=""},getID=function(){return "background.afeix_"+key;},buildDescription=function(_){}},
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
    local reduced=["yuchujiu","xiaoyubeike","yaoyaoya"].find(key)!=null;
    expect(total==(reduced?5:(key=="bottle"?9:6)),"correct star budget "+key);
    expect(reduced?(bro.talents[4]==2&&bro.talents[6]==1):(bro.talents[6]==3&&(key=="bottle"?bro.talents[4]==3:bro.talents[2]==2)),"reduced offense defense or retained specialist talents "+key);
    foreach(i,prior in before.talents) if(prior==bro.talents[i])
        expect(equalTalentData(before.attributes[i],bro.m.Attributes[i]),"unchanged attribute rolls preserved "+key);
    expect(bro.m.Attributes[6][0]>=(reduced?2:3) && bro.m.Attributes[6][0]<=(reduced?3:4),"next defense upgrade matches current stars "+key);
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
candidate.getFlags().set("afeix_candidate",true);candidate.getFlags().set("afeix_v26_quote",220);
A.recruitPrice=function(key){return 220;};
A.restoreCharacterMetadata(candidate);
expect(candidate.talents[4]==3 && candidate.m.HiringCost==220,"old town hire candidate migrates without recruitment");
foreach(key in ["bottle","chenzhihan",""]) {
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
// Saves that already applied revision 1 must downgrade nine stars too. Pending
// ordinary upgrades change; earned stats and queued veteran +1 entries survive.
foreach(key,third in {yuchujiu="Initiative",xiaoyubeike="Hitpoints",yaoyaoya="Stamina"}) {
    local nine={MeleeSkill=3,MeleeDefense=3};nine[third]<-3;
    local bro=talentActor(key,nine,5);bro.level=12;bro.m.LevelUps=3;
    bro.getFlags().set("afeix_talent_revision",1);
    foreach(row in bro.m.Attributes)foreach(i,v in row)row[i]=i<2?4:1;
    local before=A.captureTalentState(bro),props=clone bro.props;
    A.restoreCharacterMetadata(bro);
    expect(bro.getFlags().get("afeix_talent_revision")==A.TalentRevision,"revision one saves migrate again "+key);
    expect(bro.talents[4]==2&&bro.talents[6]==1&&bro.talents[::Const.Attributes[third=="Stamina"?"Fatigue":third]]==2,"nine to five stars "+key);
    foreach(i,row in bro.m.Attributes){
        if(before.talents[i]==bro.talents[i])expect(equalTalentData(before.attributes[i],row),"unchanged queue preserved "+key+" / "+i);
        else {
            local range=::Const.AttributesLevelUp[i];
            for(local j=0;j<2;j++)expect(row[j]>=range.Min+bro.talents[i]&&row[j]<=range.Max,"pending rolls use downgraded range "+key);
        }
        for(local j=2;j<row.len();j++)expect(row[j]==1,"veteran queue unaffected by downgrade "+key);
    }
    expect(bro.props.Hitpoints==props.Hitpoints&&bro.props.MeleeSkill==props.MeleeSkill&&bro.hp==22&&bro.xp==999&&bro.level==12&&bro.m.LevelUps==3,"downgrade keeps earned growth and health "+key);
    local stable=A.captureTalentState(bro),calls=::talentRng.calls;
    A.restoreCharacterMetadata(bro);
    expect(::talentRng.calls==calls&&equalTalentData(stable.attributes,bro.m.Attributes),"downgrade only rerolls once "+key);
}
// Revision bump must not reroll the unchanged nine-star/defensive specialists.
foreach(key in ["bottle","damou","laocai","dae","keke","xiaogui"]) {
    local bro=talentActor(key,A.Characters[key].stars),before=A.captureTalentState(bro),calls=::talentRng.calls;
    bro.getFlags().set("afeix_talent_revision",1);A.syncRosterTalents(bro);
    expect(::talentRng.calls==calls&&equalTalentData(before.attributes,bro.m.Attributes)&&equalTalentData(before.talents,bro.talents),"unchanged revision one profile never rerolls "+key);
}
print("TESTS_PASSED="+checks+"\n");
