this.afeix_turtle_retract <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_turtle_retract";
        this.m.Name = "缩头乌龟";
        this.m.Icon = "skills/afeix_member_turtle_cover.png";
        this.m.IconMini = this.m.Icon;
        this.m.IsSerialized = true;
        this.m.Description = "刀锋往脑袋上招呼时，她会把头缩回壳里。头部命中有25%概率完全免疫本次伤害；未触发时，将这次命中转移到身体，按身甲、身体伤害倍率与身体伤势计算。身体命中、流血和中毒照常生效。";
    },
    function onHeadHit(skill, hit, bodyMultiplier) {
        if (this.Math.rand(1, 100) <= 25) {
            hit.DamageInflictedHitpoints = 0;
            hit.DamageInflictedArmor = 0;
            return true;
        }
        // Resolve the body part before native armor, damage, fatality and injury
        // processing. Editing only the eventual HP damage would bypass armor.
        hit.BodyPart = this.Const.BodyPart.Body;
        hit.BodyDamageMult = bodyMultiplier;
        hit.Injuries = skill != null && "InjuriesOnBody" in skill.m ? skill.m.InjuriesOnBody : null;
        return false;
    }
});
