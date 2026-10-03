// A turn-start death can leave native CurrentEntities pointing at the corpse
// while the frontend still holds the selection lock. Rebuild only the dream
// and real Douyu encounter, preserving living actors' AP and turn state.
::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(o) {
    local isScoped = function() {
        local A = ::AfeixExpedition;
        if (A.isDreamCombat()) return true;
        if (!A.isOrigin() || ::Tactical.State == null) return false;
        local p = ::Tactical.State.getStrategicProperties();
        return p != null && "CombatID" in p && p.CombatID == "afeix_douyu_final";
    };
    local remove = o.removeEntities;
    o.removeEntities = function() {
        // Native clear cancels its timer but not an already pending async query.
        if (isScoped() && this.m.JSHandle != null) this.m.JSHandle.call("afeixInvalidateFirstSlot", null);
        return remove.bindenv(this)();
    };
    local enter = o.onEntityEntersFirstSlot;
    o.onEntityEntersFirstSlot = function(id) {
        local A = ::AfeixExpedition, dream = A.isDreamCombat();
        local scoped = isScoped();
        if (dream && A.DreamSession.ending) return { AfeixRemovedFirstSlot = true };
        local data = enter.bindenv(this)(id);
        if (!scoped) return data;
        if (dream && (!A.isDreamCombat() || A.DreamSession.ending)) return { AfeixRemovedFirstSlot = true };
        if (data != null) return data;

        local removed = 0;
        while (this.m.CurrentEntities.len() != 0) {
            local actor = this.m.CurrentEntities[0];
            if (actor.isAlive() && !actor.isDying() && actor.isPlacedOnMap()) break;
            this.m.CurrentEntities.remove(0); ++this.m.TurnPosition; ++removed;
            if (this.m.CurrentEntities.len() != 0) this.m.CurrentEntities[0].onBeforeActivation();
        }
        // clear also cancels the old first-slot selection timer in native JS.
        this.m.JSHandle.call("afeixInvalidateFirstSlot", null);
        this.m.JSHandle.call("clear", null);
        if (this.m.CurrentEntities.len() != 0) {
            this.m.IsLocked = true;
            this.reloadVisibleEntities();
        }
        else {
            this.m.IsLocked = false;
            if (this.m.AllEntities.len() != 0) {
                this.m.IsInitNextRound = true; this.m.CheckEnemyRetreat = true;
            }
            else this.checkBattleEndedCondition();
        }
        ::logInfo("AFEIX_DOUYU TURNBAR_RECOVER removed=" + removed);
        // The frontend consumes this marker without rendering the dead slot.
        return { AfeixRemovedFirstSlot = true };
    };
});
