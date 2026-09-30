this.afeix_turtle_awakening <- this.inherit("scripts/skills/skill", {
    m = { NormalHitpointsMax = 1 },
    function create() {
        this.m.ID = "effects.afeix_turtle_awakening";
        this.m.Name = "玄武血脉";
        this.m.Description = "她壳上的旧纹接住了整片深水。本场生命上限 +400、疲劳上限 +120、决心 +100、近攻 +60、远攻 +40、双防 +100、近战伤害 ×1.5、疲劳恢复 +10，先攻最多 20；觉醒时回满生命、清空疲劳并变为自信。战后消失，生命降至不超过原上限；再次觉醒需完成 5 场未觉醒的参战胜利，待命和撤退不计。";
        this.m.Icon = "skills/afeix_member_turtle_shell.png";
        this.m.IconMini = this.m.Icon;
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsSerialized = true;
        this.m.IsRemovedAfterBattle = true;
    },
    function onUpdate(p) {
        p.Hitpoints += 400;
        p.Stamina += 120;
        p.Bravery += 100;
        p.MeleeSkill += 60;
        p.RangedSkill += 40;
        p.MeleeDefense += 100;
        p.RangedDefense += 100;
        p.MeleeDamageMult *= 1.5;
        p.FatigueRecoveryRate += 10;
    },
    function onAfterUpdate(p) {
        p.Initiative = this.Math.min(p.Initiative, 20);
        p.InitiativeMult = this.Math.minf(p.InitiativeMult, 1.0);
    },
    function onRemoved() {
        local actor = this.getContainer().getActor();
        if (actor != null && actor.isAlive() && !actor.isDying())
            actor.setHitpoints(this.Math.min(actor.getHitpoints(), this.m.NormalHitpointsMax));
    },
    function onSerialize(out) { this.skill.onSerialize(out); out.writeI32(this.m.NormalHitpointsMax); },
    function onDeserialize(input) { this.skill.onDeserialize(input); this.m.NormalHitpointsMax = input.readI32(); }
});
