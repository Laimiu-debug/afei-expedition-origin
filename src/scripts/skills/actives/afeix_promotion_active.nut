this.afeix_promotion_active <- this.inherit("scripts/skills/skill", {
    m = { Route = "", GoldCost = 0, Radius = 0, Used = false },
    function create() {
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.Any;
        this.m.IsSerialized = true;
        this.m.IsActive = true;
        this.m.IsTargeted = false;
        this.m.IsStacking = false;
        this.m.IsAttack = false;
        this.m.IsVisibleTileNeeded = false;
        this.m.ActionPointCost = 4;
        this.m.FatigueCost = 20;
        this.m.MinRange = 0;
        this.m.MaxRange = 0;
    },
    function getTooltip() {
        local result = this.getDefaultUtilityTooltip();
        result.push({ id = 10, type = "text", icon = "ui/icons/special.png", text = this.m.Used ? "本场战斗已经使用。" : "每场战斗限用一次。" });
        if (this.m.GoldCost > 0) result.push({ id = 11, type = "text", icon = "ui/icons/money.png", text = "当场支付 " + this.m.GoldCost + " 克朗；资金不足时不能使用。" });
        return result;
    },
    function isUsable() {
        return this.skill.isUsable() && !this.m.Used
            && ::AfeixExpedition.promotionUser(this.getContainer().getActor(), this.m.Route)
            && ::World.Assets.getMoney() >= this.m.GoldCost;
    },
    function onVerifyTarget(originTile, targetTile) { return true; },
    function onUse(user, targetTile) {
        // Vanilla already spent AP/fatigue before onUse. Do not re-check affordability here.
        if (user != this.getContainer().getActor() || !this.isUsable()) return false;
        local A = ::AfeixExpedition;
        if (this.m.GoldCost > 0) ::World.Assets.addMoney(-this.m.GoldCost);
        this.m.Used = true;
        if (this.m.Route == "toad") {
            A.promotionEffect(user, "scripts/skills/effects/afeix_wawa_effect", "effects.afeix_wawa");
        } else {
            local path = this.m.Route == "jiahao" ? "scripts/skills/effects/afeix_haoqi_effect" : "scripts/skills/effects/afeix_feidie_effect";
            local id = this.m.Route == "jiahao" ? "effects.afeix_haoqi" : "effects.afeix_feidie";
            foreach (actor in A.promotionTargets(user, this.m.Radius)) A.promotionEffect(actor, path, id);
            if (this.m.Route == "feidie") A.promotionEffect(user, "scripts/skills/effects/afeix_feidie_guard_effect", "effects.afeix_feidie_guard");
        }
        return true;
    },
    function onCombatStarted() { this.m.Used = false; },
    function onCombatFinished() { this.m.Used = false; },
    function onSerialize(out) {
        this.skill.onSerialize(out);
        out.writeBool(this.m.Used);
    },
    function onDeserialize(input) {
        this.skill.onDeserialize(input);
        this.m.Used = input.readBool();
    }
});
