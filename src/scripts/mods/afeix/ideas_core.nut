// Journal expansion. Stable flags keep content finite across world/tactical saves.
local A = ::AfeixExpedition;
// World parties use a destination, unlike tactical actors. There is no
// player_party.isMoving in the supported native game.
A.isWorldPartyMoving <- function() {
    local party = ::World.State.getPlayer();
    return party != null && party.m.Destination != null;
};
A.isTurtle <- function(a) { return this.isOrigin() && a != null && this.characterId(a) == "xiaogui"; };
A.syncIdeasCharacter <- function(a) {
    if (!this.isOrigin() || a == null || !a.isAlive()) return;
    if (this.isTurtle(a)) {
        local skills = a.getSkills();
        if (!skills.hasSkill("trait.afeix_turtle_body")) skills.add(::new("scripts/skills/traits/afeix_turtle_body"));
        if (!skills.hasSkill("perk.steel_brow")) skills.add(::new("scripts/skills/perks/perk_steel_brow"));
        // Retain an old helmet until there is room. Never destroy a saved item.
        if (!::Tactical.isActive()) {
            local items = a.getItems(), helmet = items.getItemAtSlot(::Const.ItemSlot.Head);
            local stash = ::World.Assets.getStash();
            if (helmet != null && stash.getNumberOfEmptySlots() > 0) {
                if (items.unequip(helmet)) {
                    if (stash.add(helmet) == null) {
                        this.IdeasRestoringHelmet = true;
                        try { items.equip(helmet); } catch (error) { this.IdeasRestoringHelmet = false; throw error; }
                        this.IdeasRestoringHelmet = false;
                    }
                }
            }
        }
    }
};
A.IdeasRestoringHelmet <- false;
A.GripID <- "weapon.afeix_laoma_grip";
A.gripBreakArmor <- function(actor, skill, target, part) {
    if (!this.isOrigin() || skill == null || skill.getID() != "actives.smite" || target == null || !target.isAlive() || target.isDying()) return 0;
    local w = skill.getItem();
    if (w == null || w.getID() != this.GripID || actor.isAlliedWith(target)) return 0;
    local serial = this.catalogGet(actor, "attempt_serial");
    if (serial <= 0 || this.catalogGet(actor, "grip_paid", -1) != serial || this.catalogGet(actor, "grip_done", -1) == serial) return 0;
    this.catalogSet(actor, "grip_done", serial);
    local slot = part == ::Const.BodyPart.Head ? ::Const.ItemSlot.Head : ::Const.ItemSlot.Body;
    local armor = target.getItems().getItemAtSlot(slot);
    // Damage a real armor item only. Bare monsters and the other body part are unaffected.
    if (armor == null || !("setCondition" in armor)) return 0;
    local before = armor.getCondition(), damage = ::Math.minf(30.0, before);
    if (damage <= 0) return 0;
    armor.setCondition(before - damage);
    target.getSkills().update();
    target.setDirty(true);
    if (!target.isHiddenToPlayer()) ::Tactical.EventLog.log("垂直开甲：" + target.getName() + (part == ::Const.BodyPart.Head ? "的头盔" : "的身甲") + "额外损失 " + damage.tointeger() + " 点护甲。");
    return damage;
};
A.gripRestock <- function(building, stash) {
    if (!this.isOrigin() || (building.getID() != "building.weaponsmith" && building.getID() != "building.marketplace")
        || !building.getSettlement().isAlliedWithPlayer()) return;
    foreach (item in stash.getItems()) if (item != null && item.getID() == this.GripID) return;
    if (::Math.rand(1, 100) > 5) return;
    local item = ::new("scripts/items/weapons/afeix_laoma_grip");
    item.setPriceMult(building.getPriceMult());
    stash.add(item);
    stash.sort();
};
