this.afei_c14_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c14";
   this.m.Name="小杰 · 挂钥匙的学徒";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="钥匙都挂她身上。要用就先开，这把放你那里。";
   this.m.GoodEnding="小杰把最后一串钥匙交还车队。车锁着，路敞着。";
   this.m.BadEnding="钥匙还在腰上响。车停在没人认得的地方。";
   this.m.HiringCost=0;this.m.DailyCost=14;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小杰做车队学徒时丢过一袋修车钉。钉子并不值很多钱，偏偏是在最远的那段路上，所有人都等着修车。她赔过钱以后开始上锁，工具箱一把，粮箱一把，连已经空了的木柜也舍不得卸下锁扣。东西后来没再丢，找钥匙却成了新麻烦。有一天下雨，大家等着拿油布，她忙着解释自己明明分好了类。阿飞站在车外淋了一会儿，问她锁得这么牢，打算先保护谁。她把一串钥匙都拿出来，连自己也愣住了。大谋没有拆锁，抹茶找来两块木牌，先替她把用途写明。阿飞让她把另一把钥匙交给旁边的人。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
