this.afeix_feidie_guard_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_feidie_guard";
        this.m.Name = "飞爹撑得住";
        this.m.Icon = "skills/afeix_feidie.png"; this.m.IconMini = this.m.Icon;
        this.m.Description = "阿飞近防-3，至自己下次回合开始。";
        this.m.Incoming = 1.0;
    }
});
