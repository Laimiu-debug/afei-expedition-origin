this.afei_c16_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c16";
   this.m.Name="涂涂 · 说清楚的告别";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="我今天走到哪儿，先跟你们说清楚。";
   this.m.GoodEnding="涂涂在新路线旁添上了自己的名字。这回不是告别。";
   this.m.BadEnding="那句没说完的再见，留在了上一个岔口。";
   this.m.HiringCost=0;this.m.DailyCost=14;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "涂涂做过不少只送到下一站的护送。到了地方，钱拿清楚，她会把同行的人送到各自要去的门口，再找自己的落脚处。黑旗接下送她到邻镇的委托，阿飞一路讲以后会招到多少人。她听完才问，那今天最后一班岗是谁。阿飞翻了翻名册，发现自己又排重了。她把手里的路线折好，顺便替大家把这一夜分清。送行的晚饭后，她已经走到营门口，又回去取落在火边的手套。她坐下把手套缝了几针，等阿飞从守夜处回来，告诉他下一程如果还缺人，可以再签一段。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/shortsword"));
        items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
