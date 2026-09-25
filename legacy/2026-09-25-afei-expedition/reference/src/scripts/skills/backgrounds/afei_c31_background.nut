this.afei_c31_background <- this.inherit("scripts/skills/backgrounds/character_background", {
 m={},
 function create() {
   this.character_background.create();
   this.m.ID="background.afei_c31";
   this.m.Name="bula · 核账的bula";
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription="要买可以，先告诉我这次能帮到谁。";
   this.m.GoodEnding="阿飞自己写出了粮药预算。她只圈出雨布下那包备用针线。";
   this.m.BadEnding="钱袋空了。账页上最后一笔没人来对。";
   this.m.HiringCost=0;this.m.DailyCost=16;this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.AllFemale;this.m.Hairs=this.Const.Hair.AllFemale;this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.Female;
 },
 function onBuildDescription() { return "bula替商旅保管过公用钱袋。大家总在路上忽然想买点什么，只有到晚上算账时才记起，那袋钱还得付下一座城的通行费。她不吝啬，却总要先问买来给谁、能够用多久。一次集市竞价，她没有抢最漂亮的披风，而是买下几件略旧的雨布。旅伴笑她不会享受，隔夜下雨，每个人却都能分到一块干燥的地方。阿飞招她时夸自己有大格局，她先让他报一下明天的粮钱。抹茶在旁边翻账本，大谋把想买的新斧放回架子。三个人重新算完，她才点头。"; },
 function onChangeAttributes() { return {Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}; },
 function onAddEquipment() { local items=this.getContainer().getActor().getItems();
        items.equip(this.new("scripts/items/weapons/javelin"));
        items.equip(this.new("scripts/items/armor/padded_surcoat"));
        items.equip(this.new("scripts/items/helmets/hood"));
        items.equip(this.new("scripts/items/shields/buckler_shield"));
 }
});
