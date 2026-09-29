// Optional add-on. The base mod and its assets are never overwritten.
if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Xiwen/Regen DLC requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_dlc_xiwen_regen", 3, "阿飞远征团 DLC：希文与里根");
::mods_queue("mod_afeix_dlc_xiwen_regen", "mod_afeix_expedition(>=36), >mod_afeix_expedition", function() {
    if (!("AfeixExpedition" in getroottable()) || ::AfeixExpedition.Version < 36)
        throw "Xiwen/Regen DLC requires Afei Expedition v0.26.2 (internal version 36) or newer.";
    if ("XiwenRegenDLC" in ::AfeixExpedition) return;
    ::include("scripts/mods/afeix_dlc_xiwen_regen/content");
    ::include("scripts/mods/afeix_dlc_xiwen_regen/pet");
    ::include("scripts/mods/afeix_dlc_xiwen_regen/hooks");
    ::AfeixExpedition.XiwenRegenDLC <- 3;
});
