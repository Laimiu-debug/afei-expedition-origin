local A = ::AfeixExpedition;
A.barberPortraitLocked <- function(bro) { return bro != null && this.isArtCharacter(bro) && this.hasPortraitArt(bro); };
A.barberPreview <- function(bro) {
    local list = ::World.getTemporaryRoster().getAll();
    if (list.len() == 0) return bro.getImagePath();
    local temp = list[0];
    temp.copySpritesFrom(bro, ["body", "head"]);
    // Native barber previews are plain humans without character identity flags.
    foreach (name in this.Art.HiddenLayers) if (temp.hasSprite(name)) temp.getSprite(name).Visible = false;
    temp.setDirty(true);
    return temp.getImagePath();
};
::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_barber_dialog_module", function(o) {
    local query = o.queryRosterInformation;
    o.queryRosterInformation = function() {
        local result = query.bindenv(this)();
        foreach (entry in result.Roster)
            entry.AfeixPortraitLocked <- ::AfeixExpedition.barberPortraitLocked(::Tactical.getEntityByID(entry.ID));
        return result;
    };
    local selected = o.onEntrySelected;
    o.onEntrySelected = function(id) {
        local A = ::AfeixExpedition, bro = ::Tactical.getEntityByID(id);
        if (A.barberPortraitLocked(bro)) A.syncCharacterArt(bro);
        local result = selected.bindenv(this)(id);
        return A.barberPortraitLocked(bro) ? A.barberPreview(bro) : result;
    };
    local update = o.onUpdateAppearance;
    o.onUpdateAppearance = function(data) {
        local A = ::AfeixExpedition, bro = ::Tactical.getEntityByID(data[0]);
        return A.barberPortraitLocked(bro) ? A.barberPreview(bro) : update.bindenv(this)(data);
    };
    local accept = o.onChangeAppearance;
    o.onChangeAppearance = function(id) {
        local A = ::AfeixExpedition, bro = ::Tactical.getEntityByID(id);
        if (!A.barberPortraitLocked(bro)) return accept.bindenv(this)(id);
        A.syncCharacterArt(bro);
        return bro.getImagePath();
    };
});
