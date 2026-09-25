this.afei_c26_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c26";
   this.m.Name="芷芷 · 撑幕布的手";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="先别挤，这一侧给你们留出来了。";
   this.m.GoodEnding="再回渡口，新船夫已学会摆两列木箱。她把那面旧盾挎回了肩上。";
   this.m.BadEnding="幕布落了。撑幕布的手没能从架下抽出来。";
   this.m.HiringCost=0;this.m.DailyCost=17;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "芷芷跟着河岸戏班长大，最先学会的不是上台，而是起风时撑住幕布。演员嫌她挡光，搬运人却总先找她。她一伸手，晃得厉害的木架就能停下来。有一次渡船靠岸，人群挤在跳板上争先下船。她没有跟着喊，只把两只木箱横着摆开，让大家分两列走。船夫后来送她一面旧盾，说你站在那里，比我敲半天锣还管用。阿飞在临时舞台见到她时，先想请她表演。演出完毕，她却追着他问货车怎么编队，伤员从哪边经过。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/boar_spear"));
        items.equip(this.new("scripts/items/armor/gambeson"));
        items.equip(this.new("scripts/items/helmets/aketon_cap"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
 }
});
