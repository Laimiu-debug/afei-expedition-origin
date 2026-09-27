// Execute from the repository root. Model only Legacy Hooks 21.1 dispatch:
// ExactClass runs during inherit, NewObject when an instance is created, and
// BaseClass for a direct child. Native bare tables never emit an inherit event.
// In particular, do not execute every registered ExactClass callback up front.
::registrationChecks <- 0;
function expectRegistration(condition, message) {
    if (!condition) throw "FAIL " + message;
    ::registrationChecks++;
}

::hookRegistry <- { exact = {}, instance = {}, children = {} };
function registerHook(kind, path, callback) {
    local registry = ::hookRegistry[kind];
    if (!(path in registry)) registry[path] <- [];
    registry[path].push(callback);
}
::mods_hookExactClass <- function(path, callback) { registerHook("exact", path, callback); };
::mods_hookNewObject <- function(path, callback) { registerHook("instance", path, callback); };
::mods_hookBaseClass <- function(path, callback) { registerHook("children", path, callback); };
// Exact Legacy Hooks 21.1 member resolution on raw, unflattened class tables.
::mods_getMember <- function(object, key) {
    while (!(key in object)) object = object[object.SuperName];
    return object[key];
};
::mods_override <- function(object, key, value) {
    while (!(key in object)) object = object[object.SuperName];
    object[key] = value;
};
function dispatchHooks(kind, path, object) {
    local registry = ::hookRegistry[kind];
    if (path in registry) foreach (callback in registry[path]) callback(object);
}
function nativeObject(path, object, parent = null) {
    // This models the two actual entry points; it does not infer inheritance
    // merely from a path name or from whether a hook happens to be registered.
    if (parent != null) {
        dispatchHooks("children", parent, object);
        dispatchHooks("exact", path, object);
    }
    dispatchHooks("instance", path, object);
    return object;
}

::registrationState <- {
    origin = true, formationCalls = 0, nativeFormationCalls = 0,
    ledgerCalls = 0, nativeKeyCalls = 0, nativeDeathCalls = 0,
    metadataCalls = 0, worldLoaded = false, receipts = [], finished = [],
    contractCalls = 0, eventCalls = 0, flags = {}, actors = {}, roster = [], victories = [], nativeCombatIDs = []
};
::AfeixExpedition <- {
    RosterMax = 20, CombatMax = 10, PaymentContext = null,
    isOrigin = function() { return ::registrationState.origin; },
    enforceFormation = function() { ::registrationState.formationCalls++; },
    formation = function() { return "afeix-formation"; },
    openLedger = function() { ::registrationState.ledgerCalls++; return true; },
    roster = function() { return ::registrationState.roster; },
    updateRecruitEligibility = function() {},
    restoreCharacterMetadata = function(bro) {
        expectRegistration(::registrationState.worldLoaded, "metadata follows native world deserialization");
        ::registrationState.metadataCalls++;
    },
    characterId = function(bro) { return bro == null ? "" : bro.key; },
    findCharacter = function(key) {
        return key in ::registrationState.actors ? ::registrationState.actors[key] : null;
    },
    set = function(key, value) { ::registrationState.flags[key] <- value; },
    noteContractIncome = function(id, amount) { ::registrationState.receipts.push([id, amount]); },
    noteCircleVictory = function(id) { ::registrationState.victories.push(id); },
    finishContractPayment = function(id, cancelled) { ::registrationState.finished.push([id, cancelled]); },
    withPaymentContext = function(id, callback, args) {
        local previous = this.PaymentContext;
        this.PaymentContext = id;
        local result = callback.acall(args);
        this.PaymentContext = previous;
        return result;
    },
    wrapContractCallback = function(callback) {
        return function(...) {
            ::registrationState.contractCalls++;
            local args = [this]; args.extend(vargv);
            return callback.acall(args);
        };
    },
    wrapNonContractCallback = function(callback) {
        return function(...) {
            ::registrationState.eventCalls++;
            local args = [this]; args.extend(vargv);
            return callback.acall(args);
        };
    }
};
::Const <- { FatalityType = { Unconscious = 0 } };
::Tactical <- { getEntityByID = function(id) { return ::registrationState.actors[id]; } };
::World <- { Assets = null };
dofile("src/scripts/mods/afeix/hooks.nut");

function assetStub() {
    return {
        m = { Money = 0, BrothersMax = 20, BrothersMaxInCombat = 12, BrothersScaleMax = 12 },
        getMoney = function() { return this.m.Money; },
        addMoney = function(amount) { this.m.Money += amount; return "native-money"; },
        getFormation = function() { return "native-formation"; },
        updateFormation = function(considerMax = false) { ::registrationState.nativeFormationCalls++; }
    };
}
local assets = nativeObject("states/world/asset_manager", assetStub());
::World.Assets = assets;
expectRegistration(assets.getFormation() == "afeix-formation", "bare asset_manager receives getFormation hook");
assets.updateFormation();
expectRegistration(::registrationState.formationCalls == 1, "bare asset_manager receives updateFormation hook");
expectRegistration(assets.m.BrothersMaxInCombat == 10, "asset instance enforces ten active members");
expectRegistration(assets.m.BrothersScaleMax == 10, "asset instance migrates scaling to ten brothers");
::AfeixExpedition.PaymentContext = 501;
expectRegistration(assets.addMoney(60) == "native-money", "addMoney preserves native return value");
expectRegistration(::registrationState.receipts.len() == 1 && ::registrationState.receipts[0][0] == 501
    && ::registrationState.receipts[0][1] == 60, "bare asset_manager receives payment hook");
