// Isolated tests of the real promotion and skill scripts. The stub preserves
// vanilla's AP-before-onUse ordering, skill inheritance, and serialization calls.
::Const <- { SkillType = { Active = 1, StatusEffect = 2, Trait = 4 }, SkillOrder = { Any = 0 }, Faction = { Player = 1 } };
dofile("tests/gameplay/talent_fixture.nut");
::state <- { origin = true, safe = true, town = true, tactical = false, roots = false, progress = 0, actor = null, flags = {}, refreshed = 0, art = 0, actors = [], failNew = false, failAdd = false, failArt = false };
::logError <- function(text) {};
::World <- { Assets = { money = 0, getMoney = function() { return this.money; }, addMoney = function(value) { this.money += value; } } };
::Tactical <- { isActive = function() { return ::state.tactical; }, Entities = { getInstancesOfFaction = function(faction) { return ::state.actors; } } };
::AfeixExpedition <- {
    get = function(key, fallback = 0) { return key in ::state.flags ? ::state.flags[key] : fallback; },
    set = function(key, value) { ::state.flags[key] <- value; return value; },
    result = function(ok, text) { return { ok = ok, text = text }; },
    isOrigin = function() { return ::state.origin; },
    canManage = function() { return ::state.origin && ::state.safe && !::state.tactical; },
    currentTown = function() { return ::state.town ? {} : null; },
    findCharacter = function(key) { return ::state.actor; },
    characterId = function(actor) { return actor.key; },
    rootsUnlocked = function() { return ::state.roots; },
    progressCount = function() { return ::state.progress; },
    refreshAssets = function() { ::state.refreshed++; },
    syncCharacterArt = function(actor) { ::state.art++; if (::state.failArt) { ::state.failArt = false; throw "appearance failed"; } }
};

