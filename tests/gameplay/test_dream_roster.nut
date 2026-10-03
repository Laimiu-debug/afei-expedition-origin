// Production roster construction against synchronous native API stand-ins.
// Native combat, artwork and item inheritance require separate engine checks.
::checks <- 0;
function check(ok, text) { if (!ok) throw "Dream roster: " + text; ::checks++; }
::state <- { nextID=0, campaignRolls=0, rejectPath="", rejectEquip=false, giftedRows=0 };
::Const <- {
    Attributes={COUNT=8,Hitpoints=0,Fatigue=1,Bravery=2,Initiative=3,MeleeSkill=4,RangedSkill=5,MeleeDefense=6,RangedDefense=7},
    LevelXP=[0,200,500,1000,2000,3500,5500,8000,11000,14500,19000],
    AttributesLevelUp=[{Min=2,Max=4},{Min=2,Max=4},{Min=2,Max=4},{Min=3,Max=5},{Min=1,Max=3},{Min=2,Max=4},{Min=1,Max=3},{Min=2,Max=4}]
};
::Time <- {getVirtualTimeF=function(){return 23.0;}};
::campaignRand <- function(low, high) { ::state.campaignRolls++; return low; };
::Math <- {rand=::campaignRand};
::AfeixExpedition <- {Schema=2,TalentRevision=4,characterBackgroundPath=function(key){return "afeix_"+key+"_background";},isOrigin=function(){return true;}};
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/member_skills.nut");
dofile("src/scripts/mods/afeix/member_catalog_data.nut");
dofile("src/scripts/mods/afeix/balance_v26_data.nut");
dofile("src/scripts/mods/afeix/member_training.nut");
dofile("src/scripts/mods/afeix/dream_roster.nut");
local A=::AfeixExpedition;
A.characterId <- function(a){return a.getFlags().has("afeix_character")?a.getFlags().get("afeix_character"):"";};
A.syncCharacterArt <- function(actor){actor.artSynced=true;};

function flags() {
    return {values={},has=function(k){return k in this.values;},get=function(k){return this.values[k];},set=function(k,v){this.values[k]<-v;}};
}
function makeBrother() {
    local f=flags(), p={Hitpoints=0,Stamina=0,Bravery=0,Initiative=0,MeleeSkill=0,RangedSkill=0,MeleeDefense=0,RangedDefense=0}, talents=[];
    local skills={m={Skills=[]}, actor=null, hasSkill=function(id){foreach(s in this.m.Skills)if(s.m.ID==id)return true;return false;},
        getSkillByID=function(id){foreach(s in this.m.Skills)if(s.m.ID==id)return s;return null;},
        update=function(){},add=function(s){
            if(s.m.ID=="perk.gifted"&&!s.m.IsApplied){::state.giftedRows++;this.actor.m.LevelUps++;}
            if(s.m.ID=="perk.bags_and_belts")this.actor.getItems().capacity=4;
            this.m.Skills.push(s);
        }};
    local inventory={equipped=[],bag=[],capacity=2,clear=function(){this.equipped=[];this.bag=[];},
        equip=function(item){if(::state.rejectEquip)return false;this.equipped.push(item);return true;},
        addToBag=function(item){if(this.bag.len()>=this.capacity)return false;this.bag.push(item);return true;}};
    local actor={id=++::state.nextID,m={Level=1,XP=0,LevelUps=0,PerkPoints=0,PerkPointsSpent=0,Attributes=[],HireTime=0},name="",title="",place=255,hp=0,fatigue=0,artSynced=false,
        getID=function(){return this.id;},getFlags=function(){return f;},getBaseProperties=function(){return p;},getTalents=function(){return talents;},
        getSkills=function(){return skills;},getItems=function(){return inventory;},getLevel=function(){return this.m.Level;},
        getHitpointsMax=function(){return p.Hitpoints;},setHitpoints=function(n){this.hp=n;},setFatigue=function(n){this.fatigue=n;},
        setName=function(n){this.name=n;},setTitle=function(n){this.title=n;},setPlaceInFormation=function(n){this.place=n;},
        setStartValuesEx=function(backgrounds,traits){::Math.rand(1,100);this.m.Level=2;this.m.LevelUps=1;this.m.PerkPoints=1;check(!traits,"no native random trait generation");},
        onHired=function(){throw "Dream must not invoke native hiring";}};
    skills.actor=actor;
    return actor;
}
function roster() {
    return {actors=[],create=function(path){::Math.rand(0,9);local a=makeBrother();this.actors.push(a);return a;},
        getAll=function(){return this.actors;},remove=function(actor){local i=this.actors.find(actor);if(i!=null)this.actors.remove(i);}};
}
::realRoster <- roster();
::realBrother <- makeBrother();
::realBrother.m.XP=724;::realBrother.m.Level=3;::realBrother.fatigue=9;
::realRoster.actors.push(::realBrother);
::World <- {getPlayerRoster=function(){return ::realRoster;},
    Flags={values={afeix_ever_afei=true,afeix_afei_route="normal"},set=function(k,v){throw "Dream construction wrote real campaign flag";}},
    Assets={money=700,addMoney=function(n){throw "Dream construction spent real crowns";}}};
