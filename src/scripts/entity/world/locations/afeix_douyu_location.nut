this.afeix_douyu_location <- this.inherit("scripts/entity/world/location", {
    m = {},
    function create() {
        this.location.create();
        this.m.TypeID = "location.afeix_douyu";
        this.m.Name = "梦潮祭场";
        this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
        this.m.IsShowingDefenders = false;
        this.m.IsShowingBanner = false;
        this.m.IsSpawningDefenders = false;
        this.m.IsDespawningDefenders = false;
        this.m.IsScalingDefenders = false;
        this.m.IsAttackableByAI = false;
        this.m.VisibilityMult = 0.85;
        this.m.Resources = 1000;
        this.m.CombatLocation.Template = [null, null];
        this.m.CombatLocation.ForceLineBattle = true;
        this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
    },
    function getDescription() {
        return "橙色的鳍影在梦沼上方游弋，旧石柱缠着被潮水打湿的旗绳。三位队长曾经在梦里抵达这里，深渊之主如今正等着现实中的黑旗。\n\n准备好队伍与补给，再从大陆前往挑战。伤亡和消耗都会留下，撤退后仍可回来。潮声背后的秘密，还埋在祭场深处。";
    },
    function createDefenders() {
        if (this.m.Troops.len() != 0 || ::AfeixExpedition.douyuWorldDefeated()) return;
        local troop = clone this.Const.World.Spawn.Troops.Unhold;
        troop.Script = "scripts/entity/tactical/enemies/afeix_douyu";
        troop.Variant = 0; troop.Strength = 1000;
        this.Const.World.Common.addTroop(this, { Type = troop });
    },
    function onSpawned() {
        this.m.Name = "梦潮祭场";
        this.location.onSpawned();
        this.createDefenders();
    },
    function onInit() {
        this.location.onInit();
        this.addSprite("body").setBrush("world_kraken_stones");
    },
    function onEnteringCombatWithPlayer(isPlayerAttacking = true) {
        if (::AfeixExpedition.isDreamCombat() || ::AfeixExpedition.douyuWorldDefeated()) return false;
        return this.location.onEnteringCombatWithPlayer(isPlayerAttacking);
    },
    function onBeforeCombatStarted() {
        this.createDefenders();
        return this.location.onBeforeCombatStarted();
    },
    function onCombatLost() {
        ::AfeixExpedition.recordDouyuWorldVictory();
        return this.location.onCombatLost();
    },
    function onDiscovered() {
        this.location.onDiscovered();
        ::AfeixExpedition.set("douyu_world_discovered", true);
    }
});
