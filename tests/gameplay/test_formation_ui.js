const fs = require('fs');
const vm = require('vm');
const assert = require('assert');
let passed = 0;
function check(value, message) { assert.ok(value, message); passed++; }
class Element {
    constructor() { this.values = {}; this.styles = { 'overflow-y': 'visible' }; this.children = []; this.removed = false; this.handlers = {}; this.scroll = 0; }
    data(key, value) { if (arguments.length === 1) return this.values[key]; this.values[key] = value; return this; }
    css(key, value) { if (arguments.length === 1) return this.styles[key]; this.styles[key] = value; return this; }
    append(child) { this.children.push(child); return this; }
    drop(name, fn) { this.onDrop = fn; return this; }
    empty() { this.children = []; return this; }
    remove() { this.removed = true; return this; }
    removeClass() { return this; }
    appendTo(parent) { parent.append(this); return this; }
    detach() { return this; }
    off(namespace) { Object.keys(this.handlers).filter(key => key.indexOf(namespace) >= 0).forEach(key => delete this.handlers[key]); return this; }
    on(events, fn) { events.split(' ').forEach(event => { this.handlers[event] = fn; }); return this; }
    outerHeight() { return 82; }
    scrollTop(value) { if (value === undefined) return this.scroll; this.scroll = Math.max(0, Math.min(322, value)); return this; }
}
global.document = { onwheel: null };
global.$ = function (value) { return value instanceof Element ? value : new Element(); };
global.CharacterScreenDatasourceIdentifier = { InventoryMode: { Stash: 'stash', Ground: 'ground' } };
global.CharacterScreenBrothersListModule = function () {};
const proto = CharacterScreenBrothersListModule.prototype;
proto.clearBrothersList = function () {
    this.mSlots.forEach(slot => { slot.empty(); slot.data('child', null); });
    this.mNumActive = 0;
};
proto.onBrothersListLoaded = function (source, brothers) {
    this.clearBrothersList();
    if (!brothers) return;
    brothers.forEach((bro, i) => {
        if (!bro) return;
        assert.ok(this.mSlots[i], 'native renderer must have a real slot');
        this.mSlots[i].data('child', bro);
        if (i < 18) this.mNumActive++;
    });
};
// The live game constructs this listener before mods_registerJS runs.
const capturedNativeListener = proto.onBrothersListLoaded;
vm.runInThisContext(fs.readFileSync('src/ui/mods/afeix/formation.js', 'utf8'));
let mode = 'stash';
const screen = new CharacterScreenBrothersListModule();
screen.mSlots = Array.from({ length: 27 }, (_, i) => new Element().data('idx', i).data('child', null));
screen.mListScrollContainer = new Element();
screen.mDataSource = { getInventoryMode: () => mode };
screen.mNumActiveMax = 12;
screen.swaps = [];
screen.swapSlots = function (from, to) { this.swaps.push([from, to]); };
const board = Array(38).fill(null);
board[3] = { id: 1 };
for (let i = 18; i <= 36; i++) board[i] = { id: i - 16 };
screen.onBrothersListLoaded(screen.mDataSource, board);
check(screen.mSlots.length === 38, 'enlarged backend formation creates enough UI slots');
check(screen.mSlots.filter(s => s.data('child')).length === 20, 'all twenty members remain visible');
check(screen.mNumActive === 1, 'nineteen reserves do not count as active');
check(screen.mListScrollContainer.css('overflow-y') === 'auto', 'reserve rows can scroll');
function wheelOn(targetScreen, properties) {
    let prevented = false, stopped = false;
    const fn = targetScreen.mListScrollContainer.handlers['wheel.afeixFormation'] ||
        targetScreen.mListScrollContainer.handlers['mousewheel.afeixFormation'];
    fn({ originalEvent: properties, preventDefault() { prevented = true; }, stopPropagation() { stopped = true; } });
    return prevented && stopped;
}
check(wheelOn(screen, { deltaY: 120 }) && screen.mListScrollContainer.scrollTop() === 41, 'one wheel notch moves half a row and suppresses default page jump');
check(wheelOn(screen, { deltaY: -1 }) && screen.mListScrollContainer.scrollTop() === 0, 'reverse wheel uses the same small step');
check(!wheelOn(screen, { deltaY: 0, deltaX: 120 }) && screen.mListScrollContainer.scrollTop() === 0, 'horizontal wheel leaves the roster alone');
check(!wheelOn(screen, { deltaY: 120, ctrlKey: true }), 'zoom gesture is not treated as roster scrolling');
delete document.onwheel;
screen.onBrothersListLoaded(screen.mDataSource, board);
check(wheelOn(screen, { wheelDelta: -120 }) && screen.mListScrollContainer.scrollTop() === 41, 'legacy game mousewheel uses half a row');
document.onwheel = null;
screen.onBrothersListLoaded(screen.mDataSource, board);
check(Object.keys(screen.mListScrollContainer.handlers).length === 1, 'refresh does not stack wheel handlers');
for (let i = 27; i < 38; i++) {
    check(screen.mSlots[i].data('idx') === i && typeof screen.mSlots[i].onDrop === 'function', 'each extra slot has its own index and handler');
}
function drag(from, to) {
    return screen.mSlots[to].onDrop({}, { drag: new Element().data('idx', from), drop: screen.mSlots[to], proxy: new Element().data('idx', from) });
}
check(drag(3, 37) === false && screen.swaps.length === 0, 'cannot send last active member to empty reserve');
check(drag(3, 28) === true && screen.swaps[0][1] === 28, 'last active may swap with an occupied reserve');
check(drag(19, 37) === true, 'reserve-to-reserve reorder works');
mode = 'ground';
check(drag(19, 37) === false, 'loot screen cannot reorder formation');
mode = 'stash'; screen.mNumActive = 2;
check(drag(3, 37) === true, 'can reserve a member when another remains active');
check(drag(37, 37) === false, 'self-drop ignored');
const extra = screen.mSlots[37];
screen.onBrothersListLoaded(screen.mDataSource, Array(27).fill(null));
check(screen.mSlots.length === 27 && extra.removed, 'another origin returns to native slot count');
check(screen.mListScrollContainer.css('overflow-y') === 'visible', 'another origin gets original overflow style');
check(screen.mListScrollContainer.scrollTop() === 0 && Object.keys(screen.mListScrollContainer.handlers).length === 0, 'another origin resets scroll and removes custom wheel events');
screen.onBrothersListLoaded(screen.mDataSource, null);
check(screen.mSlots.length === 27, 'empty tactical roster remains safe');

