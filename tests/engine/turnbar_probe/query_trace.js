// Passive selector diagnostics. Native DOM APIs are compared only after an
// unexpected empty result; no node or Sizzle cache is changed here.
(function () {
    var engine = $.find, count = 0;
    function inspect(selector, context, results, seed) {
        var result = engine.apply(this, arguments);
        var cls = context && context.nodeType === 1 ? context.getAttribute('class') || '' : '';
        if (count >= 12 || seed || result.length ||
                (selector !== '.l-entity' && selector !== '.image-layer:first' && selector !== 'img:first') ||
                (cls !== 'l-entity' && cls !== 'image-layer' && cls !== 'entity-slider-container')) return result;
        var simple = selector.replace(/:first$/, ''), nodes = [], tag = simple === 'img' ? 'img' : null;
        function walk(parent) {
            for (var child = parent.firstChild; child; child = child.nextSibling) {
                if (child.nodeType !== 1) continue;
                if (tag ? String(child.tagName).toLowerCase() === tag :
                        (' ' + (child.getAttribute('class') || '') + ' ').indexOf(' ' + simple.slice(1) + ' ') >= 0) nodes.push(child);
                walk(child);
            }
        }
        walk(context);
        if (!nodes.length) return result;
        ++count;
        function api(name, value) {
            try {return context[name] ? context[name](value).length : 'unsupported';}
            catch (e) {return String(e);}
        }
        console.error('AFEIX_SELECTOR_TRACE ' + JSON.stringify({selector: selector, rootClass: cls,
            nativeCount: result.length, rawCount: nodes.length,
            byClass: tag ? null : api('getElementsByClassName', simple.slice(1)),
            byTag: api('getElementsByTagName', tag || '*'), qsa: api('querySelectorAll', simple),
            supportClass: engine.support && engine.support.getElementsByClassName,
            supportQsa: engine.support && engine.support.qsa,
            firstClass: nodes[0].getAttribute('class'), firstTag: nodes[0].tagName,
            attached: document.documentElement.contains(context),
            engineSource: String(engine).slice(0, 80), jquery: $.fn.jquery,
            stack: (new Error('selector discrepancy')).stack}));
        return result;
    }
    for (var key in engine) if (engine.hasOwnProperty(key)) inspect[key] = engine[key];
    $.find = inspect;
}());
