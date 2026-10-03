// Exercise the shipped event/event_manager and native UI conversion together.
// JS rendering, procedural portrait pixels and campaign file I/O are explicit
// engine boundaries. Durable flags use the native tag_collection serializer.
dofile("tests/gameplay/test_dream_flow.nut");
local storyBaseline = ::checks;
dofile(".cache/afei-art/native-contract-fixture/world_event_screen.nut");
dofile(".cache/afei-art/native-contract-fixture/tag_collection.nut");
::dreamStoryTest <- { views = [], keyFallbacks = 0 };

function storyReset() {
    resetDream();
    ::AfeixExpedition.resetDreamRuntime();
    ::dreamStoryTest.views = [];
    ::dreamStoryTest.keyFallbacks = 0;
    foreach (actor in ::dreamTest.realActors) {
        actor.getImagePath <- function() { return "portrait_" + this.key + ".png"; };
    }
    foreach (key in ["douyu_final_unlocked", "douyu_final_defeated", "douyu_final_notice", "douyu_loot_dropped"])
        ::AfeixExpedition.set(key, false);
    // The native event manager owns visibility and menu-stack transitions;
    // its show call is the exact boundary where native UI data is captured.
    ::World.State.m.EventScreen.show = function(event) {
        this.visible = true;
        ::dreamStoryTest.views.push(::world_event_screen.convertEventToUIData(event));
    };
    ::World.State.m.EventScreen.animating <- false;
    ::World.State.m.EventScreen.isAnimating = function() { return this.animating; };
    // Keep the real outer onKeyInput hook and native onKeyInput forwarding.
    // Contextual handling of unrelated keys remains the explicit UI boundary.
    ::World.State.helper_handleContextualKeyInput = function(key) {
        ++::dreamStoryTest.keyFallbacks;
        return false;
    };
}

function storyKey(code, state) {
    return ::World.State.onKeyInput({ code = code, state = state,
        getKey = function() { return this.code; }, getState = function() { return this.state; } });
}

function storyView(id, title, image, left, right) {
    local event = ::World.Events.m.ActiveEvent;
    check(event != null && event.m.ActiveScreen.ID == id, "native story page " + id);
    local view = ::world_event_screen.convertEventToUIData(event);
    check(view.id == "event.afeix_dream" && view.title == title, id + " native title and event identity");
    check(view.content.len() == 1 && view.content[0].type == "description" && view.content[0].text.len() > 0,
        id + " native description content");
    if (image != null)
        check(view.content[0].text.find("[img]gfx/" + image + "[/img]") != null, id + " visible inline native illustration");
    check(view.headerImagePath == null, id + " uses native inline art instead of unused Image field");
    foreach (pair in [["characterLeft", left], ["characterRight", right]]) {
        local portrait = view[pair[0]];
        if (pair[1] == "any") check(portrait == null || (portrait.IsProcedural && portrait.Image.find("portrait_") == 0),
            id + " native portrait slot contains a real actor or stays empty");
        else if (pair[1] == null) check(portrait == null, id + " missing portrait slot remains empty");
        else check(portrait != null && portrait.IsProcedural && portrait.Image == "portrait_" + pair[1] + ".png",
            id + " native " + pair[0] + " portrait");
    }
    check(view.buttons.len() == event.m.ActiveScreen.Options.len() && view.buttons.len() > 0,
        id + " native buttons belong to this page");
    check(::World.State.m.MenuStack.steps.len() == 1 && ::World.State.m.EventScreen.isVisible(),
        id + " keeps one native menu entry");
    return view;
}

function storyRealitySnapshot() {
    local A = ::AfeixExpedition;
    return { money = ::World.Assets.m.Money, armor = ::World.Assets.m.ArmorParts,
        medicine = ::World.Assets.m.Medicine, ammo = ::World.Assets.m.Ammo,
        roster = ::dreamTest.realActors, statistics = ::World.Statistics,
        time = ::dreamTest.virtualTime, saves = ::dreamTest.saves,
        finalUnlocked = A.get("douyu_final_unlocked", false), finalDefeated = A.get("douyu_final_defeated", false),
        finalNotice = A.get("douyu_final_notice", false), loot = A.get("douyu_loot_dropped", false) };
}

function storyRealityUnchanged(before, label) {
    local A = ::AfeixExpedition;
    check(::World.Assets.m.Money == before.money && ::World.Assets.m.ArmorParts == before.armor
        && ::World.Assets.m.Medicine == before.medicine && ::World.Assets.m.Ammo == before.ammo,
        label + " does not charge or award campaign resources");
    check(::dreamTest.realActors == before.roster && ::World.Statistics == before.statistics
        && ::dreamTest.virtualTime == before.time && ::dreamTest.saves == before.saves,
        label + " preserves real roster, statistics, clock and save count");
    foreach (actor in ::dreamTest.realActors)
        check(actor.level == 1 && actor.hp == 50 && actor.xp == 0 && actor.battles == 0 && actor.equipment[0] == "original",
            label + " real actor unchanged " + actor.key);
    check(A.get("douyu_final_unlocked", false) == before.finalUnlocked
        && A.get("douyu_final_defeated", false) == before.finalDefeated
        && A.get("douyu_final_notice", false) == before.finalNotice
        && A.get("douyu_loot_dropped", false) == before.loot,
        label + " leaves final encounter and unique loot flags unchanged");
    check(!A.isDreamCombat() && ::dreamTest.tempActors.len() == 0 && !::Stash.locked,
        label + " never constructs or equips dream actors");
}

