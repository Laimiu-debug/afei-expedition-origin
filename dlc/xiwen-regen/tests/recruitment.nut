// Appended to the v0.24 native recruitment fixture setup by build.py.
local baseCount = A.CharacterOrder.len(), baseCapacity = A.CombatMax, baseRoster = A.RosterMax, capturedScenario = null, queued = null;
local originalHook = ::mods_hookExactClass;
::mods_hookExactClass = function(path, callback) {
    if (path == "scenarios/world/afeix_expedition_scenario") capturedScenario = callback;
    else originalHook(path, callback);
};
::mods_queue = function(id, expression, callback) {
    expect(id == "mod_afeix_dlc_xiwen_regen", "separate DLC registration");
    expect(expression.find(">mod_afeix_expedition") != null, "DLC loads after base hooks");
    queued = callback;
};
dofile("src/scripts/!mods_preload/mod_afeix_dlc_xiwen_regen.nut");
local version = A.Version, rejected = false;
A.Version = 28;
try { queued(); } catch(error) { rejected = true; }
expect(rejected && !("xiwen" in A.Characters), "unsupported base fails before content mutation");
A.Version = version; queued(); queued();
expect(A.CharacterOrder.len() == baseCount + 1, "load guard prevents duplicate registration");
expect(A.Characters.xiwen.name == "希文" && A.Characters.xiwen.chapter == 5, "independent DLC identity/group");
expect(A.RosterMax == baseRoster && A.CombatMax == baseCapacity, "DLC preserves base capacity");
expect(A.characterBackgroundPath("xiwen") == "afeix_xiwen_background", "dedicated background path");
expect(A.MemberGrowth.xiwen.choices.len() == 2 && "xiwen" in A.Endings.members, "growth and endings registered");
reset();
expect(!A.isCharacterKnown("xiwen"), "unvisited character stays hidden");
hire.queryHireInformation();
local xiwen = A.candidateInRoster(townRosters[1], "xiwen");
expect(xiwen != null && player.getSize() == 3, "first town offers Xiwen without auto-recruiting");
expect(xiwen.name == "希文" && xiwen.getHiringCost() == 280, "candidate identity and price");
expect(xiwen.getBaseProperties().Initiative == 111 && xiwen.getTalents()[4] == 2, "authored starting stats and stars");
for(local i = 0; i < 4; i++) hire.queryHireInformation();
expect(townRosters[1].getSize() == 1, "opening hiring repeatedly creates one Xiwen");
local id = xiwen.getID(), money = ::World.Assets.money;
expect(hire.onHireRosterEntry(id).Result == 0, "real native hiring succeeds");
expect(A.findCharacter("xiwen") == xiwen && ::World.Assets.money == money - 280, "same actor transfers and charges once");
expect(hire.onHireRosterEntry(id).Result == 3 && ::World.Assets.money == money - 280, "duplicate click cannot charge again");
xiwen.m.XP = 765; xiwen.m.Level = 3; xiwen.battles = 3;
A.restoreCharacterMetadata(xiwen);
expect(xiwen.m.XP == 765 && xiwen.m.Level == 3 && xiwen.name == "希文", "metadata restoration preserves progress");
expect(A.growthStatus("xiwen") == "ready", "personal growth unlocks after real level/battle milestones");
local snapshot = {retired=true,days=50,renown=3500,crises=0,company="黑旗",states={},living=4,rootCount=0,route="normal",bicycle=0,bicycleChoice=-1};
foreach(key in A.CharacterOrder) snapshot.states[key] <- key == "xiwen" ? "alive" : "unknown";
expect(A.companyEndingText(snapshot).find(A.Endings.members.xiwen.good) != null, "retirement includes Xiwen epilogue");
snapshot.states.xiwen = "dead";
expect(A.companyEndingText(snapshot).find(A.Endings.members.xiwen.memorial) != null, "memorial does not index missing data");
player.remove(xiwen); A.set("dead_xiwen", true);
now += 600; hire.queryHireInformation();
expect(A.makeCharacter("xiwen") == null && A.candidateInRoster(townRosters[1], "xiwen") == null, "death cannot duplicate Xiwen");
reset(); origin = false; hire.queryHireInformation();
expect(townRosters[1].getSize() == 0, "other origins get no DLC recruits");
origin = true;

// One-time pet grant, including a blocked slot and equip failure.
::Const.ItemSlot <- {Accessory=5};
local afei = A.findCharacter("afei"), inventory = afei.getItems(), dogCount = 0, slot = null, equipOK = true;
inventory.getItemAtSlot <- function(index) { return slot; };
inventory.equip = function(item) { if (!equipOK) return false; slot = item; return true; };
local originalNew = ::new;
::new = function(path) {
    if (path == "scripts/items/accessory/afeix_regen_item") { dogCount++; return {path=path,name="里根"}; }
    return originalNew(path);
};
local occupied = {name="another mod's accessory"}; slot = occupied;
expect(!A.giveStartingRegen() && slot == occupied && dogCount == 0, "occupied accessory survives unchanged");
slot = null; equipOK = false;
expect(!A.giveStartingRegen() && !A.get("dlc_regen_granted",false), "failed equip does not consume entitlement");
equipOK = true;
expect(A.giveStartingRegen() && slot.name == "里根", "pet equips directly on Afei");
local count = dogCount, dog = slot, saved = clone ::World.Flags.values;
expect(!A.giveStartingRegen() && dogCount == count && slot == dog, "repeat grant produces no second dog");
slot = null; ::World.Flags.values = clone saved;
expect(!A.giveStartingRegen() && dogCount == count, "saved flag prevents replacement after loss/death/sale");
A.set("dlc_regen_granted",false); origin = false;
expect(!A.giveStartingRegen() && dogCount == count, "other origins get no pet");
origin = true; player.remove(afei);
expect(!A.giveStartingRegen() && dogCount == count, "missing Afei does not consume grant");
player.add(afei);
local spawnCalls = 0;
local scenario = {m={Description="base"},function create(){this.m.Description="base";},function onSpawnAssets(){spawnCalls++;return 17;}};
capturedScenario(scenario); scenario.create();
expect(scenario.m.Description.find("里根") != null, "origin selection explains starting companion");
expect(scenario.onSpawnAssets() == 17 && spawnCalls == 1 && slot.name == "里根", "spawn hook preserves base and grants dog");
scenario.onSpawnAssets();
expect(dogCount == count + 1, "repeat lifecycle callback never duplicates companion");
print("TESTS_PASSED=" + checks + "\n");
