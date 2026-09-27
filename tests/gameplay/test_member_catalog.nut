// Execute actual native skill.use and our actual registration callbacks.
// Map navigation, visuals and hit resolution are engine substitutes.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::checks <- 0;
function check(ok,label){if(!ok)throw "FAIL "+label;::checks++;}
function eq(a,b,label){check(a==b,label+" expected="+b+" actual="+a);}
::baseHooks <- {};::exactHooks <- {};::objectHooks <- {};
::mods_hookBaseClass <- function(path,cb){::baseHooks[path]<-cb;};
::mods_hookExactClass <- function(path,cb){::exactHooks[path]<-cb;};
::mods_hookNewObject <- function(path,cb){::objectHooks[path]<-cb;};
::mods_getMember <- function(o,k){return o[k];};
::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/member_catalog_hooks.nut");
::catalogTestHook <- function(path,o){if(path=="scripts/skills/skill")::baseHooks["skills/skill"](o);};
function member(key,pos=0,grown=true){
    local a=makeActor(key,pos);if(grown)::state.flags["growth_done_"+key]<-true;
    ::AfeixExpedition.syncMemberSkills(a);::AfeixExpedition.catalogMemory(a,true);return a;
}
function cfx(a,k){return ::AfeixExpedition.catalogFindEffect(a,k);}
function begin(a){::AfeixExpedition.catalogTurnStart(a);event(a,"onTurnStart");a.ap=9;}
function attack(a,s,t,hit=true){a.ap=50;a.fatigue=0;::state.hit=hit;return s.use(t.tile);}
function shoot(a){local s=equip(a);s.m.IsRanged=true;s.m.MaxRange=5;return s;}
function neighbors(a,b){a.neighbors.push(b);b.neighbors.push(a);}
function addStatus(a,id){local s=::new("scripts/skills/special/afeix_combat_memory");s.m.ID=id;a.skills.add(s);return s;}

// Every companion learns exactly two skills initially and a third at growth.
foreach(owner,keys in A.MemberSkills){
    fresh();local a=member(owner,0,false);eq(keys.len(),3,owner+" group");
    foreach(i,k in keys)eq(A.catalogHas(a,k),i<2,k+" growth gate");
    ::state.flags["growth_done_"+owner]<-true;A.syncMemberSkills(a);A.syncMemberSkills(a);
    foreach(k in keys){
        local d=A.MemberSkillDefs[k],id=(d.active?"actives.":"trait.")+"afeix_member_"+k,count=0;
        foreach(s in a.skills.m.Skills)if(!s.isGarbage()&&s.getID()==id)count++;
        eq(count,1,k+" single instance");
        local path="scripts/skills/"+(d.active?("extended" in d?"actives/afeix_catalog_active":"actives/afeix_member_active"):("extended" in d?"traits/afeix_catalog_passive":"traits/afeix_member_passive"));
        local saved=roundtrip(a.skills.getSkillByID(id),path);eq(saved.m.Key,k,k+" save key");
    }
}
fresh();local m=member("mocha"),ally=member("bottle",1),enemy=makeActor("enemy",2,2),s=equip(ally);
check(active(m,"abacus_mark").use(enemy.tile),"mark use");
for(local i=0;i<4;i++){eq(ally.skills.buildPropertiesForUse(s,enemy).MeleeSkill,70,"preview +10");check(cfx(enemy,"abacus_mark").valid(),"preview retains mark");}
event(enemy,"onTurnEnd");check(cfx(enemy,"abacus_mark").valid(),"victim turn does not expire mark");
attack(ally,s,enemy,false);eq(::state.attacks.top().p.MeleeSkill,70,"mark applies to miss");check(cfx(enemy,"abacus_mark")==null,"miss consumes mark");
// A mark with no attack expires by rounds; reapplication moves it.
m.ap=9;::state.round=4;check(active(m,"abacus_mark").use(enemy.tile),"mark again");
::state.round=6;check(!cfx(enemy,"abacus_mark").valid(),"two round expiry");
fresh();m=member("mocha");ally=member("bottle",1);enemy=makeActor("enemy",2,2);s=equip(ally);
check(active(m,"shadow_captain").use(ally.tile),"discount use");local raw=s.skill.getFatigueCost();
for(local i=0;i<3;i++)eq(s.getFatigueCost(),raw-8,"discount preview");
attack(ally,s,enemy,false);eq(ally.fatigue,raw-8,"discount actually paid");eq(s.getFatigueCost(),raw,"discount consumed");

