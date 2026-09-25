// Run from src/: sq.exe ../tools/check_growth.nut
::include <- function(path) { return ::loadfile(path + ".nut")(); };
::Math <- { max = function(a,b) { return a>b?a:b; } };
local worldFlags = {};
::World <- { Flags = {
    has = function(k) { return k in worldFlags; },
    get = function(k) { return worldFlags[k]; },
    set = function(k,v) { worldFlags[k] <- v; }
} };
::AfeiExpedition <- { Schema = 4 };
::AfeiExpedition.setdelegate(getroottable());
::include("scripts/mods/afei/definitions");
::include("scripts/mods/afei/core");
::include("scripts/mods/afei/world");
::include("scripts/mods/afei/growth");
local A = ::AfeiExpedition;
local seen = 0;
foreach (id, data in A.Characters) {
    if (!(id in A.GrowthRoads)) throw "MISSING_GROWTH_ROAD_" + id;
    local flags = { afei_named_id = id };
    local brother = { level = 1,
        getLevel = function() { return this.level; },
        getFlags = function() { return { has = function(k) { return k in flags; }, get = function(k) { return flags[k]; } }; }
    };
    if (A.growthCond(id, brother)) throw "GROWTH_TOO_EARLY_" + id;
    local before = A.growthProgress(brother);
    if (before.find("还欠下这些经历") == null || before.len() > 320 || before.find("G0") != null || before.find("G1") != null || before.find("G2") != null) throw "BAD_PENDING_NOTE_" + id;
    brother.level = 11;
    foreach (step in A.GrowthRoads[id]) {
        local path = "either" in step ? step.either[0] : step;
        if (path.key == "_level") continue;
        if (path.key == "_jiahao") worldFlags.afei_jiahao_count <- path.n;
        else if (path.key == "_m06") worldFlags.afei_m06_done <- true;
        else if (path.key == "_other_contracts") flags.afei_contracts <- path.n;
        else flags["afei_" + path.key] <- path.n;
    }
    if (!A.growthCond(id, brother)) throw "GROWTH_NEVER_READY_" + id;
    local ready = A.growthProgress(brother);
    if (ready.find("该走的路都走过了") == null) throw "BAD_READY_NOTE_" + id;
    worldFlags.clear();
    seen++;
}
if (seen != 32 || "C11" in A.Characters || !("C32" in A.Characters) || !("C33" in A.Characters) || !("C34" in A.Characters)) throw "BAD_GROWTH_COUNT_" + seen;
print("GROWTH_ROADS_OK " + seen + "\n");
worldFlags.afei_recruit_ready_C04 <- true;
worldFlags.afei_cohesion <- 0;
if (!A.eligible("C04")) throw "COMPLETED_INVITATION_LOST";
worldFlags.afei_ever_C04 <- true;
if (A.eligible("C04")) throw "RECRUIT_DUPLICATE_ALLOWED";
print("INVITATION_STAYS_READY_OK\n");
