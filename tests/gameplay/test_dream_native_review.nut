// Extra native-contract regressions: loading callbacks remain asynchronous,
// failed state allocation restores a visible, retryable campaign, and the
// shipped swamp map supports the ordinary 18 formation positions and exits.
dofile("tests/gameplay/test_dream_flow.nut");
local baseline = ::checks;
::nativeDreamReview <- { worldVisible = true, listener = null, adds = 0, exits = 0, placements = [], grid = [] };
local allocate = ::RootState.add;
::RootState.add = function(name, path) {
    ++::nativeDreamReview.adds;
    local t = allocate.bindenv(this)(name, path);
    // RootState.add invokes tactical onInitUI, whose final native method
    // replaces the global loading-screen listener. Keep that boundary real.
    t.initLoadingScreenHandler();
    t.sendMessageToSiblings <- function(message) {
        if (message == "AboutToFinish") {
            ++::nativeDreamReview.exits;
            ::World.State.onSiblingSentMessage("TacticalFromWorldState", message);
        }
    };
    return t;
};
::LoadingScreen.show = function() { ++this.shown; this.visible = true; };
::LoadingScreen.setOnScreenShownListener = function(callback) { ::nativeDreamReview.listener = callback; };
::LoadingScreen.clearEventListener = function() { ::nativeDreamReview.listener = null; };
function reviewReset() {
    resetDream();
    ::nativeDreamReview.worldVisible = true;
    ::nativeDreamReview.adds = 0;
    ::nativeDreamReview.exits = 0;
    ::World.State.isVisible <- function() { return ::nativeDreamReview.worldVisible; };
    ::World.State.show = function() { ::nativeDreamReview.worldVisible = true; ::LoadingScreen.hide(); };
    ::World.State.hide <- function() { ::nativeDreamReview.worldVisible = false; };
    ::World.State.initLoadingScreenHandler();
    ::AfeixExpedition.initializeDreamOpening();
}
function completeLoading() {
    check(::LoadingScreen.isVisible() && ::nativeDreamReview.listener != null, "native onShown is pending");
    local callback = ::nativeDreamReview.listener;
    callback();
}
function assertReadyAgain(label, expectedSeed = 0) {
    assertReality(label);
    check(::Time.getVirtualTimeF() == 43210.0, label + " restores virtual world clock");
    check(::World.State.m.CombatStartTime == 0 && ::World.State.m.CombatProperties == null, label + " clears pending combat");
    check(::World.State.m.CombatSeed == expectedSeed, label + " restores prior combat seed");
    check(!::LoadingScreen.isVisible() && ::nativeDreamReview.worldVisible, label + " restores visible campaign");
    check(::AfeixExpedition.dreamWorldReady(), label + " permits retry or skip");
}

reviewReset();
check(::AfeixExpedition.startDreamCombat(0), "first invisible native launch is accepted");
check(::nativeDreamReview.adds == 0 && ::Tactical.State == null, "tactical allocation waits for native loading callback");
completeLoading();
check(::nativeDreamReview.adds == 1 && ::nativeDreamReview.exits == 0 && ::AfeixExpedition.isDreamCombat(), "onShown allocates one battle without premature AboutToFinish");
check(::Time.getVirtualTimeF() == 0 && ::Stash.isLocked(), "native second phase owns clock and stash lock");
::LoadingScreen.hide(); // The native tactical UI hides this after map init.
::Tactical.Entities.result = ::Const.Tactical.CombatResult.EnemyDestroyed;
::Tactical.State.onBattleEnded();
completeLoading();
check(::nativeDreamReview.exits == 1, "native tactical onShown performs exactly one return");
assertReadyAgain("successful asynchronous stage");

reviewReset();
::World.State.m.CombatSeed = 24680;
::dreamTest.failLaunch = true;
check(::AfeixExpedition.startDreamCombat(0), "asynchronous launch request precedes engine failure");
completeLoading();
assertReadyAgain("failed asynchronous allocation", 24680);
check(::AfeixExpedition.dreamStatus() == "pending" && ::AfeixExpedition.DreamOpeningQueued, "async failure keeps the pending stage");
::dreamTest.failLaunch = false;
check(::AfeixExpedition.startDreamCombat(0), "failed native allocation is retryable");
completeLoading();
::LoadingScreen.hide();
::Tactical.State.flee();
::dreamTest.virtualTime += 1.5; ::Tactical.State.onUpdate();
completeLoading();
assertReadyAgain("retry then retreat", 24680);

