// Load after the existing gameplay hooks so the dream boundary is outermost.
local A = ::AfeixExpedition;
local getFlag = A.get, setFlag = A.set, realRoster = A.roster, realFind = A.findCharacter, realRoute = A.route, syncFeatures = A.syncCharacterFeatures;
A.get = function(key, fallback = 0) {
    if (this.isDreamCombat() && key in this.DreamSession.flags) return this.DreamSession.flags[key];
    return getFlag.bindenv(this)(key, fallback);
};
A.set = function(key, value) {
    if (this.isDreamCombat()) { this.DreamSession.flags[key] <- value; return value; }
    return setFlag.bindenv(this)(key, value);
};
A.roster = function() { return this.isDreamCombat() ? this.DreamSession.actors : realRoster.bindenv(this)(); };
A.findCharacter = function(key) {
    if (!this.isDreamCombat()) return realFind.bindenv(this)(key);
    foreach (actor in this.DreamSession.actors) if (this.characterId(actor) == key) return actor;
    return null;
};
A.route = function() { return this.isDreamCombat() ? "feidie" : realRoute.bindenv(this)(); };
A.syncCharacterFeatures = function(actor) {
    if (actor != null && actor.getFlags().get("afeix_dream_actor") == true) return;
    return syncFeatures.bindenv(this)(actor);
};
::mods_hookExactClass("states/world_state", function(o) {
    local keyInput = o.onKeyInput;
    o.onKeyInput = function(key) {
        if (key.getState() == 0 && key.getKey() == 41 && ::AfeixExpedition.closeDreamStory(this)) return true;
        return keyInput.bindenv(this)(key);
    };
    local combatProperties = o.getLocalCombatProperties;
    o.getLocalCombatProperties = function(pos, ignoreNoEnemies = false) {
        local properties = combatProperties.bindenv(this)(pos, ignoreNoEnemies);
        return ::AfeixExpedition.douyuLocationCombatProperties(properties);
    };
    local shown = o.loading_screen_onScreenShown;
    o.loading_screen_onScreenShown = function() {
        if (!::AfeixExpedition.isDreamCombat()) return shown.bindenv(this)();
        // The native callback starts combat and then hides the world. Catch
        // outside that whole callback so a failed launch leaves it visible.
        try { return shown.bindenv(this)(); }
        catch (error) { return ::AfeixExpedition.failDreamCombat(error); }
    };
    local guests = o.isUsingGuests;
    o.isUsingGuests = function() { return ::AfeixExpedition.isDreamCombat() ? false : guests.bindenv(this)(); };
    local autosave = o.autosave;
    o.autosave = function() { if (!::AfeixExpedition.isDreamCombat()) return autosave.bindenv(this)(); };
    local save = o.saveCampaign;
    o.saveCampaign = function(name, label = null) {
        // Reject at the public save entry before World.save opens a file.
        if (::AfeixExpedition.isDreamCombat()) return false;
        return save.bindenv(this)(name, label);
    };
    local serialize = o.onSerialize;
    o.onSerialize = function(out) {
        if (::AfeixExpedition.isDreamCombat()) throw "Dream encounters cannot be saved; the campaign save before this stage remains intact.";
        return serialize.bindenv(this)(out);
    };
    local deserialize = o.onDeserialize;
    o.onDeserialize = function(input) {
        // Never reuse runtime references from a previously loaded campaign.
        ::AfeixExpedition.resetDreamRuntime();
        local result = deserialize.bindenv(this)(input), A = ::AfeixExpedition;
        A.DreamOpeningQueued = A.isOrigin() && A.dreamStatus() == "pending";
        return result;
    };
    local finish = o.onCombatFinished;
    o.onCombatFinished = function() {
        local A = ::AfeixExpedition;
        if (A.isDreamCombat()) return A.finishDreamWorld(this);
        // Native Ironman settlement autosaves. Commit the already-resolved
        // tactical outcome first so that save cannot offer a second victory.
        if (A.isOrigin()) A.finishFinalDouyu();
        return finish.bindenv(this)();
    };
    local update = o.onUpdate;
    o.onUpdate = function() {
        local result = update.bindenv(this)();
        ::AfeixExpedition.updateDouyuWorld();
        ::AfeixExpedition.updateDreamWorld();
        return result;
    };
});
::mods_hookNewObject("states/world/asset_manager", function(o) {
    local saveEquipment = o.saveEquipment;
    o.saveEquipment = function() {
        if (!::AfeixExpedition.isDreamCombat()) return saveEquipment.bindenv(this)();
    };
});
::mods_hookExactClass("states/tactical_state", function(o) {
    local scenario = o.isScenarioMode;
    o.isScenarioMode = function() { return ::AfeixExpedition.isDreamCombat() || scenario.bindenv(this)(); };
    local ended = o.onBattleEnded;
    o.onBattleEnded = function() {
        local A = ::AfeixExpedition;
        local r = ::Tactical.Entities.getCombatResult();
        local win = r == ::Const.Tactical.CombatResult.EnemyDestroyed || r == ::Const.Tactical.CombatResult.EnemyRetreated;
        if (A.isDreamCombat()) return A.endDreamTactical(this, win);
        if (A.isOrigin() && this.getStrategicProperties() != null && this.getStrategicProperties().CombatID == "afeix_douyu_final") A.FinalDouyuResult = win;
        return ended.bindenv(this)();
    };
    local update = o.onUpdate;
    o.onUpdate = function() {
        local A = ::AfeixExpedition;
        if (A.isDreamCombat() && !A.DreamSession.ending && !this.isInLoadingScreen()) {
            if (A.DreamSession.stage == 3 && ::Time.getRound() >= 4) A.requestDreamWake("douyu");
            if (A.DreamSession.wake != "") { A.endDreamTactical(this, false); return; }
        }
        return update.bindenv(this)();
    };
    local flee = o.flee;
    o.flee = function(tag = null) {
        if (::AfeixExpedition.isDreamCombat()) { ::AfeixExpedition.requestDreamWake("retreat"); return ::AfeixExpedition.endDreamTactical(this, false); }
        return flee.bindenv(this)(tag);
    };
    local quit = o.main_menu_module_onQuitPressed;
    o.main_menu_module_onQuitPressed = function() {
        if (::AfeixExpedition.isDreamCombat()) {
            // Leaving this short encounter wakes the dream and returns to the
            // campaign. Never let Ironman retire the real starting captains.
            this.m.MenuStack.popAll();
            ::AfeixExpedition.requestDreamWake("skip");
            return ::AfeixExpedition.endDreamTactical(this, false);
        }
        return quit.bindenv(this)();
    };
});
