local A = ::AfeixExpedition;
// Called only from new-origin asset creation. Never respawn a lost/sold/dead pet
// on loading a save, visiting a town, switching routes or recreating metadata.
A.giveStartingRegen <- function() {
    if (!this.isOrigin() || this.get("dlc_regen_granted", false)) return false;
    local afei = this.findCharacter("afei");
    if (afei == null) return false;
    local items = afei.getItems();
    // The base origin equips Afei's electronic cigarette before this callback.
    // Keep equipped items and deliver the dog to the shared stash instead.
    local equip = items.getItemAtSlot(::Const.ItemSlot.Accessory) == null;
    local stash = ::World.Assets.getStash();
    if (!equip && stash.getNumberOfEmptySlots() == 0) return false;
    local dog = ::new("scripts/items/accessory/afeix_regen_item");
    if (!(equip && items.equip(dog)) && stash.add(dog) == null) return false;
    this.set("dlc_regen_granted", true);
    return true;
};
