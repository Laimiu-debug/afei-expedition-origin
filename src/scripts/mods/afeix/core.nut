local A = ::AfeixExpedition;
A.isOrigin <- function() {
    // Standalone tactical scenarios expose World before the campaign managers
    // exist. Global actor hooks also run there while native equipment is added.
    return "World" in getroottable() && ::World != null && "Assets" in ::World
        && ::World.Assets != null && ::World.Assets.getOrigin() != null
        && ::World.Assets.getOrigin().getID() == "scenario.afeix_expedition";
};
A.get <- function(key, fallback = 0) {
    return ::World.Flags.has("afeix_" + key) ? ::World.Flags.get("afeix_" + key) : fallback;
};
A.set <- function(key, value) {
    ::World.Flags.set("afeix_" + key, value);
    return value;
};
A.roster <- function() { return ::World.getPlayerRoster().getAll(); };
A.result <- function(ok, text) { return { ok = ok, text = text }; };
A.currentTown <- function() {
    if (!this.isOrigin() || ::World.State == null) return null;
    local player = ::World.State.getPlayer();
    if (player == null) return null;
    local nearest = null, distance = 999;
    foreach (town in ::World.EntityManager.getSettlements()) {
        if (!town.isAlive() || town.isMilitary() || !town.isAlliedWithPlayer()) continue;
        local d = town.getTile().getDistanceTo(player.getTile());
        if (d <= 1 && d < distance) { nearest = town; distance = d; }
    }
    return nearest;
};
// The ledger may be read elsewhere; mutations require a peaceful world-map node.
A.canManage <- function() {
    if (!this.isOrigin() || ::Tactical.isActive() || ::World.State == null) return false;
    if (::World.State.getCombatStartTime() != 0 || ::World.State.getPlayer() == null) return false;
    if (this.currentTown() == null && (!::World.Assets.isCamping() || !::World.State.isCampingAllowed())) return false;
    foreach (entity in ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(), 400.0)) {
        if (entity != null && entity.isAlive() && !entity.isAlliedWithPlayer()
            && "getTroops" in entity && entity.getTroops().len() > 0) return false;
    }
    return true;
};
A.refreshAssets <- function() {
    if (::World.State != null) ::World.State.updateTopbarAssets();
};
A.syncCharacterFeatures <- function(bro) {
    if (!this.isOrigin() || bro == null) return;
    if ("syncBalance" in this) this.syncBalance(bro);
    if ("syncRosterTalents" in this) this.syncRosterTalents(bro);
    if ("syncPersonalGrowth" in this) this.syncPersonalGrowth(bro);
    if ("syncMemberSkills" in this) this.syncMemberSkills(bro);
    if ("syncPromotion" in this) this.syncPromotion(bro);
    if ("syncCharacterArt" in this) this.syncCharacterArt(bro);
    if ("syncIdeasCharacter" in this) this.syncIdeasCharacter(bro);
};
