this.afei_c30_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c30";
   this.m.Name="罗一可 · 让角度的人";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="先让我把这个角度转过来。";
   this.m.GoodEnding="巷口不再堆桶。她把球传给围观的新兵，自己站到门侧。";
   this.m.BadEnding="巷口的桶又堆了起来。再没有人把它们转开。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "罗一可曾是街头球场最不肯让出门前位置的人。她并不总能跑到最后，却知道球将滚向哪一块凹地。别人看的是远处的门，她先看自己脚下两步。球场被临时货市占去后，她替摊贩搬木架，发现挤来挤去也有同样的规律。大箱子从正面推不动，换个角度，便能给后面的人让出一条路。阿飞邀她上路，说正好缺个能跑的。她摇头，带他走到堆满桶的巷口，几下把最碍事的桶转开。她要接的是门前那几步，整条长街则得靠大家轮换走完。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/ragged_surcoat"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
