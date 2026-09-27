local A = ::AfeixExpedition;

A.recruitPrice <- function(key) {
    if (!(key in this.Characters)) return 0;
    local price = this.Characters[key].hireCost - this.get("hire_discount_" + key);
    return price > 0 ? price : 0;
};

A.recruitHint <- function(key) {
    if (!(key in this.Characters)) return "没有这位人物的邀请记录。";
    local data = this.Characters[key];
    if (data.isCaptain) return "这位人物是初始队长，不通过邀请重新生成。";
    local status = this.characterStatus(key);
    if (status == "recruited") return "已经入队；可在编队页安排出战或待命。";
    if (status == "dead") return "已经阵亡，邀请无法重新领取。";
    if (status == "departed") return "已经永久离队，不再生成同一位伙伴。";
    if (!this.isCharacterKnown(key)) return "这里还没有留下记录。";
    if (this.get("recruit_offer_key", "") == key) return "可在城镇的招募界面与这位伙伴谈同行。费用以招募界面为准。";
    return "还记得这位伙伴。继续旅行，日后可以在城镇招募界面再见。";
};

A.resolveEncounter <- function(key, choiceIndex) {
    if (!this.isOrigin() || !(key in this.Characters) || this.Characters[key].isCaptain)
        return this.result(false, "没有可办理的相遇。");
    if (!this.isAtTavern())
        return this.result(false, "请进入友好城镇的酒馆，与对方当面交谈。");
    if (this.characterStatus(key) != "encounter")
        return this.result(false, "这次相遇尚未开放，或已经处理过；没有重复扣款。");
    local data = this.Characters[key];
    if (typeof choiceIndex != "integer" || choiceIndex < 0 || choiceIndex >= data.encounterChoices.len())
        return this.result(false, "请选择有效的处理方式。");
    local choice = data.encounterChoices[choiceIndex];
    if (::World.Assets.getMoney() < choice.cost)
        return this.result(false, "这项选择需要 " + choice.cost + " 克朗，资金不足，没有扣款。可以稍后回来，或选择另一种处理方式。");
    // The result is durable and one-shot; hiring remains a separate transaction.
    if (choice.cost > 0) ::World.Assets.addMoney(-choice.cost);
    this.set("encounter_choice_" + key, choiceIndex);
    this.set("hire_discount_" + key, choice.hireDiscount);
    this.set("encounter_done_" + key, true);
    this.refreshAssets();
    return this.result(true, choice.outcome + "\n\n" + data.name + "的邀请已保留。本次支付 " + choice.cost + " 克朗；正式招募费为 " + this.recruitPrice(key) + " 克朗。未正式邀请前不会占用名册或领取工资。");
};