function storyReloadFlags() {
    // Native tag_collection performs the same typed field sequence used by
    // real save data; this array supplies only the C++ binary stream boundary.
    local flags = clone ::tag_collection; flags.m = {};
    foreach (key, value in ::dreamTest.flags) flags.set(key, value);
    local stream = { values = [], index = 0 };
    foreach (kind in ["U16", "U8", "I32", "F32", "Bool", "String"]) {
        stream["write" + kind] <- function(value) { this.values.push(value); };
        stream["read" + kind] <- function() { return this.values[this.index++]; };
    }
    flags.onSerialize(stream);
    local restored = clone ::tag_collection; restored.m = {}; restored.onDeserialize(stream);
    local saved = {};
    foreach (key, entry in restored.m) saved[key] <- entry.Value;
    ::dreamTest.flags = saved;
    ::World.State.onDeserialize({});
    check(stream.index == stream.values.len(), "native durable story flags consume complete serialized data");
}

local A = ::AfeixExpedition;
storyReset(); local before = storyRealitySnapshot();
check(A.initializeDreamOpening() && A.openDreamIntro(), "new company opens first background page");
storyView("opening", "黑旗未满", "ui/events/event_33.png", "afei", "damou");
::World.Events.processInput(0);
storyView("opening_dream", "三人同梦", "ui/events/afeix_douyu.png", "afei", "mocha");
check(A.get("dream_intro_page", "") == "opening_dream" && A.DreamLaunchRequest == null,
    "first story click persists next page without scheduling combat");
storyRealityUnchanged(before, "background and shared-dream preview");
::World.Events.processInput(0);
check(!::World.Events.hasActiveEvent() && A.DreamLaunchRequest != null && A.DreamLaunchRequest.stage == 0,
    "combat starts only after reading the separate shared-dream preview");
storyRealityUnchanged(before, "preview combat request");

storyReset(); A.initializeDreamOpening(); A.openDreamIntro(); ::World.Events.processInput(0);
before = storyRealitySnapshot();
check(!storyKey(41, 1) && ::dreamStoryTest.keyFallbacks == 1,
    "Esc keyDown passes through the real outer hook to native contextual handling");
check(::World.Events.hasActiveEvent() && ::World.State.m.EventScreen.isVisible() && !A.DreamStoryDismissed,
    "Esc keyDown does not close or dismiss the current story");
check(!storyKey(39, 0) && ::dreamStoryTest.keyFallbacks == 2 && ::World.Events.hasActiveEvent(),
    "unrelated key releases retain native contextual handling");
::World.State.m.EventScreen.animating = true;
check(storyKey(41, 0) && ::dreamStoryTest.keyFallbacks == 2,
    "real outer hook consumes Esc release during story animation");
check(::World.Events.hasActiveEvent() && ::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "opening_dream"
    && ::World.State.m.MenuStack.steps.len() == 1 && !A.DreamStoryDismissed,
    "animated story consumes Esc without clearing event or menu entry");
::World.State.m.EventScreen.animating = false;
check(storyKey(41, 0) && ::dreamStoryTest.keyFallbacks == 2,
    "real outer hook closes the stable story on Esc release");
check(!::World.Events.hasActiveEvent() && !::World.State.m.EventScreen.isVisible()
    && ::World.State.m.MenuStack.steps.len() == 0 && A.DreamStoryDismissed,
    "Esc closes native story event and menu entry");
local shown = ::dreamStoryTest.views.len();
A.updateDreamWorld(); A.updateDreamWorld();
check(!::World.Events.hasActiveEvent() && ::dreamStoryTest.views.len() == shown,
    "Esc suppression prevents automatic story reappearance");
check(A.resumeDreamStory(), "F8 resume helper accepts dismissed story");
A.updateDreamWorld();
storyView("opening_dream", "三人同梦", "ui/events/afeix_douyu.png", "afei", "mocha");
check(!A.DreamStoryDismissed, "F8 resume clears only runtime dismissal");
storyRealityUnchanged(before, "Esc and F8 resume");

::World.Events.processInput(-1);
storyReloadFlags();
check(A.get("dream_intro_page", "") == "opening_dream" && !A.DreamStoryDismissed,
    "load retains shared-dream page cursor and resets runtime dismissal");
A.updateDreamWorld();
storyView("opening_dream", "三人同梦", "ui/events/afeix_douyu.png", "afei", "mocha");
storyRealityUnchanged(before, "serialized intro resume");

storyReset(); A.initializeDreamOpening(); A.openDreamIntro();
::World.Events.processInput(1);
check(A.dreamStatus() == "skipped" && A.get("dream_departure_pending", false)
    && !A.get("dream_story_seen", false) && A.DreamLaunchRequest == null,
    "skipping dream retains unread real-company background");
