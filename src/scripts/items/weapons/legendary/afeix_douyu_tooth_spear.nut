this.afeix_douyu_tooth_spear <- this.inherit("scripts/items/weapons/fighting_spear", {
    m = {},
    function create() {
        this.fighting_spear.create();
        this.m.ID = "weapon.afeix_douyu_tooth_spear";
        this.m.Name = "破浪鲨牙";
        this.m.Description = "最深处的一枚鲨牙被嵌入硬木矛杆，以铁箍和旧绳牢牢绑紧。苍白牙尖覆着细细的灰纹，像把整片黑水压进了刃口。曾经追着点名扑咬的獠牙，如今守在兄弟们的阵线前。\n\n固定传奇单手矛：54–62 伤害，145% 护甲伤害，45% 穿甲；武器技能基础疲劳减少 4。沿用刺击的 +20 命中、矛墙、持盾和双握与矛专精。";
        this.m.Categories = "传奇矛，单手";
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.Icon = "weapons/melee/afeix_douyu_tooth_spear_70x70.png";
        this.m.IconLarge = "weapons/melee/afeix_douyu_tooth_spear.png";
        this.m.ArmamentIcon = "afeix_douyu_tooth_spear";
        this.m.ArmamentIconBloody = "afeix_douyu_tooth_spear_bloodied";
        this.m.Value = 18000; this.m.Condition = 120.0; this.m.ConditionMax = 120.0;
        this.m.StaminaModifier = -1; this.m.RegularDamage = 54; this.m.RegularDamageMax = 62;
        this.m.ArmorDamageMult = 1.45;
        this.m.DirectDamageMult = 0.25; this.m.DirectDamageAdd = 0.20;
        this.m.FatigueOnSkillUse = -4;
    },
    function getTooltip() {
        local result = this.fighting_spear.getTooltip();
        foreach(row in result) if("icon" in row) {
            if(row.icon == "ui/icons/armor_damage.png") row.text = "护甲伤害效率：[color=" + this.Const.UI.Color.DamageValue + "]" + this.Math.round(this.m.ArmorDamageMult * 100) + "%[/color]";
            if(row.icon == "ui/icons/direct_damage.png") row.text = "穿透护甲：[color=" + this.Const.UI.Color.DamageValue + "]" + this.Math.round((this.m.DirectDamageMult + this.m.DirectDamageAdd) * 100) + "%[/color]";
        }
        return result;
    }
});