reviewReset();
::dreamTest.failBuild = true;
check(!::AfeixExpedition.startDreamCombat(0), "synchronous construction failure is rejected");
assertReadyAgain("failed construction");
check(::nativeDreamReview.adds == 0, "construction failure never creates a tactical state");

// Execute shipped map, patch, tile and formation methods. Drawing primitives,
// tile objects and navigation are explicit engine boundaries, not map metadata.
::Const.Tactical.CombatResult.None <- 0;
dofile(".cache/afei-art/dream-native/tactical_entity_manager.nut");
local manager = clone ::tactical_entity_manager; manager.setdelegate(getroottable());
::nativeDreamReview.randomSeed <- 24680;
::Math.rand = function(low = 0, high = 2147483647) {
    ::nativeDreamReview.randomSeed = (::nativeDreamReview.randomSeed * 251 + 67) % 65521;
    return low + ::nativeDreamReview.randomSeed % (high-low+1);
};
::Math.min <- function(a,b) { return a < b ? a : b; };
::Math.max <- function(a,b) { return a > b ? a : b; };
::Math.abs <- function(a) { return a < 0 ? -a : a; };
::createColor <- function(value) { return value; };
::createTileTransition <- function() { return { setBlendIntoSockets=function(v){}, setBrush=function(...){}, setSocket=function(v){} }; };
::Const.Direction <- {N=0,NE=1,SE=2,S=3,SW=4,NW=5};
::Const.Tactical.TerrainType <- {RoughGround=1,FlatGround=2,Swamp=3};
::Const.Tactical.TerrainSubtype <- {MoistEarth=1,PlashyGrass=2,MurkyWater=3};
::Const.Tactical.TileBlendPriority <- {Swamp1=1,Swamp2=2,Swamp3=3,Swamp4=4,Swamp5=5};
dofile(".cache/afei-art/dream-native/map_template.nut");
local priorInherit = ::inherit;
::inherit = function(path, object) {
    local parent = path == "scripts/mapgen/map_template" ? ::map_template : ::tactical_template;
    local result = clone parent; result.m = clone parent.m;
    foreach (key,value in object) if (key != "m") result[key] <- value;
    foreach (key,value in object.m) result.m[key] <- value;
    result.setdelegate(getroottable());
    return result;
};
dofile(".cache/afei-art/dream-native/tactical_template.nut");
::nativeDreamReview.templates <- {};
::MapGen <- {get=function(name){return ::nativeDreamReview.templates[name];}};
::Tactical.setTransitions <- function(...) {};
::Tactical.isValidTileSquare <- function(x,y) { return x>=0 && y>=0 && x<32 && y<32; };
function nextReviewTile(tile,direction) {
    local x=tile.Coords.X, r=tile.Coords.Y-x/2;
    local q=x;
    switch(direction) {case 0:--r;break;case 1:++q;--r;break;case 2:++q;break;case 3:++r;break;case 4:--q;++r;break;case 5:--q;break;}
    local y=r+q/2;
    return ::Tactical.isValidTileSquare(q,y) ? ::nativeDreamReview.grid[q][y] : null;
}
local grid = ::nativeDreamReview.grid;
for (local x = 0; x < 32; ++x) {
    local column = [];
    for (local y = 0; y < 32; ++y) column.push({
        Level = 0, Type = 0, Subtype = 0, BlendPriority = 0, IsEmpty = true, IsHidingEntity = false, IsBadTerrain = false,
        Coords = {X=x,Y=y}, SquareCoords = {X=x,Y=y},
        setBrush=function(brush){},
        spawnDetail = function(...) { return {Color=null}; },
        spawnObject = function(...) { this.IsEmpty = false; return {setFlipped=function(v){}}; },
        clear = function() { this.IsEmpty = true; this.IsHidingEntity = false; },
        removeObject = function() { this.IsEmpty = true; },
        hasNextTile = function(direction) { return nextReviewTile(this,direction) != null; },
        getNextTile = function(direction) { return nextReviewTile(this,direction); }
    });
    grid.push(column);
}
::Tactical.getTileSquare <- function(x,y) {
    check(x >= 0 && y >= 0 && x < 32 && y < 32, "native swamp tile is in bounds");
    return ::nativeDreamReview.grid[x][y];
};
::Tactical.getTile <- function(x,y) { return this.getTileSquare(x,y+x/2); };
::Tactical.getMapSize <- function() { return {X=32,Y=32}; };
::Tactical.addEntityToMap <- function(actor,x,y) {
    ::nativeDreamReview.placements.push({actor=actor,x=x,y=y});
    check(x >= 2 && x <= 29 && y >= 2 && y <= 29, "ordinary formation stays inside swamp map bounds");
};
foreach (name in ["swamp1","swamp2","swamp3","swamp4","swamp5","patch_swamp","patch_swamp_pond","tactical_swamp"]) {
    dofile(".cache/afei-art/dream-native/" + name + ".nut");
    local template=getroottable()[name]; template.init();
    ::nativeDreamReview.templates[template.getName()] <- template;
}
::inherit = priorInherit;
local swamp=::nativeDreamReview.templates["tactical.swamp"];
check(swamp.getMinX()==32 && swamp.getMinY()==32, "shipped swamp dimensions are 32 by 32");
swamp.fill({X=0,Y=0,W=32,H=32}, {Tile=null}, 1);
foreach (column in grid) foreach(tile in column)
    check(tile.Level==0 && tile.Type!=0, "actual swamp map and patches create terrain without a closed height ring");
