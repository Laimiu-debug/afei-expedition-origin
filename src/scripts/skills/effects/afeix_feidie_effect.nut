this.afeix_feidie_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_feidie";
        this.m.Name = "飞爹在此";
        this.m.Icon = "skills/afeix_feidie.png";
        this.m.Description = "近战与远程命中 +8，决心 +8；持续至该角色第二次回合开始。";
        this.m.Melee = 8;
        this.m.Ranged = 8;
        this.m.BraveryBonus = 8;
    }
});
