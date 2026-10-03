// Execute native item equip, generic-item properties, mastery, hit dispatch and
// persistence. Engine visuals are stubbed; this is an offline native contract.
dofile("tests/gameplay/member_skill_fixture.nut");
dofile(".cache/afei-art/native-contract-fixture/weak_table_ref.nut");
local checks=0,check=function(ok,label){if(!ok)throw "FAIL douyu gear: "+label;checks++;};
::Const.ItemSlot.Bag<-5;::Const.ItemSlot.None<-255;
foreach(pair in [["None",0],["Weapon",32],["Named",64],["Legendary",128],["Quest",256],["Armor",512],["Defensive",1024]])
    ::Const.Items.ItemType[pair[0]]<-pair[1];
::Const.Items.Property<-{None=0};::Const.Items.Default<-{GenericItemName="item",GenericItemIcon=""};
::Const.Sound<-{DefaultWeaponEquip=[],ArmorLeatherImpact=[]};
::Const.SkillType.Item<-32;::Const.SkillType.Perk<-64;::Const.SkillOrder.Item<-50;::Const.SkillOrder.Perk<-60;
::Const.Strings<-{PerkName={SpecCleaver="cleaver",SpecSpear="spear"},PerkDescription={SpecCleaver="",SpecSpear=""}};
::Const.UI<-{Color={DamageValue="d",NegativeValue="n",PositiveValue="p"}};
::Const.Tactical.AttackEffectSplitShield<-0;::Const.Tactical.AttackEffectThrust<-0;::Const.Tactical.AttackEffectSlash<-0;
::Const.Combat.WeaponDurabilityLossOnHit<-1;::Const.Combat.ShowDamagedArmorThreshold<-0.5;
::Const.Combat.FatigueReceivedPerHit<-0;
::Tactical.State<-{getStrategicProperties=function(){return null;},isScenarioMode=function(){return true;}};
::doesBrushExist<-function(name){return name=="afeix_douyu_fin_cleaver_bloodied"||name=="afeix_douyu_tooth_spear_bloodied";};
::Const.Injury.PiercingBody<-[];::Const.Injury.PiercingHead<-[];
foreach(key in ["DamageFatigue","DamageMinimum","Injuries","InjuryThresholdMult","Tile"])
    ::Const.Tactical.HitInfo[key]<-null;
