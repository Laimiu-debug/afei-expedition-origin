// Three regular offers plus independent, persistent random visitor offers.
local A = ::AfeixExpedition;
A.RecruitIntervalDays <- 1;
A.RecruitOfferCount <- 3;
A.RecruitOfferDays <- 4;
A.RecruitReturnOfferDays <- 2;
A.RecruitReturnPriorityDays <- 6;
A.RecruitNewBurst <- 2;
A.RecruitRegularOfferCount <- 3;
A.RandomRecruitKeys <- [];
A.RandomRecruits <- {};
A.configureRecruitment <- function(rules) {
    this.RecruitRegularOfferCount = rules.regular_slots;
    this.RecruitIntervalDays = rules.hire_cooldown_days;
    this.RecruitOfferDays = rules.regular_offer_days;
    this.RecruitReturnOfferDays = rules.return_offer_days;
    this.RecruitReturnPriorityDays = rules.return_priority_days;
    this.RecruitNewBurst = rules.max_new_before_return;
    this.RandomRecruitKeys = rules.random_order;
    this.RandomRecruits = rules.random_visitors;
    this.RecruitOfferCount = this.RecruitRegularOfferCount + this.RandomRecruitKeys.len();
};
A.isRandomRecruit <- function(key) { return key in this.RandomRecruits; };
// Old saves can keep invitations/discounts, but F8 and taverns never hire now.
A.recruit = function(key) { return this.result(false, "请在城镇招募界面雇佣伙伴。"); };
A.resolveEncounter = function(key, choice) { return this.result(false, "请在城镇招募界面与伙伴见面。"); };
A.createHireCandidate <- function(key, roster) {
    if (roster == null) return null;
    try { return this.makeCharacter(key, 255, roster); }
    catch (error) { ::logError("[AfeixExpedition] Hiring candidate " + key + ": " + error); }
    return null;
};
A.recruitGone <- function(key) {
    return !(key in this.Characters) || this.findCharacter(key) != null || this.get("ever_" + key, false)
        || this.get("dead_" + key, false) || this.get("departed_" + key, false);
};
A.getRecruitSlot <- function(index) {
    local prefix = "recruit_slot_" + index + "_";
    return { key = this.get(prefix + "key", ""), town = this.get(prefix + "town"),
        expires = this.get(prefix + "until"), ready = this.get(prefix + "next") };
};
A.saveRecruitSlot <- function(index, slot) {
    local prefix = "recruit_slot_" + index + "_";
    this.set(prefix + "key", slot.key); this.set(prefix + "town", slot.town);
    this.set(prefix + "until", slot.expires); this.set(prefix + "next", slot.ready);
};
A.migrateRecruitSlots <- function() {
    if (this.get("recruit_slots_v1", false)) return;
    // Preserve the original actor and offer lifetime. Convert the old three-day
    // hire cooldown to one day, measured from the original hire, not this load.
    local oldReady = this.get("recruit_next_time");
    local slot = { key = this.get("recruit_offer_key", ""), town = this.get("recruit_offer_town"),
        expires = this.get("recruit_offer_until"),
        ready = oldReady > 0 ? ::Math.max(0, oldReady - this.daysInSeconds(2)) : 0 };
    this.saveRecruitSlot(0, slot);
    this.set("recruit_offer_key", ""); this.set("recruit_offer_town", 0);
    this.set("recruit_offer_until", 0); this.set("recruit_next_time", 0);
    this.set("recruit_slots_v1", true);
};
A.recruitOfferSlot <- function(key) {
    if (key == "") return -1;
    for (local i = 0; i < this.RecruitOfferCount; i++)
        if (this.getRecruitSlot(i).key == key) return i;
    // Ledger reads can precede the completed world-load migration.
    return !this.get("recruit_slots_v1", false) && this.get("recruit_offer_key", "") == key ? 0 : -1;
};
A.visitRecruitTown <- function(town) {
    if (!this.isOrigin() || town == null || !town.isAlive() || town.isMilitary() || !town.isAlliedWithPlayer()) return false;
    if (!this.get("visited_recruit_town_" + town.getID(), false)) {
        this.set("visited_recruit_town_" + town.getID(), true);
        this.set("recruit_towns", this.get("recruit_towns") + 1);
    }
    return true;
};
A.queueRecruit <- function(key, queuedAt = null) {
    if (!(key in this.Characters) || this.Characters[key].isCaptain) return;
    local order = this.get("recruit_queue_serial") + 1;
    this.set("recruit_queue_serial", order);
    this.set("recruit_order_" + key, order);
    this.set("recruit_queued_at_" + key, queuedAt == null ? this.worldNow() : queuedAt);
};
A.updateRecruitEligibility <- function() {
    if (!this.isOrigin()) return;
    local metrics = this.discoveryMetrics(), pending = [];
    foreach (key in this.CharacterOrder) {
        if (this.isRandomRecruit(key)) {
            if (!this.recruitGone(key) && (this.isCharacterKnown(key) || this.get("recruit_order_" + key) > 0
                || this.canMeetCharacter(key, metrics))) this.set("random_recruit_eligible_" + key, true);
            continue;
        }
        if (this.Characters[key].isCaptain || this.recruitGone(key)) continue;
        if (this.get("recruit_order_" + key) > 0) {
            // Old scalar queues have no waiting timestamp. Initialize once;
            // repeated visits and loading must not reset a pending return's age.
            if (this.get("recruit_queued_at_" + key, -1) < 0) this.set("recruit_queued_at_" + key, this.worldNow());
            continue;
        }
        // Existing invitations survive the change of entry point.
        if (this.isCharacterKnown(key) || this.canMeetCharacter(key, metrics)) {
            local days = key in this.EncounterRequirements && "days" in this.EncounterRequirements[key] ? this.EncounterRequirements[key].days : 1;
            pending.push({ key = key, day = days, index = pending.len() });
        }
    }
    // A late first town visit can unlock many people together. Use their planned
    // dates, with the roster order as tie-breaker; preserve existing queue orders.
    pending.sort(function(a, b) { return a.day == b.day ? a.index - b.index : a.day - b.day; });
    foreach (entry in pending) this.queueRecruit(entry.key);
};
A.nextQueuedRecruit <- function(excluded = null) {
    local fresh = null, returning = null, overdue = null;
    local freshOrder = 2147483647, returnOrder = 2147483647, overdueOrder = 2147483647;
    foreach (key in this.CharacterOrder) {
        local value = this.get("recruit_order_" + key);
        if (this.isRandomRecruit(key) || value <= 0 || this.recruitGone(key) || this.recruitOfferSlot(key) >= 0
            || (excluded != null && key in excluded)) continue;
        if (!this.isCharacterKnown(key)) {
            if (value < freshOrder) { fresh = key; freshOrder = value; }
        } else {
            if (value < returnOrder) { returning = key; returnOrder = value; }
            local queuedAt = this.get("recruit_queued_at_" + key, this.worldNow());
            if (this.worldNow() - queuedAt >= this.daysInSeconds(this.RecruitReturnPriorityDays) && value < overdueOrder) {
                overdue = key; overdueOrder = value;
            }
        }
    }
    // New faces lead, but an aged return gets a turn after two successful new
    // introductions. Only actual displays count, never reads or failed builds.
    if (fresh != null && (overdue == null || this.get("recruit_new_streak") < this.RecruitNewBurst)) return fresh;
    return overdue != null ? overdue : returning;
};
A.randomRecruitReady <- function(key) {
    if (this.recruitGone(key) || this.recruitOfferSlot(key) >= 0 || !this.get("random_recruit_eligible_" + key, false)) return false;
    local day = ::World.getTime().Days.tointeger(), prefix = "random_recruit_" + key + "_", rules = this.RandomRecruits[key];
    if (this.get(prefix + "day", -1) != day) {
        local misses = this.get(prefix + "misses");
        local success = misses >= rules.pity_attempts - 1 || ::Math.rand(1, 100) <= rules.chance;
        // Save before actor construction: retries and town changes reuse today's outcome.
        this.set(prefix + "day", day); this.set(prefix + "success", success);
        if (!success) this.set(prefix + "misses", misses + 1);
    }
    return this.get(prefix + "success", false);
};
A.candidateInRoster <- function(roster, key) {
    if (roster == null) return null;
    foreach (bro in roster.getAll()) if (this.characterId(bro) == key) return bro;
    return null;
};
A.restoreHireCandidate <- function() {
    this.migrateRecruitSlots();
    for (local i = 0; i < this.RecruitOfferCount; i++) {
        local slot = this.getRecruitSlot(i);
        if (slot.key == "" || slot.town == 0) continue;
        local bro = this.candidateInRoster(::World.getRoster(slot.town), slot.key);
        if (bro != null) this.restoreCharacterMetadata(bro);
    }
};
A.ensureTownRecruit <- function(town) {
    if (!this.visitRecruitTown(town)) return;
    this.migrateRecruitSlots();
    this.updateRecruitEligibility();
    local now = this.worldNow();
    local targetRoster = ::World.getRoster(town.getID());
    // Retire expired offers before filling vacancies. Visitors roll again instead
    // of joining the regular queue; legacy visitors keep their current slot until expiry.
    for (local i = 0; i < this.RecruitOfferCount; i++) {
        local slot = this.getRecruitSlot(i);
        if (slot.key == "" || (!this.recruitGone(slot.key) && now < slot.expires)) continue;
        local oldRoster = slot.town == 0 ? null : ::World.getRoster(slot.town);
        local bro = this.candidateInRoster(oldRoster, slot.key);
        if (bro != null) oldRoster.remove(bro);
        if (!this.recruitGone(slot.key) && !this.isRandomRecruit(slot.key)) this.queueRecruit(slot.key, slot.expires);
        slot.key = ""; slot.town = 0; slot.expires = 0;
        this.saveRecruitSlot(i, slot);
    }
    local failed = {};
    for (local i = 0; i < this.RecruitOfferCount; i++) {
        local slot = this.getRecruitSlot(i), bro = null;
        if (slot.key == "") {
            if (now < slot.ready) continue;
            local randomSlot = i >= this.RecruitRegularOfferCount;
            local key = randomSlot ? this.RandomRecruitKeys[i - this.RecruitRegularOfferCount] : this.nextQueuedRecruit(failed);
            if (key == null) continue;
            if (randomSlot && !this.randomRecruitReady(key)) continue;
            bro = this.createHireCandidate(key, targetRoster);
            if (!randomSlot) {
                // One malformed candidate must not block every ordinary slot.
                // Keep its place and try each other queued identity once per query.
                while (bro == null) {
                    failed[key] <- true;
                    key = this.nextQueuedRecruit(failed);
                    if (key == null) break;
                    bro = this.createHireCandidate(key, targetRoster);
                }
            }
            if (bro == null) continue;
            local duration = randomSlot ? this.RandomRecruits[key].offer_days
                : (this.get("native_recruit_" + key, false) ? this.RecruitReturnOfferDays : this.RecruitOfferDays);
            slot.key = key; slot.expires = now + this.daysInSeconds(duration);
            if (randomSlot) this.set("random_recruit_" + key + "_misses", 0);
            else this.set("recruit_new_streak", this.isCharacterKnown(key) ? 0 : ::Math.min(this.RecruitNewBurst, this.get("recruit_new_streak") + 1));
        } else {
            local oldRoster = slot.town == 0 ? null : ::World.getRoster(slot.town);
            bro = this.candidateInRoster(oldRoster, slot.key);
            if (bro == null) {
                // A destroyed town can remove its roster; entitlement and timer survive.
                bro = this.createHireCandidate(slot.key, targetRoster);
                if (bro == null) continue;
            } else if (slot.town != town.getID()) {
                targetRoster.add(bro); oldRoster.remove(bro);
            }
        }
        slot.town = town.getID(); this.saveRecruitSlot(i, slot);
        this.set("native_recruit_" + slot.key, true);
        this.set("met_" + slot.key, true);
        this.set("met_town_" + slot.key, town.getNameOnly());
        this.restoreCharacterMetadata(bro);
    }
};
A.onNativeHired <- function(bro) {
    if (!this.isOrigin()) return;
    local key = this.characterId(bro);
    if (key == "" || this.findCharacter(key) != bro) return;
    this.set("ever_" + key, true); this.set("met_" + key, true);
    bro.getFlags().set("afeix_candidate", false);
    this.migrateRecruitSlots();
    local index = this.recruitOfferSlot(key);
    if (index >= 0) {
        this.saveRecruitSlot(index, { key = "", town = 0, expires = 0,
            ready = this.worldNow() + this.daysInSeconds(this.RecruitIntervalDays) });
    }
    this.enforceFormation();
    this.updateRecruitEligibility();
    if ("ensureStoryItems" in this) this.ensureStoryItems();
};
A.withProtectedCandidates <- function(town, callback, force) {
    if (!this.isOrigin()) return callback.bindenv(town)(force);
    local roster = ::World.getRoster(town.getID()), temporary = ::World.getTemporaryRoster(), held = [];
    foreach (bro in roster.getAll())
        if (bro.getFlags().has("afeix_candidate") && bro.getFlags().get("afeix_candidate")) held.push(bro);
    // The engine owns actor lifetime through rosters. Transfer before removal,
    // then put back the same objects even when native roster refresh throws.
    foreach (bro in held) { temporary.add(bro); roster.remove(bro); }
    local result = null, failure = null;
    try { result = callback.bindenv(town)(force); } catch (error) { failure = error; }
    foreach (bro in held) { roster.add(bro); temporary.remove(bro); }
    if (failure != null) throw failure;
    return result;
};
