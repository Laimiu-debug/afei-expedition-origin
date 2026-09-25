this.afei_c13_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c13";
   this.m.Name="大鹅 · 护箱的前锋";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="谁也别碰那口箱子。箱子里是大家的。";
   this.m.GoodEnding="大鹅把空箱子留在营地。都到了，箱子用不上了。";
   this.m.BadEnding="箱子被抬进了库房。守箱子的人留在了路上。";
   this.m.HiringCost=0;this.m.DailyCost=15;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "大鹅给蓝旗押过补给。她嗓门大，走得也直，别人把路堵住，她常把人连着自己的货一起往外推。一次卸货丢了箱，她追出去两条街，回来时队伍已经挪到另一个出口。找回的箱子里是锅、鞋底和几包旧绷带，赔不起她刚刚把人丢开的那段空当。小宁让她第二天先点人，她把箱单攥在手里，没有顶嘴。黑旗帮忙处理蓝旗遗落的物资时，大谋在旁边一起抬箱，小虎留在队尾，她才看见自己不用把所有方向都堵住。阿飞问愿不愿意一起押下一程，她先叫大家把箱子挪成一排，再站到队列最外侧。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/hatchet"));
        items.equip(this.new("scripts/items/armor/padded_leather"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
