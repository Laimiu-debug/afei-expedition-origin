this.afeix_douyu_bite_skill <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "actives.afeix_douyu_bite"; this.m.Name = "深渊撕咬";
        this.m.Description = "尖牙撕咬相邻目标，盾牌与近战防御可正常招架。";
        this.m.KilledString = "被斗鱼撕碎";
        this.m.Icon = "skills/afeix_douyu_mark.png"; this.m.IconDisabled = this.m.Icon;
        this.m.Overlay = "active_71";
        this.m.SoundOnUse = ["sounds/enemies/wolf_bite_01.wav"];
        this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
        this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsAttack = true;
        this.m.ActionPointCost = 4; this.m.FatigueCost = 12; this.m.MinRange = 1; this.m.MaxRange = 1;
        this.m.DirectDamageMult = ::AfeixExpedition.Douyu.Attacks.bite.Direct;
        this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
        this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
    },
    function onAnySkillUsed(_skill, _targetEntity, _properties) {
        if(_skill != this) return;
        local tuning = ::AfeixExpedition.Douyu.Attacks.bite;
        _properties.DamageRegularMin = tuning.Min; _properties.DamageRegularMax = tuning.Max; _properties.DamageArmorMult = tuning.Armor;
    },
    function onUse(_user, _targetTile) { return this.attackEntity(_user, _targetTile.getEntity()); }
});