::isKindOf=function(a,kind){return typeof a=="table"&&((kind=="player"&&"controlled" in a&&a.controlled)||(kind=="skill"&&"getContainer" in a));};
local originalNew=getroottable()["new"];
function nativeItem(path) {
    local def=loadDefinition(path),o=clone def;o.m=clone def.m;o.m.SkillPtrs=[];o.setdelegate(getroottable());
    foreach(k,v in def)if(typeof v=="table"&&k!="m"){
        local parent={};foreach(pk,pv in v)if(typeof pv=="function")parent[pk]<-pv.bindenv(o);o[k]=parent;
    }
    o.create();return o;
}
getroottable()["new"]=function(path){
    if(path=="scripts/tools/tag_collection")return {onSerialize=function(out){},onDeserialize=function(input,merge){}};
    if(path.find("scripts/items/")==0)return nativeItem(path);
    return originalNew(path);
};
foreach(entry in [["item","scripts/items/item"],["weapon","scripts/items/weapons/weapon"],["armor","scripts/items/armor/armor"],
    ["crypt_cleaver","scripts/items/weapons/ancient/crypt_cleaver"],["fighting_spear","scripts/items/weapons/fighting_spear"],
    ["generic_item","scripts/skills/items/generic_item"],["cleave","scripts/skills/actives/cleave"],
    ["decapitate","scripts/skills/actives/decapitate"],["split_shield","scripts/skills/actives/split_shield"],
    ["thrust","scripts/skills/actives/thrust"],["spearwall","scripts/skills/actives/spearwall"],
    ["perk_mastery_cleaver","scripts/skills/perks/perk_mastery_cleaver"],["perk_mastery_spear","scripts/skills/perks/perk_mastery_spear"]]){
    dofile(".cache/afei-art/native-contract-fixture/"+entry[0]+".nut");::definitions[entry[1]]<-getroottable()[entry[0]];
}
function gearActor(name) {
    local a=makeActor(name);a.isHiddenToPlayer=function(){return true;};
    a.baseProps.Stamina<-100;a.baseProps.Armor<-[0.0,0.0];a.baseProps.ArmorMax<-[0.0,0.0];a.baseProps.HitChance<-[75,25];
    a.baseProps.DamageRegularMin=0;a.baseProps.DamageRegularMax=0;
    a.baseProps.IsProficientWithHeavyWeapons<-false;a.baseProps.IsSpecializedInCleavers<-false;a.baseProps.IsSpecializedInSpears<-false;
    a.items.app<-{Armor="",CorpseArmor="",HideBody=false,Weapon="",Shield="",TwoHanded=false,ImpactSound=[[],[]]};
    a.items.getActor<-function(){return ::WeakTableRef(this.actor);};
    a.items.getAppearance<-function(){return this.app;};a.items.updateAppearance<-function(){};
    a.skills.add=function(s,order=0){s.m.Container=this;this.m.Skills.push(s);this.update();};
    // Clone mutable property arrays like the native CharacterProperties.getClone.
    a.baseProps.Armor=[0.0,0.0];a.skills.update=function(){
        if(this.busy)return;this.busy=true;
        this.actor.props=clone this.actor.baseProps;
        foreach(k in ["Armor","ArmorMax","HitChance","MoraleCheckBravery"])this.actor.props[k]=clone this.actor.baseProps[k];
        this.actor.props.SkillCostAdjustments=[];
        foreach(s in clone this.m.Skills)if(!s.isGarbage())s.onUpdate(this.actor.props);
        foreach(s in clone this.m.Skills)if(!s.isGarbage())s.onAfterUpdate(this.actor.props);
        this.busy=false;
    };
    a.skills.update();return a;
}
function equipItem(actor,item){item.setContainer(actor.items);item.setCurrentSlotType(item.getSlotType());item.onEquip();actor.skills.update();}
local armorPath="scripts/items/armor/legendary/afeix_douyu_sharkskin";
local finPath="scripts/items/weapons/legendary/afeix_douyu_fin_cleaver";
local toothPath="scripts/items/weapons/legendary/afeix_douyu_tooth_spear";
local armor=::new(armorPath),fin=::new(finPath),tooth=::new(toothPath);
foreach(item in [armor,fin,tooth]){
    check(item.isItemType(::Const.Items.ItemType.Legendary)&&!item.isItemType(::Const.Items.ItemType.Named),"fixed legendary classification "+item.getID());
    check(item.isUnique()&&item.isPrecious()&&item.isDroppedAsLoot(),"native unique precious loot "+item.getID());
}
check(fin.getBlockedSlotType()==::Const.ItemSlot.Offhand&&fin.isItemType(::Const.Items.ItemType.TwoHanded),"fin blocks shield slot");
check(tooth.getBlockedSlotType()==null&&tooth.isItemType(::Const.Items.ItemType.OneHanded)&&tooth.m.IsDoubleGrippable,"tooth retains shield and double grip choices");
local heavy=gearActor("heavy"),cleaver=gearActor("cleaver"),spearman=gearActor("spearman");
cleaver.weapon=fin;spearman.weapon=tooth;
equipItem(heavy,armor);equipItem(cleaver,fin);equipItem(spearman,tooth);
check(heavy.props.Armor[0]==460&&heavy.props.ArmorMax[0]==460&&heavy.props.Stamina==74,"native armor generic skill applies 460 and minus 26 fatigue");
check(heavy.items.app.Armor=="afeix_douyu_sharkskin"&&heavy.items.app.CorpseArmor=="afeix_douyu_sharkskin_dead","native equip chooses live and corpse armor art");
armor.setArmor(200);heavy.skills.update();
check(heavy.props.Armor[0]==200&&heavy.items.app.Armor=="afeix_douyu_sharkskin_damaged","native wear changes armor value and damaged sprite");
local has=heavy.skills.hasSkill;heavy.skills.hasSkill=function(id){return id=="perk.brawny"||has.call(this,id);};heavy.skills.update();
check(heavy.props.Stamina==81,"native Brawny rounds sharkskin load to minus 19");
check(cleaver.props.DamageRegularMin==90&&cleaver.props.DamageRegularMax==120&&cleaver.props.Stamina==93,"native equip applies fin damage and load");
check(spearman.props.DamageRegularMin==54&&spearman.props.DamageRegularMax==62&&spearman.props.Stamina==99,"native equip applies tooth damage and load");
check(cleaver.items.app.Weapon=="afeix_douyu_fin_cleaver"&&cleaver.items.app.TwoHanded,"native held fin sprite is two handed");
check(spearman.items.app.Weapon=="afeix_douyu_tooth_spear"&&!spearman.items.app.TwoHanded,"native held spear sprite is one handed");
fin.setBloodied(true);check(cleaver.items.app.Weapon=="afeix_douyu_fin_cleaver_bloodied","native bloody weapon brush follows suffix contract");fin.setBloodied(false);
local cleave=cleaver.skills.getSkillByID("actives.cleave"),decap=cleaver.skills.getSkillByID("actives.decapitate"),split=cleaver.skills.getSkillByID("actives.split_shield");
local thrust=spearman.skills.getSkillByID("actives.thrust"),wall=spearman.skills.getSkillByID("actives.spearwall");
check(cleave!=null&&decap!=null&&split!=null&&thrust!=null&&wall!=null,"native parent weapons install all intended skills");
check(cleave.getFatigueCostRaw()==10&&decap.getFatigueCostRaw()==15&&split.getFatigueCostRaw()==15,"native fin equip reduces all skill base costs");
check(thrust.getFatigueCostRaw()==6&&wall.getFatigueCostRaw()==26,"native spear equip reduces thrust and spearwall costs");
cleaver.skills.add(::new("scripts/skills/perks/perk_mastery_cleaver"));spearman.skills.add(::new("scripts/skills/perks/perk_mastery_spear"));
check(cleave.getFatigueCost()==8&&decap.getFatigueCost()==12&&split.getFatigueCost()==15,"native cleaver mastery rounds costs and leaves axe skill unaffected");
check(thrust.getFatigueCost()==5&&wall.getFatigueCost()==20,"native spear mastery rounds both costs");
check(thrust.getHitChanceModifier()==20,"native thrust retains plus 20 accuracy");
local foe=makeActor("foe",1,2);foe.hp=50;::state.tactical=true;
foreach(spec in [[cleaver,cleave,8],[cleaver,decap,12],[spearman,thrust,5]]){
    spec[0].ap=9;spec[0].fatigue=0;spec[1].attackEntity=function(user,target){return false;};
    spec[1].use(foe.tile);
    check(spec[0].ap==5&&spec[0].fatigue==spec[2],"native skill.use spends actual mastered costs on a missed "+spec[1].getID());
}
::state.tactical=false;
local hit=null,victim={isAlive=function(){return true;},getHitpoints=function(){return 50;},getHitpointsMax=function(){return 100;},
    getTile=function(){return {};},getPos=function(){return {};},getItems=function(){return {getAppearance=function(){return {ImpactSound=[[],[]]};}};},
    onDamageReceived=function(user,attack,h){hit=clone h;throw "NATIVE_HIT_CAPTURED";}};
