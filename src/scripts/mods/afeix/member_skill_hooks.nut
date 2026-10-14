// getBravery is also read by threaded AI evaluation. Keep that native getter
// pure: skills.update can change HP, rebuild art and call the UI bridge.
// Refresh only before an actual morale check and main-thread combat events.
::mods_hookExactClass("entity/tactical/actor", function(o) {
    local checkMorale = o.checkMorale;
    o.checkMorale = function(change, difficulty, type = ::Const.MoraleCheckType.Default, icon = "", noNewLine = false) {
        // Native checkMorale returns before reading resolve for these states.
        // Death broadcasts often include already-confident players; refreshing
        // their skills here rebuilds HP/portraits for a check that cannot run.
        local morale = this.getMoraleState();
        if (morale != ::Const.MoraleState.Ignore
            && !(change > 0 && morale == ::Const.MoraleState.Confident)
            && !(change < 0 && morale == ::Const.MoraleState.Fleeing)
            && !(change == 1 && morale == ::Const.MoraleState.Fleeing))
            ::AfeixExpedition.refreshMemberAura(this);
        return checkMorale.bindenv(this)(change, difficulty, type, icon, noNewLine);
    };
    local onTurnStart = o.onTurnStart;
    o.onTurnStart = function() {
        ::AfeixExpedition.refreshMemberAura(this);
        return onTurnStart.bindenv(this)();
    };
    local onMovementFinish = o.onMovementFinish;
    o.onMovementFinish = function(tile) {
        local result = onMovementFinish.bindenv(this)(tile), A = ::AfeixExpedition;
        if (A.isOrigin() && ::Tactical.isActive())
            foreach (actor in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) A.refreshMemberAura(actor);
        return result;
    };
});
