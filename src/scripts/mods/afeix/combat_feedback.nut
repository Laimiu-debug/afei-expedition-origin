// Use the installed game's circular status brushes and native skill-use VFX.
// Main skill-button art stays custom; IconMini is a brush ID, never a PNG path.
local A = ::AfeixExpedition;
A.feedbackKind <- function(key) {
    if (["nicotine", "nicotine_debt", "ecig"].find(key) != null) return "recover";
    if (["wawa", "turtle_awakening", "turtle_shell", "guard_nest", "borrow_strike", "feidie_guard"].find(key) != null) return "guard";
    if (["breakthrough_exposed", "douyu_pressure"].find(key) != null) return "debuff";
    if (["dog_bark", "pokemon", "douyu_mark"].find(key) != null) return "mark";
    if (!("MemberSkillDefs" in this) || !(key in this.MemberSkillDefs)) return "support";
    local d = this.MemberSkillDefs[key];
    if ("mode" in d) {
        if (d.mode == "step" || d.mode == "swap" || d.mode == "unnet") return d.mode;
        if (d.mode == "mark" || d.mode == "snare" || d.mode == "taunt") return "mark";
        if (d.mode == "weapon") return "attack";
    }
    if ("target" in d && d.target == "weapon") return "attack";
    if (("shield" in d && d.shield) || (key in this.CatalogEffects && ("md" in this.CatalogEffects[key] || "rd" in this.CatalogEffects[key]))) return "guard";
    return "support";
};
A.feedbackBrush <- function(key) {
    local kind = this.feedbackKind(key);
    if (kind == "guard") return "status_effect_03";
    if (kind == "debuff" || kind == "recover") return "status_effect_74";
    if (kind == "mark") return "status_effect_34";
    return "status_effect_33";
};
A.configureStatusFeedback <- function(skill, key, showOnAdd = true) {
    local brush = this.feedbackBrush(key);
    skill.m.IconMini <- brush + "_mini";
    skill.m.Overlay <- showOnAdd ? brush : "";
};
A.configureActiveFeedback <- function(skill, key) {
    local kind = this.feedbackKind(key), overlay = "perk_42_active", sound = "sounds/combat/rally_the_troops_01.wav";
    if (kind == "guard") { overlay = "active_15"; sound = "sounds/combat/shieldwall_01.wav"; }
    else if (kind == "recover") { overlay = "perk_54_active"; sound = "sounds/combat/drink_01.wav"; }
    else if (kind == "mark") { overlay = "perk_38_active"; sound = "sounds/combat/taunt_01.wav"; }
    else if (kind == "step" || kind == "unnet") { overlay = "perk_25_active"; sound = "sounds/combat/footwork_01.wav"; }
    else if (kind == "swap") { overlay = "perk_11_active"; sound = "sounds/combat/rotation_01.wav"; }
    else if (kind == "attack") { overlay = "status_effect_34"; sound = "sounds/combat/perfect_focus_01.wav"; }
    skill.m.Overlay <- overlay;
    skill.m.SoundOnUse <- [sound];
    skill.m.SoundVolume <- 0.8;
};
A.logCustomSkill <- function(skill, user, target = null) {
    if (!("EventLog" in ::Tactical) || !("UI" in ::Const)) return;
    if (!::Tactical.isActive() || user == null || !user.isPlacedOnMap() || !user.getTile().IsVisibleForPlayer) return;
    local text = ::Const.UI.getColorizedEntityName(user) + " 使用「" + skill.getName() + "」";
    if (target != null && target.IsOccupiedByActor && target.getEntity().getID() != user.getID() && target.IsVisibleForPlayer)
        text += " → " + ::Const.UI.getColorizedEntityName(target.getEntity());
    ::Tactical.EventLog.log(text);
};
A.feedbackParticles <- function(tile, name, scale = 1.0) {
    if (!::Tactical.isActive() || tile == null || !tile.IsVisibleForPlayer || !(name in ::Const.Tactical)) return;
    foreach (p in ::Const.Tactical[name])
        ::Tactical.spawnParticleEffect(false, p.Brushes, tile, p.Delay,
            ::Math.max(1, (p.Quantity * scale).tointeger()), p.LifeTimeQuantity,
            ::Math.max(1, (p.SpawnRate * scale).tointeger()), p.Stages);
};
A.feedbackImpactSound <- function(tile) {
    if (tile != null && tile.IsVisibleForPlayer && "Sound" in getroottable())
        ::Sound.play("sounds/combat/dlc6/fire_mortar_impact_01.wav", ::Const.Sound.Volume.Skill, tile.Pos);
};
