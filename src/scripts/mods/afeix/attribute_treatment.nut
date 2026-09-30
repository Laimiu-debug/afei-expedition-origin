local A = ::AfeixExpedition;
A.TreatmentCost <- 100;
// Native CharacterProperties persists these fields as signed 16-bit integers.
A.TreatmentMax <- 32767;
A.TreatmentAttributes <- [
    { field = "Hitpoints", name = "生命" },
    { field = "Stamina", name = "疲劳上限" },
    { field = "Bravery", name = "决心" },
    { field = "Initiative", name = "先攻" },
    { field = "MeleeSkill", name = "近战命中" },
    { field = "RangedSkill", name = "远程命中" },
    { field = "MeleeDefense", name = "近战防御" },
    { field = "RangedDefense", name = "远程防御" }
];
A.treatmentAttribute <- function(field) {
    foreach (attribute in this.TreatmentAttributes) if (attribute.field == field) return attribute;
    return null;
};
A.treatmentActor <- function(id) {
    // Actor IDs also cover ordinary recruits and optional DLC members.
    foreach (bro in this.roster())
        if (bro.getID() == id && bro.isAlive() && !bro.isDying()) return bro;
    return null;
};
A.treatmentCheck <- function(actorId, field) {
    if (!this.isOrigin() || !this.canManage())
        return this.result(false, "请到友好城镇附近或安全营地参加飞李不可。");
    local bro = this.treatmentActor(actorId), attribute = this.treatmentAttribute(field);
    if (bro == null) return this.result(false, "这位角色已不在队中，请重新选择。");
    if (attribute == null) return this.result(false, "请选择一项基础属性。");
    if (bro.getBaseProperties()[field] >= this.TreatmentMax)
        return this.result(false, "这项基础属性已达到可保存的上限。");
    if (::World.Assets.getMoney() < this.TreatmentCost)
        return this.result(false, "克朗不足，本次需要 " + this.TreatmentCost + " 克朗。");
    return this.result(true, "本次只增加 1 点基础" + attribute.name + "。");
};
A.treatAttribute <- function(actorId, field, expectedBase, expectedCost) {
    local check = this.treatmentCheck(actorId, field);
    if (!check.ok) return check;
    local bro = this.treatmentActor(actorId), properties = bro.getBaseProperties();
    local previous = properties[field], money = ::World.Assets.getMoney();
    if (previous != expectedBase || this.TreatmentCost != expectedCost)
        return this.result(false, "属性或费用已经变化，请重新选择并确认。");
    local hitpoints = bro.getHitpoints(), hitpointsMax = bro.getHitpointsMax();
    try {
        properties[field] = previous + 1;
        bro.getSkills().update();
        // Keep the missing HP amount, including Colossus/injury multipliers.
        // Paying for maximum HP does not heal existing wounds for free.
        if (field == "Hitpoints")
            bro.setHitpoints(::Math.min(bro.getHitpointsMax(), hitpoints + bro.getHitpointsMax() - hitpointsMax));
        bro.setDirty(true);
        ::World.Assets.addMoney(-expectedCost);
        if (::World.Assets.getMoney() != money - expectedCost) throw "unexpected treatment payment";
    } catch (error) {
        properties[field] = previous;
        ::World.Assets.setMoney(money);
        try { bro.getSkills().update(); } catch (updateError) {}
        bro.setHitpoints(hitpoints);
        bro.setDirty(true);
        if ("logError" in getroottable()) ::logError("[AfeixExpedition] Treatment rolled back: " + error);
        return this.result(false, "本次调整未能完成，属性与克朗均已保留。");
    }
    // UI refresh is after the transaction; a display error cannot refund a
    // completed improvement or make another confirmation spend this offer.
    try { this.refreshAssets(); } catch (error) {
        if ("logError" in getroottable()) ::logError("[AfeixExpedition] Treatment display refresh: " + error);
    }
    return this.result(true, bro.getNameOnly() + "的基础"
        + this.treatmentAttribute(field).name + " " + previous + " → " + properties[field]
        + "。本次花费 " + expectedCost + " 克朗。");
};
A.treatmentConfirmOption <- function(offer) {
    return this.ledgerOption("支付 " + offer.cost + " 克朗，属性 +1", function(event) {
        if (event.m.TreatmentOffer != offer) {
            event.m.Notice = "本次选择已结束，请重新选择属性。";
            return "treatment_actor:" + offer.actorId;
        }
        // One confirmation is one opportunity, including failed payments.
        event.m.TreatmentOffer = null;
        local result = ::AfeixExpedition.treatAttribute(offer.actorId, offer.field, offer.value, offer.cost);
        event.m.Notice = result.text;
        return "treatment_actor:" + offer.actorId;
    });
};
A.treatmentNumber <- function(text) {
    // Ledger IDs are internal, but stale/malformed links should stay readable.
    if (text == "") return -1;
    foreach (c in text) if (c < 48 || c > 57) return -1;
    try { return text.tointeger(); } catch (error) { return -1; }
};
A.treatmentLedgerPage <- function(event, page) {
    local parts = split(page, ":"), kind = parts[0];
    if (["treatment", "treatment_actor", "treatment_preview"].find(kind) == null) return null;
    local screen = { ID = page, Text = "", Image = "", List = [], Characters = [], Options = [], function start(event) {} };
    if (kind == "treatment") {
        local members = [];
        foreach (bro in this.roster()) if (bro.isAlive() && !bro.isDying()) members.push(bro);
        local offset = parts.len() > 1 ? this.treatmentNumber(parts[1]) : 0;
        local window = this.ledgerWindow(members.len(), offset);
        screen.Text = "飞李不可\n\n黑旗下多了一张桌子，旁边挂着价目牌：‘一次一点，明码标价。’"
            + "\n\n每次 " + this.TreatmentCost + " 克朗，为一名在队角色的一项基础属性永久增加 1 点。可以再次付费参加。"
            + "装备、特质与专长照常计算。\n\n选择参加的角色：";
        if (!this.isOrigin() || !this.canManage()) screen.Text += "\n请先到友好城镇附近或安全营地，再调整属性。";
        if (members.len() == 0) screen.Text += "\n目前没有可参加的角色。";
        for (local i = 0; i < window.count; i++) {
            local bro = members[window.offset + i];
            screen.Options.push(this.ledgerNav(bro.getNameOnly() + " · " + bro.getLevel() + " 级", "treatment_actor:" + bro.getID()));
        }
        if (window.more) screen.Options.push(this.ledgerNav(window.next == 0 ? "回到第一页" : "下一页角色", "treatment:" + window.next));
        screen.Options.push(this.ledgerNav("返回战团事务", "company"));
        return screen;
    }
    local actorId = parts.len() > 1 ? this.treatmentNumber(parts[1]) : -1;
    local bro = this.treatmentActor(actorId);
    if (bro == null) {
        screen.Text = "这位角色已不在队中，请重新选择。";
        screen.Options.push(this.ledgerNav("重新选择角色", "treatment"));
        return screen;
    }
    if (kind == "treatment_preview") {
        local field = parts.len() > 2 ? parts[2] : "", attribute = this.treatmentAttribute(field);
        if (attribute == null) {
            screen.Text = "没有找到这项基础属性，请重新选择。";
        } else {
            local value = bro.getBaseProperties()[field], check = this.treatmentCheck(actorId, field);
            screen.Text = bro.getNameOnly() + " · 飞李不可\n\n基础" + attribute.name
                + " " + value + " → " + (value + 1) + "。\n费用：" + this.TreatmentCost
                + " 克朗。\n现有：" + ::World.Assets.getMoney() + " 克朗。\n\n本次只增加所选属性的 1 点。继续调整需再次付费。";
            if (check.ok) {
                local offer = { actorId = actorId, field = field, value = value, cost = this.TreatmentCost };
                event.m.TreatmentOffer = offer;
                screen.Options.push(this.treatmentConfirmOption(offer));
            } else screen.Text += "\n\n" + check.text;
        }
        screen.Options.push(this.ledgerNav("再考虑一下", "treatment_actor:" + actorId));
        return screen;
    }
    local offset = parts.len() > 2 ? this.treatmentNumber(parts[2]) : 0;
    local window = this.ledgerWindow(this.TreatmentAttributes.len(), offset);
    screen.Text = bro.getNameOnly() + " · 飞李不可\n\n每次 " + this.TreatmentCost
        + " 克朗，只增加一项基础属性 1 点。\n\n当前基础属性（装备、特质与专长加成另计）：";
    foreach (attribute in this.TreatmentAttributes)
        screen.Text += "\n" + attribute.name + "：" + bro.getBaseProperties()[attribute.field];
    for (local i = 0; i < window.count; i++) {
        local attribute = this.TreatmentAttributes[window.offset + i];
        screen.Options.push(this.ledgerNav(attribute.name + " +1", "treatment_preview:" + actorId + ":" + attribute.field));
    }
    if (window.more) screen.Options.push(this.ledgerNav(window.next == 0 ? "前四项属性" : "后四项属性", "treatment_actor:" + actorId + ":" + window.next));
    screen.Options.push(this.ledgerNav("重新选择角色", "treatment"));
    return screen;
};
