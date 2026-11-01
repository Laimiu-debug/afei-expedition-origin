this.afeix_feidie_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_feidie";
        this.m.Name = "飞爹在此";
        this.m.Icon = "skills/afeix_feidie.png"; this.m.IconMini = "status_effect_33_mini"; this.m.Overlay = "status_effect_33";
        this.m.Description = "双攻+5、决心+5，至下次回合结束。";
        this.m.Melee = 5;
        this.m.Ranged = 5;
        this.m.BraveryBonus = 5;
        this.m.TurnsLeft = 2;
    }
});
