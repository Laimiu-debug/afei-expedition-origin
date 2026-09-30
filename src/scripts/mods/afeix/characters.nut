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
        description = "黑旗刚挂起来，阿飞就把“嘉豪”写得比招募价还大。披风要体面，站相要威风，盾一压下来，哇哇叫的却也是他。大谋顶在前面，抹茶算着饭钱，他暂时还撑不起嘴里的远征团。可雇主要拿伙伴的命赌排场时，这张爱笑的脸会忽然冷下来。他想当一声响亮的大哥，也想看自己叫来的人，一个个闯出名堂。",
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
        description = "王大谋进酒馆先看谁的盾磨得最狠，出门时往往又认了一位大哥。“借我一招”刚说完，下一句就是“要不要换面旗”。营里笑他偷大哥，他也不恼，拉张凳子继续问。真遇上险处，最先横过去的仍是他自己的盾。阿飞握反了盾带，他能嫌弃半天，也能陪练半天；请高手的酒钱，倒还得先过抹茶那一关。",
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
        description = "阿飞讲远征，午夜抹抹茶算晚饭。地精算盘一响，豪言壮语就得换成克朗、口粮和修盾的钱。雇主说“顺手”，他添一笔费用；团长说“将来”，他先问今天谁付账。他的弓站在后排，账本却摆在三位队长中间。别看拆台时一句不让，真有人欠了队员的工钱，他能追到对方连酒都喝不安稳。",
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
        description = "小酒瓶看缺口比阿飞喊冲锋还快。瓶队爱突破，爱决赛，也爱接住队友真正肯传来的球。“蛤妈”这个外号她听惯了，推团长一把也不嫌麻烦，只是自己的比赛还得自己赢。阿飞讲带人的道理，她常把话截在半道：“先把车扶稳。”那辆旧自行车的链条掉过几回，两个人记得的事却不止修车。",
        attrs = [54, 96, 42, 98, 55, 36, 4, 2],
        stars = { MeleeSkill = 3, MeleeDefense = 3, Bravery = 3 },
        equipment = ["weapons/shortsword", "armor/ragged_dark_surcoat", "helmets/hood", "shields/wooden_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = "这回先接住",
        encounterText = "小酒瓶把旧球停在鞋尖，听阿飞刚夸完瓶队突破，便轻轻拨到他脚下。他下意识让了半步。\n\n“以后带人，也这样让？”她抱起手臂等他答。旧自行车靠在旁边，车铃压着修理报价。把球接住可以继续谈，替她付清修车费，也能再议招募价。",
        encounterChoices = [
            { label = "接住球，认真回答她。（原价邀请）", outcome = "阿飞把球停住，拨回她脚边：“这回接着。”小酒瓶笑了一声，把原价招募条件讲给他听。正式同行还得再定，球倒已经来回传了一次。", cost = 0, hireDiscount = 0 },
            { label = "付清修车费，再谈同行。（招募优惠）", outcome = "修车费用结清，小酒瓶试了试车铃，把黑旗的招募报价往下改了一笔。“这个收了。球，下一回还得你自己接。”邀请与优惠一并留下。", cost = 50, hireDiscount = 80 }
        ]
    },
    shuaizi = {
        name = "白小帅子", title = "远征团队员", isCaptain = false, hireCost = 200, wage = 9,
        background = "militia_background", role = "可培养的持盾前排",
        description = "白小帅子守门前要看门闩、摸盾带，再确认旁边有人。突然一声响，她自己先抖一下；轮到发信号，四下鼓却一声都不能少。阿飞抢着出发，也得被她叫回来等第四拍。小酒瓶往前找缺口，她往后看归路，两人常为跑得太快拌嘴。请她守一个位置，先把口令讲明白——她紧张归紧张，记得比发令的人还牢。",
        attrs = [56, 97, 43, 97, 53, 33, 6, 3],
        stars = { MeleeDefense = 2, Bravery = 1 },
        equipment = ["weapons/shortsword", "armor/padded_surcoat", "shields/wooden_shield"],
        bag = [],
        chapter = 1,
        encounterTitle = "请等第四下",
        encounterText = "鼓点刚到第三下，阿飞就接了一声“好”。白小帅子的手一抖，鼓槌横回门闩：“第四下呢？”交班的人在旁边憋笑。\n\n裂开的鼓带用旧绳系着，修补报价也已说定。黑旗可以先把信号听完整，按原价邀请；也能承担修补费用，换一份较低的招募报价。",
        encounterChoices = [
            { label = "等第四下，再复述信号。（原价邀请）", outcome = "第四声落下，阿飞才把信号复述了一遍。帅子点头，留下原价邀请。“以后也这么等。”她说完，才肯让开门口。", cost = 0, hireDiscount = 0 },
            { label = "承担鼓带和门闩修补费。（招募优惠）", outcome = "修补费付清，帅子收好账纸，给黑旗留下优惠报价。阿飞刚想接话，鼓槌又抬了起来。很好，团长还得再等一拍。", cost = 40, hireDiscount = 60 }
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
        description = "高背椅摆好，弓拿起来，李李超欧就等人喊一声超巨。她懂得抢灯，也懂得忽然绕到灯外，让刚才还盯着她的人找个空。问得无趣，她懒得接；有人拿成绩挑战，她又回来得最快。欧气挂在嘴边，射偏的箭照样自己认。黑旗想请她当招牌，最好先留够上场的位置，她可不愿只负责把告示撑得好看。",
        attrs = [49, 92, 36, 112, 47, 49, 2, 4],
        stars = { RangedSkill = 2, Initiative = 1 },
        equipment = ["weapons/short_bow", "ammo/quiver_of_arrows", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "超巨这张椅子",
        encounterText = "阿飞正琢磨高背椅怎么装车，李李超欧已经绕到椅后：“请超巨，还是搬家具？”她把弓拿起来，故意等他重新开口。\n\n椅脚和弓弦都有待修处，报价写在同一张纸上。先听她开条件，可以原价邀请；承担修整费，她也愿意下调招募报价。",
        encounterChoices = [
            { label = "请会出手的超巨。（原价邀请）", outcome = "“这句还算像话。”她把椅子挪开半步，让阿飞看清手里的弓。原价条件留在桌上，超巨的上场机会也一并谈了进去。", cost = 0, hireDiscount = 0 },
            { label = "承担椅脚与弓弦修整费。（招募优惠）", outcome = "修整费结清，李李把招募价改低，笑着收下这份捧场。“下一箭是不是欧气，到时候看。”邀请和优惠都替黑旗留着。", cost = 50, hireDiscount = 80 }
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
        description = "两块木板一拍，小月牙的“超市里”就开张了。旧扣子、断绳头、歪木片，在她眼里全是还没找到用途的好东西。阿飞刚听懂一个主意，她已经拿木杆比划起下一个。抹茶要她报账，她就逐件演示，连试坏的零件也要争取一次重新上架。招她同行后，收拾行囊大概得慢一点：那声“先别扔”，总会从身后追过来。",
        attrs = [50, 95, 34, 114, 46, 45, 3, 5],
        stars = { RangedSkill = 1, Initiative = 2 },
        equipment = ["weapons/javelin", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "欢迎光临超市里",
        encounterText = "两块木板一拍，小月牙便请阿飞逛“超市里”。半张摊子被招牌遮住，货只有扣子、绳头和木片。抹茶问用途，她捡起铜扣，把松掉的牌角卡住：“这不就是？”\n\n固定件和旧工具还要修整。黑旗可以先听她讲，原价留邀请；也能付这笔修整费，议低招募价。",
        encounterChoices = [
            { label = "听她把铜扣的新用法讲完。（原价邀请）", outcome = "铜扣先挂招牌，又变成收绳的扣环。小月牙越讲越来劲，顺势留下原价邀请。阿飞看看自己的行囊，突然觉得里面大概还有不少货。", cost = 0, hireDiscount = 0 },
            { label = "支付招牌与旧工具修整费。（招募优惠）", outcome = "修整费付清，小月牙改低招募价，还把账纸递给抹茶：“超市里，欢迎核账！”邀请和优惠都留下了，招牌也终于不再歪着。", cost = 40, hireDiscount = 60 }
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
        description = "余初九一开口，队尾也能听清。阿飞讲到兴头上，她照样敢喊停，随后问路看了没有、人点齐没有。有人笑她狗叫，她连那人一起点名，少一个都不肯糊弄。回营先数伙伴，再数战利品，团长也得亲口应一声。她能当面把阿飞顶得没话说，转头又替他盯住后路；这面旗容得下她的嗓门，她才走得踏实。",
        attrs = [48, 91, 42, 112, 45, 43, 3, 5],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Initiative = 2 },
        equipment = ["weapons/throwing_axe", "shields/buckler_shield", "armor/thick_tunic", "helmets/hood"],
        bag = ["weapons/knife"],
        chapter = 1,
        encounterTitle = "听见就回一声",
        encounterText = "渡口边，余初九用船桨压住旧图：“先看年份。”阿飞正要说近路，她又让他指出水位标记。河风一吹，提醒几乎传遍了整座码头。\n\n新路图的核实费还没结。黑旗若肯听完危险，可以原价邀请；愿意付清核实费，她也会给出招募优惠。她仍等阿飞先回这一声。",
        encounterChoices = [
            { label = "收起旧图，听完她的提醒。（原价邀请）", outcome = "阿飞逐项说清，余初九才移开船桨，留下原价邀请。临走又喊住他：“那张旧的别拿！”团长回得很响，渡口的人都听见了。", cost = 0, hireDiscount = 0 },
            { label = "支付路图核实费。（招募优惠）", outcome = "核实费结清，余初九把优惠报价记给黑旗。她卷起新图，最后又确认一次：“往后听见停，记得回我。”阿飞这次没装作听不见。", cost = 60, hireDiscount = 90 }
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
        description = "栈桥外侧一空，小鱼贝壳先把盾顶过去，话留到站稳再说。有人叫她“唯一的男人”，她随口接一句：“行，下回你也来当。”她敢借一口劲撑过眼前这阵，缓气时也会明说要人替班。阿飞讲大计划，她看的是旁边那一步谁来站。等她真停下来换气，谁肯主动补上空位，谁的保证才算听进去了。",
        attrs = [59, 100, 36, 85, 48, 31, 4, 0],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Hitpoints = 2 },
        equipment = ["weapons/bludgeon", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 1,
        encounterTitle = "空着的那一步",
        encounterText = "桥头摆着两面旧盾，小鱼贝壳用脚点了点空着的外侧。阿飞夸她可靠大哥，她看向另一面盾：“称呼能再站一个人？”\n\n松掉的扶绳和盾带还有一笔修补费。黑旗可以先谈清轮换，原价邀请；也能承担修补费，换取招募优惠。她等团长把自己那一步说出来。",
        encounterChoices = [
            { label = "站到外侧，说清轮换。（原价邀请）", outcome = "阿飞走过去，把轮换的时辰说清。小鱼留下原价邀请，顺手纠正他的摆盾姿势。“大哥先练这步。”她说得很短。", cost = 0, hireDiscount = 0 },
            { label = "支付扶绳与盾带修补费。（招募优惠）", outcome = "修补费结清，小鱼查过收据，给黑旗报出优惠价。扶绳能修好，谁来接盾仍按刚才谈的算；邀请就留在那面旧盾旁。", cost = 60, hireDiscount = 90 }
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
        description = "阿飞一嗓子能把王怼怼吓一跳，她回过神来，三个问题就把团长问住：去哪儿，做什么，谁接应？营里拿恐飞派和太子的名号逗她，她把歪王冠往椅背一挂，继续等答案。声音越响，她越怕漏听了正事。想让她少怼一句并不难，把上一句说全就行；真让太子自己发令，她也正在学着把令牌拿稳。",
        attrs = [52, 96, 45, 108, 52, 36, 4, 3],
        stars = { Bravery = 2, Initiative = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 1,
        encounterTitle = "太子不接糊涂口信",
        encounterText = "传令牌一翻，三个问题露在背面。阿飞把集合点说出两个版本，王怼怼便停住脚步。旁人递来歪王冠，她挂上椅背：“先答这个。”\n\n旧口信的核对费还没人认领。黑旗可以把安排讲全，按原价邀请；付清这笔费用，她也愿意议一个较低的招募价。",
        encounterChoices = [
            { label = "逐项说清集合安排。（原价邀请）", outcome = "三个问题答完，怼怼终于翻回令牌，留下原价邀请。“下次也这么说。”王冠还在椅背，团长倒已被她安排得很明白。", cost = 0, hireDiscount = 0 },
            { label = "付清旧口信核对费。（招募优惠）", outcome = "核对费结清，怼怼把优惠价写在招募条件旁，又从头读了一遍。“这回没有第三个集合点吧？”邀请留下，问题也没少。", cost = 50, hireDiscount = 80 }
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
        description = "老蔡听完计划，往往先抽走地图上的那座桥。阿飞的豪言还没收住，队尾已经被几枚木旗困在了另一岸。他说话不响，坏消息却总能落到具体的位置上。最后翻过那面留在险处的旗，背面常是他自己的名字。他也会画错，愿意听人改图；只是新的路线摆上桌，接应谁来做，也得一并说清。",
        attrs = [55, 99, 48, 97, 58, 37, 5, 3],
        stars = { MeleeDefense = 3, Bravery = 2, Hitpoints = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/padded_surcoat", "helmets/aketon_cap"],
        bag = ["weapons/warfork"],
        chapter = 2,
        encounterTitle = "先抽掉这座桥",
        encounterText = "阿飞刚说这趟稳妥，老蔡便抽走桌上代表桥梁的木块。几枚队尾的木旗留在另一岸，最后那面翻过来，背面是老蔡自己的名字。\n\n“桥没了，谁接人？”他等答案，也把地形图查阅费摆到一旁。先把后路谈完，可原价邀请；分担查图费，可以重议招募价。",
        encounterChoices = [
            { label = "把队尾和接应谈明白。（原价邀请）", outcome = "两人把几种走法都摆了一遍，老蔡留下原价条件。他收起木旗，那块桥木还在桌边，提醒团长别只记住最好走的一条。", cost = 0, hireDiscount = 0 },
            { label = "分担地形图查阅费。（招募优惠）", outcome = "查图费由黑旗分担，老蔡将这份支持折入优惠报价。邀请留下，他又把那面写着自己名字的旗推到接应的位置。", cost = 70, hireDiscount = 100 }
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
        description = "刘佳俊，大家叫他眼子。两边吵得要掀桌，他一句玩笑能先把人劝回凳子上；笑声落了，漏掉的货、含糊的交接，仍得逐项对清。他带着剑盾，愿意替伙伴接话，也肯直说自己的安排。难事递得多了，他开始在清单上添上时辰、酬劳和自己的名字。阿飞再想只靠熟人两字请他帮忙，怕是得多坐一会儿。",
        attrs = [56, 101, 48, 106, 57, 40, 7, 5],
        stars = { MeleeDefense = 1, Bravery = 1, RangedDefense = 1 },
        equipment = ["weapons/shortsword", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 2,
        encounterTitle = "玩笑说完以后",
        encounterText = "两名雇工把货单拍得直响，棍子也拿了起来。眼子讲了句玩笑，等两人笑出声，才把清单铺到中间：“笑完了，这几箱呢？”\n\n他愿意听黑旗的安排。一起核清交接，可以原价邀请；支付第三方复核费，替他省下调解开支，也能议低招募价。",
        encounterChoices = [
            { label = "一起核清交接。（原价邀请）", outcome = "数量对上，两人各自落了款。眼子这才接着讲刚才的笑话，把原价邀请收好。“肯一起看账，这桌还坐得下去。”", cost = 0, hireDiscount = 0 },
            { label = "支付第三方复核费。（招募优惠）", outcome = "复核费用结清，双方接受了结果。眼子省下原本准备自付的开支，给黑旗留下优惠价。收单前，他仍请两人把名字签完整。", cost = 60, hireDiscount = 90 }
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
        description = "小虎应声时，手已经又检查了一遍蓝旗信袋。掌柜肯提前盖回执，她偏要问信到底交到了谁手里。跑得快她高兴，送得准才肯领钱。带弓上路以后，这个习惯没改，走出一段仍要回头看队尾。阿飞想临时换安排可以商量；想把未办完的事说成办妥，她会把那张回执重新推回来。",
        attrs = [50, 93, 43, 106, 46, 53, 2, 5],
        stars = { RangedSkill = 2, Bravery = 1 },
        equipment = ["weapons/hunting_bow", "ammo/quiver_of_arrows", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "盖好印也不算送到",
        encounterText = "掌柜催小虎领钱，桌上的回执早盖好了印。她却从蓝旗信袋摸出那封未送达的信：“收信的人在哪？”掌柜顿时没再催。\n\n她把空回执压平，听黑旗谈同行。愿意容她核清去向，可按原价邀请；分担驿站查档费，她也会下调招募报价。",
        encounterChoices = [
            { label = "答应先核实信件去向。（原价邀请）", outcome = "小虎在回执上写明未送达，再把原价雇用条件说清。信放回袋底，等到能查的时候再查，她肯和黑旗继续谈这一程。", cost = 0, hireDiscount = 0 },
            { label = "分担驿站查档费。（招募优惠）", outcome = "查档费得到支持，小虎留下优惠报价。空回执仍没填上名字，她把信袋扣好，先将这笔费用另记了一行。", cost = 50, hireDiscount = 80 }
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
        description = "看过小宁的地图，就知道“外星人”这外号没白叫。河像面饼，城是圆圈，最要紧的岔口偏只画在她脑子里；一想入神，嘴角还差点把纸洇湿。阿飞听得发愣，小月牙已经替符号取起名字。她也会把自己绕进去，可从第一笔耐心问起，偶尔真能找到别人漏掉的路。公用地图如今得再找个人看懂，她对此颇不服气。",
        attrs = [49, 91, 39, 101, 48, 56, 3, 7],
        stars = { RangedSkill = 2, RangedDefense = 1 },
        equipment = ["weapons/light_crossbow", "ammo/quiver_of_bolts", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "先说这个圆圈是什么",
        encounterText = "路图缺了一角，城名又被口水洇开。小宁指着一个圆圈，先讲起晚饭；阿飞问河在哪，她才想起该擦嘴。小月牙正给这套符号起名，抹茶已经护住账本。\n\n先听她从头解释，可以原价邀请。地图铺也能补抄缺页，替她付清费用，便能议低招募价。",
        encounterChoices = [
            { label = "从第一个怪符号听起。（原价邀请）", outcome = "河和饭铺终于分开，小宁在图角补了一句说明，留下原价邀请。阿飞的旗子却又被她画出两条腿，她坚持说这样更好认。", cost = 0, hireDiscount = 0 },
            { label = "支付缺页路图补抄费。（招募优惠）", outcome = "补抄费结清，小宁卷好新纸，给出优惠价。旧图也没扔，她说那张有些新图没有的东西。阿飞看了看，大概是口水印。", cost = 60, hireDiscount = 90 }
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
        description = "鼓点一响，小胖的脚就闲不住。卡拍、转身、收重心，空桶倒下的声音都能接进下一拍。阿飞拿嘉豪步伐挑战，她让帅子敲鼓，专等团长先踩乱。可换上盾甲，她自己也会被重量带歪，笑完就把那一步拆开重来。夜里鼓停了，门口还响着磨鞋底的动静，多半是第四拍又没让她满意。",
        attrs = [60, 106, 40, 89, 55, 31, 7, 2],
        stars = { Stamina = 2, MeleeDefense = 1 },
        equipment = ["weapons/hand_axe", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 2,
        encounterTitle = "那只桶正好倒在第四拍",
        encounterText = "小胖转过半圈，阿飞的嘉豪步伐便撞倒空桶。她把响声接进下一拍，招手请笑得最响的团长再来。帅子的鼓槌已经举好，掌柜也递来了场租和地板修整单。\n\n黑旗可以先聊步子，原价留邀请；分担这笔练习开支，她也肯下调招募价。",
        encounterChoices = [
            { label = "跟着节拍再试一轮。（原价邀请）", outcome = "第四拍终于没撞桶，小胖笑着留下原价条件。她约好有鼓声时再比，阿飞先确认了一遍，旁边那只桶会不会搬走。", cost = 0, hireDiscount = 0 },
            { label = "分担场租与地板修整费。（招募优惠）", outcome = "场租与修整费结清，小胖留下优惠价，把桶挪回角落。“行，给嘉豪让点场地。”鼓点一响，她又示意阿飞跟上。", cost = 70, hireDiscount = 100 }
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
        description = "凳上只有一顶帽子，大鹅也能喊出满屋子的“有人！”去打水的同伴还没回来，她先把位置占得稳稳当当。身后有自己人，她敢替大家争地盘；身后少了谁，她又会猛地回头，冲锋的嗓门原样拿来叫人。鹅势欺人的名号很响，她实际惦记的，无非是那个小小的窝：离开的人，回来还坐得到自己的地方。",
        attrs = [59, 99, 44, 91, 53, 33, 8, 2],
        stars = { MeleeDefense = 3, Bravery = 2, Hitpoints = 1 },
        equipment = ["weapons/militia_spear", "shields/wooden_shield", "armor/padded_surcoat", "helmets/hood"],
        bag = [],
        chapter = 2,
        encounterTitle = "帽子在，人就有位置",
        encounterText = "凳上只有一顶帽子，大鹅却喊着有人，把伸手的阿飞挡回去。去打水的同伴恰好从门口进来，她一扬下巴：“看见没？”\n\n说起黑旗，她先问营地怎么留位置。旧营位还有席位和茶水账要结，替她付清，可议招募优惠；先把共同规矩谈好，也能原价留邀请。",
        encounterChoices = [
            { label = "先把营地规矩说好。（原价邀请）", outcome = "规矩谈定，大鹅留下原价条件，把帽子递回同伴。阿飞这回坐到了真空着的地方，她才点头让他接着说。", cost = 0, hireDiscount = 0 },
            { label = "结清旧营位席位与茶水账。（招募优惠）", outcome = "旧营位的账结清，大鹅改低招募价，先替同伴收好帽子，再替黑旗留出空位。“这个可以坐。”这次她说得很响亮。", cost = 50, hireDiscount = 80 }
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
        description = "蔓越莓把红线一拉，桌边就没人好抢话了。“停。坐下。再说一遍。”她句子短，眼神催得更紧，阿飞想插句排场都找不到空。当大谋指出漏算的木片，她看一眼，改线，再让他继续讲。轻弩的箭袋也系着红绳，看见它便该先看清彼此站哪边。要她服气，漂亮话不大管用，一项清楚的安排倒能让她点头。",
        attrs = [48, 95, 42, 113, 45, 54, 3, 6],
        stars = { RangedSkill = 2, Initiative = 2 },
        equipment = ["weapons/light_crossbow", "ammo/quiver_of_bolts", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 2,
        encounterTitle = "先把顺序说一遍",
        encounterText = "红线把桌面划成两边，蔓越莓让阿飞依次说谁前进、谁等待。他刚想加一句威风，她便敲桌：“先答这句。”大谋指出一枚漏算的木片，她看过，立刻重摆。\n\n这种讨论规矩可以先谈定，原价留邀请；分担推演场租，她也愿意给黑旗优惠报价。",
        encounterChoices = [
            { label = "按顺序把安排说清。（原价邀请）", outcome = "最后一个问题答完，红线才松下来。蔓越莓留下原价条件，又把漏算的木片收好。下一回推演，这枚得先摆上桌。", cost = 0, hireDiscount = 0 },
            { label = "分担推演场租。（招募优惠）", outcome = "场租得到分担，蔓越莓报出优惠价，请阿飞复述一遍。团长这次答得很顺，她终于点头，把条件写给黑旗。", cost = 60, hireDiscount = 90 }
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
        description = "罗一可的口袋总比别人鼓，干饼、栗子、舍不得扔的扣子，各藏各的地方。阿飞喊仓鼠，她先摸一摸粮袋：“先过今晚。”弯刀是护送的家伙，路费另系一个结，嘴馋的团长想分半张饼，也得先问。带足储备让她安心，可她渐渐也想攒一处有窗的屋檐。哪天留下，哪天再走，最好都能由自己挑。",
        attrs = [51, 98, 37, 116, 52, 41, 4, 5],
        stars = { MeleeSkill = 1, Initiative = 2 },
        equipment = ["weapons/falchion", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 2,
        encounterTitle = "仓鼠的第三只口袋",
        encounterText = "罗一可从第三只口袋摸出半张干饼。阿飞问是不是准备过冬，她把饼收回：“先过今晚。”商贩递来的大粮囊被放回架上，她不想背得连刀都拔不出来。\n\n黑旗要雇护送的人，她先问工钱和伙食。说清条件，可原价邀请；分担眼前袋口的修补费，还能议一份招募优惠。",
        encounterChoices = [
            { label = "说清工钱与伙食。（原价邀请）", outcome = "罗一可把约定的那份另系一个结，留下原价条件。最后半张饼还在自己手边，阿飞看看，终于先问了句能不能分一点。", cost = 0, hireDiscount = 0 },
            { label = "出钱补好漏粮的袋口。（招募优惠）", outcome = "袋口补好，栗子终于不用一路捡回。罗一可应下优惠招募价，把省下的盘缠收好，又递给阿飞一颗完整的栗子。", cost = 40, hireDiscount = 60 }
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
        description = "可可认出朋友，先挪凳子，再问吃过没有。刚来的搬运工也能被她招到桌边，不一会儿就有了名字和去处。大家笑叫保可梦，她举弩时却很认真，侧后落着谁总要看一眼。阿飞一句“有你在”还没说完，她已经把轮到谁帮忙问了回来。自己人可以一起热闹，也得一起收拾热闹过后的桌子。",
        attrs = [53, 96, 46, 100, 50, 52, 5, 5],
        stars = { MeleeDefense = 3, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "布条上没有名字",
        encounterText = "可可替黑旗挪好凳子，又把门边没座的搬运工招进来。布条上没写名字，她便一个个问，片刻后连下一程去哪都聊上了。\n\n弩具整修单还在手边。黑旗可以先坐下，按原价谈同行；分担这笔整修费，她也愿意给一份较低的招募报价。",
        encounterChoices = [
            { label = "坐下来，把来人认清。（原价邀请）", outcome = "去处和名字都问清，可可把原价条件留给黑旗。她又把凳子往里挪了点，刚来的搬运工也能靠桌吃饭了。", cost = 0, hireDiscount = 0 },
            { label = "分担弩具整修费。（招募优惠）", outcome = "整修费按约分担，可可写下优惠价，再把账纸收好。“这笔说定了。刚才那位叫什么来着？”人和账，她都想记清。", cost = 70, hireDiscount = 100 }
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
        description = "余想最警觉的夸奖是“你最让人放心”——后面常跟着一班没人肯接的夜岗。五老压阵喊得再响，她也只问长矛稳不稳、交接谁来签。说起下岗，脸冷，话短，顺手还能让想逃班的人吃一句讽刺。阿飞请她守队伍，她先看轮值表。她站得久，也记得清，哪个名字一直躲在替班栏外，别想蒙过去。",
        attrs = [57, 104, 47, 94, 56, 33, 6, 3],
        stars = { Stamina = 1, MeleeDefense = 1, Bravery = 2 },
        equipment = ["weapons/pitchfork", "armor/padded_surcoat", "helmets/hood"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "空着的替班栏",
        encounterText = "旧哨所的掌事终于签下交接，余想将钥匙放回桌上，松了松握矛的手。大谋提起黑旗，她先要轮值表，再看旅店寄存行李的账单。\n\n账可以自己处理，留下原价邀请；黑旗若愿分担，招募价也可再议。她抬眼补一句：“别记成我又多守一班。”",
        encounterChoices = [
            { label = "说清轮值与交班。（原价邀请）", outcome = "余想核过轮值，收下原价邀请，先按自己的安排去取行李。大谋笑着目送，至少这回，下岗的人真能走出门了。", cost = 0, hireDiscount = 0 },
            { label = "分担行李寄存费。（招募优惠）", outcome = "寄存费分担清楚，余想留下优惠价。抹茶把补贴和轮值分列两栏，她看过才点头，长矛也终于从桌旁拿了起来。", cost = 60, hireDiscount = 90 }
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
        description = "童猪把木熊一摆，桌边几个自信满满的大哥就有点危险了。小熊出击前先懂规则，她讲得一本正经，眼里却分明等着看人猜错。阿飞抢答，大谋不服，抹茶要核账，恰好都很适合坐到她面前。输家可以要求再讲一遍，悄悄改掉上一局可不行。至于同行，她除了问待遇，也想看看这三位队长下一回谁先认输。",
        attrs = [56, 94, 48, 104, 49, 38, 4, 3],
        stars = { Hitpoints = 1, Bravery = 2 },
        equipment = ["weapons/wooden_stick", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "再讲一遍，还是先认输",
        encounterText = "抹茶和大谋还在争哪一步算错，童猪便翻过木熊，指着底下的规则。阿飞想插话，被她推过来一只杯子：“等号。”掌柜随后把场租单也推了过来。\n\n黑旗可以原价邀请；分担场租，还能议低招募价。她敲敲木熊，先前输掉的那一局照旧记着。",
        encounterChoices = [
            { label = "认下这一局，再听规则。（原价邀请）", outcome = "两位队长总算认输，童猪留下原价条件。她把木熊朝阿飞转过去，神情很和气，团长却莫名觉得下一局该轮到自己。", cost = 0, hireDiscount = 0 },
            { label = "分担游戏桌场租。（招募优惠）", outcome = "场租结清，童猪报出优惠价，又将木熊摆回原位。“钱算完了，输赢也算完了。”两位队长看着它，没找到重来的借口。", cost = 40, hireDiscount = 70 }
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
        description = "美伢记得鼓点前那口气，也记得台侧哪块板子会绊脚。大王舞跳得热闹，她却总能看出主角哪一拍该让路。阿飞以为请来一位炒热场子的高手，她已经把两把挡路的椅子搬开，反问谁来排下一段。夸天赋她听惯了，肯认真谈位置、报酬和配合，倒能让她多留一会儿。到了谢幕，她也知道该把谁拉到灯下。",
        attrs = [54, 101, 43, 109, 56, 37, 5, 3],
        stars = { MeleeSkill = 1, Stamina = 1, Initiative = 1 },
        equipment = ["weapons/warfork", "armor/padded_surcoat"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "请团长走过这两把椅子",
        encounterText = "美伢把两把椅子留在过道，请阿飞照刚才说的步子走一遍。披风果然挂住了。鼓手笑出声，又被她问回那半拍的事。\n\n断掉的鼓带有了修理报价，她也想谈黑旗的安排。听完她要负责的位置，可原价邀请；分担修理费，她会下调招募报价。",
        encounterChoices = [
            { label = "听她排位置，谈清合作。（原价邀请）", outcome = "阿飞收好披风，美伢把想负责的动作逐个讲清，留下原价条件。鼓手又说别抢拍，她回一句：“你倒是敲稳。”两人都笑了。", cost = 0, hireDiscount = 0 },
            { label = "分担鼓带修理费。（招募优惠）", outcome = "鼓带修理费分担妥当，美伢留下优惠价，搬开挡路的椅子。真正同行后的位置还要再谈，团长至少先学会从这里走过去。", cost = 60, hireDiscount = 100 }
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
        description = "秦国的神，招式名字一个比一个响。玩蛇真正试招时，问的却只是：“你哪一步开始站不住？”木桩上的蛇痕弯了又改，她能为半寸落脚和大谋争到天黑。阿飞只要安静数清次数，偶尔也算个合用的帮手。她爱赢，也爱找能把自己难住的对手。黑旗的旗号还没谈妥，下一招怎么破，她倒已经惦记上了。",
        attrs = [52, 98, 39, 111, 57, 34, 6, 4],
        stars = { MeleeSkill = 2, Initiative = 1 },
        equipment = ["weapons/shortsword", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "先别讲，把脚放这里",
        encounterText = "玩蛇和大谋将两只桶搬来搬去，各自坚持这一步更省力。阿飞数到一半忘了次数，门口的看客已经换了一拨。看场人递来追加场租，两人才停下。\n\n原价邀请可以留，分担场租也能议低招募价。玩蛇先问大谋：“同行以后，这招还接着试？”",
        encounterChoices = [
            { label = "约好继续试招。（原价邀请）", outcome = "大谋说有空再比，玩蛇便留下原价条件，木剑往肩上一搁。刚走两步，她又回头指出桶应该放在哪边，显然还没试完。", cost = 0, hireDiscount = 0 },
            { label = "分担试招场租。（招募优惠）", outcome = "追加场租结清，玩蛇将招募价改低。她谢过这份支持，又把大谋叫回半步：“钱算清了，刚才那招可还没算清。”", cost = 60, hireDiscount = 90 }
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
        description = "涂涂的行囊里总有下一站的打算，营火边的歌唱完，却可能又多坐一会儿。有人没讲完笑话，她愿意听；有人拿“再留一晚”替她定了去处，她便把路票摊开。她喜欢同行的热闹，也会认真告诉伙伴什么时候告别。黑旗吵起来未必动听，倒常有让她想接上一句的地方。下一段走不走，她还想亲自看看。",
        attrs = [50, 100, 50, 103, 48, 40, 3, 4],
        stars = { Bravery = 2, Stamina = 1 },
        equipment = ["weapons/lute", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "这一段，先写清楚",
        encounterText = "涂涂回来取手套，听见黑旗谈下一程，便在门口又停了停。她摊开仍有效的路票，问这条路能不能绕过想去的镇子。\n\n原价邀请可以先留，让她比较去处；黑旗若分担改签费，她愿意降低招募报价。手套已拿到，她却还没急着走。",
        encounterChoices = [
            { label = "把下一程谈清，让她再想想。（原价邀请）", outcome = "涂涂收好路票和原价邀请，坐回火边，指了指自己想去的镇子。刚才没唱完的那半段，她说等话谈完再唱。", cost = 0, hireDiscount = 0 },
            { label = "分担路票改签费。（招募优惠）", outcome = "改签费按约分担，涂涂留下优惠价。票上的去处改了，正式同行还待双方说定；她把手套放好，重新端起那杯茶。", cost = 40, hireDiscount = 60 }
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
        description = "奶盖讲胜负时，仿佛教官都得排队来听。盾真拿到手里，她又能退得比讲解快上三拍。缩进奶盖以后，解释照样从盾后飘出来，营地想安静一会儿都难。阿飞笑她嘴硬，她回一句“本王只是还没开始”，转头却悄悄系紧盾带。牛吹得大，脸也丢过，好在下一轮喊她上场，还是能看见她把盾捡起来。",
        attrs = [52, 95, 33, 107, 46, 42, 3, 2],
        stars = { RangedSkill = 1, MeleeDefense = 2 },
        equipment = ["weapons/throwing_axe", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "盾后面还有一句",
        encounterText = "盾立歪了，奶盖还在后面解释：“本王正在研究对手。”大谋一低头，她便赶紧把磨破的盾带藏了藏。研究完了，下一次试训还得重新上场。\n\n黑旗可原价留邀请；补贴盾带修理费，也能换取招募优惠。她嘴上仍说考虑，耳朵已经在等阿飞报条件。",
        encounterChoices = [
            { label = "认真问她想练什么。（原价邀请）", outcome = "阿飞问到下一次试训，奶盖马上声称早有安排，留下原价条件。盾往旁边一挪，里面其实已经备好了重新系带的绳。", cost = 0, hireDiscount = 0 },
            { label = "补贴盾带修理费。（招募优惠）", outcome = "修理费补贴清楚，奶盖改低招募价，宣布这叫英雄相惜。大谋看看她刚系紧的盾带，暂时决定让本王威风这一小会儿。", cost = 40, hireDiscount = 60 }
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
        description = "锁扣“咔哒”响过，小杰才肯转身。有人说大家都认识，她反而再查一次车门；说东西大概会还，她把借据推得更近。备用钥匙一把不少，谁拿走的也得留名。她和抹茶聊起借还办法能聊很久，遇见欠账的熟人，脸又板得飞快。阿飞要请她同行，最好先讲清分工，别一开口就把全营地的钥匙都递过来。",
        attrs = [58, 105, 39, 96, 51, 35, 4, 3],
        stars = { Stamina = 2, Hitpoints = 1 },
        equipment = ["weapons/pickaxe", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "未来团长，现在哪位担保",
        encounterText = "借走的绳钩终于找到了人，小杰却还不满意：每借一次都得回来找她开箱。抹茶正帮她列交接办法，锁匠也报好了备用钥匙的费用。\n\n原价邀请可以留；分担配钥匙费，招募价便可再议。阿飞伸手看钥匙，她先把手收回：“看可以，拿走先写名字。”",
        encounterChoices = [
            { label = "把借还和分工谈好。（原价邀请）", outcome = "借还办法一条条记下，小杰留下原价条件。抹茶问得仔细，她也答得起劲，箱子终于有了不用每次都叫她回来的办法。", cost = 0, hireDiscount = 0 },
            { label = "分担备用钥匙配制费。（招募优惠）", outcome = "配钥匙费分担清楚，小杰留下优惠价，把新钥匙的位置逐一记好。阿飞的名字没写在借用栏，这次他也没乱伸手。", cost = 50, hireDiscount = 80 }
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
        description = "bula一抖钱袋，台下便以为里面又多了几枚；散场往桌上一倒，她却能逐枚数清。戏法让人笑，账目也能笑着算，只是缺多少钱就说多少钱。抹茶问总账平不平，她还要问买回来的东西谁来用。阿飞爱排场，她倒不反对；等账单到了，刚才鼓掌的人也得留在桌边，别一起跑去看天色。",
        attrs = [54, 98, 45, 98, 49, 40, 4, 5],
        stars = { Bravery = 1, RangedDefense = 1, Hitpoints = 1 },
        equipment = ["weapons/bludgeon", "shields/wooden_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "这枚铜片付不了粮钱",
        encounterText = "阿飞摸着那枚戏法铜片，问能买多少粮。bula将它拨到桌角，又把真正的账纸铺开：“这枚买掌声，粮钱看这里。”抹茶笑着坐近了点。\n\n道具布料费用还未结，黑旗可分担这笔以议低招募价；先谈清采购打算，也能留下原价邀请。",
        encounterChoices = [
            { label = "一起核对真正的采买需要。（原价邀请）", outcome = "bula听完采买安排，留下原价条件。那枚道具铜片仍放在桌边，阿飞再讲排场，抹茶就轻轻指一下它。", cost = 0, hireDiscount = 0 },
            { label = "分担道具布料费。（招募优惠）", outcome = "布料费分担妥当，bula把支持和优惠都写明。她留好报价，抖了抖钱袋：“这回真省下了。要数给你看吗？”", cost = 50, hireDiscount = 80 }
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
        description = "苏袜讲一条路，脚尖已经指着下一个路口。踩点、抢半步、急刹，她知道哪里能快，哪里得立刻收脚。可腿上记得的转弯，画到纸上常少一半，车夫拿车轮印子来问，她才不情愿地停下重画。黑旗想请她领路，她想继续找新路，也想让跟在后面的人听懂。下一个岔口，或许该先等大家看清再走。",
        attrs = [49, 101, 38, 121, 49, 46, 4, 6],
        stars = { Initiative = 3, Stamina = 1 },
        equipment = ["weapons/javelin", "shields/buckler_shield", "armor/thick_tunic"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "到底是哪只靴子",
        encounterText = "苏袜说近路能走，车夫偏说走不了。两人争到岔口，才发现一个说靴子，一个说车轮。她在地上分画两条线，阿飞总算跟上了话。\n\n抄图铺已报重绘费用。黑旗可原价邀请；分担补图费，还能重议招募价。苏袜先把能走的人和车都标清。",
        encounterChoices = [
            { label = "听完两条路适合谁。（原价邀请）", outcome = "车夫不再摇头，苏袜也将原价邀请收好。她多画了一只靴子，又嫌太慢，索性写上两个字：步行。阿飞这次终于看懂了。", cost = 0, hireDiscount = 0 },
            { label = "分担路线重绘费。（招募优惠）", outcome = "补图费按约分担，苏袜留下优惠报价。她把新图转向阿飞，指着岔口等他复述，直到团长不再把车赶上那条小径。", cost = 60, hireDiscount = 90 }
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
        description = "千涵把003号木牌擦得发亮，旁人夸一句传奇，她反倒急着把练习簿打开：这一段还没跑完。短坡起步要快，后半程要留气，她把目标拆成一段段，空着的格子一格格填。阿飞想替她起个响亮名号，她宁肯先比一次眼前的坡。003只是号码，却也记着她从哪里起跑；下一程，她仍想认真争。",
        attrs = [53, 99, 41, 103, 53, 36, 5, 3],
        stars = { MeleeSkill = 2, MeleeDefense = 1 },
        equipment = ["weapons/militia_spear", "shields/wooden_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 3,
        encounterTitle = "别替003写得太快",
        encounterText = "003木牌又擦了一遍，千涵将练习纸给阿飞看。团长才说传奇，她就指住下一格：“这个还没跑。”场边的木桩和标距绳要租，费用已列清。\n\n原价邀请可以先留；黑旗若分担场具租费，她也愿意降低招募报价。下一段的目标，她仍想按自己的进度定。",
        encounterChoices = [
            { label = "听她说完下一段目标。（原价邀请）", outcome = "阿飞这回没替003改名，千涵收好原价条件，把新目标写进练习纸。木牌仍摆在最亮处，旁边那一格就等她亲自填。", cost = 0, hireDiscount = 0 },
            { label = "分担练习场具租费。（招募优惠）", outcome = "场具租费分担清楚，千涵留下优惠价，认真道谢。她量好起点和终点，回头请阿飞看着，别又提前把成绩喊了出来。", cost = 50, hireDiscount = 80 }
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
        description = "“芷芷，搭把手！”场子一乱，总先有人喊王大芷。幕布、架脚、门口的空当，她看一眼就知道该撑哪里。等大家终于能开演，她自己的节目却常被挤到散席以后。那张名字折得整齐，藏在袖口，她可没忘。黑旗要请她护场，她愿意谈，也得把自己的安排一并写上。下一回谢幕，她还想站到前面应一声。",
        attrs = [56, 102, 46, 95, 52, 33, 7, 4],
        stars = { MeleeDefense = 2, Stamina = 1, Bravery = 1 },
        equipment = ["weapons/wooden_flail", "shields/wooden_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 3,
        encounterTitle = "谢幕名单漏了谁",
        encounterText = "幕布架终于站稳，王大芷一看节目纸，自己的登场却挪到了散席以后。她拿过笔，将名字往上挪了一行，请掌事重新看。裂口幕布的修补单也在一旁。\n\n黑旗可原价邀请；分担修补费，可以议低招募价。她先指着节目纸：“这回也听听我想做什么。”",
        encounterChoices = [
            { label = "听她自己的登场安排。（原价邀请）", outcome = "三位队长听完，王大芷留下原价条件。她把节目纸折好，名字落在自己挑的位置，袖口也终于不用藏得那么深。", cost = 0, hireDiscount = 0 },
            { label = "分担幕布修补费。（招募优惠）", outcome = "修补费分担妥当，王大芷留下优惠报价。幕布能补了，节目纸也还摊着；她趁掌事回来，再确认一遍登场的时辰。", cost = 70, hireDiscount = 100 }
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
        description = "奶团吕布的名号一响，递给瑶瑶牙的挑战书就比委托还多。她爱赢，正面的一击也够干脆，只是总有人想拿她的好胜省掉报酬。抹茶把护送安排铺开，她反而先看这张纸。往前能打出缺口，回头也得找得到同伴的旗。黑旗肯把任务和约定讲实在，她就肯把那杆长柄兵器一起带上。",
        attrs = [58, 104, 40, 84, 55, 29, 3, 0],
        stars = { MeleeSkill = 2, MeleeDefense = 1, Stamina = 2 },
        equipment = ["weapons/woodcutters_axe", "armor/padded_surcoat", "helmets/aketon_cap"],
        bag = ["weapons/knife"],
        chapter = 3,
        encounterTitle = "先把委托写在名号上面",
        encounterText = "挑战书把“奶团吕布”写得很大，瑶瑶牙看了一眼，却先拉近抹茶那张护送安排：“这趟答应的是哪件？”看客只好先等。\n\n斧刃整修费已列明，黑旗若分担，她愿意下调招募价；原价邀请也能留下，等任务谈清再定。长柄斧就在身边，暂时没为叫好声举起来。",
        encounterChoices = [
            { label = "按实际护送任务谈同行。（原价邀请）", outcome = "任务讲清，瑶瑶牙留下原价条件，将挑战书压到下面。阿飞问那场比试呢，她说先把答应的这趟安排好。", cost = 0, hireDiscount = 0 },
            { label = "分担斧刃整修费。（招募优惠）", outcome = "整修费按约分担，瑶瑶牙报出优惠价，扶正长柄斧。她再核对一遍护送的时辰，才将黑旗的邀请收下考虑。", cost = 80, hireDiscount = 120 }
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
        description = "羊咩咩的小车挂着铃，风吹会响，轴松了也会响，她听得出差别。直路能追，弯前得留力，贴着哪条线走还要看包裹有多重。掌事只夸抵达次序，她便把完好的封蜡摆到计时牌旁，再谈这趟工钱。请她随黑旗上路，先让她讲完车况。路可以争快，送到手里的东西，她想一件不坏。",
        attrs = [59, 100, 44, 97, 50, 38, 5, 4],
        stars = { Hitpoints = 2, Bravery = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/padded_surcoat"],
        bag = [],
        chapter = 3,
        encounterTitle = "计时牌旁的碎封蜡",
        encounterText = "掌事指着计时牌，羊咩咩便把完好的包裹推到旁边：“这个也看看。”轮轴的小铃又颤出杂音，她侧耳一听，记下了要修的位置。\n\n车匠报好检修费，黑旗可分担以议低招募价；先听完交付和车况，也能原价留邀请。她还等掌事把这趟工钱算明白。",
        encounterChoices = [
            { label = "听清车况与交付要求。（原价邀请）", outcome = "羊咩咩留下原价条件，继续指着封蜡同掌事谈账。阿飞在一旁看了会儿，终于也把计时牌和包裹一起摆正。", cost = 0, hireDiscount = 0 },
            { label = "分担轮轴检修费。（招募优惠）", outcome = "检修费分担清楚，羊咩咩报出优惠价，试了试小铃。“下回听见这声，弯前就先松一点。”她让团长再听了一遍。", cost = 50, hireDiscount = 80 }
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
        description = "锣一响，宋暖阳先缩一下鹌鹑纹兜帽，过一会儿又探头把问题问完。集市的凯旋告示她写过，夸到“所向无敌”，笔却总要停住。黑旗暂时没多少漂亮战绩，三位队长倒能吵出不少值得记的事。谁嘴硬，谁漏算，谁笑完又回来帮忙，她都想再听一点。空白页还有很多，下一段跟着走，兴许就能写下去。",
        attrs = [60, 104, 50, 108, 58, 39, 6, 5],
        stars = { MeleeSkill = 1, Bravery = 1, Hitpoints = 1 },
        equipment = ["weapons/militia_spear", "shields/buckler_shield", "armor/thick_tunic"],
        bag = [],
        chapter = 4,
        encounterTitle = "所向无敌，从哪一场写起",
        encounterText = "雇主只留半份纸墨钱，告示上却要写所向无敌。宋暖阳把假凯旋翻了面，听阿飞、大谋和抹茶当场争了三句，笔反而动了一下。\n\n黑旗可原价邀请；补贴列明的纸墨开支，也能商议招募优惠。摊外锣响，她缩起兜帽，又探头等这三人的下一句。",
        encounterChoices = [
            { label = "邀她记录沿途见闻。（原价邀请）", outcome = "宋暖阳留下原价邀请，又问刚才那场争执从哪开始。阿飞指着乱草稿说都是真的，抹茶补一句：“连算错的也有。”她这回写了不少。", cost = 0, hireDiscount = 0 },
            { label = "补贴纸墨开支。（招募优惠）", outcome = "纸墨费按约补贴，宋暖阳留下优惠报价，翻开一页新纸。旧凯旋仍朝下放着，黑旗的第一行倒从三位队长抢话写起。", cost = 40, hireDiscount = 60 }
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
        description = "溺水小龟得垫个木箱才够得着棋盘，自己的报名牌却一定摆在最前面。飞爹来旁观，她高兴；飞爹伸手代走，她立刻挡住：“这步我来。”她想听意见，也想亲手打出一场能讲给阿飞听的战绩。夜里擦壳，旧纹偶尔泛起深水似的暗光，她很少提，只把亮粉蝴蝶结重新系好。步子慢些，身后谁还跟着，她一直听得见。",
        attrs = [53, 102, 43, 100, 48, 44, 5, 8],
        stars = { MeleeDefense = 3, Bravery = 2, Stamina = 1 },
        equipment = ["weapons/boar_spear", "shields/wooden_shield", "armor/thick_tunic"],
        bag = ["weapons/javelin"],
        chapter = 4,
        encounterTitle = "飞爹先坐观众席",
        encounterText = "阿飞的手刚伸到棋盘边，小龟便轻轻挡住：“飞爹先坐那边。”她将自己的报名牌摆正，还想再试一条进攻路线。\n\n这场比试的参赛费尚未结清。黑旗可原价留邀请；分担费用，她也愿意降低招募报价。棋子怎么走，她已经把手放上去了。",
        encounterChoices = [
            { label = "坐到旁边，让她自己试。（原价邀请）", outcome = "阿飞收手坐好，小龟留下原价邀请，重新盯住棋盘。飞爹有意见等这一场之后再讲，她先要把眼前这一步走完。", cost = 0, hireDiscount = 0 },
            { label = "分担参赛费用。（招募优惠）", outcome = "参赛费按约分担，小龟留下优惠报价，笑着给阿飞指好观众的座位。“飞爹，出钱也不能代走哦。”她说完，认真落下一子。", cost = 50, hireDiscount = 80 }
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
