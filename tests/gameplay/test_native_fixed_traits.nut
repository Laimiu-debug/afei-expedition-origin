// Verify actual installed-game effects independently of the generated trait deltas.
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){};::mods_queue <- function(...){};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition, checks=0;
function expect(ok,text){if(!ok)throw text;}
local check=function(ok,text){expect(ok,text);checks++;};
::inherit <- function(path,data){return data;};
local native={};
foreach(key in ["fat","huge","gluttonous","determined","sure_footing","loyal","hesitant","optimist","teamplayer","quick","ailing"]){
    dofile(".cache/afei-art/native-contract-fixture/"+key+"_trait.nut");
    native[key]<-getroottable()[key+"_trait"];
}
foreach(pair in [["bottle",["sure_footing","determined"]],["keke",["fat","huge"]],["yuchujiu",["loyal","hesitant"]],["xiaoyueya",["gluttonous","optimist"]],["xiaogui",["fat","loyal"]],["yanzi",["loyal","teamplayer"]],["songnuanyang",["quick","ailing"]]]){
    local key=pair[0], d=A.BalanceV26.people[key], props={MeleeDamageMult=1.0,DailyFood=2.0};
    foreach(i,field in A.BalanceFields)props[field]<-d.runtime_base_before_traits[i];
    foreach(i,trait in pair[1]){
        check(d.fixed_traits[i]==trait,key+" native identity");
        if("onUpdate" in native[trait])native[trait].onUpdate(props);
    }
    foreach(i,field in A.BalanceFields)check(props[field]==d.attrs[i],key+" native effect reconciles "+field);
    if(key=="keke")check(::abs(props.MeleeDamageMult-1.1)<0.00001,"Huge retains its melee damage multiplier");
    check(props.DailyFood==(key=="xiaoyueya"?3:2),key+" actual native food cost");
}
::Const <- {MoodState={Neutral=2},MoraleState={Confident=5}};
local actor={mood=2,morale=3,getMoodState=function(){return this.mood;},getMoraleState=function(){return this.morale;},setMoraleState=function(v){this.morale=v;}};
local skill=native.determined;skill.setdelegate(getroottable());
skill.getContainer<-function(){return {getActor=function(){return actor;}};};
skill.onCombatStarted();check(actor.morale==5,"Determined grants confident morale when mood permits");
actor.mood=1;actor.morale=3;skill.onCombatStarted();check(actor.morale==3,"Determined respects poor mood");
actor.mood=2;actor.morale=6;skill.onCombatStarted();check(actor.morale==6,"Determined does not lower existing morale");
local team=native.teamplayer,owner={getID=function(){return 1;},getFaction=function(){return 1;}};
team.getContainer<-function(){return {getActor=function(){return owner;}};};
foreach(sample in [[1,2,true,0.5],[2,2,true,1.0],[1,1,true,1.0],[1,2,false,1.0]]){
    local target={getID=function(){return sample[1];},getFaction=function(){return sample[0];}};
    local action={isAttack=function(){return sample[2];}},props={MeleeSkillMult=1.0,RangedSkillMult=1.0};
    team.onAnySkillUsed(action,target,props);
    check(props.MeleeSkillMult==sample[3] && props.RangedSkillMult==sample[3],"Team Player only reduces friendly attack accuracy");
}
print("TESTS_PASSED="+checks+"\n");
