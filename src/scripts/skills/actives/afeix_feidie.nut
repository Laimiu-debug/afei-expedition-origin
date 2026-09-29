this.afeix_feidie <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_feidie";
        this.m.Name = "飞爹在此";
        this.m.Description = "花20克朗，2格内最多3名队员（含自己）双攻+5、决心+5至各自下次回合结束；自己近防-3至下次回合开始。每战2次、冷却4轮。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_feidie.png"; this.m.IconMini = this.m.Icon;
        this.m.Route = "feidie";
        this.m.GoldCost = 20;
        this.m.Radius = 2;
    }
});
