// Execute native world.startScriptedCombat, tactical state getters/exit,
// event.fire/processInput and event_manager.fire/processInput. Engine-owned
// rendering, rosters and persistence are explicit boundaries below.
::checks <- 0;
function check(v, label) { if (!v) throw "FAIL dream flow: " + label; ++::checks; }
::dreamTest <- { flags = {}, realActors = [], tempActors = [], origin = true, tactical = false, safe = true,
    virtualTime = 43210.0, realTime = 0.0, round = 1, saves = 0, nativeFinishes = 0, nativeBattleEnds = 0, nativeUpdates = 0, nativeAIUpdates = 0,
    equipmentSaves = 0, syncs = 0, errors = [], kills = 0, turnBarClears = 0, notices = [], monologues = 0,
    failBuild = false, failLaunch = false, lastDialog = null, finalFlagAtNativeFinish = false, tideCalls = [], killOrder = [] };
::Math <- { rand = function(...) { return 13579; } };
::Time <- { getVirtualTimeF = function() { return ::dreamTest.virtualTime; }, setVirtualTime = function(t) { ::dreamTest.virtualTime = t; },
    getRealTimeF = function() { return ::dreamTest.realTime; },
    getRound = function() { return ::dreamTest.round; } };
::Sound <- { stopAmbience = function() {}, setAmbience = function(...) {}, play = function(...) {} };
::Tooltip <- { hide = function() {} };
::Cursor <- { setCursor = function(...) {} };
::Stash <- { locked = false, setLocked = function(v) { this.locked = v; }, isLocked = function() { return this.locked; } };
::LoadingScreen <- { visible = false, shown = 0, isVisible = function() { return this.visible; }, isAnimating = function() { return false; },
    show = function() { ++this.shown; this.visible = true; }, hide = function() { this.visible = false; }, clearEventListener = function() {},
    setOnScreenShownListener = function(...) {}, setOnQueryDataListener = function(...) {} };
::Const <- { FatalityType = { None = 0 }, Combat = { MiasmaTimeout = 1, FireTimeout = 1, SmokeTimeout = 1 }, Faction = { Player = 1, Beasts = 8 }, FactionType = { Beasts = 4 }, UI = { Cursor = { Hand = 0 } },
    Events = { GlobalSound = "" }, World = { TerrainTacticalTemplate = ["tactical.plains"], SpeedSettings = { NormalMult = 1 } },
    Sound = { Volume = { Ambience = 1, AmbienceInTactical = 1 }, AmbienceMinDelay = 0, AmbienceMinDelayAtNight = 0 },
    Music = { BattleTracks = { [8] = ["battle"] } }, Tactical = { DeploymentType = { Line = 1 }, LocationTemplate = { Template = [null, null], ForceLineBattle = false }, CombatResult = { EnemyDestroyed = 1, EnemyRetreated = 2, PlayerDestroyed = 3, PlayerRetreated = 4 },
        CombatInfo = { getClone = function() { return { Tile = null, TerrainTemplate = null, LocationTemplate = null, PlayerDeploymentType = 0, EnemyDeploymentType = 0, CombatID = "", Music = [],
            IsAttackingLocation = false, IsLootingProhibited = false, IsFleeingProhibited = false, IsWithoutAmbience = false,
            IsFogOfWarVisible = true, IsUsingSetPlayers = false, IsPlayerInitiated = false, IsAutoAssigningBases = true, Entities = [], Players = [], Parties = [],
            Ambience = [[], []], AmbienceMinDelay = [0, 0] }; } } } };
::dreamTest.video <- { Width = 2560, Height = 1440 };
::Settings <- { getVideoMode = function() { return ::dreamTest.video; },
    getGameplaySettings = function() { return { RestoreEquipment = true }; } };
// Load the installed native troop definitions; engine entity IDs are an opaque
// boundary, while Row, Variant, Cost, Strength and Script stay native data.
::nativeTroopIDs <- {};
::Const.EntityType <- {};
::Const.EntityType.setdelegate({_get=function(key){
    if(!(key in ::nativeTroopIDs))::nativeTroopIDs[key]<-::nativeTroopIDs.len()+1;
    return ::nativeTroopIDs[key];
}});
::Const.Strings <- {};
::Const.Strings.setdelegate({_get=function(key){return [];}});
dofile(".cache/afei-art/dream-native/spawnlist_master.nut");
::Tactical <- { State = null, EventLog = { log = function(text) { ::dreamTest.notices.push(text); } }, isActive = function() { return ::dreamTest.tactical; }, setActive = function(v) { ::dreamTest.tactical = v; },
    TurnSequenceBar = { removeEntities = function() { ++::dreamTest.turnBarClears; } },
    Entities = { result = 1, getCombatResult = function() { return this.result; } } };
