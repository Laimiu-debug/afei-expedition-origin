// Production ledger/actions with native event dispatch, WeakTableRef and
// CharacterProperties serialization. Engine drawing remains simulated.
local checks = 0;
local expect = function(ok, label) { if (!ok) throw "FAIL " + label; checks++; };
::Const <- {};
::createColor <- function(value) { return value; };
::createVec <- function(x, y) { return { X = x, Y = y }; };
::Math <- { function min(a,b) { return a<b?a:b; }, function floor(v) { return ::floor(v); } };
::Time <- { function getVirtualTimeF() { return 0.0; } };
::logError <- function(message) {};
::World <- { function getTime() { return { SecondsPerDay = 86400 }; } };
dofile(".cache/afei-art/native-contract-fixture/character.nut");
dofile(".cache/afei-art/native-contract-fixture/weak_table_ref.nut");
dofile(".cache/afei-art/native-contract-fixture/event.nut");
::inherit <- function(path, child) {
    local result = clone ::event;
    result.m = clone ::event.m;
    foreach (key, value in child) {
        if (key == "m") foreach (name, entry in value) result.m[name] <- entry;
        else result[key] <- value;
    }
    result.setdelegate(getroottable());
    return result;
};
::mods_hookNewObject <- function(...) {};
::mods_hookExactClass <- function(...) {};
::Tactical <- { Active = false, function isActive() { return this.Active; } };
::safe <- true;
::hostile <- false;
::actors <- [];
::World <- {
    Assets = {
        money = 10000, origin = "scenario.afeix_expedition", failPayment = false, waivePayment = false,
        function getMoney() { return this.money; },
        function setMoney(n) { this.money = n; },
        function addMoney(n) { if (!this.waivePayment) this.money += n; if (this.failPayment) throw "wallet failed after debit"; },
        function getOrigin() { return { function getID() { return ::World.Assets.origin; } }; },
        function isCamping() { return ::safe; }
    },
    EntityManager = { function getSettlements() { return []; } },
    State = {
        transition = 0, refreshes = 0, failRefresh = false,
        function getCombatStartTime() { return this.transition; },
        function getPlayer() { return { function getPos() { return {}; } }; },
        function isCampingAllowed() { return ::safe; },
        function updateTopbarAssets() { this.refreshes++; if (this.failRefresh) throw "display refresh failed"; }
    },
    function getPlayerRoster() { return { function getAll() { return ::actors; } }; },
    function getAllEntitiesAtPos(pos, radius) {
        return ::hostile ? [{ function isAlive() { return true; }, function isAlliedWithPlayer() { return false; }, function getTroops() { return [1]; } }] : [];
    }
};
::AfeixExpedition <- { CombatMax = 12, function deployedIds() { return [1]; }, function hasStoryRecords() { return false; } };
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/attribute_treatment.nut");
dofile("src/scripts/mods/afeix/ledger.nut");
dofile("src/scripts/mods/afeix/banner_hooks.nut");
dofile("src/scripts/events/events/afeix_ledger_event.nut");
local A = ::AfeixExpedition;
function makeActor(id, name) {
    local bro = {
        id = id, name = name, alive = true, dying = false, level = 7, hp = 40, hpMult = 1.25, failUpdate = false,
        properties = ::Const.CharacterProperties.getClone(), current = null, skills = null, dirty = false,
        talents = [0,1,2,3,0,1,2,3], pending = [[2],[4]], perks = 3,
        flags = { afeix_training_choice = "kept", afeix_balance_v26 = true, afeix_endgame_revision = 1 },
        equipment = { weapon = "kept" }, injuries = ["kept injury"],
        function getID() { return this.id; }, function getNameOnly() { return this.name; },
        function getLevel() { return this.level; }, function isAlive() { return this.alive; }, function isDying() { return this.dying; },
        function getBaseProperties() { return this.properties; }, function getSkills() { return this.skills; },
        function getHitpoints() { return this.hp; }, function setHitpoints(n) { this.hp = n; },
        function getHitpointsMax() { return ::Math.floor(this.current.Hitpoints * this.hpMult); },
        function setDirty(value) { this.dirty = value; }
    };
    foreach (attribute in ::AfeixExpedition.TreatmentAttributes) bro.properties[attribute.field] = 60;
    bro.skills = { owner = bro, function update() {
        if (this.owner.failUpdate) { this.owner.failUpdate = false; throw "skill update failed"; }
        this.owner.current = clone this.owner.properties;
    } };
    bro.skills.update();
    return bro;
}
for (local i = 1; i <= 40; i++) ::actors.push(makeActor(i, i==1?"阿飞":i==35?"希文":i==40?"普通雇员":"角色"+i));
local first = ::actors[0], dlc = ::actors[34], ordinary = ::actors[39];
// Native weak refs forward methods through _get, rather than the `in` operator.
::actors[0] = ::WeakTableRef(first);
local e = ::afeix_ledger_event;
e.create(); e.fire();
expect(e.processInput(3) && e.m.ActiveScreen.ID=="company", "home reaches company through native event input");
expect(e.m.ActiveScreen.Options[0].Text=="飞李不可", "company exposes treatment");
expect(e.processInput(0) && e.m.ActiveScreen.ID=="treatment", "company reaches treatment");
local money = ::World.Assets.money;
expect(e.processInput(0) && e.m.ActiveScreen.ID=="treatment_actor:1", "native cloned option captures actor ID");
expect(e.processInput(0) && e.m.ActiveScreen.ID=="treatment_preview:1:Hitpoints", "selecting HP only previews");
expect(::World.Assets.money==money && first.properties.Hitpoints==60, "browsing does not buy a point");
local oldOption = e.m.ActiveScreen.Options[0], missingHP = first.getHitpointsMax()-first.hp;
expect(e.processInput(0) && first.properties.Hitpoints==61 && ::World.Assets.money==money-100, "confirmation buys exactly one point for 100");
expect(first.getHitpointsMax()-first.hp==missingHP, "HP multiplier preserves existing wounds");
oldOption.getResult(e);
expect(first.properties.Hitpoints==61 && ::World.Assets.money==money-100, "same confirmation cannot charge twice");
e.setScreen(e.getScreen("treatment_preview:1:MeleeSkill")); oldOption=e.m.ActiveScreen.Options[0];
e.processInput(1); oldOption.getResult(e);
expect(first.properties.MeleeSkill==60 && ::World.Assets.money==money-100, "cancelled offer cannot be reused");
e.setScreen(e.getScreen("treatment_preview:1:MeleeSkill")); oldOption=e.m.ActiveScreen.Options[0];
e.setScreen(e.getScreen("treatment_preview:35:RangedSkill")); oldOption.getResult(e);
expect(first.properties.MeleeSkill==60 && dlc.properties.RangedSkill==60, "replacing preview invalidates previous actor offer");
// Every roster and attribute page fits the native six-button window and links
// to its own actor/field, including reserves, DLC and ordinary hires.
for (local offset=0; offset<40; offset+=4) {
    local screen=A.ledgerPage(e,"treatment:"+offset);
    expect(screen.Options.len()==6,"roster page fits six buttons");
    for (local i=0; i<4; i++) expect(screen.Options[i].getResult(e)=="treatment_actor:"+(offset+i+1),"actor row captures its own ID");
}
foreach (bro in [first,dlc,ordinary]) {
    foreach (offset in [0,4]) {
        local screen=A.ledgerPage(e,"treatment_actor:"+bro.id+":"+offset);
        expect(screen.Options.len()==6,"attribute page fits six buttons");
        for (local i=0;i<4;i++) expect(screen.Options[i].getResult(e)=="treatment_preview:"+bro.id+":"+A.TreatmentAttributes[offset+i].field,"attribute row captures its own field");
    }
    foreach (attribute in A.TreatmentAttributes) {
        local before=clone bro.properties, hpBefore=bro.hp, wallet=::World.Assets.money;
        expect(A.treatAttribute(bro.id,attribute.field,before[attribute.field],100).ok,"all actor kinds can buy all eight attributes");
        foreach (other in A.TreatmentAttributes)
            expect(bro.properties[other.field]==before[other.field]+(other.field==attribute.field?1:0),"only chosen field gains one");
        expect(::World.Assets.money==wallet-100,"each repeat costs 100");
        if(attribute.field!="Hitpoints")expect(bro.hp==hpBefore,"other attributes do not heal HP");
    }
    expect(bro.level==7 && bro.perks==3 && bro.talents[3]==3 && bro.pending[0][0]==2,"level, perks, stars and unspent level-up rolls preserved");
    expect(bro.flags.afeix_training_choice=="kept" && bro.injuries[0]=="kept injury" && bro.equipment.weapon=="kept","training, injuries and equipment preserved");
}
local deny = function(label) {
    local value=first.properties.MeleeSkill, wallet=::World.Assets.money;
    expect(!A.treatAttribute(1,"MeleeSkill",value,100).ok,label);
    expect(first.properties.MeleeSkill==value && ::World.Assets.money==wallet,label+" leaves funds and attributes unchanged");
};
::safe=false; deny("unsafe location denied"); ::safe=true;
::hostile=true; deny("nearby enemy denied"); ::hostile=false;
::Tactical.Active=true; deny("combat denied"); ::Tactical.Active=false;
::World.State.transition=1; deny("combat transition denied"); ::World.State.transition=0;
::World.Assets.origin="scenario.other"; deny("other origin denied"); ::World.Assets.origin="scenario.afeix_expedition";
first.alive=false; deny("dead actor denied"); first.alive=true;
first.dying=true; deny("dying actor denied"); first.dying=false;
local saved=::actors.remove(0); deny("departed actor denied"); ::actors.insert(0,saved);
::World.Assets.money=99; deny("insufficient funds denied"); ::World.Assets.money=10000;
expect(!A.treatAttribute(1,"ActionPoints",9,100).ok,"non-attribute fields denied");
expect(!A.treatAttribute(1,"MeleeSkill",first.properties.MeleeSkill-1,100).ok,"changed attribute invalidates quoted offer");
A.TreatmentCost=110; deny("changed price invalidates quoted offer"); A.TreatmentCost=100;
foreach (failure in ["skill","payment","waived"]) {
    if(failure=="skill")first.failUpdate=true;
    if(failure=="payment")::World.Assets.failPayment=true;
    if(failure=="waived")::World.Assets.waivePayment=true;
    deny(failure+" failure rolls back");
    ::World.Assets.failPayment=false; ::World.Assets.waivePayment=false;
}
::World.State.failRefresh=true;
expect(A.treatAttribute(1,"MeleeSkill",first.properties.MeleeSkill,100).ok,"display error does not undo completed transaction");
::World.State.failRefresh=false;
::World.Assets.money=100;
expect(A.treatAttribute(1,"RangedDefense",first.properties.RangedDefense,100).ok && ::World.Assets.money==0,"exact funds buy one opportunity");
::World.Assets.money=10000;
// Native CharacterProperties serializer/read order carries the paid base
// points, including values above 255; no repeated load-time bonus is applied.
local stream={data=[],pos=0,
    function writeU8(v){this.data.push(v);}, function writeF32(v){this.data.push(v);},
    function writeI16(v){if(v < -32768 || v > 32767)throw "I16 overflow";this.data.push(v);},
    function readU8(){return this.data[this.pos++];},function readI16(){return this.data[this.pos++];},function readF32(){return this.data[this.pos++];}};
first.properties.MeleeSkill=300;
expect(A.treatAttribute(1,"MeleeSkill",300,100).ok,"attribute above U8 range remains supported");
first.properties.onSerialize(stream);
local loaded=::Const.CharacterProperties.getClone(); loaded.onDeserialize(stream);
foreach(attribute in A.TreatmentAttributes)expect(loaded[attribute.field]==first.properties[attribute.field],"native persistence retains "+attribute.field);
first.properties.MeleeSkill=32767; deny("native I16 save ceiling denied"); first.properties.MeleeSkill=loaded.MeleeSkill;
foreach(page in ["treatment:-2","treatment:garbage","treatment_actor:1:garbage","treatment_actor:999","treatment_actor:1abc","treatment_preview:1:ActionPoints"])
    expect(A.ledgerPage(e,page).Options.len()<=6,"malformed/stale links stay navigable");
e.setScreen(e.getScreen("treatment_preview:1:MeleeSkill")); oldOption=e.m.ActiveScreen.Options[0];
e.clear(); oldOption.getResult(e);
expect(first.properties.MeleeSkill==loaded.MeleeSkill && e.m.TreatmentOffer==null,"closing ledger invalidates unspent confirmation");
print("TESTS_PASSED="+checks+"\n");
