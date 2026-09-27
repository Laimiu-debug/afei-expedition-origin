this.afeix_wawa <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_wawa";
        this.m.Name = "哇哇叫";
        this.m.Description = "阿飞把这一嗓子留给自己：近战命中 +12，所受伤害减少 20%，持续至自己的第二次回合开始。不会鼓舞其他人。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_wawa.png";
        this.m.Route = "toad";
        this.m.ActionPointCost = 3;
        this.m.FatigueCost = 15;
    }
});
