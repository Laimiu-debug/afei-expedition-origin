this.afeix_douyu_core_effect <- this.inherit("scripts/skills/skill", {
    m = { Turn = 0, LastRound = -1, SpecialTurn = -1, NextRocket = 1, NextMark = 1, NextBarrage = 1,
        Charging = false, ChargeKind = "rocket", ChargeTurn = 0, BlastTiles = [], InterruptDamage = 0,
        MarkID = 0, MarkTurn = 0, Phase2 = false, ComboPending = false, ExposedUntil = 0, SpecialRecoveryUntil = 0 },
    function create() {
        this.m.ID = "effects.afeix_douyu_core";
        this.m.Name = "深渊之主";
        this.m.Icon = "skills/afeix_douyu_rocket.png";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false; this.m.IsStacking = false;
        this.m.IsSerialized = false; this.m.IsRemovedAfterBattle = true;
        this.m.BlastTiles = [];
    },
    function getDescription() {
        local text = "斗鱼不召唤随从，也不恢复生命。点名、弹幕与超级火箭均提前一回合预告。生命降至一半后，攻击伤害提高20%。免疫眩晕、定身、缴械、恐惧与强制位移；流血、毒和削弱仍然有效。";
        if(this.m.Charging) text += "\n" + (this.m.ChargeKind == "rocket" ? "超级火箭" : "弹幕洪流") + "正在蓄力！累计造成 " + ::AfeixExpedition.Douyu.InterruptThreshold + " 点实际生命与护甲伤害可以打断。目前：" + this.m.InterruptDamage + "/" + ::AfeixExpedition.Douyu.InterruptThreshold + "。";
        if(this.m.Turn < this.m.ExposedUntil) text += "\n破绽：受到的伤害提高 35%，直到斗鱼下次回合。";
        if(this.m.Turn < this.m.SpecialRecoveryUntil) text += "\n蓄力被打断后，下一回合改用撕咬，随后才重新使用礼炮。";
        return text;
    },
    function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; },
    function onTurnStart() { ::AfeixExpedition.Douyu.startTurn(this.getContainer().getActor()); },
    function onUpdate(_properties) {
        _properties.IsImmuneToStun = true; _properties.IsImmuneToRoot = true;
        _properties.IsImmuneToDisarm = true; _properties.IsImmuneToRotation = true;
        _properties.IsImmuneToKnockBackAndGrab = true;
        // Existing origin mental-target checks read this compatibility slot;
        // vanilla CharacterProperties does not declare it. Match Ignore morale.
        _properties.IsImmuneToFearAndPanic <- true;
        _properties.IsAffectedByLosingHitpoints = false;
        _properties.IsAffectedByDyingAllies = false; _properties.IsAffectedByFreshInjuries = false;
        if(this.m.Turn < this.m.ExposedUntil) _properties.DamageReceivedTotalMult *= 1.35;
        if(this.m.Phase2) _properties.DamageTotalMult *= ::AfeixExpedition.Douyu.Phase2DamageMult;
    },
    function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
        ::AfeixExpedition.Douyu.interrupt(this.getContainer().getActor(), _attacker, _damageHitpoints, _damageArmor);
    },
    function onDeath(_fatalityType) {
        local actor = this.getContainer().getActor();
        this.m.Charging = false;
        ::AfeixExpedition.Douyu.clearWarning(actor); ::AfeixExpedition.Douyu.removeMark(actor);
    }
});
