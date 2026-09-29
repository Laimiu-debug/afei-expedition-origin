// Native constructor/getTooltip and Split Shield consumer, including float rounding.
dofile("tests/gameplay/member_skill_fixture.nut");
local checks=0,check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Const.ItemSlot.Bag<-5;::Const.ItemSlot.None<-255;
::Const.Items.ItemType.None<-0;::Const.Items.ItemType.Weapon<-32;::Const.Items.ItemType.Named<-64;
::Const.Items.Property<-{None=0};::Const.Sound<-{DefaultWeaponEquip=[]};
::Const.UI<-{Color={DamageValue="d",NegativeValue="n",PositiveValue="p"}};
::Const.Tactical.AttackEffectSplitShield<-0;
::Const.Combat.WeaponDurabilityLossOnHit<-1;
local originalNew=getroottable()["new"];
getroottable()["new"]=function(path){if(path=="scripts/tools/tag_collection")return {};return originalNew(path);};
foreach(entry in [["item","scripts/items/item"],["weapon","scripts/items/weapons/weapon"],["two_handed_hammer","scripts/items/weapons/two_handed_hammer"],["split_shield","scripts/skills/actives/split_shield"]]){
 dofile(".cache/afei-art/native-contract-fixture/"+entry[0]+".nut");::definitions[entry[1]]<-getroottable()[entry[0]];
}
local def=loadDefinition("scripts/items/weapons/afeix_laoma_grip"),grip=clone def;grip.m=clone def.m;grip.setdelegate(getroottable());
foreach(k,v in def)if(typeof v=="table"&&k!="m"){
 local parent={};foreach(pk,pv in v)if(typeof pv=="function")parent[pk]<-pv.bindenv(grip);grip[k]=parent;
}
grip.create();grip.getValueString=function(){return "12000";};
check(grip.getDamageMin()==84&&grip.getDamageMax()==120,"native getters expose requested fixed damage");
check(abs(grip.m.DirectDamageMult+grip.m.DirectDamageAdd-0.7)<0.00001&&abs(grip.getArmorDamageMult()-2.35)<0.00001,"native combat multipliers are seventy and 235 percent");
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
print("TESTS_PASSED="+checks+"\n");
