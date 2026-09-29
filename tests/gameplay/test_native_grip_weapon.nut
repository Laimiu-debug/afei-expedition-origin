// Native item properties, attack tooltips and hit dispatch, including float rounding.
dofile("tests/gameplay/member_skill_fixture.nut");
local checks=0,check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Const.ItemSlot.Bag<-5;::Const.ItemSlot.None<-255;
::Const.Items.ItemType.None<-0;::Const.Items.ItemType.Weapon<-32;::Const.Items.ItemType.Named<-64;
::Const.Items.Property<-{None=0};::Const.Sound<-{DefaultWeaponEquip=[]};
::Const.UI<-{Color={DamageValue="d",NegativeValue="n",PositiveValue="p"}};
::Const.Tactical.AttackEffectSplitShield<-0;
::Const.Combat.WeaponDurabilityLossOnHit<-1;
local originalNew=getroottable()["new"];
function nativeWeapon(path) {
 local def=loadDefinition(path),item=clone def;item.m=clone def.m;item.setdelegate(getroottable());
 foreach(k,v in def)if(typeof v=="table"&&k!="m"){
  local parent={};foreach(pk,pv in v)if(typeof pv=="function")parent[pk]<-pv.bindenv(item);item[k]=parent;
 }
 item.create();return item;
}
getroottable()["new"]=function(path){
 if(path=="scripts/tools/tag_collection")return {onSerialize=function(out){},onDeserialize=function(input,merge){}};
 if(path.find("scripts/items/weapons/")==0)return nativeWeapon(path);
 return originalNew(path);
};
::Const.Injury.BluntBody<-[];::Const.Injury.BluntHead<-[];
foreach(entry in [["item","scripts/items/item"],["weapon","scripts/items/weapons/weapon"],["two_handed_hammer","scripts/items/weapons/two_handed_hammer"],["split_shield","scripts/skills/actives/split_shield"],["smite_skill","scripts/skills/actives/smite_skill"],["shatter_skill","scripts/skills/actives/shatter_skill"]]){
 dofile(".cache/afei-art/native-contract-fixture/"+entry[0]+".nut");::definitions[entry[1]]<-getroottable()[entry[0]];
}
local grip=nativeWeapon("scripts/items/weapons/afeix_laoma_grip");
check(grip.getDamageMin()==84&&grip.getDamageMax()==120,"native getters expose requested fixed damage");
check(abs(grip.m.DirectDamageMult+grip.m.DirectDamageAdd-0.7)<0.00001&&abs(grip.getArmorDamageMult()-2.35)<0.00001,"native item fields report seventy and 235 percent");
check(grip.getShieldDamage()==52,"native shield getter is 52");
local nativeRows=grip.two_handed_hammer.getTooltip(),rows=grip.getTooltip(),fields={};
foreach(row in rows)if("icon" in row&&"text" in row)fields[row.icon]<-row.text;
check(fields["ui/icons/armor_damage.png"].find("235%")!=null,"235 percent does not display as 234 from float truncation");
check(fields["ui/icons/direct_damage.png"].find("70%")!=null&&fields["ui/icons/shield_damage.png"].find("52")!=null,"native penetration and shield tooltips remain accurate");
check(rows.len()==nativeRows.len(),"preserve all native tooltip rows");
foreach(i,row in rows)if(!("icon" in row)||row.icon!="ui/icons/armor_damage.png"){
 if("text" in row)check(row.text==nativeRows[i].text,"unrelated tooltip content preserved");
}
local actor=makeActor("damou");actor.weapon=grip;actor.isHiddenToPlayer=function(){return true;};
actor.props.IsSpecializedInAxes<-false;
local shield={condition=100,getCondition=function(){return this.condition;},applyShieldDamage=function(n){this.condition=::Math.max(0,this.condition-n);}};
local foe={getItems=function(){return {getItemAtSlot=function(slot){return shield;}};}};
local tile={getEntity=function(){return foe;},IsVisibleForPlayer=false};
::Tactical.getNavigator<-function(){return {isTravelling=function(target){return true;}};};
local hitCallbacks=0;actor.skills.onTargetHit<-function(skill,target,part,hp,armor){hitCallbacks++;};
local split=::new("scripts/skills/actives/split_shield");split.m.SoundOnHit=[];
check(split.onUse(actor,tile)&&shield.condition==48&&hitCallbacks==1,"native Split Shield consumes the requested 52 damage");
shield.condition=20;check(split.onUse(actor,tile)&&shield.condition==0,"native shield hit respects remaining durability");

