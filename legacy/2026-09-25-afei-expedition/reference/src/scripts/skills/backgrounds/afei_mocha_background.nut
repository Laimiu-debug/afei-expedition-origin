this.afei_mocha_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_mocha";
   this.m.Name="抹茶 · 算账的副队长";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="算完还要再数一遍。弓在后排，告示他先翻过来。";
   this.m.GoodEnding="抹茶合上账本。余料分给了新来的修理工。据你所知，账是平的。";
   this.m.BadEnding="账本停在某一页。没人再往下翻。";
   this.m.HiringCost=0;this.m.DailyCost=12;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllMale;this.m.Hairs=this.Const.Hair.AllMale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Muscular;
 },
 function onBuildDescription() { return "抹茶在地精商路的账房里长大，学会算盾牌损耗，比学会写自己的名字还早。第一本他自己经手的账里，货物有损耗，牲口有赔付，死在山口的车夫却只被划掉一天工钱。他算了三遍，在余白添上安葬费。账房主人撕了那页，连他一起赶走。到了烟港，别人找他算钱，算完还要自己再数一遍。他不急，收下该收的铜子，裂了柄的工具修到能用。阿飞来请他写招募告示，满嘴以后的人马，口袋里没几枚钱。他把羊皮纸翻过来，先算三个人能吃几天。阿飞嫌数字小。他把笔放下。过了一会儿那人回来，说那就从肯拿这份钱的人招起。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hunting_bow"));
        items.equip(this.new("scripts/items/armor/thick_tunic"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
        items.addToBag(this.new("scripts/items/weapons/knife"));
 }
});
