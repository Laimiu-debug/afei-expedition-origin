// Hidden eligibility is evaluated from play history, never printed in the ledger.
local A = ::AfeixExpedition;
A.EncounterRequirements <- {
    bottle = { battles = 1 }, shuaizi = { towns = 2 },
    lili = { jobs = 1, towns = 2 }, xiaoyueya = { towns = 3 },
    yuchujiu = { battles = 3 }, xiaoyubeike = { level = 2, towns = 2 },
    wangduidui = { jobs = 2, types = 2 }, laocai = { battles = 4, level = 3 },
    yanzi = { jobs = 2, towns = 3 },
    tiantong = { towns = 4 }, xiaoning = { towns = 4, level = 2 },
    xiaopangxu = { battles = 3, level = 3 }, dae = { jobs = 3, types = 2 },
    manyuemei = { battles = 5, level = 3 }, xiaohani = { towns = 4, companions = 5 },
    keke = { jobs = 3, companions = 5 }, yuxiang = { battles = 6, towns = 3 },
    tongzhu = { jobs = 4, types = 3 }, meiya = { towns = 5, companions = 6 },
    wanshe = { level = 4, battles = 5 }, tutu = { jobs = 4, level = 4 },
    songnuanyang = { towns = 5, battles = 4 }, xiaogui = { battles = 7, companions = 6 },
    naigai = { jobs = 5, types = 3 }, xiaojie = { battles = 8, level = 5 },
    bula = { towns = 6, companions = 7 }, suwa = { jobs = 5, battles = 6 },
    qianhan = { level = 5, jobs = 4 }, wangdazhi = { battles = 9, companions = 7 },
    yaoyaoya = { towns = 7, types = 3 }, yangmiemie = { jobs = 6, level = 5 },
};
A.TavernTown <- 0;
A.isCharacterKnown <- function(key) {
    return key in this.Characters && (this.findCharacter(key) != null || this.get("met_" + key, false)
        || this.get("encounter_done_" + key, false) || this.get("ever_" + key, false)
        || this.get("dead_" + key, false) || this.get("departed_" + key, false));
};
A.knownMembers <- function() {
    local result = [];
    foreach (key in this.CharacterOrder) if (this.isCharacterKnown(key)) result.push(key);
    return result;
};
A.discoveryMetrics <- function() {
    // High-water marks survive loss of a veteran; discovery must not become impossible.
    local battles = this.get("journey_battles"), level = this.get("journey_level", 1), companions = 0;
    foreach (bro in this.roster()) {
        battles = ::Math.max(battles, this.personalBattles(bro));
        level = ::Math.max(level, bro.getLevel());
    }
    foreach (key in this.CharacterOrder) if (this.get("ever_" + key, false) || this.findCharacter(key) != null) companions++;
    this.set("journey_battles", battles); this.set("journey_level", level);
    return { jobs = this.get("qualified_contracts"), types = this.get("qualified_types"), battles = battles, level = level,
        towns = this.get("recruit_towns"), companions = companions };
};
A.canMeetCharacter <- function(key, metrics = null) {
    if (!this.isOrigin() || !(key in this.EncounterRequirements) || this.isCharacterKnown(key)) return false;
    if (metrics == null) metrics = this.discoveryMetrics();
    foreach (field, threshold in this.EncounterRequirements[key]) if (metrics[field] < threshold) return false;
    return true;
};
A.isAtTavern <- function() {
    if (!this.isOrigin() || this.TavernTown == 0 || !this.canManage()) return false;
    local town = this.currentTown();
    if (town == null || town.getID() != this.TavernTown) return false;
    local screen = ::World.State.m.WorldTownScreen;
    return screen != null && screen.m.LastActiveModule == screen.getTavernDialogModule();
};
A.visitTavern <- function(town) {
    if (town == null || !town.isAlive() || !town.isAlliedWithPlayer()) return false;
    local id = town.getID();
    if (!this.get("visited_tavern_" + id, false)) {
        this.set("visited_tavern_" + id, true);
        this.set("tavern_towns", this.get("tavern_towns") + 1);
    }
    return true;
};
A.prepareTavernMeeting <- function() {
    if (!this.isAtTavern()) return "home";
    local town = this.currentTown();
    this.visitTavern(town);
    // New people appear in the native hiring screen; taverns retain only stories
    // and legacy conversations, never bypass the global recruitment pacing.
    local scene = this.nextDiscovery(true);
    if (scene != null && this.revealDiscovery(scene)) return scene;
    return "tavern";
};
A.growthKnown <- function(key) { return this.get("growth_seen_" + key, false) || this.get("growth_done_" + key, false); };
A.promotionKnown <- function() { return this.get("promotion_discovered", false) || this.route() != "normal"; };
A.feidieKnown <- function() { return this.get("feidie_discovered", false) || this.get("promotion_seen_feidie", false); };
A.canDiscoverFeidie <- function() {
    local bro = this.findCharacter("afei");
    return this.storyAlive(bro) && bro.getLevel() >= 9 && this.personalBattles(bro) >= 12
        && this.get("growth_done_afei", false) && this.rootsUnlocked();
};
A.bicycleKnown <- function() { return this.get("bicycle_discovered", false) || this.get("bicycle_state") > 0; };
A.rootKnown <- function(id) { return this.get("root_triggered_" + id, false) || this.get("root_done_" + id, false); };
A.knownRoots <- function() {
    local ids = []; foreach (id in this.RootOrder) if (this.rootKnown(id)) ids.push(id); return ids;
};
A.knownGrowth <- function() {
    local keys = []; foreach (key in this.CharacterOrder) if (this.isCharacterKnown(key) && this.growthKnown(key)) keys.push(key); return keys;
};
A.hasStoryRecords <- function() {
    return this.promotionKnown() || this.feidieKnown() || this.bicycleKnown() || this.knownRoots().len() > 0 || this.knownGrowth().len() > 0;
};
A.nextDiscovery <- function(inTavern = false) {
    if (!this.isOrigin() || !this.canManage()) return null;
    foreach (key in this.CharacterOrder)
        if (this.growthStatus(key) == "ready" && !this.growthKnown(key)) return "member_growth:" + key;
    local afei = this.findCharacter("afei");
    if (this.storyAlive(afei) && !this.promotionKnown() && afei.getLevel() >= 7
        && this.personalBattles(afei) >= 6 && this.get("growth_done_afei", false)) return "promotion";
    foreach (id in this.RootOrder) {
        if (this.rootStatus(id) != "ready" || this.rootKnown(id)) continue;
        if (this.RootStories[id].member != "" || inTavern) return "roots:" + id;
    }
    if (this.canDiscoverFeidie() && !this.feidieKnown()) return "promotion:feidie";
    if (this.bicycleStatus() == "ready" && !this.bicycleKnown() && this.currentTown() != null) return "bicycle";
    return null;
};
A.revealDiscovery <- function(page) {
    if (!this.isOrigin() || !this.canManage()) return false;
    local parts = split(page, ":");
    if (parts[0] == "member_growth" && parts.len() > 1 && this.growthStatus(parts[1]) == "ready") {
        this.set("growth_seen_" + parts[1], true); return true;
    }
    if (parts[0] == "roots" && parts.len() > 1) return this.triggerRoot(parts[1]).ok;
    if (page == "promotion:feidie" && this.canDiscoverFeidie()) { this.set("feidie_discovered", true); return true; }
    if (page == "promotion") {
        local bro = this.findCharacter("afei");
        if (this.storyAlive(bro) && bro.getLevel() >= 7 && this.personalBattles(bro) >= 6 && this.get("growth_done_afei", false)) {
            this.set("promotion_discovered", true); return true;
        }
    }
    if (page == "bicycle" && this.bicycleStatus() == "ready" && this.currentTown() != null) {
        this.set("bicycle_discovered", true); return true;
    }
    return false;
};