::definitions <- {};
::nativeSkill <- {
    m = { ID = "", Name = "", Description = "", Icon = "", IconDisabled = "", IsNew = true, Container = null, IsUsable = true, IsRemovedAfterBattle = false, IsSerialized = true,
        Type = 0, Order = 0, IsActive = false, IsTargeted = false, IsStacking = false, IsAttack = false, IsVisibleTileNeeded = true,
        ActionPointCost = 0, FatigueCost = 0, MinRange = 0, MaxRange = 0, IsGarbage = false },
    getContainer = function() { return this.m.Container; },
    getID = function() { return this.m.ID; },
    getName = function() { return this.m.Name; },
    getDescription = function() { return this.m.Description; },
    getDefaultUtilityTooltip = function() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; },
    isUsable = function() { return this.m.IsUsable && this.getContainer().getActor().able; },
    isAffordable = function() { local a = this.getContainer().getActor(); return a.ap >= this.m.ActionPointCost && a.fatigue + this.m.FatigueCost <= a.fatigueMax; },
    use = function(tile) {
        if (!this.isUsable() || !this.isAffordable()) return false;
        local actor = this.getContainer().getActor();
        actor.ap -= this.m.ActionPointCost;
        actor.fatigue += this.m.FatigueCost;
        return this.onUse(actor, tile);
    },
    removeSelf = function() { this.getContainer().removeAllByID(this.m.ID); },
    onUpdate = function(properties) {},
    onCombatStarted = function() {},
    onCombatFinished = function() { if (this.m.IsRemovedAfterBattle) this.removeSelf(); },
    onSerialize = function(out) { out.writeBool(this.m.IsNew); },
    onDeserialize = function(input) { this.m.IsNew = input.readBool(); }
};
::definitions["scripts/skills/skill"] <- ::nativeSkill;
local trait = clone ::nativeSkill;
trait.m = clone ::nativeSkill.m;
trait.create <- function() { this.m.Type <- ::Const.SkillType.Trait; };
::definitions["scripts/skills/traits/character_trait"] <- trait;
function loadDefinition(path) {
    if (path in ::definitions) return ::definitions[path];
    dofile("src/" + path + ".nut");
    local pieces = split(path, "/"), name = pieces[pieces.len() - 1];
    ::definitions[path] <- getroottable()[name];
    return ::definitions[path];
}
::inherit <- function(path, data) {
    local parent = loadDefinition(path), result = clone parent;
    result.m = clone parent.m;
    foreach (key, value in data) {
        if (key == "m") { foreach (mk, mv in value) result.m[mk] <- mv; }
        else result[key] <- value;
    }
    local pieces = split(path, "/");
    result[pieces[pieces.len() - 1]] <- parent;
    return result;
};
function bindParent(parent, object) {
    local result = {};
    foreach (key, value in parent) if (typeof value == "function") result[key] <- value.bindenv(object);
    return result;
}
getroottable()["new"] <- function(path) {
    if (::state.failNew) { ::state.failNew = false; throw "construction failed"; }
    local definition = loadDefinition(path), object = clone definition;
    object.setdelegate(getroottable());
    object.m = clone definition.m;
    foreach (key, value in definition) if (typeof value == "table" && key != "m") object[key] = bindParent(value, object);
    object.create();
    return object;
};
function makeActor(key = "afei", faction = 1, distance = 0) {
    local actor = {
        key = key, alive = true, faction = faction, controlled = true, placed = true,
        level = 1, battles = 0, xp = 222, perks = ["perk.pathfinder"], gear = { body = "mail", hand = "sword" }, wounds = ["injury.cut_arm"], hp = 31,
        able = true, ap = 9, fatigue = 0, fatigueMax = 100, distance = distance,
        baseProperties = { Hitpoints = 50, Stamina = 90, Initiative = 90, MeleeSkill = 47, RangedSkill = 35, MeleeDefense = 2, RangedDefense = 3, Bravery = 39, DamageTotalMult = 1.0, DamageReceivedTotalMult = 1.0 },
        getLevel = function() { return this.level; },
        getLifetimeStats = function() { return { Battles = this.battles }; },
        isAlive = function() { return this.alive; },
        getFaction = function() { return this.faction; },
        isPlayerControlled = function() { return this.controlled; },
        isPlacedOnMap = function() { return this.placed; },
        getTile = function() { return { distance = this.distance, getDistanceTo = function(other) { return abs(other.distance - this.distance); } }; },
        getSkills = function() { return this.skills; }
    };
    actor.skills <- {
        actor = actor, all = {}, derived = clone actor.baseProperties,
        getActor = function() { return this.actor; },
        hasSkill = function(id) { return id in this.all; },
        getSkillByID = function(id) { return id in this.all ? this.all[id] : null; },
        add = function(skill) {
            if (this.hasSkill(skill.m.ID)) return;
            skill.m.Container = this;
            this.all[skill.m.ID] <- skill;
            if (::state.failAdd) { ::state.failAdd = false; throw "add failed after insertion"; }
            this.update();
        },
        removeAllByID = function(id) {
            if (id in this.all) { this.all[id].m.IsGarbage = true; delete this.all[id]; }
            this.update();
        },
        update = function() { this.derived = clone this.actor.baseProperties; foreach (id, skill in this.all) skill.onUpdate(this.derived); }
    };
    return addTalentFixture(actor, {MeleeSkill=2,Bravery=2,Stamina=1});
}
function stream() {
    return { data = [], index = 0,
        writeBool = function(value) { this.data.push(value); }, readBool = function() { return this.data[this.index++]; },
        writeU8 = function(value) { this.data.push(value); }, readU8 = function() { return this.data[this.index++]; }
    };
}
::passed <- 0;
function expect(condition, label) { if (!condition) throw "Promotion assertion failed: " + label; ::passed++; }
function fresh() {
    ::state.origin = true; ::state.safe = true; ::state.town = true; ::state.tactical = false;
    ::state.roots = false; ::state.progress = 0; ::state.flags = {}; ::state.actor = makeActor();
    ::state.failNew = false; ::state.failAdd = false; ::state.failArt = false;
    ::state.actors = [::state.actor]; ::World.Assets.money = 5000;
    return ::state.actor;
}
function ready() { local a = fresh(); a.level = 5; a.battles = 3; ::AfeixExpedition.set("growth_done_afei", true); return a; }
function beginBattle() {
    ::state.tactical = true;
    foreach (actor in ::state.actors) foreach (id, skill in clone actor.skills.all) skill.onCombatStarted();
}
function endBattle() {
    foreach (actor in ::state.actors) foreach (id, skill in clone actor.skills.all) skill.onCombatFinished();
    ::state.tactical = false;
}
dofile("src/scripts/mods/afeix/talents.nut");
dofile("src/scripts/mods/afeix/promotions.nut");
local A = ::AfeixExpedition;
local bro = fresh();
expect(A.route() == "normal" && A.circleRate() == 0, "new campaign is unpromoted");
expect(!A.promote("invented").ok, "unknown route refused");
expect(!A.promote("toad").ok, "unqualified normal promotion refused");
bro.level = 5; bro.battles = 2; A.set("growth_done_afei", true);
expect(!A.promote("toad").ok, "reserves cannot replace real participation");
bro.battles = 3; A.set("growth_done_afei", false);
expect(!A.promote("toad").ok, "personal growth is required");
A.set("growth_done_afei", true); bro.level = 4;
expect(!A.promote("jiahao").ok, "level required");
bro.level = 5;
foreach (boundary in ["town", "safe", "origin"]) {
    ::state[boundary] = false;
    expect(!A.promote("toad").ok && A.route() == "normal" && ::World.Assets.money == 5000, "unsafe promotion leaves state unchanged: " + boundary);
    ::state[boundary] = true;
}
::state.tactical = true;
expect(!A.promote("toad").ok, "combat cannot change route");
::state.tactical = false; bro.alive = false;
expect(!A.promote("toad").ok, "dead protagonist cannot promote");
bro.alive = true; ::state.actor = null;
expect(!A.promote("toad").ok, "absent protagonist cannot promote");
::state.actor = bro;
local gear = bro.gear, wounds = bro.wounds, perks = bro.perks, baseProperties = bro.baseProperties;
expect(A.promote("toad").ok && ::World.Assets.money == 5000, "first ordinary promotion free");
expect(equalTalentData(bro.talents,[0,0,3,0,3,0,3,0]),"first promotion replaces starting five stars with exactly nine");
expect(bro.m.Attributes[4][0]>=3 && bro.m.Attributes[6][0]>=3,"promotion upgrades actual pending melee and defense rolls");
local nineStarQueue=A.captureTalentState(bro), promotionRolls=::talentRng.calls;
expect(bro.skills.hasSkill("actives.afeix_wawa") && bro.skills.hasSkill("trait.afeix_promotion"), "toad skill package installed");
expect(bro.skills.derived.MeleeSkill == 55 && bro.skills.derived.MeleeDefense == 7 && bro.skills.derived.RangedDefense == 8, "toad combat attributes");
expect(abs(bro.skills.derived.DamageTotalMult - 1.10) < 0.001 && A.circleRate() == 0, "toad has offense but no circle income");
local active = bro.skills.getSkillByID("actives.afeix_wawa");
A.syncPromotion(bro); A.syncPromotion(bro);
expect(bro.skills.all.len() == 2 && bro.skills.getSkillByID("actives.afeix_wawa") == active, "sync idempotent and retains active instance");
expect(bro.skills.derived.MeleeSkill == 55 && bro.baseProperties.MeleeSkill == 47, "sync never stacks base attributes");
expect(!A.promote("toad").ok && ::World.Assets.money == 5000, "same-route request cannot charge");
expect(!A.promote("jiahao").ok, "early respec denied");
bro.level = 9; ::state.progress = 11;
expect(!A.promote("jiahao").ok, "respec requires twelve fulfilled jobs");
::state.progress = 12; ::World.Assets.money = 1499;
expect(!A.promote("jiahao").ok && A.route() == "toad" && ::World.Assets.money == 1499 && bro.skills.getSkillByID("actives.afeix_wawa") == active, "insufficient funds leave full old state intact");
::World.Assets.money = 1500;
expect(A.promote("jiahao").ok && ::World.Assets.money == 0, "respec charges once exactly");
expect(equalTalentData(bro.talents,nineStarQueue.talents) && equalTalentData(bro.m.Attributes,nineStarQueue.attributes) && ::talentRng.calls==promotionRolls,"respec neither stacks nine stars nor rerolls upgrades");
expect(!bro.skills.hasSkill("actives.afeix_wawa") && bro.skills.hasSkill("actives.afeix_haoqi") && bro.skills.all.len() == 2, "old route removed without duplicate passive");
expect(bro.skills.derived.MeleeSkill == 47 && bro.skills.derived.Bravery == 49 && bro.skills.derived.DamageTotalMult == 1.0, "new route does not retain toad bonuses");
expect(bro.gear == gear && bro.wounds == wounds && bro.perks == perks && bro.baseProperties == baseProperties && bro.hp == 31 && bro.xp == 222, "same actor preserves equipment injury HP XP perks and base properties");
expect(A.circleRate() == 0.15, "jiahao circle rate");
expect(!A.promote("jiahao").ok && ::World.Assets.money == 0, "repeat respec request not charged");
expect(!A.promote("feidie").ok, "hidden route needs roots");
::state.roots = true; bro.level = 1; ::state.progress = 0;
expect(A.promote("feidie").ok && ::World.Assets.money == 0, "first hidden route has no additional level or money gate");
expect(A.get("feidie_base_route") == "jiahao" && A.get("promotion_seen_feidie", false), "hidden route saves previous body and first-use history");
expect(A.circleRate() == 0.10 && bro.skills.derived.MeleeSkill == 52 && bro.skills.derived.Bravery == 44, "hybrid has its own moderate passive");
expect(!bro.skills.hasSkill("actives.afeix_haoqi") && bro.skills.hasSkill("actives.afeix_feidie"), "hybrid replaces rather than copies jiahao package");
bro.level = 9; ::state.progress = 12; ::World.Assets.money = 3000;
expect(A.promote("toad").ok && ::World.Assets.money == 1500, "leaving hidden route uses paid respec");
expect(A.promote("feidie").ok && ::World.Assets.money == 0 && A.get("feidie_base_route") == "toad", "returning hidden route charged and body updated");
bro = fresh(); ::state.roots = true; ::World.Assets.money = 0;
expect(A.promote("feidie").ok && A.get("feidie_base_route") == "normal", "unpromoted level-one actor may choose newly unlocked hidden route");
expect(equalTalentData(bro.talents,[0,0,3,0,3,0,3,0]),"direct hidden promotion also grants nine stars");
local promotedSave=A.captureTalentState(bro);local loadedActor=makeActor();A.restoreTalentState(loadedActor,promotedSave);
A.syncPromotion(loadedActor);
expect(equalTalentData(loadedActor.m.Attributes,promotedSave.attributes),"loaded promoted actor preserves cached upgrades");
local legacyActor=makeActor();A.syncPromotion(legacyActor);
expect(equalTalentData(legacyActor.talents,[0,0,3,0,3,0,3,0]),"already promoted old save gains nine stars on synchronization");
local other = makeActor("damou"); A.syncPromotion(other);
expect(other.skills.all.len() == 0, "other captains cannot receive protagonist package");

