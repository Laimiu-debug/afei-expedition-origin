this.afeix_haoqi_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_haoqi";
        this.m.Name = "豪气冲天";
        this.m.Icon = "skills/afeix_haoqi.png";
        this.m.Description = "近战与远程命中 +10，决心 +10；持续至该角色第二次回合开始。";
        this.m.Melee = 10;
        this.m.Ranged = 10;
        this.m.BraveryBonus = 10;
    }
});
