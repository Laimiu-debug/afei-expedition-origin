this.afeix_promotion_effect <- this.inherit("scripts/skills/skill", {
    m = { TurnsLeft = 1, Melee = 0, Ranged = 0, BraveryBonus = 0, Incoming = 1.0 },
    function create() {
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsSerialized = true;
        this.m.IsRemovedAfterBattle = true;
    },
    function onUpdate(properties) {
        ::AfeixExpedition.balanceHit(properties,"MeleeSkill",this.m.Melee);
        ::AfeixExpedition.balanceHit(properties,"RangedSkill",this.m.Ranged);
        properties.Bravery += this.m.BraveryBonus;
        if(this.m.ID=="effects.afeix_wawa")properties.MeleeDefense-=5;
        if(this.m.ID=="effects.afeix_feidie_guard")properties.MeleeDefense-=3;
    },
    function onTurnStart() {
        if ((this.m.ID=="effects.afeix_wawa"||this.m.ID=="effects.afeix_feidie_guard") && --this.m.TurnsLeft<=0)this.removeSelf();
        else if(this.m.TurnsLeft==2)this.m.TurnsLeft=1;
    },
    // Two means waiting for the next recipient turn; one means that turn began.
    // Keep the existing serialized byte so mid-battle saves retain this phase.
    function onTurnEnd(){if(this.m.ID!="effects.afeix_wawa"&&this.m.ID!="effects.afeix_feidie_guard"&&this.m.TurnsLeft==1){this.m.TurnsLeft=0;this.removeSelf();}},
    function onSerialize(out) {
        this.skill.onSerialize(out);
        out.writeU8(this.m.TurnsLeft);
    },
    function onDeserialize(input) {
        this.skill.onDeserialize(input);
        this.m.TurnsLeft = input.readU8();
    }
});