foreach (failure in ["failNew", "failAdd", "failArt"]) {
    bro = ready(); A.promote("toad"); bro.level = 9; ::state.progress = 12; ::World.Assets.money = 1500;
    local oldActive = bro.skills.getSkillByID("actives.afeix_wawa"), oldPassive = bro.skills.getSkillByID("trait.afeix_promotion");
    oldActive.m.Used = true; ::state[failure] = true;
    expect(!A.promote("jiahao").ok && A.route() == "toad" && ::World.Assets.money == 1500, "failure rolls back route and no charge: " + failure);
    expect(bro.skills.getSkillByID("actives.afeix_wawa") == oldActive && bro.skills.getSkillByID("trait.afeix_promotion") == oldPassive && oldActive.m.Used, "failure keeps old skill instances and state: " + failure);
    expect(!oldActive.m.IsGarbage && bro.skills.all.len() == 2 && !bro.skills.hasSkill("actives.afeix_haoqi") && bro.skills.derived.MeleeSkill == 55, "failure leaves no partial package: " + failure);
    expect(A.promote("jiahao").ok && ::World.Assets.money == 0, "retry works and charges once: " + failure);
}
bro = fresh(); ::state.roots = true; ::state.failArt = true;
expect(!A.promote("feidie").ok && A.route() == "normal" && !A.get("promotion_seen_feidie", false) && bro.skills.all.len() == 0, "failed first hidden promotion does not consume free unlock");
foreach(failure in ["roll","dirty"]) {
    bro=ready();local saved=A.captureTalentState(bro);
    if(failure=="roll")::talentRng.fail=true;else bro.failDirty=true;
    expect(!A.promote("toad").ok && A.route()=="normal" && ::World.Assets.money==5000 && bro.skills.all.len()==0,"talent failure rolls back route skills and money "+failure);
    expect(equalTalentData(bro.talents,saved.talents) && equalTalentData(bro.m.Attributes,saved.attributes),"talent failure restores starting stars and upgrade queue "+failure);
    expect(A.promote("toad").ok,"talent failure remains retryable "+failure);
}

