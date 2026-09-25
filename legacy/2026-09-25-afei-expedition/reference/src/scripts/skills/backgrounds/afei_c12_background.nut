this.afei_c12_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c12";
   this.m.Name="小虎 · 回头的信使";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="前面能走。等等，她先看一眼后头。";
   this.m.GoodEnding="小虎的信袋空了。这一袋，终于送完了。";
   this.m.BadEnding="最后一封信还夹在袋底。收信人的名字没有落款。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小虎做过蓝旗信使。收信人会搬家，关卡会换人，一句带到了还不够，她要看见有人把封口拆开。蓝旗留下最后一袋信时，大部分人都已赶往下一份活。她按远近排好，发现袋底还有一封早该送达的。她折返去问，在村口碰见黑旗的车队。阿飞劝她先搭车走一段，她说顺路可以，到了岔口得停。大谋真的在岔口停了车。等她回来的时候，远处有两个人追着车辙走来。她先把弓取下，直到认出是送回遗落包裹的村民才放松。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hunting_bow"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
