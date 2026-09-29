// Uses the keepsake fixture's engine doubles, with the real base scenario,
// real electronic-cigarette grant/skill and real DLC startup hook together.
dofile("src/scripts/scenarios/world/afeix_expedition_scenario.nut");
dofile("src/scripts/mods/afeix_dlc_xiwen_regen/pet.nut");
local scenario = ::afeix_expedition_scenario;
scenario.setdelegate(getroottable());
::mods_hookExactClass <- function(path, callback) {
    expect(path == "scenarios/world/afeix_expedition_scenario", "only own origin is hooked");
    callback(scenario);
};
dofile("src/scripts/mods/afeix_dlc_xiwen_regen/hooks.nut");
local originalNew = ::new, dogCount = 0, failEquip = false, foodUpdates = 0, formationUpdates = 0;
::new = function(path) {
    if (path == "scripts/items/accessory/afeix_regen_item") {
        if (failCreate) throw "injected pet constructor failure";
        dogCount++;
        return {function getID(){return "accessory.afeix_regen";},function onEquip(){},owner=null};
    }
    if (path == "scripts/items/supplies/ground_grains_item")
        return {amount=0,function setAmount(n){this.amount=n;},function getID(){return "supplies.grains";}};
    return originalNew(path);
};
::World.Assets.m <- {Money=2000,ArmorParts=20,Medicine=20,Ammo=80};
::World.Assets.getFoodItems <- function(){return [];};
::World.Assets.updateFood <- function(){foodUpdates++;};
A.Schema <- 8;
A.makeCharacter <- function(key, position) {
    local bro = actor(key);
    local equip = bro.inv.equip;
    bro.inv.equip = function(item) { return failEquip ? false : equip.bindenv(this)(item); };
    brothers.push(bro);
    return bro;
};
A.enforceFormation <- function(){formationUpdates++;};
reset(); brothers=[];
// Regression: the base onSpawnAssets equips the electronic cigarette FIRST.
scenario.onSpawnAssets();
local afei=brothers[0], ecig=afei.inv.accessory, dog=A.findKeepsake("accessory.afeix_regen");
expect(dog != null && stash.items.find(dog) != null, "real startup retains electronic cigarette and grants Regen to stash");
expect(brothers.len()==3 && brothers[1].key=="damou" && brothers[2].key=="mocha", "all three captains created by base scenario");
expect(ecig.getID()=="accessory.afeix_ecig" && afei.skills.len()==1 && afei.skills[0].isUsable(), "electronic cigarette stays equipped and usable");
expect(stash.items.len()==3 && stash.items[0].amount==25 && stash.items[1].amount==25, "starting food is preserved alongside pet");
expect(foodUpdates==1 && formationUpdates==1 && ::World.Assets.m.Money==1800, "DLC preserves resource and formation callbacks");
expect(A.get("dlc_regen_granted",false) && dogCount==1, "stash delivery consumes one grant");
local saved=clone ::World.Flags.v;
expect(!A.giveStartingRegen() && dogCount==1, "repeated grant cannot duplicate stashed dog");
A.ensureStoryItems();
expect(afei.inv.accessory==ecig && stash.items.len()==3, "story refresh preserves both objects");
stash.remove(dog); ::World.Flags.v=clone saved;
expect(!A.giveStartingRegen() && dogCount==1, "saved grant prevents replacement after loss sale or death");
// Reset for isolated inventory edge cases.
local resetPet=function(){reset();brothers=[];A.makeCharacter("afei",3);failEquip=false;};
resetPet(); afei=brothers[0];
expect(A.giveStartingRegen() && afei.inv.accessory.getID()=="accessory.afeix_regen" && stash.items.len()==0, "empty accessory gets dog directly");
local count=dogCount;
expect(!A.giveStartingRegen() && dogCount==count, "equipped dog is never duplicated");
resetPet(); afei=brothers[0]; stash.capacity=0;
expect(A.giveStartingRegen() && afei.inv.accessory!=null, "full stash still permits direct equipment");
resetPet(); afei=brothers[0];
local ordinary={function getID(){return "accessory.other_mod";},function onEquip(){},owner=null};
afei.inv.equip(ordinary);
expect(A.giveStartingRegen() && afei.inv.accessory==ordinary && stash.items.len()==1, "other mod accessory preserved with stash fallback");
resetPet(); afei=brothers[0]; afei.inv.equip(ordinary); stash.capacity=0; count=dogCount;
expect(!A.giveStartingRegen() && dogCount==count && !A.get("dlc_regen_granted",false), "occupied slot and full stash do not consume grant");
stash.capacity=1;
expect(A.giveStartingRegen() && stash.items.len()==1, "failed grant can be retried during startup");
resetPet(); failEquip=true;
expect(A.giveStartingRegen() && brothers[0].inv.accessory==null && stash.items.len()==1, "rejected equipment falls back to stash");
resetPet(); failEquip=true; failAdd=true;
expect(!A.giveStartingRegen() && !A.get("dlc_regen_granted",false), "both delivery failures leave flag unset");
failEquip=false; failAdd=false;
expect(A.giveStartingRegen(), "delivery succeeds once failures clear");
resetPet(); failCreate=true; local threw=false;
try { A.giveStartingRegen(); } catch(error) { threw=true; }
expect(threw && !A.get("dlc_regen_granted",false), "constructor failure cannot consume pet grant");
resetPet(); origin=false; count=dogCount;
expect(!A.giveStartingRegen() && dogCount==count && stash.items.len()==0, "other origins receive no pet");
origin=true; brothers=[];
expect(!A.giveStartingRegen() && dogCount==count, "missing Afei receives no pet");
// Test wrapper return value, single invocation and descriptions independently.
local spawnCalls=0;
local wrapped={m={Description="base"},function create(){this.m.Description="base";},function onSpawnAssets(){spawnCalls++;return 17;}};
::mods_hookExactClass=function(path,callback){callback(wrapped);};
dofile("src/scripts/mods/afeix_dlc_xiwen_regen/hooks.nut");
wrapped.create();
expect(wrapped.m.Description.find("仓库")!=null && wrapped.m.Description.find("饰品")!=null, "origin explains stash placement and equipment");
resetPet(); A.ensureStoryItems(); count=dogCount;
expect(wrapped.onSpawnAssets()==17 && spawnCalls==1 && stash.items.len()==1, "startup wrapper returns base result and grants stashed dog");
wrapped.onSpawnAssets();
expect(dogCount==count+1 && spawnCalls==2 && stash.items.len()==1, "repeated startup callback does not duplicate dog");
print("TESTS_PASSED="+checks+"\n");
