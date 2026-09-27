this.afeix_promotion_effect <- this.inherit("scripts/skills/skill", {
    m = { TurnsLeft = 2, Melee = 0, Ranged = 0, BraveryBonus = 0, Incoming = 1.0 },
    function create() {
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsSerialized = true;
        this.m.IsRemovedAfterBattle = true;
    },
    function onUpdate(properties) {
        properties.MeleeSkill += this.m.Melee;
        properties.RangedSkill += this.m.Ranged;
        properties.Bravery += this.m.BraveryBonus;
        properties.DamageReceivedTotalMult *= this.m.Incoming;
    },
    function onTurnStart() {
        if (--this.m.TurnsLeft <= 0) this.removeSelf();
    },
    function onSerialize(out) {
        this.skill.onSerialize(out);
        out.writeU8(this.m.TurnsLeft);
    },
    function onDeserialize(input) {
        this.skill.onDeserialize(input);
        this.m.TurnsLeft = input.readU8();
    }
});
