local A = ::AfeixExpedition;
A.promotionLedgerPage <- function(event, page) {
    local parts = split(page, ":");
    if (parts[0] != "promotion") return null;
    local screen = { ID = page, Text = "", Image = "", List = [], Characters = [], Options = [], function start(event) {} };
    local target = parts.len() > 1 ? parts[1] : "";
    if ((!A.promotionKnown() && !A.feidieKnown()) || (target == "feidie" && !A.feidieKnown())
        || ((target == "toad" || target == "jiahao") && !A.promotionKnown())) {
        screen.Text = "这里还没有留下记录。";
        screen.Options.push(A.ledgerNav("返回旧事", "growth"));
        return screen;
    }

    local descriptions = {};
    foreach(key,d in A.BalanceV26.routes)descriptions[key]<-d.name+"\n"+d.passive+"\n主动："+d.ap+"行动点、"+d.fatigue+"疲劳，冷却"+d.cd+"轮。"+d.effect+"\n"+d.economy;
    if (target in descriptions) {
        local check = A.promotionCheck(target), cost = A.promotionCost(target);
        screen.Text = descriptions[target] + "\n\n当前路线：" + A.routeName(A.route()) + "。\n" + check.text;
        screen.Text += "\n\n转职不改变天赋星数、不重掷升级属性。首次普通路线需要7级、亲自参战6次及个人成长选择；重修需要9级、12份履约、1500克朗，间隔7日。\n确认会替换原路线的专属能力，保留等级、装备、已选专长、伤势及已经留下的经历。请在安全的友好城镇附近办理。";
        screen.Text += "\n阿飞始终保留同一种立绘，转职只改变路线能力。";
        if (target == "feidie") screen.Text += "\n飞碟还需9级、亲自参战12次、完成个人成长和六根开篇。首次进入飞碟免费，不受付费重修的履约与7日间隔限制；之后再次进入按重修办理。";
        if (check.ok) {
            local chosen = target;
            screen.Options.push(A.ledgerAction(cost == 0 ? "确认免费转职" : "支付 1500 克朗，确认重修", function() { return A.promote(chosen); }, "promotion"));
        }
        screen.Options.push(A.ledgerNav("返回转职路线", "promotion"));
    } else {
        local bro = A.findCharacter("afei");
        screen.Text = "阿飞的路\n\n当前路线：" + A.routeName(A.route()) + "。";
        if (bro != null) screen.Text += "\n等级 " + bro.getLevel() + "；亲自参战 " + A.promotionBattles(bro) + " 场；个人成长" + (A.get("growth_done_afei", false) ? "已作选择。" : "尚未作选择。") ;
        screen.Text += "\n\n一路走来，阿飞终于能认真选择自己要走的路。首次选择免费。";
        if ("circleSummary" in A) screen.Text += "\n\n" + A.circleSummary();
        if (A.promotionKnown()) {
            screen.Options.push(A.ledgerNav("查看蛤蟆人路线", "promotion:toad"));
            screen.Options.push(A.ledgerNav("查看嘉豪路线", "promotion:jiahao"));
        }
        if (A.feidieKnown()) screen.Options.push(A.ledgerNav("查看飞碟路线", "promotion:feidie"));
    }
    screen.Options.push(A.ledgerNav("返回成长记录", "growth"));
    return screen;
};
