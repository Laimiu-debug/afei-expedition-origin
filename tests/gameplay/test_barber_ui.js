const fs = require('fs'), vm = require('vm'), assert = require('assert');
let checks = 0;
function button() { return { enabled: true, enableButton(value) { this.enabled = value; } }; }
function Barber() {
    this.mAppearanceOptions = {};
    ['Color', 'Head', 'Hair', 'Beard', 'Body', 'Tattoo'].forEach(key => {
        this.mAppearanceOptions[key] = { UpButton: button(), DownButton: button() };
    });
    this.mDetailsPanel = { HireButton: button() };
    this.subtitle = '';
    this.mDialogContainer = { findDialogSubTitle: () => ({ text: text => { this.subtitle = text; } }) };
}
Barber.prototype.loadFromData = function () { return 'loaded'; };
Barber.prototype.updateDetailsPanel = function () { return 'updated'; };
vm.runInNewContext(fs.readFileSync('src/ui/mods/afeix/barber.js', 'utf8'), { WorldTownScreenBarberDialogModule: Barber });
const barber = new Barber();
barber.loadFromData({ SubTitle: '普通理发店' });
for (const locked of [true, false, true, false]) {
    assert.strictEqual(barber.updateDetailsPanel({ length: 1, data: () => ({ AfeixPortraitLocked: locked }) }), 'updated'); checks++;
    for (const control of Object.values(barber.mAppearanceOptions)) {
        assert.strictEqual(control.UpButton.enabled, !locked);
        assert.strictEqual(control.DownButton.enabled, !locked); checks += 2;
    }
    assert.strictEqual(barber.mDetailsPanel.HireButton.enabled, !locked); checks++;
    assert.strictEqual(barber.subtitle, locked ? '该人物使用专属外观，理发店无法修改。' : '普通理发店'); checks++;
}
barber.updateDetailsPanel(null);
assert.strictEqual(barber.mDetailsPanel.HireButton.enabled, true); checks++;
console.log('TESTS_PASSED=' + checks);
