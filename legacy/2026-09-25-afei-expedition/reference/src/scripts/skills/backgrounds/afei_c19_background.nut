this.afei_c19_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c19";
   this.m.Name="奶盖 · 嘴强的盾";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="等我把盾拿好。刚才那句话，还算数。";
   this.m.GoodEnding="奶盖把待再试改成了通过。笔是教官递给她的。";
   this.m.BadEnding="那方小台空了。没人再来争那句嘴强。";
   this.m.HiringCost=0;this.m.DailyCost=15;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "英灵殿招募所给新人留了一方小台。奶盖站上去，能把面前几名教官说得直摇头。轮到隔着软垫接一拳，她退了两步，差点撞倒台后的木架。记录员在嘴强王者下面写了待再试，她隔一会儿就去看那一行，生怕变成请离开。抹茶把试训记录带回营里。阿飞先笑了，笑完又让人把下一场的位置留住。第二次试训，大谋给她一面盾，帅子站在侧后方数拍。教官举拳，她照样想退，手却先把盾摆到脸前。练完以后她还在解释刚才差点就能反击。阿飞把一束轻投枪递过来。她朝靶架扔出一枪，扎得不深，位置却对。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/javelin"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
