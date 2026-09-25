this.afei_c28_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c28";
   this.m.Name="羊咩咩 · 听铃铛的车手";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="弯前松一点，出弯才有力气追。";
   this.m.GoodEnding="新人问她铃铛为什么不响了。她指着停稳的车：大家都知道在哪儿等。";
   this.m.BadEnding="铃铛挂在空车轴上。风一过，响给没人听。";
   this.m.HiringCost=0;this.m.DailyCost=14;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "羊咩咩替山道驿站赶过轻车，车轴旁总挂着一枚铃铛。雇主嫌它吵，她却靠声音判断哪只轮子开始松动。直路上她不一定最快，到了连续弯道，她总能把货送得完整些。一回山路竞速，后车在弯前追得很紧。她没有抢那条最短的内线，而是绕开碎石，晚到半步却保住了整车包裹。裁判只记了抵达时间，收信的人却记得封蜡没有被震开。阿飞想让她带全队赶路。她先带他走了一趟山口，把铃铛递给他，让他先听那一阵不对劲的响声。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/shortsword"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
