// Talent changes affect vanilla's pre-rolled level-up queue, not earned stats.
local A = ::AfeixExpedition;
A.TalentRevision <- 2;
A.RebalancedTalentKeys <- ["bottle", "yuchujiu", "xiaoyubeike", "yaoyaoya", "damou", "laocai", "dae", "keke", "xiaogui"];
// Shared across all promotions: retraining cannot accumulate stars or reroll.
A.PromotionTalents <- { MeleeSkill = 3, MeleeDefense = 3, Bravery = 3 };

A.captureTalentState <- function(bro) {
    local queues = [];
    foreach (row in bro.m.Attributes) queues.push(clone row);
    return { talents = clone bro.getTalents(), attributes = queues };
};
A.restoreTalentState <- function(bro, saved) {
    local talents = bro.getTalents();
    talents.resize(saved.talents.len());
    foreach (i, value in saved.talents) talents[i] = value;
    bro.m.Attributes = saved.attributes;
};

A.applyTalentProfile <- function(bro, profile) {
    local target = array(::Const.Attributes.COUNT, 0), old = bro.getTalents(), changed = [];
    foreach (field, stars in profile) {
        if (typeof stars != "integer" || stars < 0 || stars > 3) throw "Invalid talent stars";
        target[::Const.Attributes[field == "Stamina" ? "Fatigue" : field]] = stars;
    }
    foreach (i, value in target) if (i >= old.len() || old[i] != value) changed.push(i);
    if (changed.len() == 0) return false;
    local saved = this.captureTalentState(bro), next = [];
    foreach (row in saved.attributes) next.push(clone row);
    // Pending level-ups are included. Veteran +1 entries must never gain stars.
    local normalLeft = ::Const.XP.MaxLevelWithPerkpoints - bro.getLevel() + bro.m.LevelUps;
    foreach (i in changed) {
        if (i >= next.len()) continue;
        local stars = target[i], range = ::Const.AttributesLevelUp[i];
        for (local j = 0; j < next[i].len() && j < normalLeft; j++)
            next[i][j] = ::Math.rand(range.Min + (stars == 3 ? 2 : stars), range.Max + (stars == 3 ? 1 : 0));
    }
    // Stage every roll before committing so a failure cannot half-migrate an actor.
    try {
        old.resize(target.len());
        foreach (i, value in target) old[i] = value;
        bro.m.Attributes = next;
        if ("setDirty" in bro) bro.setDirty(true);
    } catch (error) {
        this.restoreTalentState(bro, saved);
        throw error;
    }
    return true;
};

A.syncRosterTalents <- function(bro) {
    if (!this.isOrigin() || bro == null) return;
    local key = this.characterId(bro);
    if (this.RebalancedTalentKeys.find(key) == null) return;
    local flags = bro.getFlags();
    if (flags.has("afeix_talent_revision") && flags.get("afeix_talent_revision") >= this.TalentRevision) return;
    this.applyTalentProfile(bro, this.Characters[key].stars);
    flags.set("afeix_talent_revision", this.TalentRevision);
};
