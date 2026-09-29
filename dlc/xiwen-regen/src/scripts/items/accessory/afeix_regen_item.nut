// Native wardog owns combat AI, return, death, item persistence and armor use.
this.afeix_regen_item <- this.inherit("scripts/items/accessory/wardog_item", {
    m = {},
    function create() {
        this.wardog_item.create();
        this.m.ID = "accessory.afeix_regen";
        this.m.Name = "里根";
        this.m.Description = "阿飞的狗里根。从黑旗启程的第一天起，它就陪在阿飞身边。开局若阿飞的饰品栏已被电子烟等物品占用，里根会在队伍仓库等候。战前给一名队员装备里根，战斗中可放到相邻空地；存活时会在战后回来。请照看好它，里根也会在战斗中阵亡。";
    },
    function getName() { return this.isUnleashed() ? this.m.Name + "的项圈" : this.m.Name; },
    function getDescription() {
        return this.isUnleashed() ? "里根已经进入战场。这是它留下的项圈；它活着回来时，会重新回到同行者身边。" : this.m.Description;
    }
});
