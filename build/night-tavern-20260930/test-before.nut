// Execute the installed game's key dispatch, character-screen state and menu
// stack. Drawing/async UI callbacks are simulated; this is not an engine test.
local checks = 0;
local expect = function(ok, label) { if (!ok) throw "FAIL " + label; checks++; };
::inherit <- function(path, child) { return child; };
::Const <- { Items = { ItemFilter = { All = 0 } }, Events = { GlobalSound = "" }, UI = { Cursor = { Hand = 0 } } };
::logInfo <- function(...) {};
::logError <- function(message) { throw message; };
::Tactical <- { State = null, function isActive() { return false; } };
::LoadingScreen <- null;
::Cursor <- { function setCursor(value) {} };
::AfeixExpedition <- { TavernTown = 0, function isOrigin() { return true; }, function canManage() { return true; } };
::World <- { Assets = { function updateFormation() {}, function refillAmmo() {} } };
dofile(".cache/afei-art/native-contract-fixture/world_state.nut");
dofile(".cache/afei-art/native-contract-fixture/menu_stack.nut");
dofile(".cache/afei-art/native-contract-fixture/character_screen.nut");
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
dofile("build/night-tavern-20260930/ledger-before.nut");
local S = ::world_state, M = ::menu_stack, C = ::character_screen, E = ::event_manager, A = ::AfeixExpedition;
S.setdelegate(getroottable()); C.setdelegate(getroottable()); E.setdelegate(getroottable());
::World.State <- S; ::World.Events <- E;
M.create(); M.setEnviroment(S);
S.m.MenuStack = M; S.m.CharacterScreen = C; S.m.Player = {};
S.setAutoPause = function(value) { this.m.IsGameAutoPaused = value; };
S.setNormalTime = function() {};
S.updateTopbarAssets = function() {};
local camera = { Zoom = 1.0, function zoomTo(value, speed) { this.Zoom = value; } };
::World.getCamera <- function() { return camera; };
S.m.WorldScreen = { function hide() {}, function show() {} };
S.m.WorldTownScreen = {
    visible = false, restored = 0, animating = false,
    town = { function isAlive() { return true; }, function isAlliedWithPlayer() { return true; } },
    function isVisible() { return this.visible; },
    function isAnimating() { return this.animating; },
    function getTown() { return this.town; },
    function hideAllDialogs() {},
    function showLastActiveDialog() { this.restored++; }
};
S.m.EventScreen = {
    visible = false, animating = false, shows = 0,
    function isVisible() { return this.visible; },
    function isAnimating() { return this.animating; },
    function setIsContract(value) {},
    function show(event) { this.visible = true; this.shows++; },
    function hide() { this.visible = false; }
};
// Simulate Coherent callbacks; retain native isVisible/isAnimating (including
// PopupDialogVisible) so visibility does not collapse into a permissive mock.
C.show = function() { this.m.Visible = true; };
C.hide = function() { this.m.Visible = false; };
local event = {
    m = { AutoPage = "home", TreatmentOffer = null, Selected = [] }, fires = 0,
    function getID() { return "event.afeix_ledger"; },
    function fire() { this.fires++; },
    function processInput(option) { return option != -1; },
    function clear() { this.m.TreatmentOffer=null;this.m.Selected=[];this.m.AutoPage="home"; }
};
E.m.Events = [event];
::mods_hookExactClass <- function(path, callback) { if (path == "states/world_state") callback(S); };
::mods_hookNewObject <- function(...) {};
::mods_hookBaseClass <- function(...) {};
dofile("src/scripts/mods/afeix/hooks.nut");
local key = function(code, state = 0) { return {
    function getKey() { return code; }, function getState() { return state; }
}; };
local reset = function(inTown) {
    M.m.Stack = [];
    E.m.ActiveEvent = null; E.m.IsEventShown = false;
    S.m.EventScreen.visible = false; S.m.EventScreen.animating = false;
    S.m.WorldTownScreen.visible = inTown;
    C.m.Visible = false; C.m.Animating = false; C.m.PopupDialogVisible = false;
    if (inTown) M.push(function() { this.m.WorldTownScreen.visible = false; });
};