::logError <- function(text) { ::dreamTest.errors.push(text); };
::logDebug <- function(...) {};
::inherit <- function(path, object) {
    if (path == "scripts/events/event") {
        local result = clone ::event;
        foreach (k, v in object) result[k] <- v;
        result.m = clone ::event.m;
        foreach (k, v in object.m) result.m[k] <- v;
        result.setdelegate(getroottable());
        return result;
    }
    object.setdelegate(getroottable());
    return object;
};
dofile(".cache/afei-art/native-contract-fixture/world_state.nut");
dofile(".cache/afei-art/native-contract-fixture/tactical_state.nut");
dofile(".cache/afei-art/native-contract-fixture/event.nut");
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
dofile(".cache/afei-art/dream-native/dialog_screen.nut");
dofile(".cache/afei-art/dream-native/tactical_screen.nut");
::DialogScreen <- clone ::dialog_screen;
::DialogScreen.m = clone ::dialog_screen.m;
::DialogScreen.setdelegate(getroottable());
::DialogScreen.m.Visible = false; ::DialogScreen.m.Animating = false;
::DialogScreen.m.JSHandle = { asyncCall = function(method, data) {
    if (method == "show") {
        check(data.IsMonologue && data.Text.find("黑水") != null, "native single-button ending monologue");
        ++::dreamTest.monologues; ::DialogScreen.onScreenShown();
    } else if (method == "hide") ::DialogScreen.onScreenHidden();
} };
::hooks <- { exact = {}, instance = {} };
::mods_hookExactClass <- function(path, callback) { ::hooks.exact[path] <- callback; };
::mods_hookNewObject <- function(path, callback) { ::hooks.instance[path] <- callback; };
::new <- function(path) {
    if (path != "scripts/statistics/statistics_manager") throw "unexpected new " + path;
    return { flags = {}, getFlags = function() { return this.flags; } };
};
::AfeixExpedition <- {
    DouyuWorldChecked = false, DouyuWorldLocationID = 0, DouyuMapFocusQueued = false,
    douyuLocationCombatProperties = function(p) { return p; },
    updateDouyuWorld = function() {},
    douyuWorldIntel = function() { return "梦潮祭场位于城镇以北的荒野。"; },
    queueDouyuMapFocus = function() { if (!this.isOrigin() || this.isDreamCombat() || this.get("douyu_final_defeated", false)) return false; this.DouyuMapFocusQueued = true; return true; },
    isOrigin = function() { return ::dreamTest.origin; },
    get = function(key, fallback = 0) { return key in ::dreamTest.flags ? ::dreamTest.flags[key] : fallback; },
    set = function(key, value) { ::dreamTest.flags[key] <- value; return value; },
    roster = function() { return ::dreamTest.realActors; },
    characterId = function(actor) { return actor.key; },
    findCharacter = function(key) { foreach (a in this.roster()) if (a.key == key) return a; return null; },
    route = function() { return this.get("afei_route", "normal"); },
    syncCharacterFeatures = function(a) { ++::dreamTest.syncs; },
    canManage = function() { return ::dreamTest.safe; },
    ledgerOption = function(label, action) { return { Text = label, Action = action, getResult = function(e) { return this.Action(e); } }; },
    buildDreamRoster = function(roster) {
        if (::dreamTest.failBuild) throw "construction failed";
        local actors = [];
        foreach (key in ["afei", "damou", "mocha", "bottle", "shuaizi", "lili", "xiaoyueya", "yuchujiu", "xiaoyubeike", "wangduidui"]) {
            local actor = { key = key, alive = true,
                isAlive = function() { return this.alive; }, isDying = function() { return false; }, isPlacedOnMap = function() { return this.alive; },
                kill = function(...) { check(::dreamTest.turnBarClears > 0, "native selection cleared before death callback"); this.alive = false; ++::dreamTest.kills; ::dreamTest.killOrder.push(this.key); ::Tactical.State.onBattleEnded(); },
                getFlags = function() { return { get = function(k) { return k == "afeix_dream_actor"; } }; } };
            actors.push(actor); ::dreamTest.tempActors.push(actor);
        }
        return actors;
    }
};
dofile("src/scripts/mods/afeix/dream_flow.nut");
dofile("src/scripts/mods/afeix/dream_tide.nut");
dofile("src/scripts/mods/afeix/dream_ledger.nut");
dofile("src/scripts/mods/afeix/dream_hooks.nut");
dofile("src/scripts/events/events/afeix_dream_event.nut");
::World <- { State = null, Events = null, Statistics = null,
    Assets = { m = { Money = 1800, ArmorParts = 30, Medicine = 10, Ammo = 40 }, isIronman = function() { return false; }, saveEquipment = function() { ++::dreamTest.equipmentSaves; } },
    getTemporaryRoster = function() { return { remove = function(a) { local i = ::dreamTest.tempActors.find(a); if (i != null) ::dreamTest.tempActors.remove(i); } }; },
    getPlayerRoster = function() { return { getAll = function() { return ::dreamTest.realActors; } }; },
    FactionManager = { getFactionOfType = function(type) { return { getID = function() { return 8; } }; } },
    getTime = function() { return { IsDaytime = true }; }, setSpeedMult = function(...) {},
    save = function(...) { ++::dreamTest.saves; } };