function hitProperties(actor,attack,target,bonus=0.0){
    local p=actor.skills.buildPropertiesForUse(attack,target);p.DamageDirectAdd+=bonus;
    p.DamageAdditionalWithEachTile<-0;p.FatigueDealtPerHitMult<-1.0;p.DamageMinimum<-0;p.FatalityChanceMult<-1.0;p.ThresholdToInflictInjuryMult<-1.0;
    p.getHitchance<-function(part){return 0;};return p;
}
foreach(spec in [[cleaver,cleave,0.55,90.0,148.5],[cleaver,decap,0.55,135.0,148.5],[spearman,thrust,0.45,54.0,78.3]]){
    local a=spec[0],attack=spec[1];a.skills.setBusy<-function(value){};a.skills.onBeforeTargetHit<-function(s,t,h){};
    foreach(bonus in [0.0,0.1,0.8]){
        hit=null;
        try{attack.onScheduledTargetHit({Container=a.skills,TargetEntity=victim,User=a,Skill=attack,Properties=hitProperties(a,attack,victim,bonus),DistanceToTarget=1});}
        catch(e){if(e!="NATIVE_HIT_CAPTURED")throw e;}
        check(hit!=null&&abs(hit.DamageDirect-::Math.minf(1.0,spec[2]+bonus))<0.0001,"native hit penetration, bonuses and cap "+attack.getID());
        check(abs(hit.DamageRegular-spec[3])<0.0001&&abs(hit.DamageArmor-spec[4])<0.0001,"native hit actual damage "+attack.getID());
    }
}
check(hitProperties(spearman,thrust,victim).MeleeSkill==80,"native thrust accuracy reaches actual attack properties");
foreach(spec in [[fin,"165%","55%"],[tooth,"145%","45%"]]){
    local fields={};foreach(row in spec[0].getTooltip())if("icon" in row&&"text" in row)fields[row.icon]<-row.text;
    check(fields["ui/icons/armor_damage.png"].find(spec[1])!=null&&fields["ui/icons/direct_damage.png"].find(spec[2])!=null,"display percentages match actual hit "+spec[0].getID());
}
fin.m.Condition=37;tooth.m.Condition=81;armor.m.Condition=200;
local loadedArmor=roundtrip(armor,armorPath),loadedFin=roundtrip(fin,finPath),loadedTooth=roundtrip(tooth,toothPath);
check(loadedArmor.getArmor()==200&&loadedArmor.getArmorMax()==460&&loadedArmor.getStaminaModifier()==-26,"native armor save preserves wear and fixed quality");
check(loadedArmor.m.Sprite=="afeix_douyu_sharkskin"&&loadedArmor.m.SpriteDamaged=="afeix_douyu_sharkskin_damaged"&&loadedArmor.m.SpriteCorpse=="afeix_douyu_sharkskin_dead","native deserialize retains all custom armor art");
check(loadedFin.getCondition()==37&&loadedFin.getDamageMin()==90&&abs(loadedFin.m.DirectDamageAdd-0.30)<0.0001,"native fin save preserves wear and restores attack bonus");
check(loadedTooth.getCondition()==81&&loadedTooth.getDamageMin()==54&&abs(loadedTooth.m.DirectDamageAdd-0.20)<0.0001,"native tooth save preserves wear and restores attack bonus");

