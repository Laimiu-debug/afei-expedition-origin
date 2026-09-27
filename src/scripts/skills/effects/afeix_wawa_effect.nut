this.afeix_wawa_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_wawa";
        this.m.Name = "哇哇叫";
        this.m.Icon = "skills/afeix_wawa.png";
        this.m.Description = "近战命中 +12，所受伤害减少 20%；持续至阿飞第二次回合开始。";
        this.m.Melee = 12;
        this.m.Incoming = 0.80;
    }
});