::AfeixExpedition.PaymentContext = null;
local secondAssets = nativeObject("states/world/asset_manager", assetStub());
expectRegistration(secondAssets.getFormation() == "afeix-formation", "NewObject applies to later campaign asset instances too");
::registrationState.origin = false;
expectRegistration(assets.getFormation() == "native-formation", "other origins retain native formation getter");
assets.updateFormation();
expectRegistration(::registrationState.nativeFormationCalls == 1, "other origins retain native formation updater");
::registrationState.origin = true;

local manager = nativeObject("contracts/contract_manager", {
    m = { Active = { getID = function() { return 601; } } },
    finishActiveContract = function(cancelled = false) {
        expectRegistration(::AfeixExpedition.PaymentContext == 601, "manager native finish has payment context");
        this.m.Active = null;
        return "native-finish";
    }
});
expectRegistration(manager.finishActiveContract(false) == "native-finish", "bare contract_manager receives finish hook");
expectRegistration(::registrationState.finished.len() == 1 && ::registrationState.finished[0][0] == 601
    && !::registrationState.finished[0][1], "contract_manager commits native successful finish");
expectRegistration(::AfeixExpedition.PaymentContext == null, "manager call restores payment context");

local callbacks = ["processInput", "setScreen", "setState", "update", "onActorKilled", "onActorRetreated",
    "onRetreatedFromCombat", "onCombatVictory", "onPartyDestroyed", "onLocationDestroyed"];
function callbackStub(methods) {
    local object = {};
    foreach (method in methods) object[method] <- function(...) { return "native-callback"; };
    return object;
}
local contractStub = callbackStub(callbacks);
contractStub.getID <- function() { return 701; };
contractStub.onCombatVictory = function(combatID) {
    expectRegistration(::registrationState.victories.len() == 1 && ::registrationState.victories[0] == 701,
        "victory entitlement is recorded before native callback can settle the contract");
    ::registrationState.nativeCombatIDs.push(combatID);
    return "native-callback";
};
local contract = nativeObject("contracts/contracts/afeix_test_contract", contractStub, "contracts/contract");
foreach (method in callbacks) {
    local result = method == "onCombatVictory" ? contract[method](9001) : contract[method]();
    expectRegistration(result == "native-callback", "contract child preserves " + method);
}
expectRegistration(::registrationState.victories.len() == 1 && ::registrationState.victories[0] == 701,
    "victory hook uses persistent contract ID rather than combat ID");
expectRegistration(::registrationState.nativeCombatIDs.len() == 1 && ::registrationState.nativeCombatIDs[0] == 9001,
    "native onCombatVictory receives its original single combatID argument");
expectRegistration(::registrationState.contractCalls == callbacks.len(), "every contract child dispatcher receives BaseClass wrapper exactly once");
local eventMethods = ["fire", "processInput", "setScreen", "update"];
local event = nativeObject("events/events/afeix_ledger_event", callbackStub(eventMethods), "events/event");
foreach (method in eventMethods)
    expectRegistration(event[method]() == "native-callback", "event child preserves " + method);
expectRegistration(::registrationState.eventCalls == eventMethods.len(), "every event child dispatcher receives BaseClass wrapper exactly once");

// Real inherit callbacks expose missing methods through SuperName, not through
// a Squirrel delegate. Flat mocks previously concealed startup exceptions.
local rawContractBase = callbackStub(callbacks);
local originalVictory = rawContractBase.onCombatVictory;
local rawFirst = { SuperName = "contract", contract = rawContractBase,
    getID = function() { return 801; },
    processInput = function(option) { return "child-override-" + option; }
};
local rawSecond = { SuperName = "contract", contract = rawContractBase,
    getID = function() { return 802; }
};
nativeObject("contracts/contracts/raw_first", rawFirst, "contracts/contract");
nativeObject("contracts/contracts/raw_second", rawSecond, "contracts/contract");
local countBefore = ::registrationState.contractCalls;
expectRegistration(rawFirst.processInput(7) == "child-override-7", "raw child method override is preserved");
expectRegistration(::mods_getMember(rawFirst,"setScreen").call(rawFirst,"Start") == "native-callback", "raw child resolves inherited dispatcher");
expectRegistration(::mods_getMember(rawSecond,"onCombatVictory").call(rawSecond,23) == "native-callback", "second raw child resolves inherited combat callback");
expectRegistration(::registrationState.contractCalls == countBefore + 3, "shared contract base is not multiply wrapped");
expectRegistration(rawContractBase.onCombatVictory != originalVictory && !("onCombatVictory" in rawFirst),
    "hook replaces the inherited definition without shadowing the child table");