// Real actives, effects, durations, money and faction filtering.
bro = ready(); A.promote("toad");
local ally = makeActor("bottle", 1, 1); ::state.actors.push(ally);
beginBattle(); active = bro.skills.getSkillByID("actives.afeix_wawa");
expect(active.use(null) && bro.ap == 6 && bro.fatigue == 15 && ::World.Assets.money == 5000, "wawa uses native AP/fatigue and no money");
expect(bro.skills.derived.MeleeSkill == 67 && abs(bro.skills.derived.DamageReceivedTotalMult - 0.80) < 0.001 && ally.skills.all.len() == 0, "wawa is personal only");
expect(!active.use(null) && bro.ap == 6, "one activation per battle");
local usedSave = stream(); active.onSerialize(usedSave);
local loaded = ::new("scripts/skills/actives/afeix_wawa"); loaded.onDeserialize(usedSave);
bro.skills.removeAllByID(active.m.ID); bro.skills.add(loaded); A.syncPromotion(bro);
expect(loaded.m.Used && !loaded.isUsable() && bro.skills.getSkillByID(loaded.m.ID) == loaded, "serialized usage survives loading and late sync");
local effect = bro.skills.getSkillByID("effects.afeix_wawa"); effect.onTurnStart();
local effectSave = stream(); effect.onSerialize(effectSave);
local loadedEffect = ::new("scripts/skills/effects/afeix_wawa_effect"); loadedEffect.onDeserialize(effectSave);
bro.skills.removeAllByID(effect.m.ID); bro.skills.add(loadedEffect);
expect(loadedEffect.m.TurnsLeft == 1 && bro.skills.hasSkill("effects.afeix_wawa"), "remaining duration persists through save load");
loadedEffect.onTurnStart();
expect(!bro.skills.hasSkill("effects.afeix_wawa"), "effect expires at second turn start");
endBattle(); beginBattle(); bro.ap = 9; bro.fatigue = 0;
expect(loaded.use(null), "fresh combat resets limited use");
endBattle();
expect(!bro.skills.hasSkill("effects.afeix_wawa"), "combat end removes temporary effect");

