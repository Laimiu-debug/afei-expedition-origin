// Runs actual story logic, trait and ledger against a small native-shaped world.
// Not a substitute for native save serialization, equipment callbacks or real combat.
::storyTestsPassed <- 0;
::logError <- function(text) {};
seterrorhandler(function(error) {});
function check(value, label) {
    if (!value) throw "FAIL " + label;
    ::storyTestsPassed++;
}
function flags() {
    return { values = {}, has = function(key) { return key in this.values; },
        get = function(key) { return this.values[key]; }, set = function(key, value) { this.values[key] <- value; } };
}
::Const <- { ItemSlot = { None = -1, Mainhand = 0, Offhand = 1, Body = 2, Head = 3, Accessory = 4, Bag = 5 } };
::Math <- { min = function(a,b) { return a < b ? a : b; } };
::storyState <- { origin = true, tactical = false, town = true, camping = false, combat = 0, threats = [],
    failSkill = false, failRemove = false, removeThrowsAfter = false, serial = 0, itemSerial = 0, formations = 0, rewardThrows = false };
::inherit <- function(path, object) {
    check(path == "scripts/skills/traits/character_trait", "personal trait inherits native trait");
    object.m = { ID = "", Name = "", Icon = "", Description = "", Titles = [], Excluded = [], Owner = null };
    object.character_trait <- { create = function() {} };
    object.getContainer <- function() { return this.m.Owner; };
    object.getID <- function() { return this.m.ID; };
    return object;
};
dofile("src/scripts/skills/traits/afeix_personal_trait.nut");
getroottable()["new"] <- function(path) {
    if (path != "scripts/skills/traits/afeix_personal_trait") throw "Unexpected creation " + path;
    local skill = clone ::afeix_personal_trait;
    skill.m = clone ::afeix_personal_trait.m;
    skill.create();
    return skill;
};
function item(slot) {
    return {
        id = ++::storyState.itemSerial, desired = slot, current = -1, condition = 53, custom = "saved-item",
        getInstanceID = function() { return this.id; }, getCurrentSlotType = function() { return this.current; },
        isInBag = function() { return this.current == ::Const.ItemSlot.Bag; }, isEquipped = function() { return this.current >= 0 && !this.isInBag(); }
    };
}
function makeInventory() {
    local result = {
        data = [[null], [null], [null], [null], [null], [null,null,null,null]],
        getData = function() { return this.data; },
        getAllItems = function() { local items=[]; foreach(slot in this.data) foreach(it in slot) if(it!=null&&it!=-1)items.push(it); return items; },
        equip = function(it) { if(it.current!=-1||this.data[it.desired][0]!=null)return false; this.data[it.desired][0]=it;it.current=it.desired;return true; },
        addToBag = function(it, index=-1) {
            if(it.current!=-1)return false;
            if(index<0)index=this.data[5].find(null);
            if(index==null||this.data[5][index]!=null)return false;
            this.data[5][index]=it;it.current=5;return true;
        },
        unequip = function(it) {
            if(it.current<0||it.current==5)return false;
            local slot=it.current,index=this.data[slot].find(it);
            if(index==null)return false;
            this.data[slot][index]=null;it.current=-1;return true;
        },
        removeFromBag = function(it) {
            local index=this.data[5].find(it);
            if(index==null)return false;
            this.data[5][index]=null;it.current=-1;return true;
        }
    };
    return result;
}
function makeBrother(key, level=3, battles=3) {
    local f = flags();
    if(key!=null)f.set("afeix_character",key);
    local bro = {
        id=++::storyState.serial, level=level, alive=true, xp=777, hp=17, injury="saved-injury", place=22,
        stats={Battles=battles}, inventory=makeInventory(),
        baseProps={Hitpoints=50,Stamina=100,Bravery=40,Initiative=100,MeleeSkill=50,RangedSkill=40,MeleeDefense=5,RangedDefense=5},
        current=null, skills=null,
        getID=function(){return this.id;},getFlags=function(){return f;},isAlive=function(){return this.alive;},
        getLevel=function(){return this.level;},getXP=function(){return this.xp;},getLifetimeStats=function(){return this.stats;},
        getSkills=function(){return this.skills;},getItems=function(){return this.inventory;},
        getPlaceInFormation=function(){return this.place;},setPlaceInFormation=function(p){this.place=p;},
        getNameOnly=function(){return key==null?"ordinary":key;}
    };
    bro.current=clone bro.baseProps;
    bro.skills = {
        owner=bro,list=[],
        getActor=function(){return this.owner;},
        getSkillByID=function(id){foreach(s in this.list)if(s.getID()==id)return s;return null;},
        add=function(s){s.m.Owner=this;this.list.push(s);},
        update=function(){
            if(::storyState.failSkill)throw "Injected skill update failure";
            this.owner.current=clone this.owner.baseProps;
            foreach(s in this.list)s.onUpdate(this.owner.current);
        }
    };
    ::testRoster.brothers.push(bro);
    if(key!=null)::World.Flags.set("afeix_ever_"+key,true);
    return bro;
}
function makeStash(capacity=20) {
    return {
        items=array(capacity,null),adds=0,failAt=-1,throwAfter=false,
        getItems=function(){return this.items;},
        getNumberOfEmptySlots=function(){local n=0;foreach(it in this.items)if(it==null)n++;return n;},
        add=function(it){
            this.adds++;
            if(this.adds==this.failAt&&!this.throwAfter)return null;
            local index=this.items.find(null);if(index==null)return null;
            this.items[index]=it;
            if(this.adds==this.failAt&&this.throwAfter)throw "Injected onAddedToStash failure";
            return index;
        },
        remove=function(it){local index=this.items.find(it);if(index==null)return null;this.items[index]=null;return it;}
    };
}
::testRoster <- {
    brothers=[],
    getAll=function(){return this.brothers;},
    remove=function(bro){
        if(::storyState.failRemove)return;
        local index=this.brothers.find(bro);if(index!=null)this.brothers.remove(index);
        if(::storyState.removeThrowsAfter)throw "Injected error after native removal";
    }
};
::testTown <- {
    isAlive=function(){return true;},isMilitary=function(){return false;},isAlliedWithPlayer=function(){return true;},
    getTile=function(){return {getDistanceTo=function(tile){return 1;}};}
};
::Tactical <- { isActive=function(){return ::storyState.tactical;} };
::World <- {
    Flags=flags(),getPlayerRoster=function(){return ::testRoster;},
    getAllEntitiesAtPos=function(pos,radius){return ::storyState.threats;},
    EntityManager={getSettlements=function(){return ::storyState.town?[::testTown]:[];}},
    State={
        getPlayer=function(){return {getPos=function(){return {};},getTile=function(){return {};}};},
        getCombatStartTime=function(){return ::storyState.combat;},isCampingAllowed=function(){return true;},
        updateTopbarAssets=function(){}
    },
    Assets={
        money=1000,ammo=20,tools=20,medicine=10,ammoMax=100,toolsMax=100,medicineMax=100,stash=makeStash(),
        getOrigin=function(){return {getID=function(){return ::storyState.origin?"scenario.afeix_expedition":"scenario.early_access";}};},
        isCamping=function(){return ::storyState.camping;},
        getMoney=function(){return this.money;},getAmmo=function(){return this.ammo;},getArmorParts=function(){return this.tools;},getMedicine=function(){return this.medicine;},
        setMoney=function(n){this.money=n;},setAmmo=function(n){this.ammo=n;},setArmorParts=function(n){this.tools=n;},setMedicine=function(n){this.medicine=n;},
        addMoney=function(n){this.money+=n;if(::storyState.rewardThrows)throw "Injected reward error";},
        addAmmo=function(n){this.ammo=::Math.min(this.ammo+n,this.ammoMax);if(::storyState.rewardThrows)throw "Injected reward error";},
        addArmorParts=function(n){this.tools=::Math.min(this.tools+n,this.toolsMax);if(::storyState.rewardThrows)throw "Injected reward error";},
        addMedicine=function(n){this.medicine=::Math.min(this.medicine+n,this.medicineMax);if(::storyState.rewardThrows)throw "Injected reward error";},
        getStash=function(){return this.stash;}
    }
};
::AfeixExpedition <- {Schema=3,RosterMax=40,CombatMax=10};
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/quests.nut");
dofile("src/scripts/mods/afeix/roster.nut");
dofile("src/scripts/mods/afeix/story_progress.nut");
dofile("src/scripts/mods/afeix/promotions.nut");
dofile("src/scripts/mods/afeix/discovery.nut");
dofile("src/scripts/mods/afeix/ledger.nut");
dofile("src/scripts/mods/afeix/story_ledger.nut");
::AfeixExpedition.enforceFormation <- function(){::storyState.formations++;};
::AfeixExpedition.deployedIds <- function(){return [];};
function resetStory() {
    ::World.Flags.values={};::testRoster.brothers=[];::World.Assets.stash=makeStash();
    ::World.Assets.money=1000;::World.Assets.ammo=20;::World.Assets.tools=20;::World.Assets.medicine=10;
    ::World.Assets.ammoMax=100;::World.Assets.toolsMax=100;::World.Assets.medicineMax=100;
    ::storyState.origin=true;::storyState.tactical=false;::storyState.town=true;::storyState.camping=false;::storyState.combat=0;::storyState.threats=[];
    ::storyState.failSkill=false;::storyState.failRemove=false;::storyState.removeThrowsAfter=false;::storyState.formations=0;::storyState.rewardThrows=false;
}
function stock() {local a=::World.Assets;return [a.money,a.ammo,a.tools,a.medicine];}
function same(a,b){if(a.len()!=b.len())return false;foreach(i,x in a)if(b[i]!=x)return false;return true;}
function prepareFarewell() {
    resetStory();
    local A=::AfeixExpedition,afei=makeBrother("afei",7,9),bottle=makeBrother("bottle",5,7);
    A.set("growth_done_bottle",true);A.set("growth_choice_bottle",0);
    for(local slot=0;slot<5;slot++)bottle.inventory.equip(item(slot));
    bottle.inventory.addToBag(item(0),0);bottle.inventory.addToBag(item(0),2);
    return {afei=afei,bottle=bottle,records=A.bicycleInventorySnapshot(bottle)};
}
function checkEquipmentRestored(pair,label) {
    check(::AfeixExpedition.findCharacter("bottle")==pair.bottle,label+" same actor");
    foreach(r in pair.records) {
        check(pair.bottle.inventory.data[r.slot][r.index]==r.item,label+" exact slot");
        check(r.item.condition==53&&r.item.custom=="saved-item",label+" item properties");
        check(::World.Assets.stash.items.find(r.item)==null,label+" no duplicate stash");
    }
    check(::AfeixExpedition.get("bicycle_state")==0,label+" choice remains pending");
    check(!::AfeixExpedition.get("departed_bottle",false),label+" not departed");
}
function runStoryTests() {
    local A=::AfeixExpedition;
    check(A.MemberGrowth.len()==34,"all 34 growth records");
    foreach(key in A.CharacterOrder) foreach(choice in [0,1]) {
        resetStory();local bro=makeBrother(key,1,0),initial=clone bro.baseProps;
        check(A.growthStatus(key)=="locked",key+" locked initially");
        check(A.syncPersonalGrowth(bro)&&bro.skills.list.len()==1,key+" install single personality");
        foreach(field,value in initial)check(bro.current[field]==value,key+" no opening stat bonus");
        bro.level=3;bro.stats.Battles=2;
        check(A.growthStatus(key)=="locked",key+" reserves cannot replace real battles");
        bro.stats.Battles=3;
        check(A.growthStatus(key)=="ready",key+" ready at level and battles");
        local result=A.resolveGrowth(key,choice),bonus=A.MemberGrowth[key].choices[choice].bonuses;
        check(result.ok&&A.get("growth_done_"+key,false)&&A.get("growth_choice_"+key,-1)==choice,key+" stores selected outcome");
        foreach(field,value in initial) {
            check(bro.baseProps[field]==value,key+" base unchanged");
            check(bro.current[field]==value+(field in bonus?bonus[field]:0),key+" actual trait property update");
        }
        check(bro.xp==777&&bro.hp==17&&bro.injury=="saved-injury"&&bro.place==22,key+" progress injury reserve preserved");
        check(!A.resolveGrowth(key,1-choice).ok,key+" cannot switch or claim twice");
        A.syncPersonalGrowth(bro);A.syncPersonalGrowth(bro);
        check(bro.skills.list.len()==1,key+" duplicate sync no duplicate trait");
        foreach(field,value in bonus)check(bro.current[field]==initial[field]+value,key+" no refresh stacking");
        dofile("src/scripts/mods/afeix/story_progress.nut");A.syncPersonalGrowth(bro);
        check(A.growthStatus(key)=="done"&&!A.resolveGrowth(key,choice).ok,key+" world flags survive logic reload");
    }
    resetStory();local bro=makeBrother("afei");
    check(!A.resolveGrowth("afei",-1).ok&&!A.resolveGrowth("afei",2).ok&&!A.resolveGrowth("afei","0").ok,"invalid growth choice atomic");
    check(A.growthStatus(null)=="unavailable"&&!A.resolveGrowth(null,0).ok,"unknown growth key");
    ::storyState.tactical=true;check(!A.resolveGrowth("afei",0).ok&&!A.get("growth_done_afei",false),"combat blocks growth");
    ::storyState.tactical=false;::storyState.combat=1;check(!A.resolveGrowth("afei",0).ok,"pending battle blocks growth");
    ::storyState.combat=0;::storyState.town=false;check(!A.resolveGrowth("afei",0).ok,"unsafe road blocks growth");
    ::storyState.camping=true;check(A.resolveGrowth("afei",0).ok,"safe camp permits growth");
    resetStory();bro=makeBrother("afei");bro.alive=false;check(!A.resolveGrowth("afei",0).ok,"dead actor cannot grow");
    bro.alive=true;A.set("dead_afei",true);check(!A.resolveGrowth("afei",0).ok,"dead world flag blocks stale live reference");
    resetStory();bro=makeBrother("afei");::testRoster.brothers=[];check(!A.resolveGrowth("afei",0).ok,"departed actor cannot grow");
    resetStory();bro=makeBrother("afei");::storyState.failSkill=true;
    check(!A.resolveGrowth("afei",0).ok&&!A.get("growth_done_afei",false)&&A.get("growth_choice_afei",-1)==-1,"failed trait update leaves growth pending");
    ::storyState.failSkill=false;check(A.resolveGrowth("afei",1).ok,"retry after trait failure");
    resetStory();local ordinary=makeBrother(null);
    check(!A.syncPersonalGrowth(ordinary)&&ordinary.skills.list.len()==0&&A.personalBonuses(ordinary).len()==0,"ordinary mercenary untouched");
    local nativeId=A.characterId;A.characterId=function(b){return null;};
    check(!A.syncPersonalGrowth(ordinary)&&A.personalBonuses(ordinary).len()==0,"null identity remains no-op");
    local orphanTrait=::new("scripts/skills/traits/afeix_personal_trait");orphanTrait.m.Owner=ordinary.skills;
    check(orphanTrait.getName()=="伙伴的这一程"&&orphanTrait.getDescription()!=null,"trait null identity safe");
    A.characterId=nativeId;
    ::storyState.origin=false;
    check(!A.syncPersonalGrowth(ordinary)&&A.personalBonuses(ordinary).len()==0&&!A.rootsUnlocked(),"other origins isolated");

    resetStory();A.set("paid_contracts",2);
    check(A.rootStatus("er_xiaoyuan")=="locked"&&!A.triggerRoot("er_xiaoyuan").ok,"contact threshold three");
    A.set("paid_contracts",3);check(A.rootStatus("er_xiaoyuan")=="ready"&&A.rootStatus("er_haman")=="locked","first contact only at three");
    A.set("paid_contracts",6);check(A.rootStatus("er_haman")=="ready"&&A.rootStatus("er_sige")=="locked","second contact at six");
    A.set("paid_contracts",9);::storyState.town=false;::storyState.camping=true;
    check(!A.triggerRoot("er_sige").ok,"representatives need town even safe camp");
    A.set("ever_keke",true);A.set("dead_keke",true);
    check(A.triggerRoot("er_keke").ok,"deceased companion note opens at safe camp");
    check(::testRoster.brothers.len()==0&&!A.rootsUnlocked(),"notes never resurrect or alone unlock");
    ::storyState.town=true;
    foreach(id in A.RootOrder) {
        local data=A.RootStories[id];if(data.member!="")A.set("ever_"+data.member,true);
        check(A.triggerRoot(id).ok&&A.get("root_triggered_"+id,false),"trigger "+id);
    }
    check(A.rootsUnlocked(),"six openings unlock without any follow-up completions");
    foreach(id in A.RootOrder)check(!A.get("root_done_"+id,false),"completion remains separate "+id);
    local before=stock();
    foreach(id in A.RootOrder) {
        check(A.resolveRoot(id,0).ok,"root finite reward "+id);
        local after=stock();
        check(!A.resolveRoot(id,0).ok&&!A.resolveRoot(id,1).ok&&same(after,stock()),"root cannot farm or switch "+id);
        check(A.triggerRoot(id).ok&&same(after,stock()),"re-read opening does not reward "+id);
    }
    check(A.rootsUnlocked(),"finishing root does not remove eligibility");
    dofile("src/scripts/mods/afeix/story_progress.nut");check(A.rootsUnlocked()&&!A.resolveRoot("er_xiaoyuan",0).ok,"root flags survive reload");
    resetStory();A.set("paid_contracts",9);
    check(!A.resolveRoot("er_xiaoyuan",0).ok&&!A.get("root_triggered_er_xiaoyuan",false),"follow-up cannot replace opening");
    A.triggerRoot("er_xiaoyuan");before=stock();::storyState.rewardThrows=true;
    check(!A.resolveRoot("er_xiaoyuan",0).ok&&same(before,stock())&&!A.get("root_done_er_xiaoyuan",false),"throw after resource mutation rolls back");
    ::storyState.rewardThrows=false;check(A.resolveRoot("er_xiaoyuan",0).ok,"retry one-time reward after exception");
    foreach(pair in [["er_xiaoyuan",1,"tools","toolsMax"],["er_haman",0,"medicine","medicineMax"],["er_sige",0,"ammo","ammoMax"]]) {
        foreach(room in [0,1]) {
            resetStory();A.set("paid_contracts",9);A.triggerRoot(pair[0]);
            local assets=::World.Assets;assets[pair[3]]=assets[pair[2]]+room;before=stock();
            check(!A.resolveRoot(pair[0],pair[1]).ok&&same(before,stock()),"capacity full or partial restores supplies "+pair[2]);
            check(!A.get("root_done_"+pair[0],false)&&A.get("root_choice_"+pair[0],-1)==-1,"capacity failure keeps pending "+pair[2]);
            assets[pair[3]]=100;check(A.resolveRoot(pair[0],pair[1]).ok,"reward succeeds after freeing capacity "+pair[2]);
        }
    }
    resetStory();A.set("paid_contracts",9);A.triggerRoot("er_xiaoyuan");::storyState.tactical=true;before=stock();
    check(!A.resolveRoot("er_xiaoyuan",0).ok&&same(before,stock()),"unsafe root follow-up blocked");

    local pair=prepareFarewell();
    check(A.bicycleStatus()=="ready","bicycle level seven and bottle growth ready");
    check(!A.resolveBicycleDeparture(1).ok&&pair.bottle.inventory.getAllItems().len()==7,"departure needs confirmation");
    ::World.Assets.stash=makeStash(6);
    check(!A.resolveBicycleDeparture(1,true).ok,"full stash blocks before detachment");
    checkEquipmentRestored(pair,"full stash");
    pair=prepareFarewell();::World.Assets.stash.failAt=2;
    check(!A.resolveBicycleDeparture(1,true).ok,"partial transfer null failure blocks departure");
    checkEquipmentRestored(pair,"partial null");
    pair=prepareFarewell();::World.Assets.stash.failAt=2;::World.Assets.stash.throwAfter=true;
    check(!A.resolveBicycleDeparture(1,true).ok,"partial stash callback exception blocks departure");
    checkEquipmentRestored(pair,"partial throw");
    pair=prepareFarewell();::storyState.failRemove=true;
    check(!A.resolveBicycleDeparture(1,true).ok,"failed roster removal rolls inventory back");
    checkEquipmentRestored(pair,"roster failure");
    pair=prepareFarewell();::storyState.town=false;::storyState.camping=true;
    check(!A.resolveBicycleDeparture(0).ok&&!A.resolveBicycleDeparture(1,true).ok,"farewell requires town");
    pair=prepareFarewell();
    check(A.resolveBicycleDeparture(0).ok&&A.bicycleStatus()=="kept","retention branch completes without removal");
    check(A.findCharacter("bottle")==pair.bottle&&pair.bottle.inventory.getAllItems().len()==7&&pair.bottle.xp==777,"retention preserves entity items xp");
    check(!A.resolveBicycleDeparture(1,true).ok&&!A.get("bicycle_reward_granted",false),"cannot change retention to farming departure");
    foreach(choice in [0,1]) {
        pair=prepareFarewell();before=stock();
        if(choice==1)::storyState.removeThrowsAfter=true;
        check(A.resolveBicycleDeparture(1,true).ok,"complete equipment preserving farewell");
        check(A.findCharacter("bottle")==null&&A.get("ever_bottle",false)&&A.get("departed_bottle",false)&&!A.get("dead_bottle",false),"departed remains unique not dead");
        check(A.get("bicycle_bottle_actor_id")==pair.bottle.id&&A.get("bicycle_bottle_level")==5&&A.get("bicycle_bottle_xp")==777&&A.get("bicycle_returned_items")==7,"departure history saved");
        foreach(r in pair.records)check(::World.Assets.stash.items.find(r.item)!=null&&r.item.condition==53,"original equipment object retained");
        check(pair.bottle.inventory.getAllItems().len()==0&&same(before,stock()),"departure does not duplicate items or pay money");
        check(!A.resolveBicycleMemory(choice).ok,"cannot skip bicycle memory");
        check(A.readBicycleMemory().ok&&!A.readBicycleMemory().ok,"memory read once");
        check(A.resolveBicycleMemory(choice).ok&&A.bicycleStatus()=="done","bicycle final reward");
        local bonuses=A.personalBonuses(pair.afei);
        check(choice==0?bonuses.Bravery==4&&bonuses.Hitpoints==2:bonuses.Stamina==5&&bonuses.Initiative==3,"different modest bicycle choices");
        local actual=clone pair.afei.current;
        check(!A.resolveBicycleMemory(1-choice).ok&&!A.resolveBicycleDeparture(1,true).ok,"bicycle no repeated final reward");
        dofile("src/scripts/mods/afeix/story_progress.nut");A.syncPersonalGrowth(pair.afei);
        foreach(field,value in actual)check(pair.afei.current[field]==value,"bicycle reload no stacking");
        check(pair.afei.xp==777&&pair.afei.hp==17&&same(before,stock()),"bicycle preserves xp damage and currency");
        check(A.get("bicycle_owned")== (choice==0),"story vehicle ownership matches choice");
    }
    pair=prepareFarewell();pair.afei.level=6;check(!A.resolveBicycleDeparture(1,true).ok,"bicycle level threshold");
    pair=prepareFarewell();A.set("growth_done_bottle",false);check(!A.resolveBicycleDeparture(1,true).ok,"bicycle bottle growth required");
    pair=prepareFarewell();pair.bottle.alive=false;check(!A.resolveBicycleDeparture(1,true).ok,"dead bottle cannot depart");
    pair=prepareFarewell();A.resolveBicycleDeparture(1,true);A.readBicycleMemory();pair.afei.alive=false;
    check(!A.resolveBicycleMemory(0).ok&&!A.get("bicycle_reward_granted",false),"dead afei cannot claim memorial bonus");
    pair=prepareFarewell();A.resolveBicycleDeparture(1,true);A.readBicycleMemory();::storyState.failSkill=true;
    check(!A.resolveBicycleMemory(0).ok&&A.get("bicycle_state")==3&&!A.get("bicycle_reward_granted",false)&&A.get("bicycle_owned"),"failed memorial refresh rolls flags back");

    resetStory();local event={m={Notice="",Selected=[],FormationPage=0}},pages=["growth","member_growth","roots:0","roots:4","bicycle","bicycle_release_confirm","member_growth:unknown","member_growth_chapter:bad"];
    foreach(chapter in A.Chapters)foreach(offset in [0,4,8])pages.push("member_growth_chapter:"+chapter.id+":"+offset);
    foreach(key in A.CharacterOrder)pages.push("member_growth:"+key);
    foreach(id in A.RootOrder)pages.push("roots:"+id);
    foreach(page in pages) {
        local screen=A.storyLedgerPage(event,page);
        check(screen!=null&&screen.Options.len()<=6,"story screen six-button limit "+page);
        check(screen.Text.find("[img]")==null,"story screen leaves final wrapper to main ledger "+page);
    }
    check(A.storyLedgerPage(event,"not_a_story")==null,"unknown story page returns null");
    local mainHome=A.ledgerPage(event,"home"),homeGrowth=null;
    check(mainHome.Options.len()==4,"new campaign has no hidden story hub");
    foreach(option in mainHome.Options)if(option.getResult(event)=="growth")homeGrowth=option;
    check(homeGrowth==null,"new campaign hides story hub");
    foreach(page in ["growth","member_growth:afei","roots:er_xiaoyuan","bicycle"]) {
        event.m.Notice="STORY_INTEGRATION_NOTICE";
        local integrated=A.ledgerPage(event,page),raw=A.storyLedgerPage(event,page);
        check(integrated.ID==page&&integrated.Options.len()==raw.Options.len(),"main ledger dispatches story page "+page);
        local first=integrated.Text.find("[img]");
        check(first==0&&integrated.Text.find("[img]",first+5)==null,"story extension receives exactly one image wrapper "+page);
        check(integrated.Text.find("STORY_INTEGRATION_NOTICE")!=null&&raw.Text.find("STORY_INTEGRATION_NOTICE")==null,"main ledger adds action notice exactly at wrapper "+page);
    }
    event.m.Notice="";
    A.set("promotion_discovered",true);A.set("growth_seen_afei",true);A.set("ever_afei",true);A.set("root_triggered_er_xiaoyuan",true);A.set("bicycle_discovered",true);
    local hub=A.storyLedgerPage(event,"growth"),routes=[];
    foreach(option in hub.Options)routes.push(option.getResult(event));
    check(routes.find("promotion")!=null&&routes.find("member_growth")!=null&&routes.find("roots:0")!=null&&routes.find("bicycle")!=null&&routes.find("home")!=null,"hub exposes all required routes");
    resetStory();bro=makeBrother("afei");A.set("growth_seen_afei",true);
    local personal=A.storyLedgerPage(event,"member_growth:afei");
    check(personal.Options[0].getResult(event)=="member_growth:afei"&&A.get("growth_choice_afei",-1)==0,"growth UI captures choice and key");
    resetStory();A.set("paid_contracts",9);
    local rootPage=A.storyLedgerPage(event,"roots:er_xiaoyuan");
    check(!A.get("root_triggered_er_xiaoyuan",false),"viewing root entry does not trigger");
    check(rootPage.Text.find(A.RootStories.er_xiaoyuan.opening)==null,"unknown opening is sealed");
    check(A.revealDiscovery("roots:er_xiaoyuan"),"actual discovery reveals opening");
    check(A.get("root_triggered_er_xiaoyuan",false),"discovery event triggers root");
    rootPage=A.storyLedgerPage(event,"roots:er_xiaoyuan");rootPage.Options[1].getResult(event);
    check(A.get("root_choice_er_xiaoyuan",-1)==1,"root UI captures choice index");
}
try {
    runStoryTests();
    print("ALL_STORY_BEHAVIOR_CHECKS_PASS\nTESTS_PASSED="+::storyTestsPassed+"\n");
} catch(error) {
    print(error+"\n");
    throw error;
}
