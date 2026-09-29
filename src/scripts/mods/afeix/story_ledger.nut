local A = ::AfeixExpedition;
// Returns raw screens only. The main ledger owns notice text and the image wrapper.
A.storyScreen <- function(page) {
    return { ID = page, Text = "", Image = "", List = [], Characters = [], Options = [], function start(event) {} };
};
A.storyPageNumber <- function(text, fallback = 0) {
    try { return text.tointeger(); } catch (error) { return fallback; }
};
A.storyGrowthLabel <- function(key) {
    local names = { locked = "待历练", ready = "可以成长", done = "已成长", unavailable = "本人不在队" };
    local state = this.growthStatus(key);
    return names[state];
};
A.storyGrowthChoice <- function(key, index) {
    local choice = this.MemberGrowth[key].choices[index];
    return this.ledgerAction(choice.label, function() { return ::AfeixExpedition.resolveGrowth(key, index); }, "member_growth:" + key);
};
A.storyRootChoice <- function(id, index) {
    return this.ledgerAction(this.RootStories[id].choices[index].label,
        function() { return ::AfeixExpedition.resolveRoot(id, index); }, "roots:" + id);
};
A.storyLedgerPage <- function(event, page) {
    local parts = split(page, ":"), kind = parts[0];
    if (kind != "growth" && kind != "member_growth" && kind != "member_growth_chapter"
        && kind != "roots" && kind != "bicycle" && kind != "bicycle_release_confirm") return null;
    local A = ::AfeixExpedition, screen = A.storyScreen(page);
    local locked = (kind == "member_growth" && parts.len() > 1 && parts[1] in A.Characters && !A.growthKnown(parts[1]))
        || ((kind == "bicycle" || kind == "bicycle_release_confirm") && !A.bicycleKnown())
        || (kind == "roots" && parts.len() > 1 && parts[1] in A.RootStories && !A.rootKnown(parts[1]));
    if (locked) {
        screen.Text = "这里还没有留下记录。";
        screen.Options.push(A.ledgerNav("合上这一页", "home"));
        return screen;
    }
    if (kind == "growth") {
        screen.Text = "旅途旧事\n\n这里可以重看已经发生的故事，也可以继续之前没聊完的话题。";
        if (A.knownGrowth().len() > 0) screen.Options.push(A.ledgerNav("营火旁的交谈", "member_growth"));
        if (A.promotionKnown() || A.feidieKnown()) screen.Options.push(A.ledgerNav("阿飞的抉择", "promotion"));
        if (A.knownRoots().len() > 0) screen.Options.push(A.ledgerNav("信件与留言", "roots:0"));
        if (A.bicycleKnown()) screen.Options.push(A.ledgerNav("那晚的旧车", "bicycle"));
        screen.Options.push(A.ledgerNav("返回黑旗名册", "home"));
    } else if (kind == "member_growth" && (parts.len() == 1 || !(parts[1] in A.Characters))) {
        local members = A.knownGrowth();
        local window = A.ledgerWindow(members.len(), parts.len() > 1 ? A.storyPageNumber(parts[1]) : 0);
        screen.Text = "营火旁的交谈\n\n已经提起的话题留在这里。";
        for (local i = 0; i < window.count; i++) {
            local key = members[window.offset + i];
            screen.Options.push(A.ledgerNav(A.Characters[key].name + " · " + A.storyGrowthLabel(key), "member_growth:" + key));
        }
        if (window.more) screen.Options.push(A.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", "member_growth:" + window.next));
        screen.Options.push(A.ledgerNav("返回旧事", "growth"));
    } else if (kind == "member_growth") {
        local key = parts.len() > 1 ? parts[1] : "";
        if (key in A.MemberGrowth && key in A.Characters && A.growthKnown(key)) {
            local data = A.MemberGrowth[key], status = A.growthStatus(key);
            screen.Text = A.Characters[key].name + " · " + data.title + "\n\n" + data.scene;
            foreach (index, choice in data.choices) {
                if (status == "ready") {
                    screen.Text += "\n\n" + choice.label + "\n特长：" + choice.traitName + "（" + A.personalBonusText(choice.bonuses) + "）。";
                    screen.Options.push(A.storyGrowthChoice(key, index));
                }
            }
            if (status == "done") {
                local index = A.get("growth_choice_" + key, -1);
                if (index >= 0 && index < 2) screen.Text += "\n\n已选：" + data.choices[index].label + "\n" + data.choices[index].outcome;
            }
        } else screen.Text = "这里还没有留下记录。";
        screen.Options.push(A.ledgerNav("返回交谈记录", "member_growth"));
    } else if (kind == "member_growth_chapter") {
        screen.Text = "记录已按相遇和经历整理。";
        screen.Options.push(A.ledgerNav("返回旧事", "growth"));
    } else if (kind == "roots" && (parts.len() < 2 || !(parts[1] in A.RootStories))) {
        local ids = A.knownRoots(), window = A.ledgerWindow(ids.len(), parts.len() > 1 ? A.storyPageNumber(parts[1]) : 0);
        screen.Text = "信件与留言\n\n点名字查看对方说过的话。标着‘待回应’的，还可以选择回应并领取补给。";
        for (local i = 0; i < window.count; i++) {
            local id = ids[window.offset + i];
            screen.Options.push(A.ledgerNav(A.RootStories[id].name + (A.rootStatus(id) == "done" ? " · 已回应" : " · 待回应"), "roots:" + id));
        }
        if (window.more) screen.Options.push(A.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", "roots:" + window.next));
        screen.Options.push(A.ledgerNav("返回旧事", "growth"));
    } else if (kind == "roots") {
        local id = parts[1], data = A.RootStories[id], state = A.rootStatus(id);
        screen.Text = data.name + " · " + data.title + "\n\n" + data.opening;
        if (state == "opened") {
            screen.Text += "\n\n" + data.followup + "\n\n选择一种回应，领取对应补给。每条记录只能选一次，也可以稍后再选。";
            foreach (index, choice in data.choices) {
                screen.Text += "\n\n" + choice.label + "\n获得：" + A.storyRewardText(choice.reward) + "。";
                screen.Options.push(A.storyRootChoice(id, index));
            }
        } else if (state == "done") {
            local index = A.get("root_choice_" + id, -1);
            if (index >= 0 && index < 2) screen.Text += "\n\n已选：" + data.choices[index].label + "\n" + data.choices[index].outcome + "\n已领取：" + A.storyRewardText(data.choices[index].reward) + "。";
        }
        screen.Options.push(A.ledgerNav("返回信件与留言", "roots:0"));
    } else if (kind == "bicycle_release_confirm") {
        local info = A.bicycleInventoryInfo();
        screen.Text = "确认放手\n\n小酒瓶将永久离开本起源名册，不再重新招募。她的成长与身份记录保留，现有 " + info.count + " 件装备将逐件原物放入公共行囊，至少需要相同数量的空位；目前空位 " + info.empty + " 个。满仓或转移失败时取消本次离队，不出售、不丢弃装备。\n\n确认后先读回忆，再决定保留旧车还是推下山坡；两条纪念方向都有不同的温和特长，毁车不是唯一正确答案。";
        screen.Options.push(A.ledgerAction("确认放手并回收全部装备", function() { return A.resolveBicycleDeparture(1, true); }, "bicycle"));
        screen.Options.push(A.ledgerNav("还没决定，返回夜话", "bicycle"));
    } else if (kind == "bicycle") {
        local status = A.bicycleStatus();
        screen.Text = "蛤妈与旧自行车\n\n小酒瓶曾帮阿飞拨回车链，也有自己的路想走。今晚她坐在车边，想和阿飞认真聊聊。";
        if (status == "ready") {
            screen.Text += "\n\n小酒瓶把手从车把上松开，说起一段想亲自去试的路。阿飞可以把挽留的理由讲明，也可以认真放手；两个人都不欠对方一个必须选的答案。";
            screen.Options.push(A.ledgerAction("说清条件，邀请她继续同行", function() { return A.resolveBicycleDeparture(0); }, "bicycle"));
            screen.Options.push(A.ledgerNav("考虑放手，先查看离队说明", "bicycle_release_confirm"));
        } else if (status == "kept") {
            screen.Text += "\n\n这次夜话选择了继续同行，当时未改变小酒瓶的装备、经验和成长；她后来的去留与生死仍以名册为准。车仍靠在营边，没有发放告别奖励。";
        } else if (status == "memory") {
            screen.Text += "\n\n她已按双方的决定离队，全部 " + A.get("bicycle_returned_items") + " 件装备归库。旧车还在，先回看两人走过的这一段，再决定怎样安放它。";
            screen.Options.push(A.ledgerAction("回看那些没接住又接住的日子", function() { return A.readBicycleMemory(); }, "bicycle"));
        } else if (status == "choice") {
            screen.Text += "\n\n球、车链、盾墙，以及学着自己走的那一句，都已记在这段回忆里。\n留下旧车：阿飞决心 +4、生命 +2。\n推下山坡：阿飞耐力 +5、先攻 +3。\n仅一次纪念特性，不叠加，也不改变后续经验倍率。";
            screen.Options.push(A.ledgerAction("留下旧车，记住共同走过的一程", function() { return A.resolveBicycleMemory(0); }, "bicycle"));
            screen.Options.push(A.ledgerAction("把车推下山坡，亲自走下一段", function() { return A.resolveBicycleMemory(1); }, "bicycle"));
        } else if (status == "done") {
            screen.Text += A.get("bicycle_choice", -1) == 0 ? "\n\n已留下旧车。回忆与这一份特长保留，不再重复结算。" : "\n\n旧车已经推下山坡。下一段路继续，这一份特长不会重复领取。";
        } else if (status == "unavailable") screen.Text += "\n\n阿飞或小酒瓶尚未入队、已离队或阵亡，这次夜话暂不能开始；不会重新生成任何人物。";
        screen.Options.push(A.ledgerNav("返回成长目录", "growth"));
    }
    if (screen.Options.len() > 6) throw "Story page exceeds six buttons: " + page;
    return screen;
};
