(function () {
    "use strict";
    /*RESTORE_NATIVE_METHODS*/
    var proto = TacticalScreenTurnSequenceBarModule.prototype;
    var count = 0, serial = 0;
    function trace(label, slot, detail) {
        if (count >= 160) return;
        ++count;
        var node = slot && slot[0], entity = slot && slot.data('entity');
        var layer = slot && slot.find('.image-layer:first');
        var image = layer && layer.find('img.entity-image:first');
        console.error('AFEIX_TURNBAR_TRACE ' + JSON.stringify({event: label, detail: detail,
            id: entity && entity.id, serial: node && node._afeixTraceSerial,
            type: node && node.nodeType, tag: node && node.tagName, cls: node && node.className,
            attached: !!(node && document.documentElement.contains(node)),
            removal: slot && slot.is('[in-removal]'), layer: layer && layer.length,
            image: image && image.length, data: image && typeof image.data(),
            sameJQuery: !!(slot && slot.constructor === jQuery), slotJQuery: slot && slot.jquery,
            html: node && String(node.outerHTML).slice(0, 1000).replace(/</g, '[LT]').replace(/>/g, '[GT]'),
            stack: (new Error('turnbar trace')).stack}));
    }
    var create = proto.createEntityDIV;
    proto.createEntityDIV = function (id) {
        var slot = create.apply(this, arguments);
        slot[0]._afeixTraceSerial = ++serial;
        trace('create', slot, id);
        return slot;
    };
    var update = proto.updateEntityImage;
    proto.updateEntityImage = function (data, slot) {
        var image = slot.find('.image-layer:first img.entity-image:first');
        if (!image.length || !image.data('placeholder')) trace('bad-update', slot, data && data.id);
        return update.apply(this, arguments);
    };
    var remove = proto.removeEntity;
    proto.removeEntity = function (id) {
        var match = this.findEntityDIV(id);
        if (match) trace('remove', match.div, id);
        return remove.apply(this, arguments);
    };
    var clear = proto.clear;
    proto.clear = function () {
        trace('clear-bar', this.mEntitySliderContainer);
        return clear.apply(this, arguments);
    };
    var cleanup = $.cleanData;
    $.cleanData = function (elements) {
        for (var i = 0; i < elements.length; ++i) {
            var element = $(elements[i]);
            if (element.is('.entity-image')) trace('clean-portrait', element.closest('.l-entity'));
        }
        return cleanup.apply(this, arguments);
    };
    console.error('AFEIX_TURNBAR_TRACE NATIVE_METHODS_RESTORED; passive lifecycle trace active');
}());
