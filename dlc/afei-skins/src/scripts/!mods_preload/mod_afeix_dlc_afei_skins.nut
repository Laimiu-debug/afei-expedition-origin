// Independent optional add-on: main -> skins, with no sibling dependency.
if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Skins DLC requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_dlc_afei_skins", 1, "阿飞远征团 DLC：阿飞衣橱");
::mods_queue("mod_afeix_dlc_afei_skins", "mod_afeix_expedition(>=62), >mod_afeix_expedition", function() {
    if (!("AfeixExpedition" in getroottable()) || ::AfeixExpedition.Version < 62)
        throw "Afei Skins DLC requires Afei Expedition v0.28.12 (internal 62) or newer.";
    if ("AfeixSkinsDLC" in getroottable()) return;
    ::include("scripts/mods/afeix_dlc_afei_skins/content");
    ::include("scripts/mods/afeix_dlc_afei_skins/hooks");
});
