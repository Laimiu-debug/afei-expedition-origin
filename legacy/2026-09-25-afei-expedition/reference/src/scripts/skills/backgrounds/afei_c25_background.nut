this.afei_c25_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c25";
   this.m.Name="玩蛇 · 画蛇的剑客";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="你先让我看一遍，再说它难不难。";
   this.m.GoodEnding="她在团旗边缘画了一条新蛇。旁边写的是队友的名字。";
   this.m.BadEnding="木桩上的蛇痕到某一条为止。再也没有添过新的。";
   this.m.HiringCost=0;this.m.DailyCost=22;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "边境比武场的木桩画满了蛇。玩蛇每学会一套步法，就在旧痕旁再添一条。她很少把新招讲得神秘，只问陪练的人，刚才是从哪一脚开始觉得难受。一次长局，她赢了前半段，却因一直追求更漂亮的变化耗尽力气。第二天，她把最得意的三招删成一招。阿飞去看她比试时，先被她的名号镇住，紧接着又想告诉她该怎么打。她递给他一把木剑，说讲也行，先把刚才那步站出来。他没站稳，却留下来听完了整个复盘。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/arming_sword"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/full_leather_cap"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