getroottable()["new"] <- function(path) {
    ::Math.rand(0,7);
    if(path==::state.rejectPath)throw "Injected constructor failure";
    local result={path=path,m={ID="",Name="",Condition=100,ConditionMax=100,StaminaModifier=0,IsDroppedAsLoot=true,IsApplied=false,GoldCost=20,Description=""},
        configure=function(key){local d=::AfeixExpedition.MemberSkillDefs[key];this.m.ID=(d.active?"actives.":"trait.")+"afeix_member_"+key;}};
    if(path.find("scripts/skills/perks/perk_")==0)result.m.ID="perk."+path.slice(26);
    if(path=="scripts/skills/actives/afeix_feidie")result.m.ID="actives.afeix_feidie";
    if(path=="scripts/skills/traits/afeix_promotion_trait")result.m.ID="trait.afeix_promotion";
    foreach(key,definition in ::AfeixExpedition.BalanceV26.traits)if(path==definition.path)result.m.ID=definition.id;
    return result;
};

local temporary=roster(), unrelated=makeBrother();temporary.actors.push(unrelated);
local actors=A.buildDreamRoster(temporary);
check(actors.len()==10&&temporary.actors.len()==11&&temporary.actors[0]==unrelated,"ten separate actors preserve unrelated temporary candidate");
check(::realRoster.actors.len()==1&&::realRoster.actors[0]==::realBrother&&::realBrother.m.XP==724&&::realBrother.fatigue==9,"real actor and roster unchanged");
check(::World.Flags.values.len()==2&&::World.Flags.values.afeix_afei_route=="normal"&&::World.Assets.money==700,"real flags route and money unchanged");
check(::state.campaignRolls==0&&::Math.rand==::campaignRand,"construction does not consume campaign RNG and restores function");
check(::state.giftedRows==0,"Gifted never grants a second unspent attribute row");
local slots={};
foreach(i,actor in actors) {
    local key=A.DreamRoster.order[i], d=A.DreamRoster.people[key], real=A.BalanceV26.people[key];
    check(actor.m.Level==11&&actor.m.XP==::Const.LevelXP[10]&&actor.m.LevelUps==0&&actor.m.PerkPoints==0&&actor.m.PerkPointsSpent==10&&actor.m.Attributes.len()==0,key+" real level11 accounting fully spent");
    check(actor.getFlags().get("afeix_dream_actor")&&actor.getFlags().get("afeix_character")==key&&actor.artSynced,key+" temporary identity and native portrait sync");
    check(!(actor.place in slots),key+" unique formation slot");slots[actor.place]<-true;
    local selections=array(8,0), gains=array(8,0), points=0;
    foreach(row in d.level_rows) {
        check(row.fields.len()==3&&row.gains.len()==3,key+" three selections per native level");
        local chosen={};
        foreach(j,index in row.fields) {
            check(!(index in chosen),key+" no duplicate field within a level");chosen[index]<-true;
            local field=A.DreamRoster.fields[index],star=field in d.stars?d.stars[field]:0,native=::Const.AttributesLevelUp[index];
            check(row.gains[j]>=native.Min+(star==3?2:star)&&row.gains[j]<=native.Max+(star==3?1:0),key+" actual talent bounds");
            selections[index]++;gains[index]+=row.gains[j];points++;
        }
    }
    check(points==30,key+" exactly30 normal selections");
    foreach(index,field in A.DreamRoster.fields) {
        check(selections[index]==d.allocation[index],key+" current build allocation "+field);
        check(actor.getBaseProperties()[field]==real.attrs[index]-d.trait_delta[index]+gains[index]+d.personal_bonus[index]+d.gifted_bonus[index],key+" base has native growth once and fixed trait delta removed "+field);
        check(actor.getBaseProperties()[field]>=-5&&actor.getBaseProperties()[field]<250,key+" finite attribute bounds "+field);
    }
    local perkCount=0,memberCount=0;
    foreach(skill in actor.getSkills().m.Skills) {
        if(skill.m.ID.find("perk.")==0)perkCount++;
        if(skill.m.ID.find("afeix_member_")!=null)memberCount++;
    }
    check(perkCount==10,key+" ten native perks");
    check(!actor.getSkills().hasSkill("trait.afeix_personal"),key+" world personal trait cannot double apply dream choice");
    if(d.training!="") {
        check(memberCount==1&&A.trainingRank(actor,d.training)==2,key+" exactly one mastered personal skill");
        foreach(skill in A.MemberSkills[key])if(skill!=d.training)check(A.trainingRank(actor,skill)==0,key+" unchosen skill stays unavailable "+skill);
    } else check(memberCount==0,key+" no member choice for captain promotion");
    if(key=="afei") {
        check(actor.getSkills().hasSkill("actives.afeix_feidie")&&!actor.getSkills().hasSkill("actives.afeix_wawa")&&!actor.getSkills().hasSkill("actives.afeix_haoqi"),"Afei only shows flying-disc route");
        check(actor.getSkills().getSkillByID("actives.afeix_feidie").m.GoldCost==0,"dream command does not spend real money");
    }
    local armorFatigue=0;
    foreach(item in actor.getItems().equipped) {
        check(!item.m.IsDroppedAsLoot,key+" equipment cannot leak into loot");
        if(item.path.find("armor/")!=null||item.path.find("helmets/")!=null)armorFatigue-=item.m.StaminaModifier;
    }
    check(d.heavy?armorFatigue==45:armorFatigue==13,key+" native armor matches heavy or Nimble plan");
    check(actor.getItems().bag.len()==d.bag.len(),key+" bags accepted with native slot capacity");
}
local badRoster=roster(),existing=makeBrother();badRoster.actors.push(existing);
::state.rejectPath="scripts/items/weapons/named/named_crossbow";
local threw=false;
try{A.buildDreamRoster(badRoster);}catch(error){threw=true;}
check(threw&&badRoster.actors.len()==1&&badRoster.actors[0]==existing,"constructor failure removes only all newly created dream actors");
check(::Math.rand==::campaignRand&&::state.campaignRolls==0,"constructor failure restores RNG without consuming it");
::state.rejectPath="";::state.rejectEquip=true;
threw=false;try{A.makeDreamCharacter("afei",badRoster);}catch(error){threw=true;}
check(threw&&badRoster.actors.len()==1&&::Math.rand==::campaignRand,"inventory rejection is atomic and restores RNG");
::state.rejectEquip=false;
threw=false;try{A.makeDreamCharacter("afei",::realRoster);}catch(error){threw=true;}
check(threw&&::realRoster.actors.len()==1,"reject construction in real player roster");
check(A.makeDreamCharacter("missing",temporary)==null&&A.makeDreamCharacter("afei",null)==null,"invalid roster inputs have no side effects");
local custom=A.makeDreamCharacter("afei",badRoster,8);check(custom.place==8,"caller can select a native formation slot");
local sequenceA=A.withDreamConstructionRandom(57,function(){local result=[];for(local i=0;i<20;i++)result.push(::Math.rand(1,100));return result;}),
    sequenceB=A.withDreamConstructionRandom(57,function(){local result=[];for(local i=0;i<20;i++)result.push(::Math.rand(1,100));return result;});
local unique={},same=true;
foreach(i,value in sequenceA){if(value!=sequenceB[i])same=false;unique[value]<-true;}
check(same&&unique.len()>10&&::state.campaignRolls==0,"bounded construction RNG is deterministic and changes enough for native rejection loops");
print("TESTS_PASSED="+::checks+"\n");
