this.afei_c34_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c34";
   this.m.Name="蔓越莓 · 驿路上的弓手";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="箭囊扎着一段红线；她总等前排站稳才拉弓。";
   this.m.GoodEnding="蔓越莓把那段红线系在新的路牌上，后来的人顺着它找到了归队的方向。";
   this.m.BadEnding="黑旗名册在这一行留下了空白。";
   this.m.HiringCost=0;this.m.DailyCost=17;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "蔓越莓替商队望过路，也给守夜的人留过箭。她不爱争谁先射中，常在车板上画一道红线，让后排知道前面哪处不能误伤。一次山路遇袭，护卫抢着追敌，她却守住回程的窄口，等最后一辆车拐过弯才收弓。黑旗在旧驿站遇见她时，箭囊只剩几支，她仍把其中一支递给没有备用箭的陌生弓手。抹茶问她要多少薪水，她先问队伍会不会等掉队的人。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hunting_bow"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
