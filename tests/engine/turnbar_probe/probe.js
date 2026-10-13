(function () {
    "use strict";
    var nativeFactory = /*NATIVE_FACTORY*/
    function describe(node) {
        if (!node) return {missing: true};
        return {type: node.nodeType, tag: node.tagName, className: node.className,
            attr: node.getAttribute ? node.getAttribute('class') : 'no-getAttribute',
            childNodes: node.childNodes ? node.childNodes.length : -1,
            outerHTML: typeof node.outerHTML};
    }
    function capture(label, root) {
        var layer = root.find('.image-layer:first');
        var image = layer.find('img.entity-image:first');
        var children = [], list = root[0] && root[0].childNodes;
        if (list) for (var i = 0; i < list.length && i < 5; ++i) children.push(describe(list[i]));
        console.error('AFEIX_UI_PROBE ' + JSON.stringify({label: label,
            jquery: $.fn.jquery, rootLength: root.length, root: describe(root[0]),
            children: children, layer: layer.length, layerWithoutFirst: root.find('.image-layer').length,
            image: image.length, dataType: typeof image.data(), firstImage: describe(root.find('img:first')[0])}));
    }
    function markup(explicit) {
        var root = $('<div class="l-entity"></div>');
        var container = $(explicit ? '<div class="entity"></div>' : '<div class="entity"/>');
        var layer = $(explicit ? '<div class="image-layer"></div>' : '<div class="image-layer"/>');
        var image = $('<img class="entity-image"/>');
        root.append(container); container.append(layer); layer.append(image);
        image.data('placeholder', $('<img class="placeholder-image"/>').appendTo(layer));
        return root;
    }
    function primitives() {
        function element(tag, cls) {
            var node = document.createElement(tag); node.setAttribute('class', cls); return node;
        }
        var root = element('div', 'l-entity'), container = element('div', 'entity');
        var layer = element('div', 'image-layer'), image = element('img', 'entity-image');
        root.appendChild(container); container.appendChild(layer); layer.appendChild(image);
        $(image).data('placeholder', $(element('img', 'placeholder-image')).appendTo(layer));
        return $(root);
    }
    $(function () {
        setTimeout(function () {
            var sandbox = $('<div style="display:none"></div>').appendTo(document.body);
            var bar = new TacticalScreenTurnSequenceBarModule();
            bar.mEntityMouseEnterCallback = bar.mEntityMouseLeaveCallback = bar.mEntityClickedCallback = function () {};
            var cases = [
                ['native-factory', function () { return nativeFactory.call(bar, 1); }],
                ['self-closing', function () { return markup(false); }],
                ['explicit-closing', function () { return markup(true); }],
                ['createElement', primitives]
            ];
            for (var i = 0; i < cases.length; ++i) {
                try {
                    var root = cases[i][1]();
                    capture(cases[i][0] + '-detached', root);
                    sandbox.append(root);
                    capture(cases[i][0] + '-attached', root);
                    root.remove();
                } catch (error) {
                    console.error('AFEIX_UI_PROBE ' + cases[i][0] + ' exception=' + error + ' stack=' + error.stack);
                }
            }
            sandbox.remove();
            console.error('AFEIX_UI_PROBE COMPLETE');
        }, 500);
    });
}());