storyView("departure", "黑旗启程", "ui/events/event_16.png", "mocha", "afei");
before = storyRealitySnapshot();
::World.Events.processInput(-1); A.updateDreamWorld();
check(!::World.Events.hasActiveEvent() && A.get("dream_departure_pending", false),
    "Esc from departure leaves it pending without reopening");
storyReloadFlags(); A.updateDreamWorld();
storyView("departure", "黑旗启程", "ui/events/event_16.png", "mocha", "afei");
::World.Events.processInput(0);
check(A.get("dream_story_seen", false) && !A.get("dream_departure_pending", false)
    && !::World.Events.hasActiveEvent(), "departure acknowledgment alone completes real-company story");
A.updateDreamWorld(); A.updateDreamWorld();
check(!::World.Events.hasActiveEvent(), "completed departure does not repeat");
storyRealityUnchanged(before, "departure close and load");

storyReset(); A.set("dream_status", "complete"); A.set("dream_wake_pending", true);
A.set("dream_wake_reason", "douyu"); A.set("douyu_final_unlocked", true);
before = storyRealitySnapshot(); A.updateDreamWorld();
storyView("wake", "黑旗初醒", null, "any", "any");
::World.Events.processInput(0);
storyView("departure", "黑旗启程", "ui/events/event_16.png", "mocha", "afei");
check(!A.get("dream_wake_pending", false) && A.get("dream_departure_pending", false),
    "wake transitions directly to durable departure without a second event queue");
::World.Events.processInput(0);
check(A.get("dream_story_seen", false) && !A.get("dream_departure_pending", false),
    "normal dream return finishes company background");
storyRealityUnchanged(before, "wake to company background");

storyReset(); A.set("dream_status", "skipped"); A.set("dream_story_seen", true);
A.set("douyu_final_defeated", true); A.set("douyu_final_unlocked", true); A.set("douyu_loot_dropped", true);
local originalFlags = clone ::dreamTest.flags; before = storyRealitySnapshot();
check(A.queueDepartureStoryReview(), "F8 can queue read-only company background after completion");
A.updateDreamWorld();
storyView("departure", "黑旗启程", "ui/events/event_16.png", "mocha", "afei");
check(::World.Events.m.ActiveEvent.m.StoryReview, "read-only background identifies its review context");
::World.Events.processInput(0);
check(!::World.Events.hasActiveEvent() && ::dreamTest.flags.len() == originalFlags.len(),
    "read-only company review closes without adding durable tags");
foreach (key, value in originalFlags) check(::dreamTest.flags[key] == value, "review preserves durable flag " + key);
check(!::World.Events.getEvent("event.afeix_dream").m.StoryReview, "native event clear resets review context");
storyRealityUnchanged(before, "completed-story review");

foreach (missing in ["afei", "damou", "mocha", "all"]) {
    storyReset();
    for (local i = ::dreamTest.realActors.len() - 1; i >= 0; --i)
        if (missing == "all" || ::dreamTest.realActors[i].key == missing) ::dreamTest.realActors.remove(i);
    A.initializeDreamOpening(); A.openDreamIntro();
    local event = ::World.Events.m.ActiveEvent;
    local view = ::world_event_screen.convertEventToUIData(event);
    check(event.m.ActiveScreen.ID == "opening" && view.title == "黑旗未满", "missing " + missing + " still opens background");
    ::World.Events.processInput(0);
    check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "opening_dream", "missing " + missing + " still turns native page");
    ::World.Events.processInput(1);
    check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "departure", "missing " + missing + " still skips to departure");
    view = ::world_event_screen.convertEventToUIData(::World.Events.m.ActiveEvent);
    check(view.buttons.len() > 0 && (missing != "all" || (view.characterLeft == null && view.characterRight == null)),
        "missing " + missing + " never creates replacement portraits or actors");
    ::World.Events.processInput(0);
    check(A.get("dream_story_seen", false), "missing " + missing + " can complete background");
}

storyReset(); A.set("dream_status", "complete"); A.set("douyu_final_defeated", true); A.set("douyu_final_notice", true);
A.updateDreamWorld(); check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "victory", "final victory uses native story event");
check(storyKey(41, 0), "real Esc route closes final victory story");
shown = ::dreamStoryTest.views.len(); A.updateDreamWorld(); A.updateDreamWorld();
check(!::World.Events.hasActiveEvent() && A.DreamStoryDismissed && A.get("douyu_final_notice", false)
    && shown == ::dreamStoryTest.views.len(), "Esc suppression also covers pending final victory story");
check(A.resumeDreamStory(), "F8 resumes dismissed final victory story"); A.updateDreamWorld();
check(::World.Events.m.ActiveEvent.m.ActiveScreen.ID == "victory", "resumed final victory preserves its page");

print("DREAM_STORY_NATIVE_PASSED=" + (::checks - storyBaseline) + "\n");
print("TESTS_PASSED=" + (::checks - storyBaseline) + "\n");
