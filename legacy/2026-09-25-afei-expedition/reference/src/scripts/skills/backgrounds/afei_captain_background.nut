this.afei_captain_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_captain";
   this.m.Name="阿飞 · 空喊的团长";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="决心靠嗓门撑着，本事还在学。旗面很大，名册上只有三行。";
   this.m.GoodEnding="阿飞把黑旗收进行囊。告示上还写着嘉豪，底下补了日薪和出事了去哪找。据你所知，他后来很少再为自己喊。";
   this.m.BadEnding="阿飞的嗓门还在。旗帜不知落到哪条泥路上。";
   this.m.HiringCost=0;this.m.DailyCost=6;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllMale;this.m.Hairs=this.Const.Hair.AllMale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Muscular;
 },
 function onBuildDescription() { return "阿飞靠讲别人的战报换晚饭。哪支队伍捡过好甲，哪位大哥拿盾顶过巨兽，他讲得比当事人还细。有人问他自己打过什么，他就把嗓门再抬高一截。墙上贴着一张告示，只写了嘉豪两个字。出城前他试着把盾举满一刻钟，没到一半就开始哇哇叫。路过的人学他那一声吸气，管他们叫哇哇兄弟。大谋叫他放下。他问以后人多了还听不听得见。黑旗就是那天挂上车的。旗面很大，名册上只有三行。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/bludgeon"));
        items.equip(this.new("scripts/items/armor/thick_tunic"));
        items.equip(this.new("scripts/items/helmets/headscarf"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
