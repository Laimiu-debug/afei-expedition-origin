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
    { id = "spiders", name = "蛛网之间", text = "火光一照，满眼蛛网。十个熟面孔各就各位，传奇兵器在手，配合熟得像一起打过上百仗。先把蛛网撕了，看看这队人的刀口够不够快。", script = "scripts/entity/tactical/enemies/spider", count = 5 },
    { id = "wolves", name = "狼影逼近", text = "蛛网清干净了，空地露出来，紧跟着就是爪子刨地的声音。恐狼从两边包过来，前排把口子堵住，后排想好下一步往哪退。\n\n抹茶低头看了眼靴子：刚才还是干地，这会儿已经泡上一层水了。远处有潮声，比狼嚎还低，拖得还长。", script = "scripts/entity/tactical/enemies/direwolf", count = 4 },
    { id = "lindwurm", name = "梦中的长鳞", text = "地面忽然拱起来，林德虫盘在路中间，头和尾巴一起压过来。兵器再好也别一窝蜂往上砍，这一仗靠的是站位和轮换。\n\n大谋回头看了一眼：刚才狼跑过来的那条泥路已经没在水里了，远处的树也在往下沉。‘打完往高处走。’他把盾又抬高了一点。", script = "scripts/entity/tactical/enemies/lindwurm", count = 1 },
    { id = "douyu", name = "斗鱼·深渊之主", text = "林德虫一倒，四面八方全是水声。橙色背鳍从雾里冒出来，礼炮映着火光，雾里的嘈杂人声快把潮声都盖过去了。\n\n抹茶蹲下摸了摸水：‘水在涨。不是它掀的浪，是整片沼泽都在涨。’大谋往回看，刚才走过的浅滩已经没了。\n\n阿飞把黑旗往地里一插：‘都站一块。路没了就没了，别让谁一个人掉队。三、二、一，放轻松。’十个人重新站好。斗鱼打得动，可脚下这场梦正在往下沉。", script = "scripts/entity/tactical/enemies/afeix_douyu", count = 1 }
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
    this.set("dream_notice", "梦境没能展开，出了点岔子。三人现实里的状态都没动，可以再试一次，或者直接跳过。\n\n" );
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
        { round = 1, text = "抹茶：‘水还在涨！都别离黑旗太远，别落单。’" },
        { round = 3, text = "大谋：‘来路淹了！往黑旗这边靠，我接着你们！’黑水漫过浅滩，远处的树影一棵棵没了。" },
        { round = 5, text = "阿飞：‘最后一波了，都站一块！’水已经淹到旗杆，整片沼泽就剩黑旗底下巴掌大一块地。" }
    ];
    foreach (i, notice in notices) if (round >= notice.round && i > s.lastTideNotice) {
        s.lastTideNotice = i;
        ::Tactical.EventLog.log(notice.text);
    }
    if (round >= 6) this.requestDreamWake("douyu");
};
A.dreamEndingText <- function(cause) {
    local lead = cause == "victory" ? "斗鱼终于倒下了，十个人刚想喘口气，水还在往上涨。背鳍不动了，雾后面的潮一点没停。"
        : (cause == "retreat" || cause == "skip" ? "黑旗往来路撤，大谋断后。可来时那片浅滩早就沉进黑水里，梦里已经找不到岸了。"
        : (cause == "defeat" ? "阵线被撕开了，大谋还伸手去捞倒下的人。黑水从缺口涌进来，连退的地方都没了。"
        : "第五轮打完，水已经没过旗杆。礼炮还在雾里一闪一闪，十个人脚下最后那块地开始碎了。"));
    return lead + "\n\n抹茶把账本往怀里一塞：‘不是装备不行……这梦压根没给咱们留回去的路。’\n\n大谋把盾撑住：‘都靠过来！谁也别一个人沉下去。’阿飞攥着黑旗，把还站得住的人一个个往身边拽。潮声里大家互相喊名字，喊到最后，只剩一只只抓在一起的手。\n\n黑水终于漫过了盾沿。十个人扛到了最后一秒，梦就到这儿了。";
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
