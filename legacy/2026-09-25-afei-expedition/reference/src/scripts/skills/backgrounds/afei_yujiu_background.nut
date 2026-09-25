this.afei_yujiu_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_yujiu";
   this.m.Name="余初九 · 数两遍的守夜人";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="嘴上说不管，数人时却一个也没落下。";
   this.m.GoodEnding="余九把守夜名单交给下一个人。这一夜她数了一遍就数对了。";
   this.m.BadEnding="她数完了所有人。唯独没数自己。";
   this.m.HiringCost=0;this.m.DailyCost=10;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "余初九做过渡口的守夜人。听见车轮就点灯，少收一枚钱要赔，多放一辆超载的车也要赔。她养成了一个习惯：先数上船的人，再听领队解释为何不必再数。嗓门也是这样练出来的，河对面听不见客气话。黑旗第一次到渡口，阿飞拿着一张过期的路图，指着已经废弃的浅滩说能省半天。余九隔着雾喊了两次，那边还在争。她划小船过来，把船桨横到车前。大谋先停下，阿飞才看见地图角落的年份。阿飞问她肯不肯给团里守夜。她问的是另一个问题：下回我喊停，你还听不听？说完又补一句，她只是怕车堵在渡口。那晚黑旗走后，最后一辆车的灯却一直有人替他们守着。抹茶把新路线抄进日志，阿飞在旁边写了一个听。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/ragged_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