::hooks.instance["states/world/asset_manager"](::World.Assets);
::RootState <- { add = function(name, path) {
    if (::dreamTest.failLaunch) throw "engine state allocation failed";
    local t = clone ::tactical_state; t.m = clone ::tactical_state.m; t.setdelegate(getroottable());
    t.onBattleEnded = function() { ++::dreamTest.nativeBattleEnds; };
    t.onUpdate = function() { ++::dreamTest.nativeUpdates; };
    t.onProcessAI = function() { ++::dreamTest.nativeAIUpdates; };
    t.isInLoadingScreen = function() { return false; };
    t.m.MenuStack = { popAll = function() {} };
    local screen = clone ::tactical_screen; screen.m = clone ::tactical_screen.m; screen.setdelegate(getroottable());
    screen.m.JSHandle = { asyncCall = function(method, data) {
        if(method.find("afeix") == 0) ::dreamTest.tideCalls.push({method=method,data=data});
    } };
    t.m.TacticalScreen = screen;
    t.m.TacticalDialogScreen = { isVisible = function() { return false; }, isAnimating = function() { return false; } };
    ::hooks.exact["states/tactical_state"](t);
    ::Tactical.State = t; ::dreamTest.tactical = true;
    return t;
} };
function resetDream() {
    local d = ::dreamTest, A = ::AfeixExpedition;
    if (A.isDreamCombat()) A.restoreDreamSession();
    d.flags = { afei_route = "jiahao", progress_contracts = 2, dead_afei = false };
    d.origin = true; d.tactical = false; d.safe = true; d.virtualTime = 43210.0; d.realTime = 0.0; d.round = 1;
    d.saves = 0; d.nativeFinishes = 0; d.nativeBattleEnds = 0; d.nativeUpdates = 0; d.nativeAIUpdates = 0; d.equipmentSaves = 0;
    d.failBuild = false; d.failLaunch = false; d.lastDialog = null; d.tempActors = []; d.kills = 0; d.turnBarClears = 0; d.finalFlagAtNativeFinish = false;
    d.notices = []; d.monologues = 0; d.tideCalls = []; d.killOrder = []; ::DialogScreen.m.Visible = false; ::DialogScreen.m.Animating = false;
    d.realActors = [];
    foreach (key in ["afei", "damou", "mocha"]) d.realActors.push({ key = key, level = 1, hp = 50, xp = 0, battles = 0, equipment = ["original"],
        isAlive = function() { return true; }, isDying = function() { return false; }, getPlaceInFormation = function() { return 3; },
        getImagePath = function() { return "portrait_" + this.key; } });
    A.resetDreamRuntime();
    ::World.Assets.m = { Money = 1800, ArmorParts = 30, Medicine = 10, Ammo = 40 };
    ::World.Statistics = { marker = "real statistics", flags = { LastCombatID = 7, BeastsDefeated = 2 } };
    ::Stash.locked = false; ::LoadingScreen.visible = false; ::LoadingScreen.shown = 0; ::Tactical.State = null;
    local w = clone ::world_state; w.m = clone ::world_state.m; w.setdelegate(getroottable());
    w.m.Player = { getTile = function() { return { TacticalType = 0 }; } };
    w.m.MenuStack = { steps = [], hasBacksteps = function() { return this.steps.len() > 0; },
        push = function(fn, can) { this.steps.push(fn); }, pop = function(force = false) { if (this.steps.len() > 0) this.steps.pop().bindenv(::World.State)(); },
        isAllowingCancel = function() { return true; } };
    w.m.EventScreen = { visible = false, isVisible = function() { return this.visible; }, isAnimating = function() { return false; },
        show = function(e) { this.visible = true; }, hide = function() { this.visible = false; }, setIsContract = function(v) {} };
    w.m.WorldScreen = { show = function() {}, hide = function() {} };
    w.setPause = function(v) { this.m.IsGamePaused = v; };
    w.setAutoPause = function(v) { this.m.IsGameAutoPaused = v; };
    w.isPaused = function() { return this.m.IsGamePaused || this.m.IsGameAutoPaused; };
    w.setNormalTime = function() {};
    w.isInCharacterScreen = function() { return false; };
    w.updateTopbarAssets = function() {};
    w.visible <- true;
    w.isVisible <- function() { return this.visible; };
    w.show <- function() { this.visible = true; ::LoadingScreen.hide(); };
    w.hide <- function() { this.visible = false; };
    w.setWorldmapMusic = function(v) {};
    w.getSurroundingAmbienceSounds = function() { return []; };
    w.showCombatDialog = function(...) { ::dreamTest.lastDialog = vargv; };
    w.onUpdate = function() {};
    w.onDeserialize = function(input) {};
    w.onCombatFinished = function() { ++::dreamTest.nativeFinishes; ::dreamTest.finalFlagAtNativeFinish = ::AfeixExpedition.get("douyu_final_defeated", false); };
    w.sendMessageToSiblings <- function(msg) { if (msg == "FullyLoaded") ::Tactical.State = null; };
    ::hooks.exact["states/world_state"](w);
    ::World.State = w;
    local event = clone ::afeix_dream_event; event.m = clone ::afeix_dream_event.m; event.setdelegate(getroottable()); event.create();
    local manager = clone ::event_manager; manager.m = clone ::event_manager.m; manager.setdelegate(getroottable());
    manager.m.Events = [event]; manager.m.ActiveEvent = null; ::World.Events = manager;
}
function assertReality(label) {
    local A = ::AfeixExpedition, d = ::dreamTest;
    check(::World.getPlayerRoster().getAll() == d.realActors && d.realActors.len() == 3, label + " same real roster objects");
    foreach (a in d.realActors) check(a.level == 1 && a.hp == 50 && a.xp == 0 && a.battles == 0 && a.equipment[0] == "original", label + " untouched " + a.key);
    check(::World.Assets.m.Money == 1800 && ::World.Assets.m.ArmorParts == 30 && ::World.Assets.m.Medicine == 10 && ::World.Assets.m.Ammo == 40, label + " resources restored");
    check(A.route() == "jiahao" && A.get("dead_afei") == false && A.get("progress_contracts") == 2, label + " real progression preserved");
    check(::World.Statistics.marker == "real statistics" && ::World.Statistics.flags.LastCombatID == 7 && ::World.Statistics.flags.BeastsDefeated == 2, label + " real stats preserved");
    check(d.tempActors.len() == 0 && !::Stash.locked && !A.isDreamCombat(), label + " no temporary actors or lock");
}
resetDream(); local A = ::AfeixExpedition;
check(A.initializeDreamOpening() && !A.initializeDreamOpening(), "opening initialization is idempotent");
check(A.openDreamIntro(), "native event fire opens intro");
check(::World.Events.m.ActiveEvent.m.ActiveScreen.Options.len() == 2, "story or skip choices");
::World.Events.processInput(1); check(A.dreamStatus() == "skipped" && ::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "wake", "skip retains scripted defeat story");
check(A.get("dream_wake_pending") && A.dreamPage(null,"wake").Text.find("全军覆没") != null,"skip cannot bypass dream defeat");
::World.Events.processInput(0); check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "departure", "skip proceeds from defeat to departure");
::World.Events.processInput(0); check(!::World.Events.hasActiveEvent() && A.get("dream_story_seen"), "departure closes after acknowledgment");
check(!A.skipDream() && !A.openDreamIntro(), "skip cannot apply twice"); assertReality("skip");

