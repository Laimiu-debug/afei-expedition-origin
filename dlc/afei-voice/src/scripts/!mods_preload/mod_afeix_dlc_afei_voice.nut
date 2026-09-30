// Optional voice add-on; no main-package files or saved classes are replaced.
if (!("mods_registerMod" in getroottable()) || !("mods_queue" in getroottable()))
    throw "Afei Voice DLC requires Legacy Modding Script Hooks (mod_hooks).";
::mods_registerMod("mod_afeix_dlc_afei_voice", 3, "阿飞远征团 DLC：阿飞哇哇叫");
::mods_queue("mod_afeix_dlc_afei_voice", "mod_afeix_expedition(>=36), >mod_afeix_expedition", function() {
    if (!("AfeixExpedition" in getroottable()) || ::AfeixExpedition.Version < 36)
        throw "Afei Voice DLC requires Afei Expedition v0.26.2 (internal version 36) or newer.";
    if ("AfeixVoiceDLC" in getroottable()) return;
    ::AfeixVoiceDLC <- { ID = "mod_afeix_dlc_afei_voice", Version = 3 };
    ::include("scripts/mods/afeix_dlc_afei_voice/config");
    if (::AfeixVoiceDLC.HurtSounds.len() == 0) {
        ::logInfo("[Afei Voice DLC] Awaiting original voice clips; native sounds retained.");
        return;
    }
    ::include("scripts/mods/afeix_dlc_afei_voice/hooks");
});
