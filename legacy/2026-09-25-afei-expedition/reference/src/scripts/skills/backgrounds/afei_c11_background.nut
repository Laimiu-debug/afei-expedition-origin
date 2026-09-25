this.afei_c11_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c11";
   this.m.Name="川神 · 折图的老副将";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="图先拿着。真走到那里，再看脚下。";
   this.m.GoodEnding="川神把队形图传了下去。补丁朝外，那是用得最多的一面。";
   this.m.BadEnding="图还在。画图的人留在了上一条阵线。";
   this.m.HiringCost=0;this.m.DailyCost=18;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "川神替蓝旗商团排过路，也排过阵。图上每个人的位置都很整齐，真正走进山道，车轮会陷，马匹会惊，总有人比预计的慢。她最难忘的一次返程，不是遇上多强的敌人，而是自己坚持等所有人归位，错过了本来能先接走一队人的空当。蓝旗那段行程结束后，她还留着队形图。纸折得太多，中央裂开一道细口。联合护送时，她先问大谋哪一段最不好走，再让车队按实地调整。阿飞想把这次合作写成一场漂亮战报，她指着图中那道裂口说，先把当时怎么改的记下来。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/pitchfork"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/hood"));
 }
});
