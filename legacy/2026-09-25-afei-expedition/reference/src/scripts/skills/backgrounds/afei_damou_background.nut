this.afei_damou_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_damou";
   this.m.Name="王大谋 · 顶盾的副队长";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="这事好办，我认识一个大哥。最不好抬的那一头，他留给自己。";
   this.m.GoodEnding="引荐过的人还在旗下。大谋自己也还站在前排。";
   this.m.BadEnding="箱子还稳稳地摞着。搬箱子的人没有回来。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllMale;this.m.Hairs=this.Const.Hair.AllMale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Muscular;
 },
 function onBuildDescription() { return "王大谋替商队装车，也替临时拼起来的护卫队找人。每到一个驿站，他总能指着远处说认识一个大哥：那个枪使得好，那个知道山路，那个拿了钱真肯站前面。别人笑他只会借人撑场，他把笑话听完，照样坐到对方的篝火边谈工钱。有一回，好不容易凑来的护卫还没出城，雇主便把约定的口粮减了一半。大谋替雇主解释到喉咙发干，最后发现自己连同那几个被说服的人，都成了拿不到足数薪水的笨蛋。他把佣金掏回桌上，扛起行李走了。阿飞招他时也说得很大。大谋只问两件事：来了算谁的人，走的时候能不能把钱结清。抹茶把团约递过来，两条都写着。他读完，把阿飞挡门的木箱搬开，先把最不好抬的那一头留给自己。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/padded_leather"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