// Follow the native property and skill consumers, not just the item's display fields.
actor.props.IsSpecializedInHammers<-false;
function attackProperties(weapon,attack,bonus=0.0) {
 local p=properties();p.Stamina<-100;p.HitChance<-[75,25];
 p.DamageRegularMin=0;p.DamageRegularMax=0;p.DamageDirectAdd=bonus;
 p.DamageTooltipMinMult<-1.0;p.DamageTooltipMaxMult<-1.0;
 p.DamageAdditionalWithEachTile<-0;p.FatigueDealtPerHitMult<-1.0;
 p.DamageMinimum<-0;p.FatalityChanceMult<-1.0;p.ThresholdToInflictInjuryMult<-1.0;
 p.getHitchance<-function(part){return 0;};
 weapon.onUpdateProperties(p);attack.onAnySkillUsed(attack,null,p);
 return p;
}
::Const.Combat.FatigueReceivedPerHit<-0;
foreach(key in ["DamageFatigue","DamageMinimum","Injuries","InjuryThresholdMult","Tile"])
 ::Const.Tactical.HitInfo[key]<-null;
local captured=null;
local victim={isAlive=function(){return true;},getTile=function(){return {};},getPos=function(){return {};},
 getItems=function(){return {getAppearance=function(){return {ImpactSound=[[],[]]};}};},
 onDamageReceived=function(user,attack,hit){captured=clone hit;throw "CAPTURED_NATIVE_HIT";}};
local plain=::new("scripts/items/weapons/two_handed_hammer");
foreach(spec in [[grip,"smite_skill",0.7,98],[grip,"shatter_skill",0.6,72],
                 [plain,"smite_skill",0.5,55],[plain,"shatter_skill",0.4,36]]) {
 local weapon=spec[0],attack=::new("scripts/skills/actives/"+spec[1]);
 attack.m.Container={getActor=function(){return actor;},
  buildPropertiesForUse=function(s,t){return attackProperties(weapon,s);},
  setBusy=function(value){},onBeforeTargetHit=function(s,t,h){}};
 attack.getCostString=function(){return "engine UI costs omitted";};
 local tooltip=null;
 foreach(row in attack.getTooltip())if("icon" in row&&row.icon=="ui/icons/regular_damage.png")tooltip=row.text;
 check(tooltip!=null&&tooltip.find("[color=d]"+spec[3]+"[/color] can ignore armor")!=null,
  weapon.getID()+" "+spec[1]+" native tooltip uses effective penetration");
 foreach(bonus in [0.0,0.1,0.8]) {
  captured=null;
  try {attack.onScheduledTargetHit({Container=attack.m.Container,TargetEntity=victim,User=actor,Skill=attack,
   Properties=attackProperties(weapon,attack,bonus),DistanceToTarget=1});}
  catch(error){if(error!="CAPTURED_NATIVE_HIT")throw error;}
  check(captured!=null&&abs(captured.DamageDirect-::Math.minf(1.0,spec[2]+bonus))<0.00001,
   weapon.getID()+" "+spec[1]+" native hit dispatch preserves bonuses and penetration cap");
 }
}
// Old fixed weapons serialize wear, not penetration; create() must restore the corrected bonus.
grip.m.Condition=73.0;
grip.m.DirectDamageMult=0.7;grip.m.DirectDamageAdd=0.0;
local restored=roundtrip(grip,"scripts/items/weapons/afeix_laoma_grip");
local restoredSmite=::new("scripts/skills/actives/smite_skill");
local restoredProps=attackProperties(restored,restoredSmite);
check(restored.m.Condition==73.0&&abs(restoredSmite.getDirectDamage()+restoredProps.DamageDirectAdd-0.7)<0.00001,
 "native item save/load preserves wear and restores seventy percent Smite penetration");
print("TESTS_PASSED="+checks+"\n");
