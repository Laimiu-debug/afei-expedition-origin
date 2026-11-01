::mods_hookExactClass("states/tactical_state", function(o) {
    // Keep rendering/camera/particles running, but do not advance the actor
    // queue or parallel AI while the single short landing animation resolves.
    local update = o.updateCurrentEntity;
    o.updateCurrentEntity = function() {
        if(::AfeixExpedition.Douyu.hasRocketFlight(this)) { this.setInputLocked(true); return; }
        return update.bindenv(this)();
    };
    local ai = o.onProcessAI;
    o.onProcessAI = function() {
        if(::AfeixExpedition.Douyu.hasRocketFlight(this)) return;
        return ai.bindenv(this)();
    };
    local ended = o.onBattleEnded;
    o.onBattleEnded = function() {
        ::AfeixExpedition.Douyu.cancelRocketFlights(this);
        return ended.bindenv(this)();
    };
    local finish = o.onFinish;
    o.onFinish = function() {
        ::AfeixExpedition.Douyu.cancelRocketFlights(this);
        return finish.bindenv(this)();
    };
});
