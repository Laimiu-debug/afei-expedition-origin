this.afei_c15_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c15";
   this.m.Name="苏袜 · 记路的快脚";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="这个岔口看记号。下个她也给你们画了。";
   this.m.GoodEnding="苏袜画的记号连成了线。后来的人顺着走，再没迷过路。";
   this.m.BadEnding="记号还在石头上。画记号的人没能一起回来。";
   this.m.HiringCost=0;this.m.DailyCost=15;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "苏袜替驿站跑腿，最讨厌鞋底还没磨热，路就被另一辆车堵住。她记得屋檐能遮到哪里，哪块石头踩上去不会滑。单独办事，这样很省时间。带人走的时候，就未必。一次踏勘，她把每处路口都认清了，同行的老车夫却在第二个岔道走偏。她折回去找，才看见自己留下的记号只有自己认得。阿飞成了那个一路都要问的人。问得她起初想快走两步，后来开始在路口画更大的箭头。四小时走完，她反而比自己单跑时累。大谋检查过路标，说这次把车交给他，也能跟上。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/javelin"));
        items.equip(this.new("scripts/items/armor/thick_tunic"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