// Team wards take the strongest bonus, including existing v14 wards.
fresh();local p=member("wangduidui"),c=member("shuaizi",1),a=member("xiaohani",2),foe=makeActor("foe",3,2);
check(active(p,"prince_order").use(p.tile),"deputy when captain absent");
check(active(c,"drum").use(c.tile),"drum");a.fatigue=40;
eq(a.props.Bravery,66,"max buff plus companion");
eq(a.skills.defense(foe,null).MeleeDefense,15,"order defense");
begin(a);eq(a.fatigue,32,"drum next start recovery");event(a,"onTurnEnd");check(cfx(a,"drum")==null,"drum ends after receiving turn");
local captain=makeActor("afei",0);::state.round=5;p.ap=9;check(!active(p,"prince_order").isUsable(),"captain blocks deputy order");
captain.morale=0;check(active(p,"prince_order").isUsable(),"fleeing captain no command");

// Shield dependencies, max defense and permanent loss of anchored protection.
fresh();a=member("naigai");equip(a,false,true);foe=makeActor("foe",1,2);s=equip(foe);
check(active(a,"shrink_cover").use(a.tile),"shrink");eq(a.skills.defense(foe,s).MeleeDefense,18,"cover defense");
check(!a.props.IsAbleToUseWeaponSkills&&a.props.IsRooted,"shrink restrictions");
eq(a.skills.damage(foe,s).DamageReceivedRegularMult,0.8,"cover health multiplier");
a.shield=null;check(!cfx(a,"shrink_cover").valid(),"loss of shield");equip(a,false,true);check(!cfx(a,"shrink_cover").valid(),"shield re-equip cannot restore stance");
fresh();a=member("wangdazhi");equip(a,false,true);check(active(a,"hold_curtain").use(a.tile),"curtain");check(a.props.IsImmuneToKnockBackAndGrab,"curtain push immune");
begin(a);check(cfx(a,"hold_curtain")==null,"curtain next start expiry");
fresh();a=member("suwa");check(active(a,"hard_brake").use(a.tile),"unshielded hard brake");check(a.props.IsRooted,"hard brake root");A.catalogMoved(a,0);check(!cfx(a,"hard_brake").valid(),"forced move breaks brake");

// Native weapon calls preserve costs, durability callbacks, damage and cooldown.
fresh();a=member("wanshe");s=equip(a);foe=makeActor("foe",1,2);
attack(a,s,foe);eq(active(a,"snake_trial").getFatigueCost(),A.MemberSkillDefs.snake_trial.fatigue-4,"next path discount");
a.ap=9;a.fatigue=0;check(active(a,"snake_trial").use(foe.tile),"snake trial");
eq(::state.attacks.top().p.DamageRegularMult,0.8,"trial damage");eq(a.weapon.uses,2,"trial native item once");
eq(foe.props.MeleeSkill,54,"trial target debuff");eq(A.catalogGet(a,"turn_hit_target"),0,"trial clears combo");
check(!active(a,"snake_trial").isUsable(),"trial same-round cooldown");
fresh();a=member("dae");s=equip(a);foe=makeActor("foe",1,2);check(active(a,"gaga_charge").use(foe.tile),"gaga native weapon");
eq(::state.attacks.top().p.MeleeSkill,55,"gaga hit penalty");eq(::state.attacks.top().p.DamageArmorMult,1.2,"gaga armor");

// Real use hook intercepts the whole split-man attack, not just first damage.
fresh();a=member("xiaoyubeike",0);equip(a,false,true);ally=member("bottle",1);foe=makeActor("foe",-1,2);s=equip(foe,true);
s.m.MaxRange=3;check(active(a,"cover_up").use(ally.tile),"cover up");
check(attack(foe,s,ally),"enemy split man");eq(a.received.len(),1,"second body part hits guardian");eq(ally.received.len(),0,"protected ally receives neither part");
check(!cfx(ally,"cover_up").valid(),"intercept single charge");eq(a.skills.damage(foe,s).DamageReceivedTotalMult,0.85,"intercept reduction");
attack(foe,s,a);eq(a.skills.damage(foe,s).DamageReceivedTotalMult,1.0,"later swing not reduced");

