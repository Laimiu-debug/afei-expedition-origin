local A = ::AfeixExpedition;

A.ledgerOption <- function(label, action) {
    return { Text = label, Action = action, function getResult(event) { return this.Action(event); } };
};
A.ledgerNav <- function(label, page) {
    return this.ledgerOption(label, function(event) { event.m.Notice = ""; return page; });
};
A.ledgerAction <- function(label, action, page) {
    return this.ledgerOption(label, function(event) {
        local result = action();
        event.m.Notice = result.text;
        return page;
    });
};
A.ledgerStatus <- function(status) {
    local labels = { locked = "尚无线索", encounter = "曾经相遇", waiting = "等待重逢", available = "可以招募", recruited = "已经入队", dead = "已经阵亡", departed = "已经离队" };
    return status in labels ? labels[status] : "尚无线索";
};
A.ledgerWindow <- function(total, offset, limit = 4) {
    if (offset < 0 || offset >= total) offset = 0;
    local count = ::Math.min(limit, total - offset);
    local next = offset + count;
    return { offset = offset, count = count, more = total > limit, next = next >= total ? 0 : next };
};
A.ledgerToggle <- function(event, actorId) {
    local index = event.m.Selected.find(actorId);
    if (index != null) {
        event.m.Selected.remove(index);
        event.m.Notice = "";
    } else if (event.m.Selected.len() >= this.CombatMax) {
        event.m.Notice = "最多选择 " + this.CombatMax + " 人出战。请先取消一位，再加入另一位。";
    } else {
        event.m.Selected.push(actorId);
        event.m.Notice = "";
    }
};
// Factory arguments give every row its own captured actor ID and destination.
A.ledgerActorOption <- function(label, actorId, page) {
    return this.ledgerOption(label, function(event) {
        ::AfeixExpedition.ledgerToggle(event, actorId);
        return page;
    });
};
A.ledgerCharacterReturn <- function(key) {
    local members = this.knownMembers(), index = members.find(key);
    return "recruits:" + (index == null ? 0 : index / 4 * 4);
};
A.ledgerEncounterOption <- function(label, key, index) {
    return this.ledgerOption(label, function(event) {
        local result = ::AfeixExpedition.resolveEncounter(key, index);
        event.m.Notice = result.text;
        return (result.ok ? "recruit:" : "encounter:") + key;
    });
};

