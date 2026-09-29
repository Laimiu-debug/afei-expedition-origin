// Production V2 code, native skill base, deterministic engine fixtures.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::checks<-0;
function check(ok,label){if(!ok)throw "V2: "+label;::checks++;}
function eq(a,b,label){check(a==b,label+" expected="+b+" actual="+a);}
// Optional content registers through the same public adapter as its preload.
dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");
local nativeNew=::new;
// Native trait arithmetic is audited against installed script hashes by the
// design validator. Here native traits are deterministic stand-ins to exercise
// the actual migration's subtraction, conflicts and one-time application.
::new=function(path){
    foreach(key,d in ::AfeixExpedition.BalanceV26.traits)if(d.path==path){
        local s=nativeNew("scripts/skills/special/afeix_combat_memory");s.m.ID=d.id;s.m.Type=::Const.SkillType.Trait;
        s.onUpdate=function(p){foreach(i,field in ::AfeixExpedition.BalanceFields)p[field]+=d.delta[i];};
        return s;
    }
    return nativeNew(path);
};
foreach(key,p in A.BalanceV26.people){
    fresh();local a=makeActor(key);
    foreach(i,field in A.BalanceFields)a.baseProps[field]<-p.attrs[i];
    A.balanceTraits(a,true);a.skills.update();
    foreach(i,field in A.BalanceFields){eq(a.baseProps[field],p.runtime_base_before_traits[i],key+" raw "+field);eq(a.props[field],p.attrs[i],key+" table "+field);}
    foreach(t in p.fixed_traits)check(a.skills.hasSkill(A.BalanceV26.traits[t].id),key+" fixed trait "+t);
    A.balanceTraits(a,true);A.balanceTraits(a);a.skills.update();
    foreach(i,field in A.BalanceFields)eq(a.props[field],p.attrs[i],key+" repeated migration "+field);
    fresh();a=makeActor(key);a.flags.set("kept_name","custom");a.flags.set("afeix_training_choice",key+"_kept");
    foreach(i,field in A.BalanceFields)a.baseProps[field]<-p.old_attrs[i]+17;
    A.balanceTraits(a);a.skills.update();
    foreach(i,field in A.BalanceFields)eq(a.props[field],p.attrs[i]+17,key+" preserves earned points "+field);
    eq(a.flags.get("afeix_training_choice"),key+"_kept",key+" selection retained");
    A.balanceTraits(a);a.skills.update();
    foreach(i,field in A.BalanceFields)eq(a.props[field],p.attrs[i]+17,key+" old load idempotent "+field);
}
// A constructor failure leaves a legacy actor untouched and retryable.
fresh();local legacy=makeActor("afei");foreach(i,field in A.BalanceFields)legacy.baseProps[field]<-A.BalanceV26.people.afei.old_attrs[i]+10;
local constructor=::new;::new=function(path){if(path=="scripts/skills/traits/bright_trait")throw "injected native trait constructor";return constructor(path);};
local failed=false;try{A.balanceTraits(legacy);}catch(e){failed=true;}
check(failed&&!legacy.flags.has("afeix_balance_v26")&&legacy.skills.m.Skills.len()==0,"trait failure is atomic");
foreach(i,field in A.BalanceFields)eq(legacy.baseProps[field],A.BalanceV26.people.afei.old_attrs[i]+10,"trait failure preserves base");
::new=constructor;A.balanceTraits(legacy);check(legacy.flags.has("afeix_balance_v26"),"trait migration retry succeeds");
fresh();local af=makeActor("afei");af.baseProps.Stamina<-106;af.flags.set("afeix_balance_v26",true);af.level=11;
::productionSyncBalance.bindenv(A)(af);check(!af.skills.hasSkill("trait.afeix_endurance"),"Afei has no extra endurance");
af.baseProps.Stamina+=18;af.skills.update();eq(af.props.Stamina,124,"Afei six ordinary fatigue upgrades reach expected target");
::productionSyncBalance.bindenv(A)(af);af.skills.update();eq(af.props.Stamina,124,"Afei sync adds no hidden stamina");

