// The dream's named standard keeps the native banner art, aura and polearm attack.
// It is constructed only for temporary dream actors and never issued to the stash.
this.afeix_dream_warbanner <- this.inherit("scripts/items/tools/player_banner", {
    m = {},
    function create() {
        this.player_banner.create();
        this.m.ID = "weapon.afeix_dream_warbanner";
        this.m.Name = "黑旗·梦中誓言";
        this.m.Description = "梦中十人始终能看见的黑旗。醒来后，它的重量仍等着伙伴们共同接住。";
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Named;
        this.m.IsDroppedAsLoot = false;
        this.m.RegularDamage = 60;
        this.m.RegularDamageMax = 84;
        this.m.StaminaModifier = -12;
        this.m.Variant = 4;
        this.updateVariant();
    }
});
