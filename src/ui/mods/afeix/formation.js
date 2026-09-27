// Extend only a formation array that needs more than the native 27 slots.
// The Squirrel adapter sends such arrays only for the Afei origin.
(function () {
    "use strict";
    var proto = CharacterScreenBrothersListModule.prototype;
    var original = proto.onBrothersListLoaded;
    var originalClear = proto.clearBrothersList;

    function resizeSlots(brothers) {
        var required = Array.isArray(brothers) ? Math.max(27, brothers.length) : 27;
        var self = this;
        // Clear while all old slots still exist, before shrinking on a different campaign.
        while (this.mSlots.length > required) this.mSlots.pop().remove();
        while (this.mSlots.length < required) {
            var index = this.mSlots.length;
            var slot = $('<div class="ui-control is-brother-slot is-reserve-slot"/>');
            slot.data('idx', index);
            slot.data('child', null);
            slot.drop("end", function (event, dd) {
                var drag = $(dd.drag), drop = $(dd.drop), proxy = $(dd.proxy);
                if (proxy.data('idx') === undefined || drop.data('idx') === undefined) return false;
                var from = drag.data('idx'), to = drop.data('idx');
                if (from === undefined || from === to || !self.mSlots[from]) return false;
                if (self.mDataSource.getInventoryMode() !== CharacterScreenDatasourceIdentifier.InventoryMode.Stash) return false;
                var empty = self.mSlots[to].data('child') == null;
                if (self.mNumActive === 1 && from < 18 && empty) return false;
                drag.removeClass('is-dragged');
                self.swapSlots(from, to);
                return true;
            });
            this.mListScrollContainer.append(slot);
            this.mSlots.push(slot);
        }
        if (required > 27) {
            if (this.afeixOldOverflow === undefined) this.afeixOldOverflow = this.mListScrollContainer.css('overflow-y');
            this.mListScrollContainer.css('overflow-y', 'auto');
        } else if (this.afeixOldOverflow !== undefined) {
            this.mListScrollContainer.css('overflow-y', this.afeixOldOverflow);
            delete this.afeixOldOverflow;
        }
    }

    // Hooks JS can load after the native constructor has already bound its list
    // listener with jQuery.proxy. That callback retains the original function,
    // but calls clearBrothersList dynamically before rendering any slot.
    proto.clearBrothersList = function () {
        originalClear.call(this);
        var brothers = this.afeixIncomingBrothers;
        if (brothers === undefined && this.mDataSource && this.mDataSource.getBrothersList) {
            brothers = this.mDataSource.getBrothersList();
        }
        resizeSlots.call(this, brothers);
    };
    proto.onBrothersListLoaded = function (source, brothers) {
        this.afeixIncomingBrothers = brothers;
        try { return original.call(this, source, brothers); }
        finally { delete this.afeixIncomingBrothers; }
    };
}());