// Unselectable never creates an invulnerable last survivor or blocks AOE.
fresh();a=member("lili",0);foe=makeActor("foe",2,2);s=equip(foe);s.m.MaxRange=4;
check(active(a,"unselectable").use(a.tile),"unselectable activate");
check(s.onVerifyTarget(foe.tile,a.tile),"only target remains legal");ally=member("bottle",1);
check(!s.onVerifyTarget(foe.tile,a.tile),"alternative blocks target");
ally.pos=20;check(s.onVerifyTarget(foe.tile,a.tile),"out of range alternative ignored");
ally.pos=1;s.m.IsAOE=true;check(s.onVerifyTarget(foe.tile,a.tile),"AOE bypass");s.m.IsAOE=false;
local own=shoot(a);attack(a,own,foe);check(cfx(a,"unselectable")==null,"own attack cancels hiding");

// Hit history belongs to the victim and is committed only on real attempts.
fresh();a=member("bottle",0);ally=member("keke",1);foe=makeActor("foe",2,2);s=equip(a);local other=equip(ally);s.m.MaxRange=3;
attack(ally,other,foe);eq(A.catalogBoost(a,s,foe),5,"teammate followup");attack(a,s,foe,false);eq(A.catalogBoost(a,s,foe),0,"followup once on miss");
local cai=member("laocai",1),third=equip(cai);attack(a,s,foe);eq(A.catalogBoost(cai,third,foe),10,"two allies set good card");
::state.round++;attack(a,s,foe);attack(ally,other,foe);eq(A.catalogBoost(a,s,foe),5,"own first hit still allows teammate followup");
fresh();a=member("xiaoyueya");s=shoot(a);foe=makeActor("foe",2,2);local foe2=makeActor("foe2",3,2);
eq(A.catalogBoost(a,s,foe),0,"first target no switch");attack(a,s,foe,false);eq(A.catalogBoost(a,s,foe2),8,"switch bonus");attack(a,s,foe2,false);eq(A.catalogBoost(a,s,foe),0,"switch once a round");
fresh();a=member("xiaoning");s=shoot(a);foe=makeActor("foe",2,2);
eq(A.catalogBoost(a,s,foe),6,"alien still");attack(a,s,foe,false);eq(A.catalogBoost(a,s,foe),14,"miss signal");attack(a,s,foe);eq(A.catalogBoost(a,s,foe),6,"signal consumed");A.catalogMoved(a,0);eq(A.catalogBoost(a,s,foe),0,"alien moved");
fresh();a=member("bula");s=shoot(a);a.weapon.throwing=true;a.weapon.ammo=1;foe=makeActor("foe",2,2);
eq(A.catalogBoost(a,s,foe),6,"last ammo preview");attack(a,s,foe);eq(::state.attacks.top().p.RangedSkill,56,"last ammo after item.onUse");eq(a.weapon.ammo,0,"ammo consumed normally");
a.weapon.ammo=1;attack(a,s,foe);a.weapon.ammo=1;eq(A.catalogBoost(a,s,foe),0,"last throw cap two");

