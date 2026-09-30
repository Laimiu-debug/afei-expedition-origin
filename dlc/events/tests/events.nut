// Native event state/input, manager selection/save and town presentation are
// executed verbatim. Engine rendering/timers are simulated, not an in-game test.
dofile("base_version.nut");
local checks = 0;
function expect(value, message) { if (!value) throw "FAIL " + message; checks++; }
::test <- { now = 10000.0, day = 10, origin = true, combat = false, safe = true, moving = true,
    camping = false, characterScreen = false, money = 100, alive = true, dying = false,
    ledgerCalls = 0, refreshed = 0, visits = 0, scheduled = [], logs = [], flags = {}, rolls = [], hookCalls = 0 };
::Time <- { getVirtualTimeF = function() { return ::test.now; },
    scheduleEvent = function(unit, delay, callback, tag) { ::test.scheduled.push([callback, tag]); } };
::TimeUnit <- { Real = 0 };
::Math <- { min = function(a, b) { return a < b ? a : b; }, max = function(a, b) { return a > b ? a : b; },
    rand = function(low, high) { if (::test.rolls.len() == 0) return low; return ::test.rolls.remove(0); } };
::Tactical <- { State = null, isActive = function() { return ::test.combat; } };
::LoadingScreen <- null;
::Const <- { Events = { GlobalSound = "" }, UI = { Cursor = { Hand = 0 } } };
::Cursor <- { setCursor = function(value) {} };
::logError <- function(message) { ::test.logs.push(message); };
::logInfo <- function(message) {};
::World <- { Assets = { isCamping = function() { return ::test.camping; } },
    getTime = function() { return { Days = ::test.day, SecondsPerDay = 100.0 }; },
    getAllEntitiesAtPos = function(pos, radius) { return []; },
    getSpeedMult = function() { return 1; }, Statistics = { isNewsReady = function() { return false; } } };
::town <- { getID = function() { return 77; } };
::actor <- { isAlive = function() { return ::test.alive; }, isDying = function() { return ::test.dying; } };
::AfeixExpedition <- { Version = ::TestBaseInternal,
    get = function(key, fallback = 0) { return key in ::test.flags ? ::test.flags[key] : fallback; },
    set = function(key, value) { ::test.flags[key] <- value; return value; },
    isOrigin = function() { return ::test.origin; },
    ideaSafe = function() { return ::test.origin && !::test.combat && ::test.safe && ::World.State != null; },
    worldNow = function() { return ::test.now; }, daysInSeconds = function(value) { return value * 100.0; },
    isWorldPartyMoving = function() { return ::test.moving; },
    currentTown = function() { return ::World.State.m.WorldTownScreen.visible ? ::town : null; },
    findCharacter = function(key) { return key == "afei" ? ::actor : null; },
    refreshAssets = function() { ::test.refreshed++; },
    visitTavern = function(town) { ::test.visits++; return true; },
    openLedger = function(page = "home", townID = 0) { ::test.ledgerCalls++; return "base_ledger"; } };
dofile("base_characters.nut");
::registered <- [];
::queued <- null;
::mods_registerMod <- function(id, version, name) { ::registered.push([id, version, name]); };
::mods_queue <- function(id, dependencies, callback) {
    expect(dependencies == "mod_afeix_expedition(>=54), >mod_afeix_expedition", "base dependency and order");
    ::queued = callback;
};
::include <- function(path) { dofile("src/" + path + ".nut"); };
::mods_hookExactClass <- function(path, callback) { ::test.hookCalls++; };
local originalLedger = ::AfeixExpedition.openLedger;
dofile("src/scripts/!mods_preload/mod_afeix_dlc_events.nut");
::queued();
local D = ::AfeixEventsDLC, A = ::AfeixExpedition;
expect(::registered.len() == 1 && ::registered[0][0] == D.ID, "standalone registration");
local authoredCount = D.Order.len();
expect(authoredCount == D.Scenes.len(), "production registration covers every authored scene");
if (authoredCount == 0) expect(::test.hookCalls == 0, "empty framework adds no tavern/UI hook");
local old = A.openLedger;
::queued();
expect(A.openLedger == old && D.Order.len() == authoredCount, "initialization is idempotent");
// Isolate framework behavior from future authored content; only the content audit
// enumerates shipping stories. Fixtures below never enter the runtime ZIP.
D.Scenes = {}; D.Order = []; A.openLedger = originalLedger;
if ("HooksInstalled" in D) delete D.HooksInstalled;

