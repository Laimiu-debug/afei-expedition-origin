this.afei_c18_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c18";
   this.m.Name="童猪 · 讲规则的木熊";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="我再讲一次。听完再举手。";
   this.m.GoodEnding="童猪把木熊交给最先猜错的人。规则还在熊底下刻着。";
   this.m.BadEnding="杯子还倒扣着。等一个不再来猜的人。";
   this.m.HiringCost=0;this.m.DailyCost=17;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "童猪带一只木熊跑集市，靠一个小游戏换热汤。木熊什么时候举起、杯子什么时候敲响，规则开始就会讲。偏偏围过来的人常听到一半便抢着猜。有人认定自己聪明到不用再听，连错三次以后，又认定是她偷偷改了答案。她于是把规则刻在木熊底下。可以猜，可以问，也可以拿起来看，只是看完别再说自己全凭本事猜中。到黑旗营里，阿飞和抹茶各有一套解释，轮流说服了对方，又轮流猜错。童猪让两个人停一下，把刚才实际发生的动作按顺序摆出来。大谋照着做了一遍，这才答对。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/pitchfork"));
        items.equip(this.new("scripts/items/armor/ragged_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/accessory/afei_bear_item"));
 }
});
