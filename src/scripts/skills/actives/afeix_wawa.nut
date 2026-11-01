this.afeix_wawa <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_wawa";
        this.m.Name = "哇哇叫";
        this.m.Description = "阿飞把这一嗓子留给自己：近战命中+8、近防-5，持续至自己下次回合开始；每战2次、冷却3轮。不会鼓舞其他人。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_wawa.png"; this.m.IconMini = this.m.Icon;
        this.m.Route = "toad";
        ::AfeixExpedition.configureActiveFeedback(this, "wawa");
        this.m.ActionPointCost = 1;
        this.m.FatigueCost = 18;
    }
});
