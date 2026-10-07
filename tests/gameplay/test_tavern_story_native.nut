// Integration regression: real tavern hook -> deferred callback -> ledger ->
// native event.fire/onPrepare -> actual growth/root discovery and choices.
// Timer delivery, actor storage and Coherent drawing are engine boundaries.
::checks <- 0;
function expect(value, label) { if (!value) throw "FAIL " + label; ++::checks; }
::logInfo <- function(...) {};
::logError <- function(message) { throw message; };
::Math <- { min = function(a,b) { return a < b ? a : b; }, max = function(a,b) { return a > b ? a : b; } };
::Const <- { Events = { GlobalSound = "" }, UI = { Cursor = { Hand = 0 } } };
::Cursor <- { setCursor = function(value) {} };
::TimeUnit <- { Real = 0 };
::test <- { timers = [], flags = {}, actors = [], clicks = 0, views = [], hostile = true,
    distance = 3, origin = true, now = 0, updates = 0 };
::Time <- {
    getVirtualTimeF = function() { return 1000.0; },
    scheduleEvent = function(unit, delay, callback, tag) {
        ::test.timers.push({ due = ::test.now + delay, callback = callback, tag = tag });
    }
};
function runTimer() {
    expect(::test.timers.len() > 0, "deferred callback remains scheduled");
    local timer = ::test.timers.remove(0);
    ::test.now = timer.due; timer.callback(timer.tag);
    return timer;
}
function drainTimers() {
    local count = 0;
    while (::test.timers.len() > 0 && ++count < 100) runTimer();
    expect(count < 100, "retry queue terminates");
}
::Tactical <- { Active = false, State = null, isActive = function() { return this.Active; } };
::LoadingScreen <- { visible = false, animating = false,
    isVisible = function() { return this.visible; }, isAnimating = function() { return this.animating; } };
::inherit <- function(path, object) {
    if (path == "scripts/events/event") {
        local result = clone ::event; result.m = clone ::event.m;
        foreach (key, value in object) {
            if (key == "m") foreach (field, entry in value) result.m[field] <- entry;
            else result[key] <- value;
        }
        result.event <- ::event;
        return result;
    }
    if (path == "scripts/skills/traits/character_trait") {
        object.m = { ID = "", Name = "", Icon = "", IconMini = "", Description = "", Titles = [], Excluded = [], Owner = null };
        object.character_trait <- { create = function() {} };
        object.getID <- function() { return this.m.ID; };
        object.getContainer <- function() { return this.m.Owner; };
    }
    return object;
};
dofile(".cache/afei-art/native-contract-fixture/event.nut");
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
dofile(".cache/afei-art/native-contract-fixture/world_state.nut");
dofile(".cache/afei-art/native-contract-fixture/menu_stack.nut");
dofile(".cache/afei-art/native-contract-fixture/world_event_screen.nut");
::AfeixExpedition <- { CombatMax = 12, RosterMax = 40 };
foreach (part in ["core", "formation", "characters", "roster", "quests", "promotions", "story_progress", "discovery", "ledger", "story_ledger"])
    dofile("src/scripts/mods/afeix/" + part + ".nut");
dofile("src/scripts/events/events/afeix_ledger_event.nut");
dofile("src/scripts/skills/traits/afeix_personal_trait.nut");
getroottable()["new"] <- function(path) {
    expect(path == "scripts/skills/traits/afeix_personal_trait", "growth creates the real personal trait");
    local skill = clone ::afeix_personal_trait; skill.m = clone skill.m; skill.create(); return skill;
};
local A = ::AfeixExpedition, S = ::world_state, E = ::event_manager, M = ::menu_stack;
S.setdelegate(getroottable()); E.setdelegate(getroottable());
local tavern = { animating = false, isAnimating = function() { return this.animating; } };
local town = { id = 51, alive = true, allied = true,
    getID = function() { return this.id; }, isAlive = function() { return this.alive; },
    isMilitary = function() { return false; }, isAlliedWithPlayer = function() { return this.allied; },
    getTile = function() { return { getDistanceTo = function(tile) { return ::test.distance; } }; } };
local T = { visible = true, animating = false, town = town, restored = 0, hidden = 0,
    m = { LastActiveModule = tavern },
    getTown = function() { return this.town; }, getTavernDialogModule = function() { return tavern; },
    isVisible = function() { return this.visible; }, isAnimating = function() { return this.animating; },
    hideAllDialogs = function() { ++this.hidden; }, showLastActiveDialog = function() { ++this.restored; } };
