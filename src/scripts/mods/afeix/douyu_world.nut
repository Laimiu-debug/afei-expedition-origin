// One real legendary location, separate from every temporary dream encounter.
local A = ::AfeixExpedition;
A.DouyuWorldType <- "location.afeix_douyu";
A.DouyuWorldChecked <- false;
A.DouyuWorldLocationID <- 0;
A.DouyuMapFocusQueued <- false;
A.findDouyuWorldLocation <- function() {
    if (!this.isOrigin() || this.isDreamCombat()) return null;
    if (this.DouyuWorldLocationID != 0) {
        local location = ::World.getEntityByID(this.DouyuWorldLocationID);
        if (location != null && location.isAlive() && location.getTypeID() == this.DouyuWorldType) return location;
    }
    foreach (location in ::World.EntityManager.getLocations()) {
        if (location.isAlive() && location.getTypeID() == this.DouyuWorldType) {
            this.DouyuWorldLocationID = location.getID();
            return location;
        }
    }
    this.DouyuWorldLocationID = 0;
    return null;
};
A.douyuWorldDefeated <- function() { return this.get("douyu_final_defeated", false) || this.get("douyu_loot_dropped", false); };
A.recordDouyuWorldVictory <- function() {
    if (this.get("douyu_final_defeated", false)) return false;
    this.set("douyu_final_defeated", true);
    this.set("douyu_final_unlocked", true);
    this.set("douyu_final_notice", true);
    return true;
};
A.chooseDouyuWorldTile <- function() {
    local size = ::World.getMapSize(), terrain = ::Const.World.TerrainType;
    if (size.X < 6 || size.Y < 6) return null;
    local settlements = ::World.EntityManager.getSettlements(), locations = ::World.EntityManager.getLocations();
    local candidates = [], width = size.X - 4, height = size.Y - 4, total = width * height;
    // At most 4096 sampled tiles and 48 native navigator calls per creation.
    // Sampling is deterministic and does not consume campaign random rolls.
    local budget = ::Math.min(4096, total);
    for (local n = 0; n < budget; ++n) {
        local index = (n * total / budget).tointeger();
        local x = 2 + index % width, y = 2 + index / width;
        local tile = ::World.getTileSquare(x, y);
        if (tile.IsOccupied || tile.HasRoad || tile.Type == terrain.Ocean || tile.Type == terrain.Shore
            || tile.Type == terrain.Mountains || tile.Type == terrain.Impassable || tile.Type == terrain.Urban) continue;
        local nearest = 9000;
        foreach (town in settlements) nearest = ::Math.min(nearest, tile.getDistanceTo(town.getTile()));
        if (nearest < 8) continue;
        local crowded = false;
        foreach (location in locations) if (location.isAlive() && tile.getDistanceTo(location.getTile()) < 6) { crowded = true; break; }
        if (crowded) continue;
        local coastal = false;
        for (local direction = 0; direction < 6; ++direction) {
            if (!tile.hasNextTile(direction)) continue;
            local next = tile.getNextTile(direction);
            if (next.Type == terrain.Ocean || next.Type == terrain.Shore) { coastal = true; break; }
        }
        local score = 100.0 * y / size.Y + 2 * ::Math.min(nearest, 45) + (coastal ? 150 : 0) + (tile.Type == terrain.Swamp ? 180 : 0);
        candidates.push({ Tile = tile, Score = score });
    }
    candidates.sort(function(a, b) { return a.Score > b.Score ? -1 : a.Score < b.Score ? 1 : 0; });
    local nav = ::World.getNavigator().createSettings();
    nav.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;
    local home = ::World.State.getPlayer().getTile();
    local attempts = ::Math.min(48, candidates.len());
    for (local i = 0; i < attempts; ++i) {
        // After the best sixteen sites, spread checks through the remaining
        // ranking so an unreachable northern island cannot exhaust all tries.
        local index = i < 16 ? i : 16 + (i - 16) * (candidates.len() - 16) / (attempts - 16);
        local path = ::World.getNavigator().findPath(candidates[index].Tile, home, nav, 0);
        if (!path.isEmpty()) return candidates[index].Tile;
    }
    return null;
};
A.ensureDouyuWorldLocation <- function() {
    if (!this.dreamWorldReady() || this.DouyuWorldChecked) return false;
    this.DouyuWorldChecked = true;
    local existing = this.findDouyuWorldLocation();
    // A completed save must never regenerate its slain boss or its equipment.
    foreach (location in clone ::World.EntityManager.getLocations()) {
        if (!location.isAlive() || location.getTypeID() != this.DouyuWorldType) continue;
        if (this.douyuWorldDefeated() || (existing != null && location.getID() != existing.getID())) location.fadeOutAndDie();
    }
    if (this.douyuWorldDefeated()) { this.DouyuWorldLocationID = 0; return false; }
    if (existing != null) return true;
    local tile = this.chooseDouyuWorldTile();
    if (tile == null) {
        this.set("douyu_world_notice", "梦潮祭场的方位暂未查明。可以重新读取旅程后再查地点情报。" );
        ::logWarning("[AfeixExpedition] No reachable Douyu location tile within the bounded search.");
        return false;
    }
    local location = null;
    try {
        location = ::World.spawnLocation("scripts/entity/world/locations/afeix_douyu_location", tile.Coords);
        if (location == null) throw "native location creation refused";
        location.setFaction(::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());
        location.onSpawned();
        this.DouyuWorldLocationID = location.getID();
        this.set("douyu_world_generated", true);
        this.set("douyu_world_notice", "");
        return true;
    } catch (error) {
        // Native location.onFinish releases occupancy and manager membership.
        if (location == null) location = this.findDouyuWorldLocation();
        if (location != null) location.fadeOutAndDie();
        this.DouyuWorldLocationID = 0;
        this.set("douyu_world_notice", "梦潮祭场的方位暂未查明。可以重新读取旅程后再查地点情报。" );
        ::logError("[AfeixExpedition] Douyu location creation failed: " + error);
        return false;
    }
};
A.douyuWorldIntel <- function() {
    local location = this.findDouyuWorldLocation();
    if (location == null) return this.get("douyu_world_notice", "地图上还没有梦潮祭场的情报。稍后再查看黑旗名册。");
    local nearest = null, distance = 9000;
    foreach (town in ::World.EntityManager.getSettlements()) {
        local d = location.getTile().getDistanceTo(town.getTile());
        if (d < distance) { distance = d; nearest = town; }
    }
    if (nearest == null) return "梦潮祭场坐落在远离城镇的荒野。";
    local p = location.getTile().SquareCoords, q = nearest.getTile().SquareCoords;
    local direction = p.X > q.X ? "东" : p.X < q.X ? "西" : "";
    direction += p.Y > q.Y ? "北" : p.Y < q.Y ? "南" : "";
    if (direction == "") direction = "附近";
    return "梦潮祭场位于「" + nearest.getName() + "」的" + direction + "方荒野。";
};
A.queueDouyuMapFocus <- function() {
    if (!this.isOrigin() || this.isDreamCombat() || this.douyuWorldDefeated()) return false;
    this.DouyuMapFocusQueued = true;
    return true;
};
A.updateDouyuWorld <- function() {
    if (!this.isOrigin() || this.isDreamCombat() || ::World.State == null || ::Tactical.isActive()) return;
    if (this.DouyuMapFocusQueued && !::World.Events.hasActiveEvent()) {
        local state = ::World.State;
        if (state.m.LastEnteredTown != null && state.m.WorldTownScreen != null && state.m.WorldTownScreen.isVisible()
            && !state.m.WorldTownScreen.isAnimating() && state.m.MenuStack.isAllowingCancel()) {
            state.town_screen_main_dialog_module_onLeaveButtonClicked();
            return;
        }
    }
    if (!this.dreamWorldReady()) return;
    this.ensureDouyuWorldLocation();
    if (!this.DouyuMapFocusQueued) return;
    this.DouyuMapFocusQueued = false;
    local location = this.findDouyuWorldLocation();
    if (location == null || this.douyuWorldDefeated()) return;
    location.setDiscovered(true);
    ::World.uncoverFogOfWar(location.getTile().Pos, 500.0);
    ::World.getCamera().setPos(location.getPos());
    ::World.State.setPause(true);
};
A.douyuLocationCombatProperties <- function(p) {
    if (p == null || this.isDreamCombat()) return p;
    foreach (party in p.Parties) {
        if (!party.isLocation() || party.getTypeID() != this.DouyuWorldType) continue;
        p.CombatID = "afeix_douyu_final";
        p.TerrainTemplate = "tactical.swamp";
        p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
        p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Line;
        p.IsFleeingProhibited = false;
        return p;
    }
    return p;
};
