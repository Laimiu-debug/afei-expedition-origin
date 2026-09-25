this.afei_xiaoyu_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_xiaoyu";
   this.m.Name="小鱼贝壳 · 栈桥边的盾";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="最重的箱子她先上肩。栈桥外侧没人守，她把盾立过去。";
   this.m.GoodEnding="卸完最后一箱，小鱼把盾递给下一个人。该你接一会儿了。";
   this.m.BadEnding="栈桥外侧空了。潮水把那圈盾印冲平。";
   this.m.HiringCost=0;this.m.DailyCost=12;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "小鱼贝壳在旧码头抬货。招工的人一早就喊缺个最能扛的，喊到中午，最重的木箱还堆在原处。她等得不耐烦，先把箱子上了肩。有人拿唯一的男人逗她，她把空车推回去，让对方把第二箱也抬来。活做久了，她知道哪块木板踩上去会响，也知道有人嘴上说没事，手已经握不住绳。黑旗来接搬运契约时，阿飞的盾被行李卡住。她替他松开带扣，看见短栈桥外侧还没人守，便把自己的盾立过去。谈签约时她只提了一个要求：排守卫班次的人，也去那里站一次。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/blotched_gambeson"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