// Both revised builds use ordinary, player-selected stamina growth only.
fresh();local bottle=makeActor("bottle");bottle.baseProps.Stamina<-109;bottle.flags.set("afeix_balance_v26",true);
foreach(level in [1,3,5,7,9,11,25]){
 bottle.level=level;::productionSyncBalance.bindenv(A)(bottle);bottle.skills.update();
 check(!bottle.skills.hasSkill("trait.afeix_endurance"),"bottle receives no special level bonus");
 eq(bottle.props.Stamina,109,"level alone cannot grant bottle stamina");
}
bottle.level=11;bottle.baseProps.Stamina+=18;bottle.skills.update();eq(bottle.props.Stamina,127,"bottle four ordinary three-star rolls at mean4.5 reach127");
::productionSyncBalance.bindenv(A)(bottle);bottle.skills.update();eq(bottle.props.Stamina,127,"bottle resync leaves allocated stamina intact");
foreach(key,p in A.BalanceV26.people)eq(p.level_bonus_per_level[1],0,"no roster member gets dedicated level stamina "+key);

::day<-1;::highest<-11;
::World<-{getTime=function(){return {Days=::day};},Assets={money=10000,getMoney=function(){return this.money;},addMoney=function(n){this.money+=n;}}};
A.discoveryMetrics=function(){return {level=::highest};};A.catalogWorldHas=function(key){return false;};
// Early access changes the service price, not equipment, wages or late catchup.
::day=3;::highest=2;
eq(A.recruitPrice("bottle"),850,"Bottle affordable base quote on first eligible day");
eq(A.Characters.bottle.wage,16,"Bottle normal daily wage retained");
eq(A.BalanceV26.people.bottle.equipment_value,750,"Bottle original starting equipment retained");
::day=6;::highest=2;
eq(A.recruitPrice("lili"),460,"Lili delayed opening retains original base quote");
eq(A.balanceJoinLevel("lili"),1,"Lili remains an early phase recruit");
::highest=11;
foreach(pair in [["bottle",1],["xiwen",2],["xiaojie",4],["yaoyaoya",5]]){
 foreach(d in [35,60,150]){::day=d;eq(A.balanceJoinLevel(pair[0]),pair[1],"member phase cap survives late hiring");}
}
::day=60;::highest=2;eq(A.balanceJoinLevel("xiwen"),1,"highest level still gates catchup");
::highest=5;eq(A.balanceJoinLevel("xiwen",true),2,"freeze at first creation");::day=1;::highest=1;eq(A.balanceJoinLevel("xiwen"),2,"saved level never rerolls");
fresh();::day=35;::highest=5;eq(A.recruitPrice("xiwen"),590,"midgame quote includes exactly one level of catchup");
::day=150;::highest=11;eq(A.recruitPrice("xiwen"),590,"late hiring cannot inflate phase or quote");
check(!A.get("v26_join_level_xiwen",false),"preview does not freeze first generation");
local recruit={m={Level=1,XP=0,LevelUps=0,PerkPoints=0},battles=0};::Const.LevelXP<-[0,200,500,1000,2000];
A.balanceCatchup(recruit,"xiwen");eq(recruit.m.Level,2,"Xiwen joins level2");eq(recruit.m.XP,200,"catchup sets native threshold");eq(recruit.m.LevelUps,1,"one attribute row remains unspent");eq(recruit.m.PerkPoints,1,"one perk remains unspent");eq(recruit.battles,0,"catchup grants no personal battle credit");

// Budget helpers include all mod positives but leave native stats and penalties.
local p={MeleeSkill=60,RangedSkill=50,MeleeDefense=10};A.balanceHit(p,"MeleeSkill",8);A.balanceHit(p,"MeleeSkill",8);A.balanceHit(p,"MeleeSkill",-5);eq(p.MeleeSkill,65,"hit cap with independent penalty");
A.balanceDefense(p,5);A.balanceDefense(p,4);eq(p.MeleeDefense,16,"conditional defense cap");
fresh();local a=makeActor("bottle");a.fatigue=30;eq(A.catalogRecover(a,6),6,"first recovery");eq(A.catalogRecover(a,6),2,"remaining recovery budget");eq(A.catalogRecover(a,6),0,"exhausted recovery budget");
local saved=roundtrip(A.catalogMemory(a),"scripts/skills/special/afeix_combat_memory");a.skills.removeAllByID(saved.getID());a.skills.add(saved);eq(A.catalogRecover(a,6),0,"save retains budget");::state.round++;eq(A.catalogRecover(a,6),6,"new round grants budget");

