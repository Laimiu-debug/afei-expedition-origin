// Independent optional event expansion. Content is added only in this DLC.
if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Events DLC requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_dlc_events", 1, "阿飞远征团 DLC：旅途与酒馆");
::mods_queue("mod_afeix_dlc_events", "mod_afeix_expedition(>=54), >mod_afeix_expedition", function() {
    if (!("AfeixExpedition" in getroottable()) || ::AfeixExpedition.Version < 54)
        throw "Afei Events DLC requires Afei Expedition v0.28.4 (internal version 54) or newer.";
    if ("AfeixEventsDLC" in getroottable()) return;
    ::AfeixEventsDLC <- { ID = "mod_afeix_dlc_events", Version = 1, EventID = "event.afeix_dlc_events",
        Scenes = {}, Order = [], SharedCooldownDays = 1.5, TavernChance = 25, TavernAttemptDays = 1.0 };
    ::include("scripts/mods/afeix_dlc_events/core");
    ::include("scripts/mods/afeix_dlc_events/content");
    ::include("scripts/mods/afeix_dlc_events/hooks");
});
