::AfeixExpedition <- { ID = "mod_afeix_expedition", Version = 79, Schema = 8, CombatMax = 12, RosterMax = 40 };
::AfeixExpedition.setdelegate(getroottable());
foreach (part in ["core", "formation", "characters", "background_data", "backgrounds", "talents", "quests", "contracts", "roster", "encounters",
    "promotions", "economy", "appearance", "story_progress", "discovery", "recruitment", "keepsakes", "combat_feedback", "member_skills",
    "member_catalog_data", "member_catalog", "member_catalog_combat", "member_catalog_economy", "member_training", "attribute_treatment", "ledger", "story_ledger", "promotion_ledger",
    "ideas_core", "ideas_events", "ideas_random", "ideas_combat", "ideas_chronicles", "ending_data", "endings", "world_art", "balance_v26_data", "balance_v26", "balance_v26_combat", "turtle_secret",
    "douyu_combat", "douyu_rocket", "douyu_overlay", "douyu_gear", "dream_roster", "dream_flow", "dream_tide", "douyu_world", "dream_ledger"])
    ::include("scripts/mods/afeix/" + part);

if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Expedition requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_expedition", 79, "阿飞远征团");
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
    // Keep the temporary dream boundary outside all ordinary campaign hooks.
    ::include("scripts/mods/afeix/dream_hooks");
    ::include("scripts/mods/afeix/douyu_rocket_hooks");
    ::include("scripts/mods/afeix/douyu_turnbar_hooks");
    ::mods_registerJS("afeix/formation.js");
    ::mods_registerJS("afeix/barber.js");
    ::mods_registerJS("afeix/douyu_turnbar.js");
    ::mods_registerJS("afeix/dream_tide.js");
});
