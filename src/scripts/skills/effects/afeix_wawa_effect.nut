this.afeix_wawa_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_wawa";
        this.m.Name = "哇哇叫";
        this.m.Icon = "skills/afeix_wawa.png"; this.m.IconMini = "status_effect_34_mini"; this.m.Overlay = "status_effect_34";
        this.m.Description = "近战命中+8、近防-5，至阿飞下次回合开始。";
        this.m.Melee = 8;
        this.m.Incoming = 1.0;
    }
});