// Run town first: before the fix F8 adds an uncloseable event above the
// character backstep, and both C and Escape leave the character screen open.
foreach (inTown in [true, false]) {
    foreach (closeKey in [13, 41, -1]) {
        reset(inTown);
        S.toggleCharacterScreen();
        expect(C.isVisible(), "native character screen opened");
        local depth = M.m.Stack.len(), fires = event.fires, shows = S.m.EventScreen.shows;
        A.TavernTown = 77; event.m.AutoPage = "unchanged";
        for (local press = 0; press < 3; press++) {
            S.onKeyInput(key(78, 1)); S.onKeyInput(key(78));
        }
        local untouched = M.m.Stack.len() == depth && event.fires == fires
            && S.m.EventScreen.shows == shows && E.m.ActiveEvent == null && !E.m.IsEventShown
            && A.TavernTown == 77 && event.m.AutoPage == "unchanged";
        if (closeKey == -1) S.character_screen_onClosePressed();
        else S.onKeyInput(key(closeKey));
        expect(!C.isVisible(), "F8 in character screen still permits C/Escape/close button, town=" + inTown);
        expect(untouched, "repeated F8 does not fire, push a menu or change ledger state");
        expect(M.m.Stack.len() == depth - 1, "native close removes exactly the character backstep");
        expect(S.m.WorldTownScreen.visible == inTown, "character close preserves map/town context");
        expect(A.openLedger(), "ledger opens normally after closing character screen");
        expect(!A.openLedger(), "active ledger cannot be stacked");
        // The real event-completion path force-pops its non-cancellable menu.
        M.pop(true); E.m.ActiveEvent = null; E.m.IsEventShown = false;
        expect(A.openLedger(), "ledger can reopen after event completion");
    }
}

// Escape closes any ledger subpage through the native event-manager cleanup,
// without also popping the town or calling its ordinary menu toggle.
foreach(inTown in [true,false]) foreach(page in ["home","treatment_preview:1:Hitpoints","formation_confirm","tavern"]) {
    reset(inTown);
    local depth=M.m.Stack.len(),restored=S.m.WorldTownScreen.restored;
    expect(A.openLedger(page),"ledger subpage opens before Escape: "+page);
    event.m.TreatmentOffer={actorId=1};event.m.Selected=[1,2];
    S.onKeyInput(key(41,1));
    expect(E.m.ActiveEvent==event,"Escape key-down does not close early");
    S.m.EventScreen.animating=true;
    expect(S.onKeyInput(key(41))&&E.m.ActiveEvent==event,"opening animation consumes Escape without another menu");
    S.m.EventScreen.animating=false;
    expect(S.onKeyInput(key(41)),"Escape key-up handled for ledger subpage");
    expect(E.m.ActiveEvent==null&&!E.m.IsEventShown&&!S.m.EventScreen.isVisible(),"native manager and screen close");
    expect(M.m.Stack.len()==depth&&S.m.WorldTownScreen.visible==inTown,"only event backstep removed");
    expect(event.m.TreatmentOffer==null&&event.m.Selected.len()==0,"unconfirmed points and formation drafts discarded");
    expect(S.m.WorldTownScreen.restored==restored+(inTown?1:0),"town dialog restored once");
    expect(A.openLedger(),"F8 remains usable after Escape");
}
reset(false);
local story={getID=function(){return "event.some_story";}};
E.m.ActiveEvent=story;S.m.EventScreen.visible=true;
expect(!A.closeLedger(S)&&E.m.ActiveEvent==story,"ordinary story event cannot be cancelled by ledger Escape");
E.m.ActiveEvent=null;

