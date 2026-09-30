// Source busts face screen-right. Native faction flipping mirrors enemies;
// do not invert every ally to compensate for a frontal source illustration.
// Custom faces and hair sit below native armor, helmets and weapon icons.
local A = ::AfeixExpedition;
A.Art <- {
    Prefix = "afeix_p04_", DiscLayer = "afeix_gameplay_disc",
    HiddenLayers = ["tattoo_body", "scar_body", "injury_body", "body_injury",
        "eye_rings", "closed_eyes", "tattoo_head", "scar_head", "injury_skin",
        "beard", "hair", "beard_top",
        "bandage_1", "bandage_2", "bandage_3", "dirt", "permanent_injury_1",
        "permanent_injury_2", "permanent_injury_3", "permanent_injury_4"],
    CorpseLayers = ["tattoo_body", "tattoo_head", "armor", "surcoat", "upgrade_back", "upgrade_front",
        "accessory", "head", "beard", "beard_top", "hair", "helmet", "smashed", "guts", "arrows"]
};
A.isPortraitBrush <- function(name) { return typeof name == "string" && name.find(this.Art.Prefix) == 0; };
A.characterPortraitBrush <- function(bro) {
    if (bro == null || !this.isOrigin()) return null;
    if ("afeixResurrectedPortrait" in bro.m && this.isPortraitBrush(bro.m.afeixResurrectedPortrait))
        return bro.m.afeixResurrectedPortrait.find(this.Art.Prefix + "afei_") == 0
            ? this.Art.Prefix + "afei_normal" : bro.m.afeixResurrectedPortrait;
    if (!bro.getFlags().has("afeix_character")) return null;
    local key = bro.getFlags().get("afeix_character");
    if (!(key in this.Characters)) return null;
    // Profession changes abilities, never Afei's portrait. Old corpse IDs map
    // to this same portrait on resurrection as well.
    if (key == "afei") return this.Art.Prefix + "afei_normal";
    return this.Art.Prefix + key;
};
A.isArtCharacter <- function(bro) { return this.characterPortraitBrush(bro) != null; };
A.hasPortraitArt <- function(bro, brush = null) {
    if (brush == null) brush = this.characterPortraitBrush(bro);
    return brush != null && ::doesBrushExist(brush) && ::doesBrushExist(brush + "_head") && ::doesBrushExist(brush + "_dead");
};
A.isCharacterArtSuspended <- function(bro) {
    return bro != null && "afeixArtSuspendDepth" in bro.m && bro.m.afeixArtSuspendDepth > 0;
};
A.hideCharacterArt <- function(bro) {
    if (bro == null || !bro.hasSprite(this.Art.DiscLayer)) return;
    local disc = bro.getSprite(this.Art.DiscLayer);
    disc.Visible = false; disc.resetBrush();
};
A.ensureCharacterArtLayer <- function(bro) {
    // The hidden promotion remains playable but no longer adds a saucer sprite.
    this.hideCharacterArt(bro); return null;
};
A.captureNativePortraitState <- function(bro) {
    if ("afeixNativeArt" in bro.m && bro.m.afeixNativeArt != null) return;
    local body = bro.getSprite("body"), head = bro.getSprite("head"), visible = {};
    foreach (name in this.Art.HiddenLayers) if (bro.hasSprite(name)) visible[name] <- bro.getSprite(name).Visible;
    bro.m.afeixNativeArt <- { Visible = visible, BodyVisible = body.Visible,
        HeadBrush = head.getBrush().Name, HeadColor = head.Color, HeadSaturation = head.Saturation, HeadScale = head.Scale,
        Color = body.Color, Saturation = body.Saturation, Scale = body.Scale, Rotation = body.Rotation };
};
A.hideOriginalPortraitParts <- function(bro) {
    if (!this.isArtCharacter(bro) || this.isCharacterArtSuspended(bro) || !this.hasPortraitArt(bro)) return;
    if (!("afeixPortraitActive" in bro.m) || !bro.m.afeixPortraitActive) return;
    foreach (name in this.Art.HiddenLayers) if (bro.hasSprite(name)) bro.getSprite(name).Visible = false;
    // socket, arrow, morale, miniboss and status_* remain native.
};
A.restoreNativeCharacterBody <- function(bro) {
    if (bro == null || !bro.hasSprite("body")) return false;
    local appearance = bro.getItems().getAppearance();
    if (!("Body" in appearance) || appearance.Body == "" || !::doesBrushExist(appearance.Body)) return false;
    local body = bro.getSprite("body"); body.setBrush(appearance.Body);
    if ("afeixNativeArt" in bro.m && bro.m.afeixNativeArt != null) {
        local saved = bro.m.afeixNativeArt;
        if ("HeadBrush" in saved) {
            local head = bro.getSprite("head"); head.setBrush(saved.HeadBrush);
            head.Color = saved.HeadColor; head.Saturation = saved.HeadSaturation; head.Scale = saved.HeadScale;
        }
        body.Visible = saved.BodyVisible; body.Color = saved.Color; body.Saturation = saved.Saturation;
        body.Scale = saved.Scale; body.Rotation = saved.Rotation;
        foreach (name, visible in saved.Visible) if (bro.hasSprite(name)) bro.getSprite(name).Visible = visible;
    } else if (bro.hasSprite("head")) {
        body.Color = bro.getSprite("head").Color; body.Saturation = bro.getSprite("head").Saturation;
    }
    // Recompute current equipment/health visuals with recursive art sync off.
    local depth = "afeixArtSuspendDepth" in bro.m ? bro.m.afeixArtSuspendDepth : 0;
    bro.m.afeixArtSuspendDepth <- depth + 1;
    try {
        if ("onAppearanceChanged" in bro) bro.onAppearanceChanged(appearance, false);
        if ("onUpdateInjuryLayer" in bro) bro.onUpdateInjuryLayer();
        if ("updateInjuryVisuals" in bro) bro.updateInjuryVisuals(false);
    } catch (error) { bro.m.afeixArtSuspendDepth = depth; throw error; }
    bro.m.afeixArtSuspendDepth = depth; bro.m.afeixPortraitActive <- false;
    return true;
};
A.suspendCharacterArt <- function(bro) {
    if (!this.isArtCharacter(bro)) return false;
    this.hideCharacterArt(bro); return this.restoreNativeCharacterBody(bro);
};
A.syncPortraitInjuries <- function(bro) {
    // Use native overlays above the portrait/equipment, never request a
    // custom body + "_injured" brush (that native body replacement is absent).
    local maximum = bro.getHitpointsMax();
    local ratio = maximum > 0 ? bro.getHitpoints() / (maximum * 1.0) : 1.0;
    local flip = !bro.isAlliedWithPlayer();
    // Keep the last living wound state when the lethal hit reaches zero HP
    // before the injury callback. Death must not erase or replace those marks.
    if (bro.getHitpoints() > 0) {
        bro.m.afeixPortraitWoundLevel <- ratio > 0.67 ? 0 : (ratio > 0.33 ? 1 : 2);
        bro.m.afeixPortraitBloodied <- ratio < 1.0 || ("BloodiedCount" in bro.m
            && bro.m.BloodiedCount >= ::Const.Combat.BloodiedBustCount);
    }
    if (bro.hasSprite("injury")) {
        local injury = bro.getSprite("injury"), head = bro.getSprite("head");
        local brush = ratio > 0.33 ? "bust_head_injured_01" : "bust_head_injured_02";
        injury.Visible = ratio <= 0.67 && head.Visible && ::doesBrushExist(brush);
        if (injury.Visible) injury.setBrush(brush);
        injury.Color = ::createColor("#ffffff"); injury.Saturation = 1.0;
        injury.Scale = head.Scale; injury.setHorizontalFlipping(flip);
    }
    if (bro.hasSprite("body_blood")) {
        local blood = bro.getSprite("body_blood");
        // Retain native combat splashes as well as blood from own wounds.
        local splashed = "BloodiedCount" in bro.m && bro.m.BloodiedCount >= ::Const.Combat.BloodiedBustCount;
        blood.Visible = blood.HasBrush && (ratio < 1.0 || splashed);
        blood.Color = ::createColor("#ffffff"); blood.Saturation = 1.0;
        blood.Scale = bro.getSprite("body").Scale; blood.setHorizontalFlipping(flip);
    }
};
A.syncCharacterArt <- function(bro) {
    local brush = this.characterPortraitBrush(bro);
    if (brush == null || this.isCharacterArtSuspended(bro) || !bro.hasSprite("body")) return false;
    if (!bro.m.IsAlive || bro.m.IsDying) { this.hideCharacterArt(bro); return false; }
    if (!this.hasPortraitArt(bro, brush)) {
        this.hideCharacterArt(bro);
        if ("afeixPortraitActive" in bro.m && bro.m.afeixPortraitActive) this.restoreNativeCharacterBody(bro);
        return false;
    }
    this.captureNativePortraitState(bro);
    local body = bro.getSprite("body"); body.setBrush(brush); body.Visible = true;
    body.Color = ::createColor("#ffffff"); body.Saturation = 1.0; body.Rotation = 0;
    body.setHorizontalFlipping(!bro.isAlliedWithPlayer());
    local head = bro.getSprite("head"), appearance = bro.getItems().getAppearance();
    head.setBrush(brush + "_head"); head.Color = ::createColor("#ffffff");
    head.Saturation = 1.0; head.Scale = body.Scale;
    head.Visible = !("HideHead" in appearance) || !appearance.HideHead || bro.m.IsHidingHelmet;
    head.setHorizontalFlipping(!bro.isAlliedWithPlayer());
    bro.m.afeixPortraitActive <- true;
    this.hideOriginalPortraitParts(bro);
    this.syncPortraitInjuries(bro);
    this.hideCharacterArt(bro);
    bro.setDirty(true); return true;
};
// Native bodies and equipment supply the prone silhouette; only the face is
// replaced. Never clear Corpse details: another body can occupy the same tile.
A.hasCorpseHeadArt <- function(brush) { return ::doesBrushExist(brush + "_corpse_head"); };
A.beginPortraitDeath <- function(bro, fatality) {
    local appearance = bro.getItems().getAppearance();
    local saved = { Fields = {}, Body = bro.getSprite("body").getBrush().Name, Tattoos = {} };
    foreach (name in ["HideCorpseHead", "HideHair", "HideBeard", "HelmetCorpse"])
        saved.Fields[name] <- { Exists = name in appearance, Value = name in appearance ? appearance[name] : null };
    // Let native death create the original equipment, projectiles and corpse
    // record. Suppress duplicate faces and defer the helmet until after ours.
    appearance.HideCorpseHead <- true; appearance.HideHair <- true; appearance.HideBeard <- true;
    if (fatality != ::Const.FatalityType.Decapitated) appearance.HelmetCorpse <- "";
    bro.getSprite("body").setBrush(appearance.Body);
    foreach (name in ["tattoo_body", "tattoo_head"]) if (bro.hasSprite(name)) {
        local sprite = bro.getSprite(name);
        saved.Tattoos[name] <- sprite.HasBrush ? sprite.getBrush().Name : null;
        sprite.resetBrush();
    }
    bro.m.afeixDeathPortrait <- saved.Body;
    bro.m.afeixDeathVisual <- true;
    this.hideCharacterArt(bro); return saved;
};
A.endPortraitDeath <- function(bro, saved) {
    local appearance = bro.getItems().getAppearance();
    foreach (name, entry in saved.Fields) {
        if (entry.Exists) appearance[name] = entry.Value;
        else if (name in appearance) delete appearance[name];
    }
    bro.getSprite("body").setBrush(saved.Body);
    foreach (name, brush in saved.Tattoos) if (brush != null) bro.getSprite(name).setBrush(brush);
    bro.m.afeixDeathVisual <- false; this.hideCharacterArt(bro);
};
A.stylePortraitCorpse <- function(sprite, scale = 1.0, flip = false) {
    sprite.Color = ::createColor("#ffffff"); sprite.Saturation = 0.75;
    // Prone pose and neck offset are baked in the brush, including UI renders.
    // Native horizontal flipping now mirrors the whole pose exactly once.
    sprite.Scale = scale; sprite.Rotation = 0;
};
A.portraitCorpseBrush <- function(bro, brush, fatality) {
    local level = "afeixPortraitWoundLevel" in bro.m ? bro.m.afeixPortraitWoundLevel : 0;
    local bloodied = "afeixPortraitBloodied" in bro.m && bro.m.afeixPortraitBloodied;
    bloodied = bloodied || ("BloodiedCount" in bro.m && bro.m.BloodiedCount >= ::Const.Combat.BloodiedBustCount);
    if (bro.getHitpoints() > 0) {
        local ratio = bro.getHitpoints() / (bro.getHitpointsMax() * 1.0);
        level = ratio > 0.67 ? 0 : (ratio > 0.33 ? 1 : 2);
        bloodied = bloodied || ratio < 1.0;
    }
    if (!bloodied && fatality != ::Const.FatalityType.Unconscious) {
        bloodied = true; level = 2;
    }
    local suffix = level == 0 ? "_corpse_head_bloodied" : "_corpse_head_injured_0" + level;
    return bloodied && ::doesBrushExist(brush + suffix) ? brush + suffix : brush + "_corpse_head";
};
A.replacePortraitCorpse <- function(bro, tile, brush, fatality) {
    local F = ::Const.FatalityType;
    if (fatality == F.Decapitated || fatality == F.Smashed || fatality == F.Devoured || fatality == F.Kraken) return;
    local appearance = bro.getItems().getAppearance();
    local helmet = "HelmetCorpse" in appearance ? appearance.HelmetCorpse : "";
    local flip = bro.m.IsCorpseFlipped;
    // Wounds are composed with the living face before applying its exact
    // prone transform. No ground blood pool is pasted onto the neck.
    local headBrush = this.portraitCorpseBrush(bro, brush, fatality);
    if (tile != null) {
        local offset = ::Const.Combat.HumanCorpseOffset;
        local head = tile.spawnDetail(headBrush, ::Const.Tactical.DetailFlag.Corpse,
            flip, false, offset);
        this.stylePortraitCorpse(head, 0.9, flip);
        if (helmet != "" && ::doesBrushExist(helmet)) {
            local cap = tile.spawnDetail(helmet, ::Const.Tactical.DetailFlag.Corpse, flip, false, offset);
            cap.Scale = 0.9; cap.setBrightness(0.9);
        }
    }
    foreach (stub in ::Tactical.getCasualtyRoster().getAll()) {
        if (stub.getOriginalID() != bro.getID()) continue;
        local head = stub.hasSprite("head") ? stub.getSprite("head") : stub.addSprite("head");
        head.setBrush(headBrush); head.Visible = true;
        this.stylePortraitCorpse(head);
        stub.setSpriteOffset("head", ::createVec(0, 0));
        if (helmet != "" && ::doesBrushExist(helmet)) {
            local cap = stub.hasSprite("helmet") ? stub.getSprite("helmet") : stub.addSprite("helmet");
            cap.setBrush(helmet); cap.Visible = true;
        }
    }
};
