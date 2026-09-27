local passed = 0;
local check = function(value, message) { if (!value) throw message; passed++; };
local flags = {}, members = [], origin = true, safe = true, money = 100, current = null, towns = [];
::Math <- { function max(a, b) { return a > b ? a : b; } };
::Const <- { World = { TerrainTypeNavCost = [] } };
::Time <- { function getVirtualTimeF() { return 0.0; } };
::World <- {
    Flags = {
        function has(key) { return key in flags; },
        function get(key) { return flags[key]; },
        function set(key, value) { flags[key] <- value; }
    },
    Assets = {
        function getOrigin() { return { function getID() { return origin ? "scenario.afeix_expedition" : "scenario.other"; } }; },
        function addMoney(amount) { money += amount; }
    },
    EntityManager = { function getSettlements() { return towns; } },
    function getPlayerRoster() { return { function getAll() { return members; } }; },
    function getEntityByID(id) { foreach (town in towns) if (town.getID() == id) return town; return null; },
    function uncoverFogOfWar(pos, radius) {},
    function getNavigator() { return {
        function createSettings() { return { ActionPointCosts = null, RoadMult = 1.0, RoadOnly = false }; },
        function findPath(from, to, settings, unused) { return {
            function isEmpty() { return to.route <= 0; },
            function getSize() { return to.route; }
        }; }
    }; }
};
::AfeixExpedition <- { CombatMax = 10, RosterMax = 40, Schema = 2 };
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/formation.nut");
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/quests.nut");
local A = ::AfeixExpedition;
A.isCharacterKnown <- function(key) { return this.get("met_" + key, false); };
A.canManage = function() { return safe && this.isOrigin(); };
A.currentTown = function() { return current; };
A.refreshAssets = function() {};
local bro = function(id, place) { return {
    p = place, equipment = "same-sword", xp = 123, wound = true,
    function getID() { return id; },
    function getPlaceInFormation() { return this.p; },
    function setPlaceInFormation(value) { this.p = value; }
}; };
for (local i = 0; i < 20; i++) members.push(bro(i + 1, i < 12 ? i : 18 + i - 12));
A.enforceFormation();
check(A.deployedIds().len() == 10, "old twelve-person formation must become ten");
local first = members[0];
check(A.applyFormation([1]).ok, "one member may deploy with nineteen reserves");
check(A.deployedIds().len() == 1, "manual short formation is preserved");
local board = A.formation(), seen = {};
foreach (member in board) if (member != null) { check(!(member.getID() in seen), "no duplicate board entity"); seen[member.getID()] <- true; }
check(seen.len() == 20 && board.len() == 38, "all twenty retained across enlarged reserve board");
check(members[19].getPlaceInFormation() == 36, "reserve placement extends past native 26");
check(members[0] == first && first.xp == 123 && first.wound && first.equipment == "same-sword", "switching keeps the same entity and history");
local before = members[0].getPlaceInFormation();
check(!A.applyFormation([]).ok && members[0].getPlaceInFormation() == before, "empty selection is atomic rejection");
check(!A.applyFormation([1,1]).ok, "duplicate selection rejected");
check(!A.applyFormation([999]).ok, "departed actor ID rejected");
check(!A.applyFormation([1,2,3,4,5,6,7,8,9,10,11]).ok, "eleven-person selection rejected");
check(A.deployedIds().len() == 1, "all rejected selections left formation intact");
safe = false;
check(!A.applyFormation([2,3]).ok && A.deployedIds()[0] == 1, "unsafe switch rejected");
safe = true;
check(A.applyFormation([2,3]).ok, "captain is allowed to wait in reserve");
check(members[0].getPlaceInFormation() >= 18, "no mandatory protagonist seat");
members[1].setPlaceInFormation(4); members[2].setPlaceInFormation(4);
A.enforceFormation();
check(members[1].getPlaceInFormation() != members[2].getPlaceInFormation(), "overlapping active slots repaired");
members[19].setPlaceInFormation(255); A.enforceFormation();
check(A.deployedIds().len() == 3, "new unplaced recruit joins when space is free");
origin = false;
members[0].setPlaceInFormation(255); A.enforceFormation();
check(members[0].getPlaceInFormation() == 255, "other origins remain unchanged");
origin = true;
members[0].setPlaceInFormation(18);
for (local count = 1; count <= 10; count++) {
    local chosen = [];
    for (local i = 20 - count; i < 20; i++) chosen.push(i + 1);
    check(A.applyFormation(chosen).ok, "every legal squad size applies");
    A.enforceFormation();
    check(A.deployedIds().len() == count, "normalization never fills explicit reserves");
    local slots = {};
    foreach (b in members) {
        check(!(b.getPlaceInFormation() in slots), "every member has unique formation position");
        slots[b.getPlaceInFormation()] <- true;
    }
}
// Native serialization owns each PlaceInFormation and flag container. Recreating the
// module must not reset them; this tests reload semantics, not the engine save format.
local preserved = members[19].getPlaceInFormation();
dofile("src/scripts/mods/afeix/formation.nut");
check(members[19].getPlaceInFormation() == preserved, "loading module does not reassign saved positions");