// Conditional defense, insight, rest and morale variants.
fresh();a=member("tongzhu");foe=makeActor("foe",1,2);s=equip(foe);
attack(foe,s,a,false);eq(A.catalogGet(a,"insight"),0,"first enemy action");attack(foe,s,a,false);eq(A.catalogGet(a,"insight"),1,"repeat insight");
attack(foe,s,a,false);eq(A.catalogGet(a,"insight"),1,"insight once a round");
a.ap=9;check(active(a,"bear_strike").use(foe.tile),"bear spends insight");eq(A.catalogGet(a,"insight"),0,"insight cost");
eq(foe.skills.buildPropertiesForUse(s,a).MeleeSkill,50,"enemy next attack -10");attack(foe,s,a,false);check(cfx(foe,"bear_strike")==null,"penalty consumed");
fresh();a=member("xiaoyueya");a.morale=::Const.MoraleState.Wavering;begin(a);eq(a.morale,3,"optimist recovery");a.morale=1;begin(a);eq(a.morale,1,"optimist once battle");
fresh();a=member("xiaoyueya");a.morale=0;begin(a);eq(a.morale,0,"optimist no fleeing reset");
fresh();a=member("lili");eq(a.props.RerollMoraleChance,20,"ouqi native property");s=shoot(a);foe=makeActor("foe",2,2);
attack(a,s,foe);eq(a.props.RangedSkill,53,"spotlight gained");attack(a,s,foe);eq(a.props.RangedSkill,53,"spotlight once round");attack(a,s,foe,false);eq(a.props.RangedSkill,50,"spotlight lost");
fresh();a=member("xiaojie");eq(a.props.MoraleCheckBravery[0],15,"mental bravery");a.skills.update();eq(a.props.MoraleCheckBravery[0],15,"bravery no accumulation");
fresh();a=member("xiaohani");a.fatigue=30;event(a,"onTurnEnd");eq(a.fatigue,26,"quiet rest");event(a,"onTurnEnd");eq(a.fatigue,26,"rest once");
::state.round++;begin(a);foe=makeActor("foe",1,2);neighbors(a,foe);event(a,"onTurnEnd");eq(a.fatigue,26,"adjacent enemy blocks rest");
fresh();a=member("keke");equip(a,false,true);ally=member("bottle",1);ally.hp=40;a.skills.update();eq(a.props.Bravery,56,"wounded friend resolve");eq(a.skills.defense(null,null).MeleeDefense,14,"wounded friend guard");
fresh();a=member("suwa");s=equip(a);foe=makeActor("foe",1,2);a.baseProps.Initiative=110;a.skills.update();
eq(A.catalogBoost(a,s,foe),5,"initiative advantage");attack(a,s,foe);attack(a,s,foe);eq(A.catalogBoost(a,s,foe),0,"half step twice");
fresh();a=member("chenzhihan");equip(a,false,true);foe=makeActor("foe",1,2);s=equip(foe);A.catalogReceived(a,foe,s,true);
eq(a.skills.defense(foe,s).MeleeDefense,16,"remember attacker");foe2=makeActor("foe2",1,2);eq(a.skills.defense(foe2,s).MeleeDefense,10,"other enemy not remembered");

// Native movement wrapper counts completed paid walking, not teleport callbacks.
function walker(a){
    a.onTurnStart<-function(){event(this,"onTurnStart");};
    a.onMovementStep<-function(tile,level){return !this.props.IsRooted;};
    a.onMovementUndo<-function(tile,level){};
    a.onMovementFinish<-function(tile){event(this,"onMovementFinished");};
    ::exactHooks["entity/tactical/actor"](a);return a;
}
fresh();a=walker(member("qianhan"));a.fatigue=30;
a.onMovementFinish(a.tile);eq(a.fatigue,30,"teleport no start run");
a.onMovementStep(a.tile,0);a.onMovementUndo(a.tile,0);a.onMovementFinish(a.tile);eq(A.catalogGet(a,"steps"),0,"cancel no walk count");
a.onMovementStep(a.tile,0);a.onMovementStep(a.tile,0);a.onMovementFinish(a.tile);eq(A.catalogGet(a,"steps"),2,"multihex walk count");eq(a.fatigue,28,"start run once");
a.onMovementFinish(a.tile);eq(A.catalogGet(a,"steps"),2,"no leftover walk count");
// Native rotation/teleport bodies run with a minimal navigator.
::Tactical.getNavigator <- function(){return {
    teleport=function(a,t,x,y,z){a.pos=t.owner.pos;::AfeixExpedition.catalogMoved(a,0);},
    switchEntities=function(a,b,x,y,z){local p=a.pos;a.pos=b.pos;b.pos=p;::AfeixExpedition.catalogMoved(a,0);::AfeixExpedition.catalogMoved(b,0);}};};
function emptyTile(pos){local a=makeActor("empty",pos);a.faction=9;a.placed=false;a.tile.IsEmpty=true;a.tile.IsOccupiedByActor=false;return a.tile;}
fresh();a=member("yuchujiu");ally=member("bottle",1);check(active(a,"guard_swap").use(ally.tile),"native rotation");eq(a.pos,1,"rotation user");eq(ally.pos,0,"rotation other");
fresh();a=member("yuchujiu");ally=member("bottle",1);ally.baseProps.IsRooted=true;ally.skills.update();check(!active(a,"guard_swap").use(ally.tile),"root blocks rotation");eq(a.ap,9,"invalid rotation costs nothing");
fresh();a=member("qianhan");local tile=emptyTile(1);check(active(a,"short_sprint").use(tile),"sprint native teleport");eq(a.pos,1,"sprint destination");eq(A.catalogGet(a,"steps"),0,"sprint not walking");
s=equip(a);foe=makeActor("foe",2,2);attack(a,s,foe);eq(::state.attacks.top().p.MeleeSkill,68,"sprint bonus");check(cfx(a,"short_sprint")==null,"sprint consumed");

