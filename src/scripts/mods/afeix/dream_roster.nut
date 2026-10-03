// Frozen exhibition builds. The supplied temporary roster owns every actor;
// never call makeCharacter/onHired or write recruitment/story campaign flags.
local A = ::AfeixExpedition;
// BEGIN GENERATED DREAM ROSTER
A.DreamRoster <- {["schema"]=1,["level"]=11,["order"]=["afei","damou","mocha","bottle","shuaizi","lili","xiaoyueya","yuchujiu","xiaoyubeike","wangduidui"],["fields"]=["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"],["people"]={["afei"]={["name"]="阿飞",["role"]="可换路线的队长前排",["place"]=4,["level"]=11,["stars"]={["MeleeSkill"]=2,["MeleeDefense"]=2,["Bravery"]=2},["starting_attrs"]=[69,106,46,79,51,19,3,2],["trait_delta"]=[0,0,5,0,0,0,-5,-5],["allocation"]=[3,6,1,0,10,0,10,0],["level_rows"]=[{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[2,4,6],["gains"]=[4,3,3]}],["growth_gain"]=[9,18,4,0,30,0,30,0],["personal_choice"]=0,["personal_bonus"]=[0,0,2,0,2,0,0,0],["gifted_fields"]=[0,4,6],["gifted_bonus"]=[4,0,0,0,3,0,3,0],["base_attrs"]=[82,124,47,79,86,19,41,7],["fixed_traits"]=["cocky","bright"],["perks"]=["colossus","gifted","fast_adaption","mastery_sword","rotation","underdog","nimble","berserk","killing_frenzy","duelist"],["training"]="",["route"]="feidie",["equipment"]=[{["path"]="scripts/items/weapons/named/named_sword",["name"]="黑旗·归途",["stats"]={}},{["path"]="scripts/items/armor/named/named_noble_mail_armor",["name"]="阿飞·黑旗行装",["stats"]={["Condition"]=192,["ConditionMax"]=192,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/norse_helmet",["name"]="阿飞·归途盔",["stats"]={["Condition"]=150,["ConditionMax"]=150,["StaminaModifier"]=-5}},{["path"]="scripts/items/accessory/afeix_ecig_item",["name"]="",["stats"]={}}],["bag"]=[],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["damou"]={["name"]="王大谋",["role"]="相邻核心的单点护卫盾坦",["place"]=3,["level"]=11,["stars"]={["MeleeDefense"]=3,["Bravery"]=2,["Stamina"]=1},["starting_attrs"]=[59,100,48,96,56,32,6,2],["trait_delta"]=[10,10,0,0,0,0,0,0],["allocation"]=[9,5,6,0,0,0,10,0],["level_rows"]=[{["fields"]=[6,0,2],["gains"]=[3,3,4]},{["fields"]=[6,0,1],["gains"]=[4,3,3]},{["fields"]=[6,0,2],["gains"]=[3,3,4]},{["fields"]=[6,0,1],["gains"]=[4,3,4]},{["fields"]=[6,0,2],["gains"]=[3,3,4]},{["fields"]=[6,0,1],["gains"]=[4,3,3]},{["fields"]=[6,0,2],["gains"]=[3,3,4]},{["fields"]=[6,0,1],["gains"]=[4,3,4]},{["fields"]=[2,6,0],["gains"]=[4,3,3]},{["fields"]=[1,2,6],["gains"]=[3,4,4]}],["growth_gain"]=[27,17,24,0,0,0,35,0],["personal_choice"]=0,["personal_bonus"]=[0,3,0,0,0,0,2,0],["gifted_fields"]=[0,1,6],["gifted_bonus"]=[4,4,0,0,0,0,3,0],["base_attrs"]=[80,114,72,96,56,32,46,2],["fixed_traits"]=["strong","tough"],["perks"]=["colossus","gifted","shield_expert","taunt","rotation","steel_brow","underdog","battle_forged","indomitable","recover"],["training"]="borrow_strike",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_spear",["name"]="大谋·守夜",["stats"]={}},{["path"]="scripts/items/shields/named/named_full_metal_heater_shield",["name"]="大谋·不退壁盾",["stats"]={}},{["path"]="scripts/items/armor/named/brown_coat_of_plates_armor",["name"]="大谋·不退壁垒",["stats"]={["Condition"]=360,["ConditionMax"]=360,["StaminaModifier"]=-27}},{["path"]="scripts/items/helmets/named/named_metal_bull_helmet",["name"]="大谋·铁角守夜",["stats"]={["Condition"]=360,["ConditionMax"]=360,["StaminaModifier"]=-18}}],["bag"]=[],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=true},["mocha"]={["name"]="午夜抹抹茶",["role"]="远程支援队长与军需账房",["place"]=12,["level"]=11,["stars"]={["RangedSkill"]=2,["Bravery"]=1,["Stamina"]=1},["starting_attrs"]=[53,98,43,100,50,52,3,5],["trait_delta"]=[0,0,0,0,0,0,0,0],["allocation"]=[8,5,5,0,0,10,0,2],["level_rows"]=[{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,0,2],["gains"]=[4,3,3]},{["fields"]=[5,0,1],["gains"]=[4,3,4]},{["fields"]=[5,0,2],["gains"]=[4,3,4]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,0,2],["gains"]=[4,3,3]},{["fields"]=[5,0,1],["gains"]=[4,3,4]},{["fields"]=[5,2,7],["gains"]=[4,4,3]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[2,5,7],["gains"]=[3,4,3]}],["growth_gain"]=[24,17,17,0,0,40,0,6],["personal_choice"]=0,["personal_bonus"]=[0,4,2,0,0,0,0,0],["gifted_fields"]=[0,1,5],["gifted_bonus"]=[4,4,0,0,0,4,0,0],["base_attrs"]=[81,123,62,100,50,96,3,11],["fixed_traits"]=["bright","ailing"],["perks"]=["colossus","gifted","quick_hands","mastery_crossbow","bullseye","footwork","nimble","berserk","killing_frenzy","overwhelm"],["training"]="abacus_mark",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_crossbow",["name"]="抹茶·算无遗箭",["stats"]={}},{["path"]="scripts/items/ammo/quiver_of_bolts",["name"]="",["stats"]={}},{["path"]="scripts/items/armor/named/blue_studded_mail_armor",["name"]="抹茶·蓝墨账衣",["stats"]={["Condition"]=168,["ConditionMax"]=168,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/wolf_helmet",["name"]="抹茶·夜哨",["stats"]={["Condition"]=168,["ConditionMax"]=168,["StaminaModifier"]=-4}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_dagger",["name"]="抹茶·备用零件",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["bottle"]={["name"]="小酒瓶",["role"]="高命中斩刀决斗与破阵",["place"]=5,["level"]=11,["stars"]={["MeleeSkill"]=3,["MeleeDefense"]=3,["Stamina"]=3},["starting_attrs"]=[67,109,51,86,60,24,3,2],["trait_delta"]=[0,0,0,0,0,0,5,0],["allocation"]=[5,4,1,0,10,0,10,0],["level_rows"]=[{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[4,4,3]},{["fields"]=[4,6,1],["gains"]=[3,3,4]},{["fields"]=[4,6,0],["gains"]=[4,4,3]},{["fields"]=[4,6,1],["gains"]=[3,3,5]},{["fields"]=[4,6,0],["gains"]=[4,4,3]},{["fields"]=[4,6,1],["gains"]=[3,3,4]},{["fields"]=[4,6,0],["gains"]=[4,4,3]},{["fields"]=[4,6,1],["gains"]=[3,3,5]},{["fields"]=[2,4,6],["gains"]=[3,4,4]}],["growth_gain"]=[15,18,3,0,35,0,35,0],["personal_choice"]=0,["personal_bonus"]=[0,0,0,3,3,0,0,0],["gifted_fields"]=[0,4,6],["gifted_bonus"]=[4,0,0,0,3,0,3,0],["base_attrs"]=[86,127,54,89,101,24,36,2],["fixed_traits"]=["sure_footing","determined"],["perks"]=["colossus","gifted","fast_adaption","mastery_cleaver","rotation","underdog","nimble","berserk","killing_frenzy","duelist"],["training"]="bottle_breakthrough",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_cleaver",["name"]="瓶队·破阵斩刀",["stats"]={}},{["path"]="scripts/items/armor/named/black_leather_armor",["name"]="瓶队·决赛战衣",["stats"]={["Condition"]=138,["ConditionMax"]=138,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/wolf_helmet",["name"]="瓶队·追猎盔",["stats"]={["Condition"]=168,["ConditionMax"]=168,["StaminaModifier"]=-4}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_dagger",["name"]="瓶队·后手",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["shuaizi"]={["name"]="白小帅子",["role"]="局部疲劳支援与卡口盾卫",["place"]=2,["level"]=11,["stars"]={["MeleeDefense"]=2,["Bravery"]=1,["Hitpoints"]=1},["starting_attrs"]=[62,102,45,96,54,30,7,3],["trait_delta"]=[0,0,0,0,0,0,0,0],["allocation"]=[8,5,7,0,0,0,10,0],["level_rows"]=[{["fields"]=[6,0,2],["gains"]=[3,3,3]},{["fields"]=[6,0,2],["gains"]=[3,4,4]},{["fields"]=[6,0,1],["gains"]=[3,3,3]},{["fields"]=[6,0,2],["gains"]=[3,4,3]},{["fields"]=[6,0,1],["gains"]=[3,3,3]},{["fields"]=[6,2,0],["gains"]=[3,4,4]},{["fields"]=[6,1,2],["gains"]=[3,3,3]},{["fields"]=[6,0,1],["gains"]=[3,3,3]},{["fields"]=[2,6,0],["gains"]=[4,3,4]},{["fields"]=[1,2,6],["gains"]=[3,3,3]}],["growth_gain"]=[28,15,24,0,0,0,30,0],["personal_choice"]=0,["personal_bonus"]=[3,0,0,0,0,0,3,0],["gifted_fields"]=[0,1,6],["gifted_bonus"]=[4,4,0,0,0,0,3,0],["base_attrs"]=[97,121,69,96,54,30,43,3],["fixed_traits"]=["bright","insecure"],["perks"]=["colossus","gifted","shield_expert","taunt","rotation","steel_brow","underdog","battle_forged","indomitable","recover"],["training"]="drum",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_mace",["name"]="帅仔·定音锤",["stats"]={}},{["path"]="scripts/items/shields/named/named_golden_round_shield",["name"]="帅仔·鼓阵圆盾",["stats"]={}},{["path"]="scripts/items/armor/named/green_coat_of_plates_armor",["name"]="帅仔·鼓阵重甲",["stats"]={["Condition"]=384,["ConditionMax"]=384,["StaminaModifier"]=-33}},{["path"]="scripts/items/helmets/named/heraldic_mail_helmet",["name"]="帅仔·旌纹盔",["stats"]={["Condition"]=336,["ConditionMax"]=336,["StaminaModifier"]=-15}}],["bag"]=[],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=true},["lili"]={["name"]="李李超欧",["role"]="轻甲长弓与超距支援",["place"]=13,["level"]=11,["stars"]={["RangedSkill"]=2,["Initiative"]=1,["Bravery"]=1},["starting_attrs"]=[52,95,38,116,46,53,1,5],["trait_delta"]=[0,0,0,0,0,0,0,0],["allocation"]=[8,5,5,0,0,10,0,2],["level_rows"]=[{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,0,2],["gains"]=[4,3,3]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,0,2],["gains"]=[4,3,4]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,0,2],["gains"]=[4,3,3]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,2,7],["gains"]=[4,4,3]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[2,5,7],["gains"]=[3,4,3]}],["growth_gain"]=[24,15,17,0,0,40,0,6],["personal_choice"]=0,["personal_bonus"]=[0,0,0,3,0,3,0,0],["gifted_fields"]=[0,1,5],["gifted_bonus"]=[4,4,0,0,0,4,0,0],["base_attrs"]=[80,114,55,119,46,100,1,11],["fixed_traits"]=["lucky","optimist"],["perks"]=["colossus","gifted","quick_hands","mastery_bow","bullseye","footwork","nimble","berserk","killing_frenzy","overwhelm"],["training"]="chaoju",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_warbow",["name"]="李李·风中远声",["stats"]={}},{["path"]="scripts/items/ammo/quiver_of_arrows",["name"]="",["stats"]={}},{["path"]="scripts/items/armor/named/black_leather_armor",["name"]="李李·风中斗篷",["stats"]={["Condition"]=138,["ConditionMax"]=138,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/norse_helmet",["name"]="李李·听风盔",["stats"]={["Condition"]=150,["ConditionMax"]=150,["StaminaModifier"]=-5}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_dagger",["name"]="李李·脱困",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["xiaoyueya"]={["name"]="小月牙",["role"]="近距投掷转火手",["place"]=15,["level"]=11,["stars"]={["RangedSkill"]=2,["Initiative"]=2,["Hitpoints"]=1},["starting_attrs"]=[54,99,36,115,49,51,3,5],["trait_delta"]=[0,0,0,0,0,0,0,0],["allocation"]=[7,3,4,0,0,10,6,0],["level_rows"]=[{["fields"]=[5,0,6],["gains"]=[4,3,2]},{["fields"]=[5,0,6],["gains"]=[4,4,2]},{["fields"]=[5,0,2],["gains"]=[4,3,3]},{["fields"]=[5,0,6],["gains"]=[4,4,2]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[5,2,6],["gains"]=[4,3,2]},{["fields"]=[5,0,1],["gains"]=[4,4,3]},{["fields"]=[5,2,6],["gains"]=[4,3,2]},{["fields"]=[5,0,1],["gains"]=[4,3,3]},{["fields"]=[2,5,6],["gains"]=[3,4,2]}],["growth_gain"]=[24,9,12,0,0,40,12,0],["personal_choice"]=0,["personal_bonus"]=[0,0,0,4,0,2,0,0],["gifted_fields"]=[0,5,6],["gifted_bonus"]=[4,0,0,0,0,4,3,0],["base_attrs"]=[82,108,48,119,49,97,18,5],["fixed_traits"]=["gluttonous","optimist"],["perks"]=["colossus","gifted","quick_hands","mastery_throwing","bags_and_belts","footwork","nimble","berserk","killing_frenzy","duelist"],["training"]="supermarket",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_javelin",["name"]="小月牙·超市飞签",["stats"]={}},{["path"]="scripts/items/armor/named/named_plated_fur_armor",["name"]="小月牙·百货行囊",["stats"]={["Condition"]=156,["ConditionMax"]=156,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/norse_helmet",["name"]="小月牙·远行盔",["stats"]={["Condition"]=150,["ConditionMax"]=150,["StaminaModifier"]=-5}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_javelin",["name"]="小月牙·备用飞签",["stats"]={}},{["path"]="scripts/items/weapons/named/named_throwing_axe",["name"]="小月牙·拆货斧",["stats"]={}},{["path"]="scripts/items/weapons/named/named_dagger",["name"]="小月牙·开箱刀",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["yuchujiu"]={["name"]="余初九",["role"]="轻甲控场与换位救场",["place"]=6,["level"]=11,["stars"]={["MeleeSkill"]=2,["MeleeDefense"]=1,["Initiative"]=2},["starting_attrs"]=[61,99,45,117,55,31,5,5],["trait_delta"]=[0,0,0,-10,0,0,0,0],["allocation"]=[7,0,3,0,10,0,10,0],["level_rows"]=[{["fields"]=[4,6,0],["gains"]=[3,2,3]},{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,2,3]},{["fields"]=[4,6,0],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,2,3]},{["fields"]=[4,6,2],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,2,3]},{["fields"]=[4,6,2],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,2,3]},{["fields"]=[2,4,6],["gains"]=[3,3,3]}],["growth_gain"]=[21,0,9,0,30,0,25,0],["personal_choice"]=0,["personal_bonus"]=[0,0,4,0,0,0,2,0],["gifted_fields"]=[0,4,6],["gifted_bonus"]=[4,0,0,0,3,0,3,0],["base_attrs"]=[86,99,58,127,88,31,35,5],["fixed_traits"]=["loyal","hesitant"],["perks"]=["colossus","gifted","dodge","relentless","mastery_mace","underdog","nimble","berserk","killing_frenzy","duelist"],["training"]="guard_swap",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_mace",["name"]="初九·叫停之锤",["stats"]={}},{["path"]="scripts/items/armor/named/blue_studded_mail_armor",["name"]="初九·接应锁衣",["stats"]={["Condition"]=168,["ConditionMax"]=168,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/norse_helmet",["name"]="初九·归队盔",["stats"]={["Condition"]=150,["ConditionMax"]=150,["StaminaModifier"]=-5}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_dagger",["name"]="初九·归队",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false},["xiaoyubeike"]={["name"]="小鱼贝壳",["role"]="稳健重甲双手低耗前排",["place"]=7,["level"]=11,["stars"]={["MeleeSkill"]=2,["Hitpoints"]=2,["MeleeDefense"]=1},["starting_attrs"]=[65,108,48,77,55,30,5,0],["trait_delta"]=[0,0,0,0,0,0,0,0],["allocation"]=[5,3,2,0,10,0,10,0],["level_rows"]=[{["fields"]=[4,6,0],["gains"]=[3,2,4]},{["fields"]=[4,6,0],["gains"]=[3,3,4]},{["fields"]=[4,6,0],["gains"]=[3,2,4]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,0],["gains"]=[3,2,4]},{["fields"]=[4,6,1],["gains"]=[3,3,3]},{["fields"]=[4,6,2],["gains"]=[3,2,3]},{["fields"]=[4,6,0],["gains"]=[3,3,4]},{["fields"]=[4,6,1],["gains"]=[3,2,3]},{["fields"]=[2,4,6],["gains"]=[3,3,3]}],["growth_gain"]=[20,9,6,0,30,0,25,0],["personal_choice"]=0,["personal_bonus"]=[3,5,0,0,0,0,0,0],["gifted_fields"]=[0,1,6],["gifted_bonus"]=[4,4,0,0,0,0,3,0],["base_attrs"]=[92,126,54,77,85,30,33,0],["fixed_traits"]=["determined","loyal"],["perks"]=["colossus","gifted","pathfinder","mastery_axe","steel_brow","underdog","battle_forged","brawny","quick_hands","fortified_mind"],["training"]="nicotine",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/named/named_greataxe",["name"]="小鱼·踏浪巨斧",["stats"]={}},{["path"]="scripts/items/armor/named/leopard_armor",["name"]="小鱼·踏浪兽甲",["stats"]={["Condition"]=348,["ConditionMax"]=348,["StaminaModifier"]=-26}},{["path"]="scripts/items/helmets/named/golden_feathers_helmet",["name"]="小鱼·潮羽盔",["stats"]={["Condition"]=288,["ConditionMax"]=288,["StaminaModifier"]=-12}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_dagger",["name"]="小鱼·余力",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=true},["wangduidui"]={["name"]="王怼怼",["role"]="副旗手与接班指挥",["place"]=14,["level"]=11,["stars"]={["Bravery"]=2,["Initiative"]=1,["Hitpoints"]=1},["starting_attrs"]=[55,98,55,106,52,35,4,3],["trait_delta"]=[0,0,5,0,0,0,0,0],["allocation"]=[8,6,10,0,6,0,0,0],["level_rows"]=[{["fields"]=[2,0,1],["gains"]=[4,3,3]},{["fields"]=[2,0,4],["gains"]=[4,4,2]},{["fields"]=[2,0,1],["gains"]=[4,3,3]},{["fields"]=[2,0,4],["gains"]=[4,4,2]},{["fields"]=[2,0,1],["gains"]=[4,3,3]},{["fields"]=[2,4,0],["gains"]=[4,2,4]},{["fields"]=[2,1,4],["gains"]=[4,3,2]},{["fields"]=[2,0,1],["gains"]=[4,3,3]},{["fields"]=[2,4,0],["gains"]=[4,2,4]},{["fields"]=[1,2,4],["gains"]=[3,4,2]}],["growth_gain"]=[28,18,40,0,12,0,0,0],["personal_choice"]=0,["personal_bonus"]=[0,0,5,0,0,0,0,0],["gifted_fields"]=[0,1,2],["gifted_bonus"]=[4,4,4,0,0,0,0,0],["base_attrs"]=[87,120,99,106,64,35,4,3],["fixed_traits"]=["brave","loyal"],["perks"]=["colossus","rally_the_troops","gifted","fortified_mind","mastery_polearm","rotation","nimble","fearsome","recover","bags_and_belts"],["training"]="dui_sentence",["route"]="normal",["equipment"]=[{["path"]="scripts/items/weapons/afeix_dream_warbanner",["name"]="黑旗·梦中誓言",["stats"]={}},{["path"]="scripts/items/armor/named/named_noble_mail_armor",["name"]="怼怼·传令旗衣",["stats"]={["Condition"]=192,["ConditionMax"]=192,["StaminaModifier"]=-8}},{["path"]="scripts/items/helmets/named/wolf_helmet",["name"]="怼怼·号令盔",["stats"]={["Condition"]=168,["ConditionMax"]=168,["StaminaModifier"]=-4}}],["bag"]=[{["path"]="scripts/items/weapons/named/named_battle_whip",["name"]="怼怼·传令鞭",["stats"]={}},{["path"]="scripts/items/tools/reinforced_throwing_net",["name"]="怼怼·救场网",["stats"]={}}],["level_bonus"]=[0,0,0,0,0,0,0,0],["heavy"]=false}},["accounting"]="Ten native level-ups, 30 selections; Gifted separately spends 3 unstarred maximum rolls. Starting values include fixed traits; base_attrs subtract their delta once. Personal choice is a frozen dream example. Promotion and level bonuses remain native skills. Named weapons, armor, helmets and shields use native art; ammunition and utility tools keep their native type.",["source"]="docs/design/balance-v2/proposal.json"};
// END GENERATED DREAM ROSTER

A.withDreamConstructionRandom <- function(seed, callback) {
    // Native creation (appearance, backgrounds and named rolls) is synchronous.
    // A small bounded local generator avoids advancing the campaign RNG and
    // still gives native rejection loops a changing sequence. Never set a seed.
    local original = ::Math.rand, state = (seed % 65521).tointeger();
    ::Math.rand = function(low = null, high = null) {
        // Native actor.setDirty calls rand() while roster.create initializes
        // the player. Those draws need a nonnegative local value too.
        if ((low == null) != (high == null) || (low != null && high < low)) throw "Invalid dream random range";
        state = (state * 251 + 67) % 65521;
        return low == null ? state : low + state % (high - low + 1);
    };
    try {
        local result = callback();
        ::Math.rand = original;
        return result;
    } catch (error) {
        ::Math.rand = original;
        throw error;
    }
};

A.makeDreamItem <- function(definition) {
    local item = ::new(definition.path);
    if (definition.name != "") item.m.Name = definition.name;
    foreach (field, value in definition.stats) {
        // Native inherit resolves parent m slots through _get/_set; `in`
        // only checks local slots and rejects valid armor/helmet properties.
        try { local nativeValue = item.m[field]; }
        catch (error) { throw "Unknown dream item property: " + field; }
        item.m[field] = value;
    }
    // Every temporary dream item stays inside its owning temporary actor.
    item.m.IsDroppedAsLoot = false;
    return item;
};

A.makeDreamCharacter <- function(key, roster, place = null) {
    if (roster == null || !(key in this.DreamRoster.people) || !(key in this.Characters)) return null;
    // A caller must pass a temporary roster, never the player's real roster.
    if (roster == ::World.getPlayerRoster()) throw "Dream actor requires a temporary roster";
    local A = this, d = this.DreamRoster.people[key], bro = null, seed = 917;
    foreach (i, ch in key) seed += (i + 1) * ch;
    try {
        return this.withDreamConstructionRandom(seed, function() {
            bro = roster.create("scripts/entity/tactical/player");
            // Construction finishes before session.actors receives this actor.
            // Apply the same display preference before the first equip callback,
            // rather than hiding a previously visible helmet on a weapon swap.
            bro.m.IsHidingHelmet = A.get("hide_helmets", true);
            local flags = bro.getFlags();
            flags.set("afeix_dream_actor", true);
            bro.setStartValuesEx([A.characterBackgroundPath(key)], false);
            bro.getItems().clear();
            bro.setName(d.name);
            bro.setTitle("梦中同行 · " + d.role);
            flags.set("afeix_character", key);
            flags.set("afeix_schema", A.Schema);
            flags.set("afeix_dream_route", d.route);
            flags.set("afeix_dream_personal_choice", d.personal_choice);
            flags.set("afeix_training_choice", d.training);
            flags.set("afeix_balance_v18", true);
            flags.set("afeix_balance_v26", true);
            flags.set("afeix_endgame_revision", 1);
            flags.set("afeix_talent_revision", A.TalentRevision);
            if (key == "damou") flags.set("afeix_damou_balance_v17", true);
            local properties = bro.getBaseProperties(), talents = bro.getTalents();
            foreach (i, field in A.DreamRoster.fields) properties[field] = d.base_attrs[i];
            talents.resize(::Const.Attributes.COUNT, 0);
            foreach (i, value in talents) talents[i] = 0;
            foreach (field, stars in d.stars) talents[::Const.Attributes[field == "Stamina" ? "Fatigue" : field]] = stars;
            bro.m.Level = 11;
            bro.m.XP = ::Const.LevelXP[10];
            bro.m.LevelUps = 0;
            bro.m.PerkPoints = 0;
            bro.m.PerkPointsSpent = 10;
            bro.m.Attributes = [];
            bro.m.HireTime = ::Time.getVirtualTimeF();
            local skills = bro.getSkills();
            // Fixed native traits are already subtracted in base_attrs; their
            // real hooks now restore exactly the intended displayed bonuses.
            foreach (trait in d.fixed_traits) skills.add(::new(A.BalanceV26.traits[trait].path));
            foreach (perk in d.perks) {
                local skill = ::new("scripts/skills/perks/perk_" + perk);
                // Gifted's three selections are frozen separately. Do not add
                // another level-up row or leave unspent points in the dream.
                if (perk == "gifted") skill.m.IsApplied = true;
                skills.add(skill);
            }
            if (d.level_bonus[1] > 0) skills.add(::new("scripts/skills/traits/afeix_endurance"));
            if (d.training != "") {
                local definition = A.MemberSkillDefs[d.training], extra = "extended" in definition && definition.extended;
                local skill = ::new("scripts/skills/" + (definition.active ? (extra ? "actives/afeix_catalog_active" : "actives/afeix_member_active") : (extra ? "traits/afeix_catalog_passive" : "traits/afeix_member_passive")));
                skill.configure(d.training);
                skills.add(skill);
            }
            if (d.route == "feidie") {
                local skill = ::new("scripts/skills/actives/afeix_feidie");
                // Keep AP/fatigue/cooldown/use limits; dream calls do not spend
                // the real company's crowns. Route reads use the dream session.
                skill.m.GoldCost = 0;
                skill.m.Description = "梦中号令：2格内最多3名队员（含自己）双攻+5、决心+5至各自下次回合结束；自己近防-3至下次回合开始。每战2次、冷却4轮。";
                skills.add(skill);
                skills.add(::new("scripts/skills/traits/afeix_promotion_trait"));
            }
            foreach (equipment in d.equipment) if (!bro.getItems().equip(A.makeDreamItem(equipment))) throw "Dream equipment rejected: " + equipment.path;
            foreach (equipment in d.bag) if (!bro.getItems().addToBag(A.makeDreamItem(equipment))) throw "Dream bag rejected: " + equipment.path;
            if ("syncCharacterArt" in A) A.syncCharacterArt(bro);
            skills.update();
            bro.setHitpoints(bro.getHitpointsMax());
            bro.setFatigue(0);
            bro.setPlaceInFormation(place == null ? d.place : place);
            return bro;
        });
    } catch (error) {
        if (bro != null) roster.remove(bro);
        throw error;
    }
};

A.buildDreamRoster <- function(roster) {
    local actors = [];
    try {
        foreach (key in this.DreamRoster.order) {
            local actor = this.makeDreamCharacter(key, roster);
            if (actor == null) throw "Dream roster member could not be created: " + key;
            actors.push(actor);
        }
    } catch (error) {
        // Do not clear the temporary roster: an unrelated hire can own entries.
        foreach (actor in actors) roster.remove(actor);
        throw error;
    }
    return actors;
};