resetDream(); A.initializeDreamOpening();
for (local stage = 0; stage < 4; ++stage) {
    check(A.openDreamIntro(), "open stage " + stage);
    if (stage == 0) {
        ::World.Events.processInput(0);
        check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "opening_dream" && A.get("dream_intro_page") == "opening_dream", "story moves to shared dream before launching battle");
    }
    ::World.Events.processInput(0);
    check(!::World.Events.hasActiveEvent() && A.DreamLaunchRequest != null, "native event closes before launch " + stage);
    A.updateDreamWorld();
    check(A.isDreamCombat() && ::Tactical.State == null && ::LoadingScreen.visible, "deferred native loading callback " + stage);
    ::World.State.loading_screen_onScreenShown();
    local t = ::Tactical.State, p = t.getStrategicProperties(), real = ::dreamTest.realActors;
    check(A.isDreamCombat() && t.isScenarioMode() && t.m.Scenario == null, "scenario safety without changing native generation " + stage);
    check(p.IsUsingSetPlayers && p.Players.len() == 10 && ::World.getPlayerRoster().getAll() == real, "explicit temporary ten actors " + stage);
    check(!p.IsAutoAssigningBases,"scenario faction slots never index beyond the real campaign factions " + stage);
    check(p.CombatID == "afeix_dream_" + A.DreamStages[stage].id && p.Entities.len() == A.DreamStages[stage].count, "ordered enemy wave " + stage);
    check(p.TerrainTemplate == "tactical.swamp" && p.LocationTemplate == null && !p.IsFleeingProhibited, "independent native swamp with normal retreats " + stage);
    check(p.PlayerDeploymentType == 1 && p.EnemyDeploymentType == 1, "ordinary lines regardless of real world terrain " + stage);
    check(::Const.Tactical.LocationTemplate.Template[0] == null, "native template constant not mutated " + stage);
    check(::dreamTest.saves == stage + 1 && ::dreamTest.equipmentSaves == 0 && ::Stash.locked, "only pre-dream save; no equipment snapshot " + stage);
    check(!::World.State.isUsingGuests(), "no real guests in dream " + stage);
    check(A.route() == "feidie" && A.findCharacter("afei") != real[0] && A.roster().len() == 10, "local dream route/roster " + stage);
    A.set("dead_afei", true); A.set("progress_contracts", 999);
    ::World.Statistics.flags.LastCombatID <- 888;
    ::World.Assets.m.Money = 1; ::World.Assets.m.Ammo = 0;
    ::World.State.autosave(); check(::dreamTest.saves == stage + 1 && ::World.State.saveCampaign("bad") == false, "save entry blocked before file open " + stage);
    local rejected = false; try { ::World.State.onSerialize({}); } catch (e) { rejected = true; } check(rejected, "direct serialization fails closed " + stage);
    if (stage == 3) {
        foreach (round in [1,3,5]) {
            ::dreamTest.round = round; t.onUpdate();
            local count = ::dreamTest.notices.len(); t.onUpdate();
            check(!A.DreamSession.ending && ::dreamTest.notices.len() == count, "tide forecast is once per phase and still allows play " + round);
        }
        check(::dreamTest.notices.len() == 3 && ::dreamTest.kills == 0, "three increasing tide forecasts before any scripted death");
        ::dreamTest.round = 6; t.onUpdate();
        check(A.DreamSession.ending && !A.DreamSession.victory && A.DreamSession.wake == "douyu", "boss dream ends after five playable rounds");
        check(::dreamTest.kills == 0 && ::DialogScreen.isVisible() && ::dreamTest.monologues == 1, "narration precedes mass death");
        ::dreamTest.virtualTime += 30; t.onUpdate(); t.onBattleEnded();
        check(!A.DreamSession.exitStarted && ::dreamTest.kills == 0 && ::dreamTest.monologues == 1, "reading time and native reentry cannot bypass or duplicate narration");
        ::DialogScreen.onOkPressed();
        check(::dreamTest.kills == 0 && A.DreamSession.tide != null,"water animation starts before any scripted deaths");
        ::dreamTest.realTime += 3.41; t.onUpdate();
        check(::dreamTest.kills == 10 && !A.DreamSession.exitStarted,"all temporary actors fall before returning");
        foreach (actor in A.DreamSession.actors) check(!actor.isAlive(),"scripted defeat leaves no dream survivor");
        t.onBattleEnded(); check(::dreamTest.kills == 10,"native death reentry cannot repeat scripted defeat");
        ::dreamTest.realTime += 1.2; t.onUpdate();
    } else {
        ::Tactical.Entities.result = ::Const.Tactical.CombatResult.EnemyDestroyed; t.onBattleEnded();
        check(A.DreamSession.victory, "non-boss victory advances");
    }
    check(::dreamTest.nativeBattleEnds == 0 && ::LoadingScreen.shown > 0, "native settlement and loot gathering bypassed");
    ::World.State.onReturnedFromTactical();
    check(::dreamTest.nativeFinishes == 0 && ::dreamTest.virtualTime == 43210.0, "native world battle count and clock unchanged");
    assertReality("stage " + stage);
}
check(A.dreamStatus() == "complete" && A.get("dream_wake_pending") && A.get("douyu_final_unlocked"), "wake unlocks real final encounter");
A.updateDreamWorld(); check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "wake", "wake narrative displayed once");
::World.Events.processInput(0); check(!A.get("dream_wake_pending"), "wake acknowledgment persists");
check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "departure" && A.get("dream_departure_pending"), "wake continues to background in the same event");
::World.Events.processInput(0); check(A.get("dream_story_seen") && !A.get("dream_departure_pending"), "departure completion persists");
A.updateDreamWorld(); check(!::World.Events.hasActiveEvent(), "wake does not repeatedly reopen");