local town = function(id, name, route, allied = true, alive = true) { return {
    friendly = allied, living = alive,
    function getID() { return id; }, function getNameOnly() { return name; },
    function isMilitary() { return false; }, function isAlive() { return this.living; },
    function isAlliedWithPlayer() { return this.friendly; }, function isConnectedToByRoads(other) { return true; },
    function getTile() { return { route = route, Pos = {}, SquareCoords = { X = id, Y = id + 1 } }; }
}; };
local home = town(11, "Home", 0), far = town(12, "Far", 50), near = town(13, "Near", 10);
local hostile = town(14, "Hostile", 1, false), isolated = town(15, "Island", 0);
towns = [home, far, hostile, isolated, near]; current = home;
check(A.findDeliveryTown(home) == near, "nearest reachable friendly route selected");
check(!A.isRecruitUnlocked("shuaizi") && !A.isRecruitUnlocked("bottle"), "neither recruit available before task");
check(A.findDeliveryRoute(home).tiles == 10, "route records actual road length");
towns = [home, far, hostile, isolated];
check(A.findDeliveryTown(home) == far, "remote road-connected destination allowed when it is the nearest");
local edge = town(16, "Boundary", 30), beyond = town(17, "Too far", 31);
towns = [home, beyond]; check(A.findDeliveryTown(home) == beyond, "no hard cap at 30 road tiles");
towns.push(edge); check(A.findDeliveryTown(home) == edge, "30 road tiles allowed");
flags.clear(); A.set("delivery_state", 1); A.migrateProgress(); A.migrateProgress();
check(A.get("delivery_state") == 3 && A.get("legacy_letter_retired",false), "legacy pending letter retires without travel requirement");
check(money == 100 && A.progressCount() == 0, "migration neither pays nor grants completion");
check(!A.recordContract(2, true, 200), "cancelled contract does not unlock recruits");
check(!A.recordContract(2, false, 0), "zero-pay contract does not unlock recruits");
origin = false; check(!A.recordContract(2, false, 200), "other origin contract untouched"); origin = true;
check(A.recordContract(2, false, 200), "normal paid contract provides fallback");
check(!A.recordContract(2, false, 200) && A.get("paid_contracts") == 1, "same native contract counted once");
check(!A.isRecruitUnlocked("shuaizi") && !A.isRecruitUnlocked("bottle"), "paid work alone does not grant invitations");
check(money == 100, "contract accounting never manufactures extra payment");
flags.clear(); A.set("delivery_state", 2);
check(A.progressCount() == 1, "v01 completed letter receives one migration credit");
A.migrateProgress(); A.migrateProgress();
check(A.progressCount() == 1 && A.get("schema") == 2, "migration preserves previous completed journeys exactly once");
foreach (state in [0,1,3]) {
    flags.clear(); A.set("delivery_state", state); A.migrateProgress();
    check(A.progressCount() == 0, "v01 pending or cancelled jobs give no migration credit");
}
flags.clear(); A.set("met_bottle",true);
check(!A.isRecruitUnlocked("bottle"), "meeting alone still needs personal conversation");
A.set("encounter_done_bottle",true);
check(A.isRecruitUnlocked("bottle"), "completed conversation preserves invitation independent of work count");
check(A.questSummary().find("章")==null && A.questSummary().find("六根")==null, "quest text contains neither chapters nor hidden plots");
print("TESTS_PASSED=" + passed + "\n");