foreach (inTown in [true, false]) {
    foreach (status in ["Visible", "Animating", "PopupDialogVisible"]) {
        reset(inTown);
        C.m[status] = true;
        local depth = M.m.Stack.len(), fires = event.fires;
        // Direct/tavern entry must also respect character animation and popups,
        // including the interval before the character backstep is installed.
        expect(!A.openLedger("tavern", 42), "character state blocks delayed tavern entry: " + status);
        expect(event.fires == fires && M.m.Stack.len() == depth && E.m.ActiveEvent == null,
            "blocked animation/popup has no event or menu side effects");
        C.m[status] = false;
        expect(A.openLedger("tavern", 42), "tavern entry works once character state ends");
        expect(A.TavernTown == 42 && event.m.AutoPage == "tavern", "allowed entry keeps requested page/town");
    }
}
reset(false);
C.m.Visible = true;
S.m.CharacterScreen = null;
expect(A.openLedger(), "native null character screen remains safe");

// Reproduce the player's town rejection using production canManage(), with
// nearby hostiles and the installed game's real F8/Escape/menu dispatch.
dofile("src/scripts/mods/afeix/core.nut");
S.m.CharacterScreen=C;
local enteredTown={alive=true,allied=true,
    function isAlive(){return this.alive;},function isMilitary(){return false;},
    function isAlliedWithPlayer(){return this.allied;},
    function getTile(){return {function getDistanceTo(tile){return 0;}};}};
local enemy={function isAlive(){return true;},function isAlliedWithPlayer(){return false;},function getTroops(){return [1];}};
local daylight=true,hostiles=false;
S.m.Player={function getTile(){return {};},function getPos(){return {};}};
S.m.WorldTownScreen.town=enteredTown;
::World.Assets.getOrigin <- function(){return {function getID(){return "scenario.afeix_expedition";}};};
::World.Assets.isCamping <- function(){return false;};
::World.EntityManager <- {function getSettlements(){return [enteredTown];}};
::World.getAllEntitiesAtPos <- function(pos,radius){return hostiles?[enemy]:[];};
::World.getTime <- function(){return {IsDaytime=daylight};};
foreach(isDay in [false,true])foreach(nearby in [true,false]) {
    daylight=isDay;hostiles=nearby;
    reset(true);
    expect(A.canManage()==!nearby,"existing management still rejects nearby enemies, day="+isDay);
    local depth=M.m.Stack.len(),restored=S.m.WorldTownScreen.restored;
    S.onKeyInput(key(78,1));
    expect(E.m.ActiveEvent==null,"F8 key-down does not fire early");
    expect(S.onKeyInput(key(78))&&E.m.ActiveEvent==event&&S.m.EventScreen.isVisible(),
        "native F8 opens entered tavern by day/night despite outside enemies");
    expect(M.m.Stack.len()==depth+1,"tavern ledger adds exactly one event backstep");
    expect(!A.openLedger(),"repeat F8 cannot stack town event");
    expect(S.onKeyInput(key(41))&&E.m.ActiveEvent==null&&!S.m.EventScreen.isVisible(),
        "Escape closes tavern ledger through native manager");
    expect(M.m.Stack.len()==depth&&S.m.WorldTownScreen.visible
        &&S.m.WorldTownScreen.restored==restored+1,"Escape restores the entered inn exactly once");
    expect(A.openLedger("tavern",42),"delayed/manual tavern entry also works near hostiles");
    S.onKeyInput(key(41));
}
foreach(reason in ["missing","dead","hostile","animating","locked menu"]) {
    reset(true);
    A.TavernTown=77;event.m.AutoPage="unchanged";
    local depth=M.m.Stack.len(),fires=event.fires;
    if(reason=="missing")S.m.WorldTownScreen.town=null;
    if(reason=="dead")enteredTown.alive=false;
    if(reason=="hostile")enteredTown.allied=false;
    if(reason=="animating")S.m.WorldTownScreen.animating=true;
    if(reason=="locked menu")M.m.Stack[0].allowCancel=false;
    expect(!A.openLedger("tavern",42),"invalid town/animation/menu remains blocked: "+reason);
    expect(E.m.ActiveEvent==null&&event.fires==fires&&M.m.Stack.len()==depth
        &&A.TavernTown==77&&event.m.AutoPage=="unchanged","rejected town entry has no UI state side effects: "+reason);
    S.m.WorldTownScreen.town=enteredTown;enteredTown.alive=true;enteredTown.allied=true;
    S.m.WorldTownScreen.animating=false;
}
print("TESTS_PASSED=" + checks + "\n");
