this.afei_bicycle_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.afei_bicycle";
		this.m.Name = "自行车";
		this.m.Description = "阿飞从烟港一路推来的旧车。车铃时灵时不灵，踏板很涩。瓶队偶尔会替他把链条拨回去；没人说这辆车为什么一直没扔。";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = false;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/afei_bicycle.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 66,
				type = "text",
				text = this.getValueString()
			},
			{
				id = 3,
				type = "image",
				image = this.getIcon()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "有些告别以后，旧东西会忽然变得比行李更沉。"
			}
		];
		return result;
	}

	function playInventorySound(_eventType)
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}
});
