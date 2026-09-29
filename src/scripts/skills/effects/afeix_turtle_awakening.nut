this.afeix_turtle_awakening <- this.inherit("scripts/skills/skill", {
    m = { NormalHitpointsMax = 1 },
    function create() {
        this.m.ID = "effects.afeix_turtle_awakening";
        this.m.Name = "壳后的那一步";
        this.m.Description = "沉下去的脚步没有变快，壳上的纹路却仿佛接住了整片深水。小龟没有回头，只把身后的路留得很稳。";
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
