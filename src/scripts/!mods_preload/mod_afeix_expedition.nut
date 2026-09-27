::AfeixExpedition <- { ID = "mod_afeix_expedition", Version = 17, Schema = 8, CombatMax = 10, RosterMax = 40 };
::AfeixExpedition.setdelegate(getroottable());
foreach (part in ["core", "formation", "characters", "talents", "quests", "contracts", "roster", "encounters",
    "promotions", "economy", "appearance", "story_progress", "discovery", "recruitment", "keepsakes", "member_skills",
    "member_catalog_data", "member_catalog", "member_catalog_combat", "member_catalog_economy", "ledger", "story_ledger", "promotion_ledger"])
    ::include("scripts/mods/afeix/" + part);

if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Expedition requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_expedition", 17, "阿飞远征团");
::mods_queue("mod_afeix_expedition", null, function() {
    ::include("scripts/mods/afeix/hooks");
    ::include("scripts/mods/afeix/member_skill_hooks");
    ::include("scripts/mods/afeix/member_catalog_hooks");
    ::include("scripts/mods/afeix/member_catalog_economy_hooks");
    ::include("scripts/mods/afeix/art_hooks");
    ::mods_registerJS("afeix/formation.js");
});