foreach (cause in ["retreat", "skip", "early loss", "boss victory"]) {
    resetDream(); A.initializeDreamOpening(); A.set("dream_stage", cause == "boss victory" ? 3 : 0);
    check(A.startDreamCombat(A.dreamStage()), "launch cancellation case " + cause);
    ::World.State.loading_screen_onScreenShown();
    local t = ::Tactical.State;
    if (cause == "retreat") t.flee();
    else if (cause == "skip") t.main_menu_module_onQuitPressed();
    else { ::Tactical.Entities.result = cause == "boss victory" ? 1 : 3; t.onBattleEnded(); }
    check(A.DreamSession.ending && !A.DreamSession.victory, "cancellation/defeat cannot grant dream victory " + cause);
    check(::dreamTest.kills == 0 && ::DialogScreen.isVisible(), "every alternate ending receives a narrative bridge " + cause);
    if (cause == "boss victory") check(A.dreamEndingText(A.DreamSession.endingCause).find("斗鱼终于倒下") != null, "early boss kill acknowledges victory before the rising water");
    if (cause == "retreat") {
        check(t.onKeyInput({getState=function(){return 0;},getKey=function(){return 41;}}), "Escape safely continues ending monologue");
    } else ::DialogScreen.onOkPressed();
    check(::dreamTest.kills == 0 && A.DreamSession.tide != null,"alternate ending starts water tableau before deaths " + cause);
    ::dreamTest.realTime += 3.41; t.onUpdate();
    check(::dreamTest.kills == 10 && A.DreamSession.wake == "douyu", "every exit is the same scripted party defeat " + cause);
    ::dreamTest.realTime += 1.2; t.onUpdate();
    check(A.DreamSession.exitStarted,"death presentation completes safely " + cause);
    ::World.State.onReturnedFromTactical(); assertReality(cause);
    check(A.dreamStatus() == "complete", "returns to playable campaign " + cause);
}
foreach (fail in ["build", "launch", "seeded launch"]) {
    resetDream(); A.initializeDreamOpening(); ::dreamTest.failBuild = fail == "build"; ::dreamTest.failLaunch = fail != "build";
    local beforeSeed = fail == "seeded launch" ? 2468 : 0;
    ::World.State.m.CombatSeed = beforeSeed;
    ::World.State.m.LastWorldSpeedMult = 3.25;
    local scheduled = A.startDreamCombat(0);
    if (fail != "build") { check(scheduled && ::Tactical.State == null, "launch failure deferred to native loading callback"); ::World.State.loading_screen_onScreenShown(); }
    else check(!scheduled, "build failure caught");
    assertReality("failed " + fail);
    check(::dreamTest.virtualTime == 43210.0 && ::World.State.m.CombatSeed == beforeSeed && ::World.State.m.CombatStartTime == 0 && ::World.State.m.LastWorldSpeedMult == 3.25, "failure restores clock and native combat seed " + fail);
    check(!::LoadingScreen.visible && ::World.State.visible && A.dreamWorldReady(), "failure restores visible usable world " + fail);
    check(A.dreamStatus() == "pending" && A.DreamOpeningQueued, "failed launch offers safe retry or skip " + fail);
    check(A.dreamPage(null, "opening").Text.find("梦境没能展开") != null, "opening page displays launch failure " + fail);
}
resetDream(); local unseen = A.dreamPage(null, "dream_final");
check(unseen.Options.len() == 3 && unseen.Options[0].Text.find("回看") != null && unseen.Options[1].Text.find("地图") != null, "old saves offer optional dream replay and real location intel");
unseen.Options[0].getResult(null); check(A.dreamStatus() == "pending" && A.DreamOpeningQueued, "old-save replay queues opening");
::World.State.m.LastEnteredTown = {};
::World.State.m.WorldTownScreen = { visible = true, isVisible = function() { return this.visible; }, isAnimating = function() { return false; } };
::World.State.m.MenuStack.push(function() { this.m.WorldTownScreen.visible = false; this.m.LastEnteredTown = null; }, true);
A.updateDreamWorld(); check(!::World.State.m.WorldTownScreen.visible && !::World.Events.hasActiveEvent() && A.DreamOpeningQueued, "replay safely leaves native town first");
A.updateDreamWorld(); check(::World.Events.hasActiveEvent() && !A.DreamOpeningQueued, "replay opens intro after town closes");
resetDream(); ::dreamTest.safe = false;
local unsafe = A.dreamPage(null, "dream_final"); check(unsafe.Options.len() == 2 && unsafe.Text.find("友好城镇") != null && unsafe.Text.find("扎营") != null, "unsafe old saves show replay safety condition and map intel");
A.set("douyu_final_unlocked", true); unsafe = A.dreamPage(null, "dream_final");
check(unsafe.Options.len() == 3 && unsafe.Text.find("从大陆前往") != null && unsafe.Options[0].Text.find("地图") != null, "final page provides world intel and read-only background review");
unsafe.Options[0].getResult(null); check(A.DouyuMapFocusQueued && ::World.State.m.CombatProperties == null, "ledger map marker cannot start remote combat");
resetDream(); A.initializeDreamOpening(); ::dreamTest.origin = false;
check(!A.openDreamIntro() && !A.startDreamCombat(0) && !A.skipDream() && !A.queueDouyuMapFocus(), "other origins inert");
::dreamTest.origin = true; ::World.State.onDeserialize({});
check(A.DreamOpeningQueued && A.DreamLaunchRequest == null && !A.isDreamCombat(), "load resumes only persistent pending stage");
A.skipDream(); ::World.State.onDeserialize({}); check(!A.DreamOpeningQueued, "load does not repeat skipped dream");
local finalProperties = A.dreamCombatProperties(3, false);
check(finalProperties.IsAutoAssigningBases,"real final keeps campaign faction base assignment");
check(::World.State.startScriptedCombat(finalProperties, true, true, true), "normal native final combat fixture prepares campaign battle");
check(::World.State.m.CombatProperties.CombatID == "afeix_douyu_final" && !::World.State.m.CombatProperties.IsUsingSetPlayers, "final keeps free campaign formation");
check(::dreamTest.lastDialog != null && ::dreamTest.lastDialog[2] == true, "native final formation picking retained");
check(::World.State.startScriptedCombat(), "native final combat starts");
check(!::Tactical.State.isScenarioMode() && !A.isDreamCombat(), "final has normal campaign consequences");
::Tactical.Entities.result = 1; ::Tactical.State.onBattleEnded();
check(::dreamTest.nativeBattleEnds == 1 && A.FinalDouyuResult == true, "real victory uses native loot/results");
::World.State.onReturnedFromTactical();
check(::dreamTest.nativeFinishes == 1 && A.get("douyu_final_defeated") && A.get("douyu_final_notice"), "real victory records ending once");
check(::dreamTest.finalFlagAtNativeFinish, "final ending committed before native Ironman settlement autosave");
check(!A.finishFinalDouyu() && !A.queueDouyuMapFocus(), "no repeated final reward/map request");
print("TESTS_PASSED=" + ::checks + "\n");