bro = ready(); A.promote("jiahao");
local close = makeActor("bottle", 1, 3), far = makeActor("damou", 1, 4), enemy = makeActor("enemy", 2, 1), neutral = makeActor("neutral", 0, 1);
local allyNPC = makeActor("auxiliary", 3, 1), dead = makeActor("dead", 1, 1), unplaced = makeActor("reserve", 1, 1), charmed = makeActor("charmed", 1, 1);
dead.alive = false; unplaced.placed = false; charmed.controlled = false;
::state.actors = [bro, close, far, enemy, neutral, allyNPC, dead, unplaced, charmed];
beginBattle(); active = bro.skills.getSkillByID("actives.afeix_haoqi");
::World.Assets.money = 79;
expect(!active.use(null) && !active.m.Used && bro.ap == 9 && ::World.Assets.money == 79, "insufficient gold spends no combat resources");
::World.Assets.money = 80; bro.able = false;
expect(!active.use(null) && ::World.Assets.money == 80, "native unable-to-use-skills gate retained");
bro.able = true; bro.ap = 3;
expect(!active.use(null) && ::World.Assets.money == 80, "native AP affordability enforced");
bro.ap = 9; bro.fatigue = 81;
expect(!active.use(null) && ::World.Assets.money == 80, "native fatigue affordability enforced");
bro.fatigue = 0;
expect(!active.onUse(close, null) && ::World.Assets.money == 80, "foreign caller cannot pay or cast with another actor's skill");
bro.ap = 4;
expect(active.use(null) && ::World.Assets.money == 0 && bro.ap == 0 && bro.fatigue == 20, "exactly four remaining AP still activates after native deduction");
expect(bro.skills.hasSkill("effects.afeix_haoqi") && close.skills.hasSkill("effects.afeix_haoqi"), "aura includes self and radius boundary ally");
foreach (invalid in [far, enemy, neutral, allyNPC, dead, unplaced, charmed]) expect(invalid.skills.all.len() == 0, "excluded tactical actor: " + invalid.key);
expect(close.skills.derived.MeleeSkill == 57 && close.skills.derived.RangedSkill == 45 && close.skills.derived.Bravery == 49, "team boost values are applied");
expect(!active.use(null) && ::World.Assets.money == 0, "repeated activation cannot charge again");
local closeEffect = close.skills.getSkillByID("effects.afeix_haoqi"); closeEffect.onTurnStart();
expect(close.skills.hasSkill("effects.afeix_haoqi"), "ally keeps effect for one complete personal turn");
closeEffect.onTurnStart(); expect(!close.skills.hasSkill("effects.afeix_haoqi"), "ally's own second turn expires effect");
endBattle();
expect(!active.isUsable(), "cannot spend money outside tactical battle");