expectRegistration(::registrationState.victories.top() == 802, "raw inherited victory observes actual child ID");
local rawEventBase = callbackStub(eventMethods);
local originalFire = rawEventBase.fire;
local rawEventFirst = { SuperName = "event", event = rawEventBase };
local rawEventSecond = { SuperName = "event", event = rawEventBase };
nativeObject("events/events/raw_first", rawEventFirst, "events/event");
nativeObject("events/events/raw_second", rawEventSecond, "events/event");
local eventsBefore = ::registrationState.eventCalls;
expectRegistration(::mods_getMember(rawEventFirst,"fire").call(rawEventFirst) == "native-callback"
    && ::mods_getMember(rawEventSecond,"fire").call(rawEventSecond) == "native-callback",
    "raw event children resolve inherited fire method");
expectRegistration(::registrationState.eventCalls == eventsBefore + 2 && rawEventBase.fire != originalFire
    && !("fire" in rawEventFirst), "event definition is replaced only once without shadowing child tables");

::registrationState.actors["bottle"] <- { key = "bottle" };
local characterScreen = nativeObject("ui/screens/character/character_screen", {
    onDismissCharacter = function(data) {
        delete ::registrationState.actors[data[0]];
        return "native-dismiss";
    }
});
expectRegistration(characterScreen.onDismissCharacter(["bottle"]) == "native-dismiss", "bare character_screen receives dismissal hook");
expectRegistration("departed_bottle" in ::registrationState.flags && ::registrationState.flags.departed_bottle,
    "dismissal records the removed named companion");

local player = nativeObject("entity/tactical/player", {
    onCombatStart = function() {},
    key = "afei",
    onDeath = function(killer, skill, tile, fatality) { ::registrationState.nativeDeathCalls++; return "native-death"; }
}, "entity/tactical/human");
expectRegistration(player.onDeath(null, null, null, 1) == "native-death", "inherited player receives ExactClass hook");
expectRegistration("dead_afei" in ::registrationState.flags && ::registrationState.flags.dead_afei,
    "player exact hook records a fatal named casualty");
player.key = "damou";
player.onDeath(null, null, null, ::Const.FatalityType.Unconscious);
expectRegistration(!("dead_damou" in ::registrationState.flags), "unconscious player is not marked dead");

local world = nativeObject("states/world_state", {
    onKeyInput = function(key) { ::registrationState.nativeKeyCalls++; return "native-key"; },
    onDeserialize = function(input) {
        ::registrationState.worldLoaded = true;
        ::registrationState.origin = true;
        return "native-world-load";
    }
}, "states/state");
function keyInput(state, code) {
    return { state = state, code = code, getState = function() { return this.state; }, getKey = function() { return this.code; } };
}
expectRegistration(world.onKeyInput(keyInput(0, 78)) == true && ::registrationState.ledgerCalls == 1,
    "inherited world_state receives released F8 hook");
expectRegistration(world.onKeyInput(keyInput(1, 78)) == "native-key", "F8 key-down retains native handling");
expectRegistration(world.onKeyInput(keyInput(0, 77)) == "native-key", "unrelated key retains native handling");
::registrationState.origin = false;
::registrationState.roster = [player];
::AfeixExpedition.PaymentContext = 999;
local formationBeforeLoad = ::registrationState.formationCalls;
expectRegistration(world.onDeserialize(null) == "native-world-load", "world exact hook preserves native load result");
expectRegistration(::registrationState.metadataCalls == 1, "world load repairs metadata after saved origin is restored");
expectRegistration(::registrationState.formationCalls == formationBeforeLoad + 1, "world load invokes hooked formation update");
expectRegistration(::AfeixExpedition.PaymentContext == null, "world load clears stale transient contract context");

// Guard the dispatcher itself against returning to the old permissive mock:
// an Exact hook on a bare table must stay dormant; Base only targets its child.
local control = { exact = 0, children = 0, instance = 0 };
::mods_hookExactClass("test/plain", function(o) { control.exact++; });
::mods_hookBaseClass("test/base", function(o) { control.children++; });
::mods_hookNewObject("test/plain", function(o) { control.instance++; });
nativeObject("test/plain", {});
expectRegistration(control.exact == 0 && control.instance == 1, "bare tables dispatch NewObject but never ExactClass");
nativeObject("test/child", {}, "test/base");
expectRegistration(control.children == 1, "BaseClass dispatches for a direct child");
nativeObject("test/grandchild", {}, "test/child");
expectRegistration(control.children == 1, "BaseClass is not a recursive descendant hook");
print("TESTS_PASSED=" + ::registrationChecks + "\n");