dofile("native/event.nut");
::event.setdelegate(getroottable());
::inherit <- function(path, child) {
    expect(path == "scripts/events/event", "uses native base event");
    local fields = clone ::event.m;
    foreach (key, value in child.m) fields[key] <- value;
    child.m = fields; child.event <- ::event; child.setdelegate(::event); return child;
};
dofile("src/scripts/events/events/afeix_dlc_events_event.nut");
local E = ::afeix_dlc_events_event;
E.create();
dofile("native/event_manager.nut");
local M = ::event_manager;
M.setdelegate(getroottable());
::World.Events <- M;
M.m.Events = [E];
dofile("native/ui.nut");
local menu = { stack = [], hasBacksteps = function() { return this.stack.len() > 0; },
    push = function(close, allowed = null) { this.stack.push(close); },
    pop = function() { local close = this.stack.remove(this.stack.len() - 1); close.bindenv(::World.State)(); } };
local tavernModule = { setTavern = function(building) {} };
local townScreen = { visible = false, animating = false, restored = 0, m = { LastActiveModule = tavernModule },
    getTavernDialogModule = function() { return tavernModule; }, isVisible = function() { return this.visible; },
    isAnimating = function() { return this.animating; }, hideAllDialogs = function() {},
    showLastActiveDialog = function() { this.restored++; },
    showTavernDialog = function() { this.m.LastActiveModule = tavernModule; } };
local eventScreen = { visible = false, animating = false,
    isVisible = function() { return this.visible; }, isAnimating = function() { return this.animating; },
    setIsContract = function(value) {}, show = function(event) { this.visible = true; }, hide = function() { this.visible = false; } };
local state = { m = { MenuStack = menu, WorldTownScreen = townScreen, EventScreen = eventScreen,
        WorldScreen = { hide = function() {}, show = function() {} } },
    showEventScreen = ::nativeUI.showEventScreen, showEventScreenFromTown = ::nativeUI.showEventScreenFromTown,
    getMenuStack = function() { return menu; }, getPlayer = function() { return { getPos = function() { return 0; } }; },
    isInCharacterScreen = function() { return ::test.characterScreen; },
    isPaused = function() { return true; }, setAutoPause = function(value) { ::test.moving = false; },
    updateTopbarAssets = function() {} };
state.setdelegate(getroottable());
::World.State <- state;
E.update(); expect(E.m.Score == 0, "empty runtime event has zero weight");
expect(!D.tryTavern(77) && ::test.flags.len() == 0, "empty pool consumes no attempts/flags");

function reset(inTown = false) {
    local s = ::test;
    s.flags = {}; s.origin = true; s.combat = false; s.safe = true; s.moving = !inTown; s.camping = false;
    s.characterScreen = false; s.money = 100; s.alive = true; s.dying = false; s.rolls = []; s.scheduled = [];
    ::Tactical.State = null; ::LoadingScreen = null;
    menu.stack.clear(); townScreen.visible = inTown; townScreen.animating = false; townScreen.m.LastActiveModule = tavernModule;
    eventScreen.visible = false; eventScreen.animating = false;
    M.m.ActiveEvent = null; M.m.IsEventShown = false; M.m.Thread = null; M.m.LastEventID = "";
    M.m.LastBattleTime = 0; E.clear(); E.m.CooldownUntil = 0;
    D.Checking = {}; D.ConditionFaults = {};
    if (inTown) menu.push(function() {});
}
function scene(id, place, once = false) {
    return { id = id, place = place, title = "Fixture " + id, text = "Test-only dialogue", once = once,
        members = ["afei"], choices = [{ text = "Pay", outcome = "Paid",
            canChoose = function(e) { return ::test.money >= 20; },
            apply = function(e) { ::test.money -= 20; } }, { text = "Leave", outcome = "Left" }] };
}
function rejected(s) { local failed = false; try { D.register(s); } catch (error) { failed = true; } return failed; }
D.register(scene("test_road", "road"));
D.register(scene("test_tavern", "tavern", true));
expect(rejected(scene("test_road", "road")), "duplicate IDs rejected");
expect(rejected(scene("BAD-ID", "road")), "unstable ID rejected");
expect(rejected(scene("test_bad", "camp")), "unsupported place rejected");
local bad = scene("bad_member", "road"); bad.members = ["unknown"];
expect(rejected(bad), "unknown members rejected");
bad = scene("bad_option", "road"); bad.choices[0].apply = 0;
expect(rejected(bad), "invalid callback rejected");
bad = scene("zero_cooldown", "road"); bad.cooldownDays <- 0;
expect(rejected(bad), "zero cooldown rejected");

