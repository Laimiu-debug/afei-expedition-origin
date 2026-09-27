// Refresh conditional resolve before an actual morale check, and recovery before
// vanilla consumes it. Never replace attackEntity or the engine's damage rules.
::mods_hookExactClass("entity/tactical/actor", function(o) {
    local getBravery = o.getBravery;
    o.getBravery = function() {
        ::AfeixExpedition.refreshMemberAura(this);
        return getBravery.bindenv(this)();
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
