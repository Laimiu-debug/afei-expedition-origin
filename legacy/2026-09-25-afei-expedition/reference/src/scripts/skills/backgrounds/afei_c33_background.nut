this.afei_c33_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c33";
   this.m.Name="小胖 · 守车的盾手";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="卸车时她总留到最后，盾举起来时也一样。";
   this.m.GoodEnding="小胖把磨旧的木盾挂在驿站门口，后来的人都知道那里有人肯等他们回来。";
   this.m.BadEnding="黑旗名册在这一行留下了空白。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小胖在驿站守过粮车。比起抢头功，她更记得哪辆车的绳索松了、谁在夜里咳得厉害。有回一队护卫追着贼跑远，她留在车旁挡住了从侧路摸来的第二拨人。清点时少了一袋麦子，她承认自己没看住；同伴却说，没有她，整辆车都回不来。黑旗帮蓝旗卸完货，她看见大鹅忙着数箱、小虎忙着点人，便把盾靠在门边，问还缺不缺一个肯守到最后的人。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hatchet"));
        items.equip(this.new("scripts/items/armor/padded_leather"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
