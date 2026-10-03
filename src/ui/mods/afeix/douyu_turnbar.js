(function () {
    "use strict";
    var proto = TacticalScreenTurnSequenceBarModule.prototype;
    proto.afeixInvalidateFirstSlot = function () {
        this._afeixFirstSlotGeneration = (this._afeixFirstSlotGeneration || 0) + 1;
    };
    var enter = proto.notifyBackendEntityEntersFirstSlot;
    proto.notifyBackendEntityEntersFirstSlot = function (id, callback) {
        var self = this;
        var generation = this._afeixFirstSlotGeneration || 0;
        return enter.call(this, id, function (data) {
            // A scoped clear can finish before this native async reply arrives.
            if (generation !== (self._afeixFirstSlotGeneration || 0)) return;
            // Only the scoped backend repair emits this marker. Ordinary
            // callbacks, including unrelated null failures, pass through.
            if (data && data.AfeixRemovedFirstSlot === true) return;
            callback(data);
        });
    };
}());
