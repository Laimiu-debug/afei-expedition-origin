this.afei_bottle_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_bottle";
   this.m.Name="小酒瓶 · 抢节奏的突破手";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="球滚到脚边，她第一个往人缝里冲。护具裂了也不肯先退。";
   this.m.GoodEnding="小酒瓶把球传给下一个新人。这一回有人在接。";
   this.m.BadEnding="突破的人先走了。门后没人接应。";
   this.m.HiringCost=0;this.m.DailyCost=13;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小酒瓶在烟港的泥地球场上出了名。球滚到脚边，她第一个往人缝里冲，护具裂了也不肯先退下来。一届比赛的最后一脚，她过了两个人，却把球踢向了早已没人接应的一侧。观众骂得很响，她记得最清楚的，是队友在身后叫过一次自己的名字。散队后，她到试训场找活，冲得越急，招募台前的人退得越远。大谋递盾给她，两人连撞几回。抹茶把被撞倒的告示扶起，说照这样练，先收的该是修理费。阿飞没有让她再冲。她捡起球，故意传得慢了一拍。瓶队已经跑出去，又折回来接住。这一回大谋先顶住靶架，她从侧面挤出一条路。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/shortsword"));
        items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
