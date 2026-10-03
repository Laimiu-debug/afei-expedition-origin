this.afeix_douyu_sharkskin <- this.inherit("scripts/items/armor/armor", {
    m = {},
    function create() {
        this.armor.create();
        this.m.ID = "armor.body.afeix_douyu_sharkskin";
        this.m.Name = "深渊鲨衣";
        this.m.Description = "从斗鱼身上剥下的整片鲨皮，经盐水浸制后仍透着深海的灰蓝光泽。皮下密集的细鳞像一层层柔韧铁片，粗缝线将它们缚成贴身战衣。肩头还留着一截橙红的旧饰带——那张笑脸终于不会再跟着它浮出黑水。\n\n460 点护甲，最大疲劳 -26。固定传奇数值，不随机浮动；可正常修理并加装护甲附件。";
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
        this.m.IsDroppedAsLoot = true; this.m.ShowOnCharacter = true; this.m.IsIndestructible = true;
        this.updateVariant();
        this.m.Value = 26000; this.m.Condition = 460.0; this.m.ConditionMax = 460.0; this.m.StaminaModifier = -26;
    },
    function updateVariant() {
        // Native armor deserialize calls updateVariant twice; retain custom art.
        this.m.Icon = "armor/afeix_douyu_sharkskin_70x70.png";
        this.m.IconLarge = "armor/afeix_douyu_sharkskin.png";
        this.m.Sprite = "afeix_douyu_sharkskin";
        this.m.SpriteDamaged = "afeix_douyu_sharkskin_damaged";
        this.m.SpriteCorpse = "afeix_douyu_sharkskin_dead";
    }
});
