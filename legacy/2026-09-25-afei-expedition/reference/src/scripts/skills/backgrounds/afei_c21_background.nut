this.afei_c21_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c21";
   this.m.Name="美伢 · 谢幕的舞者";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="你站这里，她才有地方把这一拍做完。";
   this.m.GoodEnding="美伢在排练表上给搬箱人也写了名字。谢幕时她第一个转身鼓掌。";
   this.m.BadEnding="舞跳完了。台侧的木板换成了新料。";
   this.m.HiringCost=0;this.m.DailyCost=14;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "美伢在行会宴厅跳过许多次大王舞。扮演大王的人每晚都换，灯光照向谁，谁便以为整场演出为自己而来。她记得的却是台侧的磨损木板，以及鼓手抬手前那一下吸气。一次城门戒严，客人急着离开，临时护卫挤在狭窄出口。她把最后一段舞改短，让端灯的人先过，再示意乐手搬开挡路的箱子。阿飞来招人的时候，先问她能不能再跳那支舞。她让他举着盾走过两把椅子，第三次仍撞上同伴。她说自己可以同行，但他得学会把看热闹的眼睛，分一点给队友脚下的位置。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/shortsword"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
