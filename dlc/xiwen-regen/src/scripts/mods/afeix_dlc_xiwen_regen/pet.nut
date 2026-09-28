local A = ::AfeixExpedition;
// Called only from new-origin asset creation. Never respawn a lost/sold/dead pet
// on loading a save, visiting a town, switching routes or recreating metadata.
A.giveStartingRegen <- function() {
    if (!this.isOrigin() || this.get("dlc_regen_granted", false)) return false;
    local afei = this.findCharacter("afei");
    if (afei == null) return false;
    local items = afei.getItems();
    // Preserve an accessory granted by another add-on; keep the grant retryable.
    if (items.getItemAtSlot(::Const.ItemSlot.Accessory) != null) return false;
    local dog = ::new("scripts/items/accessory/afeix_regen_item");
    if (!items.equip(dog)) return false;
    this.set("dlc_regen_granted", true);
    return true;
};
