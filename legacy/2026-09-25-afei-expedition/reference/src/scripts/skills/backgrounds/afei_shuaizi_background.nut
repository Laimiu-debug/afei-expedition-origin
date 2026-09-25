this.afei_shuaizi_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_shuaizi";
   this.m.Name="白小帅子 · 数拍子的门神";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="慌是真的。四拍走一车，门就还在。";
   this.m.GoodEnding="帅子把腰鼓传给新来的门卫。数到四，就有人回来。";
   this.m.BadEnding="鼓点停在第三下。门后再没有人接应。";
   this.m.HiringCost=0;this.m.DailyCost=12;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "白小帅子给集市守过门，给节庆队敲过鼓。平日她怕管错人，见到争吵就先问是不是有误会。一次收摊时两辆车抢着出门，她被挤在门柱边，嘴里一直说慢一点，手上的横杆却没有松。等车倒回去，她才发现腿抖得走不动。后来节庆队缺鼓手，让她照固定拍子敲。四拍走一车，八拍再开另一边。人群渐渐听懂了。阿飞听见鼓声去找人。大谋把两面盾搭在门边，让她站进原来的位置试试。帅子说这和战场不一样，手却已经在盾沿上敲起那个拍子。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/bludgeon"));
        items.equip(this.new("scripts/items/armor/padded_leather"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
        items.equip(this.new("scripts/items/accessory/afei_drum_item"));
 }
});
