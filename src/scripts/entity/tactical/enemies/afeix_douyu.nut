this.afeix_douyu <- this.inherit("scripts/entity/tactical/actor", {
    m = { AfeixDouyuLootDropped = false },
    function create() {
        this.m.Type = this.Const.EntityType.Unhold;
        this.m.Name = "斗鱼·深渊之主";
        this.m.MoraleState = this.Const.MoraleState.Ignore;
        this.m.BloodType = this.Const.BloodType.Red; this.m.XP = 3000;
        this.m.BloodSplatterOffset = this.createVec(0, 0); this.m.DecapitateSplatterOffset = this.createVec(0, -20);
        this.m.ConfidentMoraleBrush = "icon_confident_orcs";
        this.actor.create();
        this.m.Sound[this.Const.Sound.ActorEvent.Death] = ["sounds/enemies/unhold_death_01.wav"];
        this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = ["sounds/enemies/unhold_hurt_01.wav"];
        this.m.Sound[this.Const.Sound.ActorEvent.Idle] = ["sounds/enemies/unhold_idle_01.wav"];
        this.m.SoundPitch = 0.8; this.m.SoundVolumeOverall = 1.2;
        local agent = this.new("scripts/ai/tactical/agents/unhold_agent");
        agent.clearBehaviors();
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_idle"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
        local bite = this.new("scripts/ai/tactical/behaviors/ai_attack_default");
        bite.m.PossibleSkills = ["actives.afeix_douyu_bite"];
        agent.addBehavior(bite);
        agent.addBehavior(this.new("scripts/mods/afeix/douyu_ai"));
        agent.finalizeBehaviors(); agent.setActor(this); this.m.AIAgent = agent;
    },
    function onInit() {
        this.actor.onInit();
        local b = this.m.BaseProperties;
        b.setValues(::AfeixExpedition.Douyu.Stats);
        b.HitpointsRecoveryRate = 0;
        this.m.ActionPoints = b.ActionPoints; this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
        this.m.ActionPointCosts = this.Const.DefaultMovementAPCost; this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
        this.m.Items.getAppearance().Body = "afeix_douyu_body";
        this.addSprite("socket").setBrush("bust_base_beasts");
        this.addSprite("body").setBrush("afeix_douyu_body");
        this.addSprite("injury").Visible = false;
        this.addSprite("armor"); this.addSprite("head"); this.addSprite("helmet");
        this.addDefaultStatusSprites();
        this.setSpriteOffset("status_stunned", this.createVec(0, 20));
        this.setSpriteOffset("arrow", this.createVec(0, 20));
        this.m.Skills.add(this.new("scripts/skills/effects/afeix_douyu_core_effect"));
        this.m.Skills.add(this.new("scripts/skills/actives/afeix_douyu_bite_skill"));
        this.m.Skills.add(this.new("scripts/skills/actives/afeix_douyu_mark_skill"));
        this.m.Skills.add(this.new("scripts/skills/actives/afeix_douyu_barrage_skill"));
        this.m.Skills.add(this.new("scripts/skills/actives/afeix_douyu_rocket_skill"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
    },
    function onFactionChanged() {
        this.actor.onFactionChanged(); this.getSprite("body").setHorizontalFlipping(this.isAlliedWithPlayer());
    },
    function onDeath(_killer, _skill, _tile, _fatalityType) {
        // The corpse never borrows Unhold drops or resurrects. Real final-boss
        // death adds exactly the three fixed trophies through native tile loot.
        if(_tile != null) {
            local decal = _tile.spawnDetail("afeix_douyu_dead", this.Const.Tactical.DetailFlag.Corpse, false);
            decal.setBrightness(0.9);
            this.spawnBloodPool(_tile, 1);
            local corpse = clone this.Const.Corpse;
            corpse.CorpseName = "斗鱼·深渊之主"; corpse.IsResurrectable = false; corpse.IsConsumable = false; corpse.Tile = _tile;
            corpse.Items = this.getItems().prepareItemsForCorpse(_killer);
            _tile.Properties.set("Corpse", corpse); this.Tactical.Entities.addCorpse(_tile);
        }
        ::AfeixExpedition.dropDouyuTrophies(this, _tile);
        this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
    },
    function assignRandomEquipment() {}
});
