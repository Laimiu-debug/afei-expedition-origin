// Presentation-only company banner. Keep the saved numeric banner variant for
// native consumers; the original battle standard keeps its stats and skills.
::AfeixExpedition.ToadBanners <- [
    {key="native", name="建团时选择的旗帜", suffix=null},
    {key="classic", name="黑金蛤蟆", suffix=""},
    {key="front", name="正面踩球蛤蟆", suffix="_front"},
    {key="profile", name="侧身踩球蛤蟆", suffix="_profile"},
    {key="medallion", name="圆章蛤蟆", suffix="_medallion"},
    {key="golden", name="黄金天使蛙", suffix="_golden"}
];
::AfeixExpedition.toadBanner <- function() {
    local key = "native";
    if ("World" in getroottable() && ::World != null && "Flags" in ::World && ::World.Flags != null)
        key = this.get("banner_style", "native");
    foreach (banner in this.ToadBanners) if (banner.key == key) return banner;
    return this.ToadBanners[0];
};
::AfeixExpedition.chooseToadBanner <- function(key) {
    if (!this.isOrigin() || ::Tactical.isActive() || ::World.State == null
        || ::World.State.getCombatStartTime() != 0 || ::World.State.getPlayer() == null)
        return this.result(false, "请回到大地图后更换旗帜。");
    foreach (banner in this.ToadBanners) {
        if (banner.key != key) continue;
        this.set("banner_style", key);
        this.syncToadBanner();
        return this.result(true, "已换上“" + banner.name + "”旗帜。");
    }
    return this.result(false, "没有找到这款旗帜。");
};
::AfeixExpedition.toadBannerOption <- function(banner, page) {
    local label = (this.toadBanner().key == banner.key ? "[当前] " : "换上：") + banner.name;
    return this.ledgerAction(label, function() { return ::AfeixExpedition.chooseToadBanner(banner.key); }, page);
};
::AfeixExpedition.bannerLedgerPage <- function(event, page) {
    local parts = split(page, ":"), kind = parts[0];
    if (kind != "company" && kind != "banners") return null;
    local screen = {ID=page, Text="", Image="", List=[], Characters=[], Options=[], function start(event) {}};
    if (kind == "company") {
        screen.Text = "战团事务\n\n安排伙伴研习技能、选择旗帜，或切换全队头盔外观。\n\n隐藏头盔只影响在队成员的外观，装备、防护、疲劳和技能效果保持不变。";
        if ("trainingLedgerPage" in this) screen.Options.push(this.ledgerNav("研习专属技能", "training"));
        screen.Options.push(this.ledgerNav("更换旗帜", "banners"));
        if ("toggleCompanyHelmets" in this) screen.Options.push(this.ledgerAction(
            this.get("hide_helmets", false) ? "显示全队头盔" : "隐藏全队头盔",
            function() { return ::AfeixExpedition.toggleCompanyHelmets(); }, "company"));
        screen.Options.push(this.ledgerNav("返回名册", "home"));
    } else {
        local banner = this.toadBanner();
        screen.Text = "[img]gfx/ui/banners/" + ::World.Assets.getBanner() + "s.png[/img]更换旗帜\n\n当前：" + banner.name
            + "。\n\n可以恢复建团时选择的旗帜，也可以选用蛤蟆旗。点选即可换旗，选择会随存档保留。大地图旗与已获得的战旗使用相同图案。";
        local offset = parts.len() > 1 ? parts[1].tointeger() : 0;
        local window = this.ledgerWindow(this.ToadBanners.len(), offset), stay = "banners:" + window.offset;
        for (local i = 0; i < window.count; i++)
            screen.Options.push(this.toadBannerOption(this.ToadBanners[window.offset + i], stay));
        if (window.more) screen.Options.push(this.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", "banners:" + window.next));
        screen.Options.push(this.ledgerNav("返回战团事务", "company"));
    }
    return screen;
};
::AfeixExpedition.applyToadStandardArt <- function(actor) {
    if (actor == null) return;
    local banner = this.toadBanner(), native = banner.key == "native";
    local brush = native ? "player_" + ::World.Assets.getBanner() : "afeix_toad_standard" + banner.suffix;
    local shaft = native ? brush + "_shaft" : "player_banner_15_shaft";
    if (actor.hasSprite("background")) actor.getSprite("background").setBrush(brush);
    if (actor.hasSprite("shaft")) actor.getSprite("shaft").setBrush(shaft);
    actor.setDirty(true);
};
::mods_hookNewObject("states/world/asset_manager", function(o) {
    local getBanner = o.getBanner;
    o.getBanner = function() {
        local A = ::AfeixExpedition;
        return A.isOrigin() && A.toadBanner().key != "native" ? "banner_afeix_toad" + A.toadBanner().suffix : getBanner.bindenv(this)();
    };
});
::AfeixExpedition.syncToadBanner <- function() {
    if (!this.isOrigin() || ::World.State == null) return;
    local party = ::World.State.getPlayer();
    local brush = ::World.Assets.getBanner();
    if (party == null || !::doesBrushExist(brush)) return;
    foreach (name in ["banner", "zoom_banner"])
        if (party.hasSprite(name)) party.getSprite(name).setBrush(brush);
    // Items can deserialize before Assets restores the campaign origin.
    // Refresh their presentation after world load without re-equipping skills.
    foreach (bro in this.roster()) {
        foreach (item in bro.getItems().getAllItems())
            if (item != null && item.getID() == "weapon.player_banner") item.updateVariant();
        local held = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (held != null && held.getID() == "weapon.player_banner") this.applyToadStandardArt(bro);
    }
    foreach (item in ::World.Assets.getStash().getItems())
        if (item != null && item.getID() == "weapon.player_banner") item.updateVariant();
};
::mods_hookExactClass("states/world_state", function(o) {
    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function(input) {
        local result = onDeserialize.bindenv(this)(input);
        ::AfeixExpedition.syncToadBanner();
        return result;
    };
});
::mods_hookExactClass("items/tools/player_banner", function(o) {
    local updateVariant = o.updateVariant, onEquip = o.onEquip;
    o.updateVariant = function() {
        local result = updateVariant.bindenv(this)();
        if (::AfeixExpedition.isOrigin()) {
            local banner = ::AfeixExpedition.toadBanner();
            local icon = banner.key == "native" ? "weapons/banner/" + ::World.Assets.getBanner() : "weapons/afeix_toad_banner" + banner.suffix;
            this.m.Icon = icon + "_70x70.png";
            this.m.IconLarge = icon + ".png";
        }
        return result;
    };
    o.onEquip = function() {
        local result = onEquip.bindenv(this)();
        if (::AfeixExpedition.isOrigin()) {
            this.updateVariant();
            local actor = this.getContainer().getActor();
            ::AfeixExpedition.applyToadStandardArt(actor);
        }
        return result;
    };
});
