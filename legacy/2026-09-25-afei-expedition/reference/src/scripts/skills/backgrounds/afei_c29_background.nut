this.afei_c29_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c29";
   this.m.Name="一凹瑶 · 递棒的瑶瑶";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="先别抢，看看下一棒准备好了没有。";
   this.m.GoodEnding="她让最慢的新兵来敲铃。一整轮接力，没有一棒掉在地上。";
   this.m.BadEnding="木牌还在桌上。再没有人来接下一棒。";
   this.m.HiringCost=0;this.m.DailyCost=18;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "一凹瑶在城镇游艺棚主持过反应比赛。铃声一响，参赛者抢走桌上的木牌。她逐渐学会先看肩膀：有人还没伸手，动作已经写在那里。游艺棚被征作临时救护处后，木牌变成了药袋。她发现抢先伸手有时会挡住真正需要的人，便把比赛改成接力。谁先拿到不重要，最后那个人能不能接稳才重要。阿飞和抹茶去体验她的小游戏，一个输完坚持重来，一个开始研究铃铛。她把木牌放回桌上，问他们愿不愿意换一种玩法。那天最后赢的，是三个人一起把药袋送到了目的地。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/shortsword"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
