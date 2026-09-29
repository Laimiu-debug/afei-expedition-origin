(function () {
    "use strict";
    var proto = WorldTownScreenBarberDialogModule.prototype;
    var load = proto.loadFromData;
    proto.loadFromData = function (data) {
        this.afeixBarberSubtitle = data.SubTitle;
        return load.apply(this, arguments);
    };
    var update = proto.updateDetailsPanel;
    proto.updateDetailsPanel = function (element) {
        var data = element && element.length > 0 ? element.data('entry') : null;
        var locked = !!(data && data.AfeixPortraitLocked);
        var result = update.apply(this, arguments);
        Object.keys(this.mAppearanceOptions).forEach(function (key) {
            var control = this.mAppearanceOptions[key];
            if (control.UpButton) control.UpButton.enableButton(!locked);
            if (control.DownButton) control.DownButton.enableButton(!locked);
        }, this);
        this.mDetailsPanel.HireButton.enableButton(!locked);
        this.mDialogContainer.findDialogSubTitle().text(locked
            ? '该人物使用专属外观，理发店无法修改。'
            : (this.afeixBarberSubtitle || '在理发店调整弟兄们的外貌'));
        return result;
    };
}());
