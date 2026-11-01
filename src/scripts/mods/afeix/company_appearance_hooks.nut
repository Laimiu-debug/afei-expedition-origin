// Campaign preference uses the native display flag, never unequips helmets or
// changes the shared item appearance table, protection or corpse/drop handling.
local A = ::AfeixExpedition;
A.ensureCompanyHelmetDefault <- function() {
    if (!this.isOrigin() || !("World" in getroottable()) || ::World == null
        || !("Flags" in ::World) || ::World.Flags == null) return false;
    // The dream snapshots this choice before construction; never run a world
    // flag migration against the dream's isolated get/set namespace.
    if ("isDreamCombat" in this && this.isDreamCombat()) return true;
    // One migration for older campaigns; subsequent explicit choices persist.
    if (!::World.Flags.has("afeix_full_portrait_helmet_default")) {
        this.set("hide_helmets", true);
        this.set("full_portrait_helmet_default", true);
    } else if (!::World.Flags.has("afeix_hide_helmets")) this.set("hide_helmets", true);
    return true;
};
A.managesCompanyHelmet <- function(bro) {
    return this.isOrigin() && bro != null && bro.m.IsAlive && !bro.m.IsDying
        && "World" in getroottable() && ::World != null
        && "Flags" in ::World && ::World.Flags != null
        && (this.roster().find(bro) != null
            || ("isDreamCombat" in this && this.isDreamCombat()
                && bro.getFlags().has("afeix_dream_actor") && bro.getFlags().get("afeix_dream_actor") == true));
};
A.applyCompanyHelmetState <- function(bro) {
    if (!this.managesCompanyHelmet(bro) || !this.ensureCompanyHelmetDefault()) return false;
    bro.m.IsHidingHelmet = this.get("hide_helmets", true);
    return true;
};
A.syncCompanyHelmet <- function(bro) {
    if (!this.applyCompanyHelmetState(bro)) return;
    bro.onAppearanceChanged(bro.getItems().getAppearance());
};
A.syncCompanyHelmets <- function() {
    if (!this.ensureCompanyHelmetDefault()) return;
    foreach (bro in this.roster()) this.syncCompanyHelmet(bro);
};
A.toggleCompanyHelmets <- function() {
    if (!this.isOrigin() || ::Tactical.isActive() || ::World.State == null
        || ::World.State.getCombatStartTime() != 0 || ::World.State.getPlayer() == null)
        return this.result(false, "请回到大地图后切换头盔外观。");
    if (!this.ensureCompanyHelmetDefault()) return this.result(false, "当前战役尚未就绪。");
    local hidden = !this.get("hide_helmets", true);
    this.set("hide_helmets", hidden);
    this.syncCompanyHelmets();
    return this.result(true, hidden ? "已隐藏全队头盔外观，防护和装备效果保持不变。" : "已恢复显示全队头盔。");
};
::mods_hookExactClass("entity/tactical/player", function(o) {
    local appearance = ::mods_getMember(o, "onAppearanceChanged");
    ::mods_override(o, "onAppearanceChanged", function(value, setDirty = true) {
        local A = ::AfeixExpedition, managed = A.applyCompanyHelmetState(this);
        local result = appearance.bindenv(this)(value, setDirty);
        // Native closed helmets hide the head even with IsHidingHelmet set.
        if (managed && this.m.IsHidingHelmet && this.hasSprite("head")) {
            this.getSprite("head").Visible = true;
            if (setDirty) this.setDirty(true);
        }
        return result;
    });
    local loaded = ::mods_getMember(o, "onDeserialize");
    ::mods_override(o, "onDeserialize", function(input) {
        local result = loaded.bindenv(this)(input);
        ::AfeixExpedition.syncCompanyHelmet(this);
        return result;
    });
    local combatFinished = ::mods_getMember(o, "onCombatFinished");
    ::mods_override(o, "onCombatFinished", function() {
        local result = combatFinished.bindenv(this)();
        ::AfeixExpedition.syncCompanyHelmet(this);
        return result;
    });
});
::mods_hookExactClass("states/world_state", function(o) {
    local loaded = o.onDeserialize;
    o.onDeserialize = function(input) {
        local result = loaded.bindenv(this)(input);
        ::AfeixExpedition.syncCompanyHelmets();
        return result;
    };
});
::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_hire_dialog_module", function(o) {
    local hired = o.onHireRosterEntry;
    o.onHireRosterEntry = function(id) {
        local result = hired.bindenv(this)(id);
        if (result != null && result.Result == 0) ::AfeixExpedition.syncCompanyHelmets();
        return result;
    };
});
