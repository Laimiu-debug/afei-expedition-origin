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
        screen.Text = this.get("dream_notice", "") + "夜色压住了道路，阿飞、抹茶与大谋在营火旁摊开地图。镇名一个挨着一个，三人能叫出名字的同行者却还不多。黑旗已经备好，旗下面的队伍仍要慢慢凑齐。\n\n阿飞用树枝点了点明天的路：‘一路走，一路找人。旗子先立起来，名字慢慢添。’\n\n抹茶合上账本：‘吃的、修甲的、发工钱的，都得算进去。人找到了，也得让大家走得下去。’大谋把盾靠在树旁：‘先去镇上看看。愿意同行的人，就一起带回来。’\n\n火光渐低，地图留在三人之间。谁也没有想到，这一夜，他们会走进同一个梦。";
        screen.Options.push(this.ledgerOption("看看他们梦见了什么。", function(e) { ::AfeixExpedition.set("dream_intro_page", "opening_dream"); return "opening_dream"; }));
        screen.Options.push(this.ledgerOption("略过梦境战斗，直接启程。", function(e) { ::AfeixExpedition.skipDream(); return "departure"; }));
    } else if (id == "opening_dream") {
        screen.Image = "ui/events/afeix_douyu.png";
        screen.PortraitKeys = ["afei", "mocha"];
        screen.Text = this.get("dream_notice", "") + "营火的声音变成了水声。阿飞抬头，发现抹茶与大谋也站在黑旗下；再往两边看，刀一十人已经齐聚。熟悉的脸，熟悉的声音，握着的兵器却像陪他们走过了很长的路。\n\n全员11级，传奇装备各循自己的职责。前排已经站稳，盾卫留着接应的位置，远处有人搭好了弩。十人没有多说，便知道下一步该怎样互相照应。\n\n雾中先传来蜘蛛的窸窣声，随后是狼嚎与鳞甲拖过泥地的低响。更远处，一道橙色背鳍划开黑水，尖牙之上的笑脸正望着他们。\n\n先跟着这支成长后的队伍走一程。梦里的伤亡与装备不会带回现实；梦醒之后，三人还得亲自寻找自己的伙伴。";
        screen.Options.push(this.ledgerOption("走进这场梦。", function(e) { ::AfeixExpedition.set("dream_notice", ""); ::AfeixExpedition.queueDreamCombat(); return 0; }));
        screen.Options.push(this.ledgerOption("略过梦境战斗，直接启程。", function(e) { ::AfeixExpedition.skipDream(); return "departure"; }));
    } else if (id == "stage") {
        local d = this.DreamStages[this.dreamStage()];
        screen.Title = d.name;
        screen.Text = this.get("dream_notice", "") + d.text;
        if (this.dreamStage() == 3) {
            screen.Image = "ui/events/afeix_douyu.png";
            screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
        }
        screen.Options.push(this.ledgerOption("继续走向前方。", function(e) { ::AfeixExpedition.set("dream_notice", ""); ::AfeixExpedition.queueDreamCombat(); return 0; }));
        screen.Options.push(this.ledgerOption("让梦停在这里，三人启程。", function(e) { ::AfeixExpedition.skipDream(); return "departure"; }));
    } else if (id == "wake") {
        screen.Title = "黑旗初醒";
        screen.Image = "ui/events/event_33.png";
        screen.PortraitKeys = ["damou", "afei"];
        screen.Text = this.get("dream_wake_reason", "") == "douyu"
            ? "斗鱼的背鳍掀起最后一道梦潮。传奇护甲没有碎，黑旗却连同脚下的空地一起散开。十人的声音被水声吞没，三位队长同时睁开眼。\n\n营火只剩余烬。大谋先问：‘你们也看见了？’抹茶伸手摸向账本，阿飞望着尚未写满的黑旗，过了片刻才点头。\n\n地图仍在，路也仍在。这回他们得亲自找到愿意同行的人，慢慢长成自己的模样，再去面对斗鱼。"
            : "梦中的队伍散进了晨雾。阿飞、抹茶与大谋先后醒来，发现彼此记得同样的黑旗、同样的伙伴，还有雾里的斗鱼。\n\n营火已经熄了，原来的装备与行囊仍在手边。梦只是一个开始；三人整理地图，准备在大陆上寻找愿意同行的人。";
        screen.Options.push(this.ledgerOption("再看一眼脚下的路。", function(e) { ::AfeixExpedition.set("dream_wake_pending", false); ::AfeixExpedition.set("dream_departure_pending", true); return "departure"; }));
    } else if (id == "departure") {
        screen.Title = "黑旗启程";
        screen.Image = "ui/events/event_16.png";
        screen.PortraitKeys = ["mocha", "afei"];
        screen.Text = "天亮了，三人收起地图。梦里那支队伍仿佛已经走过许多场战斗，现实中的黑旗却才刚刚上路。抹茶把第一笔准备工作记进账本：进城补给，修整装备，再看看谁愿意同行。\n\n大陆上的伙伴各有自己的去处与打算。随着旅程推进，他们会留下线索，满足相遇与招募条件后才会出现在名单中。想带谁一起走，由你来选；黑旗下最多十二人出战，队伍可以长成不同的样子。\n\n在世界地图按 [color=#bcad8c]F8[/color] 打开黑旗名册，查看伙伴线索、招募条件与战团事务。入队的伙伴仍从城镇的招募名单雇佣。先让大家站稳脚步，再慢慢补齐装备和配合。\n\n梦里的斗鱼也在现实大陆留下了踪迹：[color=#bcad8c]梦潮祭场[/color]。名册里的‘再赴梦潮’提供地图方位，准备好后需要亲自行军前往。建议达到11级、配齐装备再挑战；这次的伤亡与消耗会留在旅程里，击杀后可取得鲨皮、鱼翅与鲨牙制成的三件传奇装备。";
        screen.Options.push(this.ledgerOption("收好地图，黑旗启程。", function(e) {
            if (e != null && e.m.StoryReview) return 0;
            ::AfeixExpedition.set("dream_departure_pending", false);
            ::AfeixExpedition.set("dream_story_seen", true);
            return 0;
        }));
    } else if (id == "dream_final") {
        screen.Title = "再赴梦潮";
        if (this.get("douyu_final_defeated", false)) screen.Text = "斗鱼已经倒下。梦中的十人曾经走到这里，如今赢下这一战的是你亲自组建的黑旗。";
        else if (!this.get("douyu_final_unlocked", false)) {
            screen.Text = "三位队长曾围着营火做过同一个梦。黑旗之下，刀一十人已经成长，雾中的斗鱼却仍挡着前路。\n\n可以回看这段梦境，再由现在的队伍走向终局。";
            if (this.dreamStatus() == "unseen" && this.canManage()) screen.Options.push(this.ledgerOption("回看三人的梦境序章。", function(e) { ::AfeixExpedition.initializeDreamOpening(); return 0; }));
            else if (this.dreamStatus() == "pending" && this.canManage()) screen.Options.push(this.ledgerOption("继续梦境序章。", function(e) { ::AfeixExpedition.resumeDreamStory(); return 0; }));
            if (!this.canManage()) screen.Text += "\n\n请先到友好城镇旁，或在允许扎营的地点停下扎营，确保附近没有敌军，再回看梦境。";
            screen.Text += "\n\n" + this.douyuWorldIntel();
            screen.Options.push(this.ledgerOption("把祭场方位记在地图上。", function(e) { ::AfeixExpedition.queueDouyuMapFocus(); return 0; }));
        }
        else {
            screen.Image = "ui/events/afeix_douyu.png";
            screen.Text = this.douyuWorldIntel() + "\n\n斗鱼在梦潮祭场等待黑旗。它会预告扑击、掀起弹幕浪潮，并点燃火箭礼炮；观察出招，留好撤路，再抓住失衡后的空隙。\n\n整理现实名册，带上自由选择的队员从大陆前往祭场，最多十二人出战。建议以11级、完备配装挑战；伤亡与消耗照常记入旅程，撤退或败战后可以再来。真正击杀斗鱼，将掉落三件传奇装备。";
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
        screen.Text = "斗鱼终于倒在黑旗之前。三人曾在同一个梦里看见过传奇队伍，也看见过队伍败下阵来。\n\n如今站在这里的人，是一路相遇、作出选择、互相接应后走来的伙伴。黑旗收起，回去的路已经在脚下。";
        screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
        screen.Options.push(this.ledgerOption("带大家回家。", function(e) { ::AfeixExpedition.set("douyu_final_notice", false); return 0; }));
    } else return null;
    if ((id == "opening" || id == "opening_dream" || id == "wake" || id == "departure") && screen.Image != "")
        screen.Text = "[p=c][img]gfx/" + screen.Image + "[/img][/p]" + screen.Text;
    return screen;
};
