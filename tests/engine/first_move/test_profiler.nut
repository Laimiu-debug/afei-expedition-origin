::checks <- 0;
function check(value, label) { if (!value) throw "FAIL " + label; ::checks++; }
::testState <- { exact = 0.0, real = 0.0, origin = true, messages = [] };
::Time <- {
    getExactTime = function() { return ::testState.exact; },
    getRealTimeF = function() { return ::testState.real; }
};
::logInfo <- function(message) { ::testState.messages.push(message); };
::AfeixExpedition <- { isOrigin = function() { return ::testState.origin; } };
::BBMODMapLabels <- {
    collect = function(state) { ::testState.exact += 60; return state; },
    regionAngles = function(regions) { return regions; }, sameFrame = function(frame) { return true; }
};
::hooks <- { exact = {}, instance = {} };
::mods_registerMod <- function(...) {};
::mods_queue <- function(id, dependencies, callback) { callback(); };
::mods_hookExactClass <- function(path, callback) { ::hooks.exact[path] <- callback; };
::mods_hookNewObject <- function(path, callback) { ::hooks.instance[path] <- callback; };
::include <- function(path) { dofile("tests/engine/first_move/src/" + path + ".nut"); };
foreach (key in ["syncIdeasCharacter", "hasIdea", "nextDiscovery", "ensureTownRecruit", "findDeliveryRoute"])
    ::AfeixExpedition[key] <- function(...) { return 23; };
dofile("tests/engine/first_move/src/scripts/!mods_preload/mod_afeix_first_move_diagnostic.nut");
local P = ::AfeixFirstMove;
check(::hooks.instance.len() == 7, "all seven native manager registrations present");
local object = { value = 8 };
local callback = function(number) { ::testState.exact += 40; return this.value + number; }.bindenv({ value = 99 });
check(P.measure("outside", callback, object, [object, 2]) == 10, "native environment and return preserved before capture");
check(P.Rows.len() == 0, "no timings collected outside capture");
P.reset("test"); check(P.Armed && !P.Active, "reset waits for user movement");
check(P.begin("test") && !P.Armed && P.Active, "single capture starts");
check(!P.begin("duplicate"), "cannot start capture twice");
check(P.measure("work", callback, object, [object, 3]) == 11, "captured callback gets live environment and arguments");
P.measure("work", callback, object, [object, 3]);
check(P.Rows.work.calls == 2 && P.Rows.work.total == 80 && P.Rows.work.maximum == 40, "raw exact ticks aggregated");
local fail = function() { ::testState.exact += 100; throw "native_failure"; };
local threw = false;
try { P.measure("failure", fail, object, [object]); } catch (error) { threw = error == "native_failure"; }
check(threw && P.Rows.failure.errors == 1 && P.Rows.failure.maximum == 100, "native exceptions measured and rethrown unchanged");
local generator = function() { yield false; return true; };
local produced = P.measure("generator", generator, object, [object]);
check(typeof produced == "generator" && (resume produced) == false && (resume produced) == true, "generator execution is not consumed by profiling");
::testState.real = 13.0;
local world = {
    m = { AutoAttack = null, AutoEnterLocation = null, MenuStack = { hasBacksteps = function() { return false; } } },
    player = { m = { Destination = null, Path = null } }, paused = true,
    getPlayer = function() { return this.player; }, isPaused = function() { return this.paused; },
    isInLoadingScreen = function() { return false; }, isInCameraMovementMode = function() { return false; },
    startNewCampaign = function() { return 71; }, onDeserialize = function(input) { return input; },
    onMouseInput = function(mouse) { this.player.m.Path = {}; this.paused = false; ::testState.exact += 500; return 13; },
    onUpdate = function() { ::testState.exact += 80; return 19; }, onHide = function() { return 21; },
    onProcessInThread = function() { return 12; }, onRender = function() { return 17; }, updateCursorAndTooltip = function() {},
    updateDayTime = function() {}, getSurroundingAmbienceSounds = function() { return []; },
    getSurroundingLocationSounds = function() { return []; }
};
P.frame(world);
check(!P.Active && !P.Armed && P.Frames == 1 && P.MaxFrameGap == 13, "capture ends after real time budget and records frame gap");
check(P.measure("after", callback, object, [object, 0]) == 8 && !("after" in P.Rows), "finished capture stops timing");
::hooks.exact["states/world_state"](world);
check(world.startNewCampaign() == 71 && P.Armed && P.Rows.len() == 0, "new campaign resets runtime diagnostics only");
check(world.onUpdate() == 19 && !P.Active, "paused world does not start capture");
local mouse = { getState = function() { return 1; } };
check(world.onMouseInput(mouse) == 13 && P.Active, "first movement click starts capture after native input");
check(P.Rows["mouse.input"].calls == 1 && P.Rows["mouse.input"].maximum == 500, "initial synchronous click cost retained");
check(world.onUpdate() == 19 && P.Rows["world.onUpdate"].maximum == 80, "native world update preserved and timed");
check(::BBMODMapLabels.collect(world) == world && P.Rows["bbmod.labels_collect"].maximum == 60, "installed label bridge preserves result and gets independent timing");
foreach (path, hook in ::hooks.instance) {
    local manager = { value = path, update = function(...) { ::testState.exact += 7; return this.value; } };
    hook(manager);
    check(manager.update(true, 3) == path, "native manager environment and varargs preserved: " + path);
}
foreach (name in ["entities.update", "factions.update", "combat.update", "contracts.update", "events.update", "ambitions.update", "assets.update"])
    check(name in P.Rows && P.Rows[name].calls == 1, "manager label independently captured: " + name);
check(world.onHide() == 21 && !P.Active, "world exit flushes capture without changing native result");
check(world.onDeserialize(31) == 31 && P.Armed, "loading resets capture without modifying native save input");
::testState.origin = false; world.paused = false;
check(world.onUpdate() == 19 && !P.Active, "other origins do not start capture");
::testState.origin = true;
check(world.onUpdate() == 19 && P.Active, "keyboard unpause starts capture before native update");
P.finish("test");
local oldClock = ::Time.getExactTime;
::Time.getExactTime = function() { throw "clock_unavailable"; };
P.reset("missing_clock");
check(!P.begin("test") && P.Disabled && !P.Active && !P.Armed, "missing exact clock fails open");
check(world.onUpdate() == 19, "native frame still runs with diagnostics disabled");
::Time.getExactTime = oldClock;
print("TESTS_PASSED=" + ::checks + "\n");
