// Real authored choices through the native event state machine, with native
// money/mood/type getters. Only engine entities, skills and sound are simulated.
dofile("native/story_api.nut");
dofile("base_contracts.nut");
local D = ::AfeixEventsDLC, A = ::AfeixExpedition, E = ::afeix_dlc_events_event, M = ::World.Events;
D.Scenes = ::authoredScenes; D.Order = ::authoredOrder;
expect(D.Order.len() == 2 && D.Order[0] == "mocha_river_song" && D.Order[1] == "damou_benz", "both supplied stories registered without test fixtures");
::Math.minf <- ::Math.min; ::Math.maxf <- ::Math.max;
::Const.MoodState <- [0, 1, 2, 3, 4];
::Const.Sound <- { MoneyTransaction = ["coin"], Volume = { Inventory = 1 } };
::Sound <- { play = function(...) {} };
local oldAssets = ::World.Assets, oldFind = A.findCharacter, oldEntities = ::World.getAllEntitiesAtPos;
local assets = clone ::nativeMoney;
assets.m <- { Money = 0, Score = 0 };
assets.isCamping <- oldAssets.isCamping;
assets.updateAchievement <- function(...) {};
assets.setdelegate(getroottable()); ::World.Assets = assets;
local makeActor = function(key, alive = true, dying = false) {
    local actor = clone ::nativeMood;
    actor.key <- key; actor.alive <- alive; actor.dying <- dying; actor.fail <- false;
    actor.m <- { Mood = 2.0, MoodChanges = [] };
    actor.isAlive <- function() { return this.alive; };
    actor.isDying <- function() { return this.dying; };
    actor.getSkills <- function() {
        local actor = this;
        return { update = function() { if (actor.fail) throw "fixture skill update failure"; } };
    };
    actor.setdelegate(getroottable()); return actor;
};
local members = [];
A.roster <- function() { return members; };
A.findCharacter = function(key) { foreach (actor in members) if (actor.key == key) return actor; return null; };
::World.State.getCombatStartTime <- function() { return 0; };
local player = { getPos = function() { return 0; }, getTile = function() {
    return { getDistanceTo = function(tile) { return tile.distance; } };
} };
::World.State.getPlayer = function() { return player; };
local camps = [], threats = [];
::World.EntityManager <- { getLocations = function() { return camps; } };
::World.getAllEntitiesAtPos = function(pos, radius) { return threats; };
::World.Contracts <- clone ::nativeContractManager;
::World.Contracts.m <- { Active = null };
local contract = function(kind) { local c = clone ::nativeContract; c.m <- { Type = kind }; return c; };
local camp = function(distance = 8, allied = false, alive = true, troops = 1, location = true) {
    return { isAlive = function() { return alive; }, isLocation = function() { return location; },
        isAlliedWithPlayer = function() { return allied; }, getTroops = function() { return array(troops, 1); },
        getTile = function() { return { distance = distance }; } };
};
function closeStory() {
    M.processInput(0);
    expect(M.m.ActiveEvent == null && !::World.State.m.EventScreen.visible, "native story result closes to map");
}
local prepare = function(id) {
    // Limit only the test draw, retaining the production scene and its predicates.
    D.Order = [id]; E.update();
    expect(E.m.Score == D.Scenes[id].weight, "authored scene scores through native event");
    expect(M.fire(D.EventID) && E.m.Scene == id, "authored scene opens through native manager");
};
local resetStory = function() {
    reset(); ::test.day = 31;
    assets.m.Money = 200; assets.m.Score = 0;
    members = [makeActor("mocha"), makeActor("damou"), makeActor("ordinary"),
        makeActor("reserve"), makeActor("dead", false), makeActor("dying", true, true)];
    camps = [camp()]; threats = [];
    ::World.Contracts.m.Active = contract("contract.deliver_item");
    D.Order = ::authoredOrder;
};
local near = function(actual, expected) { return ::Math.max(actual - expected, expected - actual) < 0.00001; };
resetStory();
expect(D.eligible("mocha_river_song", "road"), "living mocha and hostile camp at eight tiles admit song");
expect(D.pool("tavern").len() == 0, "both new stories stay out of tavern pool");
foreach (entry in [null, camp(9), camp(8, true), camp(8, false, false), camp(8, false, true, 0), camp(8, false, true, 1, false)]) {
    camps = [entry]; expect(!D.eligible("mocha_river_song", "road"), "song excludes absent distant allied dead empty or noncamp targets");
}
resetStory(); members.remove(0); expect(!D.eligible("mocha_river_song", "road"), "absent mocha cannot trigger song");
foreach (dying in [false, true]) {
    resetStory(); members[0].alive = dying; members[0].dying = dying;
    expect(!D.eligible("mocha_river_song", "road"), "dead or dying mocha cannot trigger song");
}
resetStory(); ::test.moving = false; expect(!D.eligible("mocha_river_song", "road"), "song requires travelling");
resetStory(); ::test.camping = true; expect(!D.eligible("mocha_river_song", "road"), "song excludes camping");
resetStory(); ::World.State.m.WorldTownScreen.visible = true; expect(!D.eligible("mocha_river_song", "road"), "song excludes settlements");
resetStory(); ::test.safe = false; expect(!D.eligible("mocha_river_song", "road"), "song retains main danger exclusion");
resetStory(); threats = [camp(1)];
local generator = M.selectEvent(); while (resume generator == false) {}
expect(M.m.ActiveEvent == null && !::World.State.m.EventScreen.visible, "native nearby-enemy guard still blocks authored scene");
resetStory(); D.Order = ["mocha_river_song"];
generator = M.selectEvent(); while (resume generator == false) {}
expect(E.m.Scene == "mocha_river_song" && M.m.ActiveEvent == E && !::test.moving, "native random draw can show nearby-camp song and pause travel");
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result", "song choice settles through native input");
foreach (actor in members) expect(near(actor.getMood(), actor.alive && !actor.dying ? 2.1 : 2.0), "song affects all living roster including ordinary reserves only");
expect(assets.getMoney() == 200 && assets.m.Score == 0, "song changes no money or income score");
expect(!D.resolve(E, 0).ok && near(members[0].getMood(), 2.1), "repeated song click cannot duplicate mood");
closeStory();
expect(!D.eligible("mocha_river_song", "road") && D.get("cooldown_mocha_river_song") == ::test.now + D.days(8), "song display starts eight-day cooldown");
local savedFlags = clone ::test.flags;
resetStory(); ::test.flags = clone savedFlags;
expect(!D.eligible("mocha_river_song", "road"), "song cooldown persists across simulated world flag reload");
::test.now += D.days(8);
expect(D.eligible("mocha_river_song", "road"), "repeatable song returns after cooldown despite completion record");
resetStory(); prepare("mocha_river_song"); members.remove(0);
expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && near(members[0].getMood(), 2), "mocha leaving before choice grants no mood");
expect(!E.processInput(1), "song failed prerequisite has safe exit");

