this.afei_c22_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c22";
   this.m.Name="陈知含 · 留一份的月饼";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="我的那份先放好，再来分你们的。";
   this.m.GoodEnding="陈知含买了完整的一盒月饼，每人一份。她自己的那份，最先放好。";
   this.m.BadEnding="月饼分完了。留到最后的那一块，没有人来领。";
   this.m.HiringCost=0;this.m.DailyCost=12;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "陈知含在粮铺替人押过短途货车，报酬常是一袋碎饼。每到宿营，别人争整块的，她就把碎块分成差不多的几份。常要等大家吃完，才发现轮到自己的只剩纸袋。城郊试训时，她举盾挨了几下，站得不漂亮。教头让她换一个轻松的位置，她却问能不能先告诉自己，下一击会从哪里来。后来她学会了看对方的脚，而不是一直盯着盾上的裂口。阿飞在粮铺见到她，先夸她能吃苦。抹茶打断了这句话，问她想学什么。她指了指车旁的盾：先让我知道自己挡住了什么，再决定明天还站不站这里。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/bludgeon"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
