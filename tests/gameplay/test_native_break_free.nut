// Execute native break-free, skill use/removal and AI completion with the real
// catalog hook. Rendering and engine entity properties are test substitutes.
dofile("tests/gameplay/member_skill_fixture.nut");
local A = ::AfeixExpedition;
::checks <- 0;
function check(ok, label) { if (!ok) throw "FAIL " + label; ::checks++; }
function eq(actual, expected, label) { check(actual == expected, label); }
::baseHooks <- {};
::mods_hookBaseClass <- function(path, cb) { ::baseHooks[path] <- cb; };
::mods_hookExactClass <- function(...) {};
::mods_getMember <- function(o, k) { return o[k]; };
::mods_override <- function(o, k, v) { o[k] = v; };
dofile("src/scripts/mods/afeix/member_catalog_hooks.nut");
::catalogTestHook <- function(path, o) { if (path == "scripts/skills/skill") ::baseHooks["skills/skill"](o); };
::Const.SkillOrder.BeforeLast <- 100;
::Const.UI <- { getColorizedEntityName = function(a) { return a.getName(); } };
::Const.AI <- { VerboseMode = false };
::Tactical.EventLog <- { log_newline = function() {}, logEx = function(text) {} };
::isKindOf = function(a, kind) { return typeof a == "table" && (kind == "skill" ? "getContainer" in a : ("human" in a && a.human && kind == "human")); };
foreach (name in ["break_free_skill", "net_effect"]) {
    dofile(".cache/afei-art/native-contract-fixture/" + name + ".nut");
    ::definitions["scripts/skills/" + (name == "net_effect" ? "effects/" : "actives/") + name] <- getroottable()[name];
}
dofile(".cache/afei-art/native-contract-fixture/skill_container.nut");
::definitions["scripts/ai/tactical/behavior"] <- { m = {} };
dofile(".cache/afei-art/native-contract-fixture/ai_break_free.nut");

function trappedActor(faction = 2) {
    local a = makeActor("enemy", 0, faction);
    a.controlled = faction == ::Const.Faction.Player;
    a.baseProps.MeleeDefenseMult <- 1.0;
    a.baseProps.RangedDefenseMult <- 1.0;
    a.baseProps.InitiativeMult <- 1.0;
    a.baseProps.getMeleeSkill <- function() { return this.MeleeSkill; };
    a.baseProps.getClone <- function() { return clone this; };
    a.getBaseProperties <- function() { return this.baseProps; };
    a.setCurrentProperties <- function(p) { this.props = p; };
    a.getHitpointsMax = function() { return 0; };
    a.getActionPointsMax <- function() { return 9; };
    a.onSkillsUpdated <- function() {};
    a.updateOverlay <- function() {};
    a.sprites <- { status_rooted = { Visible = true }, status_rooted_back = { Visible = true } };
    a.getSprite <- function(name) { return this.sprites[name]; };
    a.setDirty <- function(value) {};
    local c = clone ::skill_container;
    c.setdelegate(getroottable());
    c.m = clone ::skill_container.m;
    c.m.Skills = []; c.m.SkillsToAdd = [];
    c.setActor(a); a.skills = c;
    local net = ::new("scripts/skills/effects/net_effect");
    net.spawnIcon <- function(...) {};
    c.add(net);
    local s = ::new("scripts/skills/actives/break_free_skill");
    c.add(s);
    return a;
}

function runEscapeAI(a, s) {
    local ai = clone ::ai_break_free;
    ai.setdelegate(getroottable()); ai.m = clone ::ai_break_free.m;
    ai.m.Skill = s;
    ai.agent <- { actions = 0, declareAction = function() { this.actions++; } };
    ai.getAgent <- function() { return this.agent; };
    check(ai.onExecute(a), "AI finishes break-free behavior");
    eq(ai.m.Skill, null, "AI releases completed action");
    eq(ai.agent.actions, 1, "AI declares its action");
}

// Both native deferred collection and collection by an onUse hook must allow
// the outer catalog use hook to return to the AI. The latter exercises the
// detached-skill boundary that the old post-use callback did not support.
foreach (origin in [true, false]) foreach (faction in [1, 2]) foreach (collectDuringUse in [false, true]) {
    fresh();
    ::state.origin = origin;
    local enemy = trappedActor(faction), escape = enemy.skills.getSkillByID("actives.break_free");
    if (collectDuringUse) {
        local nativeOnUse = escape.onUse;
        escape.onUse = function(user, tile) {
            local result = nativeOnUse.bindenv(this)(user, tile);
            user.getSkills().update();
            return result;
        };
    }
    check(enemy.props.IsRooted, "net roots actor");
    runEscapeAI(enemy, escape);
    check(!enemy.props.IsRooted, "net removed immediately");
    enemy.skills.update();
    eq(escape.getContainer(), null, "native garbage collection detaches skill");
    eq(enemy.ap, 5, "escape costs four AP");
    eq(enemy.fatigue, 15, "escape costs fifteen fatigue");
    check(!enemy.sprites.status_rooted.Visible && !enemy.sprites.status_rooted_back.Visible, "net sprites cleared");
    local target = makeActor("target", 1, faction == 1 ? 2 : 1), attack = equip(enemy);
    check(attack.use(target.tile), "actor can attack after escaping");
    eq(::state.attacks.len(), 1, "follow-up attack resolves once");
    eq(enemy.ap, 1, "follow-up attack pays AP once");
}

fresh();
local enemy = trappedActor(), escape = enemy.skills.getSkillByID("actives.break_free");
escape.setSkillBonus(0);
runEscapeAI(enemy, escape);
check(enemy.props.IsRooted, "failed attempt retains net");
check(escape.getContainer() != null && !escape.isGarbage(), "failed attempt retains escape skill");
eq(escape.m.ChanceBonus, 10, "failure increases next escape chance");
eq(enemy.ap, 5, "failed attempt still pays four AP");
runEscapeAI(enemy, escape);
check(!enemy.props.IsRooted, "retry can escape");
eq(enemy.ap, 1, "retry pays another four AP");
eq(enemy.fatigue, 30, "two attempts pay fatigue once each");

fresh();
enemy = trappedActor(); escape = enemy.skills.getSkillByID("actives.break_free");
enemy.ap = 3;
check(!escape.use(enemy.tile), "insufficient AP refuses escape");
check(enemy.props.IsRooted, "refused action leaves net intact");
eq(enemy.ap, 3, "refused action spends no AP");
eq(enemy.fatigue, 0, "refused action spends no fatigue");

// A removed order is safe too, while a live order must still trigger its
// existing companion behavior (also covered by test_member_catalog.nut).
foreach (id in ["actives.afeix_haoqi", "actives.afeix_feidie"]) {
    local order = { id = id, getID = function() { return this.id; }, getContainer = function() { return null; } };
    A.catalogAfterSkill(order, true);
    check(true, "detached captain order is safe");
}

print("TESTS_PASSED=" + ::checks + "\n");
