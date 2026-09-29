// asset_manager is a bare native table; ExactClass never sees its creation.
::mods_hookNewObject("states/world/asset_manager", function(o) {
    local updateLook = o.updateLook;
    o.updateLook = function(updateTo = -1) {
        local result = updateLook.bindenv(this)(updateTo);
        ::AfeixExpedition.syncWorldPartyArt();
        return result;
    };
});
::mods_hookExactClass("states/world_state", function(o) {
    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function(input) {
        local result = onDeserialize.bindenv(this)(input);
        // Player sprites may load before Assets restores the saved origin.
        // Only update once the whole world, camp state and origin are ready.
        ::AfeixExpedition.syncWorldPartyArt();
        return result;
    };
});
