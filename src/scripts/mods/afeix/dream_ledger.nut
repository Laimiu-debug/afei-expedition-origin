local A = ::AfeixExpedition;
A.dreamPage <- function(event, id) {
    local A = this;
    local screen = { ID = id, Title = "三人同梦", Text = "", Image = "", Banner = "", Characters = [], List = [], Options = [], function start(e) {} };
    screen.PortraitKeys <- [];
    screen.start = function(e) {
        // Native setScreen clears Characters before start; fill the two UI
        // portrait slots here using actual captains, never new actors.
        foreach (key in this.PortraitKeys) {
            local actor = ::AfeixExpedition.findCharacter(key);
            if (actor != null && actor.isAlive() && !actor.isDying()) this.Characters.push(actor.getImagePath());
        }
    };
    if (id == "opening") {
        screen.Title = "黑旗未满";
        screen.Image = "ui/events/event_33.png";
        screen.PortraitKeys = ["afei", "damou"];
        screen.Text = this.get("dream_notice", "") + "天黑了，三个人围着营火摊开地图。上面的镇子一个挨一个，叫得出名字的队友却没几个。黑旗倒是做好了，旗底下就站着他们仨。\n\n阿飞拿树枝戳了戳明天要走的路：‘一路走一路招人，旗先立起来，名字慢慢往上添。三、二、一，放轻松。’\n\n抹茶啪地合上账本：‘轻松？饭钱、修甲钱、工钱，哪样轻松得了。人招来了，还得养得起。’大谋把盾往树上一靠：‘先进城转转，看得上咱们的，就一起带回来。’\n\n火慢慢小了。谁也没想到，这一晚他们仨会做同一个梦。";
        screen.Options.push(this.ledgerOption("看看他们梦到了啥。", function(e) { ::AfeixExpedition.set("dream_intro_page", "opening_dream"); return "opening_dream"; }));
        screen.Options.push(this.ledgerOption("略过梦境战斗。", function(e) { ::AfeixExpedition.skipDream(); return "wake"; }));
    } else if (id == "opening_dream") {
        screen.Image = "ui/events/afeix_douyu.png";
        screen.PortraitKeys = ["afei", "mocha"];
        screen.Text = this.get("dream_notice", "") + "营火的噼啪声听着听着，变成了水声。阿飞一抬头，抹茶和大谋就站在黑旗底下；再往两边一看，刀一十个人全到齐了。脸还是那些脸，手里的家伙却一个比一个亮，人人都像身经百战的老兵。\n\n大谋顶着铁角盔、扛着壁盾站最前面，帅子披着绿甲守另一个口子，已经摆出了战斗脸。抹茶裹着蓝锁衣给弩上弦，李李从黑斗篷里抽出长弓，嘴里念叨着‘这边我来，那边也我来’。瓶队摸了摸斩刀的刃口，金靴的脚感还在；初九拎着钉锤，像只撒欢的小狗在队伍里窜来窜去，哪缺人往哪补。小月牙清点行囊里的飞签，小鱼披着兽甲扛起巨斧，准备开抡；怼怼接过另一面黑旗，小声嘀咕：‘这回可别再倒霉了。’\n\n雾里先是蜘蛛窸窸窣窣，再是狼嚎，接着有什么带鳞的东西在泥里拖着走。最远处，一道橙色背鳍划开黑水，背鳍底下一张笑脸，满嘴尖牙。\n\n先跟着这支百战之师走一趟。梦里死了伤了、掉了装备都不算数；梦一醒，人还得你们仨自己一个个找回来。";
        screen.Options.push(this.ledgerOption("走进这场梦。", function(e) { ::AfeixExpedition.set("dream_notice", ""); ::AfeixExpedition.queueDreamCombat(); return 0; }));
        screen.Options.push(this.ledgerOption("略过梦境战斗。", function(e) { ::AfeixExpedition.skipDream(); return "wake"; }));
    } else if (id == "stage") {
        local d = this.DreamStages[this.dreamStage()];
        screen.Title = d.name;
        screen.Text = this.get("dream_notice", "") + d.text;
        if (this.dreamStage() == 3) {
            screen.Image = "ui/events/afeix_douyu.png";
            screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
        }
        screen.Options.push(this.ledgerOption("接着往前打。", function(e) { ::AfeixExpedition.set("dream_notice", ""); ::AfeixExpedition.queueDreamCombat(); return 0; }));
        screen.Options.push(this.ledgerOption("不打了，醒过来。", function(e) { ::AfeixExpedition.skipDream(); return "wake"; }));
    } else if (id == "wake") {
        screen.Title = "黑旗初醒";
        screen.Image = "ui/events/event_33.png";
        screen.PortraitKeys = ["damou", "afei"];
        screen.Text = "最后一道浪拍过盾沿。传奇兵器还攥在手里，可十个人脚下已经没地方站了。黑旗谁也没丢下，连着旗边最后几个人，一起沉进了水里。\n\n阿飞腾地坐起来。抹茶和大谋几乎同时睁眼，三个人喘得比火堆还响。大谋先开口：‘你们……也梦见了？’抹茶下意识去摸账本，还在；阿飞盯着那面空荡荡的黑旗，好一会儿才点头。\n\n抹茶缓过劲来，当场开始复盘：‘打狼那会儿水就在涨了，我们光顾着看前面。’大谋看了看自己的手：‘最后也没撒手。’阿飞把旗卷好：‘行，记下了。真打到那一步，先找好退路，人得全须全尾带回来。’\n\n装备行囊都在原处，一样没少。梦里全军覆没，醒来还是三个人、一面旗。想再见斗鱼，得先把人一个个找回来。";
        screen.Options.push(this.ledgerOption("看看接下来怎么走。", function(e) { ::AfeixExpedition.set("dream_wake_pending", false); ::AfeixExpedition.set("dream_departure_pending", true); return "departure"; }));
    } else if (id == "departure") {
        screen.Title = "黑旗启程";
        screen.Image = "ui/events/event_16.png";
        screen.PortraitKeys = ["mocha", "afei"];
        screen.Text = "天亮了，三人收起地图。梦里那支队伍身经百战，现实里的黑旗才刚出门。抹茶在账本上记下第一笔：进城补给，修装备，顺便看看谁愿意跟着走。\n\n那些熟面孔散在大陆各处，各忙各的。走得越远，线索越多，条件够了他们自然会出现在招募名单上。带谁走你说了算，一场仗最多上十二个，队伍想怎么搭就怎么搭。\n\n在世界地图按 [color=#bcad8c]F8[/color] 打开黑旗名册，能看伙伴线索、招募条件和战团事务。人还是得去城镇的招募名单里雇。先站稳脚跟，装备和配合慢慢来。\n\n斗鱼在现实大陆上也留了个窝：[color=#bcad8c]梦潮祭场[/color]。名册里的‘再赴梦潮’能标出方位，准备好了得自己走过去。建议11级、装备配齐再去，这回死了伤了可都算数。梦里没打完的那一架，得黑旗自己去打完。";
        screen.Options.push(this.ledgerOption("收好地图，黑旗启程。", function(e) {
            if (e != null && e.m.StoryReview) return 0;
            ::AfeixExpedition.set("dream_departure_pending", false);
            ::AfeixExpedition.set("dream_story_seen", true);
            return 0;
        }));
    } else if (id == "dream_final") {
        screen.Title = "再赴梦潮";
        if (this.get("douyu_final_defeated", false)) screen.Text = "斗鱼已经倒了。梦里那十个人只走到这儿，这一仗是你自己拉起来的黑旗打赢的。";
        else if (!this.get("douyu_final_unlocked", false)) {
            screen.Text = "三位队长围着营火做过同一个梦：刀一十人都成了老兵，雾里的斗鱼照样挡在前面。\n\n可以回看这段梦，再带现在的队伍去打终局。";
            if (this.dreamStatus() == "unseen" && this.canManage()) screen.Options.push(this.ledgerOption("回看三人的梦境序章。", function(e) { ::AfeixExpedition.initializeDreamOpening(); return 0; }));
            else if (this.dreamStatus() == "pending" && this.canManage()) screen.Options.push(this.ledgerOption("继续梦境序章。", function(e) { ::AfeixExpedition.resumeDreamStory(); return 0; }));
            if (!this.canManage()) screen.Text += "\n\n回看梦境得先停在友好城镇旁边，或者找个能扎营的地方扎营，附近不能有敌人。";
            screen.Text += "\n\n" + this.douyuWorldIntel();
            screen.Options.push(this.ledgerOption("把祭场方位记在地图上。", function(e) { ::AfeixExpedition.queueDouyuMapFocus(); return 0; }));
        }
        else {
            screen.Image = "ui/events/afeix_douyu.png";
            screen.Text = this.douyuWorldIntel() + "\n\n斗鱼在梦潮祭场等着黑旗。它会点名扑咬、掀起弹幕洪流、放火箭礼炮，每一招都提前一回合预告。看清楚它要干嘛，留好退路，等它露破绽再上去打。\n\n整理好名册，挑好人从大陆前往祭场，最多上十二个。建议11级、装备配齐；死伤照常算，打不过撤了下次再来。潮声后面还藏着什么，得进了祭场才知道。";
            screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
            screen.Options.push(this.ledgerOption("把祭场方位记在地图上。", function(e) { ::AfeixExpedition.queueDouyuMapFocus(); return 0; }));
        }
        if (this.get("douyu_final_unlocked", false)) {
            if (this.get("dream_wake_pending", false) || this.get("dream_departure_pending", false) || this.get("douyu_final_notice", false))
                screen.Options.push(this.ledgerOption("继续未读的故事。", function(e) { ::AfeixExpedition.resumeDreamStory(); return 0; }));
            else screen.Options.push(this.ledgerOption("回看黑旗启程。", function(e) { ::AfeixExpedition.queueDepartureStoryReview(); return 0; }));
        }
        screen.Options.push(this.ledgerOption("返回黑旗名册。", function(e) { return "home"; }));
    } else if (id == "victory") {
        screen.Title = "梦潮已破";
        screen.Image = "ui/events/afeix_douyu.png";
        screen.Text = "斗鱼终于倒在了黑旗前面。三个人在梦里见过那支百战之师，也见过那支队伍全军覆没。\n\n现在站在这儿的，是一路上一个个招来、一起扛过来的人。收旗，回家。";
        screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
        screen.Options.push(this.ledgerOption("带大家回家。", function(e) { ::AfeixExpedition.set("douyu_final_notice", false); return 0; }));
    } else return null;
    if ((id == "opening" || id == "opening_dream" || id == "wake" || id == "departure") && screen.Image != "")
        screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
    return screen;
};
