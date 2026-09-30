local A = ::AfeixExpedition;
// User-confirmed content groups; grouping does not unlock recruits or change their conditions.
A.Chapters <- [
    { id = 1, name = "刀一黑队", required = 1 },
    { id = 2, name = "刀二蓝队", required = 3 },
    { id = 3, name = "0.5DFW猪团", required = 6 },
    { id = 4, name = "旅途来客", required = 9 }
];
A.completedDeliveries <- function() {
    // v0.1 stored only the single finished delivery, not a total. Credit it once.
    return this.get("deliveries_completed", this.get("delivery_state") == 2 ? 1 : 0);
};
A.migrateProgress <- function() {
    if (!this.isOrigin()) return;
    this.set("deliveries_completed", this.completedDeliveries());
    // Retire old unpaid ledger letters without a penalty. Completed work survives.
    if (!this.get("native_letters_migrated", false)) {
        if (this.get("delivery_state") == 1) {
            this.set("delivery_state", 3);
            this.set("legacy_letter_retired", true);
        }
        this.set("native_letters_migrated", true);
    }
    if (!this.get("letter_supply_migrated", false) && "Contracts" in ::World && ::World.Contracts != null) {
        // Old versions left one letter in every visited town. Retire only those
        // unaccepted mod offers; keep the active objective and all vanilla jobs.
        local active = ::World.Contracts.getActiveContract();
        foreach (c in clone ::World.Contracts.getOpenContracts())
            if (c != active && c.getType() == "contract.afeix_letter") ::World.Contracts.removeContract(c);
        if (active != null && active.getType() == "contract.afeix_letter"
            && !active.m.Flags.get("SupplyCharged")) {
            local destination = active.destination();
            if (active.getHome() != null && destination != null) this.consumeLetterSupply(active.getHome(), destination);
            active.m.Flags.set("SupplyCharged", true);
        }
        this.set("letter_supply_migrated", true);
    }
    this.set("schema", this.Schema);
};
A.progressCount <- function() { return this.completedDeliveries() + this.get("paid_contracts"); };
A.isRecruitUnlocked <- function(key) {
    return key in this.Characters && !this.Characters[key].isCaptain
        && this.isCharacterKnown(key) && this.get("encounter_done_" + key, false);
};
A.LetterCooldownDays <- 2;
A.LetterTownCooldownDays <- 5;
A.LetterPairCooldownDays <- 7;
A.worldNow <- function() { return ::Time.getVirtualTimeF(); };
A.daysInSeconds <- function(days) { return days * ::World.getTime().SecondsPerDay; };
A.letterPairKey <- function(first, second) {
    return first < second ? first + "_" + second : second + "_" + first;
};
A.letterSupplyReady <- function(home, destination = null) {
    local now = this.worldNow();
    if (now < this.get("letter_next_time") || now < this.get("letter_town_until_" + home.getID())) return false;
    // No amount of waiting or back-and-forth travel replenishes the same supply.
    if (this.get("qualified_contracts") <= this.get("letter_last_work", -1)) return false;
    return destination == null || now >= this.get("letter_pair_until_" + this.letterPairKey(home.getID(), destination.getID()));
};
A.consumeLetterSupply <- function(home, destination) {
    local now = this.worldNow();
    this.set("letter_last_work", this.get("qualified_contracts"));
    this.set("letter_next_time", now + this.daysInSeconds(this.LetterCooldownDays));
    this.set("letter_town_until_" + home.getID(), now + this.daysInSeconds(this.LetterTownCooldownDays));
    this.set("letter_pair_until_" + this.letterPairKey(home.getID(), destination.getID()), now + this.daysInSeconds(this.LetterPairCooldownDays));
};
A.findDeliveryRoute <- function(home) {
    local best = null, shortest = 999999;
    local settings = ::World.getNavigator().createSettings();
    settings.ActionPointCosts = ::Const.World.TerrainTypeNavCost;
    settings.RoadMult = 0.2;
    settings.RoadOnly = true;
    foreach (town in ::World.EntityManager.getSettlements()) {
        if (!town.isAlive() || town.getID() == home.getID() || town.isMilitary() || !town.isAlliedWithPlayer()) continue;
        if (!home.isConnectedToByRoads(town) || !this.letterSupplyReady(home, town)) continue;
        local path = ::World.getNavigator().findPath(home.getTile(), town.getTile(), settings, 0);
        if (path.isEmpty()) continue;
        local distance = path.getSize();
        // Real road length only: never fall back to a straight line across water.
        if (distance <= 0) continue;
        if (distance < shortest) { best = town; shortest = distance; }
    }
    return best == null ? null : { town = best, tiles = shortest };
};
A.findDeliveryTown <- function(home) {
    local route = this.findDeliveryRoute(home);
    return route == null ? null : route.town;
};
A.registerTownLetter <- function(faction, contract) {
    // Native addContract resets ordinary contract supply. Our extra letter
    // must not postpone the employer's normal jobs.
    local previous = faction.m.LastContractTime, result = null, failure = null;
    try { result = ::World.Contracts.addContract(contract); } catch (error) { failure = error; }
    faction.m.LastContractTime = previous;
    if (failure != null) throw failure;
    return result;
};
A.withNativeContractSupply <- function(faction, callback) {
    if (!this.isOrigin()) return callback.bindenv(faction)();
    local original = faction.m.Contracts, nativeContracts = [];
    foreach (contract in original)
        if (contract.getType() != "contract.afeix_letter") nativeContracts.push(contract);
    // Retain registration for display, payment and saving. Only the native
    // readiness check excludes our supplementary letter from the offer limit.
    faction.m.Contracts = nativeContracts;
    local result = null, failure = null;
    try { result = callback.bindenv(faction)(); } catch (error) { failure = error; }
    faction.m.Contracts = original;
    if (failure != null) throw failure;
    return result;
};
A.ensureTownLetter <- function(town) {
    if (!this.isOrigin() || town == null || !town.isAlive() || town.isMilitary() || !town.isAlliedWithPlayer()) return;
    this.migrateProgress();
    if (!this.letterSupplyReady(town)) return;
    // Respect the native one-contract-at-a-time rule and never replace a job.
    if (::World.Contracts.getActiveContract() != null) return;
    foreach (c in ::World.Contracts.getOpenContracts())
        if (c.getType() == "contract.afeix_letter" && c.isValid() && !c.isTimedOut()) return;
    local faction = town.getFactionOfType(::Const.FactionType.Settlement);
    if (faction == null) faction = town.getFactionOfType(::Const.FactionType.OrientalCityState);
    if (faction == null) return;
    local employer = faction.getRandomCharacter();
    if (employer == null) return;
    local route = this.findDeliveryRoute(town);
    if (route == null) return;
    local c = ::new("scripts/contracts/contracts/afeix_letter_contract");
    c.setFaction(faction.getID());
    c.setEmployerID(employer.getID());
    c.setHome(town);
    c.setOrigin(town);
    c.setup(route.town, route.tiles);
    this.registerTownLetter(faction, c);
};
// The contract adapter supplies a successful terminal state and observed money received.
// Contract IDs are native persistent IDs; an old completion cannot unlock or count twice.
A.recordContract <- function(id, cancelled, payment) {
    if (!this.isOrigin() || cancelled || payment <= 0 || this.get("contract_done_" + id, false)) return false;
    this.set("contract_done_" + id, true);
    local kind = this.get("contract_type_" + id, "");
    if (kind == "contract.afeix_letter" || kind == "contract.deliver_item") {
        this.set("courier_completed", this.get("courier_completed") + 1);
        return true;
    }
    this.set("paid_contracts", this.get("paid_contracts") + 1);
    this.set("qualified_contracts", this.get("qualified_contracts") + 1);
    // Old records without a type remain historical progress, never invented variety.
    if (kind != "" && !this.get("qualified_type_" + kind, false)) {
        this.set("qualified_type_" + kind, true);
        this.set("qualified_types", this.get("qualified_types") + 1);
    }
    return true;
};
A.questSummary <- function() {
    local text = "委托在城镇契约栏领取。接下后，世界地图的任务栏会显示目标；送信抵达收信城镇后即可交付，不必打开名册。";
    if ("Contracts" in ::World && ::World.Contracts != null) {
        local active = ::World.Contracts.getActiveContract();
        if (active != null) text += "\n\n正在办理：" + active.getName() + "。";
    }
    if (this.get("legacy_letter_retired", false)) text += "\n\n旧版尚未交付的送信委托已免罚撤销，请在城镇重新接取委托。已完成的记录保留。";
    return text + "\n\n已完成非送信契约：" + this.get("qualified_contracts") + " 份；种类 " + this.get("qualified_types") + " 种。送信不增加人物招募所需的履约次数。";
};
