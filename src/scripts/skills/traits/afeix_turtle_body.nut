this.afeix_turtle_body <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_turtle_body";
        this.m.Name = "头盔戴不下，龟壳扛得住";
        this.m.Icon = "skills/afeix_member_turtle_shell.png";
        this.m.IconMini = this.m.Icon;
        this.m.IsSerialized = true;
        this.m.Description = "小龟的头太大，无法装备头盔。厚壳使近防与远防各 +5，受到的躯干直接武器伤害减少20%；缩头后转移到身体的伤害也按此计算。流血、毒等持续伤害不减免。\n铁匠：你这不是没穿甲，是出厂就焊上了。";
    },
    function enabled() { return ::AfeixExpedition.isTurtle(this.getContainer().getActor()); },
    function onUpdate(p) { if (this.enabled()) { p.MeleeDefense += 5; p.RangedDefense += 5; } },
    function onBeforeDamageReceived(attacker, skill, hit, p) {
        if (!this.enabled() || skill == null || !skill.isAttack() || !skill.m.IsWeaponSkill) return;
        if (hit.BodyPart == this.Const.BodyPart.Body) p.DamageReceivedTotalMult *= 0.8;
    }
});
