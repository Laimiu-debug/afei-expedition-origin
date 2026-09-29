// Generated personal classes + the installed native background lifecycle/save methods.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition, checks=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Const.SkillType.Background <- 32;::Const.SkillOrder.Background <- 0;
::Const.Bodies <- {AllMale=[],Skinny=[]};::Const.Strings <- {CharacterNames=[]};
::Const.Faces <- {AllMale=[]};::Const.Hair <- {UntidyMale=[],CommonMale=[]};
::Const.HairColors <- {All=[],Young=[]};::Const.Beards <- {Untidy=[],All=[]};
::Const.LevelXP <- [0,100];
::Math.pow <- function(a,b){return ::pow(a,b);};
::World <- {};
foreach(name in ["character_background","daytaler_background","militia_background","poacher_background","converted_cultist_background"]) {
    dofile(".cache/afei-art/native-contract-fixture/"+name+".nut");
    ::definitions["scripts/skills/backgrounds/"+name] <- getroottable()[name];
}
// Backgrounds share the Trait bit. Exercise the actual native UI query after
// fresh-character trait cleanup; a stale actor.m.Background pointer is not enough.
dofile(".cache/afei-art/native-contract-fixture/skill_container.nut");
local nativeNew=::new;
::new=function(path){
    foreach(key,d in ::AfeixExpedition.BalanceV26.traits)if(d.path==path){
        local s=nativeNew("scripts/skills/traits/character_trait");s.m.ID=d.id;
        s.onUpdate=function(p){foreach(i,field in ::AfeixExpedition.BalanceFields)p[field]+=d.delta[i];};
        return s;
    }
    return nativeNew(path);
};
function backgroundActor(key) {
    local a=makeActor(key);
    a.m <- {Background=null,XP=4321,Level=11,PerkPoints=3,LevelUps=2};
    a.baseProps.DailyWage <- 0;
    a.getTitle <- function(){return "unchanged";};a.setTitle <- function(t){throw "migration changed title";};
    a.getBackground <- function(){return this.m.Background;};
    a.skills.removeByID <- function(id){this.removeAllByID(id);};
    local add=a.skills.add;
    a.skills.add=function(s){s.m.Container=this;s.onAdded();s.m.IsNew=false;add.bindenv(this)(s);};
    a.skills.Const <- ::Const;a.skills.WeakTableRef <- ::WeakTableRef;
    a.skills.query <- ::skill_container.query;
    return a;
}
foreach(key in A.CharacterOrder) {
    local data=A.Characters[key];
    fresh();local bro=backgroundActor(key),nativePath="scripts/skills/backgrounds/"+data.background;
    local native=::new(nativePath), path="scripts/skills/backgrounds/"+A.characterBackgroundPath(key);
    local personal=::new(path);
    check(personal.getID()=="background.afeix_"+key,key+" stable personal ID");
    check(personal.getNameOnly()==A.CharacterBackgrounds[key].name,key+" personal name");
    check(personal.m.RawDescription.find(A.CharacterBackgrounds[key].description)!=null,key+" personal history");
    check(personal.m.RawDescription.find(data.description)!=null,key+" character story retained");
    local expected=native.onChangeAttributes(), actual=personal.onChangeAttributes();
    foreach(field,range in expected)check(actual[field][0]==range[0]&&actual[field][1]==range[1],key+" native attribute template "+field);
    check(personal.isLowborn()==native.isLowborn()&&personal.isNoble()==native.isNoble(),key+" native conversion eligibility");
    native.m.IsNew=false;native.m.DailyCostMult=1.17;native.m.Level=2;
    bro.skills.add(native);
    // Identity/progress are independent of the removable background object.
    local flags=bro.flags;flags.afeix_training_choice <- "kept";flags.afeix_story_progress <- 7;
    local props=bro.baseProps, items=bro.items;
    check(A.syncCharacterBackground(bro),key+" old template migrated");
    local bg=bro.getBackground();
    check(bg.getID()==personal.getID()&&bg.m.DailyCost==data.wage,key+" migrated class and wage");
    check(bg.m.DailyCostMult==1.17&&bg.m.Level==2,key+" multiplier and background level retained");
    check(bro.m.XP==4321&&bro.m.Level==11&&bro.m.PerkPoints==3&&bro.m.LevelUps==2,key+" earned progress unchanged");
    check(bro.baseProps==props&&bro.items==items&&bro.flags==flags&&flags.afeix_training_choice=="kept"&&flags.afeix_story_progress==7,key+" stats equipment and route flags retained");
    A.syncCharacterBackground(bro);check(bro.getBackground()==bg,key+" migration idempotent");
    local saved=roundtrip(bg,path);
    check(saved.getID()==bg.getID()&&saved.m.RawDescription==bg.m.RawDescription&&saved.m.DailyCostMult==bg.m.DailyCostMult,key+" native save layout roundtrip");
    // A conversion must keep its mechanical ID and personal story after restore.
    bro.skills.removeByID(bg.getID());local converted=::new("scripts/skills/backgrounds/converted_cultist_background");converted.m.IsNew=false;
    bro.skills.add(converted);converted.m.DailyCostMult=0.95;
    check(A.syncCharacterBackground(bro)&&bro.getBackground()==converted,key+" converted background never replaced");
    check(converted.getID()=="background.converted_cultist"&&converted.getNameOnly().find("已皈依")!=null,key+" native cultist recognition and display");
    check(converted.m.Description.find(A.CharacterBackgrounds[key].description)!=null&&converted.m.Description.find("达库尔")!=null,key+" conversion retains history");
    local text=converted.m.Description;A.syncCharacterBackground(bro);check(converted.m.Description==text&&converted.m.DailyCostMult==0.95,key+" conversion text does not accumulate");
    converted.m.ID="background.external";text=converted.m.Description;
    check(!A.syncCharacterBackground(bro)&&bro.getBackground()==converted&&converted.m.Description==text,key+" external replacement untouched");

    // Follow makeCharacter's order: background -> table stats -> fixed traits.
    local recruit=backgroundActor(key), starting=::new(path), p=A.BalanceV26.people[key];
    starting.m.IsNew=false;recruit.skills.add(starting);A.syncCharacterBackground(recruit);
    foreach(i,field in A.BalanceFields)recruit.baseProps[field]<-p.attrs[i];
    local randomTrait=::new("scripts/skills/traits/character_trait");randomTrait.m.ID="trait.random_fixture";recruit.skills.add(randomTrait);
    local personalTrait=::new("scripts/skills/traits/character_trait");personalTrait.m.ID="trait.afeix_fixture";recruit.skills.add(personalTrait);
    local description=starting.m.Description, icon=starting.getIcon();
    check(starting.getType()==(::Const.SkillType.Background|::Const.SkillType.Trait),key+" native combined background type");
    A.balanceTraits(recruit,true);recruit.skills.update();
    local visible=recruit.skills.query(::Const.SkillType.Background);
    check(visible.len()==1&&visible[0]==starting&&!starting.isGarbage(),key+" background survives trait cleanup and native UI query");
    check(starting.getIcon()==icon&&icon.len()>0,key+" background icon retained");
    check(starting.getNameOnly()==A.CharacterBackgrounds[key].name&&starting.m.Description==description,key+" background name and biography retained");
    check(recruit.getBackground()==starting&&starting.isLowborn()&&!starting.isNoble(),key+" live background and native conversion classification retained");
    check(recruit.props.DailyWage>0,key+" background wage callback remains active");
    check(!recruit.skills.hasSkill(randomTrait.getID())&&recruit.skills.hasSkill(personalTrait.getID()),key+" removes random trait but preserves personal trait");
    foreach(t in p.fixed_traits)check(recruit.skills.hasSkill(A.BalanceV26.traits[t].id),key+" applies fixed trait "+t);
    foreach(i,field in A.BalanceFields)check(recruit.props[field]==p.attrs[i],key+" keeps table attribute "+field);
    A.balanceTraits(recruit,true);recruit.skills.update();
    check(recruit.skills.query(::Const.SkillType.Background).len()==1,key+" repeated balance keeps one background");
    local restored=roundtrip(starting,path), loaded=backgroundActor(key);restored.m.IsNew=false;loaded.skills.add(restored);
    local savedVisible=loaded.skills.query(::Const.SkillType.Background);
    check(savedVisible.len()==1&&savedVisible[0].m.Description==description&&savedVisible[0].getIcon()==icon,key+" preserved background survives native serialization");
}
fresh();local ordinary=backgroundActor("ordinary");check(!A.syncCharacterBackground(ordinary),"ordinary recruits untouched");
local bro=backgroundActor("afei");::state.origin=false;check(!A.syncCharacterBackground(bro),"other origins untouched");
// Conversion event's build/appearance callbacks update display immediately.
::state.origin=true;
local converted=::new("scripts/skills/backgrounds/converted_cultist_background");converted.m.IsNew=false;bro.skills.add(converted);
local buildCalls=0,appearanceCalls=0,artCalls=0,suspended=false;
converted.buildDescription=function(final=false){buildCalls++;this.m.Name="Cultist";this.m.Description="native conversion";return final;};
converted.onSetAppearance=function(){if(!suspended)throw "native tattoo used a custom body brush";appearanceCalls++;return "native appearance";};
A.isArtCharacter=function(actor){return actor==bro;};A.hasPortraitArt=function(actor){return true;};
A.suspendCharacterArt=function(actor){suspended=true;};
A.syncCharacterArt=function(actor){if(actor==bro)artCalls++;};
::mods_hookExactClass <- function(path,callback){callback(converted);};
::mods_getMember <- function(o,k){return o[k];};::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/background_hooks.nut");
check(converted.buildDescription(true)&&buildCalls==1,"conversion retains original build dispatch");
check(converted.getNameOnly().find("已皈依")!=null&&converted.getID()=="background.converted_cultist","conversion immediately displays personal identity");
check(converted.onSetAppearance()=="native appearance"&&appearanceCalls==1&&artCalls==1,"conversion resynchronizes portrait after native appearance");
::state.origin=false;converted.buildDescription();check(converted.getNameOnly()=="Cultist","ordinary cultist text is untouched");
print("TESTS_PASSED="+checks+"\n");
