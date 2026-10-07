local A = ::AfeixExpedition;
A.endingSnapshot <- function(retired) {
    local stats = ::World.Statistics.getFlags();
    local snapshot = { retired = retired, days = ::World.getTime().Days,
        renown = ::World.Assets.getBusinessReputation(), crises = stats.get("GreaterEvilsDefeated"),
        company = ::World.Assets.getName(), states = {}, living = 0, rootCount = 0,
        route = this.route(), bicycle = this.get("bicycle_state"), bicycleChoice = this.get("bicycle_choice", -1) };
    if (snapshot.crises == null) snapshot.crises = 0;
    foreach (bro in this.roster()) if (bro.isAlive()) snapshot.living++;
    foreach (key in this.CharacterOrder) {
        local bro = this.findCharacter(key);
        snapshot.states[key] <- this.get("dead_" + key, false) ? "dead"
            : (bro != null && bro.isAlive() ? "alive"
            : (this.get("departed_" + key, false) || this.get("ever_" + key, false) ? "departed" : "unknown"));
    }
    foreach (id in this.RootOrder) if (this.get("root_done_" + id, false)) snapshot.rootCount++;
    return snapshot;
};
A.companyEndingKey <- function(s) {
    if (!s.retired || s.living == 0) {
        if (s.days < 30 && s.renown < 1000 && s.crises == 0) return "early_loss";
        return s.crises > 0 || s.renown >= 3000 ? "fallen_legend" : "last_watch";
    }
    if (s.renown >= 6000 && s.crises >= 2) return "legacy";
    if (s.crises >= 1) return "after_crisis";
    if (s.renown >= 3000) return "renowned";
    return s.renown >= 1000 ? "ordinary" : "humble";
};
A.companyEndingText <- function(s) {
    local data = this.Endings, ending = data.company[this.companyEndingKey(s)];
    local retired = s.retired && s.living > 0;
    local text = "[color=#bcad8c]" + ending.title + "[/color]\n\n" + s.company + " · 第" + s.days + "天\n\n" + ending.text;
    if (s.states.afei == "dead") text += "\n\n" + data.callbacks.afei_dead;
    else if (retired && s.states.afei == "alive" && s.route in data.callbacks)
        text += "\n\n" + data.callbacks[s.route];
    else if (retired && s.states.afei == "departed") text += "\n\n" + data.callbacks.afei_absent;
    if (s.rootCount > 0) text += "\n\n" + data.callbacks.roots;
    if (retired) {
        if (s.bicycle == 1 && s.states.bottle == "alive") text += "\n\n" + data.callbacks.bottle_kept;
        if (s.bicycle == 4) text += "\n\n" + data.callbacks[s.bicycleChoice == 0 ? "bicycle_kept" : "bicycle_released"];
        else if (s.bicycle == 2 || s.bicycle == 3) text += "\n\n" + data.callbacks.bicycle_unfinished;
    }
    foreach (key in this.CharacterOrder) {
        local state = s.states[key];
        if (state == "unknown") continue;
        local story = "";
        if (state == "dead") story = data.members[key].memorial;
        else if (state == "departed") story = key == "bottle" && s.bicycle >= 2
            ? data.callbacks.bottle_departed
            : "这位伙伴在最后一页之前就离开了队伍。名册里记着一起走过的那一程，之后去了哪儿，没人知道确切的消息。";
        else if (!retired) story = "黑旗最后一次点名时，这位伙伴仍然生还。远征团散了，人还活着，往后去了哪儿，暂时没人说得准。";
        else story = data.members[key][s.renown >= 3000 || s.crises > 0 ? "good" : "lean"];
        text += "\n\n[color=#bcad8c]" + this.Characters[key].name + "[/color]\n" + story;
    }
    return text + "\n\n";
};
