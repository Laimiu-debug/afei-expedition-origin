// Actual portrait helper/hooks against a native-behavior stub. No real saves or
// engine rendering are exercised here. Native API evidence lives in the audit.
local passed = 0, currentOrigin = true, currentRoute = "normal", baseRoute = "normal";
local check = function(value, message) { if (!value) throw "FAIL " + message; passed++; };
::AfeixExpedition <- {
    function isOrigin() { return currentOrigin; }, function route() { return currentRoute; },
    function get(key, fallback) { return key == "feidie_base_route" ? baseRoute : fallback; }
};
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/appearance.nut");
local A = ::AfeixExpedition, callbacks = {}, casualties = [], nextID = 10;
::mods_hookExactClass <- function(path, callback) { callbacks[path] <- callback; };
::mods_getMember <- function(object, key) {
    while (!(key in object)) object = object[object.SuperName];
    return object[key];
};
::mods_override <- function(object, key, value) {
    while (!(key in object)) object = object[object.SuperName];
    object[key] = value;
};
dofile("src/scripts/mods/afeix/art_hooks.nut");
::Const <- { Tactical = { DetailFlag = { Corpse = 4 } }, Combat = { HumanCorpseOffset = { X = 0, Y = -12 } }, CorpsePart = ["part0", "part1"] };
::Tactical <- { function getCasualtyRoster() { return { function getAll() { return casualties; } }; } };
// These helpers belong to the engine root, not to actor instances. An actor-local
// fake previously allowed production to call APIs absent on live entity tables.
::artAvailableBrushes <- {};
::doesBrushExist <- function(name) {
    return name.find("afeix_") != 0 || (name in ::artAvailableBrushes && ::artAvailableBrushes[name]);
};
::createColor <- function(value) { return value; };
::createVec <- function(x, y) { return { X = x, Y = y }; };
local parts = ["background", "quiver", "tattoo_body", "scar_body", "injury_body", "body_injury", "armor", "surcoat",
    "armor_upgrade_back", "armor_upgrade_front", "shaft", "head", "eye_rings", "closed_eyes", "tattoo_head", "scar_head",
    "injury", "injury_skin", "beard", "hair", "helmet", "helmet_damage", "accessory", "accessory_special", "beard_top",
    "bandage_1", "bandage_2", "bandage_3", "body_blood", "dirt", "permanent_injury_1", "permanent_injury_2",
    "permanent_injury_3", "permanent_injury_4", "arms_icon", "shield_icon"];
