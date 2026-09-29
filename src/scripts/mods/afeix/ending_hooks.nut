::mods_hookNewObject("states/world/asset_manager", function(o) {
    local native = o.getGameFinishData;
    o.getGameFinishData = function(retired) {
        local A = ::AfeixExpedition;
        if (!A.isOrigin()) return native.bindenv(this)(retired);
        // Capture before native ending selection removes successor/candidates
        // from its temporary list. Native handles score, music and Ironman.
        local snapshot = A.endingSnapshot(retired);
        local result = native.bindenv(this)(retired);
        result.Text = A.companyEndingText(snapshot);
        return result;
    };
});
