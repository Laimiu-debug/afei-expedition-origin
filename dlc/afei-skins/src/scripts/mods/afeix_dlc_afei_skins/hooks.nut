// Extend the base's helpers once; retain its equipment, wound, death and save hooks.
local A = ::AfeixExpedition, D = ::AfeixSkinsDLC;
local originalIsPortrait = A.isPortraitBrush;
A.isPortraitBrush = function(name) {
    return D.isSkinBrush(name) || originalIsPortrait.bindenv(this)(name);
};
local originalPortrait = A.characterPortraitBrush;
A.characterPortraitBrush = function(bro) {
    local original = originalPortrait.bindenv(this)(bro);
    if (bro == null || !this.isOrigin()) return original;
    if ("afeixResurrectedPortrait" in bro.m && D.isSkinBrush(bro.m.afeixResurrectedPortrait))
        return D.completeBrush(bro.m.afeixResurrectedPortrait) ? bro.m.afeixResurrectedPortrait : this.Art.Prefix + "afei_normal";
    if (original == null || !bro.getFlags().has("afeix_character") || bro.getFlags().get("afeix_character") != "afei") return original;
    local style = D.selected();
    return style.brush == null ? original : style.brush;
};
local originalWorld = A.syncWorldPartyArt;
A.syncWorldPartyArt = function() {
    local result = originalWorld.bindenv(this)();
    if (!result || !this.isOrigin() || ::World.Assets.isCamping()) return result;
    local style = D.selected();
    if (style.brush == null || !::doesBrushExist(style.brush + "_world")) return result;
    ::World.State.getPlayer().getSprite("body").setBrush(style.brush + "_world");
    return true;
};
local originalBannerPage = A.bannerLedgerPage;
A.bannerLedgerPage = function(event, page) {
    local custom = D.ledgerPage(event, page);
    if (custom != null) return custom;
    local screen = originalBannerPage.bindenv(this)(event, page);
    if (screen != null && page == "company") {
        // Five native options plus this one fit the native six-button window.
        screen.Options.insert(screen.Options.len() - 1, this.ledgerNav("阿飞外观", D.Page + ":0"));
    }
    return screen;
};
local originalLedgerPage = A.ledgerPage;
A.ledgerPage = function(event, page) {
    local screen = originalLedgerPage.bindenv(this)(event, page);
    if (split(page, ":")[0] == D.Page) {
        // The base adds a default event image; these pages provide their own.
        local prefix = "[img]gfx/ui/events/event_80.png[/img]";
        if (screen.Text.find(prefix) == 0) screen.Text = screen.Text.slice(prefix.len());
    }
    return screen;
};
::mods_hookExactClass("states/world_state", function(o) {
    local loaded = o.onDeserialize;
    o.onDeserialize = function(input) {
        local result = loaded.bindenv(this)(input);
        local A = ::AfeixExpedition;
        // World flags load after actor records, so reapply only after the world.
        if (A.isOrigin()) {
            local bro = D.afei();
            if (bro != null) A.syncCharacterArt(bro);
            A.syncWorldPartyArt();
        }
        return result;
    };
});
