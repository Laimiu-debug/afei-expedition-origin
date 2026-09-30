// Separate ZIP; never include in the released main mod.
::mods_registerMod("mod_afeix_first_move_diagnostic", 1, "Afei First Movement Diagnostic");
::mods_queue("mod_afeix_first_move_diagnostic", "mod_afeix_expedition, >mod_afeix_dlc_xiwen_regen, >mod_afeix_dlc_afei_voice", function() {
    ::include("scripts/mods/afeix_first_move/profiler");
    local P = ::AfeixFirstMove;
    local wrap = function(object, method, label) {
        local previous = object[method];
        object[method] = function(...) {
            local args = [this]; args.extend(vargv);
            return ::AfeixFirstMove.measure(label, previous, this, args);
        };
    };
    // These managers are native bare tables, so use NewObject.
    foreach (entry in [
        ["entity/world/entity_manager", "entities.update"],
        ["factions/faction_manager", "factions.update"],
        ["entity/world/combat_manager", "combat.update"],
        ["contracts/contract_manager", "contracts.update"],
        ["events/event_manager", "events.update"],
        ["ambitions/ambition_manager", "ambitions.update"],
        ["states/world/asset_manager", "assets.update"]
    ]) {
        // Factory captures a distinct label for each manager.
        local registerManager = function(path, label) {
            ::mods_hookNewObject(path, function(object) { wrap(object, "update", label); });
        };
        registerManager(entry[0], entry[1]);
    }
    ::mods_hookExactClass("states/world_state", function(object) {
        local start = object.startNewCampaign, loaded = object.onDeserialize;
        object.startNewCampaign = function() {
            local result = start.bindenv(this)();
            ::AfeixFirstMove.reset("new_campaign");
            return result;
        };
        object.onDeserialize = function(input) {
            local result = loaded.bindenv(this)(input);
            ::AfeixFirstMove.reset("loaded_campaign");
            return result;
        };
        local input = object.onMouseInput;
        object.onMouseInput = function(mouse) {
            local P = ::AfeixFirstMove;
            if (!P.Armed && !P.Active) return input.bindenv(this)(mouse);
            // Native destination finding can block inside the click itself.
            // Keep its measurement even though the movement starts afterward.
            local pending = P.Armed && ::AfeixExpedition.isOrigin() && mouse.getState() == 1
                && !this.isInLoadingScreen() && !this.m.MenuStack.hasBacksteps() && !this.isInCameraMovementMode();
            local exact = 0;
            if (pending) {
                try { exact = ::Time.getExactTime(); }
                catch (error) { pending = false; }
            }
            if (P.Active) {
                local result = P.measure("mouse.input", input, this, [this, mouse]);
                return result;
            }
            if (pending) P.log("probe_begin name=mouse.input");
            local result = null;
            try { result = input.bindenv(this)(mouse); }
            catch (error) {
                if (pending) P.log("exception name=mouse.input message=" + error);
                throw error;
            }
            if (pending) P.log("probe_end name=mouse.input");
            if (pending && P.moving(this) && P.begin("first_movement_click")) {
                P.record("mouse.input", ::Time.getExactTime() - exact);
            }
            return result;
        };
        local update = object.onUpdate;
        object.onUpdate = function() {
            ::AfeixFirstMove.frame(this);
            if (!::AfeixFirstMove.Active) return update.bindenv(this)();
            return ::AfeixFirstMove.measure("world.onUpdate", update, this, [this]);
        };
        local hidden = object.onHide;
        object.onHide = function() {
            ::AfeixFirstMove.finish("world_hidden");
            return hidden.bindenv(this)();
        };
        // updateScene is an engine method, absent from the raw script class.
        // Whole onUpdate/onRender timings include those native engine calls.
        foreach (entry in [["onProcessInThread", "world.background"], ["onRender", "world.render"],
            ["updateCursorAndTooltip", "world.cursor"], ["updateDayTime", "world.daytime"],
            ["getSurroundingAmbienceSounds", "world.terrain_audio"], ["getSurroundingLocationSounds", "world.location_audio"]])
            wrap(object, entry[0], entry[1]);
    });
    ::mods_hookExactClass("entity/world/settlement", function(object) { wrap(object, "updateRoster", "town.updateRoster"); });
    // Keep dynamic scopes small; do not wrap every entity/skill on every frame.
    foreach (entry in [["syncIdeasCharacter", "afeix.turtle_sync"], ["hasIdea", "afeix.idea_score"],
        ["nextDiscovery", "afeix.discovery_score"], ["ensureTownRecruit", "afeix.recruitment"],
        ["findDeliveryRoute", "afeix.letter_paths"]]) wrap(::AfeixExpedition, entry[0], entry[1]);
    if ("BBMODMapLabels" in getroottable())
        foreach (entry in [["collect", "bbmod.labels_collect"], ["regionAngles", "bbmod.region_angles"], ["sameFrame", "bbmod.labels_compare"]])
            if (entry[0] in ::BBMODMapLabels) wrap(::BBMODMapLabels, entry[0], entry[1]);
    P.log("registered window_s=" + P.WindowSeconds + " no_save_changes=1");
});
