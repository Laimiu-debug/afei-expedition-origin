this.afeix_ecig_puff <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "actives.afeix_ecig_puff";
        this.m.Name = "抽一口";
        this.m.Description = "阿飞抽一口，恢复最多 15 点生命。每战两次，冷却2轮，不消耗电子烟；满生命时不能使用。";
        this.m.Icon = "skills/afeix_ecig_puff.png"; this.m.IconMini = this.m.Icon;
        this.m.IconDisabled = "skills/afeix_ecig_puff_sw.png";
        this.m.Overlay = "active_41";
        this.m.SoundOnUse = ["sounds/combat/drink_01.wav", "sounds/combat/drink_02.wav", "sounds/combat/drink_03.wav"];
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.Any;
        this.m.IsSerialized = false; // equipment restores the skill; the actor owns cooldown
        this.m.IsActive = true;
        this.m.IsTargeted = false;
        this.m.IsStacking = false;
        this.m.IsAttack = false;
        this.m.IsVisibleTileNeeded = false;
        this.m.ActionPointCost = 4;
        this.m.FatigueCost = 10;
        this.m.MinRange = 0;
        this.m.MaxRange = 0;
    },
    function getTooltip() {
        local result = this.getDefaultUtilityTooltip();
        result.push({ id = 10, type = "text", icon = "ui/icons/health.png", text = "恢复最多 15 生命，不修复护甲或治愈伤势。" });
        result.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "仅阿飞可用；每战两次，冷却2轮，不消耗物品。" });
        return result;
    },
    function canPuff(actor) {
        if (!::AfeixExpedition.isOrigin() || !this.Tactical.isActive() || actor == null
            || ::AfeixExpedition.characterId(actor) != "afei" || !actor.isAlive()
            || actor.getHitpoints() >= actor.getHitpointsMax()) return false;
        local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
        local flags = actor.getFlags();
        return item != null && item.getID() == "accessory.afeix_ecig"
            && ::AfeixExpedition.catalogGet(actor,"ecig_uses")<2
            && ::AfeixExpedition.catalogGet(actor,"ecig_ready")<=this.Time.getRound();
    },
    function isUsable() { return this.skill.isUsable() && this.canPuff(this.getContainer().getActor()); },
    function onVerifyTarget(originTile, targetTile) { return true; },
    function onUse(user, targetTile) {
        // Native skill.use already pays AP/fatigue; validate identity/cooldown only.
        if (user != this.getContainer().getActor() || !this.canPuff(user)) return false;
        local before = user.getHitpoints(), after = this.Math.min(user.getHitpointsMax(), before + 15);
        ::AfeixExpedition.catalogSet(user,"ecig_uses",::AfeixExpedition.catalogGet(user,"ecig_uses")+1);
        ::AfeixExpedition.catalogSet(user,"ecig_ready",this.Time.getRound()+2);
        user.setHitpoints(after);
        user.setDirty(true);
        this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " 抽了一口，恢复 " + (after - before) + " 点生命");
        return true;
    }
});
