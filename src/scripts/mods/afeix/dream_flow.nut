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
    { id = "wolves", name = "狼影逼近", text = "蛛网散了，梦沼中的空地又完整地浮现出来，爪声随后响起。恐狼从两侧绕来，前排需要守住缺口，后排也得找好下一步的退路。", script = "scripts/entity/tactical/enemies/direwolf", count = 4 },
    { id = "lindwurm", name = "梦中的长鳞", text = "地面忽然鼓起。林德虫盘住前路，头尾同时逼近。十人的传奇装备仍然明亮，这一次，站位与轮换比追着伤害跑更重要。", script = "scripts/entity/tactical/enemies/lindwurm", count = 1 },
    { id = "douyu", name = "斗鱼·深渊之主", text = "林德虫倒下后，水声从梦沼四周涌来。橙色背鳍从雾中抬起，礼炮映着火光。\n\n斗鱼在等黑旗。这一幕重新以完整队伍开始；第三轮结束，梦潮便会吞没空地，让三位队长醒来。", script = "scripts/entity/tactical/enemies/afeix_douyu", count = 1 }
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
    this.set("dream_wake_pending", false);
    this.set("dream_departure_pending", true);
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
    local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID();
    for (local i = 0; i < d.count; ++i)
        p.Entities.push({ Script = d.script, Faction = faction, Variant = 0, Strength = 0, Party = null });
    return p;
};
A.startDreamCombat <- function(stage) {
    if (!this.dreamWorldReady() || this.dreamStatus() != "pending" || stage != this.dreamStage()) return false;
    local p = this.dreamCombatProperties(stage, true), temporary = ::World.getTemporaryRoster();
    local session = {
        stage = stage, actors = [], flags = {}, statistics = ::World.Statistics,
        dreamStatistics = null, ending = false, victory = false, wake = "",
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
A.endDreamTactical <- function(state, victory) {
    if (!this.isDreamCombat() || this.DreamSession.ending) return false;
    local s = this.DreamSession;
    s.ending = true;
    s.victory = victory && s.stage < 3 && s.wake == "";
    if (s.stage == 3) s.wake = "douyu";
    if (!s.victory && s.wake == "") s.wake = "lost";
    state.m.IsExitingToMenu = false;
    state.exitTactical();
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