// Run the production enemy death override through native actor.dropLoot and
// native item.drop. Native kill keeps IsAlive=true while IsDying=true here.
::definitions["scripts/entity/tactical/entity"]<-{m={}};
::Const.BloodType<-{None=0};::Const.MoraleState.Confident<-5;
::Const.DefaultMovementAPCost<-[2];::Const.DefaultMovementFatigueCost<-[4];
::Const.Movement<-{LevelDifferenceActionPointCost=1,LevelDifferenceFatigueCost=2};
::Const.Tactical.MovementType<-{Default=0};::Const.ShakeCharacterLayers<-[];
::Const.MoraleCheckType.Default<-0;::Const.FatalityType<-{None=0};
::createColor<-function(value){return value;};
dofile(".cache/afei-art/native-contract-fixture/actor.nut");::definitions["scripts/entity/tactical/actor"]<-::actor;
dofile("src/scripts/entity/tactical/enemies/afeix_douyu.nut");
dofile("src/scripts/mods/afeix/douyu_gear.nut");
local properties={CombatID="afeix_douyu_final",IsArenaMode=false},dream=false,A=::AfeixExpedition;
::Tactical.State.getStrategicProperties=function(){return properties;};
::Tactical.State.isScenarioMode=function(){return dream;};A.isDreamCombat=function(){return dream;};
::World<-{Assets={m={IsBlacksmithed=false},getOrigin=function(){return {isDroppedAsLoot=function(item){return false;}};}}};
function lootTile(){return {Items=[],IsContainingItems=false,IsContainingItemsFlipped=true,Properties={values={},set=function(k,v){this.values[k]<-v;}},
    spawnDetail=function(...){return {setBrightness=function(value){}};}};}
