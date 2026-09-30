this.afeix_laoma_grip <- this.inherit("scripts/items/weapons/two_handed_hammer", {
    m = {},
    function create() {
        this.two_handed_hammer.create();
        this.m.ID = "weapon.afeix_laoma_grip";
        this.m.Name = "老马的垂直握把";
        this.m.Description = "曹飞派领袖老马的化身，一身风骚尽在这根握把。马头一昂，蛤蟆低头；握把一挺，铁甲开口。阿飞嫌它不正经，老马笑得更灿烂：‘飞哥，站稳了——我这一下，专治嘴硬甲也硬。’铁匠叮嘱双手握紧，掌柜补了一句：盔甲可以再买，矜持就别带上战场了。\n\n单体重击命中后，对命中部位额外削减最多 30 点护甲；不溢出为生命伤害，横扫和反击不触发。";
        this.m.Categories = "传奇双手锤";
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.IconLarge = "weapons/afeix_laoma_grip.png";
        this.m.Icon = "weapons/afeix_laoma_grip_70x70.png";
        this.m.ArmamentIcon = "icon_afeix_laoma_grip";
        this.m.Value = 28888;
        this.m.Condition = 100.0; this.m.ConditionMax = 100.0;
        this.m.RegularDamage = 84; this.m.RegularDamageMax = 120;
        this.m.ArmorDamageMult = 2.35;
        // Weapon DirectDamageMult is display-only; attacks consume DirectDamageAdd.
        // Keep native Smite/Shatter bases (50%/40%) and add 20 percentage points.
        this.m.DirectDamageMult = 0.5; this.m.DirectDamageAdd = 0.2;
        this.m.ShieldDamage = 52;
        this.m.StaminaModifier = -18;
    },
    function getTooltip() {
        local result = this.two_handed_hammer.getTooltip();
        // Native floor(2.35 * 100) renders 234 with Squirrel's float precision.
        // Round this item's percentage for display; keep the combat multiplier 2.35.
        foreach (row in result)
            if (row.id == 5 && "icon" in row && row.icon == "ui/icons/armor_damage.png")
                row.text = "对护甲的伤害效率为 [color=" + this.Const.UI.Color.DamageValue + "]" + this.Math.round(this.m.ArmorDamageMult * 100) + "%[/color]";
        return result;
    },
    function onEquip() {
        this.two_handed_hammer.onEquip();
        local s = this.getContainer().getActor().getSkills().getSkillByID("actives.smite");
        if (s != null) s.setFatigueCost(20);
        this.addSkill(this.new("scripts/skills/special/afeix_grip_breaker"));
    }
});
