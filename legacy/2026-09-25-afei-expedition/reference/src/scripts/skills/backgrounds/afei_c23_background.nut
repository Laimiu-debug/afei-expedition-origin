this.afei_c23_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c23";
   this.m.Name="千涵 · 擦亮木牌的003";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="一整条路我不敢保证，这一段交给我。";
   this.m.GoodEnding="千涵在木牌背面刻了一道短坡。新兵问她能跑多远，她指向下一面旗。";
   this.m.BadEnding="003的木牌挂回了架上。等一个不再回来认领的人。";
   this.m.HiringCost=0;this.m.DailyCost=13;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "英灵殿把每位应募者都刻上编号，千涵拿到003。她以为这代表第三位传奇，直到门房告诉她，前面两人只是来得更早。她仍把木牌擦得很亮，排队时站在最靠近旗杆的地方。长跑试训开始，她冲出去很快，没多久就被队伍追上。第二次试训，她没再抢第一个弯，把力气留给最后一段短坡。抹茶带她见阿飞时，阿飞差点把那段故事讲成一天跑完北境。她赶紧纠正，只是那段坡。她愿意跟团走长路，条件是每次出发之前，先让她看清下一处可以停下来的地方。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
