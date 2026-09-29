local passed = 0;
local check = function(value, message) { if (!value) throw "FAIL " + message; passed++; };
local flags = {}, roster = [], origin = true, callback = null;
::AfeixExpedition <- {
    function isOrigin() { return origin; },
    function get(key, fallback = 0) { return key in flags ? flags[key] : fallback; },
    function route() { return this.get("route", "normal"); },
    function roster() { return roster; },
    function findCharacter(key) { foreach (bro in roster) if (bro.key == key) return bro; return null; },
    RootOrder = ["er_xiaoyuan", "er_haman", "er_sige", "er_keke", "er_xiaogui", "er_yuchujiu"]
};
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/ending_data.nut");
dofile("src/scripts/mods/afeix/endings.nut");
local assets = {
    m = { nativeCalls = 0, ironman = true, renown = 100, name = "本次黑旗", crises = 0, day = 1 },
    function getBusinessReputation() { return this.m.renown; },
    function getName() { return this.m.name; },
    function getGameFinishData(retired) { this.m.nativeCalls++; this.m.ironman = false; return { Image = "native-image", Score = "123 points", Text = "native-ending", Won = retired }; }
};
::World <- { Assets = assets, Statistics = { function getFlags() { return { function get(key) { return assets.m.crises; } }; } },
    function getTime() { return { Days = assets.m.day }; } };
::mods_hookNewObject <- function(path, cb) { check(path == "states/world/asset_manager", "bare finish-data provider uses NewObject registration"); callback = cb; };
dofile("src/scripts/mods/afeix/ending_hooks.nut");
callback(assets);
local A = ::AfeixExpedition;
local member = function(key) { return { key = key, alive = true, function isAlive() { return this.alive; } }; };
local reset = function() { flags.clear(); roster.clear(); assets.m.renown = 100; assets.m.crises = 0; assets.m.day = 1; origin = true; };
try {
    foreach (key in A.CharacterOrder) {
        reset(); roster.push(member(key));
        local s = A.endingSnapshot(true), text = A.companyEndingText(s);
        check(text.find(A.Endings.members[key].lean) != null, "individual lean ending " + key);
        assets.m.renown = 3000;
        check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.members[key].good) != null, "individual prosperous ending " + key);
        roster.clear(); flags["dead_" + key] <- true;
        text = A.companyEndingText(A.endingSnapshot(false));
        check(text.find(A.Endings.members[key].memorial) != null && text.find(A.Endings.members[key].good) == null, "deceased cannot receive a living ending " + key);
        reset(); flags["departed_" + key] <- true;
        text = A.companyEndingText(A.endingSnapshot(true));
        check(text.find(A.Characters[key].name) != null && text.find(A.Endings.members[key].memorial) == null, "departure is not death " + key);
        reset(); text = A.companyEndingText(A.endingSnapshot(false));
        check(text.find(A.Endings.members[key].good) == null && text.find(A.Endings.members[key].memorial) == null, "unknown identity never receives an epilogue " + key);
    }
    foreach (row in [[100,0,"humble"],[999,0,"humble"],[1000,0,"ordinary"],[2999,0,"ordinary"],[3000,0,"renowned"],
                    [6000,0,"renowned"],[100,1,"after_crisis"],[5999,2,"after_crisis"],[6000,2,"legacy"]]) {
        reset(); roster.push(member("afei")); assets.m.renown = row[0]; assets.m.crises = row[1];
        check(A.companyEndingKey(A.endingSnapshot(true)) == row[2], "retirement boundary " + row[2]);
    }
    reset(); check(A.companyEndingKey(A.endingSnapshot(false)) == "early_loss", "early defeat");
    assets.m.day = 30; check(A.companyEndingKey(A.endingSnapshot(false)) == "last_watch", "day thirty defeat");
    assets.m.renown = 3000; check(A.companyEndingKey(A.endingSnapshot(false)) == "fallen_legend", "renowned defeat");
    assets.m.renown = 100; assets.m.day = 1; assets.m.crises = 1;
    check(A.companyEndingKey(A.endingSnapshot(false)) == "fallen_legend", "completed crisis overrides early defeat");
    check(A.companyEndingKey(A.endingSnapshot(true)) == "fallen_legend", "empty retirement is still defeat");
    reset(); roster.push(member("afei")); flags.route <- "jiahao";
    local text = A.companyEndingText(A.endingSnapshot(true));
    check(text.find(A.Endings.callbacks.jiahao) != null && text.find(A.Endings.callbacks.toad) == null, "only actual promotion route");
    flags.dead_afei <- true;
    text = A.companyEndingText(A.endingSnapshot(true));
    check(text.find(A.Endings.callbacks.afei_dead) != null && text.find(A.Endings.callbacks.jiahao) == null, "dead captain cannot speak at retirement");
    reset(); roster.push(member("bottle"));
    flags.bicycle_state <- 1;
    check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.callbacks.bottle_kept) != null, "bottle chose to stay");
    flags.dead_bottle <- true;
    check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.callbacks.bottle_kept) == null, "later death overrides former decision to stay");
    foreach (choice in [0,1]) {
        reset(); roster.push(member("afei")); flags.departed_bottle <- true; flags.bicycle_state <- 4; flags.bicycle_choice <- choice;
        text = A.companyEndingText(A.endingSnapshot(true));
        check(text.find(A.Endings.callbacks.bottle_departed) != null && text.find(A.Endings.callbacks[choice == 0 ? "bicycle_kept" : "bicycle_released"]) != null, "bicycle choice and departure " + choice);
        check(text.find(A.Endings.members.bottle.memorial) == null, "departed bottle not memorialized");
    }
    flags.bicycle_state = 3;
    check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.callbacks.bicycle_unfinished) != null, "unresolved bicycle choice never auto-completes");
    reset(); roster.push(member("afei"));
    check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.callbacks.roots) == null, "unknown roots remain undisclosed");
    flags.root_done_er_keke <- true;
    check(A.companyEndingText(A.endingSnapshot(true)).find(A.Endings.callbacks.roots) != null, "completed root acknowledged");
    text = A.companyEndingText(A.endingSnapshot(false));
    check(text.find("仍然生还") != null && text.find(A.Endings.members.afei.memorial) == null, "defeat with reserve survivors avoids false death");
    local before = assets.m.nativeCalls, moneylessFlags = flags.len(), actor = roster[0];
    local data = assets.getGameFinishData(true);
    check(assets.m.nativeCalls == before + 1 && !assets.m.ironman && data.Score == "123 points" && data.Image == "native-image", "native score image ironman cleanup retained exactly once");
    check(data.Text.find("本次黑旗") != null && data.Text != "native-ending", "actual finish-data hook returns custom ending");
    check(flags.len() == moneylessFlags && roster.len() == 1 && roster[0] == actor, "ending generation does not mutate campaign or roster");
    check(data.Text == assets.getGameFinishData(true).Text, "same state produces stable story without random resampling");
    origin = false; check(assets.getGameFinishData(true).Text == "native-ending", "other origins fully native");
    print("ALL_ENDING_CHECKS_PASS\nTESTS_PASSED=" + passed + "\n");
} catch (error) { print(error + "\n"); throw error; }