local status = ["socket", "arrow", "status_rooted_back", "status_rooted", "status_stunned", "status_hex", "status_sweat", "status_rage", "morale", "miniboss"];
local makeSprite = function(name, available) { return {
    name = name, brush = "native_" + name, Visible = true, HasBrush = true,
    Color = "native-color", Saturation = 0.8, Scale = 1.0, Rotation = 0, flipped = false,
    function setBrush(brush) {
        if (brush.find("afeix_") == 0 && (!(brush in available) || !available[brush])) throw "missing brush " + brush;
        this.brush = brush; this.HasBrush = true;
    },
    function getBrush() { return { Name = this.brush }; },
    function resetBrush() { this.brush = null; this.HasBrush = false; },
    function setHorizontalFlipping(value) { this.flipped = value; }
}; };
local makeTile = function() {
    local props = { Items = ["native-drop"], Corpse = null };
    return {
        details = [{ brush = "old-corpse", flag = 4 }, { brush = "fire-effect", flag = 8 }],
        cleared = [], Properties = { function get(key) { return props[key]; }, function set(key, value) { props[key] = value; } },
        function clear(flag) {
            this.cleared.append(flag);
            for (local i = this.details.len() - 1; i >= 0; i--) if (this.details[i].flag == flag) this.details.remove(i);
        },
        function spawnDetail(brush, flag, flip, unused = false, offset = null) {
            local sprite = { brush = brush, flag = flag, flip = flip, offset = offset,
                Color = null, Saturation = 1.0, Rotation = 0, Scale = 1.0 };
            this.details.append(sprite); return sprite;
        }
    };
};
local makeBrother = function(key = "afei", zombie = false) {
    local flags = { afeix_character = key }, available = ::artAvailableBrushes, sprites = {};
    foreach (id in A.CharacterOrder) {
        if (id == "afei") foreach (form in ["normal", "toad", "jiahao"]) {
            foreach (suffix in ["", "_head", "_dead"]) available["afeix_p04_afei_" + form + suffix] <- true;
        } else { foreach (suffix in ["", "_head", "_dead"]) available["afeix_p04_" + id + suffix] <- true; }
    }
    available.afeix_g03_feidie <- true;
    foreach (name in parts) sprites[name] <- makeSprite(name, available);
    foreach (name in status) sprites[name] <- makeSprite(name, available);
    sprites.body <- makeSprite("body", available); sprites.body.brush = "bust_native_body";
    sprites.head.Color = "native-skin";
    local app = { Body = "bust_native_body", Corpse = "bust_native_body_dead", HideBody = false, HideHead = false,
        HideHair = false, HideBeard = false, HideCorpseHead = false, HelmetCorpse = "native_helmet_dead", CorpseArmor = "native_armor_dead" };
    local items = { equipped = ["sword", "shield", "armor", "helmet"], armorPoints = 140,
        function getAppearance() { return app; } };
    local bro = {
        m = { IsAlive = true, IsDying = false, IsCorpseFlipped = false, XP = 777, Level = 8, Hitpoints = 20, IsHidingHelmet = false },
        sprites = sprites, savedFlags = flags, available = available, itemState = items, id = nextID++, added = 0,
        allied = true, dirty = 0, injuryCalls = 0, deathCalls = 0, lastDirty = null, nestedSave = false,
        lastArgs = null, flyingHeads = null, offsets = {}, loadedItems = null,
        function getFlags() { return { function has(k) { return k in flags; }, function get(k) { return flags[k]; } }; },
        function hasSprite(name) { return name in this.sprites; }, function getSprite(name) { return this.sprites[name]; },
        function addSprite(name) { this.added++; this.sprites[name] <- makeSprite(name, available); return this.sprites[name]; },
        function getItems() { return this.itemState; }, function getID() { return this.id; },
        function setSpriteOffset(name, value) { this.offsets[name] <- value; }, function isAlliedWithPlayer() { return this.allied; },
        function setDirty(value) { if (value) this.dirty++; return "dirty_result"; },
        function onInit() { this.onAppearanceChanged(app); return "init_result"; },
        function onAppearanceChanged(appearance, setDirty = true) {
            this.lastDirty = setDirty;
            this.sprites.body.Visible = !appearance.HideBody;
            this.sprites.head.Visible = !appearance.HideHead;
            this.sprites.hair.Visible = !appearance.HideHair;
            this.sprites.beard.Visible = !appearance.HideBeard;
            this.sprites.helmet.Visible = true; this.sprites.armor.Visible = true;
            if (setDirty) this.setDirty(true);
            return "appearance_result";
        },
        function onUpdateInjuryLayer() {
            this.injuryCalls++;
            this.sprites.injury.Visible = true; this.sprites.injury.brush = "native_face_wound";
            this.sprites.injury_body.setBrush(this.sprites.body.brush + "_injured");
            this.sprites.injury_body.Visible = true; this.setDirty(true);
            return "injury_result";
        },
        function updateInjuryVisuals(setDirty = true) { this.sprites.bandage_1.Visible = true; this.setDirty(setDirty); },
        function onFactionChanged() { this.sprites.socket.brush = this.allied ? "player_socket" : "charmed_socket"; return "faction_result"; },
        function onDeserialize(input) { this.sprites.body.brush = app.Body; this.sprites.head.brush = "native_head"; this.onAppearanceChanged(app); return "load_result"; },
        function onCombatFinished() { this.m.IsAlive = true; this.m.IsDying = false; this.onUpdateInjuryLayer(); return "combat_result"; },
        function onSerialize(output) {
            if (A.isArtCharacter(this)) {
                check(A.isCharacterArtSuspended(this), "native save runs suspended");
                check(this.sprites.body.brush == app.Body && this.sprites.head.brush == "native_head" && this.sprites.head.Visible && this.sprites.helmet.Visible, "save sees native body/head and current native equipment visibility");
                this.onAppearanceChanged(app, false); this.onUpdateInjuryLayer(); this.onFactionChanged();
                check(this.sprites.body.brush == app.Body, "nested callbacks do not reapply portrait during save");
                if ("nested" in output && output.nested && !this.nestedSave) {
                    this.nestedSave = true; this.onSerialize({}); this.nestedSave = false;
                    check(A.isCharacterArtSuspended(this) && this.sprites.body.brush == app.Body, "nested save retains outer suspension");
                }
            }
            if ("fail" in output && output.fail) throw "native_save_error";
            return "save_result";
        },
        function onDeath(killer, skill, tile, fatality) {
            this.deathCalls++; this.lastArgs = [killer, skill, tile, fatality];
            // Exact native decapitation field conditions, including hair/beard
            // conditions that do not independently check HideCorpseHead.
            local layers = [];
            if (!app.HideCorpseHead) layers.append(this.sprites.head.brush + "_dead");
            if (!app.HideBeard && this.sprites.beard.HasBrush) layers.append(this.sprites.beard.brush + "_dead");
            if (!app.HideHair && this.sprites.hair.HasBrush) layers.append(this.sprites.hair.brush + "_dead");
            if (app.HelmetCorpse != "") layers.append(app.HelmetCorpse);
            this.flyingHeads = layers;
            this.onUpdateInjuryLayer();
            if (fatality == "throw") throw "native_death_error";
            local all = {}, originalID = this.id;
            foreach (name in ["body", "head", "hair", "beard", "beard_top", "helmet", "armor", "smashed", "guts", "arrows", "stuff_0", "stuff_1", "blood_1", "blood_2"])
                all[name] <- makeSprite(name, available);
            local stub = { sprites = all, offset = null,
                function getOriginalID() { return originalID; }, function hasSprite(name) { return name in this.sprites; },
                function getSprite(name) { return this.sprites[name]; }, function addSprite(name) { this.sprites[name] <- makeSprite(name, available); return this.sprites[name]; },
                function setSpriteOffset(name, value) { this.offset = value; }
            };
            casualties.append(stub);
            if (tile != null) {
                tile.spawnDetail(this.sprites.body.brush + "_dead", 4, false);
                tile.spawnDetail("native_smashed_head", 4, false);
                tile.Properties.set("Corpse", { Custom = { Body = this.sprites.body.brush, Face = this.sprites.head.brush },
                    Items = items, IsResurrectable = fatality == "normal", IsConsumable = fatality != "unconscious", Armor = 140 });
            }
            this.m.IsAlive = false; this.m.IsDying = true;
            return "death_result";
        },
        function onResurrected(info) {
            this.loadedItems = info.Items;
            this.sprites.body.setBrush(info.Custom.Body); this.sprites.head.Visible = true; this.sprites.hair.Visible = true;
            this.onUpdateInjuryLayer(); this.m.XP = 99; this.allied = false; return "revived_result";
        }
    };
    // Native methods returned through inherit may carry a bound prototype env.
    // Force that distinction: call/acall alone must not satisfy these fixtures.
    foreach (method in ["setDirty", "onAppearanceChanged", "onFactionChanged", "onUpdateInjuryLayer",
        "onDeath", "onResurrected", "onInit", "onDeserialize", "onCombatFinished", "onSerialize"])
        bro[method] = bro[method].bindenv({ prototypeOnly = true });
    // Model the raw native inherit structure seen by Legacy Hooks before new()
    // flattens methods. These callbacks are not own members of player/zombie_player.
    local actorBase = {}, inherited = ["setDirty", "onAppearanceChanged", "onFactionChanged"];
    if (zombie) inherited.extend(["onUpdateInjuryLayer", "onDeath", "onResurrected"]);
    foreach (method in inherited) { actorBase[method] <- bro[method]; delete bro[method]; }
    local originalMethods = clone actorBase;
    bro.SuperName <- zombie ? "zombie" : "human";
    bro[bro.SuperName] <- { SuperName = "actor", actor = actorBase };
    callbacks[zombie ? "entity/tactical/enemies/zombie_player" : "entity/tactical/player"](bro);
    foreach (method, native in originalMethods) {
        check(actorBase[method] != native && !(method in bro),
            "raw inherited " + method + " is replaced on its definition table without a child shadow");
        // Native new() exposes the resolved inherited methods on the instance.
        bro[method] <- ::mods_getMember(bro, method);
    }
    return bro;
};
try {
    check(A.CharacterOrder.len() == 34, "test covers current 34-member roster");
    foreach (key in A.CharacterOrder) {
        local bro = makeBrother(key), items = bro.getItems();
        local initialBrushes = {};
        foreach (name in parts) initialBrushes[name] <- bro.sprites[name].brush;
        check(bro.onInit() == "init_result", key + " native initialization return");
        local expected = key == "afei" ? "afeix_p04_afei_normal" : "afeix_p04_" + key;
        check(bro.sprites.body.brush == expected && bro.sprites.body.Visible && bro.added == 0, key + " uses existing single body layer");
        check(!bro.sprites.body.flipped, key + " ally uses source art facing screen-right");
        foreach (name in parts) {
            if (name == "head") {
                check(bro.sprites.head.Visible && bro.sprites.head.brush == expected + "_head", key + " custom head renders above armor");
                continue;
            }
            local hidden = A.Art.HiddenLayers.find(name) != null;
            check(bro.sprites[name].Visible == !hidden && bro.sprites[name].brush == initialBrushes[name],
                key + " retains equipment but hides native face/hair: " + name);
        }
        foreach (name in status) check(bro.sprites[name].Visible && bro.sprites[name].brush == "native_" + name, key + " retains battle marker: " + name);
        check(bro.getItems() == items && items.equipped.len() == 4 && items.armorPoints == 140 && bro.m.XP == 777 && bro.m.Level == 8, key + " equipment and progression unchanged");
        bro.onUpdateInjuryLayer();
        check(bro.injuryCalls == 0 && bro.sprites.body.brush == expected && !bro.sprites.injury.Visible, key + " injured actor keeps complete portrait without requesting missing injured suffix");
    }
    local bro = makeBrother(); bro.onInit();
    foreach (form in ["normal", "toad", "jiahao"]) {
        currentRoute = form; A.syncCharacterArt(bro);
        check(bro.sprites.body.brush == "afeix_p04_afei_" + (form == "toad" ? "normal" : form) && bro.added == 0, "toad promotion keeps human Afei appearance");
    }
    currentRoute = "feidie";
    foreach (form in ["normal", "toad", "jiahao"]) {
        baseRoute = form; A.syncCharacterArt(bro);
        check(bro.sprites.body.brush == "afeix_p04_afei_" + (form == "toad" ? "normal" : form) && !bro.hasSprite(A.Art.DiscLayer) && bro.added == 0, "hidden route retains human form without adding a disc");
        foreach (allied in [true, false, true]) {
            bro.allied = allied; bro.onFactionChanged();
            check(bro.sprites.body.flipped == !allied && !bro.hasSprite(A.Art.DiscLayer),
                form + " body follows faction through charm and recovery");
            bro.onAppearanceChanged(bro.getItems().getAppearance());
            bro.onUpdateInjuryLayer();
            bro.onSerialize({}); bro.onDeserialize({});
            check(bro.sprites.body.flipped == !allied && !bro.hasSprite(A.Art.DiscLayer),
                form + " appearance injury and save/load preserve faction facing");
        }
    }
    bro.allied = false; bro.onFactionChanged();
    check(bro.sprites.body.flipped && !bro.hasSprite(A.Art.DiscLayer) && bro.sprites.socket.brush == "charmed_socket", "charm retains changed socket and flips portrait");
    bro.addSprite(A.Art.DiscLayer).setBrush("afeix_g03_feidie");
    A.syncCharacterArt(bro);
    check(!bro.getSprite(A.Art.DiscLayer).Visible && !bro.getSprite(A.Art.DiscLayer).HasBrush, "old live saucer sprite is cleared after upgrading");
    bro.sprites.shield_icon.Visible = false; bro.setDirty(true);
    check(!bro.sprites.shield_icon.Visible && bro.sprites.armor.Visible && bro.sprites.helmet.Visible, "native unequipping visibility is not forced back on");
    bro.sprites.closed_eyes.Visible = true; bro.sprites.bandage_1.Visible = true; bro.sprites.body_blood.Visible = true;
    bro.sprites.status_stunned.brush = "bust_sleep"; bro.setDirty(true);
    check(!bro.sprites.closed_eyes.Visible && !bro.sprites.bandage_1.Visible && !bro.sprites.body_blood.Visible
        && bro.sprites.status_stunned.Visible && bro.sprites.status_stunned.brush == "bust_sleep", "direct skill layer writes are hidden while sleep marker survives");
    check(bro.onAppearanceChanged({ HideBody = true, HideHead = false, HideHair = false, HideBeard = false }, false) == "appearance_result"
        && bro.sprites.body.Visible && bro.sprites.head.Visible && bro.lastDirty == false, "equipment appearance changes retain custom face above armor");
    check(bro.onSerialize({ nested = true }) == "save_result" && !A.isCharacterArtSuspended(bro)
        && bro.sprites.body.brush == "afeix_p04_afei_jiahao" && bro.sprites.head.brush == "afeix_p04_afei_jiahao_head", "normal and nested saves restore custom head and body");
    local caught = false;
    try { bro.onSerialize({ fail = true }); } catch (error) { caught = error == "native_save_error"; }
    check(caught && !A.isCharacterArtSuspended(bro) && !bro.getSprite(A.Art.DiscLayer).Visible, "save error restores art without retired saucer and rethrows original");
    check(bro.savedFlags.len() == 1, "portrait cache/suspension not serialized into Flags");
    local app = bro.getItems().getAppearance(), originalApp = clone app;
    caught = false;
    try { bro.onDeath("killer", "skill", null, "throw"); } catch (error) { caught = error == "native_death_error"; }
    check(caught && !A.isCharacterArtSuspended(bro) && !bro.m.afeixDeathVisual && bro.flyingHeads.len() == 0, "death exception restores context and cannot fly a native head");
    foreach (name, value in originalApp) check(app[name] == value, "death exception restores appearance field " + name);
    foreach (fatality in ["normal", "decapitated", "smashed", "devoured", "unconscious"]) {
        local dead = makeBrother("xiaogui"), tile = makeTile(); dead.onInit();
        local items = dead.getItems(), tileItems = tile.Properties.get("Items");
        check(dead.onDeath("killer", "skill", tile, fatality) == "death_result" && dead.deathCalls == 1
            && dead.lastArgs[0] == "killer" && dead.lastArgs[1] == "skill" && dead.lastArgs[2] == tile && dead.lastArgs[3] == fatality, "death dispatcher preserves original args and single native invocation: " + fatality);
        check(dead.flyingHeads.len() == 0, "native detached-head effect receives no original head parts: " + fatality);
        check(tile.details.len() == 2 && tile.details[0].brush == "fire-effect" && tile.details[1].brush == "afeix_p04_xiaogui_dead"
            && tile.details[1].Rotation == -90 && tile.details[1].Color == "#ffffff", "corpse is one rotated complete image with tactical effect retained: " + fatality);
        local corpse = tile.Properties.get("Corpse");
        check(corpse.Items == items && corpse.Armor == 140 && tile.Properties.get("Items") == tileItems
            && corpse.IsResurrectable == (fatality == "normal") && corpse.IsConsumable == (fatality != "unconscious"), "native drop corpse and fatality data are preserved: " + fatality);
        local stub = casualties.top();
        check(stub.sprites.body.brush == "afeix_p04_xiaogui_dead" && stub.sprites.body.Rotation == -90
            && !stub.sprites.head.Visible && !stub.sprites.hair.Visible && !stub.sprites.stuff_0.Visible, "casualty portrait does not reconstruct native head: " + fatality);
        check(dead.getItems().getAppearance().HelmetCorpse == "native_helmet_dead" && !dead.getItems().getAppearance().HideCorpseHead, "death-only appearance fields restored: " + fatality);
        if (fatality == "unconscious") check(dead.onCombatFinished() == "combat_result" && dead.sprites.body.Visible
            && dead.sprites.body.brush == "afeix_p04_xiaogui" && dead.sprites.head.Visible, "unconscious survivor returns to its full portrait");
        if (fatality == "normal") {
            local revived = makeBrother("unknown", true);
            check(revived.onResurrected(corpse) == "revived_result" && revived.loadedItems == items && revived.m.XP == 99
                && revived.sprites.body.brush == "afeix_p04_xiaogui" && revived.sprites.body.flipped
                && revived.sprites.head.brush == "afeix_p04_xiaogui_head" && !revived.sprites.hair.Visible, "native resurrection retains items and XP while custom head survives");
            revived.onUpdateInjuryLayer(); check(revived.injuryCalls == 0, "revived portrait hides native zombie injury parts");
            local again = makeTile(); revived.onDeath("killer", "skill", again, "decapitated");
            check(revived.flyingHeads.len() == 0 && again.details[1].brush == "afeix_p04_xiaogui_dead"
                && again.Properties.get("Corpse").Items == revived.getItems(), "resurrected member dies again without native head or altered items");
        }
    }
    currentRoute = "normal";
    foreach (nativeFlip in [false, true]) {
        local fallen = makeBrother("bottle"), floor = makeTile(); fallen.onInit();
        fallen.m.IsCorpseFlipped = nativeFlip;
        fallen.onDeath("killer", "skill", floor, "normal");
        check(floor.details[1].flip == nativeFlip, "corpse retains either native randomized facing");
    }
    local missing = makeBrother("damou"); missing.onInit(); missing.available.afeix_p04_damou_dead = false;
    missing.onUpdateInjuryLayer();
    check(missing.sprites.body.brush == "bust_native_body" && missing.sprites.head.Visible && missing.sprites.helmet.Visible && missing.injuryCalls > 0, "missing full portrait state restores current native appearance safely");
    local absent = makeBrother("bottle"); absent.available.afeix_p04_bottle = false; absent.onInit();
    check(absent.sprites.body.brush == "bust_native_body" && absent.sprites.head.Visible && absent.added == 0, "missing atlas does not hide original parts or add layers");
    currentOrigin = false;
    local stranger = makeBrother(); stranger.onInit(); stranger.onAppearanceChanged(stranger.getItems().getAppearance());
    check(stranger.sprites.body.brush == "bust_native_body" && stranger.sprites.head.Visible && stranger.added == 0, "other origins preserve sprite count and rendering");
    check(stranger.onSerialize({}) == "save_result", "other-origin serializer remains native");
    local loaded = makeBrother("keke"); loaded.onDeserialize({});
    check(loaded.added == 0 && loaded.sprites.body.brush == "bust_native_body", "load before restored origin stays native without a new layer");
    currentOrigin = true; A.syncCharacterArt(loaded);
    check(loaded.sprites.body.brush == "afeix_p04_keke" && loaded.sprites.head.brush == "afeix_p04_keke_head", "completed-world metadata restoration can apply portrait");
    local ordinary = makeBrother("ordinary_mercenary"); ordinary.onInit();
    check(ordinary.added == 0 && ordinary.sprites.head.Visible && ordinary.sprites.body.brush == "bust_native_body", "ordinary hired mercenaries retain original art");
    local member = makeBrother("keke"); member.onInit();
    check(A.ensureCharacterArtLayer(member) == null && member.added == 0, "even explicit decoration helper cannot add a disc to another member");
    local noTile = makeBrother("bottle"); noTile.onInit();
    check(noTile.onDeath("killer", "skill", null, "normal") == "death_result"
        && casualties.top().sprites.body.brush == "afeix_p04_bottle_dead", "unplaced death still gives a complete casualty portrait");
    local missingDeath = makeBrother("damou"); missingDeath.onInit(); missingDeath.available.afeix_p04_damou_dead = false;
    local fallbackTile = makeTile(); missingDeath.onDeath("killer", "skill", fallbackTile, "normal");
    check(missingDeath.sprites.body.brush == "bust_native_body" && fallbackTile.cleared.len() == 0, "missing corpse brush restores native body before native death rather than crashing");
    local limitedSprite = { Color = null, Saturation = 1.0, Scale = 1.0 };
    A.stylePortraitCorpse(limitedSprite, ordinary);
    check(limitedSprite.Color == "#ffffff" && limitedSprite.Scale == 0.72, "unsupported rotation cannot abort death visual replacement");
    print("ALL_APPEARANCE_BEHAVIOR_CHECKS_PASS\nTESTS_PASSED=" + passed + "\n");
} catch (error) { print(error + "\n"); if ("exit" in getroottable()) exit(1); throw error; }
