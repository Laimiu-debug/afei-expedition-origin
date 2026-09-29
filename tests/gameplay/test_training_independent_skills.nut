// Regression: newly exclusive choices must work without the other two skills.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::checks<-0;
function check(v,label){if(!v)throw "FAIL independent: "+label;::checks++;}
::baseHooks<-{};::exactHooks<-{};
::mods_hookBaseClass<-function(p,f){::baseHooks[p]<-f;};
::mods_hookExactClass<-function(p,f){::exactHooks[p]<-f;};
::mods_getMember<-function(o,k){return o[k];};::mods_override<-function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/member_catalog_hooks.nut");
::catalogTestHook<-function(p,o){if(p=="scripts/skills/skill")::baseHooks["skills/skill"](o);};
A.canManage=function(){return !::state.tactical;};
A.findCharacter=function(k){foreach(a in ::state.actors)if(a.key==k)return a;return null;};
function trained(owner,key){local a=makeActor(owner);a.level=7;::state.tactical=false;check(::AfeixExpedition.chooseTraining(owner,key).ok,"choose "+key);::state.tactical=true;::AfeixExpedition.catalogMemory(a,true);return a;}
function swing(a,s,t,hit=true){a.ap=30;a.fatigue=0;::state.hit=hit;return s.use(t.tile);}
fresh();local a=trained("wanshe","next_path"),enemy=makeActor("enemy",1,2),s=equip(a),raw=s.getFatigueCost();
check(active(a,"snake_trial")==null&&passive(a,"snake_read")==null,"other wanshe choices absent");
swing(a,s,enemy);check(s.getFatigueCost()==raw-4,"first hit earns discount for ordinary attack");
local ready=A.catalogGet(a,"next_path_ready");for(local i=0;i<4;i++)s.getFatigueCost();check(A.catalogGet(a,"next_path_ready")==ready,"preview does not consume");
swing(a,s,enemy,false);check(a.fatigue==raw-4&&s.getFatigueCost()==raw,"miss uses discount once");
swing(a,s,enemy);check(s.getFatigueCost()==raw,"no second activation same round");
::state.round++;A.catalogTurnStart(a);swing(a,s,enemy);check(s.getFatigueCost()==raw-4,"next round reactivation");
A.catalogTurnEnd(a);check(s.getFatigueCost()==raw,"unused discount expires at action end");
fresh();a=trained("tongzhu","know_rules");enemy=makeActor("enemy",1,2);s=equip(enemy);
check(active(a,"bear_strike")==null&&active(a,"cup_signal")==null,"other tongzhu choices absent");
swing(enemy,s,a,false);check(a.props.MeleeSkill==60,"first observation no bonus");
swing(enemy,s,a,false);check(a.props.MeleeSkill==63,"repeat observation directly grants accuracy");
swing(enemy,s,a,false);check(a.props.MeleeSkill==63,"one observation per round");
::state.round++;swing(enemy,s,a,false);check(a.props.MeleeSkill==66,"two-stack cap");
::state.round++;swing(enemy,s,a,false);check(a.props.MeleeSkill==66,"cannot stack beyond cap");
event(a,"onCombatStarted");a.skills.update();check(a.props.MeleeSkill==60,"battle restart clears observation");
// Different living companions can legally combine marks despite one skill each.
fresh();a=trained("lili","ouqi");s=equip(a);s.m.IsRanged=true;s.m.MaxRange=5;
enemy=makeActor("enemy",2,2);
local mocha=trained("mocha","abacus_mark"),berry=trained("manyuemei","berry_mark");
check(active(mocha,"abacus_mark").use(enemy.tile)&&active(berry,"berry_mark").use(enemy.tile),"two independent trained supporters mark target");
for(local i=0;i<4;i++)check(a.skills.buildPropertiesForUse(s,enemy).RangedSkill==60,"two marks cap at +10 in preview");
check(A.catalogFindEffect(enemy,"abacus_mark")!=null&&A.catalogFindEffect(enemy,"berry_mark")!=null,"preview preserves both marks");
swing(a,s,enemy,false);
check(::state.attacks.top().p.RangedSkill==60,"real ranged miss uses capped assistance");
check(A.catalogFindEffect(enemy,"abacus_mark")==null&&A.catalogFindEffect(enemy,"berry_mark")==null,"miss consumes both marks despite cap");
// Existing temporary effects, including saved effects, share the same budget.
fresh();a=trained("qianhan","short_sprint");s=equip(a);enemy=makeActor("enemy",1,2);
mocha=trained("mocha","abacus_mark");check(active(mocha,"abacus_mark").use(enemy.tile),"melee target marked");
A.catalogEffect(a,"short_sprint",a);
check(a.skills.buildPropertiesForUse(s,enemy).MeleeSkill==70,"sprint and mark share +10 budget");
A.catalogEffect(a,"bear_strike",enemy);
check(a.skills.buildPropertiesForUse(s,enemy).MeleeSkill==60,"negative hit modifier applies after positive cap");
swing(a,s,enemy,false);
check(::state.attacks.top().p.MeleeSkill==60,"real attack retains full negative modifier");
check(A.catalogFindEffect(a,"short_sprint")==null&&A.catalogFindEffect(a,"bear_strike")==null,"attempt consumes temporary bonus and penalty");
check(a.skills.buildPropertiesForUse(s,enemy).MeleeSkill==60,"next attack returns to normal");
fresh();a=trained("qianhan","short_sprint");s=equip(a);s.m.IsRanged=true;enemy=makeActor("enemy",1,2);A.catalogEffect(a,"short_sprint",a);
check(a.skills.buildPropertiesForUse(s,enemy).RangedSkill==50,"melee assistance cannot boost ranged skill");
::state.origin=false;A.catalogEffect(enemy,"abacus_mark",a);
check(a.skills.buildPropertiesForUse(s,enemy).RangedSkill==50,"assistance remains origin scoped");
print("TESTS_PASSED="+::checks+"\n");
