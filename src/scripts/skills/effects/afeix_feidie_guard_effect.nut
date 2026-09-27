this.afeix_feidie_guard_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_feidie_guard";
        this.m.Name = "飞爹撑得住";
        this.m.Icon = "skills/afeix_feidie.png";
        this.m.Description = "阿飞所受伤害减少 10%；持续至自己第二次回合开始。";
        this.m.Incoming = 0.90;
    }
});
