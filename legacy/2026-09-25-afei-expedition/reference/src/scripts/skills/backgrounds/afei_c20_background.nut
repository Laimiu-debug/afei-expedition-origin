this.afei_c20_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c20";
   this.m.Name="余想 · 最后一班的岗";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="这班我守。下一班你得真的派人来。";
   this.m.GoodEnding="接班的新人提前到了。余想喝完了那碗热汤，是热的。";
   this.m.BadEnding="岗册的最后一页停在她那一行。后面再没写名字。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "边城卫所裁撤时，余想的名字排在最后一页。前几页的人领走车马，最后一页的人负责把门锁好。她没拿到好甲，倒把每一班岗的交接都记了下来：谁会忘灯油，谁需要在天亮前换下来。她守过一条迟迟没有援军的街。敌人没有传闻里那么多，守门的人却一遍遍想象自己会死在那里。她挪开坏掉的长凳，让退下来的人有地方坐，自己把矛抵在门缝里，等到街外重新传来车轮声。后来有人夸她是顶天立地的老兵，她总要先问对方想让她多值几班。遇见阿飞时，她认得那种一紧张就提高嗓门的队长。她愿意再试一回，但替班时间必须写清楚。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/fighting_spear"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
