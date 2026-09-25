this.afei_c17_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c17";
   this.m.Name="可可 · 认人的守望者";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="你往前走。她看着朝你抬弓的那个。";
   this.m.GoodEnding="可可的布条系满了全营的盾。每一条她都认得主人。";
   this.m.BadEnding="布条还在盾上。认布条的人不在了。";
   this.m.HiringCost=0;this.m.DailyCost=15;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "可可给往来市集的人看过行李。忙起来谁都说某个是自己的，她便给同一拨人的东西系上同色布条。学弩以后，她仍留着这个习惯。射得不算急，总先看箭路里是谁。有次伙计突然从靶前过去，她抬高了弩，箭扎进棚梁。别人让她先讲不是自己的错，她先去把那人的袖口从木刺上解下来。黑旗在市集聚餐时坐散了，她替他们把包与人重新对上。阿飞说自己记得全部名字，随后把两只行李拿反。她递回去，问这支队伍打起来以后，有没有人替后排看身边的路。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/light_crossbow"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
