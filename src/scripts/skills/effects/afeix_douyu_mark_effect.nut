this.afeix_douyu_mark_effect <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "effects.afeix_douyu_mark"; this.m.Name = "开播点名";
        this.m.Description = "斗鱼下次回合会扑咬三格内的这名队员。标记跟随队员；走位或换位须将其带到四格外才能避开，留在三格内可用盾墙防御。单纯交换位置不会移除标记。此标记本身不会夺走行动点。";
        this.m.Icon = "skills/afeix_douyu_mark.png";
        this.m.IconMini = "status_effect_34_mini"; this.m.Overlay = "status_effect_34";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false; this.m.IsStacking = false;
        this.m.IsSerialized = false; this.m.IsRemovedAfterBattle = true;
    },
    function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; }
});
