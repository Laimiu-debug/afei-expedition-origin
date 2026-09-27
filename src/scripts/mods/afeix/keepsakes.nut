local A = ::AfeixExpedition;
A.findKeepsake <- function(id) {
    foreach (item in ::World.Assets.getStash().getItems()) if (item != null && item.getID() == id) return item;
    foreach (bro in this.roster()) foreach (item in bro.getItems().getAllItems()) if (item.getID() == id) return item;
    return null;
};
A.issueKeepsake <- function(key, path, id, wearer = null) {
    if (this.findKeepsake(id) != null) { this.set("item_issued_" + key, true); return true; }
    if (this.get("item_issued_" + key, false)) return false; // discarded/lost items do not respawn on load
    local stash = ::World.Assets.getStash();
    local equip = wearer != null && wearer.getItems().getItemAtSlot(::Const.ItemSlot.Accessory) == null;
    if (!equip && stash.getNumberOfEmptySlots() == 0) return false;
    local item = null;
    try {
        item = ::new(path);
        if (equip && wearer.getItems().equip(item)) {
            this.set("item_issued_" + key, true); return true;
        }
        if (stash.add(item) != null) { this.set("item_issued_" + key, true); return true; }
    } catch (error) {
        ::logError("[AfeixExpedition] Keepsake " + key + ": " + error);
        // Some native/modded callbacks can throw after accepting the object.
        if (this.findKeepsake(id) != null) { this.set("item_issued_" + key, true); return true; }
    }
    return false;
};
A.ensureStoryItems <- function() {
    if (!this.isOrigin()) return;
    local afei = this.findCharacter("afei");
    if (afei != null) this.issueKeepsake("ecig", "scripts/items/accessory/afeix_ecig_item", "accessory.afeix_ecig", afei);
    // The bicycle becomes a visible object once the player has met Bottle by hiring her.
    // Previously completed goodbye choices must not restore a discarded bicycle.
    if (this.get("bicycle_state") == 4 && this.get("bicycle_choice", -1) == 1) {
        this.set("item_issued_bicycle", true); return;
    }
    if (this.findCharacter("bottle") != null || this.get("ever_bottle", false) || this.get("bicycle_state") > 0) {
        if (this.issueKeepsake("bicycle", "scripts/items/misc/afeix_bicycle_item", "misc.afeix_bicycle"))
            this.set("bicycle_owned", true);
    }
};
A.discardBicycleItem <- function() {
    // The bicycle is a stash-only keepsake; ordinary manual disposal is also respected.
    local stash = ::World.Assets.getStash();
    local held = [];
    foreach (item in stash.getItems()) if (item != null && item.getID() == "misc.afeix_bicycle") held.push(item);
    try {
        foreach (item in held) {
            stash.remove(item);
            if (stash.getItems().find(item) != null) throw "Bicycle removal failed";
        }
    } catch (error) {
        foreach (item in held) if (stash.getItems().find(item) == null) stash.add(item);
        throw error;
    }
    this.set("item_issued_bicycle", true);
};
A.resetEcigRound <- function(bro) {
    if (this.isOrigin() && this.characterId(bro) == "afei") bro.getFlags().set("afeix_ecig_round", -1);
};
