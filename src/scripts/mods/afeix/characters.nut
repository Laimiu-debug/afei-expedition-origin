// Fictional recruitment scenes for the mod; these are not real-life biographies.
// Prototype level-1 balance only. Source groups follow the user's 2026-09-28 correction.
// Ordinary backgrounds, talents and equipment do not impose a class, species or exclusive skill.
// Stable keys preserve saves when the production roster order changes.
local A = ::AfeixExpedition;
A.CharacterOrder <- ["afei", "damou", "mocha", "bottle", "shuaizi", "lili", "xiaoyueya", "yuchujiu", "xiaoyubeike", "wangduidui", "laocai", "yanzi", "tiantong", "xiaoning", "xiaopangxu", "dae", "manyuemei", "xiaohani", "keke", "yuxiang", "tongzhu", "meiya", "wanshe", "tutu", "naigai", "xiaojie", "bula", "suwa", "qianhan", "wangdazhi", "yaoyaoya", "yangmiemie", "songnuanyang", "xiaogui"];
A.Characters <- {
    afei = {
        name = "阿飞", title = "队长", isCaptain = true, hireCost = 0, wage = 8,
        background = "daytaler_background", role = "前期薄弱，保留后续成长空间",
        description = "黑旗还没招满人，阿飞已经把“嘉豪”二字写得比招募价还大。披风要体面，站相要威风，可盾牌一压下来，最先哇哇叫的也是他。营里有人背地里叫他蛤蟆，他纠正过好几回：是玉面蟾蜍。眼下大谋顶在前面，抹茶管着饭钱，他还撑不起嘴里那支远征团。不过真有雇主拿兄弟们的命去赌排场，这张爱笑的脸会一下子冷下来。",
        attrs = [46, 88, 28, 92, 41, 30, 0, 0],
        stars = { MeleeSkill = 2, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/bludgeon", "armor/thick_tunic", "helmets/headscarf", "shields/buckler_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = null,
        encounterText = null,
        encounterChoices = null
    },
    damou = {
        name = "王大谋", title = "队长", isCaptain = true, hireCost = 0, wage = 15,
        background = "militia_background", role = "开局强势的前排盾卫，近防与决心成长",
        description = "王大谋进酒馆先看谁的盾磨得最狠，出门时多半又认了一位大哥。“借我一招”刚说完，下一句就是“要不要来我们旗下”。营里笑他偷大哥，他也不恼，拉张凳子接着问。真到要命的时候，最先横过去的还是他那面盾。阿飞握反了盾带，他能嫌弃半天，也能陪练半天。",
        attrs = [55, 96, 41, 97, 55, 33, 4, 2],
        stars = { MeleeDefense = 3, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/boar_spear", "armor/padded_leather", "helmets/aketon_cap", "shields/wooden_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = null,
        encounterText = null,
        encounterChoices = null
    },
    mocha = {
        name = "午夜抹抹茶", title = "队长", isCaptain = true, hireCost = 0, wage = 10,
        background = "poacher_background", role = "普通水平的后排帮手",
        description = "阿飞讲远征，午夜抹抹茶算晚饭。地精算盘一响，豪言壮语就得折成克朗、口粮和修盾钱，营里干脆叫他老地精。哪种怪物怕火、哪条路收过路费，问他准没错，问多了还要挨他两句损。雇主说“顺手的事”，他添一笔；团长说“将来”，他先问今天谁付账。真有人欠了兄弟们的工钱，他能追得对方连酒都喝不安稳。",
        attrs = [53, 96, 41, 99, 50, 51, 3, 2],
        stars = { RangedSkill = 1, Bravery = 1 },
        equipment = ["weapons/hunting_bow", "armor/thick_tunic", "helmets/headscarf", "ammo/quiver_of_arrows"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = null,
        encounterText = null,
        encounterChoices = null
    },
    bottle = {
        name = "小酒瓶", title = "蛤妈", isCaptain = false, hireCost = 220, wage = 10,
        background = "daytaler_background", role = "九星核心：近攻、近防与决心；帮助阿飞成长",
        description = "小酒瓶看缺口，比阿飞喊冲锋还快。营里踢球她一个人能进一筐，大家都叫她瓶队，团长的指挥她听一半，进球倒一个不少。“蛤妈”这外号她早听惯了，阿飞走歪了，她推一把也不嫌麻烦。那辆旧自行车掉过好几回链子，两人记得的事却不止修车。",
        attrs = [54, 96, 42, 98, 55, 36, 4, 2],
        stars = { MeleeSkill = 3, MeleeDefense = 3, Bravery = 3 },
        equipment = ["weapons/shortsword", "armor/ragged_dark_surcoat", "helmets/hood", "shields/wooden_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = "这回先接住",
        encounterText = "小酒瓶用鞋尖停住一只旧皮球，听阿飞夸完瓶队，轻轻一拨，球滚到他脚下。他下意识让了半步。\n\n“以后带人，也这么让？”她抱着胳膊等他回答。旧自行车靠在墙边，车铃底下压着一张修车单。",
        encounterChoices = [
            { label = "接住球，好好回答她。（原价邀请）", outcome = "阿飞把球停稳，又拨回她脚边：“这回接着了。”小酒瓶笑了一声，算是认了这句话。", cost = 0, hireDiscount = 0 },
            { label = "替她付了修车钱。（招募优惠）", outcome = "修车钱付清，小酒瓶拨了两下车铃，挺响。“这个我收了。球嘛，下回还得你自己接。”", cost = 50, hireDiscount = 80 }
        ]
    },
    shuaizi = {
        name = "白小帅子", title = "远征团队员", isCaptain = false, hireCost = 200, wage = 9,
        background = "militia_background", role = "可培养的持盾前排",
        description = "白小帅子守门之前，要摸一遍门闩、试一遍盾带，再看看身边有没有人。冷不丁一声响，她自己先抖一下，眼圈说红就红。可真打起来，她那张战斗脸能把半个营地的人都镇住。打鼓发信号是她的活，四下一声不能少，阿飞抢跑了也得被她叫回来等第四拍。",
        attrs = [56, 97, 43, 97, 53, 33, 6, 3],
        stars = { MeleeDefense = 2, Bravery = 1 },
        equipment = ["weapons/shortsword", "armor/padded_surcoat", "shields/wooden_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = "请等第四下",
        encounterText = "鼓才敲到第三下，阿飞就应了一声“好”。白小帅子手一抖，鼓槌横在门闩上：“第四下呢？”旁边交班的人憋笑憋得肩膀直抖。\n\n她那面鼓的鼓带裂了，用旧绳胡乱系着，门闩也松了。",
        encounterChoices = [
            { label = "等第四下，再把信号复述一遍。（原价邀请）", outcome = "第四声落下，阿飞才一字不差地复述了信号。帅子点点头：“以后都这么等。”说完才让开门口。", cost = 0, hireDiscount = 0 },
            { label = "出钱修好鼓带和门闩。（招募优惠）", outcome = "修补钱付清，帅子把账条叠好收起。阿飞刚想开口，她又把鼓槌举了起来。行吧，团长再等一拍。", cost = 40, hireDiscount = 60 }
        ]
    },
    lili = {
        name = "李李超欧",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 260,
        wage = 10,
        background = "poacher_background",
        role = "弓箭与先手成长",
        description = "高背椅一摆，弓一拿，李李超欧就等着有人喊她一声超巨。她会抢风头，也会一转身躲出灯外，让盯着她的人扑个空。什么活都想往自己身上揽，射偏的箭也自己认。她常说来这儿开心就好，可谁拿成绩挑衅她，回来得最快的也是她。黑旗想拿她当招牌，最好先给她留好上场的位置。",
        attrs = [49, 92, 36, 112, 47, 49, 2, 4],
        stars = { RangedSkill = 2, Initiative = 1 },
        equipment = ["weapons/short_bow", "ammo/quiver_of_arrows", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "超巨这张椅子",
        encounterText = "阿飞正琢磨那把高背椅怎么装上车，李李超欧已经绕到椅子后面：“你是来请超巨的，还是来搬家具的？”她把弓拿起来，等他重说一遍。\n\n椅子腿是歪的，弓弦也起了毛。",
        encounterChoices = [
            { label = "请会射箭的超巨。（原价邀请）", outcome = "“这句还像话。”她把椅子挪开半步，让阿飞看清那张弓。上不上场的事，她要了一句准话才肯放人。", cost = 0, hireDiscount = 0 },
            { label = "出钱修椅子腿和弓弦。（招募优惠）", outcome = "修理钱付清，李李笑着收下这份捧场。“下一箭是不是欧气，到时候再看。”", cost = 50, hireDiscount = 80 }
        ]
    },
    xiaoyueya = {
        name = "小月牙",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 240,
        wage = 9,
        background = "daytaler_background",
        role = "投掷与灵活换位倾向",
        description = "两块木板一拍，小月牙的“超市里”就开张了。旧扣子、断绳头、歪木片，在她眼里都是还没找到用处的好东西。阿飞刚听懂一个主意，她已经拿着木杆比划下一个。抹茶让她报账，她就一件件演示，连试坏的零件也要再上一次架。跟她同行，收拾行囊得慢一点，那声“先别扔”总会从身后追上来。",
        attrs = [50, 95, 34, 114, 46, 45, 3, 5],
        stars = { RangedSkill = 1, Initiative = 2 },
        equipment = ["weapons/javelin", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "欢迎光临超市里",
        encounterText = "两块木板一拍，小月牙请阿飞逛她的“超市里”。半个摊子被招牌挡着，货只有扣子、绳头和木片。抹茶问这些有什么用，她捡起一枚铜扣，把松掉的招牌角卡住：“这不就用上了？”\n\n招牌还歪着，几样旧工具也该修了。",
        encounterChoices = [
            { label = "听她把铜扣的新用法讲完。（原价邀请）", outcome = "铜扣先卡了招牌，又成了收绳的扣环，小月牙越讲越来劲。阿飞低头看看自己的行囊，忽然觉得里面大概也有不少货。", cost = 0, hireDiscount = 0 },
            { label = "出钱修招牌和旧工具。（招募优惠）", outcome = "修整钱付清，小月牙把账条递给抹茶：“超市里，欢迎查账！”招牌总算不歪了。", cost = 40, hireDiscount = 60 }
        ]
    },
    yuchujiu = {
        name = "余初九",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 280,
        wage = 10,
        background = "poacher_background",
        role = "近攻与先攻二星、近防一星；灵活近战",
        description = "余初九一开口，队尾都听得清清楚楚。阿飞说到兴头上，她照样敢喊停，接着问路探了没有、人点齐了没有。有人笑她像只看门小狗，她连那人一块儿点名，一个都不肯漏。回营先数人，再数战利品，团长也得亲口应一声。当面顶得阿飞说不出话的是她，转头替他盯住后路的也是她。",
        attrs = [48, 91, 42, 112, 45, 43, 3, 5],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Initiative = 2 },
        equipment = ["weapons/throwing_axe", "shields/buckler_shield", "armor/thick_tunic", "helmets/hood"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "听见就应一声",
        encounterText = "渡口边，余初九拿船桨压住一张旧图：“先看年份。”阿飞刚要说近路，她又让他把水位标记指出来。河风一吹，她那几句话整个码头都听见了。\n\n新路图已经找人核过，核图的钱还没结。",
        encounterChoices = [
            { label = "收起旧图，把她的话听完。（原价邀请）", outcome = "阿飞一条条答清楚，余初九才挪开船桨。走出两步又喊：“旧的那张别拿！”团长应得很响，整个渡口都听见了。", cost = 0, hireDiscount = 0 },
            { label = "付了核图的钱。（招募优惠）", outcome = "核图钱付清，余初九把新图卷好，最后又叮嘱一遍：“往后听见我喊停，记得应一声。”阿飞这回没装听不见。", cost = 60, hireDiscount = 90 }
        ]
    },
    xiaoyubeike = {
        name = "小鱼贝壳",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 300,
        wage = 11,
        background = "daytaler_background",
        role = "近攻与生命二星、近防一星；耐打的近战队员",
        description = "栈桥外侧一空，小鱼贝壳先把盾顶过去，话等站稳了再说。有人叫她“唯一的男人”，她随口接一句：“行，下回你来当。”抡起锤子来她不讲究，一口气撑不住了，也会直说要人替班。阿飞讲大计划，她只看旁边那一步谁来站。",
        attrs = [59, 100, 36, 85, 48, 31, 4, 0],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Hitpoints = 2 },
        equipment = ["weapons/bludgeon", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 1,
        encounterTitle = "空着的那一步",
        encounterText = "桥头摆着两面旧盾，小鱼贝壳用脚尖点了点空着的外侧。阿飞夸她靠得住，是条汉子，她看了眼另一面盾：“夸完了，这儿能多站一个人吗？”\n\n扶绳松了，盾带也磨得快断了。",
        encounterChoices = [
            { label = "站到外侧，把轮换说清楚。（原价邀请）", outcome = "阿飞走过去，把换班的时辰说定。小鱼顺手掰正了他举盾的姿势：“大哥先练这一步。”", cost = 0, hireDiscount = 0 },
            { label = "出钱修扶绳和盾带。（招募优惠）", outcome = "修补钱付清，小鱼看过收据，点了点头。扶绳修好了，谁来接盾还按刚才说的算。", cost = 60, hireDiscount = 90 }
        ]
    },
    wangduidui = {
        name = "王怼怼",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 280,
        wage = 10,
        background = "militia_background",
        role = "决心与先攻较均衡",
        description = "阿飞一嗓子能把王怼怼吓一跳，可她回过神来，三个问题就能把团长问住：去哪儿，干什么，谁接应？营里管她叫太子，还给她编了顶歪王冠，她把王冠往椅背上一挂，接着等答案。她总说自己倒霉，走路踩坑、抽签抽短，可该问的一句也没漏过。想让她少怼一句不难，把上一句说全就行。",
        attrs = [52, 96, 45, 108, 52, 36, 4, 3],
        stars = { Bravery = 2, Initiative = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 1,
        encounterTitle = "太子不接糊涂口信",
        encounterText = "传令牌一翻，背面写着三个问题。阿飞把集合地点说出了两个版本，王怼怼当场停住脚。旁人递来那顶歪王冠，她挂到椅背上：“先答这个。”\n\n那条糊涂口信还没人核对过，核对的钱也没人认。",
        encounterChoices = [
            { label = "把集合安排一条条说清。（原价邀请）", outcome = "三个问题答完，怼怼才把令牌翻回来。“下回也这么说。”王冠还挂在椅背上，团长倒被她安排得明明白白。", cost = 0, hireDiscount = 0 },
            { label = "付了核对口信的钱。（招募优惠）", outcome = "钱付清，怼怼把条件从头念了一遍。“这回没有第三个集合点了吧？”", cost = 50, hireDiscount = 80 }
        ]
    },
    laocai = {
        name = "老蔡",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 440,
        wage = 14,
        background = "militia_background",
        role = "稳健前排盾卫，近防、决心与生命成长",
        description = "老蔡，也有人叫他川神。听完别人的计划，他往往先把地图上的那座桥抽走，阿飞的豪言还没说完，队尾已经困在了对岸。他话不多，坏消息却总能点到具体的位置上，最后翻过那面留在险处的木旗，背面常写着他自己的名字。据说他跟阿飞在擂台上打过一场，两人至今都说是自己赢了。",
        attrs = [55, 99, 48, 97, 58, 37, 5, 3],
        stars = { MeleeDefense = 3, Bravery = 2, Hitpoints = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/padded_surcoat", "helmets/aketon_cap"],
        bag = ["weapons/warfork"],
        chapter = 2,
        encounterTitle = "先抽掉这座桥",
        encounterText = "阿飞刚说这趟稳妥，老蔡就把桌上代表桥的木块抽走了。几面队尾的小木旗留在对岸，最后那面翻过来，背面写着老蔡自己的名字。\n\n“桥没了，谁去接人？”他把一张地形图的查阅账单推到一边，等阿飞回答。",
        encounterChoices = [
            { label = "把队尾和接应说明白。（原价邀请）", outcome = "两人把几种走法都摆了一遍，老蔡才收起木旗。那块桥木还留在桌边，提醒团长别只记着最好走的那条路。", cost = 0, hireDiscount = 0 },
            { label = "替他付了查图的钱。（招募优惠）", outcome = "查图钱付清，老蔡点点头，把写着自己名字的木旗推到了接应的位置上。", cost = 70, hireDiscount = 100 }
        ]
    },
    yanzi = {
        name = "眼子",
        title = "远征团队员",
        aliases = ["刘佳俊", "眼子"],
        isCaptain = false,
        hireCost = 380,
        wage = 12,
        background = "militia_background",
        role = "后排多功能长柄投掷手",
        description = "刘佳俊，大家都叫他眼子。两拨人吵得要掀桌，他一句玩笑先把人劝回凳子上，等笑声落了，再把漏掉的货、说不清的交接一项项对清。他自认长得不错，这话他自己说过不止一遍。嘴上常叫人滚，真有人找他，他回得比谁都快。只是难事递得多了，他也开始在单子上添时辰、添酬劳，阿飞再想光凭交情请他帮忙，得多坐一会儿。",
        attrs = [56, 101, 48, 106, 57, 40, 7, 5],
        stars = { MeleeDefense = 1, Bravery = 1, RangedDefense = 1 },
        equipment = ["weapons/shortsword", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 2,
        encounterTitle = "玩笑说完以后",
        encounterText = "两个雇工把货单拍得啪啪响，棍子都抄起来了。眼子讲了句玩笑，等两人都笑出声，才把单子摊到桌子中间：“笑完了，少的这几箱呢？”\n\n要请外人来复核，还得另付一笔钱，这钱他本来打算自己掏。",
        encounterChoices = [
            { label = "陪他把交接一起核清。（原价邀请）", outcome = "数目对上了，两人各自按了手印。眼子这才把刚才那个笑话讲完：“肯一起对账的人，这桌还坐得下。”", cost = 0, hireDiscount = 0 },
            { label = "替他付了复核的钱。（招募优惠）", outcome = "复核钱付清，双方都认了结果。眼子省下这一笔，心情不错，收单前还是盯着两人把名字签全了。", cost = 60, hireDiscount = 90 }
        ]
    },
    tiantong = {
        name = "小虎",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 340,
        wage = 11,
        background = "poacher_background",
        role = "稳定弓手与决心成长",
        description = "小虎应声的时候，手已经把蓝旗信袋又摸了一遍。掌柜愿意提前盖回执，她偏要问信到底交到了谁手里。跑得快她高兴，送得准才肯拿钱。带上弓以后这习惯也没改，走出一段总要回头看看队尾。谁想把没办完的事说成办妥了，她会把回执推回去。还有，别碰她的点心。",
        attrs = [50, 93, 43, 106, 46, 53, 2, 5],
        stars = { RangedSkill = 2, Bravery = 1 },
        equipment = ["weapons/hunting_bow", "ammo/quiver_of_arrows", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "盖了印也不算送到",
        encounterText = "掌柜催小虎来领钱，桌上的回执早就盖好了印。她却从蓝旗信袋里摸出那封没送出去的信：“收信的人呢？”掌柜不吭声了。\n\n要查这封信的去向，得去驿站翻旧档，翻档要钱。",
        encounterChoices = [
            { label = "答应先把信的去向查清。（原价邀请）", outcome = "小虎在回执上写明“未送达”，把信塞回袋底。等能查的时候再查，这一程她愿意先跟黑旗谈。", cost = 0, hireDiscount = 0 },
            { label = "替她付了驿站翻档的钱。（招募优惠）", outcome = "翻档钱付清，小虎把信袋扣好，又在账本上单独记了一行。回执上那个名字还空着。", cost = 50, hireDiscount = 80 }
        ]
    },
    xiaoning = {
        name = "小宁",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 390,
        wage = 12,
        background = "poacher_background",
        role = "远攻与远防偏好的弩手",
        description = "看过小宁画的地图，就知道“外星人”这外号没白叫。河画得像张饼，城是个圈，最要紧的岔路口偏偏只画在她脑子里，想入神了，口水还差点把纸洇湿。她也会把自己绕晕，可耐着性子从第一笔问起，偶尔真能找出别人漏掉的路。东西丢了她也不慌，总说一切都是最好的安排，过两天还真能找回来。",
        attrs = [49, 91, 39, 101, 48, 56, 3, 7],
        stars = { RangedSkill = 2, RangedDefense = 1 },
        equipment = ["weapons/light_crossbow", "ammo/quiver_of_bolts", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "先说这个圈是什么",
        encounterText = "路图缺了一角，城名又被口水洇花了。小宁指着一个圈，先讲起了晚饭。阿飞问河在哪，她才想起来擦嘴。小月牙已经在给这套符号起名字，抹茶赶紧护住了账本。\n\n缺的那一角，地图铺可以补抄，只是要收钱。",
        encounterChoices = [
            { label = "从第一个怪符号开始听。（原价邀请）", outcome = "河和饭铺总算分开了，小宁在图角补了一行说明。阿飞的旗子被她添了两条腿，她坚持说这样更好认。", cost = 0, hireDiscount = 0 },
            { label = "替她付了补抄的钱。（招募优惠）", outcome = "补抄钱付清，小宁卷好新图，旧图也没扔，说那张上有新图没有的东西。阿飞看了看，大概是口水印。", cost = 60, hireDiscount = 90 }
        ]
    },
    xiaopangxu = {
        name = "小胖",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 400,
        wage = 12,
        background = "militia_background",
        role = "耐力与近防偏好的盾斧配置",
        description = "鼓点一响，小胖的脚就闲不住。卡拍、转身、收重心，连空桶倒地的声音都能接进下一拍。阿飞拿他的嘉豪步伐来挑战，她叫帅子敲鼓，专等团长先踩乱。换上盾甲她也会被压得一歪，笑完了就把那一步拆开重练。算账就别找她了，数数是她这辈子的仇人。",
        attrs = [60, 106, 40, 89, 55, 31, 7, 2],
        stars = { Stamina = 2, MeleeDefense = 1 },
        equipment = ["weapons/hand_axe", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 2,
        encounterTitle = "那只桶正好倒在第四拍",
        encounterText = "小胖刚转过半圈，阿飞的嘉豪步伐就撞翻了一只空桶。她把那声响接进了下一拍，冲笑得最大声的团长招招手，让他再来。帅子已经举好了鼓槌，掌柜也递来了场地钱和修地板的单子。",
        encounterChoices = [
            { label = "跟着鼓点再试一轮。（原价邀请）", outcome = "第四拍总算没撞桶，小胖笑着约好有鼓的时候再比。阿飞先问了一句：那只桶会不会搬走。", cost = 0, hireDiscount = 0 },
            { label = "替她付了场地和修地板的钱。（招募优惠）", outcome = "钱付清，小胖把桶挪回墙角：“行，给嘉豪腾点地方。”鼓点一响，她又冲阿飞招手。", cost = 70, hireDiscount = 100 }
        ]
    },
    dae = {
        name = "大鹅",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 370,
        wage = 11,
        background = "militia_background",
        role = "守位前排盾卫，近防、决心与生命成长",
        description = "凳子上只放着一顶帽子，大鹅也能喊出满屋子的“有人！”打水的同伴还没回来，她先把位置占得死死的。身后站着自己人，她敢替大家争地盘；身后少了谁，她又会猛地回头，喊冲锋的嗓门原样拿来叫人回来。比武场上人家叫她鹅神，她自己惦记的却是那个小窝：走出去的人，回来还得有地方坐。",
        attrs = [59, 99, 44, 91, 53, 33, 8, 2],
        stars = { MeleeDefense = 3, Bravery = 2, Hitpoints = 1 },
        equipment = ["weapons/militia_spear", "shields/wooden_shield", "armor/padded_surcoat", "helmets/hood"],
        bag = [],
        chapter = 2,
        encounterTitle = "帽子在，人就有位置",
        encounterText = "凳子上只有一顶帽子，大鹅却喊着有人，把伸手的阿飞挡了回去。打水的同伴正好从门口进来，她下巴一扬：“看见没？”\n\n说起黑旗，她头一句问营地怎么留位置。旧营位的座钱和茶水钱，她还欠着。",
        encounterChoices = [
            { label = "先把营地的规矩说好。（原价邀请）", outcome = "规矩说定，大鹅把帽子还给同伴。阿飞这回坐到了真空着的位置上，她才点头让他接着说。", cost = 0, hireDiscount = 0 },
            { label = "替她结了旧营位的账。（招募优惠）", outcome = "账结清了，大鹅先替同伴收好帽子，又替黑旗留出个空位。“这个可以坐。”嗓门照样很大。", cost = 50, hireDiscount = 80 }
        ]
    },
    manyuemei = {
        name = "蔓越莓",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 410,
        wage = 12,
        background = "poacher_background",
        role = "远攻与先攻兼顾",
        description = "蔓越莓把红线一拉，桌边就没人敢抢话了。“停。坐下。再说一遍。”她句子短，眼神更急，阿飞想插句排场话都找不到空。大谋指出她漏算了一枚木片，她看一眼，改线，让他接着说。据说她追着阿飞要击掌追了半个营地，团长愣是没回头，这笔账她到现在还记着。",
        attrs = [48, 95, 42, 113, 45, 54, 3, 6],
        stars = { RangedSkill = 2, Initiative = 2 },
        equipment = ["weapons/light_crossbow", "ammo/quiver_of_bolts", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "先把顺序说一遍",
        encounterText = "红线把桌面分成两半，蔓越莓让阿飞挨个说谁先走、谁等着。他刚想添一句威风话，她就敲了敲桌子：“先答这个。”大谋指出一枚漏算的木片，她看了一眼，立刻重摆。\n\n这张推演桌是租来的，租钱还没付。",
        encounterChoices = [
            { label = "按顺序把安排说清。（原价邀请）", outcome = "最后一个问题答完，红线才松下来。蔓越莓把那枚漏算的木片收好：下回推演，这个得先摆上桌。", cost = 0, hireDiscount = 0 },
            { label = "替她付了推演桌的租钱。（招募优惠）", outcome = "租钱付清，蔓越莓让阿飞把安排复述一遍。团长这回说得很顺，她终于点了头。", cost = 60, hireDiscount = 90 }
        ]
    },
    xiaohani = {
        name = "罗一可",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 330,
        wage = 10,
        background = "daytaler_background",
        role = "近攻与先攻偏好的轻装配置",
        description = "罗一可的口袋总比别人鼓，干饼、栗子、舍不得扔的扣子，各有各的地方。阿飞喊她仓鼠，她先摸摸粮袋：“先过今晚再说。”弯刀是护送用的家伙，路费另外系一个结，嘴馋的团长想分半张饼，也得先问过她。受了委屈她不吭声，往角落一缩，得有人坐过去哄上半宿。",
        attrs = [51, 98, 37, 116, 52, 41, 4, 5],
        stars = { MeleeSkill = 1, Initiative = 2 },
        equipment = ["weapons/falchion", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 2,
        encounterTitle = "仓鼠的第三只口袋",
        encounterText = "罗一可从第三只口袋里摸出半张干饼。阿飞问她是不是准备过冬，她把饼收了回去：“先过今晚。”商贩递来的大粮囊被她放回架子上，背太多，刀都拔不出来。\n\n她手边那只粮袋的袋口破了，一路都在漏栗子。",
        encounterChoices = [
            { label = "跟她说清工钱和伙食。（原价邀请）", outcome = "罗一可把谈好的那份另系了一个结。最后半张饼还在她手边，阿飞看了看，终于先问了句能不能分一点。", cost = 0, hireDiscount = 0 },
            { label = "出钱补好漏粮的袋口。（招募优惠）", outcome = "袋口补好了，栗子不用再一路捡。罗一可把省下的路费收好，递给阿飞一颗完整的栗子。", cost = 40, hireDiscount = 60 }
        ]
    },
    keke = {
        name = "可可",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 420,
        wage = 13,
        background = "poacher_background",
        role = "鼓舞同伴的前排盾卫，近防与决心成长",
        description = "可可认出熟人，先挪凳子，再问吃过没有。刚进门的搬运工也能被她招呼到桌边，不一会儿就有了名字和去处。跟着她的那帮人自称保可梦，布条上都画着个红白小球。她管阿飞叫飞爹，叫得比谁都顺口，营里还有人说她跟团长长得有几分像。踢球时她一脚能抽得团长当场蹲下，举弩时却很认真，侧后方站着谁，她总要看一眼。",
        attrs = [53, 96, 46, 100, 50, 52, 5, 5],
        stars = { MeleeDefense = 3, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "布条上没写名字",
        encounterText = "可可替黑旗挪好了凳子，又把门边没座的搬运工招呼进来。布条上没写名字，她就一个个问，没一会儿，连人家下一程去哪都聊上了。\n\n她的弩该整修了，整修单就压在手边。",
        encounterChoices = [
            { label = "坐下来，把来人一个个认清。（原价邀请）", outcome = "名字和去处都问清了，可可又把凳子往里挪了挪，好让新来的搬运工也能靠桌吃饭。“飞爹，坐这儿。”", cost = 0, hireDiscount = 0 },
            { label = "替她付了弩的整修钱。（招募优惠）", outcome = "整修钱付清，可可把账条收好。“这笔记下了。刚才那位叫什么来着？”人和账，她都要记清。", cost = 70, hireDiscount = 100 }
        ]
    },
    yuxiang = {
        name = "余想",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 400,
        wage = 12,
        background = "militia_background",
        role = "长柄武器与持续站位",
        description = "最让余想警惕的夸奖是“有你在最放心”，后面往往跟着一班没人肯接的夜岗。别人把“五老压阵”喊得再响，她也只问长矛稳不稳、交班谁来签。提到下岗，她脸冷话短，想逃班的人顺带还得挨她一句。真动起手来，她一个人能顶住好几个，可这不是让人一直把她留在岗上的理由。",
        attrs = [57, 104, 47, 94, 56, 33, 6, 3],
        stars = { Stamina = 1, MeleeDefense = 1, Bravery = 2 },
        equipment = ["weapons/pitchfork", "armor/padded_surcoat", "helmets/hood"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "替班那一栏是空的",
        encounterText = "旧哨所的管事终于签了交接，余想把钥匙放回桌上，松了松握矛的手。大谋刚提起黑旗，她就先要轮值表，顺便看了看旅店寄存行李的账单。\n\n“别记成我又多守了一班。”她说。",
        encounterChoices = [
            { label = "说清楚轮值和交班。（原价邀请）", outcome = "余想核过轮值表，按自己的安排去取行李。大谋笑着目送她出门：至少这一回，下岗的人真走得出去。", cost = 0, hireDiscount = 0 },
            { label = "替她付了行李寄存的钱。（招募优惠）", outcome = "寄存钱付清，抹茶把补贴和轮值分成两栏记好，余想看过才点头，把长矛从桌边拿了起来。", cost = 60, hireDiscount = 90 }
        ]
    },
    tongzhu = {
        name = "童猪",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 320,
        wage = 10,
        background = "daytaler_background",
        role = "生命与决心较有潜力",
        description = "童猪把木熊往桌上一摆，几个自信满满的大哥就危险了。规则她讲得一本正经，眼睛却分明在等人猜错，真等到了，她能笑出猪叫。阿飞抢答，大谋不服，抹茶非要查账，三个人都很适合坐到她对面。她说阿飞这人，你夸他一句帅，他是真会信的。",
        attrs = [56, 94, 48, 104, 49, 38, 4, 3],
        stars = { Hitpoints = 1, Bravery = 2 },
        equipment = ["weapons/wooden_stick", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "再听一遍，还是先认输",
        encounterText = "抹茶和大谋还在争到底哪一步算错，童猪把木熊翻过来，指着底下刻的规则。阿飞想插话，被她推过来一只杯子：“排队。”掌柜随后把桌钱的单子也推了过来。",
        encounterChoices = [
            { label = "认输，再听一遍规则。（原价邀请）", outcome = "两位队长总算认了输。童猪把木熊转向阿飞，笑得很和气，团长却莫名觉得下一局轮到自己了。", cost = 0, hireDiscount = 0 },
            { label = "替她付了桌钱。（招募优惠）", outcome = "桌钱付清，童猪把木熊摆回原位：“钱算完了，输赢也算完了。”两位队长对着那只熊，没找到重来的理由。", cost = 40, hireDiscount = 70 }
        ]
    },
    meiya = {
        name = "美伢",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 430,
        wage = 12,
        background = "militia_background",
        role = "近攻、耐力与先攻均衡",
        description = "美伢记得鼓点前该吸的那口气，也记得台边哪块木板会绊脚。大王舞跳得热闹，她却总看得出主角哪一拍该让路。营里年纪小的跟着她喊“美伢妈妈”，她也应。她挂在嘴边的就一句：上了就拼，菜了就练。",
        attrs = [54, 101, 43, 109, 56, 37, 5, 3],
        stars = { MeleeSkill = 1, Stamina = 1, Initiative = 1 },
        equipment = ["weapons/warfork", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "请团长从这两把椅子中间走过去",
        encounterText = "美伢把两把椅子留在过道上，请阿飞照他刚才说的步子走一遍。披风果然挂住了。鼓手笑出了声，被她转头问起刚才那半拍是怎么回事。\n\n鼓带断了，修理的价钱已经报过来。",
        encounterChoices = [
            { label = "听她排好位置，再谈怎么合作。（原价邀请）", outcome = "阿飞收好披风，美伢把自己要负责的几段讲清楚。鼓手又说别抢拍，她回了一句：“你先敲稳。”两人都笑了。", cost = 0, hireDiscount = 0 },
            { label = "替她付了修鼓带的钱。（招募优惠）", outcome = "修理钱付清，美伢把挡路的椅子搬开。同行以后站哪儿还得再谈，团长至少先学会了从这儿走过去。", cost = 60, hireDiscount = 100 }
        ]
    },
    wanshe = {
        name = "玩蛇",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 420,
        wage = 12,
        background = "militia_background",
        role = "近攻与先攻偏好的单手剑配置",
        description = "秦国的神，招式的名字一个比一个响亮。可玩蛇真试招的时候只问一句：“你从哪一步开始站不稳？”木桩上的蛇形刀痕改了又改，为了半寸落脚，她能跟大谋争到天黑，争完了接着练到后半夜。阿飞想凑过来指点两句，她瞥一眼他那身披风：“纯嘉豪。”",
        attrs = [52, 98, 39, 111, 57, 34, 6, 4],
        stars = { MeleeSkill = 2, Initiative = 1 },
        equipment = ["weapons/shortsword", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "先别讲，把脚放这儿",
        encounterText = "玩蛇和大谋把两只桶搬过来又搬过去，各说各的那一步更省力。阿飞在旁边数次数，数到一半忘了，门口的看客已经换了一拨。看场子的人递来加时的场地钱，两人这才停手。\n\n“同行以后，这招还接着试？”玩蛇问的是大谋。",
        encounterChoices = [
            { label = "约好以后接着试招。（原价邀请）", outcome = "大谋说有空再比，玩蛇把木剑往肩上一搁。走了两步又回头，指出桶应该放在哪边，显然还没试完。", cost = 0, hireDiscount = 0 },
            { label = "替她付了加时的场地钱。（招募优惠）", outcome = "场地钱付清，玩蛇道了声谢，又把大谋叫回来半步：“钱算清了，刚才那招可还没算清。”", cost = 60, hireDiscount = 90 }
        ]
    },
    tutu = {
        name = "涂涂",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 310,
        wage = 10,
        background = "daytaler_background",
        role = "决心与耐力偏好的轻装起步",
        description = "涂涂的行囊里总装着下一站的打算，可营火边的歌唱完了，她多半还会再坐一会儿。有人笑话没讲完，她愿意听；有人拿“再留一晚”替她定了去处，她就把路票摊开给你看。营里谁说过什么、谁吃了几碗，她都记得，有人说她是黑旗的史官。下一段走不走，她要自己看过再定。",
        attrs = [50, 100, 50, 103, 48, 40, 3, 4],
        stars = { Bravery = 2, Stamina = 1 },
        equipment = ["weapons/lute", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "这一段，先写清楚",
        encounterText = "涂涂回来拿手套，听见黑旗在谈下一程，就在门口多站了一会儿。她摊开一张还没过期的路票，问这条路能不能绕到她想去的那个镇子。\n\n真要绕路，路票得改签，改签要钱。",
        encounterChoices = [
            { label = "把下一程说清，让她再想想。（原价邀请）", outcome = "涂涂收好路票，坐回火边，指了指她想去的那个镇子。刚才那首没唱完的歌，她说等话谈完了再接着唱。", cost = 0, hireDiscount = 0 },
            { label = "替她付了改签的钱。（招募优惠）", outcome = "改签钱付清，票上的去处改了。走不走还得两边再说定，她把手套放下，重新端起了那杯茶。", cost = 40, hireDiscount = 60 }
        ]
    },
    naigai = {
        name = "奶盖",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 280,
        wage = 9,
        background = "daytaler_background",
        role = "近防与投掷有潜力的新手",
        description = "奶盖讲起胜负来，教官都得排队听她的。可盾一到手，她退得比讲得还快三拍。缩到盾后头了，解释照样一句句飘出来，营地想清净一会儿都难。阿飞笑她嘴硬，她回一句“本王只是还没开始”，转头悄悄把盾带系紧。她自称盖姐聪明人，营里信的人不多，可下一轮喊她上场，她还是会把盾捡起来。",
        attrs = [52, 95, 33, 107, 46, 42, 3, 2],
        stars = { RangedSkill = 1, MeleeDefense = 2 },
        equipment = ["weapons/throwing_axe", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "盾后面还有一句",
        encounterText = "盾立歪了，奶盖还躲在后面解释：“本王在研究对手。”大谋一低头，她赶紧把磨破的盾带往身后藏了藏。研究归研究，下一次试训她还得上场。",
        encounterChoices = [
            { label = "认真问她想练什么。（原价邀请）", outcome = "阿飞问起下一次试训，奶盖马上说早有安排。盾往旁边一挪，后面其实已经备好了换盾带的绳子。", cost = 0, hireDiscount = 0 },
            { label = "替她付了修盾带的钱。（招募优惠）", outcome = "修理钱付清，奶盖宣布这叫英雄惜英雄。大谋看了看她刚系紧的盾带，决定让本王再威风一小会儿。", cost = 40, hireDiscount = 60 }
        ]
    },
    xiaojie = {
        name = "小杰",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 320,
        wage = 10,
        background = "daytaler_background",
        role = "血牛轻甲长柄与解网工具位",
        description = "锁扣“咔哒”一响，小杰才肯转身。有人说大家都是熟人，她反倒再去查一遍车门；有人说东西大概会还，她把借据往前推得更近。备用钥匙一把不少，谁拿走的都得留名。她跟抹茶聊借还的规矩能聊一下午，碰上欠账的熟人，脸板得比谁都快。三年了，这毛病一点没改。",
        attrs = [58, 105, 39, 96, 51, 35, 4, 3],
        stars = { Stamina = 2, Hitpoints = 1 },
        equipment = ["weapons/pickaxe", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "未来的团长，现在谁担保",
        encounterText = "借走的绳钩总算找到了人，小杰还是不满意：每借一次，都得回来找她开箱。抹茶正帮她列交接的办法，锁匠也报好了配备用钥匙的价钱。\n\n阿飞伸手想看钥匙，她先把手缩了回去：“看可以，拿走得先写名字。”",
        encounterChoices = [
            { label = "把借还和分工谈妥。（原价邀请）", outcome = "借还办法一条条记下了。抹茶问得仔细，她答得起劲，那只箱子总算不用每次都叫她回来开了。", cost = 0, hireDiscount = 0 },
            { label = "替她付了配钥匙的钱。（招募优惠）", outcome = "配钥匙的钱付清，小杰把新钥匙放在哪儿都一一记好。借用那一栏里没有阿飞的名字，他这回也没乱伸手。", cost = 50, hireDiscount = 80 }
        ]
    },
    bula = {
        name = "bula",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 330,
        wage = 10,
        background = "daytaler_background",
        role = "生命、决心与远防均衡",
        description = "bula把钱袋一抖，台下都以为里面又多了几枚，散了场往桌上一倒，她一枚枚数得清清楚楚。戏法是戏法，账是账，缺多少就说多少。抹茶问总账平不平，她还要追问买回来的东西给谁用。迷上什么就往死里练，半夜三点营里还能听见她在外头踢球。",
        attrs = [54, 98, 45, 98, 49, 40, 4, 5],
        stars = { Bravery = 1, RangedDefense = 1, Hitpoints = 1 },
        equipment = ["weapons/bludgeon", "shields/wooden_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "这枚铜片买不了粮",
        encounterText = "阿飞摸着那枚变戏法用的铜片，问它能换多少粮。bula把它拨到桌角，铺开真正的账本：“这枚买掌声，买粮看这儿。”抹茶笑着坐近了些。\n\n她那几块道具布还没付钱。",
        encounterChoices = [
            { label = "一起核对真正要买的东西。（原价邀请）", outcome = "bula听完采买的打算，点了点头。那枚铜片还留在桌边，往后阿飞一讲排场，抹茶就轻轻指它一下。", cost = 0, hireDiscount = 0 },
            { label = "替她付了道具布的钱。（招募优惠）", outcome = "布钱付清，bula抖了抖钱袋：“这回是真省下了。要不要数给你看？”", cost = 50, hireDiscount = 80 }
        ]
    },
    suwa = {
        name = "苏袜",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 370,
        wage = 11,
        background = "poacher_background",
        role = "高先攻与耐力倾向",
        description = "苏袜讲一条路，脚尖已经指向下一个路口。踩点、抢半步、急刹，哪儿能快、哪儿得立刻收脚，她心里有数。可腿记得的弯，画到纸上常常少一半，车夫拿着车辙来问，她才不情不愿地停下重画。跑得快的人都管她叫袜神，跟在后面的人只盼她偶尔回头看一眼。",
        attrs = [49, 101, 38, 121, 49, 46, 4, 6],
        stars = { Initiative = 3, Stamina = 1 },
        equipment = ["weapons/javelin", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "到底是哪只靴子",
        encounterText = "苏袜说那条近路能走，车夫偏说走不了。两人一直争到岔路口，才发现一个说的是人走，一个说的是车走。她在地上分开画了两条线，阿飞总算跟上了。\n\n抄图铺说，这张图要重画，得另付钱。",
        encounterChoices = [
            { label = "听完两条路各适合谁。（原价邀请）", outcome = "车夫不摇头了。苏袜在图上多画了一只靴子，又嫌太慢，干脆写上两个字：步行。阿飞这回看懂了。", cost = 0, hireDiscount = 0 },
            { label = "替她付了重画路图的钱。（招募优惠）", outcome = "重画的钱付清，苏袜把新图转向阿飞，指着岔路口等他复述，直到团长不再想把车往小路上赶。", cost = 60, hireDiscount = 90 }
        ]
    },
    qianhan = {
        name = "千涵",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 350,
        wage = 11,
        background = "militia_background",
        role = "近攻与近防偏好的长矛与盾牌配置",
        description = "千涵把003号木牌擦得发亮，谁夸一句传奇，她反倒急着翻开练习簿：这一段还没跑完。起步要快，后半程要留气，她把目标拆成一小段一小段，空格一格格填满。套圈她输过，输了就领二等的饼干，下回接着来。上了就拼，菜了就练，这话她不光挂在嘴上。",
        attrs = [53, 99, 41, 103, 53, 36, 5, 3],
        stars = { MeleeSkill = 2, MeleeDefense = 1 },
        equipment = ["weapons/militia_spear", "shields/wooden_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "别替003写得太快",
        encounterText = "003号木牌又擦了一遍，千涵把练习纸递给阿飞看。团长刚说出“传奇”两个字，她就指着下一格：“这个还没跑。”场边的木桩和量距绳要租，价钱已经写在纸上了。",
        encounterChoices = [
            { label = "听她说完下一段的目标。（原价邀请）", outcome = "阿飞这回没给003改名，千涵把新目标写进练习纸。木牌照旧摆在最亮的地方，旁边那一格等她自己去填。", cost = 0, hireDiscount = 0 },
            { label = "替她付了场地器具的租钱。（招募优惠）", outcome = "租钱付清，千涵认真道了谢。她量好起点和终点，回头叮嘱阿飞看着就行，别又提前把成绩喊出来。", cost = 50, hireDiscount = 80 }
        ]
    },
    wangdazhi = {
        name = "王大芷",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 400,
        wage = 12,
        background = "militia_background",
        role = "近防、耐力和决心偏好的持盾起步",
        description = "“芷芷，搭把手！”场子一乱，总有人先喊王大芷。幕布、架子、门口的空当，她看一眼就知道该撑哪里。等大家终于能开演了，她自己的节目却常被挤到散场以后。她闲下来爱给人算运势，抹茶的财运她算过三回，三回说法都不一样。",
        attrs = [56, 102, 46, 95, 52, 33, 7, 4],
        stars = { MeleeDefense = 2, Stamina = 1, Bravery = 1 },
        equipment = ["weapons/wooden_flail", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 3,
        encounterTitle = "谢幕名单漏了谁",
        encounterText = "幕布架总算立稳了，王大芷一看节目单，自己的节目又被挪到了散场以后。她拿过笔，把名字往上挪了一行，请管事再看看。旁边还压着一张补幕布的单子。\n\n“这回也听听我想干什么。”她说。",
        encounterChoices = [
            { label = "听她说自己的节目安排。（原价邀请）", outcome = "三位队长听完，王大芷把节目单叠好，名字落在了她自己挑的位置上。", cost = 0, hireDiscount = 0 },
            { label = "替她付了补幕布的钱。（招募优惠）", outcome = "补幕布的钱付清，节目单还摊在桌上。她趁管事回来，又确认了一遍自己登场的时辰。", cost = 70, hireDiscount = 100 }
        ]
    },
    yaoyaoya = {
        name = "瑶瑶牙",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 450,
        wage = 13,
        background = "militia_background",
        role = "近攻与疲劳二星、近防一星；双手斧起步",
        description = "“奶团吕布”的名号一传开，递给瑶瑶牙的挑战书比委托还多。她爱赢，正面那一斧也够干脆，只是总有人想拿她的好胜心省掉报酬。她个子高，往李李旁边一站，李李就成了小土豆。冲得进缺口，回头也得找得到自家的旗。黑旗肯把活和价钱讲实在，她就肯把那柄长斧一起带上。",
        attrs = [58, 104, 40, 84, 55, 29, 3, 0],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Stamina = 2 },
        equipment = ["weapons/woodcutters_axe", "armor/padded_surcoat", "helmets/aketon_cap"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "先把委托写在名号上头",
        encounterText = "挑战书上“奶团吕布”四个字写得老大，瑶瑶牙瞄了一眼，先把抹茶那张护送安排拉近：“这趟到底答应的是哪件？”看热闹的人只好先等着。\n\n她的斧刃卷了口，整修的价钱已经报过来了。",
        encounterChoices = [
            { label = "照实际的护送活儿谈同行。（原价邀请）", outcome = "活儿讲清楚了，瑶瑶牙把挑战书压到最底下。阿飞问那场比试呢，她说先把答应了的这趟走完。", cost = 0, hireDiscount = 0 },
            { label = "替她付了修斧刃的钱。（招募优惠）", outcome = "修理钱付清，瑶瑶牙扶正长斧，又核了一遍护送的时辰，这才把黑旗的邀请收下。", cost = 80, hireDiscount = 120 }
        ]
    },
    yangmiemie = {
        name = "羊咩咩",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 340,
        wage = 10,
        background = "daytaler_background",
        role = "生命与决心偏好的稳健配置",
        description = "羊咩咩的小车上挂着铃铛，风吹会响，车轴松了也会响，她听得出两种声音的分别。直道上能追，进弯前得留力，贴哪条线走还要看车上货有多重。有一回她跑了头名，掌事只夸她快，她更得意的是车上的货一件没坏。",
        attrs = [59, 100, 44, 97, 50, 38, 5, 4],
        stars = { Hitpoints = 2, Bravery = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 3,
        encounterTitle = "计时牌旁边的碎封蜡",
        encounterText = "掌事指着计时牌夸她快，羊咩咩把一只完好的包裹推到旁边：“这个也看看。”车轴上的小铃又响出杂音，她侧耳听了听，记下该修的位置。\n\n车匠已经报了检修的价钱，掌事那边这趟的工钱还没算清。",
        encounterChoices = [
            { label = "听清车况和交货的要求。（原价邀请）", outcome = "羊咩咩接着指着封蜡跟掌事算账。阿飞在旁边看了一会儿，也把计时牌和包裹一起摆正了。", cost = 0, hireDiscount = 0 },
            { label = "替她付了检修车轴的钱。（招募优惠）", outcome = "检修钱付清，羊咩咩晃了晃那只小铃：“下回听见这声，进弯前就先松一点。”她让团长又听了一遍。", cost = 50, hireDiscount = 80 }
        ]
    },
    songnuanyang = {
        name = "宋暖阳",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 320,
        wage = 10,
        background = "daytaler_background",
        role = "高先攻轻甲刺剑手",
        description = "锣一响，宋暖阳先把鹌鹑纹的兜帽缩一缩，过一会儿又探出头来，把没问完的话问完。她给集市写过凯旋告示，写到“所向无敌”那几个字，笔总要停一停。黑旗眼下没几场漂亮仗，三位队长倒是能吵出不少值得记的事。谁嘴硬、谁算错、谁笑完又回来帮忙，她都想听，听到好笑处还会咕咕嘎嘎笑出声来。",
        attrs = [60, 104, 50, 108, 58, 39, 6, 5],
        stars = { MeleeSkill = 1, Bravery = 1, Hitpoints = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 4,
        encounterTitle = "所向无敌，从哪一仗写起",
        encounterText = "雇主只给了半份纸墨钱，却要她在告示上写“所向无敌”。宋暖阳把那张假凯旋翻了过去，听阿飞、大谋和抹茶当场吵了三句，笔反倒动了一下。\n\n外面锣一响，她又缩进兜帽，过一会儿再探出头，等这三个人的下一句。",
        encounterChoices = [
            { label = "请她一路记下见闻。（原价邀请）", outcome = "宋暖阳问刚才那场争吵是从哪儿开始的。阿飞指着乱糟糟的草稿说全是真的，抹茶补了一句：“连算错的也是。”她这回写了不少。", cost = 0, hireDiscount = 0 },
            { label = "补上她的纸墨钱。（招募优惠）", outcome = "纸墨钱补上了，宋暖阳翻开一页新纸。旧的凯旋告示还扣在桌上，黑旗的第一行从三位队长抢话写起。", cost = 40, hireDiscount = 60 }
        ]
    },
    xiaogui = {
        name = "溺水小龟",
        title = "远征团队员",
        isCaptain = false,
        hireCost = 350,
        wage = 11,
        background = "daytaler_background",
        role = "前排盾卫，近防与决心成长；保留投掷副手",
        description = "溺水小龟得踩着木箱才够得着棋盘，自己的报名牌却一定摆在最前头。飞爹来看，她高兴；飞爹想伸手替她走，她马上挡住：“这步我来。”被人串急了，她会一下缩进壳里，过一会儿又探出头来接着下。夜里擦壳的时候，旧纹路偶尔泛出深水一样的暗光，她很少提，只把那只亮粉色的蝴蝶结重新系好。",
        attrs = [53, 102, 43, 100, 48, 44, 5, 8],
        stars = { MeleeDefense = 3, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/thick_tunic"],
        bag = ["weapons/javelin"],
        chapter = 4,
        encounterTitle = "飞爹先坐观众席",
        encounterText = "阿飞的手刚伸到棋盘边，小龟就轻轻挡住了：“飞爹先坐那边。”她把自己的报名牌摆正，还想再试一条进攻的路子。\n\n这场比试的报名费还没交。",
        encounterChoices = [
            { label = "坐到一边，让她自己下。（原价邀请）", outcome = "阿飞收回手坐好，小龟重新盯住棋盘。飞爹有什么意见，等这一盘下完再说。", cost = 0, hireDiscount = 0 },
            { label = "替她交了报名费。（招募优惠）", outcome = "报名费交了，小龟笑着给阿飞指好看棋的座位：“飞爹，出了钱也不能替我走哦。”说完，认真落下一子。", cost = 50, hireDiscount = 80 }
        ]
    }
};

// Metadata only: keep already recruited actors usable when upgrading older saves.
// Retired identities are never listed or created by new recruitment.
A.RetiredCharacters <- {};

// Frozen v0.17 starting values for additive, one-time save migration. Never edit.
A.CharacterBasesV17 <- {
    afei = [48, 92, 30, 95, 43, 32, 1, 0],
    damou = [57, 100, 43, 100, 57, 35, 5, 3],
    mocha = [55, 100, 43, 102, 52, 53, 4, 3],
    bottle = [56, 100, 44, 101, 57, 38, 5, 3],
    shuaizi = [58, 101, 45, 100, 55, 35, 7, 4],
    lili = [51, 96, 38, 115, 49, 51, 3, 5],
    xiaoyueya = [52, 99, 36, 117, 48, 47, 4, 6],
    yuchujiu = [53, 98, 46, 118, 50, 46, 5, 7],
    xiaoyubeike = [64, 107, 40, 91, 53, 34, 6, 2],
    wangduidui = [54, 100, 47, 111, 54, 38, 5, 4],
    laocai = [57, 103, 50, 100, 60, 39, 6, 4],
    tiantong = [52, 97, 45, 109, 48, 55, 3, 6],
    xiaoning = [51, 95, 41, 104, 50, 58, 4, 8],
    xiaopangxu = [62, 110, 42, 92, 57, 33, 8, 3],
    dae = [61, 103, 46, 94, 55, 35, 9, 3],
    manyuemei = [50, 99, 44, 116, 47, 56, 4, 7],
    xiaohani = [53, 102, 39, 119, 54, 43, 5, 6],
    keke = [55, 100, 48, 103, 52, 54, 6, 6],
    yuxiang = [59, 108, 49, 97, 58, 35, 7, 4],
    tongzhu = [58, 98, 50, 107, 51, 40, 5, 4],
    meiya = [56, 105, 45, 112, 58, 39, 6, 4],
    wanshe = [54, 102, 41, 114, 59, 36, 7, 5],
    tutu = [52, 104, 52, 106, 50, 42, 4, 5],
    songnuanyang = [57, 101, 46, 104, 52, 39, 4, 4],
    xiaogui = [55, 106, 45, 103, 50, 46, 6, 9],
    naigai = [54, 99, 35, 110, 48, 44, 4, 3],
    xiaojie = [60, 109, 41, 99, 53, 37, 5, 4],
    bula = [56, 102, 47, 101, 51, 42, 5, 6],
    suwa = [51, 105, 40, 124, 51, 48, 5, 7],
    qianhan = [55, 103, 43, 106, 55, 38, 6, 4],
    wangdazhi = [58, 106, 48, 98, 54, 35, 8, 5],
    yaoyaoya = [63, 111, 44, 90, 60, 32, 5, 2],
    yangmiemie = [61, 104, 46, 100, 52, 40, 6, 5],
};