function learned(key,skill,level=7,pos=0){local a=makeActor(key,pos);a.level=level;a.flags.set("afeix_training_choice",skill);::AfeixExpedition.syncMemberSkills(a);::AfeixExpedition.catalogMemory(a,true);return a;}
fresh();a=learned("xiwen","xiwen_read");local sword=equip(a),enemy=makeActor("enemy",1,2),enemySword=equip(enemy);
A.catalogSet(enemy,"attempt_serial",1);A.catalogSet(enemy,"paid_attempt",1);A.catalogReceived(a,enemy,enemySword,false);eq(A.catalogBoost(a,sword,enemy),8,"Xiwen remembers paid adjacent miss");
local other=makeActor("other",-1,2);A.catalogReceived(a,other,enemySword,false);eq(A.catalogGet(a,"xiwen_read_target"),enemy.id,"new miss does not overwrite mark");
eq(A.catalogBoost(a,sword,other),0,"mark only helps same enemy");a.level=11;eq(A.catalogBoost(a,sword,enemy),10,"Xiwen mastery accuracy");
A.catalogAttackResult(a,sword,enemy,false);eq(A.catalogBoost(a,sword,enemy),0,"miss consumes mark");
::state.round++;A.catalogReceived(a,enemy,enemySword,false);A.catalogTurnStart(a);A.catalogTurnEnd(a);eq(A.catalogGet(a,"xiwen_read_ready"),0,"next own turn expires mark");
fresh();a=learned("xiwen","xiwen_cover",11);equip(a,false,true);local ally=makeActor("ally",1);
check(active(a,"xiwen_cover").use(ally.tile),"Xiwen cover usable");eq(ally.skills.defense(null,null).MeleeDefense,18,"cover md8");eq(ally.skills.defense(null,null).RangedDefense,16,"master cover rd8");eq(a.skills.defense(null,null).MeleeDefense,8,"master own penalty2");
check(!active(a,"xiwen_cover").onVerifyTarget(a.tile,a.tile),"cover cannot target self");A.catalogTurnStart(a);check(!A.catalogFindEffect(ally,"xiwen_cover").valid(),"cover expires on source start");
fresh();a=learned("xiwen","xiwen_travel",11);a.fatigue=40;A.catalogTurnStart(a);A.balanceAfterTurnStart(a);eq(a.fatigue,40,"travel first turn no recovery");
A.catalogMoved(a,1);A.catalogTurnStart(a);A.balanceAfterTurnStart(a);eq(a.fatigue,37,"travel ordinary step mastery3");A.balanceAfterTurnStart(a);eq(a.fatigue,37,"travel cannot repeat in same round");
fresh();a=learned("xiwen","xiwen_travel");a.fatigue=40;A.catalogTurnStart(a);A.catalogMoved(a,0);::state.round++;A.catalogTurnStart(a);A.balanceAfterTurnStart(a);eq(a.fatigue,40,"teleport is not walking");

fresh();a=makeActor("afei");local allies=[];for(local i=1;i<=8;i++)allies.push(makeActor("ally"+i,i));
local selected=A.balanceTargets(a,a,10);eq(selected.len(),3,"team hard cap3");check(selected[0]==a&&selected[1]==allies[0]&&selected[2]==allies[1],"stable self then distance order");
a.placed=false;eq(A.balanceTargets(a,a,10).len(),0,"reserve tooltip has no deployed targets");eq(A.balanceTargets(a,null,10).len(),0,"missing preview center is safe");
print("TESTS_PASSED="+::checks+"\n");
