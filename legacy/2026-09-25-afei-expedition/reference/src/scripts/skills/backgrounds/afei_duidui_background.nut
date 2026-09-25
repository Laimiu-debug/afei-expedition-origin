this.afei_duidui_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_duidui";
   this.m.Name="王怼怼 · 问最后一遍的传令";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="我问最后一遍。这回说清楚，她去传。";
   this.m.GoodEnding="怼怼的命令簿写满了。最后一页只有一行：都问清楚了。";
   this.m.BadEnding="那句最后一遍，再也没有人回答。";
   this.m.HiringCost=0;this.m.DailyCost=10;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "王怼怼在巡演班传口令，最常听见的是快去和怎么还没去。她越急，越容易把前一句和后一句拼错。后来她学会反问一遍：谁去，带什么，到了等谁。有人嫌她怼话，她便把三个问题写在传令牌背面。道具箱里有块旧王冠，玩笑闹起来时别人把它扣给她，叫她太子。阿飞第一次让她替团里传话，自己就把集合点说了两遍，两遍不一样。怼怼站在原处，没有跑。她让团长指着地图重说。等人齐了，大谋把那块没什么用的王冠挂到车上，空出的手留给她拿真正的令牌。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
