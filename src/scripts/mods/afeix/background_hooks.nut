// Conversion replaces only the background skill. Keep the native cultist ID
// and serialized layout, with personal prose reapplied after its own callbacks.
::mods_hookExactClass("skills/backgrounds/converted_cultist_background", function(o) {
    local build = ::mods_getMember(o, "buildDescription");
    ::mods_override(o, "buildDescription", function(final = false) {
        local result = build.bindenv(this)(final);
        local A = ::AfeixExpedition, bro = this.getContainer().getActor();
        if (A.isOrigin() && A.characterId(bro) in A.CharacterBackgrounds && this.getID() == "background.converted_cultist")
            A.configureCharacterBackground(this, A.characterId(bro), true);
        return result;
    });
    local appearance = ::mods_getMember(o, "onSetAppearance");
    ::mods_override(o, "onSetAppearance", function() {
        local A = ::AfeixExpedition, bro = this.getContainer().getActor();
        // Native conversion constructs tattoo_01_<body brush>. Custom bodies
        // have no such tattoo atlas, so let it operate on the saved native body.
        if (A.isArtCharacter(bro) && A.hasPortraitArt(bro)) A.suspendCharacterArt(bro);
        local result = null;
        try { result = appearance.bindenv(this)(); }
        catch (error) { A.syncCharacterArt(bro); throw error; }
        A.syncCharacterArt(bro);
        return result;
    });
});