A.ledgerPage <- function(event, page) {
    local A = ::AfeixExpedition;
    local screen = { ID = page, Text = "", Image = "", List = [], Characters = [], Options = [], function start(event) {} };
    local parts = split(page, ":");
    local kind = parts[0];
    // Offers only live on their current confirmation screen; returning or
    // rebuilding it invalidates callbacks captured from an earlier screen.
    event.m.TreatmentOffer <- null;
    local extension = "storyLedgerPage" in A ? A.storyLedgerPage(event, page) : null;
    if (extension == null && "promotionLedgerPage" in A) extension = A.promotionLedgerPage(event, page);
    if (extension == null && "trainingLedgerPage" in A) extension = A.trainingLedgerPage(event, page);
    if (extension == null && "treatmentLedgerPage" in A) extension = A.treatmentLedgerPage(event, page);
    if (extension == null && "ideasLedgerPage" in A) extension = A.ideasLedgerPage(event, page);
    if (extension == null && "bannerLedgerPage" in A) extension = A.bannerLedgerPage(event, page);
    if (extension == null && kind == "dream_final" && "dreamPage" in A) extension = A.dreamPage(event, page);
    if (extension != null) {
        screen = extension;
    } else if (kind == "home") {
        screen.Text = "黑旗名册\n\n同行 " + A.roster().len() + " 人；当前出战 " + A.deployedIds().len() + " / " + A.CombatMax + " 人。\n\n这里可以查看委托、伙伴和旅途中的故事。想找新伙伴，请看城镇招募栏；去酒馆可以遇见熟人、聊聊近况。人物栏可以调整站位、装备和待命安排。\n世界地图按 F8 可重新打开名册。";
        if (!A.canManage()) screen.Text += "\n\n"
            + ("treatmentLedgerPage" in A ? "飞李不可仅限酒馆内使用；" : "现在可以查看记录；")
            + "招募和确认编队，请到友好城镇附近或安全扎营处。";
        screen.Options.push(A.ledgerNav("查看委托记录", "quest"));
        screen.Options.push(A.ledgerNav("已经认识的伙伴", "recruits"));
        screen.Options.push(A.ledgerOption("选择出战成员", function(e) {
            e.m.Selected = clone A.deployedIds();
            e.m.FormationPage = 0;
            e.m.Notice = "";
            return "formation:0";
        }));
        if ("bannerLedgerPage" in A) screen.Options.push(A.ledgerNav("战团事务", "company"));
        else if ("trainingLedgerPage" in A) screen.Options.push(A.ledgerNav("研习专属技能", "training"));
        if ("dreamPage" in A) screen.Options.push(A.ledgerNav("再赴梦潮", "dream_final"));
        // With the dream shortcut present, history moves into company affairs
        // so the native home screen still fits its six option buttons.
        if (!("dreamPage" in A && "bannerLedgerPage" in A) && (A.hasStoryRecords() || ("hasIdeaRecords" in A && A.hasIdeaRecords())))
            screen.Options.push(A.ledgerNav("翻看旅途旧事", "hasIdeaRecords" in A && A.hasIdeaRecords()?"journey_index":"growth"));
        screen.Options.push(A.ledgerOption("合上名册，继续上路", function(e) { return 0; }));
    } else if (kind == "quest" || kind == "quest_cancel") {
        screen.Text = "委托记录\n\n" + A.questSummary();
        screen.Options.push(A.ledgerNav("返回名册", "home"));
    } else if (kind == "recruits" || kind == "tavern") {
        local members = [];
        foreach (key in A.knownMembers()) {
            local status = A.characterStatus(key);
            if (kind != "tavern" || status == "encounter" || status == "available") members.push(key);
        }
        local offset = parts.len() > 1 ? A.storyPageNumber(parts[1]) : 0;
        local treatment = kind == "tavern" && "treatmentLedgerPage" in A;
        local window = A.ledgerWindow(members.len(), offset, treatment ? 3 : 4);
        screen.Text = kind == "tavern" ? "酒馆里的熟面孔\n\n这里可以查看已认识的伙伴。想雇人加入队伍，请打开城镇招募栏。" : "已经认识的伙伴\n\n点名字查看介绍、招募地点和当前状态。";
        if (members.len() == 0) screen.Text += kind == "tavern" ? "\n\n暂时没有新的消息，先喝一杯吧。" : "\n\n还没有认识的伙伴。";
        for (local i = 0; i < window.count; i++) {
            local key = members[window.offset + i];
            screen.Options.push(A.ledgerNav(A.Characters[key].name + " · " + A.ledgerStatus(A.characterStatus(key)), "recruit:" + key));
        }
        if (window.more) screen.Options.push(A.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", kind + ":" + window.next));
        if (treatment) screen.Options.push(A.ledgerNav("飞李不可 · 100克朗加1点", "treatment"));
        screen.Options.push(kind == "tavern" ? A.ledgerOption("先喝一杯，改日再聊", function(e) { return 0; }) : A.ledgerNav("返回名册", "home"));
    } else if (kind == "recruit" && parts.len() > 1 && parts[1] in A.Characters && A.isCharacterKnown(parts[1])) {
        local key = parts[1];
        local data = A.Characters[key];
        local state = A.characterStatus(key);
        local price = A.recruitPrice(key);
        screen.Text = data.name + "\n\n" + data.description + "\n\n起步方向：" + data.role + "。\n状态：" + A.ledgerStatus(state) + "。";
        if (data.isCaptain) screen.Text += "\n开局队长；起步日薪 " + data.wage + " 克朗，日后会随成长等因素变化。";
        else screen.Text += "\n当前招募费 " + price + " 克朗；起步日薪 " + data.wage + " 克朗，日后会随成长等因素变化。";
        screen.Text += "\n\n" + A.recruitHint(key);
        if (state == "recruited") {
            screen.Text += "\n\n" + data.name + "已在队伍中，可到编队页安排出战或待命。";
        } else if (state == "dead") {
            screen.Text += "\n\n" + data.name + "的名字留在这里，无法再次招募。";
        } else if (state == "departed") {
            screen.Text += "\n\n" + data.name + "已经离开远征团，这份邀请不再有效。";
        }
        screen.Options.push(A.ledgerNav("返回已知伙伴", A.ledgerCharacterReturn(key)));
        screen.Options.push(A.ledgerNav("返回名册", "home"));
    } else if (kind == "encounter" && parts.len() > 1 && parts[1] in A.Characters && A.isCharacterKnown(parts[1])) {
        local key = parts[1], data = A.Characters[key];
        local state = A.characterStatus(key);
        screen.Text = data.name + "的相遇\n\n" + A.recruitHint(key);
        screen.Text += "\n\n当前状态：" + A.ledgerStatus(state) + "。请在城镇招募界面办理雇佣。";
        screen.Options.push(A.ledgerNav("暂缓／返回人物档案", "recruit:" + key));
    } else if (kind == "formation") {
        local brothers = A.roster();
        local offset = parts.len() > 1 ? parts[1].tointeger() : 0;
        local window = A.ledgerWindow(brothers.len(), offset);
        event.m.FormationPage = window.offset;
        local stay = "formation:" + window.offset;
        screen.Text = "选择出战成员\n\n已选 " + event.m.Selected.len() + " / " + A.CombatMax + " 人。点名字可选择或取消；核对并确认前，现有阵容不会改变。\n\n原版人物栏仍能调整站位和装备。";
        if (brothers.len() == 0) screen.Text += "\n\n名册里已经没有同行成员。";
        for (local i = 0; i < window.count; i++) {
            local bro = brothers[window.offset + i];
            local id = bro.getID();
            local selected = event.m.Selected.find(id) != null;
            local label = (selected ? "[已选] " : "[待命] ") + bro.getNameOnly() + " · " + bro.getLevel() + " 级";
            screen.Options.push(A.ledgerActorOption(label, id, stay));
        }
        if (window.more) screen.Options.push(A.ledgerNav(window.next == 0 ? "回到第一页" : "下一页", "formation:" + window.next));
        screen.Options.push(A.ledgerNav("核对名单／返回", "formation_review"));
    } else if (kind == "formation_review") {
        screen.Text = "核对出战名单\n\n已选 " + event.m.Selected.len() + " / " + A.CombatMax + " 人：";
        local found = 0;
        foreach (bro in A.roster()) {
            if (event.m.Selected.find(bro.getID()) == null) continue;
            screen.Text += "\n" + bro.getNameOnly();
            found++;
        }
        if (found == 0) screen.Text += "\n尚未选择成员。";
        screen.Text += "\n\n确认后，未选成员进入待命；原本出战且仍被选中的成员保留站位。取消本次选择不会改变现有阵容。";
        screen.Options.push(A.ledgerOption("确认这份出战名单", function(e) {
            local result = A.applyFormation(clone e.m.Selected);
            e.m.Notice = result.text;
            if (!result.ok) return "formation_review";
            e.m.Selected = [];
            e.m.FormationPage = 0;
            return "home";
        }));
        screen.Options.push(A.ledgerNav("继续选择成员", "formation:" + event.m.FormationPage));
        screen.Options.push(A.ledgerOption("取消本次选择，返回名册", function(e) {
            e.m.Selected = [];
            e.m.FormationPage = 0;
            e.m.Notice = "已取消，出战阵容没有改变。";
            return "home";
        }));
    } else {
        screen.Text = "这一页暂时没有内容，请返回名册。";
        screen.Options.push(A.ledgerNav("返回名册", "home"));
    }
    if (event.m.Notice != "") {
        // Keep treatment receipts and refusals above the eight-attribute list
        // so a click's outcome stays visible without scrolling to the bottom.
        if (["treatment", "treatment_actor", "treatment_preview"].find(kind) != null)
            screen.Text = event.m.Notice + "\n\n" + screen.Text;
        else screen.Text += "\n\n" + event.m.Notice;
    }
    screen.Text += "\n\n按 Esc 合上名册。";
    // Six is the native event window's usable button limit; never silently drop an action.
    if (screen.Options.len() > 6) throw "Afeix ledger page exceeds six options: " + page;
    if (kind != "banners") screen.Text = "[img]gfx/ui/events/event_80.png[/img]" + screen.Text;
    return screen;
};

A.ledgerBlocked <- function(reason) {
    if ("logInfo" in getroottable()) ::logInfo("[AfeixExpedition] Ledger blocked: " + reason);
    return false;
};
A.closeLedger <- function(state) {
    if (!this.isOrigin() || ::Tactical.isActive() || ::World.Events == null) return false;
    local event = ::World.Events.m.ActiveEvent;
    if (event == null || event.getID() != "event.afeix_ledger") return false;
    // Consume Escape during the opening/closing animation as well. Finish
    // through the native event manager, preserving the map/town backstep.
    if (state.m.EventScreen == null || !state.m.EventScreen.isVisible()
        || state.m.EventScreen.isAnimating()) return true;
    ::World.Events.processInput(-1);
    return true;
};
A.openLedger <- function(page = "home", tavernTown = 0) {
    if (!this.isOrigin()) return this.ledgerBlocked("not this origin");
    if (::Tactical.isActive() || ::World.State == null || ::World.Events == null) return this.ledgerBlocked("combat or world not ready");
    local state = ::World.State;
    if (state.getPlayer() == null || state.getCombatStartTime() != 0) return this.ledgerBlocked("no player or combat transition");
    if (::World.Events.hasActiveEvent()) return this.ledgerBlocked("another event is active");
    if (("State" in ::Tactical) && ::Tactical.State != null) return this.ledgerBlocked("tactical state still active");
    if (("LoadingScreen" in getroottable()) && ::LoadingScreen != null
        && (::LoadingScreen.isVisible() || ::LoadingScreen.isAnimating())) return this.ledgerBlocked("loading screen");
    // Opening characters from town only hides its dialogs: the town itself
    // stays visible. Never put a non-cancellable event above the character
    // backstep; native C/Escape would then try to pop that event and get stuck.
    // The native predicate also covers animation and character popup dialogs.
    if (state.isInCharacterScreen()) return this.ledgerBlocked("character screen busy");
    if (state.m.EventScreen == null || state.m.EventScreen.isVisible() || state.m.EventScreen.isAnimating()) return this.ledgerBlocked("event screen busy");
    local event = ::World.Events.getEvent("event.afeix_ledger");
    if (event == null) return this.ledgerBlocked("ledger event missing");
    local fromTown = state.m.MenuStack.hasBacksteps();
    if (fromTown) {
        // The entered town is authoritative. Map proximity/hostile-party
        // checks in canManage() must not block reading from inside its inn.
        local screen = state.m.WorldTownScreen;
        if (screen == null || !screen.isVisible() || screen.isAnimating()
            || !state.m.MenuStack.isAllowingCancel()) return this.ledgerBlocked("another menu or town screen busy");
        local town = screen.getTown();
        if (town == null || !town.isAlive() || !town.isAlliedWithPlayer())
            return this.ledgerBlocked("no entered friendly town");
        local inTavern = this.isAtTavern();
        // The native town predicate omits the tavern module's own animation.
        if (inTavern && screen.getTavernDialogModule().isAnimating())
            return this.ledgerBlocked("tavern dialog animating");
        // F8 can recover an interrupted story; without one, keep the full menu.
        if (page == "home" && inTavern && this.nextDiscovery(true) != null) {
            page = "tavern";
            tavernTown = town.getID();
        }
    }
    this.TavernTown = tavernTown;
    event.m.AutoPage = page;
    if (fromTown) {
        // Native canFireEvent rejects every menu stack, including towns. Use the
        // town event path for its visible UI; each action keeps its own checks.
        try {
            ::World.Events.m.ActiveEvent = event;
            ::World.Events.m.IsEventShown = true;
            event.fire();
            state.showEventScreenFromTown(event);
            return true;
        } catch (error) {
            event.clear();
            ::World.Events.m.ActiveEvent = null;
            ::World.Events.m.IsEventShown = false;
            ::logError("[AfeixExpedition] Could not open the town ledger: " + error);
            return false;
        }
    }
    // canFireEvent also rejects nearby hostile parties, even for a manually
    // opened reference screen. The guards above cover loading, combat, menus
    // and active events; mutating actions separately enforce canManage().
    // Keep native fire/show/close handling, but allow reading near enemies.
    return ::World.Events.fire("event.afeix_ledger", false);
};
