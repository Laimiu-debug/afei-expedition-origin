this.afei_lili_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_lili";
   this.m.Name="李李超欧 · 聚光下的超巨";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="灯先别撤，她还有一箭。那把超巨的椅子，抬起来也沉。";
   this.m.GoodEnding="李李把灯留给了下一个站上去的人。椅子她自己搬回去了。";
   this.m.BadEnding="灯灭了。没人记得把椅子搬回去。";
   this.m.HiringCost=0;this.m.DailyCost=10;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "巡演班的人知道李李怎样走进灯光，也知道麻烦一来，去后台未必找得到她。散场时她总要先数有没有人替自己收道具。那把被叫作超巨的高背椅，坐着好看，抬起来也是真的沉。一场夜市演出下雨，灯罩倒了，乐师跑去护琴。李李看见搬道具的小工被椅子堵住出口，先绕开人群找准空隙，再回来把椅子拖到干处。试射的前两箭都偏了，第三箭擦中靶边。阿飞刚想替她圆场，她已经问下一轮什么时候开始。签约那天，舞台边那把椅子还在，上面多了一只裹好弦的旧猎弓。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hunting_bow"));
        items.equip(this.new("scripts/items/armor/thick_tunic"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
