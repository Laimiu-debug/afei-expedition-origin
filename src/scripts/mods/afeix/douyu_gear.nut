local A = ::AfeixExpedition;
A.DouyuTrophyPaths <- [
    "scripts/items/armor/legendary/afeix_douyu_sharkskin",
    "scripts/items/weapons/legendary/afeix_douyu_fin_cleaver",
    "scripts/items/weapons/legendary/afeix_douyu_tooth_spear"
];
A.douyuLootClaimed <- function() { return this.get("douyu_loot_dropped", false); };
A.dropDouyuTrophies <- function(actor, tile) {
    // Boss death is the sole award boundary. Winning/retreating/visiting the
    // site never creates items, and dream actors can never touch the real flag.
    local p = ::Tactical.State.getStrategicProperties();
    if(!this.isOrigin() || p == null || !("CombatID" in p) || p.CombatID != "afeix_douyu_final"
        || ("isDreamCombat" in this && this.isDreamCombat())
        // Native kill sets IsDying before onDeath and IsAlive=false afterwards.
        || actor == null || !actor.isDying() || !actor.isPlacedOnMap()
        || actor.m.AfeixDouyuLootDropped || this.douyuLootClaimed()) return false;
    if(tile == null) tile = actor.getTile();
    // Resolve all class/resource references before the first irreversible drop.
    local items = [];
    foreach(path in this.DouyuTrophyPaths) items.push(::new(path));
    actor.dropLoot(tile, items, false);
    actor.m.AfeixDouyuLootDropped = true;
    this.set("douyu_loot_dropped", true);
    return true;
};