foreach (day in [1, 29, 30, 31, 32]) {
    resetStory(); ::test.day = day;
    expect(D.eligible("damou_benz", "road") == (day > 30), "benz starts strictly after day thirty");
}
foreach (kind in ["contract.deliver_item", "contract.afeix_letter", "contract.escort_caravan", "contract.raid_caravan", "contract.destroy_bandit_camp", ""]) {
    resetStory(); ::World.Contracts.m.Active = contract(kind);
    expect(D.eligible("damou_benz", "road") == (["contract.deliver_item", "contract.afeix_letter", "contract.escort_caravan"].find(kind) != null), "benz requires accepted courier or caravan escort kind");
}
resetStory(); ::World.Contracts.m.Active = null;
expect(!D.eligible("damou_benz", "road"), "open offers without accepted contract do not trigger benz");
resetStory();
// Native WeakTableRef exposes its getter via _get rather than the in operator.
local c = contract("contract.escort_caravan"), weak = {};
weak.setdelegate({ _get = function(key) { return c[key]; } }); ::World.Contracts.m.Active = weak;
expect(D.eligible("damou_benz", "road"), "weak contract getter remains eligible");
resetStory(); members.remove(1); expect(!D.eligible("damou_benz", "road"), "absent damou cannot trigger benz");
resetStory(); members[1].alive = false; expect(!D.eligible("damou_benz", "road"), "dead damou cannot trigger benz");
resetStory(); members[1].dying = true; expect(!D.eligible("damou_benz", "road"), "dying damou cannot trigger benz");
resetStory(); ::World.State.m.WorldTownScreen.visible = true;
expect(!D.eligible("damou_benz", "road"), "benz stays on road during deliveries");
foreach (balance in [0, 118, 119, 200]) {
    resetStory(); assets.m.Money = balance; prepare("damou_benz");
    expect(E.processInput(0), "benz paid choice responds safely");
    if (balance < 119) {
        expect(E.m.ActiveScreen.ID == "retry" && assets.getMoney() == balance && near(members[1].getMood(), 2), "unaffordable benz choice charges and grants nothing");
        expect(E.processInput(1) && assets.getMoney() == balance && near(members[1].getMood(), 1.8), "unaffordable player can choose free refusal");
    } else {
        expect(E.m.ActiveScreen.ID == "result" && assets.getMoney() == balance - 119 && near(members[1].getMood(), 2.2), "benz costs exactly 119 and improves damou mood by 0.2");
        expect(!D.resolve(E, 0).ok && assets.getMoney() == balance - 119 && near(members[1].getMood(), 2.2), "benz cannot pay or reward twice");
    }
    foreach (actor in members) if (actor.key != "damou") expect(near(actor.getMood(), 2), "benz leaves other actors mood unchanged");
    expect(assets.m.Score == 0, "benz payment cannot count as contract income"); closeStory();
}
resetStory(); prepare("damou_benz");
expect(E.processInput(1) && assets.getMoney() == 200 && near(members[1].getMood(), 1.8), "free refusal only worsens damou mood");
expect(!D.resolve(E, 1).ok && near(members[1].getMood(), 1.8), "refusal cannot worsen mood twice"); closeStory();
resetStory(); prepare("damou_benz");
expect(!E.processInput(2) && assets.getMoney() == 200 && near(members[1].getMood(), 2) && !D.get("done_damou_benz", false), "safe exit changes no resources or completion");
resetStory(); prepare("damou_benz"); members.remove(1);
expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && assets.getMoney() == 200, "damou departure rechecked before charging");
resetStory(); prepare("damou_benz"); members[1].alive = false;
expect(E.processInput(1) && E.m.ActiveScreen.ID == "retry" && near(members[1].getMood(), 2), "damou death rechecked before refusal");
resetStory(); prepare("damou_benz"); ::World.Contracts.m.Active = null;
expect(E.processInput(0) && E.m.ActiveScreen.ID == "retry" && assets.getMoney() == 200, "finished or cancelled delivery invalidates paid choice");
resetStory(); prepare("damou_benz"); D.set("active_token", E.m.Token + 1);
expect(!D.resolve(E, 0).ok && assets.getMoney() == 200, "stale benz callback changes no resources");
resetStory(); prepare("damou_benz"); members[1].fail = true;
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result" && E.m.Resolved, "authored settlement failure terminates without retry loop");
expect(assets.getMoney() == 200 && near(members[1].getMood(), 2) && members[1].m.MoodChanges.len() == 0 && assets.m.Score == 0, "failed benz settlement rolls back money mood and mood history without income");
expect(!D.resolve(E, 0).ok && assets.getMoney() == 200, "failed authored callback cannot rerun");
resetStory(); prepare("mocha_river_song"); members[2].fail = true;
members[0].m.MoodChanges = [{ Positive = true, Text = "听午夜抹抹茶唱歌", Time = 123 }];
expect(E.processInput(0) && E.m.ActiveScreen.ID == "result", "song partial failure terminates safely");
foreach (actor in members) expect(near(actor.getMood(), 2) && actor.m.MoodChanges.len() == (actor.key == "mocha" ? 1 : 0), "partial song reward rolls back entire roster mood and history");
expect(members[0].m.MoodChanges[0].Time == 123, "rollback restores existing same-reason mood timestamp rather than sharing mutable history entries");
resetStory(); prepare("damou_benz"); E.processInput(1); closeStory();
savedFlags = clone ::test.flags; resetStory(); ::test.flags = clone savedFlags;
expect(!D.eligible("damou_benz", "road") && !D.eligible("mocha_river_song", "road"), "saved benz cooldown also preserves shared cooldown");
::test.now += D.days(8);
expect(D.eligible("damou_benz", "road"), "repeatable benz returns after saved cooldown expires");
expect(D.ConditionFaults.len() == 0, "authored conditions never recurse or enter error quarantine");
D.Order = ::authoredOrder; A.findCharacter = oldFind;
::World.Assets = oldAssets; ::World.getAllEntitiesAtPos = oldEntities;
