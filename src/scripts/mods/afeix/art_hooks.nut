// Keep native gameplay; only the injury-layer renderer is replaced for portraits.
// Legacy Hooks requires replacing the method on its original definition table.
// Adding a child slot for an inherited method changes native parent dispatch.
// Native inherit can bind captured closures to a prototype environment. Rebind
// every original callback to the live actor before invoking it; call/acall alone
// cannot replace a closure's previously bound environment.
local artWrappers = {};
local overrideArtMember = function(object, method, replacement) {
    local current = ::mods_getMember(object, method);
    if (current in artWrappers) return;
    artWrappers[replacement] <- true;
    ::mods_override(object, method, replacement);
};
local hookPortraitActor = function(o) {
    local generateCorpse = ::mods_getMember(o, "generateCorpse");
    overrideArtMember(o, "generateCorpse", function(tile, fatality, killer) {
        local corpse = generateCorpse.bindenv(this)(tile, fatality, killer);
        // This covers placed, delayed resurrection and unplaced corpses alike.
        if ("afeixDeathVisual" in this.m && this.m.afeixDeathVisual && corpse != null && corpse.Custom != null)
            corpse.Custom.Body = this.m.afeixDeathPortrait;
        return corpse;
    });
    local setDirty = ::mods_getMember(o, "setDirty");
    overrideArtMember(o, "setDirty", function(value) {
        ::AfeixExpedition.hideOriginalPortraitParts(this);
        return setDirty.bindenv(this)(value);
    });
    local onAppearanceChanged = ::mods_getMember(o, "onAppearanceChanged");
    overrideArtMember(o, "onAppearanceChanged", function(appearance, setDirty = true) {
        local result = onAppearanceChanged.bindenv(this)(appearance, setDirty);
        ::AfeixExpedition.syncCharacterArt(this); return result;
    });
    local onUpdateInjuryLayer = ::mods_getMember(o, "onUpdateInjuryLayer");
    overrideArtMember(o, "onUpdateInjuryLayer", function() {
        local A = ::AfeixExpedition;
        if ("afeixDeathVisual" in this.m && this.m.afeixDeathVisual) return;
        if (!A.isCharacterArtSuspended(this) && A.isArtCharacter(this) && A.hasPortraitArt(this)) {
            A.syncCharacterArt(this); return;
        }
        if (!A.isCharacterArtSuspended(this) && "afeixPortraitActive" in this.m && this.m.afeixPortraitActive)
            A.restoreNativeCharacterBody(this);
        return onUpdateInjuryLayer.bindenv(this)();
    });
    local onFactionChanged = ::mods_getMember(o, "onFactionChanged");
    overrideArtMember(o, "onFactionChanged", function() {
        local result = onFactionChanged.bindenv(this)(); ::AfeixExpedition.syncCharacterArt(this); return result;
    });
    local onDeath = ::mods_getMember(o, "onDeath");
    overrideArtMember(o, "onDeath", function(killer, skill, tile, fatalityType) {
        local A = ::AfeixExpedition, brush = A.characterPortraitBrush(this);
        // Native decapitation always calls spawnHeadEffect. Hiding every face,
        // hair and beard layer leaves an empty array on helmetless members and
        // corrupts the native effect (the crash can surface later in loot drop).
        // Restore the native head for this fatality before entering onDeath.
        if (fatalityType == ::Const.FatalityType.Decapitated || brush == null
            || !A.hasPortraitArt(this, brush) || !A.hasCorpseHeadArt(brush)) {
            if (brush == null) return onDeath.bindenv(this)(killer, skill, tile, fatalityType);
            local depth = "afeixArtSuspendDepth" in this.m ? this.m.afeixArtSuspendDepth : 0;
            this.m.afeixArtSuspendDepth <- depth + 1;
            local result = null;
            try {
                A.suspendCharacterArt(this);
                result = onDeath.bindenv(this)(killer, skill, tile, fatalityType);
            } catch (error) { this.m.afeixArtSuspendDepth = depth; throw error; }
            this.m.afeixArtSuspendDepth = depth;
            return result;
        }
        local depth = "afeixArtSuspendDepth" in this.m ? this.m.afeixArtSuspendDepth : 0;
        this.m.afeixArtSuspendDepth <- depth + 1;
        local saved = A.beginPortraitDeath(this, fatalityType), result = null;
        try { result = onDeath.bindenv(this)(killer, skill, tile, fatalityType); }
        catch (error) {
            A.endPortraitDeath(this, saved); this.m.afeixArtSuspendDepth = depth; throw error;
        }
        A.endPortraitDeath(this, saved); this.m.afeixArtSuspendDepth = depth;
        A.replacePortraitCorpse(this, tile, brush, fatalityType); return result;
    });
};
::mods_hookExactClass("entity/tactical/player", function(o) {
    hookPortraitActor(o);
    local onInit = ::mods_getMember(o, "onInit");
    overrideArtMember(o, "onInit", function() {
        this.m.afeixArtSuspendDepth <- 0;
        local result = onInit.bindenv(this)();
        // Ordinary players and other origins receive no extra sprite.
        ::AfeixExpedition.syncCharacterArt(this); return result;
    });
    local onDeserialize = ::mods_getMember(o, "onDeserialize");
    overrideArtMember(o, "onDeserialize", function(input) {
        this.m.afeixArtSuspendDepth <- 0; this.m.afeixNativeArt <- null; this.m.afeixPortraitActive <- false;
        local result = onDeserialize.bindenv(this)(input);
        ::AfeixExpedition.syncCharacterArt(this); return result;
    });
    local onCombatFinished = ::mods_getMember(o, "onCombatFinished");
    overrideArtMember(o, "onCombatFinished", function() {
        local result = onCombatFinished.bindenv(this)(); ::AfeixExpedition.syncCharacterArt(this); return result;
    });
    local onSerialize = ::mods_getMember(o, "onSerialize");
    overrideArtMember(o, "onSerialize", function(output) {
        local A = ::AfeixExpedition;
        if (!A.isArtCharacter(this)) return onSerialize.bindenv(this)(output);
        local depth = "afeixArtSuspendDepth" in this.m ? this.m.afeixArtSuspendDepth : 0;
        this.m.afeixArtSuspendDepth <- depth + 1;
        local result = null;
        try { A.suspendCharacterArt(this); result = onSerialize.bindenv(this)(output); }
        catch (error) {
            this.m.afeixArtSuspendDepth = depth;
            if (depth == 0) A.syncCharacterArt(this);
            throw error;
        }
        this.m.afeixArtSuspendDepth = depth;
        if (depth == 0) A.syncCharacterArt(this);
        return result;
    });
});
::mods_hookExactClass("entity/tactical/enemies/zombie_player", function(o) {
    hookPortraitActor(o);
    local onResurrected = ::mods_getMember(o, "onResurrected");
    overrideArtMember(o, "onResurrected", function(info) {
        local A = ::AfeixExpedition;
        if (A.isOrigin() && info.Custom != null && "Body" in info.Custom && A.isPortraitBrush(info.Custom.Body))
            this.m.afeixResurrectedPortrait <- info.Custom.Body;
        local result = onResurrected.bindenv(this)(info); A.syncCharacterArt(this); return result;
    });
});