local players=[];
for(local place=0; place<18; ++place) players.push({place=place,getPlaceInFormation=function(){return this.place;}});
::Const.SameMovementAPCost <- [];
::Const.PathfinderMovementFatigueCost <- [];
// Native navigator is implemented by the engine; the map and the actual
// isTileIsolated method are exercised with a successful path result here.
::Tactical.getNavigator <- function() { return {createSettings=function(){return {ActionPointCosts=null,FatigueCosts=null,AllowZoneOfControlPassing=false,AlliedFactions=null};},findPath=function(...){return true;}}; };
manager.placePlayersInFormation(players);
check(::nativeDreamReview.placements.len() == 18, "all native ordinary seats fit in the chosen map");
foreach (placement in ::nativeDreamReview.placements)
    check(grid[placement.x][placement.y].IsEmpty, "ordinary player seat is clear after native swamp generation");

// Run native enemy formation and setup too; troop metadata is read during
// tactical UI initialization, after the loading-screen callback has returned.
::Const.FactionType.Barbarians <- 5;
::Const.FactionType.OrientalBandits <- 6;
::World.FactionManager.isAlliedWithPlayer <- function(faction){return false;};
::World.getTime <- function(){return {IsDaytime=true};};
::nativeDreamReview.enemies <- [];
::Tactical.spawnEntity <- function(script,x,y){
    local tile=::Tactical.getTileSquare(x,y);
    check(tile.IsEmpty,"native enemy placement selects an empty tile");
    tile.IsEmpty=false;
    local actor={script=script,tile=tile,troop=null,faction=0,equipped=false,m={IsGeneratingKillName=true},
        setWorldTroop=function(troop){this.troop=troop;},setFaction=function(faction){this.faction=faction;},
        assignRandomEquipment=function(){this.equipped=true;}};
    ::nativeDreamReview.enemies.push(actor);
    return actor;
};
for(local stage=0;stage<4;++stage){
    ::nativeDreamReview.enemies=[];
    local properties=::AfeixExpedition.dreamCombatProperties(stage,true);
    manager.spawnEntitiesInFormation(properties.Entities,1);
    check(::nativeDreamReview.enemies.len()==::AfeixExpedition.DreamStages[stage].count,"native enemy wave fully deploys stage "+stage);
    foreach(i,enemy in ::nativeDreamReview.enemies){
        check(enemy.script==properties.Entities[i].Script&&enemy.troop==properties.Entities[i]&&enemy.faction==8&&enemy.equipped,"native troop setup keeps script faction metadata and equipment");
        enemy.tile.IsEmpty=true;
    }
}

print("NATIVE_REVIEW_PASSED=" + (::checks-baseline) + "\n");
print("TESTS_PASSED=" + (::checks-baseline) + "\n");