::mods_hookExactClass = function(path, callback) { if (path == "states/world_state") callback(state); };
dofile("src/scripts/mods/afeix_dlc_events/hooks.nut");
local installedLedger = A.openLedger;
dofile("src/scripts/mods/afeix_dlc_events/hooks.nut");
expect(A.openLedger == installedLedger, "repeated hook include does not stack wrappers");
reset(); E.update();
expect(E.m.Score == 5 && D.pool("road").len() == 1, "tavern excluded from road pool");
::test.moving = false; E.update(); expect(E.m.Score == 0, "stationary road excluded");
reset(); ::test.camping = true; expect(D.pool("road").len() == 0, "camp excluded");
reset(); ::test.origin = false; expect(D.pool("road").len() == 0, "other origins excluded");
reset(); ::test.combat = true; expect(D.pool("road").len() == 0, "combat excluded");
reset(); ::test.safe = false; expect(D.pool("road").len() == 0, "hostile situation excluded");
reset(); ::Tactical.State = {}; expect(D.pool("road").len() == 0, "tactical transition excluded");
reset(); ::test.day = 2; expect(D.pool("road").len() == 0, "day prerequisite"); ::test.day = 10;
reset(); ::test.alive = false; expect(D.pool("road").len() == 0, "dead member excluded");
reset(); ::test.dying = true; expect(D.pool("road").len() == 0, "dying member excluded");
reset(); menu.push(function() {}); expect(D.pool("road").len() == 0, "menus exclude road events");

// Native world selection updates, revalidates, fires and pauses travel.
reset(); local generator = M.selectEvent(); while (resume generator == false) {}
expect(M.m.ActiveEvent == E && eventScreen.visible && E.m.Scene == "test_road", "native random selection reaches DLC screen");
expect(!::test.moving && D.get("next") > ::test.now, "display pauses travel and starts shared cooldown");
expect(D.get("cooldown_test_road") == ::test.now + D.days(8), "per-scene display cooldown");
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result" && ::test.money == 80, "native option succeeds despite paused movement");
local again = D.resolve(E, 0); expect(!again.ok && ::test.money == 80, "duplicate settlement cannot pay twice");
expect(!E.processInput(0), "result screen exits through native input");
menu.pop(); M.m.ActiveEvent = null; E.clear();
expect(!eventScreen.visible && !D.eligible("test_road", "road"), "native close clears UI; cooldown remains");
::test.now += D.days(8); ::test.moving = true;
expect(D.eligible("test_road", "road"), "individual cooldown expires");

reset(); expect(M.fire(D.EventID), "manual native test fire");
::test.money = 19; expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && ::test.money == 19, "unaffordable choice remains safe");
expect(E.processInput(1) && D.get("done_test_road", false), "retry allows another authored option");
reset(); M.fire(D.EventID); ::test.alive = false;
expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && ::test.money == 100, "departed/dead participant rechecked before payment");
expect(!E.processInput(2), "retry includes safe exit");
reset(); M.fire(D.EventID); D.set("active_token", E.m.Token + 1);
expect(!D.resolve(E, 0).ok && ::test.money == 100, "stale event token rejected");
reset(); M.fire(D.EventID); expect(!D.resolve(E, -1).ok && !D.resolve(E, 99).ok, "invalid choices rejected");

