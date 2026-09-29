this.afeix_turtle_body <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_turtle_body";
        this.m.Name = "头盔戴不下，龟壳扛得住";
        this.m.Icon = "skills/afeix_member_turtle_shell.png";
        this.m.IconMini = this.m.Icon;
        this.m.IsSerialized = true;
        this.m.Description = "小龟的头太大，无法装备头盔；入队自带钢头，不消耗技能点。厚壳使近防与远防各 +5，受到的直接武器伤害：头部减少 50%，躯干减少 20%。流血、毒等持续伤害不减免。\n铁匠：你这不是没穿甲，是出厂就焊上了。\n旧档头盔在行囊有空位时自动收回；仍戴着旧头盔时，头部减伤暂不生效。";
    },
    function enabled() { return ::AfeixExpedition.isTurtle(this.getContainer().getActor()); },
    function onUpdate(p) { if (this.enabled()) { p.MeleeDefense += 5; p.RangedDefense += 5; } },
    function onBeforeDamageReceived(attacker, skill, hit, p) {
        if (!this.enabled() || skill == null || !skill.isAttack() || !skill.m.IsWeaponSkill) return;
        local a = this.getContainer().getActor();
        if (hit.BodyPart == this.Const.BodyPart.Head) {
            if (a.getItems().getItemAtSlot(this.Const.ItemSlot.Head) == null) p.DamageReceivedTotalMult *= 0.5;
        } else p.DamageReceivedTotalMult *= 0.8;
    }
});
