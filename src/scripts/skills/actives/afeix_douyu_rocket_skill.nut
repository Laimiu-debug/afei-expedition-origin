this.afeix_douyu_rocket_skill <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "actives.afeix_douyu_rocket"; this.m.Name = "超级火箭";
        this.m.Description = "预告七格轰炸区域，下一次斗鱼回合，一枚火箭从高处落向红圈中心，落地时引爆。离开红圈或累计造成 " + ::AfeixExpedition.Douyu.InterruptThreshold + " 点实际生命与护甲伤害可以化解。落地或被打断后，斗鱼露出一回合的破绽。";
        this.m.KilledString = "被超级火箭炸倒";
        this.m.Icon = "skills/afeix_douyu_rocket.png"; this.m.IconDisabled = this.m.Icon;
        this.m.ImpactSprite = "mortar_target_02";
        this.m.Overlay = "active_71";
        this.m.SoundOnUse = ["sounds/combat/dlc6/fire_mortar_01.wav"];
        this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
        this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true;
        this.m.IsTargetingActor = false; this.m.IsAttack = true; this.m.IsRanged = true; this.m.IsAOE = true;
        this.m.IsUsingHitchance = false; this.m.IsIgnoredAsAOO = true;
        this.m.IsVisibleTileNeeded = false; this.m.IsDoingForwardMove = false;
        this.m.ActionPointCost = 9; this.m.FatigueCost = 25; this.m.MinRange = 1; this.m.MaxRange = 8;
        this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 2; this.m.DirectDamageMult = ::AfeixExpedition.Douyu.Attacks.rocket.Direct;
    },
    function isUsable() { return this.skill.isUsable() && ::AfeixExpedition.Douyu.canSpecial(this.getContainer().getActor(), "rocket"); },
    function addResources() {
        this.skill.addResources();
        this.Tactical.addResource("sounds/combat/dlc6/fire_mortar_impact_01.wav");
        this.Tactical.addResource("gfx/afeix_douyu_rocket_v01.png");
    },
    function onAnySkillUsed(_skill, _targetEntity, _properties) {
        if(_skill != this) return;
        local tuning = ::AfeixExpedition.Douyu.Attacks.rocket;
        _properties.DamageRegularMin = tuning.Min; _properties.DamageRegularMax = tuning.Max; _properties.DamageArmorMult = tuning.Armor;
    },
    function onUse(_user, _targetTile) {
        local d = ::AfeixExpedition.Douyu, s = d.state(_user);
        s.SpecialTurn = s.Turn; s.NextRocket = s.Turn + 4;
        d.beginArea(_user, _targetTile, "rocket");
        ::AfeixExpedition.feedbackParticles(_user.getTile(), "MortarFireLeftParticles", 0.35);
        if(s.ComboPending && _targetTile.IsOccupiedByActor && !_user.isAlliedWith(_targetTile.getEntity())) {
            s.ComboPending = false; d.beginMark(_user, _targetTile.getEntity());
            d.log("满屏开播：火箭与点名同时预告。每名队员最多承受其中一次重击；离开红圈并远离斗鱼可全部化解。");
        }
        else d.log("斗鱼高举橙红礼炮！下次斗鱼回合轰炸红圈七格。走开，或在它再次行动前造成 " + ::AfeixExpedition.Douyu.InterruptThreshold + " 点实际生命与护甲伤害打断。");
        return true;
    }
});