bro = fresh(); ::state.roots = true; A.promote("feidie");
close = makeActor("close", 1, 2); far = makeActor("far", 1, 3); ::state.actors = [bro, close, far];
beginBattle(); active = bro.skills.getSkillByID("actives.afeix_feidie"); ::World.Assets.money = 60;
expect(active.use(null) && ::World.Assets.money == 0, "hybrid exact gold cost");
expect(close.skills.derived.MeleeSkill == 55 && far.skills.derived.MeleeSkill == 47, "hybrid support radius is two");
expect(abs(bro.skills.derived.DamageReceivedTotalMult - 0.90) < 0.001 && close.skills.derived.DamageReceivedTotalMult == 1.0, "hybrid protection remains personal");
expect(bro.skills.derived.MeleeSkill == 60 && !bro.skills.hasSkill("effects.afeix_wawa") && !bro.skills.hasSkill("effects.afeix_haoqi"), "hybrid does not stack full branch effects");
endBattle();

// Closure ownership and native six-button screen contract.
dofile("src/scripts/mods/afeix/discovery.nut");
dofile("src/scripts/mods/afeix/ledger.nut");
dofile("src/scripts/mods/afeix/promotion_ledger.nut");
local event = { m = { Notice = "" } };
expect(A.promotionLedgerPage(event, "growth") == null, "unhandled page returns null");
foreach (page in ["promotion", "promotion:toad", "promotion:jiahao", "promotion:feidie", "promotion:unknown"]) {
    local screen = A.promotionLedgerPage(event, page);
    expect(screen.ID == page && screen.Options.len() <= 6 && screen.Text.find("[img]") == null, "complete unwrapped native screen: " + page);
    expect(screen.Options[screen.Options.len() - 1].getResult(event) == "growth", "back to growth: " + page);
}
bro = ready(); A.set("promotion_discovered",true);
local toadPage = A.promotionLedgerPage(event, "promotion:toad"), jiahaoPage = A.promotionLedgerPage(event, "promotion:jiahao");
expect(toadPage.Options[0].getResult(event) == "promotion" && A.route() == "toad", "route confirmation closure keeps its own choice");
expect(jiahaoPage.Options[0].getResult(event) == "promotion" && A.route() == "toad", "stale confirmation revalidates respec eligibility");

