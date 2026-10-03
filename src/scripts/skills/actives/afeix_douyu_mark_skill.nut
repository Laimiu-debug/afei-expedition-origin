this.afeix_douyu_mark_skill <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "actives.afeix_douyu_mark"; this.m.Name = "开播点名";
        this.m.Description = "点名三格内一名敌人，下一次斗鱼回合才扑咬。标记跟随敌人；走位或换位须将其带到四格外才能避开。单纯交换位置不会免除扑咬。";
        this.m.KilledString = "被斗鱼扑咬";
        this.m.Icon = "skills/afeix_douyu_mark.png"; this.m.IconDisabled = this.m.Icon;
        this.m.Overlay = "status_effect_34";
        this.m.SoundOnUse = ["sounds/combat/taunt_01.wav"];
        this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
        this.m.IsSerialized = false; this.m.IsActive = true; this.m.IsTargeted = true;
        this.m.IsAttack = true; this.m.IsIgnoredAsAOO = true; this.m.IsVisibleTileNeeded = false;
        this.m.ActionPointCost = 6; this.m.FatigueCost = 15; this.m.MinRange = 1; this.m.MaxRange = 3;
        this.m.MaxLevelDifference = 2; this.m.DirectDamageMult = ::AfeixExpedition.Douyu.Attacks.mark.Direct;
        this.m.InjuriesOnBody = this.Const.Injury.CuttingAndPiercingBody;
        this.m.InjuriesOnHead = this.Const.Injury.CuttingAndPiercingHead;
    },
    function isUsable() { return this.skill.isUsable() && ::AfeixExpedition.Douyu.canSpecial(this.getContainer().getActor(), "mark"); },
    function onAnySkillUsed(_skill, _targetEntity, _properties) {
        if(_skill != this) return;
        local tuning = ::AfeixExpedition.Douyu.Attacks.mark;
        _properties.DamageRegularMin = tuning.Min; _properties.DamageRegularMax = tuning.Max; _properties.DamageArmorMult = tuning.Armor;
    },
    function onUse(_user, _targetTile) {
        local d = ::AfeixExpedition.Douyu, s = d.state(_user);
        s.SpecialTurn = s.Turn; s.NextMark = s.Turn + 3;
        d.beginMark(_user, _targetTile.getEntity());
        _user.setActionPoints(0);
        return true;
    }
});