// No-net attempts and unaffordable snares leave resources untouched.
::World <- {Assets={tools=20,getArmorParts=function(){return this.tools;},addArmorParts=function(v){this.tools+=v;}}};
fresh();a=member("xiaojie");check(!active(a,"spare_key").use(a.tile),"no net no use");addStatus(a,"effects.net");check(active(a,"spare_key").use(a.tile),"remove native net");check(!a.skills.hasSkill("effects.net"),"net removed");
foe=makeActor("foe",1,2);a.ap=9;check(active(a,"lock_wagon").use(foe.tile),"snare use");eq(::World.Assets.tools,18,"snare tools");check(foe.props.IsRooted,"snare root");event(foe,"onTurnEnd");check(!foe.props.IsRooted,"snare expires");
::state.round=5;a.ap=9;::World.Assets.tools=1;check(!active(a,"lock_wagon").use(foe.tile),"tools insufficient");eq(a.ap,9,"no AP on insufficient tools");

// Remaining roles: costs/targets and conditional triggers, not just registration.
fresh();a=member("shuaizi");equip(a,false,true);eq(a.props.Bravery,42,"small heart isolated");ally=member("bottle",1);a.skills.update();eq(a.props.Bravery,50,"small heart accompanied");
check(active(a,"guard_gate").use(a.tile),"gate use");check(a.props.IsRooted&&a.props.IsImmuneToKnockBackAndGrab,"gate holds ground");eq(a.skills.defense(null,null).MeleeDefense,18,"gate plus shield companion");
fresh();a=member("wangduidui",1);ally=member("bottle",2);captain=makeActor("afei",0);a.fatigue=30;
local order={getID=function(){return "actives.afeix_haoqi";},getContainer=function(){return this.owner.skills;},owner=captain};
A.catalogAfterSkill(order,true);eq(a.fatigue,22,"fear hears captain");eq(A.catalogGet(a,"fear_penalty"),1,"fear penalty armed");A.catalogAfterSkill(order,true);eq(a.fatigue,22,"fear once battle");
check(active(a,"dui_sentence").use(ally.tile),"dui encouragement");eq(A.catalogGet(a,"fear_penalty"),0,"dui clears fear");eq(ally.props.Bravery,56,"dui ally resolve");
fresh();a=member("tiantong");ally=member("bottle",1);eq(a.props.Vision,8,"scout vision");eq(a.props.Initiative,110,"scout first round");
check(active(a,"catch_rear").use(ally.tile),"catch rear");eq(ally.skills.defense(null,null).RangedDefense,16,"catch ranged guard");ally.fatigue=30;begin(ally);eq(ally.fatigue,26,"catch fatigue");
s=shoot(a);foe=makeActor("foe",2,2);A.catalogMoved(a,2);eq(A.catalogBoost(a,s,foe),7,"return arrow two steps");attack(a,s,foe,false);eq(A.catalogBoost(a,s,foe),0,"return arrow attempt consumed");
fresh();a=member("xiaoning");foe=makeActor("foe",2,2);check(active(a,"drool").use(foe.tile),"drool");eq(foe.props.Initiative,80,"drool slow");eq(foe.props.RangedSkill,45,"drool ranged penalty");event(foe,"onTurnEnd");eq(foe.props.RangedSkill,50,"drool expires");
fresh();a=member("xiaopangxu");equip(a,false,true);ally=member("bottle",1);check(active(a,"pang_share").use(ally.tile),"pang share");eq(ally.skills.defense(null,null).MeleeDefense,16,"grown dance support");eq(a.skills.defense(null,null).MeleeDefense,14,"dance anchor");
foe=makeActor("foe",2,2);s=equip(foe);a.fatigue=30;A.catalogReceived(a,foe,s,true);A.catalogReceived(a,foe,s,true);eq(a.fatigue,27,"pang recovery once");
fresh();a=member("manyuemei");ally=member("bottle",1);foe=makeActor("foe",2,2);s=shoot(a);check(active(a,"berry_mark").use(foe.tile),"berry mark");eq(A.catalogBoost(a,s,foe),13,"mark and supported aim");
a.ap=9;a.fatigue=20;local shotCost=s.getFatigueCost();s.use(foe.tile);eq(a.fatigue,20+shotCost-2,"berry hit recovery");check(cfx(foe,"berry_mark")==null,"berry mark consumed");
fresh();a=member("xiaohani");ally=member("bottle",1);check(active(a,"gentle_note").use(ally.tile),"gentle note");eq(ally.skills.defense(null,null).MeleeDefense,13,"gentle guard");eq(ally.props.Bravery,58,"gentle resolve");
fresh();a=member("yuxiang");ally=member("bottle",1);m=member("mocha",-1);a.skills.update();eq(a.props.Bravery,56,"elder resolve");eq(a.skills.defense(null,null).MeleeDefense,14,"elder guard");
begin(a);a.fatigue=30;check(active(a,"long_watch").use(a.tile),"long watch");foe=makeActor("foe",2,2);s=equip(foe);A.catalogReceived(a,foe,s,true);eq(a.fatigue,30+A.MemberSkillDefs.long_watch.fatigue-4,"watch recovery");
::state.round++;m.pos=4;local newcomer=member("keke",-1);a.fatigue=30;begin(a);eq(a.fatigue,25,"changed neighbor arrival");
fresh();a=member("tongzhu");ally=member("bottle",1);A.catalogSet(a,"insight",2);check(active(a,"cup_signal").use(a.tile),"cup signal");eq(A.catalogGet(a,"insight"),0,"cup spends two insights");s=equip(ally);eq(s.getFatigueCost(),5,"cup discount eight");
fresh();a=member("meiya");ally=member("bottle",1);foe=makeActor("foe",2,2);other=equip(ally);s=equip(a);s.m.MaxRange=3;attack(ally,other,foe,false);eq(A.catalogBoost(a,s,foe),6,"read adjacent miss");attack(a,s,foe);eq(A.catalogBoost(a,s,foe),0,"read consumed");
a.ap=9;tile=emptyTile(-1);check(active(a,"curtain_yield").use(tile),"melee hit enables yield");eq(a.pos,-1,"yield destination");
fresh();a=member("meiya");ally=member("bottle",2);tile=emptyTile(1);check(active(a,"king_dance").use(tile),"king dance");eq(ally.props.Initiative,112,"dance landing neighbor bonus");
fresh();a=member("wanshe");s=equip(a);foe=makeActor("foe",1,2);other=equip(foe);A.catalogReceived(a,foe,other,false);eq(A.catalogBoost(a,s,foe),6,"snake reads miss");event(a,"onTurnEnd");eq(A.catalogBoost(a,s,foe),0,"snake read expires");
fresh();a=member("tutu");ally=member("bottle",1);ally.hp=40;a.skills.update();eq(a.props.Bravery,60,"tutu supports wounded");eq(a.skills.defense(null,null).MeleeDefense,15,"tutu wounded guard");a.fatigue=30;event(a,"onTurnEnd");eq(a.fatigue,24,"tutu quiet rest");
check(active(a,"return_road").use(ally.tile),"tutu native rotation");eq(a.pos,1,"tutu swapped");
fresh();a=member("songnuanyang");eq(a.props.Initiative,115,"quail opening initiative");eq(a.props.Vision,8,"quail opening vision");check(active(a,"quail_hide").use(a.tile),"quail hide");check(a.props.IsRooted,"quail planted");eq(a.skills.defense(null,null).RangedDefense,20,"quail ranged cover");
::state.round=2;a.skills.update();eq(a.props.Vision,7,"quail later vision");
fresh();a=member("xiaogui");equip(a,false,true);ally=member("bottle",1);check(active(a,"turtle_cover").use(ally.tile),"turtle cover");eq(ally.skills.defense(null,null).MeleeDefense,15,"turtle guard");a.pos=4;check(!cfx(ally,"turtle_cover").valid(),"turtle distance breaks tether");a.pos=0;check(!cfx(ally,"turtle_cover").valid(),"tether cannot revive");
fresh();a=member("naigai");s=shoot(a);a.weapon.throwing=true;foe=makeActor("foe",1,2);other=equip(foe);A.catalogReceived(a,foe,other,false);eq(A.catalogBoost(a,s,foe),10,"return throwing bonus");attack(a,s,foe);eq(A.catalogBoost(a,s,foe),0,"return consumed");
// Native taunt invokes AI targeting and attaches the native status.
::definitions["scripts/skills/effects/taunted_effect"]<-::inherit("scripts/skills/skill",{m={},function create(){this.m.ID="effects.taunted";}});
foe.ai<-{forced=null,setForcedOpponent=function(a){this.forced=a;}};foe.getAIAgent<-function(){return this.ai;};a.ap=9;a.fatigue=0;check(active(a,"mouth_strong").use(foe.tile),"native taunt");check(foe.ai.forced==a,"taunt AI opponent");check(foe.skills.hasSkill("effects.taunted"),"taunt native status");
fresh();a=member("bula");s=shoot(a);a.weapon.throwing=true;check(active(a,"budget_share").use(a.tile),"budget self");eq(s.getFatigueCost(),8,"throwing discount");check(!active(a,"budget_share").isUsable(),"budget once battle");
fresh();a=member("suwa");tile=emptyTile(1);check(active(a,"foot_point").use(tile),"foot point");eq(a.props.Initiative,115,"foot initiative");
fresh();a=member("wangdazhi");equip(a,false,true);ally=member("bottle",1);eq(ally.skills.defense(null,null).MeleeDefense,13,"stationary neighbor shield");A.catalogMoved(a,0);eq(ally.skills.defense(null,null).MeleeDefense,10,"moving stops ground aura");
foe=makeActor("foe",2,2);m=member("mocha",3);s=equip(a);eq(A.catalogBoost(a,s,foe),5,"two allies door bonus");
fresh();a=member("yaoyaoya",1);captain=makeActor("afei",0);A.catalogMoved(a,1);event(a,"onTurnEnd");eq(a.props.Bravery,56,"look at captain flag");begin(a);eq(a.props.Bravery,50,"flag expires");
captain.pos=20;m=member("damou",2);A.catalogMoved(a,1);event(a,"onTurnEnd");eq(a.props.Bravery,56,"any nearby captain flag");
fresh();a=member("yangmiemie");a.fatigue=30;A.catalogMoved(a,2);eq(a.fatigue,27,"curve second step");A.catalogMoved(a,1);eq(a.fatigue,27,"curve no repeat");ally=member("bottle",1);ally.fatigue=30;event(a,"onTurnEnd");eq(ally.fatigue,27,"bell neighbor recovery");a.ap=9;tile=emptyTile(-1);check(active(a,"line_detour").use(tile),"line detour");
fresh();a=member("chenzhihan");equip(a,false,true);ally=member("bottle",1);foe=makeActor("foe",2,2);s=equip(foe);check(active(a,"guard_self").use(a.tile),"guard self");eq(a.skills.damage(foe,s).DamageReceivedRegularMult,0.9,"guard health multiplier");a.ap=9;check(active(a,"moon_cake").use(a.tile),"moon cake");eq(ally.props.Bravery,56,"cake team resolve");

// Every effect and the combat ledger have complete save round-trips.
foreach(key,d in A.CatalogEffects){
    fresh();local owner=A.MemberSkillDefs[key].owner,b=member(owner);equip(b,false,true);
    local e=A.catalogEffect(b,key,b),saved=roundtrip(e,"scripts/skills/effects/afeix_catalog_effect");
    eq(saved.m.Key,key,key+" effect save");eq(saved.m.Source,b.id,key+" source save");
}
fresh();a=member("lili");A.catalogSet(a,"spotlight",3);A.catalogSet(a,"finished_serial",7);
local memory=roundtrip(A.catalogMemory(a),"scripts/skills/special/afeix_combat_memory");eq(memory.m.State.spotlight,3,"memory stacks save");eq(memory.m.State.finished_serial,7,"memory attempt save");memory.onCombatStarted();eq(memory.m.State.len(),0,"next battle clears ledger");
::state.origin=false;check(!A.catalogHas(a,"chaoju"),"other origin no skills");
print("TESTS_PASSED="+::checks+"\n");
