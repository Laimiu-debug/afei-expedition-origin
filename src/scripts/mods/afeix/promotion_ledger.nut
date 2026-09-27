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

    local descriptions = {
        toad = "蛤蟆人 · 自己能打\n近战命中 +8，近战和远程防御 +5，伤害提高 10%。\n哇哇叫：3 行动点、15 疲劳，每战一次。仅阿飞获得近战命中 +12、所受伤害减少 20%，持续至自己的第二次回合开始。",
        jiahao = "嘉豪 · 带人\n决心 +10。豪气冲天：4 行动点、20 疲劳、80 克朗，每战一次。3 格内本方可操控角色（含阿飞）获得近战和远程命中 +10、决心 +10，持续至各自第二次回合开始。\n全力圈：成功完成有战斗胜利记录的付费契约，按实收款取得 15% 额外报酬，每份契约最多 300 克朗。阿飞需活着在队，送信与出售不计入。",
        feidie = "飞碟 · 自己能打，也能带人\n近战命中 +5，近战和远程防御 +3，决心 +5。飞爹在此：4 行动点、20 疲劳、60 克朗，每战一次。2 格内本方可操控角色（含阿飞）获得近战和远程命中 +8、决心 +8；阿飞另获所受伤害减少 10%，持续至各自第二次回合开始。\n全力圈按实收战斗契约款的 10% 计算，每份最多 300 克朗，其他条件与嘉豪相同。"
    };
    if (target in descriptions) {
        local check = A.promotionCheck(target), cost = A.promotionCost(target);
        screen.Text = descriptions[target] + "\n\n当前路线：" + A.routeName(A.route()) + "。\n" + check.text;
        screen.Text += "\n\n转职天赋：近战命中、近战防御、决心各三星，共九星。三条路线共用，重修不叠加；作用于尚未使用的普通升级机会，已经加过的属性不重算。\n确认会替换原路线的专属能力，保留等级、装备、已选专长、伤势及已经留下的经历。请在安全的友好城镇附近办理。";
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
