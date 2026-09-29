this.afeix_haoqi_effect <- this.inherit("scripts/skills/effects/afeix_promotion_effect", {
    m = {},
    function create() {
        this.afeix_promotion_effect.create();
        this.m.ID = "effects.afeix_haoqi";
        this.m.Name = "豪气冲天";
        this.m.Icon = "skills/afeix_haoqi.png"; this.m.IconMini = this.m.Icon;
        this.m.Description = "双攻+6、决心+8，至下次回合结束。";
        this.m.Melee = 6;
        this.m.Ranged = 6;
        this.m.BraveryBonus = 8;
        this.m.TurnsLeft = 2;
    }
});
