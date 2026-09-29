// Browser regression using the installed game's jQuery, drag/drop plugins,
// brother CSS and real list module (extracted into the ignored audit cache).
// Needs Python, Playwright on NODE_PATH and, optionally, BROWSER_EXECUTABLE.
// BB_GAME_DATA overrides the default local Battle Brothers data directory.
// --baseline loads formation.js from Git HEAD to demonstrate the old bug.
const fs = require('fs');
const path = require('path');
const assert = require('assert');
const { execFileSync } = require('child_process');
const { createHash } = require('crypto');
const { chromium } = require('playwright');
const root = path.resolve(__dirname, '../..');
const audit = path.join(root, '.cache/afei-art/gameplay-audit');
const baseline = process.argv.includes('--baseline');
const nativeFiles = [
    'ui/extern/jquery-2.1.4.min.js',
    'ui/extern/jquery.event.drag-2.2/jquery.event.drag-2.2.js',
    'ui/extern/jquery.event.drop-2.2/jquery.event.drop-2.2.js',
    'ui/controls/brother.css',
    'ui/screens/character/modules/character_screen_brothers_list/character_screen_brothers_list_module.css',
    'ui/screens/character/modules/character_screen_brothers_list/character_screen_brothers_list_module.js'
];
execFileSync(process.env.PYTHON || 'python', ['-c',
    'import json,sys; from pathlib import Path; from zipfile import ZipFile; z=ZipFile(Path(sys.argv[1])/"data_001.dat"); out=Path(sys.argv[2]); out.mkdir(parents=True,exist_ok=True); [(out/Path(n).name).write_bytes(z.read(n)) for n in json.loads(sys.argv[3])]',
    process.env.BB_GAME_DATA || 'F:/SteamLibrary/steamapps/common/Battle Brothers/data', audit, JSON.stringify(nativeFiles)
]);
let passed = 0;
function check(value, message) { assert.ok(value, message); passed++; }
function report(extra) {
    const out = path.join(root, 'build/formation-scroll-fix');
    fs.mkdirSync(out, { recursive: true });
    fs.writeFileSync(path.join(out, baseline ? 'browser-baseline.json' : 'browser-validation.json'), JSON.stringify({
        baseline, assertions: passed, in_game_tested: false,
        method: 'Headless Chromium with native jQuery, drag/drop, roster renderer and swapSlots; engine portrait/data bindings stubbed',
        native_sources: nativeFiles.map(file => ({ path: file, sha256: createHash('sha256').update(fs.readFileSync(path.join(audit, path.basename(file)))).digest('hex') })),
        ...extra
    }, null, 2) + '\n');
}

