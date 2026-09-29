this.afeix_haoqi <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_haoqi";
        this.m.Name = "豪气冲天";
        this.m.Description = "花25克朗，2格内最多3名队员（含自己）双攻+6、决心+8，至各自下次回合结束；每战2次、冷却4轮。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_haoqi.png"; this.m.IconMini = this.m.Icon;
        this.m.Route = "jiahao";
        this.m.GoldCost = 25;
        this.m.Radius = 2;
    }
});
