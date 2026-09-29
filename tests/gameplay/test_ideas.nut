dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,n=0;
local expect=function(v,label){++n;if(!v)throw "FAIL ideas: "+label;};
::Const.SkillType.Perk <- 32;::Const.SkillType.DamageOverTime <- 64;
::Const.SkillOrder.Trait <- 10;::Const.SkillOrder.Perk <- 20;
::Const.ItemSlot.Head <- 2;::Const.ItemSlot.Body <- 3;
::Const.Strings <- {PerkName={SteelBrow="Steel Brow"},PerkDescription={SteelBrow="No critical head multiplier"}};
::Const.Difficulty <- {MaxResources=[{Medicine=100}]};
foreach(pair in [["traits/character_trait","character_trait"],["perks/perk_steel_brow","perk_steel_brow"],["effects/bleeding_effect","bleeding_effect"]]){
    dofile(".cache/afei-art/native-contract-fixture/"+pair[1]+".nut");::definitions["scripts/skills/"+pair[0]]<-getroottable()[pair[1]];
}
::ideaTest <- {now=100000,safe=true,moving=true,hostiles=[],start=0,combat=0,result=1,town={},failAdd=false,limit=10,items=[],tools=10};
local stash={getNumberOfEmptySlots=function(){return ::ideaTest.limit-::ideaTest.items.len();},
    add=function(i){if(::ideaTest.failAdd||this.getNumberOfEmptySlots()<=0)return null;::ideaTest.items.push(i);return ::ideaTest.items.len()-1;},
    remove=function(i){local n=::ideaTest.items.find(i);if(n!=null)::ideaTest.items.remove(n);},getItems=function(){return ::ideaTest.items;},sort=function(){}};
local assets={m={Medicine=10.5,EconomicDifficulty=0,MedicineMaxAdditional=0},
    getStash=function(){return stash;},getMedicine=function(){return ::Math.floor(this.m.Medicine);},
    addMedicine=function(n){this.m.Medicine=::Math.minf(100,this.m.Medicine+n);},setMedicine=function(n){this.m.Medicine=n;},
    getArmorParts=function(){return ::ideaTest.tools;},addArmorParts=function(n){::ideaTest.tools=::Math.min(100,::ideaTest.tools+n);},setArmorParts=function(n){::ideaTest.tools=n;}};
::World <- {Assets=assets,State={getCombatStartTime=function(){return ::ideaTest.start;},
    getPlayer=function(){return {getPos=function(){return {};},m={Destination=::ideaTest.moving?{}:null}};}},
    getAllEntitiesAtPos=function(p,r){return ::ideaTest.hostiles;},getTime=function(){return {Days=10};},
    Statistics={getFlags=function(){return {getAsInt=function(k){return k=="LastCombatID" ? ::ideaTest.combat : ::ideaTest.result;}};}}};