S.m.WorldTownScreen = T;
S.m.CharacterScreen = { visible = false, animating = false,
    isVisible = function() { return this.visible; }, isAnimating = function() { return this.animating; } };
S.m.EventScreen = { visible = false, animating = false,
    isVisible = function() { return this.visible; }, isAnimating = function() { return this.animating; },
    setIsContract = function(value) {}, hide = function() { this.visible = false; },
    show = function(event) { this.visible = true; ::test.views.push(::world_event_screen.convertEventToUIData(event)); } };
S.m.WorldScreen = { hide = function() {}, show = function() {} };
S.m.Player = { getTile = function() { return {}; }, getPos = function() { return {}; } };
S.m.MenuStack = M; M.create(); M.setEnviroment(S);
S.setAutoPause = function(value) {};
S.setNormalTime = function() {};
S.updateTopbarAssets = function() { ++::test.updates; };
::World <- { State = S, Events = E,
    Flags = { has = function(key) { return key in ::test.flags; }, get = function(key) { return ::test.flags[key]; },
        set = function(key, value) { ::test.flags[key] <- value; } },
    Assets = { money = 2000, tools = 10, medicine = 10, ammo = 10,
        getOrigin = function() { return { getID = function() { return ::test.origin ? "scenario.afeix_expedition" : "other"; } }; },
        isCamping = function() { return false; }, getMoney = function() { return this.money; },
        addMoney = function(value) { this.money += value; }, setMoney = function(value) { this.money = value; },
        getArmorParts = function() { return this.tools; }, addArmorParts = function(value) { this.tools += value; }, setArmorParts = function(value) { this.tools = value; },
        getMedicine = function() { return this.medicine; }, addMedicine = function(value) { this.medicine += value; }, setMedicine = function(value) { this.medicine = value; },
        getAmmo = function() { return this.ammo; }, addAmmo = function(value) { this.ammo += value; }, setAmmo = function(value) { this.ammo = value; } },
    EntityManager = { getSettlements = function() { return [town]; } },
    getPlayerRoster = function() { return { getAll = function() { return ::test.actors; } }; },
    getAllEntitiesAtPos = function(pos, radius) { return ::test.hostile ? [{ isAlive = function() { return true; },
        isAlliedWithPlayer = function() { return false; }, getTroops = function() { return [1]; } }] : []; },
    getTime = function() { return { IsDaytime = true, Days = 10 }; } };
local ledger = ::afeix_ledger_event; ledger.setdelegate(getroottable()); ledger.create(); E.m.Events = [ledger];
local building = { onClicked = function(screen) { ++::test.clicks; screen.m.LastActiveModule = tavern; return 72; },
    getSettlement = function() { return town; } };
