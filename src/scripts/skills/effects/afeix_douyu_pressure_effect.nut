this.afeix_douyu_pressure_effect <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "effects.afeix_douyu_pressure"; this.m.Name = "弹幕压力";
        this.m.Description = "嘈杂的呼声分散了注意：近战与远程命中率降低 10%，直到这名队员回合结束。不叠加，不封锁行动。";
        this.m.Icon = "skills/afeix_douyu_barrage.png";
        this.m.IconMini = "status_effect_74_mini"; this.m.Overlay = "status_effect_74";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false; this.m.IsStacking = false;
        this.m.IsSerialized = false; this.m.IsRemovedAfterBattle = true;
    },
    function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; },
    function onUpdate(_properties) { _properties.MeleeSkillMult *= 0.9; _properties.RangedSkillMult *= 0.9; },
    function onTurnEnd() { this.removeSelf(); },
    function onNewRound() { this.removeSelf(); }
});