::Tactical.EventLog <- {log=function(t){}};
A.worldNow=function(){return ::ideaTest.now;};A.daysInSeconds=function(n){return n*86400;};
A.canManage=function(){return ::ideaTest.safe;};A.currentTown=function(){return ::ideaTest.town;};A.refreshAssets=function(){};
A.roster=function(){local out=[];foreach(a in ::state.actors)if(a.faction==1)out.push(a);return out;};
A.findCharacter=function(k){foreach(a in this.roster())if(a.key==k)return a;return null;};
local nativeNew=getroottable()["new"];
getroottable()["new"]=function(path){
    if(path.find("scripts/items/supplies/")==0)return {amount=0,setAmount=function(n){this.amount=n;}};
    if(path=="scripts/items/weapons/afeix_laoma_grip")return {price=0,getID=function(){return ::AfeixExpedition.GripID;},setPriceMult=function(v){this.price=v;}};
    return nativeNew(path);
};
function ideaActor(key,pos=0){local a=makeActor(key,pos);a.mood<-0.0;
    a.improveMood<-function(v,r){this.mood+=v;};a.worsenMood<-function(v,r){this.mood-=v;};a.setDirty<-function(v){};
    a.head<-null;a.body<-null;
    a.items.getItemAtSlot=function(slot){return slot==0?this.actor.weapon:(slot==1?this.actor.shield:(slot==2?this.actor.head:this.actor.body));};
    a.items.getActor<-function(){return this.actor;};
    a.items.unequip<-function(i){if(this.actor.head==i){this.actor.head=null;return true;};return false;};
    a.items.equip<-function(i){this.actor.head=i;return true;};
    a.baseProps.IsImmuneToCriticals<-false;
    return a;
}
local token=0;
local resolve=function(key,choice){++token;A.set("ideas_active_token",token);return A.resolveIdea(key,choice,token);};
fresh();::state.tactical=false;local afei=ideaActor("afei"),keke=ideaActor("keke"),turtle=ideaActor("xiaogui"),ordinary=ideaActor("");
expect(A.ideaSafe(),"peaceful world safe");::state.tactical=true;expect(!A.ideaSafe(),"no world events in combat");::state.tactical=false;
::ideaTest.start=1;expect(!A.ideaSafe(),"no effects during combat transition");::ideaTest.start=0;
::state.origin=false;expect(!A.ideaSafe(),"other origins excluded");::state.origin=true;
expect(A.ideaChildren().len()==2&&A.CharacterOrder.len()==34&&A.RootOrder.len()==6&&!("liuqingsong" in A.Characters),"NPC does not enter roster or six roots");
::ideaTest.safe=false;expect(A.ideaEligible("dao"),"road encounter needs moving party");::ideaTest.moving=false;expect(!A.ideaEligible("dao"),"stopped party not selected");
expect(resolve("dao",0).ok&&afei.mood==-0.5&&ordinary.mood==-0.5,"native pause does not invalidate chosen encounter; whole roster mood");
expect(!A.resolveIdea("dao",0,token).ok&&ordinary.mood==-0.5,"duplicate choice cannot charge again");
expect(!A.ideaEligible("dao"),"road cooldown enforced");::ideaTest.safe=true;
expect(resolve("bao",0).ok&&::ideaTest.items.len()==1&&::ideaTest.items[0].amount==25&&assets.m.Medicine==14.5,"gift uses stash index zero and preserves fractional medicine");
expect(ordinary.mood==-0.25,"bao whole roster mood");local oldOrd=ordinary.mood;
expect(resolve("er",0).ok&&A.get("ideas_er_gift",false)&&ordinary.mood==oldOrd&&keke.mood==0,"er mood only tagged members");
::ideaTest.limit=::ideaTest.items.len();local med=assets.m.Medicine;
expect(resolve("bao",0).ok&&A.get("ideas_gift","")=="bao"&&assets.m.Medicine==med,"full inventory keeps complete pending gift without partial supplies");
::ideaTest.limit=10;assets.m.Medicine=99.5;
expect(!A.ideaGiveGift("bao")&&assets.m.Medicine==99.5,"fractional capacity cannot silently discard medicine");assets.m.Medicine=10.5;
::ideaTest.failAdd=true;expect(!A.ideaGiveGift("bao")&&assets.m.Medicine==10.5,"stash failure no medicine grant");::ideaTest.failAdd=false;
local page=A.ideasLedgerPage({m={Notice=""}},"ideas");local eventData={m={Notice=""}};page.Options[0].getResult(eventData);
expect(A.get("ideas_gift","")==""&&assets.m.Medicine==14.5,"pending gift claim through ledger");page.Options[0].getResult(eventData);expect(assets.m.Medicine==14.5,"same ledger action cannot duplicate gift");
expect(resolve("cao",0).ok,"cao ready ticket");local ticket=A.get("ideas_cao_serial");
ordinary.placed=false;local late=ideaActor("late");::state.tactical=true;
A.ideaBattleTurn();expect(afei.skills.hasSkill("effects.afeix_cao_courage")&&keke.skills.hasSkill("effects.afeix_cao_courage"),"eligible deployed team buffed");
expect(!ordinary.skills.hasSkill("effects.afeix_cao_courage")&&!late.skills.hasSkill("effects.afeix_cao_courage"),"reserve and post-event joiner excluded");
expect(afei.skills.hasSkill("effects.bleeding")&&!keke.skills.hasSkill("effects.bleeding"),"bleeding only Afei");local count=afei.skills.m.Skills.len();A.ideaBattleTurn();expect(afei.skills.m.Skills.len()==count,"combat activation once");
local courage=afei.skills.getSkillByID("effects.afeix_cao_courage"),p=properties();courage.onUpdate(p);expect(p.Bravery==70,"resolve plus twenty");
local saved=roundtrip(courage,"scripts/skills/effects/afeix_cao_courage");expect(saved.m.Turns==2,"courage duration persists");
courage.onWaitTurn();expect(courage.m.Turns==2,"wait not a turn");courage.onTurnEnd();expect(courage.m.Turns==1,"first own turn");courage.onTurnEnd();expect(courage.isGarbage(),"second own turn expires");
local bleed=afei.skills.getSkillByID("effects.bleeding");bleed.spawnIcon=function(...){};
bleed.onWaitTurn();expect(afei.received.len()==0,"cao bleed ignores wait");bleed.onTurnEnd();bleed.onTurnEnd();expect(afei.received.len()==1&&bleed.m.TurnsLeft==1,"native round guard prevents duplicate damage");
saved=roundtrip(bleed,"scripts/skills/effects/afeix_cao_bleeding");expect(saved.m.TurnsLeft==1&&saved.m.LastRoundApplied==1,"bleed duration and round persist");
::state.round=2;bleed.onTurnEnd();expect(afei.received.len()==2&&afei.received[0].DamageRegular==5&&bleed.isGarbage(),"two baseline five point ticks");
local natural=::new("scripts/skills/effects/bleeding_effect");afei.skills.add(natural);afei.skills.add(::new("scripts/skills/effects/afeix_cao_bleeding"));afei.skills.removeAllByID("effects.bleeding");expect(!afei.skills.hasSkill("effects.bleeding"),"native bandage ID removes natural and event bleeds");
::ideaTest.combat=1;::state.tactical=false;A.finishIdeasBattle();A.finishIdeasBattle();expect(A.get("ideas_wins")==1&&A.get("ideas_dao_reply",false),"victory and dao reply once per battle");
// Re-arm another battle: reserves keep their ticket but cannot activate without Afei.
expect(resolve("cao",0).ok,"new ticket setup");afei.placed=false;::state.tactical=true;A.ideaBattleTurn();expect(A.get("ideas_cao_used")==ticket,"Afei reserve cannot spend ticket");
::ideaTest.combat=2;afei.placed=true;A.set("route","feidie"); // Actual route accessor uses promotion_route below.
A.route=function(){return "feidie";};A.ideaBattleTurn();A.set("ideas_afei_hurt",true);afei.hp=40;
::ideaTest.combat=3;::state.tactical=false;local mood=keke.mood;A.finishIdeasBattle();expect(keke.mood==mood-0.5&&A.get("ideas_hurt_open",false),"low health damaged feidie makes children worry");
A.finishIdeasBattle();expect(keke.mood==mood-0.5,"battle callback repeated does not penalize twice");
resolve("hurt",0);expect(keke.mood==mood-0.5,"reading injury scene never charges again");
afei.hp=100;::ideaTest.now+=86400;expect(A.ideaEligible("recover"),"healed response delayed half day");resolve("recover",0);expect(keke.mood==mood-0.25&&!A.get("ideas_hurt_open",false),"healing restores only original affected members");
// Native steel brow plus intrinsic armor migration.
::ideaTest.items=[];::ideaTest.limit=10;turtle.head={getSlotType=function(){return 2;}};local oldHelmet=turtle.head;
A.syncIdeasCharacter(turtle);A.syncIdeasCharacter(turtle);
expect(turtle.head==null&&::ideaTest.items.len()==1&&::ideaTest.items[0]==oldHelmet,"old helmet moved as original object exactly once");
expect(turtle.skills.hasSkill("perk.steel_brow")&&turtle.props.IsImmuneToCriticals,"real native Steel Brow attached");
local trait=turtle.skills.getSkillByID("trait.afeix_turtle_body"),baseDefense=turtle.baseProps.MeleeDefense;
expect(turtle.props.MeleeDefense==baseDefense+5,"intrinsic stats do not accumulate on sync");
local weapon=equip(afei),damage=function(part,s){local p=properties();trait.onBeforeDamageReceived(afei,s,{BodyPart=part},p);return p.DamageReceivedTotalMult;};
expect(damage(1,weapon)==0.5&&abs(damage(0,weapon)-0.8)<0.001,"head and body weapon reduction");expect(damage(0,natural)==1.0,"damage over time excluded");
turtle.head=oldHelmet;::ideaTest.limit=1;A.syncIdeasCharacter(turtle);expect(turtle.head==oldHelmet&&damage(1,weapon)==1.0,"full stash retains old helmet and disables natural head armor");
::ideaTest.limit=10;::ideaTest.failAdd=true;A.syncIdeasCharacter(turtle);expect(turtle.head==oldHelmet&&!A.IdeasRestoringHelmet,"failed transfer rolls back original helmet");::ideaTest.failAdd=false;
// Exercise actual hook's user-equip/load distinction without a game renderer.
::mods_hookBaseClass <- function(...){};
local hooks={};::mods_hookNewObject <- function(path,fn){hooks[path]<-fn;};::mods_hookExactClass <- function(path,fn){};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
local container={m={},actor=turtle,getActor=function(){return this.actor;},equip=function(i){this.actor.head=i;return true;},onDeserialize=function(input){return this.equip(input);}};
hooks["items/item_container"](container);expect(!container.equip(oldHelmet),"manual and UI equip reject turtle helmet");
container.onDeserialize(oldHelmet);expect(turtle.head==oldHelmet&&!container.m.AfeixLoading,"old save helmet deserializes for safe migration");container.actor=ordinary;expect(container.equip(oldHelmet),"other characters unaffected");
// Additional armor damage is paid, single-target, one time, same body part.
local foe=ideaActor("enemy",1);foe.faction=2;foe.body={condition=18.0,getCondition=function(){return this.condition;},setCondition=function(v){this.condition=v;}};
foe.head={condition=100.0,getCondition=function(){return this.condition;},setCondition=function(v){this.condition=v;}};
weapon.m.ID="actives.smite";afei.weapon.getID<-function(){return ::AfeixExpedition.GripID;};
A.catalogSet(afei,"attempt_serial",1);A.catalogSet(afei,"grip_paid",1);
local hpBefore=foe.hp;
expect(A.gripBreakArmor(afei,weapon,foe,0)==18&&foe.body.condition==0&&foe.head.condition==100&&foe.hp==hpBefore,"low armor caps the bonus without health or other-part damage");
expect(A.gripBreakArmor(afei,weapon,foe,1)==0&&foe.head.condition==100,"same hit callback cannot double proc");A.catalogSet(afei,"attempt_serial",2);
expect(A.gripBreakArmor(afei,weapon,foe,1)==0,"free attack has no paid serial");A.catalogSet(afei,"grip_paid",2);expect(A.gripBreakArmor(afei,weapon,foe,1)==30&&foe.head.condition==70,"head hit extra thirty");
weapon.m.ID="actives.shatter";A.catalogSet(afei,"attempt_serial",3);A.catalogSet(afei,"grip_paid",3);expect(A.gripBreakArmor(afei,weapon,foe,0)==0,"AOE excluded");
// Weapon shop independently rolls 5%, preserves one current copy, other origins excluded.
::ideaTest.items=[];local shop={getID=function(){return "building.weaponsmith";},getSettlement=function(){return {isAlliedWithPlayer=function(){return true;}};},getPriceMult=function(){return 1.25;}};
::Math.rand=function(a,b){return 5;};A.gripRestock(shop,stash);A.gripRestock(shop,stash);expect(::ideaTest.items.len()==1&&::ideaTest.items[0].price==1.25,"inclusive five percent and no duplicate in current stash");
::ideaTest.items=[];::Math.rand=function(a,b){return 6;};A.gripRestock(shop,stash);expect(::ideaTest.items.len()==0,"six excluded from five-percent roll");
::state.origin=false;::Math.rand=function(a,b){return 1;};A.gripRestock(shop,stash);expect(::ideaTest.items.len()==0,"other origins never stocked");::state.origin=true;
// NPC event finite reward, no recruit or seventh root; record has no reward action.
assets.m.Medicine=10;local beforeCount=A.roster().len();expect(A.nextChronicle()=="liu","er gift opens NPC contact at town");
expect(resolve("liu",0).ok&&assets.m.Medicine==14&&A.roster().len()==beforeCount,"NPC medicine once without roster mutation");
expect(!resolve("liu",1).ok&&::ideaTest.tools==10,"NPC cannot repeat or change reward");
::ideaTest.now+=172800;A.set("ideas_wins",A.get("ideas_liu_wins")+3);expect(A.nextChronicle()=="liu_reply","NPC followup after three more victories");
resolve("liu_reply",0);local recorded=A.ideasLedgerPage({m={}},"ideas_read:liu");expect(recorded.Options.len()==1&&recorded.Text.find("刘青松")!=null,"NPC reread navigation only");
foreach(key,d in A.Chronicles){A.set("chronicle_done_"+key,true);A.set("chronicle_choice_"+key,0);}A.set("ideas_gift","er");expect(A.ideasLedgerPage({m={}},"ideas").Options.len()<=6,"history pagination stays within native button budget");
// The actual native skill.use wrapper must distinguish paid uses from useForFree.
local baseHooks={};::mods_hookBaseClass <- function(path,fn){baseHooks[path]<-fn;};
::mods_getMember <- function(o,k){return o[k];};::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/member_catalog_hooks.nut");
baseHooks["skills/skill"](weapon);weapon.m.ID="actives.smite";afei.skills.add(::new("scripts/skills/special/afeix_grip_breaker"));
::state.tactical=true;afei.placed=true;afei.ap=40;afei.fatigue=0;foe.body.condition=100;
expect(weapon.use(foe.tile)&&foe.body.condition==70,"actual native paid use procs armor damage");
local ap=afei.ap;expect(weapon.useForFree(foe.tile)&&foe.body.condition==70&&afei.ap==ap,"native free use pays nothing and cannot proc");
::state.hit=false;expect(weapon.use(foe.tile)==false&&foe.body.condition==70,"miss pays native costs without bonus armor damage");
::state.hit=true;afei.ap=0;local serial=A.catalogGet(afei,"attempt_serial");expect(!weapon.use(foe.tile)&&A.catalogGet(afei,"attempt_serial")==serial,"unaffordable attack never arms proc");
// Resolve stacking is computed independently of effect iteration order.
local testBuff=::new("scripts/skills/effects/afeix_promotion_effect");testBuff.m.ID="test.promotion";testBuff.m.BraveryBonus=12;keke.skills.add(testBuff);
expect(A.ideaCourageContribution(keke)==8,"event only fills gap above promotion buff");
testBuff.m.BraveryBonus=25;expect(A.ideaCourageContribution(keke)==0,"stronger existing resolve effect gains nothing extra");
print("TESTS_PASSED="+n+"\n");