// Rejected UI display consumes no scene cooldown, even though native fire builds
// its opening screen before attempting presentation.
reset(); eventScreen.animating = true;
expect(!M.fire(D.EventID) && D.get("next") == 0 && M.m.ActiveEvent == null, "failed native road display has no cooldown");

// Exercise native tavern click wrapped by the current main-package timer hook.
local building = { onClicked = ::nativeTavern.onClicked, getSettlement = function() { return ::town; },
    pushUIMenuStack = function() {} };
::mods_hookExactClass = function(path, callback) { if (path == "entity/world/settlements/buildings/tavern_building") callback(building); };
::mods_hookNewObject <- function(...) {};
::mods_hookBaseClass <- function(...) {};
dofile("base_hooks.nut");
function clickTavern() {
    building.onClicked(townScreen);
    local job = ::test.scheduled.remove(0); job[0](job[1]);
}
reset(true); ::test.rolls = [100]; local calls = ::test.ledgerCalls;
clickTavern(); expect(::test.ledgerCalls == calls + 1 && M.m.ActiveEvent == null, "chance miss follows current base tavern callback");
expect(D.get("tavern_attempt_until") == ::test.now + D.days(1), "miss persists anti-spam attempt time");
::test.rolls = [1]; clickTavern(); expect(M.m.ActiveEvent == null && ::test.rolls.len() == 1, "reopening does not reroll attempt");
reset(true); ::test.rolls = [1, 1]; calls = ::test.ledgerCalls; local visits = ::test.visits;
clickTavern(); expect(M.m.ActiveEvent == E && E.m.Scene == "test_tavern" && ::test.ledgerCalls == calls, "chance hit replaces exactly one base encounter");
expect(::test.visits == visits + 1, "DLC tavern encounter preserves main exploration visit");
expect(menu.stack.len() == 2 && eventScreen.visible, "native town show pushes one event backstep");
expect(E.processInput(0) && ::test.money == 80 && D.get("done_test_tavern", false), "tavern choice settles once");
expect(!E.processInput(0), "native result exits tavern encounter");
local restored = townScreen.restored; menu.pop(); M.m.ActiveEvent = null; E.clear();
expect(menu.stack.len() == 1 && townScreen.visible && townScreen.restored == restored + 1, "native close restores original tavern dialog");
::test.now += D.days(9);
expect(!D.eligible("test_tavern", "tavern"), "one-time tavern scene remains completed after cooldown");
foreach (blocker in ["character", "animation", "other_dialog", "active_event", "loading", "selection"]) {
    reset(true);
    if (blocker == "character") ::test.characterScreen = true;
    if (blocker == "animation") eventScreen.animating = true;
    if (blocker == "other_dialog") townScreen.m.LastActiveModule = {};
    if (blocker == "active_event") M.m.ActiveEvent = {};
    if (blocker == "loading") ::LoadingScreen = { isVisible = function() { return true; }, isAnimating = function() { return false; } };
    if (blocker == "selection") M.m.Thread = {};
    expect(!D.tryTavern(77) && D.get("tavern_attempt_until") == 0, "unsafe tavern does not roll: " + blocker);
}
reset(true); expect(!D.tryTavern(88) && D.get("tavern_attempt_until") == 0, "stale town callback excluded");
reset(true); building.onClicked(townScreen); townScreen.visible = false;
local job = ::test.scheduled.remove(0); job[0](job[1]);
expect(M.m.ActiveEvent == null && D.get("tavern_attempt_until") == 0, "leaving tavern before delayed callback prevents event");
reset(true); local nativeShow = state.showEventScreenFromTown;
state.showEventScreenFromTown = function(event) { throw "fixture UI failure"; };
expect(!D.tryTavern(77) && M.m.ActiveEvent == null && !M.m.IsEventShown && D.get("next") == 0, "failed tavern UI clears manager and scene cooldown");
state.showEventScreenFromTown = nativeShow;