::mods_hookExactClass <- function(path, callback) {
    if (path == "entity/world/settlements/buildings/tavern_building") callback(building);
    if (path == "states/world_state") callback(S);
};
::mods_hookNewObject <- function(...) {};
::mods_hookBaseClass <- function(...) {};
dofile("src/scripts/mods/afeix/hooks.nut");
function makeActor(key, level = 3, battles = 3) {
    local actor = { key = key, level = level, battles = battles, alive = true,
        getFlags = function() { local key = this.key; return { has = function(flag) { return flag == "afeix_character"; }, get = function(flag) { return key; } }; },
        getLevel = function() { return this.level; }, getLifetimeStats = function() { return { Battles = this.battles }; },
        isAlive = function() { return this.alive; }, getID = function() { return 1; },
        getPlaceInFormation = function() { return 0; }, getSkills = function() { return this.skills; }, skills = null,
        properties = { Hitpoints = 50, Stamina = 100, Bravery = 40, Initiative = 100, MeleeSkill = 50, RangedSkill = 40, MeleeDefense = 5, RangedDefense = 5 } };
    actor.skills = { actor = actor, list = [], updates = 0,
        getActor = function() { return this.actor; }, getSkillByID = function(id) { foreach (skill in this.list) if (skill.getID() == id) return skill; return null; },
        add = function(skill) { skill.m.Owner <- this; this.list.push(skill); },
        update = function() { ++this.updates; foreach (skill in this.list) skill.onUpdate(this.actor.properties); } };
    ::test.actors.push(actor); return actor;
}
local reset = function() {
    ::test.timers = []; ::test.flags = {}; ::test.actors = []; ::test.views = []; ::test.now = 0;
    ::test.hostile = true; ::test.distance = 3; ::test.origin = true;
    ::LoadingScreen.visible = false; ::LoadingScreen.animating = false; ::Tactical.Active = false; ::Tactical.State = null;
    S.m.CombatStartTime = 0; S.m.WorldTownScreen = T; T.visible = true; T.animating = false;
    T.town = town; town.alive = true; town.allied = true; T.m.LastActiveModule = tavern; tavern.animating = false;
    S.m.CharacterScreen.visible = false; S.m.CharacterScreen.animating = false;
    S.m.EventScreen.visible = false; S.m.EventScreen.animating = false;
    E.m.ActiveEvent = null; E.m.IsEventShown = false; ledger.clear();
    A.TavernTown = 0; A.PendingTavernMeeting <- null;
    M.m.Stack = []; M.push(function() { this.m.WorldTownScreen.visible = false; });
    ::World.Assets.money = 2000; ::World.Assets.tools = 10; ::World.Assets.medicine = 10; ::World.Assets.ammo = 10;
};
local close = function() {
    E.processInput(-1);
    expect(E.m.ActiveEvent == null && !S.m.EventScreen.isVisible() && M.m.Stack.len() == 1,
        "native event close restores exactly the tavern backstep");
};
local open = function() { expect(building.onClicked(T) == 72, "native drink click return preserved"); drainTimers(); };
local f8 = function() { return S.onKeyInput({ getKey = function() { return 78; }, getState = function() { return 0; } }); };

// Reproduce animation lasting beyond the former single 350ms callback.
reset(); local bro = makeActor("afei"); T.animating = true; ::test.hostile = false; ::test.distance = 0;
expect(building.onClicked(T) == 72 && ::test.clicks == 1, "drink dialog opens before asynchronous story");
runTimer(); expect(::test.now == 350 && E.m.ActiveEvent == null && !A.growthKnown("afei"), "opening animation does not reveal unseen growth");
T.animating = false; tavern.animating = true;
expect(::test.timers.len() > 0, "slow native tavern animation retains retry instead of losing the visit");
local token = A.TavernTown, requested = ledger.m.AutoPage;
expect(!A.openLedger() && !A.growthKnown("afei") && A.TavernTown == token && ledger.m.AutoPage == requested,
    "F8 during only tavern module animation leaves story and ledger state untouched");
runTimer(); expect(E.m.ActiveEvent == null && !A.growthKnown("afei"), "dialog animation also waits without consuming discovery");
tavern.animating = false; ::test.hostile = true; ::test.distance = 3; runTimer();
expect(E.m.ActiveEvent == ledger && ledger.m.ActiveScreen.ID == "member_growth:afei", "native fire and onPrepare reveal eligible personal growth");
expect(!A.canManage() && A.currentTown() == null, "fixture reproduces outside enemies and stale map proximity");
expect(A.growthKnown("afei") && A.get("tavern_towns") == 1 && M.m.Stack.len() == 2,
    "entered friendly tavern records one visit and one event backstep");
expect(::test.views.len() == 1 && ::test.views[0].buttons.len() == 3
    && ::test.views[0].content[0].text.find(A.MemberGrowth.afei.scene) != null, "real native UI contains growth prose and both choices");
E.processInput(0);
expect(A.get("growth_done_afei", false) && A.get("growth_choice_afei", -1) == 0 && bro.skills.updates == 1,
    "native growth choice succeeds inside inn despite enemies outside");
expect(bro.skills.list.len() == 1 && bro.skills.list[0].getID() == A.PersonalTraitID, "choice installs actual personal trait");
local updates = bro.skills.updates;
expect(!A.resolveGrowth("afei", 1).ok && bro.skills.updates == updates, "growth reward cannot be repeated or changed");
close(); open(); expect(ledger.m.ActiveScreen.ID == "tavern", "finished growth does not automatically repeat"); close();
expect(f8() && ledger.m.ActiveScreen.ID == "home", "F8 without pending discovery retains the full home menu"); close();