// Cross-module gate: an actual personal-growth resolution opens promotion,
// and its separate trait survives promotion, retraining and late-load sync.
::definitions["scripts/skills/traits/character_trait"].m.Titles <- [];
::definitions["scripts/skills/traits/character_trait"].m.Excluded <- [];
A.Characters <- { afei = { name = "阿飞" } };
dofile("src/scripts/mods/afeix/story_progress.nut");
bro = fresh(); bro.level = 3; bro.battles = 2;
expect(A.growthStatus("afei") == "locked" && !A.resolveGrowth("afei", 0).ok, "real growth module rejects too few participated battles");
bro.battles = 3;
expect(A.growthStatus("afei") == "ready" && A.resolveGrowth("afei", 0).ok, "actual growth choice completes at level three and three battles");
expect(A.get("growth_done_afei", false) && bro.skills.hasSkill("trait.afeix_personal"), "growth sets exactly the flag and trait consumed by promotion");
expect(!A.promote("toad").ok, "growth completion alone does not skip ordinary level-five gate");
bro.level = 5;
expect(A.promote("toad").ok, "real completed growth permits ordinary promotion");
local personal = bro.skills.getSkillByID("trait.afeix_personal"), personalBonuses = A.personalBonuses(bro);
local meleeGrowth = "MeleeSkill" in personalBonuses ? personalBonuses.MeleeSkill : 0;
local braveryGrowth = "Bravery" in personalBonuses ? personalBonuses.Bravery : 0;
expect(bro.skills.derived.MeleeSkill == 47 + meleeGrowth + 8, "personal and route bonuses each apply once");
bro.level = 9; ::state.progress = 12; ::World.Assets.money = 1500;
expect(A.promote("jiahao").ok && bro.skills.getSkillByID("trait.afeix_personal") == personal, "respec preserves independent personal-growth trait object");
expect(bro.skills.derived.MeleeSkill == 47 + meleeGrowth && bro.skills.derived.Bravery == 39 + braveryGrowth + 10,
    "personal bonus survives while old route bonus disappears");
expect(!A.resolveGrowth("afei", 1).ok && A.get("growth_choice_afei") == 0, "respec does not reopen or change personal choice");
A.set("bicycle_reward_granted", true); A.set("bicycle_choice", 0);
A.syncPersonalGrowth(bro); A.syncPromotion(bro); A.syncPersonalGrowth(bro); A.syncPromotion(bro);
expect(bro.skills.derived.Bravery == 39 + braveryGrowth + 10 + 4 && bro.skills.derived.Hitpoints == 52,
    "bicycle memory coexists without duplicate personal or route reward");
expect(bro.skills.all.len() == 3 && bro.skills.getSkillByID("trait.afeix_personal") == personal && bro.hp == 31,
    "late-load feature sync keeps three skills and does not heal existing wounds");
print("TESTS_PASSED=" + ::passed + "\n");
