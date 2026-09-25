this.afei_c27_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c27";
   this.m.Name="瑶瑶牙 · 回头的吕布";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="让我往前可以，回来走哪条路先说好。";
   this.m.GoodEnding="阿飞再喊吕布，她先数了一遍身后的脚步，才把斧抬起来。";
   this.m.BadEnding="缺口打开了。回来的那条路上没有人。";
   this.m.HiringCost=0;this.m.DailyCost=23;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "瑶瑶牙的长柄斧比佣兵招牌还显眼。她来到哪座营门，守卫就先问是不是来比武的。她确实赢过几场，却也因为只顾追前面的目标，把需要保护的车留在了身后。旧团散去时，没人带走那辆轮轴断裂的车。她把斧倚在墙边，花半日帮车夫推到修理铺。阿飞听说奶团吕布来了，立即想把她写成黑旗第一勇将。大谋提醒他，队伍不缺会往前冲的人，缺的是能回来的人。她点了点头，把斧柄放到地图上，先问撤回的位置在哪。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/billhook"));
        items.equip(this.new("scripts/items/armor/padded_leather"));
        items.equip(this.new("scripts/items/helmets/full_leather_cap"));
 }
});