// Each independent root entry keeps its original progression/membership gate.
foreach (id in A.RootOrder) {
    reset(); local data = A.RootStories[id];
    // Exclude previously eligible roots to reach this independent opening.
    foreach (prior in A.RootOrder) { if (prior == id) break; A.set("root_done_" + prior, true); }
    if (data.member == "") A.set("paid_contracts", data.required - 1);
    open(); expect(ledger.m.ActiveScreen.ID == "tavern" && !A.rootKnown(id), "ineligible root stays hidden: " + id); close();
    if (data.member == "") A.set("paid_contracts", data.required);
    else A.set("ever_" + data.member, true);
    open(); expect(ledger.m.ActiveScreen.ID == "roots:" + id && A.rootKnown(id), "native prepare discovers root at its true threshold: " + id);
    expect(::test.views.top().buttons.len() == 3, "root exposes both actual reply choices: " + id);
    local reward = data.choices[0].reward, before = ::World.Assets[reward.kind];
    E.processInput(0);
    expect(A.get("root_done_" + id, false) && ::World.Assets[reward.kind] == before + reward.amount,
        "native reply pays exactly one root reward near outside enemies: " + id);
    expect(!A.resolveRoot(id, 0).ok && ::World.Assets[reward.kind] == before + reward.amount,
        "root reply cannot double-pay: " + id);
    close();
}
foreach (pair in [[2,3], [3,2]]) {
    reset(); makeActor("afei", pair[0], pair[1]); open();
    expect(ledger.m.ActiveScreen.ID == "tavern" && !A.growthKnown("afei"), "personal level and battle thresholds both remain necessary"); close();
}

// Automatic callbacks expire after navigation; they must never reopen later.
foreach (reason in ["leave", "module", "town", "screen", "character", "event", "loading", "combat", "hostile town"]) {
    reset(); makeActor("afei"); T.animating = true; building.onClicked(T); runTimer();
    if (reason == "leave") T.visible = false;
    if (reason == "module") T.m.LastActiveModule = {};
    if (reason == "town") { local other = clone town; other.id = 52; T.town = other; }
    if (reason == "screen") S.m.WorldTownScreen = clone T;
    if (reason == "character") S.m.CharacterScreen.visible = true;
    if (reason == "event") E.m.ActiveEvent = { getID = function() { return "event.other"; } };
    if (reason == "loading") ::LoadingScreen.visible = true;
    if (reason == "combat") ::Tactical.Active = true;
    if (reason == "hostile town") town.allied = false;
    drainTimers();
    expect(::test.views.len() == 0 && !A.growthKnown("afei"), "stale visit cannot show or discover after " + reason);
    expect(A.PendingTavernMeeting == null, "stale pending callback cancelled after " + reason);
}
reset(); makeActor("afei"); T.animating = true; building.onClicked(T); drainTimers();
expect(::test.views.len() == 0 && !A.growthKnown("afei") && ::test.now <= 6000, "permanently busy native screen times out without consuming discovery");
T.animating = false;
expect(f8() && ledger.m.ActiveScreen.ID == "member_growth:afei", "F8 recovers an expired visit from actual tavern context"); close();
reset(); makeActor("afei"); M.m.Stack[0].allowCancel = false; building.onClicked(T); runTimer();
expect(E.m.ActiveEvent == null, "temporarily non-cancellable menu waits");
M.m.Stack[0].allowCancel = true; drainTimers(); expect(E.m.ActiveEvent == ledger, "unlocked native menu permits pending story"); close();
reset(); makeActor("afei"); building.onClicked(T); building.onClicked(T); drainTimers();
expect(::test.views.len() == 1 && M.m.Stack.len() == 2, "duplicate tavern clicks schedule only one native event"); close();

// Safe conversations must not unlock formation changes or unsafe field stories.
reset(); makeActor("afei");
expect(!A.applyFormation([1]).ok, "story permission does not permit unsafe formation mutation");
T.visible = false; M.m.Stack = [];
expect(A.nextDiscovery(true) == null && !A.revealDiscovery("member_growth:afei") && !A.resolveGrowth("afei", 0).ok,
    "unsafe field cannot reveal or resolve personal growth");
A.set("paid_contracts", 3); A.set("root_triggered_er_xiaoyuan", true);
expect(!A.resolveRoot("er_xiaoyuan", 0).ok && !A.triggerRoot("er_keke").ok && ::World.Assets.money == 2000,
    "unsafe field cannot open or reply to roots");
reset(); ::test.origin = false; building.onClicked(T);
expect(::test.timers.len() == 0 && !A.isAtTavern(), "other origins preserve only the native drinks UI");
print("TESTS_PASSED=" + ::checks + "\n");
