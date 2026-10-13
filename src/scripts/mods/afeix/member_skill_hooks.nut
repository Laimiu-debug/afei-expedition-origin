// getBravery is also read by threaded AI evaluation. Keep that native getter
// pure: skills.update can change HP, rebuild art and call the UI bridge.
// Refresh only before an actual morale check and main-thread combat events.
::mods_hookExactClass("entity/tactical/actor", function(o) {
    local checkMorale = o.checkMorale;
    o.checkMorale = function(change, difficulty, type = ::Const.MoraleCheckType.Default, icon = "", noNewLine = false) {
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
