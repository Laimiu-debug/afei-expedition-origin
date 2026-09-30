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
dofile(".cache/afei-art/native-contract-fixture/world_town_screen.nut");
local townScreen = clone ::world_town_screen;
townScreen.m = clone ::world_town_screen.m;
local tavernModule = {};
local town = { alive = true, function isAlive() { return this.alive; } };
townScreen.m.Visible = true;
townScreen.m.TavernDialogModule = tavernModule;
townScreen.m.LastActiveModule = tavernModule;
townScreen.m.Town = ::WeakTableRef(town);
::inherit <- function(path, child) {
    local result = clone ::event;
    result.m = clone ::event.m;
    result.event <- ::event;
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
        m = { WorldTownScreen = townScreen },
        transition = 0, refreshes = 0, failRefresh = false, player = { function getPos() { return {}; } },
        function getCombatStartTime() { return this.transition; },
        function getPlayer() { return this.player; },
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
expect(::World.Assets.money==money && first.properties.Hitpoints==60, "browsing does not buy a point");
local oldOption = e.m.ActiveScreen.Options[0], missingHP = first.getHitpointsMax()-first.hp;
expect(e.processInput(0) && first.properties.Hitpoints==61 && ::World.Assets.money==money-100, "one attribute click buys exactly one point for 100");
expect(e.m.ActiveScreen.ID=="treatment_actor:1" && e.m.ActiveScreen.Options[0].Text.find("61")!=null,
    "successful purchase stays on the attribute page with fresh button values");
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
        local page="treatment_actor:"+bro.id+":"+offset;
        local screen=A.ledgerPage(e,page);
        expect(screen.Options.len()==6,"attribute page fits six buttons");
        for (local i=0;i<4;i++) {
            e.setScreen(e.getScreen(page));
            local before=clone bro.properties,wallet=::World.Assets.money,field=A.TreatmentAttributes[offset+i].field;
            expect(e.processInput(i)&&e.m.ActiveScreen.ID==page,"each cloned direct button stays on its attribute page");
            foreach(attribute in A.TreatmentAttributes)
                expect(bro.properties[attribute.field]==before[attribute.field]+(attribute.field==field?1:0),
                    "each direct button changes only its captured attribute");
            expect(::World.Assets.money==wallet-100,"each native button charges exactly once");
        }
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
// Actual native town-screen state is authoritative. Being on the world map,
// camping or remembering a previously visited inn cannot enable a purchase.
::safe=false;
townScreen.m.Visible=false;
A.TavernTown <- 51;
expect(!A.canManage(),"ordinary camp/town management stays restricted in the field");
expect(A.ledgerPage(e,"home").Text.find("飞李不可仅限酒馆内使用")!=null,"field home page explains the tavern rule");
deny("uncamped world map denied despite remembered tavern");
::safe=true;
expect(A.canManage(),"safe camp still allows ordinary management");
deny("camping does not enable treatment");
foreach(page in ["treatment","treatment_actor:1","treatment_preview:1:MeleeSkill"]) {
    local screen=A.ledgerPage(e,page);
    expect(screen.Text.find("只能在酒馆内使用")!=null&&screen.Options.len()==1,
        "field roster and stale actor/preview links have no purchase buttons");
}
::World.State.m.WorldTownScreen=null;deny("missing town screen denied");::World.State.m.WorldTownScreen=townScreen;
townScreen.m.Visible=true;
foreach(module in [null,{},{}]) {
    townScreen.m.LastActiveModule=module;
    deny("town main/shop/other module is not the tavern");
}
townScreen.m.LastActiveModule=tavernModule;
townScreen.m.TavernDialogModule=null;deny("missing tavern module denied");
townScreen.m.LastActiveModule=null;deny("two null modules do not count as a tavern");
townScreen.m.TavernDialogModule=tavernModule;townScreen.m.LastActiveModule=tavernModule;
townScreen.m.Town=null;deny("tavern without a live town denied");townScreen.m.Town=::WeakTableRef(town);
town.alive=false;deny("destroyed tavern town denied");town.alive=true;
A.TavernTown=0;
expect(A.treatmentCheck(1,"MeleeSkill").ok,"manual F8 in the actual inn works without a remembered tavern token");
e.setScreen(e.getScreen("treatment_actor:1:4"));
local valueBeforeLeaving=first.properties.MeleeSkill,walletBeforeLeaving=::World.Assets.money;
townScreen.m.Visible=false;
expect(e.processInput(0)&&first.properties.MeleeSkill==valueBeforeLeaving&&::World.Assets.money==walletBeforeLeaving,
    "leaving the inn invalidates an already displayed purchase before charging");
expect(e.m.Notice.find("只能在酒馆内使用")!=null&&e.m.ActiveScreen.Options.len()==1,
    "stale click explains the tavern requirement and removes purchase buttons");
townScreen.m.Visible=true;
::safe=false;
foreach(offset in [0,4]) for(local i=0;i<4;i++) {
    local page="treatment_actor:1:"+offset,field=A.TreatmentAttributes[offset+i].field;
    e.setScreen(e.getScreen(page));
    local before=clone first.properties,wallet=::World.Assets.money;
    expect(e.processInput(i)&&e.m.ActiveScreen.ID==page,"tavern button stays on same attribute page");
    foreach(attribute in A.TreatmentAttributes)
        expect(first.properties[attribute.field]==before[attribute.field]+(attribute.field==field?1:0),
            "tavern click increases only the selected attribute");
    expect(::World.Assets.money==wallet-100,"tavern click charges exactly 100");
    expect(e.m.Notice.find("本次花费 100")!=null
        &&e.m.ActiveScreen.Text.find(e.m.Notice)<e.m.ActiveScreen.Text.find("当前基础属性"),
        "payment receipt is visible above the attribute list");
}
expect(A.ledgerPage(e,"treatment").Text.find("仅限酒馆内参加")!=null,"tavern instructions explain the location rule");
::World.Assets.money=99;
e.setScreen(e.getScreen("treatment_actor:1:4"));
local fieldValue=first.properties.MeleeSkill;
e.processInput(0);
expect(first.properties.MeleeSkill==fieldValue&&::World.Assets.money==99,"failed tavern click keeps attributes and funds");
expect(e.m.Notice.find("克朗不足")!=null
    &&e.m.ActiveScreen.Text.find(e.m.Notice)<e.m.ActiveScreen.Text.find("当前基础属性"),
    "actual insufficient-funds reason appears above the attribute list inside the inn");
::World.Assets.money=10000;::safe=true;
::Tactical.Active=true; deny("combat denied"); ::Tactical.Active=false;
::World.State.transition=1; deny("combat transition denied"); ::World.State.transition=0;
::Tactical.State <- {};deny("tactical lifecycle still active denied");::Tactical.State=null;
local worldState=::World.State;::World.State=null;deny("world state not ready denied");::World.State=worldState;
local worldPlayer=::World.State.player;::World.State.player=null;deny("world player not ready denied");::World.State.player=worldPlayer;
::LoadingScreen <- {visible=false,animating=false,isVisible=function(){return this.visible;},isAnimating=function(){return this.animating;}};
::LoadingScreen.visible=true;deny("loading screen denied");::LoadingScreen.visible=false;
::LoadingScreen.animating=true;deny("loading animation denied");::LoadingScreen.animating=false;
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

// Native entity identifiers must round-trip as identifiers, independently of
// the nonnegative offsets used to paginate people and attributes.
foreach(id in [-2147483648,-12345,0,2147483647]) {
    ordinary.id=id;
    e.setScreen(e.getScreen("treatment_actor:"+id));
    expect(e.m.ActiveScreen.Text.find("普通雇员")!=null,"signed entity ID reaches its actor page");
    local value=ordinary.properties.MeleeSkill,wallet=::World.Assets.money;
    e.setScreen(e.getScreen("treatment_actor:"+id+":4"));
    expect(e.m.TreatmentOffer.actorId==id,"confirmation keeps native entity identifier");
    e.processInput(0);
    expect(ordinary.properties.MeleeSkill==value+1&&::World.Assets.money==wallet-100,
        "signed entity ID can purchase exactly one point");
    local stale=e.m.ActiveScreen.Options[0];
    e.processInput(0);
    expect(ordinary.properties.MeleeSkill==value+2&&::World.Assets.money==wallet-200,
        "repeat offer can purchase the same attribute again");
    stale.getResult(e);
    expect(ordinary.properties.MeleeSkill==value+2&&::World.Assets.money==wallet-200,
        "completed repeat offer cannot charge twice");
}
ordinary.id=40;
expect(A.treatmentActor("-12345garbage")==null&&A.treatmentActor("")==null,
    "malformed identifiers do not resolve to a different character");

// Use the game's event manager to cancel: no purchase callback is evaluated,
// the offer/draft are cleared, and exactly the event menu step is restored.
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
local manager=::event_manager,pops=0;
::World.Events <- manager;
::World.State.getMenuStack <- function(){return {pop=function(force){expect(force,"cancel uses native forced event pop");pops++;}};};
e.setScreen(e.getScreen("treatment_preview:1:MeleeSkill"));
local cancelled=e.m.ActiveScreen.Options[0],before=first.properties.MeleeSkill,wallet=::World.Assets.money;
e.m.Selected=[1,2];manager.m.ActiveEvent=e;manager.m.IsEventShown=true;
manager.processInput(-1);
cancelled.getResult(e);
expect(manager.m.ActiveEvent==null&&!manager.m.IsEventShown&&pops==1,"cancel clears native manager and one menu step");
expect(e.m.TreatmentOffer==null&&e.m.Selected.len()==0&&first.properties.MeleeSkill==before&&::World.Assets.money==wallet,
    "Escape discards draft and confirmation without buying a point");
e.setScreen(e.getScreen("treatment_preview:1:MeleeSkill")); oldOption=e.m.ActiveScreen.Options[0];
e.clear(); oldOption.getResult(e);
expect(first.properties.MeleeSkill==loaded.MeleeSkill && e.m.TreatmentOffer==null,"closing ledger invalidates unspent confirmation");
print("TESTS_PASSED="+checks+"\n");