function dyingBoss(tile){
    local b={m={AfeixDouyuLootDropped=false},alive=true,dying=true,placed=true,tile=tile,
        isAlive=function(){return this.alive;},isDying=function(){return this.dying;},isPlacedOnMap=function(){return this.placed;},
        getTile=function(){return this.tile;},getItems=function(){return {prepareItemsForCorpse=function(killer){return [];}};},
        spawnBloodPool=function(tile,n){}};
    b.setdelegate(getroottable());b.dropLoot<-::actor.dropLoot.bindenv(b);
    b.actor<-{onDeath=::actor.onDeath.bindenv(b)};b.onDeath<-::afeix_douyu.onDeath.bindenv(b);return b;
}
::Const.Corpse<-{CorpseName="",IsResurrectable=true,IsConsumable=true,Tile=null,Items=null};
::Const.Tactical.DetailFlag<-{Corpse=1};::Tactical.Entities.addCorpse<-function(tile){};
::state.flags={};local ground=lootTile(),boss=dyingBoss(ground);
boss.onDeath(null,null,ground,0);
check(ground.Items.len()==3&&ground.IsContainingItems&&!ground.IsContainingItemsFlipped,"real boss death uses native tile loot for all three items");
local ids={};foreach(item in ground.Items)ids[item.getID()]<-true;
check(ids.len()==3&&"armor.body.afeix_douyu_sharkskin" in ids&&"weapon.afeix_douyu_fin_cleaver" in ids&&"weapon.afeix_douyu_tooth_spear" in ids,"real death drops one of each trophy");
check(A.douyuLootClaimed()&&boss.m.AfeixDouyuLootDropped,"actual death persists campaign and actor guards");
check(!ground.Properties.values.Corpse.IsResurrectable&&!ground.Properties.values.Corpse.IsConsumable,"boss trophy corpse cannot be resurrected or consumed");
boss.onDeath(null,null,ground,0);check(ground.Items.len()==3,"duplicate native death callback adds no items");
local another=lootTile();check(!A.dropDouyuTrophies(dyingBoss(another),another)&&another.Items.len()==0,"persistent guard rejects a second boss instance");
::state.flags={};dream=true;local dreamGround=lootTile();dyingBoss(dreamGround).onDeath(null,null,dreamGround,0);
check(dreamGround.Items.len()==0&&!A.douyuLootClaimed(),"dream flag blocks even a final combat ID and leaves real reward available");
dream=false;properties.CombatID="afeix_dream_douyu";A.dropDouyuTrophies(dyingBoss(dreamGround),dreamGround);
check(dreamGround.Items.len()==0&&!A.douyuLootClaimed(),"dream combat ID independently blocks trophies");
properties.CombatID="afeix_douyu_final";boss=dyingBoss(another);boss.dying=false;
check(!A.dropDouyuTrophies(boss,another)&&another.Items.len()==0,"visiting winning or retreating with a living boss never grants trophies");
boss.dying=true;boss.placed=false;check(!A.dropDouyuTrophies(boss,another),"removed actor cannot claim rewards");
boss.placed=true;::state.origin=false;check(!A.dropDouyuTrophies(boss,another),"unrelated origin cannot claim Afei reward");::state.origin=true;
properties=null;check(!A.dropDouyuTrophies(boss,another),"missing strategic combat context cannot grant trophies");
properties={CombatID="afeix_douyu_final",IsArenaMode=false};
boss.onDeath(null,null,null,0);
check(another.Items.len()==3&&A.douyuLootClaimed(),"crowded corpse placement falls back to native actor tile without losing loot");
::state.flags={};local failed=lootTile();boss=dyingBoss(failed);
local itemFactory=getroottable()["new"],itemCount=0;
getroottable()["new"]=function(path){if(path.find("legendary/afeix_douyu_")!=null&&++itemCount==2)throw "resource unavailable";return itemFactory(path);};
local refused=false;try{A.dropDouyuTrophies(boss,failed);}catch(e){if(e!="resource unavailable")throw e;refused=true;}
check(refused&&failed.Items.len()==0&&!A.douyuLootClaimed()&&!boss.m.AfeixDouyuLootDropped,"failed item construction leaves all awards and guards untouched");
getroottable()["new"]=itemFactory;
check(A.dropDouyuTrophies(boss,failed)&&failed.Items.len()==3,"recovered item factory can retry the complete award");
print("TESTS_PASSED="+checks+"\n");
