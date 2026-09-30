::AfeixExpedition <- { ID = "mod_afeix_expedition", Version = 62, Schema = 8, CombatMax = 12, RosterMax = 40 };
::AfeixExpedition.setdelegate(getroottable());
foreach (part in ["core", "formation", "characters", "background_data", "backgrounds", "talents", "quests", "contracts", "roster", "encounters",
    "promotions", "economy", "appearance", "story_progress", "discovery", "recruitment", "keepsakes", "member_skills",
    "member_catalog_data", "member_catalog", "member_catalog_combat", "member_catalog_economy", "member_training", "attribute_treatment", "ledger", "story_ledger", "promotion_ledger",
    "ideas_core", "ideas_events", "ideas_random", "ideas_combat", "ideas_chronicles", "blue_story_data", "blue_stories", "ending_data", "endings", "world_art", "balance_v26_data", "balance_v26", "balance_v26_combat", "turtle_secret"])
    ::include("scripts/mods/afeix/" + part);

if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Expedition requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_expedition", 62, "阿飞远征团");
::mods_queue("mod_afeix_expedition", null, function() {
    ::include("scripts/mods/afeix/hooks");
    ::include("scripts/mods/afeix/member_skill_hooks");
    ::include("scripts/mods/afeix/member_catalog_hooks");
    ::include("scripts/mods/afeix/member_catalog_economy_hooks");
    ::include("scripts/mods/afeix/art_hooks");
    ::include("scripts/mods/afeix/background_hooks");
    ::include("scripts/mods/afeix/barber_hooks");
    ::include("scripts/mods/afeix/ideas_hooks");
    ::include("scripts/mods/afeix/ending_hooks");
    ::include("scripts/mods/afeix/world_art_hooks");
    ::include("scripts/mods/afeix/banner_hooks");
    ::include("scripts/mods/afeix/company_appearance_hooks");
    ::include("scripts/mods/afeix/balance_v26_hooks");
    ::include("scripts/mods/afeix/supporter_title_hooks");
    ::mods_registerJS("afeix/formation.js");
    ::mods_registerJS("afeix/barber.js");
});
