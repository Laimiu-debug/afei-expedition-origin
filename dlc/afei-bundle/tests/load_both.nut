    // Preserve the base portrait callback; apply the voice callback to the
    // same finished player instances below, as Hooks does during class loading.
    local baseHook = ::mods_hookExactClass, voiceHook = null, hookCount = 0;
    ::mods_hookExactClass = function(path, callback) {
        hookCount++;
        if (path == "entity/tactical/player") voiceHook = callback;
        else baseHook(path, callback);
    };
    local registered = {}, queued = {};
    ::mods_registerMod <- function(id, version, name) {
        check(!(id in registered), "bundle registers each component once");
        registered[id] <- version;
    };
    ::mods_queue <- function(id, dependencies, callback) {
        check(!(id in queued), "bundle queues each component once");
        local minimum = id == "mod_afeix_dlc_afei_skins" ? 62 : 36;
        check(dependencies == "mod_afeix_expedition(>=" + minimum + "), >mod_afeix_expedition",
            "bundle components retain main-only dependencies");
        queued[id] <- callback;
    };
    ::include <- function(path) { dofile(::bundleSource + "/" + path + ".nut"); };
    ::logInfo <- function(message) {};
    A.Version <- 62;
    A.characterId <- function(actor) {
        return actor != null && actor.getFlags().has("afeix_character") ? actor.getFlags().get("afeix_character") : null;
    };
    local ids = ["mod_afeix_dlc_afei_skins", "mod_afeix_dlc_afei_voice"];
    if (::bundleVoiceFirst) ids.reverse();
    foreach (id in ids) dofile(::bundleSource + "/scripts/!mods_preload/" + id + ".nut");
    foreach (id in ids) queued[id]();
    check(registered.len() == 2 && registered.mod_afeix_dlc_afei_skins == 2
        && registered.mod_afeix_dlc_afei_voice == 3, "bundle preserves reviewed component identities and versions");
    local loadedPortrait = A.characterPortraitBrush, loadedLedger = A.ledgerPage;
    foreach (id in ids) queued[id]();
    check(hookCount == 2 && voiceHook != null, "repeated startup does not duplicate voice or world hooks");
    check(loadedPortrait == A.characterPortraitBrush && loadedLedger == A.ledgerPage,
        "repeated startup does not wrap appearance or ledger again");
