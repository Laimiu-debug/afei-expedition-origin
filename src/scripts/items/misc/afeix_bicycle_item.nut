this.afeix_bicycle_item <- this.inherit("scripts/items/item", {
    m = {},
    function create() {
        this.item.create();
        this.m.ID = "misc.afeix_bicycle";
        this.m.Name = "旧自行车";
        this.m.Description = "阿飞一路推来的旧车。车铃时灵时不灵，链条总有些松。小酒瓶替他拨回过几次，后来他也慢慢学会了自己修。";
        this.m.Icon = "accessory/afeix_bicycle.png";
        this.m.SlotType = this.Const.ItemSlot.None;
        this.m.ItemType = this.Const.Items.ItemType.Misc;
        this.m.IsAllowedInBag = false;
        this.m.IsSellable = false;
        this.m.IsDroppedAsLoot = false;
        this.m.Value = 0;
    },
    function getTooltip() {
        return [
            { id = 1, type = "title", text = this.getName() },
            { id = 2, type = "description", text = this.getDescription() },
            { id = 3, type = "image", image = this.getIcon() },
            { id = 10, type = "text", icon = "ui/icons/special.png", text = "随营地行囊保管的旧物，不能穿戴或出售。" }
        ];
    },
    function playInventorySound(eventType) { this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory); }
});
