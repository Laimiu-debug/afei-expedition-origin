this.afei_c32_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c32";
   this.m.Name="小宁 · 蓝旗的排阵人";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="她先数车轮，再数人。队形图上总留一条能让后来人跟上的路。";
   this.m.GoodEnding="小宁把旧队形图留在驿站，背面写着每个帮她改过路线的名字。";
   this.m.BadEnding="黑旗名册在这一行留下了空白。";
   this.m.HiringCost=0;this.m.DailyCost=18;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小宁曾替蓝旗商团排路。一次护送中，前车陷进沟里，后队却照着旧图继续走，差点把伤员落在雪地。她从此把空白留在图上，遇到坏路就让脚下的人先说话。黑旗与蓝旗同行时，她没有急着发令，只问大谋谁还没跟上。仗后她把图摊在火边，让每个站过前排的人补上一笔。阿飞问她要不要把名字写进黑旗，她把图卷起，说先等这趟车平安到站。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/pitchfork"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/hood"));
 }
});
