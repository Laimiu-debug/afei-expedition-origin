this.afei_yueya_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_yueya";
   this.m.Name="小月牙 · 换靶的乐天派";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="招牌比摊子大三圈。先别扔，她觉得还能这么用。";
   this.m.GoodEnding="月牙的摊子重新开张。卖的是一路上修好的东西。";
   this.m.BadEnding="那只还能这么用的旧箱子，没能跟上队伍。";
   this.m.HiringCost=0;this.m.DailyCost=10;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小月牙的货摊只有两块木板，招牌却写得像能装下整座城。盐鱼、土豆、断了一截的绳子都摆在超市里那块旧牌下。客人说这也算超市，她说先从这些卖起。阿飞第一次来补给，险些被一袋换了名字的土豆说服。抹茶逐个问价，她也不恼，转身用短绳把歪斜的棚子固定好。起风时别家的木架倒了一排，她的锅还挂着。投掷试训第一枪扎在靶边的地上。旁人刚开口，她改投另一面靶，正好打中。再来一枪，又偏了。她蹲下把三根都捡回来，说现在知道哪里不能站了。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/javelin"));
        items.equip(this.new("scripts/items/armor/thick_tunic"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.addToBag(this.new("scripts/items/weapons/boar_spear"));
 }
});
