// Extend only a formation array that needs more than the native 27 slots.
// The Squirrel adapter sends such arrays only for the Afei origin.
(function () {
    "use strict";
    var proto = CharacterScreenBrothersListModule.prototype;
    var original = proto.onBrothersListLoaded;
    var originalClear = proto.clearBrothersList;
    var originalAdd = proto.addBrotherSlotDIV;

    function stopEdgeScroll(self) {
        var state = self.afeixEdgeScroll;
        if (!state) return;
        clearTimeout(state.timer);
        $(window).off('blur.afeixFormation', state.onBlur);
        delete self.afeixEdgeScroll;
    }

    function edgeDirection(self, point) {
        var list = self.mListScrollContainer && self.mListScrollContainer[0];
        if (!list || !self.mSlots || self.mSlots.length <= 27) return 0;
        if (self.mDataSource.getInventoryMode() !== CharacterScreenDatasourceIdentifier.InventoryMode.Stash) return 0;
        var bounds = list.getBoundingClientRect();
        var left = bounds.left + list.clientLeft, top = bounds.top + list.clientTop;
        var bottom = top + list.clientHeight;
        if (point.x < left || point.x >= left + list.clientWidth || point.y < top || point.y >= bottom) return 0;
        var band = Math.min(self.mSlots[0].outerHeight(true) / 4, list.clientHeight / 6);
        return point.y < top + band ? -1 : (point.y >= bottom - band ? 1 : 0);
    }

    function trackEdgeScroll(self, event, drag) {
        var point = { x: event.clientX, y: event.clientY };
        var direction = edgeDirection(self, point);
        if (!direction) { stopEdgeScroll(self); return; }
        var state = self.afeixEdgeScroll;
        if (state && state.direction === direction && state.drag[0] === drag[0]) {
            state.point = point;
            return;
        }
        stopEdgeScroll(self);
        state = { point: point, direction: direction, drag: drag };
        state.onBlur = function () { stopEdgeScroll(self); };
        self.afeixEdgeScroll = state;
        $(window).on('blur.afeixFormation', state.onBlur);
        function tick() {
            var from = state.drag.data('idx'), slot = self.mSlots && self.mSlots[from];
            var child = slot && slot.data('child');
            // Refreshing the roster, changing screens/mode, or losing focus
            // must never leave a detached character scrolling the next view.
            if (!child || child[0] !== state.drag[0] || !edgeDirection(self, state.point)) {
                stopEdgeScroll(self);
                return;
            }
            var list = self.mListScrollContainer, before = list.scrollTop();
            list.scrollTop(before + state.direction * self.mSlots[0].outerHeight(true) / 8);
            if (list.scrollTop() === before) { stopEdgeScroll(self); return; }
            state.timer = setTimeout(tick, 60);
        }
        // A brief dwell avoids scrolling when simply dropping near an edge.
        // Continue while the pointer is still: no wheel or repeated moves needed.
        state.timer = setTimeout(tick, 200);
    }

    ['hide', 'destroyDIV'].forEach(function (name) {
        var nativeMethod = proto[name];
        if (!nativeMethod) return;
        proto[name] = function () {
            stopEdgeScroll(this);
            return nativeMethod.apply(this, arguments);
        };
    });

    // jquery.event.drop 2.2 caches slot bounds at dragstart, before the list
    // scrolls. Resolve the release against live, clipped DOM bounds instead.
    function slotAtPointer(self, event) {
        var list = self.mListScrollContainer[0];
        if (!list || typeof event.clientX !== 'number' || typeof event.clientY !== 'number') return -1;
        var bounds = list.getBoundingClientRect();
        var x = event.clientX, y = event.clientY;
        var left = bounds.left + list.clientLeft, top = bounds.top + list.clientTop;
        if (x < left || x >= left + list.clientWidth || y < top || y >= top + list.clientHeight) return -1;
        for (var i = 0; i < self.mSlots.length; i++) {
            var rect = self.mSlots[i][0].getBoundingClientRect();
            if (x >= rect.left && x < rect.right && y >= rect.top && y < rect.bottom) return i;
        }
        return -1;
    }

    function moveBrother(self, drag, to) {
        var from = drag.data('idx');
        if (from === undefined || from === to || !self.mSlots[from] || !self.mSlots[to]) return false;
        var child = self.mSlots[from].data('child');
        if (!child || child[0] !== drag[0]) return false;
        if (self.mDataSource.getInventoryMode() !== CharacterScreenDatasourceIdentifier.InventoryMode.Stash) return false;
        var empty = self.mSlots[to].data('child') == null;
        if (empty && from < 18 && to >= 18 && self.mNumActive === 1) return false;
        if (empty && from >= 18 && to < 18 && self.mNumActive >= self.mNumActiveMax) return false;
        self.swapSlots(from, to);
        return true;
    }

    proto.addBrotherSlotDIV = function (parent, data, index, allowReordering) {
        var result = originalAdd.call(this, parent, data, index, allowReordering);
        if (this.mSlots.length <= 27 || !allowReordering) return result;
        var self = this, child = this.mSlots[index].data('child');
        child.drag(function (event, dd) {
            trackEdgeScroll(self, event, $(dd.drag));
        });
        // The native callback would animate an empty dd.drop back to the old
        // page. Replace it on this freshly rendered brother only. Disabling
        // plugin drops also prevents its hover/dropend callbacks from swapping.
        child.off('dragend').drag('end', function (event, dd) {
            var drag = $(dd.drag);
            stopEdgeScroll(self);
            try { moveBrother(self, drag, slotAtPointer(self, event)); }
            finally {
                $(dd.proxy).remove();
                drag.removeClass('is-dragged');
            }
        }, { drop: false });
        return result;
    };

    function configureScrolling(self, expanded) {
        var list = self.mListScrollContainer;
        list.off('.afeixFormation');
        if (!expanded) {
            if (self.afeixOldOverflow !== undefined) {
                list.css('overflow-y', self.afeixOldOverflow).scrollTop(0);
                delete self.afeixOldOverflow;
            }
            return;
        }
        if (self.afeixOldOverflow === undefined) self.afeixOldOverflow = list.css('overflow-y');
        list.css('overflow-y', 'auto');
        // Choose one browser event family so a wheel notch is never counted
        // twice. Half a visible row remains useful across UI scale settings.
        var events = 'onwheel' in document ? 'wheel.afeixFormation' : 'mousewheel.afeixFormation DOMMouseScroll.afeixFormation';
        list.on(events, function (event) {
            var wheel = event.originalEvent || event;
            var delta = wheel.deltaY !== undefined ? wheel.deltaY :
                (wheel.wheelDelta !== undefined ? -wheel.wheelDelta : wheel.detail);
            if (!delta || wheel.ctrlKey) return;
            var step = self.mSlots[0].outerHeight(true) / 2;
            list.scrollTop(list.scrollTop() + (delta > 0 ? step : -step));
            event.preventDefault();
            event.stopPropagation();
        });
    }

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
        configureScrolling(this, required > 27);
    }

    // Hooks JS can load after the native constructor has already bound its list
    // listener with jQuery.proxy. That callback retains the original function,
    // but calls clearBrothersList dynamically before rendering any slot.
    proto.clearBrothersList = function () {
        stopEdgeScroll(this);
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
