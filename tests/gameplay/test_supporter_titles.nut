// Exercise the installed game's generation and background-title order.
local checks = 0, origin = true, selection = 0, rolls = 0;
local check = function(ok, label) { if (!ok) throw "FAIL supporter titles: " + label; checks++; };
::Const <- { FatalityType = { None = 0 }, MoraleCheckType = { Default = 0 },
    Bodies = { AllMale = [] }, Strings = { CharacterNames = ["弗里茨"] },
    XP = { MaxLevelWithPerkpoints = 11 }, CharacterTraits = [["trait.test", "test_trait"]] };
::Tactical <- {};
::inherit <- function(path, body) { return body; };
dofile(".cache/afei-art/native-contract-fixture/player.nut");
dofile(".cache/afei-art/native-contract-fixture/character_background.nut");
::AfeixExpedition <- { isOrigin = function() { return origin; } };
::Math <- { rand = function(low, high) {
    check(low == 0 && high == 3, "one equal-probability choice among four titles");
    rolls++; return selection;
} };
local hook = null;
::mods_hookExactClass <- function(path, callback) {
    check(path == "entity/tactical/player", "hook targets recruit generation"); hook = callback;
};
dofile("src/scripts/mods/afeix/supporter_title_hooks.nut");
local make = function(title = "", backgroundTitle = "", traitTitle = "", backgroundID = "background.fisherman") {
    local bro = clone ::player;
    bro.setdelegate(getroottable());
    bro.m = clone ::player.m;
    bro.m.Name <- ""; bro.m.Title <- title; bro.m.Background = null;
    bro.m.Ethnicity <- 0; bro.m.Hitpoints <- 0;
    bro.m.CurrentProperties <- { Hitpoints = 60 };
    bro.ready <- false; bro.description <- ""; bro.traits <- 0;
    // Native random choices: one trait, background title when one is available.
    bro.Math <- { rand = function(a, b) { return a == 0 && b == 3 ? 3 : (b == 1 ? 1 : a); } };
    bro.isSomethingToSee <- function() { return false; };
    bro.fillTalentValues = function() {};
    bro.fillAttributeLevelUpValues = function(n) {};
    local bg = clone ::character_background;
    bg.setdelegate(getroottable()); bg.m = clone ::character_background.m;
    bg.m.Titles = backgroundTitle == "" ? [] : [backgroundTitle];
    bg.Math <- bro.Math;
    bg.getID <- function() { return backgroundID; };
    bg.getContainer <- function() { return { getActor = function() { return bro; } }; };
    bg.buildAttributes = function() {};
    bg.buildDescription = function(final = false) { bro.description = bro.m.Name + " " + bro.m.Title; };
    bg.addEquipment <- function() {};
    bg.setAppearance = function() {};
    local trait = { onAdded = function() { bro.traits++; },
        getID = function() { return "trait.test"; }, isExcluded = function(id) { return false; },
        getContainer = function() { return {}; },
        addTitle = function() { if (traitTitle != "" && bro.getTitle() == "") bro.setTitle(traitTitle); } };
    bro.new <- function(path) { return path == "test_trait" ? trait : bg; };
    bro.m.Skills <- { add = function(skill) { skill.onAdded(); }, update = function() { bro.ready = true; } };
    hook(bro);
    return bro;
};
foreach (i, title in ["保飞派", "倒飞派", "儿飞派", "曹飞派"]) {
    selection = i;
    local bro = make(), before = rolls;
    check(bro.setStartValuesEx(["fisherman_background"]) == null, "native return preserved");
    check(bro.getTitle() == title && rolls == before + 1, "blank recruit receives " + title);
    check(bro.m.Name == "弗里茨" && bro.m.Hitpoints == 60 && bro.traits == 1 && bro.ready,
        "native name, health, traits and setup remain intact");
    check(bro.description == "弗里茨 " + title, "native setter refreshes displayed description");
    bro.setStartValuesEx(["fisherman_background"]);
    check(bro.getTitle() == title && rolls == before + 1, "repeated setup preserves assigned title");
}
foreach (sample in [["捕鱼人", "", ""], ["", "乞丐", ""], ["", "", "强壮者"]]) {
    local bro = make(sample[0], sample[1], sample[2]), before = rolls;
    bro.setStartValuesEx(["fisherman_background"]);
    local expected = sample[0] != "" ? sample[0] : (sample[1] != "" ? sample[1] : sample[2]);
    check(bro.getTitle() == expected && rolls == before, "existing, background and trait titles take priority");
}
foreach (id in ["background.afeix_afei", "background.afeix_xiwen"]) {
    local named = make("", "", "", id), before = rolls;
    named.setStartValuesEx(["named_background"], false);
    check(named.getTitle() == "" && rolls == before, "named main/DLC setup does not roll a faction");
    named.setTitle("专属称号"); check(named.getTitle() == "专属称号", "authored title remains available");
}
local eventBro = make(); eventBro.setStartValuesEx(["fisherman_background"], false);
check(eventBro.getTitle() == "曹飞派" && eventBro.traits == 0, "ordinary event recruits without random traits also qualify");
origin = false;
local outsider = make(), before = rolls;
outsider.setStartValuesEx(["fisherman_background"]);
check(outsider.getTitle() == "" && rolls == before, "other origins keep native empty titles");
print("TESTS_PASSED=" + checks + "\n");
