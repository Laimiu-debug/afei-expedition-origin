// Dream actors live only in the native temporary roster. The campaign roster
// is never exchanged, rebuilt, levelled, healed or stripped of its equipment.
local A = ::AfeixExpedition;
A.DreamSession <- null;
A.DreamLaunchRequest <- null;
A.DreamOpeningQueued <- false;
A.FinalDouyuResult <- null;
A.DreamStoryDismissed <- false;
A.DreamStoryReviewQueued <- false;
A.resetDreamRuntime <- function() {
    // Only lifecycle boundaries (new campaign/load) call this. No persistent
    // campaign flag, actor, equipment or resource is modified here.
    if("clearDreamTide" in this) this.clearDreamTide();
    this.DreamSession = null;
    this.DreamLaunchRequest = null;
    this.DreamOpeningQueued = false;
    this.FinalDouyuResult = null;
    this.DreamStoryDismissed = false;
    this.DreamStoryReviewQueued = false;
    if ("DouyuWorldChecked" in this) this.DouyuWorldChecked = false;
    if ("DouyuWorldLocationID" in this) this.DouyuWorldLocationID = 0;
    if ("DouyuMapFocusQueued" in this) this.DouyuMapFocusQueued = false;
};
A.DreamStages <- [
    { id = "spiders", name = "蛛网之间", text = "火光照出了蛛网。十个熟悉又陌生的身影各自站定，传奇兵器握在手中，像已经同行了很久。先撕开蛛网，看看这支队伍怎样互相接应。", script = "scripts/entity/tactical/enemies/spider", count = 5 },
    { id = "wolves", name = "狼影逼近", text = "蛛网散了，梦沼中的空地又完整地浮现出来，爪声随后响起。恐狼从两侧绕来，前排需要守住缺口，后排也得找好下一步的退路。\n\n抹茶低头看了一眼靴边：方才还是干地的地方，已经覆上了一层薄水。远处响起的潮声，比狼嚎更低，也更久。", script = "scripts/entity/tactical/enemies/direwolf", count = 4 },
    { id = "lindwurm", name = "梦中的长鳞", text = "地面忽然鼓起。林德虫盘住前路，头尾同时逼近。十人的传奇装备仍然明亮，这一次，站位与轮换比追着伤害跑更重要。\n\n大谋往身后看去。狼群跑来的泥路已经消失在水里，远处的树像在慢慢下沉。‘打完就往高处走。’他把盾举得更稳了一些。", script = "scripts/entity/tactical/enemies/lindwurm", count = 1 },
    { id = "douyu", name = "斗鱼·深渊之主", text = "林德虫倒下后，水声从梦沼四周涌来。橙色背鳍从雾中抬起，礼炮映着火光。\n\n抹茶蹲下摸了摸水面：‘水在往上走。不是它打出来的浪，整片沼泽都在涨。’大谋望向来路，方才走过的浅滩已经不见了。\n\n阿飞把黑旗插稳：‘先站在一起。就算路没了，也别让谁一个人落在后面。’十人重新站定。斗鱼可以被伤到，脚下这场梦却正在一点点沉下去。", script = "scripts/entity/tactical/enemies/afeix_douyu", count = 1 }
];
A.isDreamCombat <- function() { return this.DreamSession != null; };
A.dreamStage <- function() { return this.get("dream_stage", 0); };
A.dreamStatus <- function() { return this.get("dream_status", "unseen"); };
A.dreamWorldReady <- function() {
    if (!this.isOrigin() || this.isDreamCombat() || ::World.State == null || ::World.Events == null || ::Tactical.isActive()) return false;
    local state = ::World.State;
    if (("State" in ::Tactical) && ::Tactical.State != null) return false;
    if (state.getPlayer() == null || state.getCombatStartTime() != 0 || ::World.Events.hasActiveEvent()) return false;
    if (("LoadingScreen" in getroottable()) && ::LoadingScreen != null && (::LoadingScreen.isVisible() || ::LoadingScreen.isAnimating())) return false;
    if (state.isInCharacterScreen() || state.m.MenuStack.hasBacksteps()) return false;
    return state.m.EventScreen != null && !state.m.EventScreen.isVisible() && !state.m.EventScreen.isAnimating();
};
A.initializeDreamOpening <- function() {
    if (!this.isOrigin()) return false;
    if (this.dreamStatus() != "unseen") return false;
    this.set("dream_status", "pending");
    this.set("dream_stage", 0);
    this.set("dream_intro_page", "opening");
    this.DreamStoryDismissed = false;
    this.DreamOpeningQueued = true;
    return true;
};
A.openDreamIntro <- function() {
    if (!this.dreamWorldReady() || this.dreamStatus() != "pending" || this.DreamStoryDismissed) return false;
    local event = ::World.Events.getEvent("event.afeix_dream");
    if (event == null) return false;
    local intro = this.get("dream_intro_page", "opening");
    event.m.Page = this.dreamStage() == 0 ? (intro == "opening_dream" ? intro : "opening") : "stage";
    if (!::World.Events.fire("event.afeix_dream", false)) return false;
    this.DreamOpeningQueued = false;
    return true;
};
A.skipDream <- function() {
    if (!this.isOrigin() || this.isDreamCombat()) return false;
    if (this.dreamStatus() != "pending") return false;
    this.set("dream_status", "skipped");
    this.set("dream_stage", 0);
    this.set("douyu_final_unlocked", true);
    this.set("dream_wake_reason", "douyu");
    this.set("dream_wake_pending", true);
    this.set("dream_departure_pending", false);
    this.DreamLaunchRequest = null;
    this.DreamOpeningQueued = false;
    this.DreamStoryDismissed = false;
    return true;
};
A.dismissDreamStory <- function() {
    this.DreamStoryDismissed = true;
    this.DreamOpeningQueued = false;
    this.DreamStoryReviewQueued = false;
};
A.closeDreamStory <- function(state) {
    if (!this.isOrigin() || ::Tactical.isActive() || ::World.Events == null) return false;
    local event = ::World.Events.m.ActiveEvent;
    if (event == null || event.getID() != "event.afeix_dream") return false;
    if (state.m.EventScreen == null || !state.m.EventScreen.isVisible() || state.m.EventScreen.isAnimating()) return true;
    ::World.Events.processInput(-1);
    return true;
};
A.resumeDreamStory <- function() {
    if (!this.isOrigin() || this.isDreamCombat()) return false;
    this.DreamStoryDismissed = false;
    if (this.dreamStatus() == "pending") this.DreamOpeningQueued = true;
    return true;
};
A.queueDepartureStoryReview <- function() {
    if (!this.isOrigin() || this.isDreamCombat()) return false;
    this.DreamStoryDismissed = false;
    this.DreamStoryReviewQueued = true;
    return true;
};
A.queueDreamCombat <- function() {
    if (!this.isOrigin() || this.isDreamCombat() || this.dreamStatus() != "pending" || this.DreamLaunchRequest != null) return false;
    local stage = this.dreamStage();
    if (stage < 0 || stage >= this.DreamStages.len()) return false;
    this.DreamOpeningQueued = false;
    this.DreamStoryDismissed = false;
    this.DreamLaunchRequest = { kind = "dream", stage = stage };
    return true;
};
A.dreamCombatProperties <- function(stage, dream) {
    local d = this.DreamStages[stage], p = ::Const.Tactical.CombatInfo.getClone();
    p.Tile = ::World.State.getPlayer().getTile();
    // Native swamp is a fixed independent stage with normal walkable borders.
    // The arena template has a complete two-level wall, trapping ordinary
    // campaign retreats. Explicit line deployment avoids world-tile ambushes.
    p.TerrainTemplate = "tactical.swamp";
    p.LocationTemplate = null;
    p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
    p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Line;
    p.CombatID = dream ? "afeix_dream_" + d.id : "afeix_douyu_final";
    p.Music = ::Const.Music.BattleTracks[::Const.Faction.Beasts];
    p.IsAttackingLocation = false;
    p.IsLootingProhibited = dream;
    p.IsFleeingProhibited = false;
    p.IsWithoutAmbience = true;
    p.IsFogOfWarVisible = true;
    p.IsUsingSetPlayers = dream;
    // Scenario safety allocates 32 tactical faction slots; the campaign may
    // have fewer factions. Native arena encounters disable this same pass.
    p.IsAutoAssigningBases = !dream;
    local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID();
    local troopKeys = ["Spider", "Direwolf", "Lindwurm", "Unhold"];
    for (local i = 0; i < d.count; ++i) {
        // Native formation reads Row and ID, and setup/death retain the world
        // troop. Clone the complete native definition for every enemy.
        local troop = clone ::Const.World.Spawn.Troops[troopKeys[stage]];
        troop.Script = d.script;
        troop.Faction <- faction;
        troop.Party <- null;
        troop.Variant = 0;
        p.Entities.push(troop);
    }
    return p;
};
A.startDreamCombat <- function(stage) {
    if (!this.dreamWorldReady() || this.dreamStatus() != "pending" || stage != this.dreamStage()) return false;
    local p = this.dreamCombatProperties(stage, true), temporary = ::World.getTemporaryRoster();
    local session = {
        stage = stage, actors = [], flags = { hide_helmets = this.get("hide_helmets", true) }, statistics = ::World.Statistics,
        dreamStatistics = null, ending = false, victory = false, wake = "", exitStarted = false, exitAt = 0.0,
        lastTideNotice = -1, narrationPending = false, collapseStarted = false, endingCause = "", tide = null,
        startClock = ::Time.getVirtualTimeF(), startSeed = ::World.State.m.CombatSeed,
        lastWorldSpeed = ::World.State.m.LastWorldSpeedMult,
        resources = { Money = ::World.Assets.m.Money, ArmorParts = ::World.Assets.m.ArmorParts,
            Medicine = ::World.Assets.m.Medicine, Ammo = ::World.Assets.m.Ammo }
    };
    // The only dream save point is before temporary actors and managers exist.
    // Reloading it repeats this stage; it cannot promote imaginary equipment.
    try {
        ::World.State.autosave();
        this.DreamSession = session;
        session.dreamStatistics = ::new("scripts/statistics/statistics_manager");
        ::World.Statistics = session.dreamStatistics;
        session.actors = this.buildDreamRoster(temporary);
        p.Players = session.actors;
        ::World.State.setPause(true);
        if (!::World.State.startScriptedCombat(p, false, false, false)) throw "dream combat launch refused";
        // Native LoadingScreen.onShown starts the tactical state. Starting it
        // immediately would race that callback and replace its UI listener.
        return true;
    } catch (error) {
        return this.failDreamCombat(error, session);
    }
};
A.failDreamCombat <- function(error, session = null) {
    local s = session == null ? this.DreamSession : session;
    if (s == null) return false;
    this.restoreDreamSession();
    ::Time.setVirtualTime(s.startClock);
    ::World.State.m.CombatProperties = null;
    ::World.State.m.CombatStartTime = 0;
    ::World.State.m.CombatSeed = s.startSeed;
    ::World.State.m.LastWorldSpeedMult = s.lastWorldSpeed;
    ::Stash.setLocked(false);
    ::World.State.initLoadingScreenHandler();
    ::LoadingScreen.hide();
    ::World.State.show();
    ::World.State.setPause(true);
    ::logError("[AfeixExpedition] Dream launch failed safely: " + error);
    this.set("dream_notice", "梦境没能展开。三人的现实状态已经保留，可以重试或跳过。\n\n" );
    this.DreamOpeningQueued = true;
    return false;
};
A.restoreDreamSession <- function() {
    local s = this.DreamSession;
    if("clearDreamTide" in this) this.clearDreamTide();
    if (s == null) return false;
    ::World.Statistics = s.statistics;
    foreach (key, value in s.resources) ::World.Assets.m[key] = value;
    foreach (actor in s.actors) ::World.getTemporaryRoster().remove(actor);
    this.DreamSession = null;
    return true;
};
A.requestDreamWake <- function(reason = "wake") {
    if (!this.isDreamCombat() || this.DreamSession.ending) return false;
    this.DreamSession.wake = reason;
    return true;
};
A.updateDreamTide <- function() {
    if (!this.isDreamCombat() || this.DreamSession.ending || this.DreamSession.stage != 3) return;
    local s = this.DreamSession, round = ::Time.getRound();
    local notices = [
        { round = 1, text = "抹茶：‘水还在涨。大家留在黑旗附近，别落单。’" },
        { round = 3, text = "大谋：‘来路淹了！向黑旗收拢，我接着你们。’黑水漫过浅滩，远处的树影正在消失。" },
        { round = 5, text = "阿飞：‘最后一程，站在一起！’水已漫到旗杆，梦沼只剩黑旗下的一小片落脚处。" }
    ];
    foreach (i, notice in notices) if (round >= notice.round && i > s.lastTideNotice) {
        s.lastTideNotice = i;
        ::Tactical.EventLog.log(notice.text);
    }
    if (round >= 6) this.requestDreamWake("douyu");
};
A.dreamEndingText <- function(cause) {
    local lead = cause == "victory" ? "斗鱼终于倒下，十人刚要喘息，水却仍在上涨。那道背鳍不再动了，雾后的海潮没有停。"
        : (cause == "retreat" || cause == "skip" ? "黑旗开始向来路退去，大谋留在最后接应。可是来时的浅滩已经沉入黑水，梦里再也找不到岸。"
        : (cause == "defeat" ? "战线被撕开，大谋仍伸手去接倒下的同伴。黑水却越过缺口，连退后的落脚处也一起吞没。"
        : "第五次交锋过去，水已经漫过旗杆。礼炮还在雾中发亮，十人脚下的最后一片土地却缓缓碎开。"));
    return lead + "\n\n抹茶把账本塞回怀里：‘不是兵器不够好……这场梦，没有留给我们回去的路。’\n\n大谋撑住盾：‘靠过来。谁都别一个人沉下去。’阿飞攥紧黑旗，把还能站住的人拉到身旁。熟悉的名字在潮声里一个接一个响起，最后只剩彼此的手。\n\n黑水终于越过盾沿。十人守到了最后，梦也走到了尽头。";
};
A.showDreamEnding <- function(state) {
    if (!this.isDreamCombat() || !this.DreamSession.narrationPending) return false;
    if (::DialogScreen.isVisible() || ::DialogScreen.isAnimating()
        || state.m.TacticalDialogScreen.isVisible() || state.m.TacticalDialogScreen.isAnimating()) return false;
    local A = this, session = this.DreamSession;
    session.narrationPending = false;
    // Native monologue has one continuation button. Death follows its hidden
    // callback, so reading speed cannot skip the transition or race the UI.
    ::DialogScreen.show("黑旗与最后一道潮", this.dreamEndingText(session.endingCause), function() {
        if (A.DreamSession == session) A.collapseDreamTactical(state);
    }, function() {}, function() {}, true);
    return true;
};
A.collapseDreamTactical <- function(state) {
    if (!this.isDreamCombat() || !this.DreamSession.ending || this.DreamSession.collapseStarted) return false;
    local s = this.DreamSession;
    s.collapseStarted = true;
    return this.startDreamTide(state);
};
A.endDreamTactical <- function(state, victory) {
    if (!this.isDreamCombat() || this.DreamSession.ending) return false;
    local s = this.DreamSession;
    s.ending = true;
    if("Douyu" in this && "cancelRocketFlights" in this.Douyu) this.Douyu.cancelRocketFlights(state);
    s.victory = victory && s.stage < 3 && s.wake == "";
    state.m.IsExitingToMenu = false;
    if (s.victory) {
        s.exitStarted = true;
        state.exitTactical();
    } else {
        // Every dream ending has the same scripted defeat, even if the boss
        // died first or the player chose to leave. Only temporary actors die.
        // Set ending before native death callbacks can re-enter onBattleEnded.
        s.endingCause = s.wake != "" ? s.wake : (victory ? "victory" : "defeat");
        s.wake = "douyu";
        s.narrationPending = true;
        state.m.IsBattleEnded = true;
        state.m.IsAIPaused = true;
        state.setInputLocked(true);
        state.m.MenuStack.popAll();
        if (state.m.TacticalScreen != null) state.m.TacticalScreen.hide();
        // Clear the native UI selection timer before mass death. Otherwise
        // removing the active actor selects the next actor while it also dies.
        ::Tactical.TurnSequenceBar.removeEntities();
        this.showDreamEnding(state);
    }
    return true;
};
A.finishDreamWorld <- function(state) {
    if (!this.isDreamCombat()) return false;
    local s = this.DreamSession, stage = s.stage, victory = s.victory, wake = s.wake;
    // Deliberately exclude native onCombatFinished: it would increment battle
    // counts, consume ammunition, heal/re-equip actors and trigger ambitions.
    ::Time.setVirtualTime(state.m.CombatStartTime);
    state.m.CombatStartTime = 0;
    state.m.CombatSeed = s.startSeed;
    state.m.LastWorldSpeedMult = s.lastWorldSpeed;
    state.m.CombatProperties = null;
    this.restoreDreamSession();
    ::Stash.setLocked(false);
    ::Sound.stopAmbience();
    state.setWorldmapMusic(true);
    state.show();
    state.setAutoPause(false);
    state.setPause(true);
    state.updateTopbarAssets();
    if (victory && stage < 3) {
        this.set("dream_stage", stage + 1);
        this.DreamOpeningQueued = true;
    } else {
        this.set("dream_status", "complete");
        this.set("dream_stage", 0);
        this.set("dream_wake_reason", wake);
        this.set("douyu_final_unlocked", true);
        this.set("dream_wake_pending", true);
        this.DreamStoryDismissed = false;
    }
    return true;
};
A.finishFinalDouyu <- function() {
    if (this.FinalDouyuResult == null) return false;
    local victory = this.FinalDouyuResult;
    this.FinalDouyuResult = null;
    if (victory && !this.get("douyu_final_defeated", false)) {
        if ("recordDouyuWorldVictory" in this) return this.recordDouyuWorldVictory();
        this.set("douyu_final_defeated", true);
        this.set("douyu_final_notice", true);
        return true;
    }
    return false;
};
A.updateDreamWorld <- function() {
    if (!this.isOrigin() || this.isDreamCombat() || ::World.State == null) return;
    // A dream replay click made from the town ledger leaves the native town
    // normally once the ledger has closed, then opens combat on the world map.
    local unreadStory = !this.DreamStoryDismissed && (this.get("dream_wake_pending", false) || this.get("dream_departure_pending", false));
    if ((this.DreamLaunchRequest != null || this.DreamOpeningQueued || this.DreamStoryReviewQueued || unreadStory) && this.isOrigin()
        && !this.isDreamCombat() && !::Tactical.isActive() && ::World.State != null && !::World.Events.hasActiveEvent()) {
        local state = ::World.State;
        if (state.m.LastEnteredTown != null && state.m.WorldTownScreen != null && state.m.WorldTownScreen.isVisible()
            && !state.m.WorldTownScreen.isAnimating() && state.m.MenuStack.isAllowingCancel()) {
            state.town_screen_main_dialog_module_onLeaveButtonClicked();
            return;
        }
    }
    if (!this.dreamWorldReady()) return;
    if (this.DreamLaunchRequest != null) {
        local request = this.DreamLaunchRequest;
        this.DreamLaunchRequest = null;
        if (request.kind == "dream") this.startDreamCombat(request.stage);
        return;
    }
    if (this.DreamStoryDismissed) return;
    if (this.get("dream_wake_pending", false) || this.get("dream_departure_pending", false) || this.get("douyu_final_notice", false) || this.DreamStoryReviewQueued) {
        local event = ::World.Events.getEvent("event.afeix_dream");
        if (event == null) return;
        event.m.StoryReview = this.DreamStoryReviewQueued;
        event.m.Page = this.DreamStoryReviewQueued ? "departure" : this.get("dream_wake_pending", false) ? "wake" : this.get("dream_departure_pending", false) ? "departure" : "victory";
        if (::World.Events.fire("event.afeix_dream", false)) this.DreamStoryReviewQueued = false;
        return;
    }
    if (this.DreamOpeningQueued) this.openDreamIntro();
};
