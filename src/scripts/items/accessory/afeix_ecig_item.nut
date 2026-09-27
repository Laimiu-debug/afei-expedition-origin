this.afeix_ecig_item <- this.inherit("scripts/items/accessory/accessory", {
    m = {},
    function create() {
        this.accessory.create();
        this.m.ID = "accessory.afeix_ecig";
        this.m.Name = "电子烟";
        this.m.Description = "阿飞随身带着的小玩意。金属外壳磕得坑坑洼洼，他却一直不肯换。装备在饰品栏后，阿飞可以在战斗中使用“抽一口”。";
        this.m.Icon = "accessory/afeix_ecig.png";
        this.m.IconLarge = "";
        this.m.AddGenericSkill = false;
        this.m.ShowOnCharacter = false;
        this.m.IsSellable = false;
        this.m.IsDroppedAsLoot = true;
        this.m.Value = 0;
    },
    function getTooltip() {
        return [
            { id = 1, type = "title", text = this.getName() },
            { id = 2, type = "description", text = this.getDescription() },
            { id = 3, type = "image", image = this.getIcon() },
            { id = 10, type = "text", icon = "ui/icons/health.png", text = "抽一口：恢复最多 20 生命；消耗 3 行动点、5 疲劳。" },
            { id = 11, type = "text", icon = "ui/icons/special.png", text = "仅阿飞可用，每回合一次，不消耗物品。装卸不会重置使用次数。" },
            { id = 12, type = "text", icon = "ui/icons/warning.png", text = "占用饰品栏；只恢复生命，不修复护甲或治愈伤势。" }
        ];
    },
    function onEquip() {
        this.accessory.onEquip();
        this.addSkill(this.new("scripts/skills/actives/afeix_ecig_puff"));
    },
    function playInventorySound(eventType) { this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory); }
});
