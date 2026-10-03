this.afeix_douyu_barrage_skill <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "actives.afeix_douyu_barrage"; this.m.Name = "弹幕洪流";
        this.m.Description = "提前一回合预告七格弹幕区域，最多攻击三名敌人。离开红圈或散开能降低波及人数，也可用 160 点实际生命与护甲伤害打断。压力不叠加，不眩晕或夺走行动点。";
        this.m.KilledString = "被弹幕击倒";
        this.m.Icon = "skills/afeix_douyu_barrage.png"; this.m.IconDisabled = this.m.Icon;
        this.m.Overlay = "active_71";
        this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
        this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true;
        this.m.IsAttack = true; this.m.IsRanged = true; this.m.IsAOE = true; this.m.IsIgnoredAsAOO = true;
        this.m.IsVisibleTileNeeded = false; this.m.IsDoingForwardMove = false;
        this.m.ActionPointCost = 6; this.m.FatigueCost = 20; this.m.MinRange = 1; this.m.MaxRange = 6;
        this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 2; this.m.DirectDamageMult = 0.1;
    },
    function isUsable() { return this.skill.isUsable() && ::AfeixExpedition.Douyu.canSpecial(this.getContainer().getActor(), "barrage"); },
    function onAnySkillUsed(_skill, _targetEntity, _properties) {
        if(_skill != this) return;
        _properties.DamageRegularMin = 35; _properties.DamageRegularMax = 50; _properties.DamageArmorMult = 0.7;
    },
    function onUse(_user, _targetTile) {
        local d = ::AfeixExpedition.Douyu, s = d.state(_user);
        s.SpecialTurn = s.Turn; s.NextBarrage = s.Turn + 3;
        d.beginArea(_user, _targetTile, "barrage");
        _user.setActionPoints(0);
        d.log("斗鱼吸入黑水，七格红圈显现！下次斗鱼回合弹幕最多波及三人。离开红圈、提前散开，或造成 160 点实际生命与护甲伤害打断。");
        return true;
    }
});
