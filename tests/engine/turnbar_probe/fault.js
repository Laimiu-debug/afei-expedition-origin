// Local diagnostic ZIP only: deliberately reproduce an empty selector result
// on intact DOM inside the actual game engine. This is not a natural repro.
(function () {
    var engine = $.find, armed = false, failures = 0, activations = 0;
    function fault(selector, context, results, seed) {
        var cls = context && context.nodeType === 1 ? context.getAttribute('class') || '' : '';
        if (armed && (selector === '.image-layer:first' || selector === 'img:first') &&
                (cls === 'l-entity' || cls === 'image-layer')) {
            ++failures;
            if (failures <= 3) console.error('AFEIX_QUERY_PROBE EMPTY selector=' + selector + ' class=' + cls);
            return results || [];
        }
        return engine.apply(this, arguments);
    }
    for (var key in engine) if (engine.hasOwnProperty(key)) fault[key] = engine[key];
    $.find = fault;
    var proto = TacticalScreenTurnSequenceBarModule.prototype, select = proto.selectFirstEntity;
    proto.selectFirstEntity = function () {
        ++activations;
        if (activations === 3) {
            armed = true;
            console.error('AFEIX_QUERY_PROBE ARMED after two native activations');
        }
        return select.apply(this, arguments);
    };
    setInterval(function () {
        console.error('AFEIX_QUERY_PROBE STATE failures=' + failures + ' activations=' + activations);
    }, 5000);
}());