(async () => {
    const browser = await chromium.launch({ headless: true, executablePath: process.env.BROWSER_EXECUTABLE || undefined });
    try {
        const page = await browser.newPage({ viewport: { width: 900, height: 640 } });
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        await page.setContent('<html><head></head><body><div class="character-screen-container"><div class="brothers-list-module"><div class="l-list-container"></div></div></div></body></html>');
        for (const name of ['brother.css', 'character_screen_brothers_list_module.css']) {
            await page.addStyleTag({ path: path.join(audit, name) });
        }
        await page.addStyleTag({ content: `html { font-size:10px } body { background:#241f19; color:#f2dca6; margin:0 }
            .character-screen-container { width:710px; margin:50px 30px }
            .is-brother-slot { outline:1px solid #80704c; background-image:none !important }
            .is-roster-slot { background-color:#533b27 }.is-reserve-slot { background-color:#273c38 }
            .brother { cursor:grab; text-align:center; line-height:78px; font-size:24px }
            .is-dragged { opacity:0.3 }.is-proxy { background:#836846; pointer-events:none }
            .is-brother-slot:after { content:attr(data-test-slot); position:absolute; top:0; left:2px; font-size:10px; pointer-events:none }
            .display-none { display:none }` });
        for (const name of ['jquery-2.1.4.min.js', 'jquery.event.drag-2.2.js', 'jquery.event.drop-2.2.js', 'character_screen_brothers_list_module.js']) {
            await page.addScriptTag({ path: path.join(audit, name) });
        }
        await page.evaluate(() => {
            window.CharacterScreenDatasourceIdentifier = {
                InventoryMode: { Stash: 'stash', Ground: 'ground', BattlePreparation: 'battle' },
                Brother: { ListLoaded: 'loaded', SettingsChanged: 'settings', Updated: 'updated', Selected: 'selected' },
                Inventory: { ModeUpdated: 'mode' }
            };
            window.CharacterScreenIdentifier = { Entity: { Id: 'id', Character: {
                Key: 'character', ImagePath: 'imagePath', ImageOffsetX: 'offsetX', ImageOffsetY: 'offsetY', LeveledUp: 'leveledUp', Name: 'name'
            } } };
            window.Path = { PROCEDURAL: '' };
            $.fn.createListBrother = function (id) { return $('<div class="ui-control brother is-list-brother"><span class="image-layer">' + id + '</span></div>').appendTo(this); };
            for (const method of ['assignListBrotherImage', 'assignListBrotherLeveledUp', 'showListBrotherMoodImage', 'assignListBrotherStatusEffect', 'assignListBrotherDaysWounded', 'assignListBrotherClickHandler', 'showListBrotherLockImage']) {
                $.fn[method] = function () { return this; };
            }
            $.fn.velocity = function (action, options) {
                if (typeof action === 'object') { this.css(action); if (options && options.complete) options.complete(); }
                return this;
            };
            window.board = []; window.mode = 'stash'; window.swaps = []; window.updates = []; window.listeners = {};
            window.ds = {
                addListener: (name, fn) => { listeners[name] = fn; }, getBrothersList: () => board, getInventoryMode: () => mode,
                getSelectedBrotherIndex: () => -1, setSelectedBrotherIndex: () => {}, isSelectedBrother: () => false,
                getSelectedBrother: () => null,
                swapBrothers: (a, b) => { [board[a], board[b]] = [board[b], board[a]]; swaps.push([a, b]); },
                notifyBackendUpdateRosterPosition: (id, place) => updates.push([id, place])
            };
            // Capture the native datasource listener before the mod loads, as in-game.
            window.roster = new CharacterScreenBrothersListModule({}, ds);
            roster.mContainer = $('.brothers-list-module');
            roster.mListScrollContainer = $('.l-list-container');
            roster.mRosterCountLabel = $('<span/>'); roster.mStartBattleButtonContainer = $('<span/>');
            roster.createBrotherSlots(roster.mListScrollContainer);
            window.resetBoard = (size = 40, active = 10, inventoryMode = 'stash', native = false) => {
                mode = inventoryMode; swaps = []; updates = [];
                board = Array(native ? 27 : 18 + size).fill(null);
                const order = [3,4,5,2,6,12,13,14,11,15,1,7];
                for (let i = 0; i < size; i++) board[i < active ? order[i] : 18 + i - active] = {
                    id: i + 1, character: { name: 'Member ' + (i + 1), imagePath: '' }, injuries: [], stats: { hitpoints: 100, hitpointsMax: 100 }
                };
                // Native loot data is a dense list, unlike the world formation.
                if (mode === 'ground') board = board.filter(Boolean);
                listeners.loaded(ds, board);
                roster.mListScrollContainer.scrollTop(0);
                roster.mSlots.forEach((slot, i) => slot.attr('data-test-slot', i));
            };
        });
        await page.addScriptTag({ content: baseline ? execFileSync('git', ['show', 'HEAD:src/ui/mods/afeix/formation.js'], { cwd: root, encoding: 'utf8' }) : fs.readFileSync(path.join(root, 'src/ui/mods/afeix/formation.js'), 'utf8') });

        const reset = (...args) => page.evaluate(args => resetBoard(...args), args);
        const point = index => page.evaluate(index => {
            const r = roster.mSlots[index][0].getBoundingClientRect();
            return { x: r.left + r.width / 2, y: r.top + r.height / 2 };
        }, index);
        const state = () => page.evaluate(() => ({ swaps, updates, active: roster.mNumActive,
            ids: board.filter(Boolean).map(b => b.id).sort((a,b) => a-b), proxy: $('.is-proxy').length, dragged: $('.is-dragged').length,
            scroll: roster.mListScrollContainer.scrollTop() }));
        const start = async from => {
            const p = await point(from);
            await page.mouse.move(p.x, p.y); await page.mouse.down(); await page.mouse.move(p.x + 4, p.y);
        };
        const release = async (to, scroll) => {
            await page.evaluate(scroll => roster.mListScrollContainer.scrollTop(scroll), scroll);
            const p = await point(to); await page.mouse.move(p.x, p.y);
            // Let the real native plugin evaluate its cached targets.
            await page.waitForTimeout(50); await page.mouse.up();
        };
        const integrity = async label => {
            const s = await state();
            check(JSON.stringify(s.ids) === JSON.stringify(Array.from({ length: 40 }, (_, i) => i + 1)), label + ': identities preserved');
            check(s.proxy === 0 && s.dragged === 0, label + ': drag visuals cleaned');
            return s;
        };
        const edge = async direction => {
            const p = await page.evaluate(direction => {
                const list = roster.mListScrollContainer[0], r = list.getBoundingClientRect();
                return { x: r.left + 40, y: direction > 0 ? r.top + list.clientHeight - 5 : r.top + 5 };
            }, direction);
            await page.mouse.move(p.x, p.y);
        };
        const visibleTarget = () => page.evaluate(() => {
            const list = roster.mListScrollContainer[0], box = list.getBoundingClientRect();
            const mid = box.top + list.clientHeight / 2;
            for (let i = 18; i < roster.mSlots.length; i++) {
                const r = roster.mSlots[i][0].getBoundingClientRect();
                if (r.top <= mid && r.bottom > mid) return i;
            }
            throw new Error('No visible reserve row');
        });

        let s;
        await reset(); await start(18); await release(27, 246);
        const crossPage = await state();
        if (baseline) {
            check(crossPage.active !== 10 || JSON.stringify(crossPage.swaps) !== '[[18,27]]', 'old code reproduces wrong cross-page drop');
            report({ cross_page: crossPage });
            console.log('BASELINE_BUG=' + JSON.stringify(crossPage));
            return;
        }
        check(JSON.stringify(crossPage.swaps) === '[[18,27]]' && crossPage.active === 10, 'first-page reserve lands on second-page reserve exactly once');
        check(crossPage.updates.some(([id, pos]) => id === 11 && pos === 27), 'backend receives actual reserve destination');
        await integrity('cross-page reserve');

        await reset(); await start(18);
        for (const i of [0, 1, 4]) { const p = await point(i); await page.mouse.move(p.x, p.y); await page.waitForTimeout(30); }
        check((await state()).swaps.length === 0, 'hovering across slots cannot swap before release');
        await release(27, 246);
        s = await integrity('hover then cross-page release');
        check(s.swaps.length === 1 && s.active === 10, 'one release produces exactly one exchange');

        await reset(); await start(3);
        await page.evaluate(() => roster.mListScrollContainer.scrollTop(246));
        await page.mouse.up();
        s = await integrity('release without another mousemove');
        check(JSON.stringify(s.swaps) === '[[3,30]]' && s.active === 10, 'release immediately after scrolling uses current bounds');

        await reset(); await start(3); await release(57, 322);
        s = await integrity('active to last empty reserve');
        check(JSON.stringify(s.swaps) === '[[3,57]]' && s.active === 9, 'deepest empty reserve lowers active count');
        await start(57); await release(0, 0);
        s = await integrity('same character dragged back');
        check(JSON.stringify(s.swaps) === '[[3,57],[57,0]]' && s.active === 10, 'repeat drag uses updated source index');

        await reset(40, 12); await page.evaluate(() => roster.mListScrollContainer.scrollTop(246));
        await start(45); await release(0, 0);
        s = await integrity('full formation'); check(s.swaps.length === 0 && s.active === 12, 'thirteenth active remains blocked');
        await page.evaluate(() => roster.mListScrollContainer.scrollTop(246)); await start(45); await release(3, 0);
        s = await integrity('full formation exchange'); check(s.swaps.length === 1 && s.active === 12, 'occupied active position still accepts an exchange');

        await reset(40, 1); await start(3); await release(57, 322);
        s = await integrity('last active'); check(s.swaps.length === 0 && s.active === 1, 'last active cannot leave an empty formation');

        for (const destination of [{ x: 800, y: 100 }, { x: 40, y: 360 }]) {
            await reset(); await start(18); await page.mouse.move(destination.x, destination.y); await page.mouse.up();
            s = await integrity('outside or clipped slot'); check(s.swaps.length === 0, 'offscreen slots and outside drops do not change formation');
        }
        await reset(); await start(18); await release(18, 0);
        s = await integrity('self drop'); check(s.swaps.length === 0, 'self drop is inert');

        await reset(); await start(18);
        await page.evaluate(() => { mode = 'ground'; }); await release(27, 246);
        s = await integrity('mode changes mid-drag'); check(s.swaps.length === 0, 'loot mode rejects a drag already in progress');

        await reset(); await page.mouse.move(200, 160); await page.mouse.wheel(0, 120); await page.waitForTimeout(50);
        check((await state()).scroll === 41, 'real wheel input moves only half a row');
        await page.mouse.wheel(0, -120); await page.waitForTimeout(50);
        check((await state()).scroll === 0, 'reverse wheel returns to initial position');
        // Wheel while holding a member, then release without moving the cursor.
        await start(18);
        for (let i = 0; i < 4; i++) { await page.mouse.wheel(0, 120); await page.waitForTimeout(25); }
        await page.mouse.up(); s = await integrity('wheel while dragging');
        check(s.scroll === 164 && JSON.stringify(s.swaps) === '[[18,36]]' && s.active === 10, 'wheel drag lands on the currently visible reserve');

        // Left-button-only path: keep the pointer still at the bottom, move
        // back to the middle to stop, and release on the currently visible row.
        await reset(); await start(18); await edge(1);
        await page.waitForTimeout(100);
        check((await state()).scroll === 0, 'brief edge pass does not scroll');
        await page.waitForFunction(() => roster.mListScrollContainer.scrollTop() >= 170);
        check((await state()).swaps.length === 0, 'stationary edge drag scrolls without swapping');
        const to = await visibleTarget(), p = await point(to);
        await page.mouse.move(p.x, p.y);
        const stopped = (await state()).scroll;
        await page.waitForTimeout(180);
        check((await state()).scroll === stopped, 'moving away from edge immediately stops scrolling');
        await page.mouse.up(); s = await integrity('left-button-only cross-page exchange');
        check(JSON.stringify(s.swaps) === JSON.stringify([[18, to]]) && s.active === 10, 'left-button-only drag lands in reserve');
        await page.waitForTimeout(180);
        check((await state()).scroll === stopped && await page.evaluate(() => !roster.afeixEdgeScroll), 'release cancels the auto-scroll timer');

        // Return from deep reserves to the first page, still without wheel input.
        await start(to); await edge(-1);
        await page.waitForFunction(() => roster.mListScrollContainer.scrollTop() === 0 && !roster.afeixEdgeScroll);
        await release(0, 0); s = await integrity('left-button-only return to formation');
        check(s.active === 11 && JSON.stringify(s.swaps[1]) === JSON.stringify([to, 0]), 'top edge reaches first page and supports a real active slot');

        await reset(); await start(18); await edge(1);
        await page.waitForFunction(() => {
            const list = roster.mListScrollContainer[0];
            return list.scrollTop === list.scrollHeight - list.clientHeight && !roster.afeixEdgeScroll;
        });
        const bottom = (await state()).scroll;
        await page.waitForTimeout(180);
        check(bottom > 0 && (await state()).scroll === bottom, 'bottom boundary clamps and retires the timer');
        await release(57, bottom); await integrity('bottom edge release');

        for (const cancel of ['outside', 'blur', 'mode', 'hide']) {
            await reset(); await start(18); await edge(1);
            await page.waitForFunction(() => roster.mListScrollContainer.scrollTop() > 0);
            if (cancel === 'outside') await page.mouse.move(800, 200);
            if (cancel === 'blur') await page.evaluate(() => $(window).triggerHandler('blur'));
            if (cancel === 'mode') await page.evaluate(() => { mode = 'ground'; });
            if (cancel === 'hide') await page.evaluate(() => roster.hide());
            await page.waitForFunction(() => !roster.afeixEdgeScroll);
            const offset = (await state()).scroll;
            await page.waitForTimeout(150);
            check((await state()).scroll === offset, cancel + ': cancelled drag no longer auto-scrolls');
            await page.mouse.move(800, 200); await page.mouse.up();
            await integrity(cancel + ' cancellation');
            if (cancel === 'hide') await page.evaluate(() => roster.show());
        }

        await reset(); await edge(1); await page.waitForTimeout(300);
        check((await state()).scroll === 0, 'hover without holding a character never scrolls');

        await reset(12, 10, 'stash', true);
        check(await page.evaluate(() => roster.mSlots.length === 27 && roster.mListScrollContainer.scrollTop() === 0 && $.data(roster.mSlots[3].data('child')[0], 'dragdata').drop === '.is-brother-slot'), 'other origin retains native drag and resets scroll');
        await page.mouse.move(200, 160); await page.mouse.wheel(0, 120); await page.waitForTimeout(50);
        check((await state()).scroll === 0, 'other origin has no custom wheel handler');

        for (const scale of [8, 12]) {
            await page.evaluate(scale => { document.documentElement.style.fontSize = scale + 'px'; document.querySelector('.character-screen-container').style.width = (71 * scale) + 'px'; }, scale);
            await reset(); await page.mouse.move(200, 160); await page.mouse.wheel(0, 120); await page.waitForTimeout(50);
            check(Math.abs((await state()).scroll - 4.1 * scale) <= 1, 'half-row wheel step follows UI scale ' + scale);
            await reset(); await start(18); await release(27, 24.6 * scale);
            s = await integrity('scaled cross-page drag');
            check(JSON.stringify(s.swaps) === '[[18,27]]' && s.active === 10, 'live drop follows scaled bounds ' + scale + ': ' + JSON.stringify(s));
        }
        await reset(40, 10, 'battle');
        check(await page.evaluate(() => !$.data(roster.mSlots[3].data('child')[0], 'dragdata')), 'battle preparation does not gain dragging');
        await reset(40, 10, 'ground');
        check(await page.evaluate(() => !$.data(roster.mSlots[3].data('child')[0], 'dragdata')), 'loot view does not gain dragging');
        check(errors.length === 0, 'no browser JavaScript exceptions: ' + errors.join('; '));
        report({ cross_page: crossPage, source_sha256: createHash('sha256').update(fs.readFileSync(path.join(root, 'src/ui/mods/afeix/formation.js'))).digest('hex') });
        console.log('TESTS_PASSED=' + passed);
    } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
