// Run the installed ordinary conversion event against every current personal background.
// Engine rendering/text substitution is stubbed; eligibility and conversion callbacks are native.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,checks=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Const.SkillType.Background <- 32;::Const.SkillOrder.Background <- 0;
::Const.Bodies <- {AllMale=[],Skinny=[]};::Const.Faces <- {AllMale=[]};
::Const.Hair <- {UntidyMale=[],CommonMale=[]};::Const.HairColors <- {All=[],Young=[]};::Const.Beards <- {Untidy=[],All=[]};
::Const.Strings <- {CharacterNames=["test"],KnightNames=["test"],SouthernNames=["test"],VizierTitles=["test"]};
::Const.LevelXP <- [0,100];::Const.UI <- {Color={PositiveEventValue="green"}};
::Math.pow <- function(a,b){return ::pow(a,b);};
::buildTextFromTemplate <- function(text,vars){return text;};
::conversionRoster <- [];::conversionOrigin <- "scenario.afeix_expedition";
::World <- {
 getPlayerRoster=function(){return {getAll=function(){return ::conversionRoster;}};},
 getTime=function(){return {SecondsPerDay=86400};},
 EntityManager={getSettlements=function(){return [{human=false,getNameOnly=function(){return "test town";}}];}},
 State={getCurrentTown=function(){return null;}},
 Assets={getOrigin=function(){return {getID=function(){return ::conversionOrigin;}};},getName=function(){return "test company";}}
};
foreach(name in ["character_background","daytaler_background","militia_background","poacher_background","converted_cultist_background"]){
 dofile(".cache/afei-art/native-contract-fixture/"+name+".nut");::definitions["scripts/skills/backgrounds/"+name]<-getroottable()[name];
}
dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");
dofile("dlc/xiwen-regen/src/scripts/skills/backgrounds/afeix_xiwen_background.nut");
::definitions["scripts/skills/backgrounds/afeix_xiwen_background"]<-::afeix_xiwen_background;
local hooks={};::mods_hookExactClass <- function(path,fn){hooks[path]<-fn;};
::mods_getMember <- function(o,k){return o[k];};::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/background_hooks.nut");
local factory=getroottable()["new"];
getroottable()["new"]=function(path){local o=factory(path);if(path=="scripts/skills/backgrounds/converted_cultist_background")hooks["skills/backgrounds/converted_cultist_background"](o);return o;};
// The event's scoring method needs no base-event scheduler. Keep the native method intact.
local inheritOriginal=::inherit;::inherit=function(path,data){return data;};
dofile(".cache/afei-art/native-contract-fixture/cultist_vs_uneducated_event.nut");::inherit=inheritOriginal;
local event=clone ::cultist_vs_uneducated_event;event.setdelegate(getroottable());event.m=clone event.m;
foreach(k,v in {Screens=[],Score=0,ID="",Title="",Cooldown=0})event.m[k]<-v;
event.create();
local score=function(roster){::conversionRoster=roster;event.m.Score=0;event.m.Cultist=null;event.m.Uneducated=null;event.onUpdateScore();return event.m.Score;};
function conversionActor(key){
 local a=makeActor(key);a.m<-{Background=null,XP=15000,Level=11,PerkPoints=2,LevelUps=0};a.level=11;
 a.baseProps.DailyWage<-0;a.baseProps.Hitpoints<-100;a.baseProps.Stamina<-120;
 a.flags.get=function(k){return k in this.values?this.values[k]:false;};a.flags.set("afeix_character",key);
 a.getTitle<-function(){return "title";};a.setTitle<-function(t){throw "conversion replaced title";};
 a.getNameOnly<-function(){return this.key;};a.getImagePath<-function(){return "test portrait";};
 a.getBackground<-function(){return this.m.Background;};a.setDirty<-function(v){};
 a.getSprite<-function(name){return {HasBrush=true};};
 a.traits<-{};
 if(key in ::AfeixExpedition.BalanceV26.people)foreach(t in ::AfeixExpedition.BalanceV26.people[key].fixed_traits)a.traits["trait."+t]<-true;
 local has=a.skills.hasSkill;a.skills.hasSkill=function(id){return id in this.actor.traits||has.bindenv(this)(id);};
 a.skills.removeByID<-function(id){this.removeAllByID(id);};
 local add=a.skills.add;a.skills.add=function(s){s.m.Container=this;s.onAdded();add.bindenv(this)(s);};
 return a;
}
local preacher=conversionActor("ordinary_cultist");local cb=::new("scripts/skills/backgrounds/converted_cultist_background");cb.m.IsNew=false;preacher.skills.add(cb);
local filler1=conversionActor("protected1"),filler2=conversionActor("protected2");
filler1.flags.set("IsSpecial",true);filler2.flags.set("IsSpecial",true);
// The native event skips these protected actors before asking for a background.
local eligible=[],blocked=[],subjects=[];
foreach(key in A.CharacterOrder){
 local bro=conversionActor(key),bg=::new("scripts/skills/backgrounds/"+A.characterBackgroundPath(key));bg.m.IsNew=false;bro.skills.add(bg);
 subjects.push(bro);
 check(bg.isLowborn()&&!bg.isNoble(),key+" inherits lowborn template");
 local bright=A.BalanceV26.people[key].fixed_traits.find("bright")!=null;
 check((score([preacher,bro,filler1,filler2])>0)==!bright,key+" actual event eligibility matches fixed traits");
 if(bright)blocked.push(key);else {eligible.push(key);check(event.m.Uneducated==bro,key+" selected as conversion target");}
 bro.traits["injury.brain_damage"]<-true;
 check(score([preacher,bro,filler1,filler2])>0,key+" native brain-damage alternative");
 bro.flags.set("IsPlayerCharacter",true);check(score([preacher,bro,filler1,filler2])==0,key+" player-character flag excludes even brain damage");
 bro.flags.set("IsPlayerCharacter",false);bro.flags.set("IsSpecial",true);check(score([preacher,bro,filler1,filler2])==0,key+" special flag excludes conversion");
 bro.flags.set("IsSpecial",false);delete bro.traits["injury.brain_damage"];
}
check(eligible.len()==30&&blocked.len()==5,"35 current members: 30 eligible, five Bright blocked");
check(score(subjects)==0,"current named roster contains no conversion preacher");
local bro=subjects[1]; // Wang Damou has no Bright trait; captain status alone is not native protection.
check(score([preacher,bro,filler1])==0,"ordinary event requires at least four roster members");
::conversionOrigin="scenario.cultists";check(score([preacher,bro,filler1,filler2])==0,"cultist origin uses a different event");::conversionOrigin="scenario.afeix_expedition";
local bright=subjects[0];bright.traits["trait.dumb"]<-true;check(score([preacher,bright,filler1,filler2])>0,"non-noble Dumb alternative uses native OR semantics");delete bright.traits["trait.dumb"];
check(score([preacher,bro,filler1,filler2])==5&&event.m.Uneducated==bro,"single preacher gives weight five, not a guaranteed trigger");
check(event.m.Cooldown==30*86400,"native thirty-day event cooldown");
// Execute the accepted screen, including native background.onAdded and real Mod hooks.
local oldProps=clone bro.baseProps,oldItems=bro.items,oldTraits=bro.traits,oldFlags=bro.flags;
bro.flags.set("afeix_training_choice","quail_alarm");bro.flags.set("afeix_story_progress",7);
local oldBravery=preacher.baseProps.Bravery;
local artRestored=0,artSuspended=0;A.isArtCharacter=function(a){return a==bro;};A.hasPortraitArt=function(a){return true;};
A.suspendCharacterArt=function(a){artSuspended++;};A.syncCharacterArt=function(a){artRestored++;};
local screen=event.m.Screens[1];screen.setdelegate(getroottable());screen.start(event);
check(bro.getBackground().getID()=="background.converted_cultist","accepted native event truly converts the selected captain");
check(bro.getBackground().getNameOnly().find("已皈依")!=null&&bro.getBackground().m.RawDescription.find(A.CharacterBackgrounds[bro.key].description)!=null,"real conversion hook keeps personal story and converted label");
foreach(field in A.BalanceFields)check(bro.baseProps[field]==oldProps[field],"conversion preserves earned "+field);
check(bro.m.XP==15000&&bro.m.Level==11&&bro.m.PerkPoints==2&&bro.m.LevelUps==0,"native onAdded does not reset progress");
check(bro.items==oldItems&&bro.traits==oldTraits&&bro.flags==oldFlags&&bro.flags.get("afeix_story_progress")==7&&bro.flags.get("afeix_training_choice")=="quail_alarm","conversion preserves equipment fixed traits skill choice and story progress");
check(artSuspended==1&&artRestored==1,"portrait hooks run around native appearance");
check(preacher.baseProps.Bravery==oldBravery+2,"native +2 resolve belongs to the preacher");
check(A.syncCharacterBackground(bro)&&bro.getBackground().getID()=="background.converted_cultist","later synchronization keeps conversion");
local joinKeys=function(keys){local out="";foreach(key in keys)out+=(out==""?"":",")+key;return out;};
print("CONVERSION_ELIGIBLE="+joinKeys(eligible)+"\n");
print("CONVERSION_BRIGHT_BLOCKED="+joinKeys(blocked)+"\n");
print("TESTS_PASSED="+checks+"\n");