// The backend keeps 18 battle positions and allocates one reserve position per
// company member. Exercise every allowed deployed count with the full cast and
// with all five ordinary-mercenary spaces filled, not just the old 20-person cap.
const battleOrder = [3, 4, 5, 2, 6, 12, 13, 14, 11, 15, 1, 7];
function makeBoard(size, deployed) {
    const result = Array(18 + size).fill(null);
    for (let i = 0; i < size; i++) {
        result[i < deployed ? battleOrder[i] : 18 + i - deployed] = { id: i + 1 };
    }
    return result;
}
function makeScreen() {
    const result = new CharacterScreenBrothersListModule();
    result.mSlots = Array.from({ length: 27 }, (_, i) => new Element().data('idx', i).data('child', null));
    result.mListScrollContainer = new Element();
    result.mDataSource = { getInventoryMode: () => mode };
    result.mNumActiveMax = 12;
    result.swaps = [];
    result.swapSlots = function (from, to) {
        const a = this.mSlots[from].data('child'), b = this.mSlots[to].data('child');
        this.mSlots[from].data('child', b);
        this.mSlots[to].data('child', a);
        if (!b && from < 18 && to >= 18) this.mNumActive--;
        if (!b && from >= 18 && to < 18) this.mNumActive++;
        this.swaps.push([from, to]);
    };
    return result;
}
function dropOn(targetScreen, from, to, proxyIndex = from) {
    return targetScreen.mSlots[to].onDrop({}, {
        drag: new Element().data('idx', from),
        drop: targetScreen.mSlots[to],
        proxy: new Element().data('idx', proxyIndex)
    });
}
function idsIn(targetScreen) {
    return targetScreen.mSlots.map(s => s.data('child')).filter(Boolean).map(b => b.id).sort((a, b) => a - b);
}
for (const size of [35, 40]) {
    for (let deployed = 1; deployed <= 12; deployed++) {
        const large = makeScreen(), positions = makeBoard(size, deployed);
        const expected = Array.from({ length: size }, (_, i) => i + 1);
        large.onBrothersListLoaded(large.mDataSource, positions);
        check(large.mSlots.length === 18 + size, `${size}/${deployed}: backend array is fully rendered`);
        check(JSON.stringify(idsIn(large)) === JSON.stringify(expected), `${size}/${deployed}: nobody lost or duplicated`);
        check(large.mNumActive === deployed, `${size}/${deployed}: reserves do not become deployed`);
        check(large.mListScrollContainer.css('overflow-y') === 'auto', `${size}/${deployed}: all reserve rows can scroll`);
        check(large.mSlots.slice(27).every((s, i) => s.data('idx') === i + 27 && typeof s.onDrop === 'function'), `${size}/${deployed}: every extended slot is addressable`);
        const lastOccupied = 18 + size - deployed - 1, empty = 18 + size - 1;
        check(dropOn(large, lastOccupied, empty) === true, `${size}/${deployed}: deepest reserve moves into last empty slot`);
        check(dropOn(large, empty, 27) === true, `${size}/${deployed}: deepest reserve swaps with occupied reserve`);
        check(JSON.stringify(idsIn(large)) === JSON.stringify(expected), `${size}/${deployed}: dragging preserves all identities`);
        check(large.mNumActive === deployed, `${size}/${deployed}: reserve dragging preserves deployed count`);
        check(dropOn(large, 27, 27) === false, `${size}/${deployed}: reserve self-drop rejected`);
        const extendedSlots = large.mSlots.slice(27);
        large.onBrothersListLoaded(large.mDataSource, positions);
        check(large.mSlots.length === 18 + size && extendedSlots.every((s, i) => s === large.mSlots[i + 27]), `${size}/${deployed}: refresh reuses extended slots`);
        large.onBrothersListLoaded(large.mDataSource, Array(27).fill(null));
        check(large.mSlots.length === 27 && extendedSlots.every(s => s.removed), `${size}/${deployed}: another origin removes all extra slots`);
        check(large.mListScrollContainer.css('overflow-y') === 'visible', `${size}/${deployed}: native overflow restored`);
    }
}
const forty = makeScreen(), fortyBoard = makeBoard(40, 1);
forty.onBrothersListLoaded(forty.mDataSource, fortyBoard);
check(forty.mSlots[56].data('child').id === 40 && forty.mSlots[57].data('child') == null, 'one active plus thirty-nine reserves reaches slot 56 and leaves slot 57 empty');
check(dropOn(forty, 3, 57) === false, 'last active cannot move into the new last empty reserve');
check(dropOn(forty, 3, 56) === true && forty.mSlots[3].data('child').id === 40, 'last active can be exchanged with the thirty-ninth reserve');
mode = 'ground';
check(dropOn(forty, 56, 57) === false, 'large roster cannot be dragged in loot mode');
mode = 'stash';
check(dropOn(forty, 999, 57) === false, 'stale out-of-range drag is ignored');
check(dropOn(forty, 56, 57, undefined) === true, 'normal reserve move remains available after loot mode');
const nativeSlots = forty.mSlots.slice(0, 27);
forty.onBrothersListLoaded(forty.mDataSource, makeBoard(35, 10));
check(forty.mSlots.length === 53 && nativeSlots.every((s, i) => s === forty.mSlots[i]), 'shrinking from forty to thirty-five retains original slots');
forty.onBrothersListLoaded(forty.mDataSource, []);
check(forty.mSlots.length === 27 && forty.mSlots.every(s => s.data('child') == null), 'empty campaign removes extended slots and stale occupants');
forty.onBrothersListLoaded(forty.mDataSource, makeBoard(40, 10));
check(forty.mSlots.length === 58 && forty.mNumActive === 10, 'returning to large campaign restores extended roster');

