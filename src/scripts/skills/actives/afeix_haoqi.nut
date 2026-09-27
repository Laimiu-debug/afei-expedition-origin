this.afeix_haoqi <- this.inherit("scripts/skills/actives/afeix_promotion_active", {
    m = {},
    function create() {
        this.afeix_promotion_active.create();
        this.m.ID = "actives.afeix_haoqi";
        this.m.Name = "豪气冲天";
        this.m.Description = "掏出 80 克朗给同行的人壮胆。3 格内本方可操控角色（含阿飞）的近战与远程命中 +10，决心 +10，持续至各自第二次回合开始。";
        this.m.Icon = this.m.IconDisabled = "skills/afeix_haoqi.png";
        this.m.Route = "jiahao";
        this.m.GoldCost = 80;
        this.m.Radius = 3;
    }
});
