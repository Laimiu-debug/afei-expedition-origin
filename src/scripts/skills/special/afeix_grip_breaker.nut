this.afeix_grip_breaker <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "special.afeix_grip_breaker";
        this.m.Type = this.Const.SkillType.Special;
        this.m.IsHidden = true; this.m.IsSerialized = false;
    },
    function onTargetHit(skill, target, part, hp, armor) {
        ::AfeixExpedition.gripBreakArmor(this.getContainer().getActor(), skill, target, part);
    }
});
