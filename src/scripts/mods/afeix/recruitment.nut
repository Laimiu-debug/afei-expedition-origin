// Persistent FIFO eligibility, one featured recruit at a time in vanilla hiring.
local A = ::AfeixExpedition;
A.RecruitIntervalDays <- 3;
A.RecruitOfferDays <- 4;
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
    return this.findCharacter(key) != null || this.get("ever_" + key, false)
        || this.get("dead_" + key, false) || this.get("departed_" + key, false);
};
A.visitRecruitTown <- function(town) {
    if (!this.isOrigin() || town == null || !town.isAlive() || town.isMilitary() || !town.isAlliedWithPlayer()) return false;
    if (!this.get("visited_recruit_town_" + town.getID(), false)) {
        this.set("visited_recruit_town_" + town.getID(), true);
        this.set("recruit_towns", this.get("recruit_towns") + 1);
    }
    return true;
};
A.queueRecruit <- function(key) {
    local order = this.get("recruit_queue_serial") + 1;
    this.set("recruit_queue_serial", order);
    this.set("recruit_order_" + key, order);
};
A.updateRecruitEligibility <- function() {
    if (!this.isOrigin()) return;
    local metrics = this.discoveryMetrics();
    foreach (key in this.CharacterOrder) {
        if (this.Characters[key].isCaptain || this.recruitGone(key) || this.get("recruit_order_" + key) > 0) continue;
        // Existing invitations survive the change of entry point.
        if (this.isCharacterKnown(key) || this.canMeetCharacter(key, metrics)) this.queueRecruit(key);
    }
};
A.nextQueuedRecruit <- function() {
    local best = null, order = 2147483647;
    foreach (key in this.CharacterOrder) {
        local value = this.get("recruit_order_" + key);
        if (value > 0 && value < order && !this.recruitGone(key)) { best = key; order = value; }
    }
    return best;
};
A.candidateInRoster <- function(roster, key) {
    if (roster == null) return null;
    foreach (bro in roster.getAll()) if (this.characterId(bro) == key) return bro;
    return null;
};
A.restoreHireCandidate <- function() {
    local key = this.get("recruit_offer_key", ""), townID = this.get("recruit_offer_town");
    if (key == "" || townID == 0) return;
    local bro = this.candidateInRoster(::World.getRoster(townID), key);
    if (bro != null) this.restoreCharacterMetadata(bro);
};
A.ensureTownRecruit <- function(town) {
    if (!this.visitRecruitTown(town)) return;
    this.updateRecruitEligibility();
    local now = this.worldNow(), key = this.get("recruit_offer_key", "");
    local oldTownID = this.get("recruit_offer_town"), oldRoster = null, bro = null;
    if (oldTownID != 0) oldRoster = ::World.getRoster(oldTownID);
    if (key != "") bro = this.candidateInRoster(oldRoster, key);
    if (key != "" && (this.recruitGone(key) || now >= this.get("recruit_offer_until"))) {
        if (bro != null) oldRoster.remove(bro);
        if (!this.recruitGone(key)) this.queueRecruit(key); // missed offers go to the back, never vanish
        this.set("recruit_offer_key", ""); this.set("recruit_offer_town", 0);
        key = ""; bro = null;
    }
    local targetRoster = ::World.getRoster(town.getID());
    if (key == "") {
        if (now < this.get("recruit_next_time")) return;
        key = this.nextQueuedRecruit();
        if (key == null) return;
        bro = this.createHireCandidate(key, targetRoster);
        if (bro == null) return; // do not consume the queue/cooldown on failed creation
        this.set("recruit_offer_key", key);
        this.set("recruit_offer_until", now + this.daysInSeconds(this.RecruitOfferDays));
        this.set("recruit_next_time", now + this.daysInSeconds(this.RecruitIntervalDays));
    } else if (bro == null) {
        // A destroyed town can remove its hiring roster. The saved entitlement remains.
        bro = this.createHireCandidate(key, targetRoster);
        if (bro == null) return;
    } else if (oldTownID != town.getID()) {
        targetRoster.add(bro); oldRoster.remove(bro);
    }
    this.set("recruit_offer_town", town.getID());
    this.set("native_recruit_" + key, true);
    this.set("met_" + key, true);
    this.set("met_town_" + key, town.getNameOnly());
    this.restoreCharacterMetadata(bro);
};
A.onNativeHired <- function(bro) {
    if (!this.isOrigin()) return;
    local key = this.characterId(bro);
    if (key == "" || this.findCharacter(key) != bro) return;
    this.set("ever_" + key, true); this.set("met_" + key, true);
    bro.getFlags().set("afeix_candidate", false);
    if (this.get("recruit_offer_key", "") == key) {
        this.set("recruit_offer_key", ""); this.set("recruit_offer_town", 0);
        this.set("recruit_next_time", this.worldNow() + this.daysInSeconds(this.RecruitIntervalDays));
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
