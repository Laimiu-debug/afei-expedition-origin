::AfeixSkinsDLC <- {
    Flag = "afeix_dlc_afei_skins_style",
    Page = "afeix_dlc_skins",
    CGs = [
        {name="阿飞 · 战败 CG（一）", image="gfx/ui/events/afeix_dlc_skins_afei_defeat_01.png"},
        {name="阿飞 · 战败 CG（二）", image="gfx/ui/events/afeix_dlc_skins_afei_defeat_02.png"}
    ],
    Styles = [
        {key="native", name="原有阿飞", brush=null, description="恢复原有阿飞外观。"},
        {key="captain", name="黑旗团长", brush="afeix_dlc_skins_captain", description="黑色披肩与旧金色衣领。"},
        {key="wanderer", name="荒野行者", brush="afeix_dlc_skins_wanderer", description="橄榄绿兜帽与旅行披肩。"},
        {key="veteran", name="赤巾老兵", brush="afeix_dlc_skins_veteran", description="赤色头巾与短围巾。"},
        {key="bare", name="裸上身", brush="afeix_dlc_skins_bare", description="裸肩与上胸的素装胸像。"},
        {key="huxueer", name="胡雪儿", brush="afeix_dlc_skins_huxueer", description="粉色短发、含笑眼妆与白色露肩高领上衣。"},
        {key="toad", name="蛤蟆形态", brush="afeix_dlc_skins_toad", description="橄榄绿蛤蟆与黑色披肩。"}
    ]
};
local D = ::AfeixSkinsDLC;
D.flagsReady <- function() {
    return "World" in getroottable() && ::World != null && "Flags" in ::World && ::World.Flags != null;
};
D.findStyle <- function(key) {
    foreach (style in this.Styles) if (style.key == key) return style;
    return null;
};
D.completeBrush <- function(brush) {
    if (brush == null) return false;
    foreach (suffix in ["", "_head", "_dead", "_corpse_head"])
        if (!::doesBrushExist(brush + suffix)) return false;
    return true;
};
D.isSkinBrush <- function(brush) {
    if (typeof brush != "string") return false;
    foreach (style in this.Styles) if (style.brush != null && style.brush == brush) return true;
    return false;
};
D.selected <- function() {
    local key = this.flagsReady() && ::World.Flags.has(this.Flag) ? ::World.Flags.get(this.Flag) : "native";
    local style = this.findStyle(key);
    return style != null && (style.brush == null || this.completeBrush(style.brush)) ? style : this.Styles[0];
};
D.afei <- function() {
    local A = ::AfeixExpedition;
    if (!A.isOrigin()) return null;
    foreach (bro in A.roster()) {
        if (bro != null && bro.m.IsAlive && !bro.m.IsDying
            && bro.getFlags().has("afeix_character") && bro.getFlags().get("afeix_character") == "afei") return bro;
    }
    return null;
};
D.choose <- function(key) {
    local A = ::AfeixExpedition;
    if (!A.isOrigin() || !this.flagsReady() || ::Tactical.isActive() || ::World.State == null
        || ::World.State.getCombatStartTime() != 0 || ::World.State.getPlayer() == null)
        return A.result(false, "请回到大地图后更换阿飞外观。");
    local bro = this.afei(), style = this.findStyle(key);
    if (bro == null) return A.result(false, "阿飞目前不在队伍中，无法更换外观。");
    if (style == null || (style.brush != null && !this.completeBrush(style.brush)))
        return A.result(false, "没有找到这套完整的美术资源。");
    ::World.Flags.set(this.Flag, key);
    A.syncCharacterArt(bro);
    A.syncWorldPartyArt();
    return A.result(true, "已换上“" + style.name + "”。");
};
D.option <- function(style, page) {
    local D = this, A = ::AfeixExpedition;
    return A.ledgerAction((this.selected().key == style.key ? "[当前] " : "换上：") + style.name,
        function() { return D.choose(style.key); }, page);
};
D.ledgerPage <- function(event, page) {
    local A = ::AfeixExpedition, parts = split(page, ":");
    if (parts[0] != this.Page) return null;
    local screen = {ID=page, Text="", Image="", List=[], Characters=[], Options=[], function start(event) {}};
    if (parts.len() > 1 && parts[1] == "cg") {
        local index = parts.len() > 2 ? A.storyPageNumber(parts[2]) : 0;
        if (index < 0 || index >= this.CGs.len()) index = 0;
        local cg = this.CGs[index];
        screen.Text = "[img]" + cg.image + "[/img]" + cg.name + "\n\n" + (index + 1) + " / " + this.CGs.len();
        screen.Options.push(A.ledgerNav(index == 0 ? "下一张 CG" : "上一张 CG", this.Page + ":cg:" + (1 - index)));
        local offset = "AfeixSkinPage" in event.m ? event.m.AfeixSkinPage : 3;
        screen.Options.push(A.ledgerNav("返回阿飞外观", this.Page + ":" + offset));
        screen.Options.push(A.ledgerNav("返回战团事务", "company"));
        return screen;
    }
    local offset = parts.len() > 1 ? A.storyPageNumber(parts[1]) : 0;
    local window = A.ledgerWindow(this.Styles.len(), offset, 3), stay = this.Page + ":" + window.offset;
    event.m.AfeixSkinPage <- window.offset;
    local style = this.selected();
    screen.Text = "[img]gfx/ui/afeix_dlc_afei_skins/" + style.key + ".png[/img]阿飞外观\n\n当前：" + style.name
        + "。\n" + style.description + "\n\n点击即可更换，选择随存档保存。实际护甲、头盔和武器仍会显示；可在战团事务中隐藏头盔。";
    if (this.afei() == null) screen.Text += "\n\n阿飞目前不在队伍中。";
    for (local i = 0; i < window.count; i++) screen.Options.push(this.option(this.Styles[window.offset + i], stay));
    if (window.more) screen.Options.push(A.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", this.Page + ":" + window.next));
    screen.Options.push(A.ledgerNav("欣赏阿飞战败 CG", this.Page + ":cg:0"));
    screen.Options.push(A.ledgerNav("返回战团事务", "company"));
    return screen;
};
