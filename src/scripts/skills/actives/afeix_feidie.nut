this.afeix_feidie <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_feidie";
        this.m.Name = "飞爹在此";
        this.m.Description = "花费 60 克朗，2 格内本方可操控角色（含阿飞）近战与远程命中 +8、决心 +8；阿飞另获所受伤害减少 10%。持续至各自第二次回合开始。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_feidie.png";
        this.m.Route = "feidie";
        this.m.GoldCost = 60;
        this.m.Radius = 2;
    }
});
