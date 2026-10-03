this.afeix_douyu_fin_cleaver <- this.inherit("scripts/items/weapons/ancient/crypt_cleaver", {
    m = {},
    function create() {
        this.crypt_cleaver.create();
        this.m.ID = "weapon.afeix_douyu_fin_cleaver";
        this.m.Name = "断潮鱼翅";
        this.m.Description = "斗鱼背鳍被锻成一把宽厚的双手砍刀。灰蓝鳍骨撑起刀背，内侧细密的锯齿被磨成一道橙红薄刃；挥动时没有礼炮的喧嚣，只有潮水断开的低响。\n\n固定传奇双手砍刀：90–120 伤害，165% 护甲伤害，55% 穿甲；武器技能基础疲劳减少 5。沿用砍切、斩首、劈盾与砍刀专精。";
        this.m.Categories = "传奇砍刀，双手";
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.Icon = "weapons/melee/afeix_douyu_fin_cleaver_70x70.png";
        this.m.IconLarge = "weapons/melee/afeix_douyu_fin_cleaver.png";
        this.m.ArmamentIcon = "afeix_douyu_fin_cleaver";
        this.m.ArmamentIconBloody = "afeix_douyu_fin_cleaver_bloodied";
        this.m.Value = 22000; this.m.Condition = 80.0; this.m.ConditionMax = 80.0;
        this.m.StaminaModifier = -7; this.m.RegularDamage = 90; this.m.RegularDamageMax = 120;
        this.m.ArmorDamageMult = 1.65;
        // Native attacks read DirectDamageAdd, not the weapon display base.
        this.m.DirectDamageMult = 0.25; this.m.DirectDamageAdd = 0.30;
        this.m.ShieldDamage = 34; this.m.FatigueOnSkillUse = -5;
    },
    function getTooltip() {
        local result = this.crypt_cleaver.getTooltip();
        foreach(row in result) if("icon" in row) {
            if(row.icon == "ui/icons/armor_damage.png") row.text = "护甲伤害效率：[color=" + this.Const.UI.Color.DamageValue + "]" + this.Math.round(this.m.ArmorDamageMult * 100) + "%[/color]";
            if(row.icon == "ui/icons/direct_damage.png") row.text = "穿透护甲：[color=" + this.Const.UI.Color.DamageValue + "]" + this.Math.round((this.m.DirectDamageMult + this.m.DirectDamageAdd) * 100) + "%[/color]";
        }
        return result;
    }
});