// Future authoring controls: custom prerequisite, either-context identity and
// callback failure/reentrancy guard. No fixture dialogue is packaged.
local extra = scene("test_either", "either"); extra.condition <- function() { return ::test.money >= 150; };
D.register(extra);
reset(); expect(!D.eligible("test_either", "road"), "custom prerequisite excludes event");
::test.money = 150; expect(D.eligible("test_either", "road"), "custom prerequisite admits event");
reset(true); ::test.money = 150; expect(D.eligible("test_either", "tavern"), "either event uses same ID at tavern");
reset(); local failing = D.Scenes.test_road.choices[0].apply, applied = 0;
D.Scenes.test_road.choices[0].apply = function(e) { applied++; ::test.money -= 1; throw "fixture settlement failure"; };
M.fire(D.EventID);
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result" && applied == 1, "callback failure offers exit rather than automatic retry");
expect(!D.resolve(E, 0).ok && applied == 1, "failed partial callback cannot run twice");
D.Scenes.test_road.choices[0].apply = function(e) { expect(!D.resolve(e, 0).ok, "reentrant option is rejected"); ::test.money -= 20; };
reset(); M.fire(D.EventID); E.processInput(0); expect(::test.money == 80, "reentrant guard preserves single payment");
D.Scenes.test_road.choices[0].apply = failing;

local checkChoice = D.Scenes.test_road.choices[0].canChoose;
D.Scenes.test_road.choices[0].canChoose = function(e) { return D.resolve(e, 0).ok; };
reset(); M.fire(D.EventID);
expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && ::test.money == 100, "recursive choice prerequisite cannot reenter settlement");
expect(!E.m.Resolving, "failed recursive choice releases settlement guard");
D.Scenes.test_road.choices[0].canChoose = function(e) { throw "fixture prerequisite failure"; };
reset(); M.fire(D.EventID);
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result" && ::test.money == 100, "throwing choice prerequisite exits without payment");
expect(!D.resolve(E, 0).ok && ::test.money == 100, "throwing prerequisite is not retried");
D.Scenes.test_road.choices[0].canChoose = checkChoice;

local conditionCalls = 0, conditionScene = scene("test_condition_throw", "road");
conditionScene.condition <- function() { conditionCalls++; throw "fixture condition failure"; };
D.register(conditionScene);
reset(); local logCount = ::test.logs.len();
for (local frame = 0; frame < 50; frame++) expect(!D.eligible("test_condition_throw", "road"), "bad condition excluded frame " + frame);
expect(conditionCalls == 1 && ::test.logs.len() == logCount + 1 && D.Checking.len() == 0, "bad condition is quarantined once; no per-frame failure/log loop");
local recursiveScene = scene("test_condition_recursive", "road");
recursiveScene.condition <- function() { D.pool("road"); return true; };
D.register(recursiveScene);
logCount = ::test.logs.len();
expect(!D.eligible("test_condition_recursive", "road"), "recursive candidate pool cannot admit the recursive scene");
expect(D.Checking.len() == 0 && ::test.logs.len() == logCount + 1, "recursive candidate guard returns with one error and no stale lock");
for (local frame = 0; frame < 20; frame++) D.pool("road");
expect(::test.logs.len() == logCount + 1, "recursive condition remains quarantined across repeated pool checks");
D.Scenes.test_condition_throw.condition = function() { return true; };
D.Scenes.test_condition_recursive.condition = function() { return true; };

// Native save format remains one F32 cooldown per event. Missing DLC events are
// consumed by the native manager on load without inventing a saved custom class.
reset(); local values = [], pos = 0;
local io = { writeF32 = function(v) { values.push(v); }, writeU32 = function(v) { values.push(v); },
    writeString = function(v) { values.push(v); }, writeBool = function(v) { values.push(v); },
    readF32 = function() { return values[pos++]; }, readU32 = function() { return values[pos++]; },
    readString = function() { return values[pos++]; }, readBool = function() { return values[pos++]; } };
E.m.CooldownUntil = 1234; M.onSerialize(io); E.m.CooldownUntil = 0;
M.onDeserialize(io); expect(E.m.CooldownUntil == 1234 && pos == values.len(), "native manager/event save-load format intact");
pos = 0; M.m.Events = []; M.onDeserialize(io);
expect(pos == values.len(), "native loader skips absent framework event cleanly"); M.m.Events = [E];
expect(A.openLedger("home") == "base_ledger", "F8/base pages keep original entry point");
print("TESTS_PASSED=" + checks + "\n");