const latePatched = makeScreen();
let liveBoard = makeBoard(34, 10);
latePatched.mDataSource.getBrothersList = () => liveBoard;
capturedNativeListener.call(latePatched, latePatched.mDataSource, liveBoard);
check(latePatched.mSlots.length === 52 && idsIn(latePatched).length === 34, 'listener bound before patch renders all 34 members');
check(latePatched.mNumActive === 10 && latePatched.mListScrollContainer.css('overflow-y') === 'auto', 'late hook preserves ten active and scrollable reserves');
liveBoard = Array(27).fill(null);
capturedNativeListener.call(latePatched, latePatched.mDataSource, liveBoard);
check(latePatched.mSlots.length === 27 && latePatched.mListScrollContainer.css('overflow-y') === 'visible', 'captured native callback restores a different origin');

// Optional integration with a locally audited native UI source. The source is
// not distributed with the mod. Run its real drop handlers and swapSlots, using
// only a tiny DOM/data-source stub, to verify the unchanged battle-slot limit.
const nativeSource = '.cache/afei-art/gameplay-audit/character_screen_brothers_list_module.js';
if (fs.existsSync(nativeSource)) {
    const context = vm.createContext({ $, CharacterScreenDatasourceIdentifier, console, document });
    vm.runInContext(fs.readFileSync(nativeSource, 'utf8'), context);
    const nativeProto = context.CharacterScreenBrothersListModule.prototype;
    nativeProto.onBrothersListLoaded = function (source, brothers) {
        this.clearBrothersList();
        brothers.forEach((bro, i) => {
            if (!bro) return;
            this.mSlots[i].data('child', new Element().data('ID', bro.id).data('idx', i));
            if (i < 18) this.mNumActive++;
        });
    };
    vm.runInContext(fs.readFileSync('src/ui/mods/afeix/formation.js', 'utf8'), context);
    const nativeScreen = Object.create(nativeProto), updates = [], swaps = [];
    nativeScreen.mListScrollContainer = new Element();
    nativeScreen.mNumActiveMax = 12;
    nativeScreen.mDataSource = {
        getInventoryMode: () => 'stash',
        swapBrothers: (from, to) => swaps.push([from, to]),
        notifyBackendUpdateRosterPosition: (id, place) => updates.push([id, place]),
        getSelectedBrotherIndex: () => -1,
        setSelectedBrotherIndex: () => {}
    };
    nativeScreen.updateBlockedSlots = function () {};
    nativeScreen.updateRosterLabel = function () {};
    nativeScreen.createBrotherSlots(nativeScreen.mListScrollContainer);
    nativeScreen.onBrothersListLoaded(nativeScreen.mDataSource, makeBoard(40, 12));
    check(dropOn(nativeScreen, 45, 17) === false && nativeScreen.mNumActive === 12 && swaps.length === 0, 'native battle handler still blocks a thirteenth member from far reserve');
    dropOn(nativeScreen, 45, 3);
    check(nativeScreen.mSlots[3].data('child').data('ID') === 40 && nativeScreen.mNumActive === 12, 'native occupied battle swap accepts far reserve at full capacity');
    check(updates.some(([id, place]) => id === 1 && place === 45), 'native swap reports extended reserve index to backend');
    check(dropOn(nativeScreen, 3, 57) === true && nativeScreen.mNumActive === 11, 'native swapSlots supports dropping an active member into slot 57');
    dropOn(nativeScreen, 57, 17);
    check(nativeScreen.mSlots[17].data('child').data('ID') === 40 && nativeScreen.mNumActive === 12, 'native handler restores a twelfth active from slot 57');
    const nativeIds = nativeScreen.mSlots.map(s => s.data('child')).filter(Boolean).map(b => b.data('ID'));
    check(nativeIds.length === 40 && new Set(nativeIds).size === 40, 'native drag flow preserves all forty entities');
    console.log('NATIVE_UI_DROP_CHECKS_PASSED');
}
console.log('TESTS_PASSED=' + passed);
