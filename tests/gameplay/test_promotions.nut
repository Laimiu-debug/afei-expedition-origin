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

dofile("src/scripts/mods/afeix/combat_feedback.nut");
::definitions <- {};
::nativeSkill <- {
    m = { ID = "", Name = "", Description = "", Icon = "", IconMini = "", IconDisabled = "", IsNew = true, Container = null, IsUsable = true, IsRemovedAfterBattle = false, IsSerialized = true,
        Type = 0, Order = 0, Overlay = "", IsActive = false, IsTargeted = false, IsStacking = false, IsAttack = false, IsVisibleTileNeeded = true,
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
        memory={}, key = key, alive = true, faction = faction, controlled = true, placed = true,
        level = 1, battles = 0, xp = 222, perks = ["perk.pathfinder"], gear = { body = "mail", hand = "sword" }, wounds = ["injury.cut_arm"], hp = 31,
        able = true, ap = 9, fatigue = 0, fatigueMax = 100, distance = distance,
        baseProperties = { Hitpoints = 50, Stamina = 90, Initiative = 90, MeleeSkill = 47, RangedSkill = 35, MeleeDefense = 2, RangedDefense = 3, Bravery = 39, DamageTotalMult = 1.0, DamageReceivedTotalMult = 1.0 },
        getID=function(){return this.distance*100+this.key.len();},getFatigue=function(){return this.fatigue;},
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
    ::day=1;
    ::state.origin = true; ::state.safe = true; ::state.town = true; ::state.tactical = false;
    ::state.roots = false; ::state.progress = 0; ::state.flags = {}; ::state.actor = makeActor();
    ::state.failNew = false; ::state.failAdd = false; ::state.failArt = false;
    ::state.actors = [::state.actor]; ::World.Assets.money = 5000;
    return ::state.actor;
}
function ready() { local a = fresh(); a.level = 7; a.battles = 6; ::AfeixExpedition.set("growth_done_afei", true); return a; }
function beginBattle() {
    ::state.tactical = true;
    foreach (actor in ::state.actors) foreach (id, skill in clone actor.skills.all) skill.onCombatStarted();
}
function endBattle() {
    foreach (actor in ::state.actors) foreach (id, skill in clone actor.skills.all) skill.onCombatFinished();
    ::state.tactical = false;
}

// Load production V2 definitions while retaining this isolated native-call fixture.
::day<-1;local adapter=::AfeixExpedition;
::include<-function(path){dofile("src/"+path+".nut");};::mods_registerMod<-function(...){};::mods_queue<-function(...){};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition;foreach(k,v in adapter)A[k]<-v;
::Math.min<-function(a,b){return a<b?a:b;};::Math.max<-function(a,b){return a>b?a:b;};
::World.getTime<-function(){return {Days=::day};};::round<-1;A.memberRound=function(){return ::round;};
A.catalogGet=function(a,k,fallback=0){return k in a.memory?a.memory[k]:fallback;};A.catalogSet=function(a,k,v){a.memory[k]<-v;return v;};
A.catalogMemory=function(a,create=false){return {m={State=a.memory}};};
A.memberPlayer=function(a){return a!=null&&a.alive&&a.placed&&a.controlled&&a.faction==1&&a.able;};
A.memberAllies=function(a,radius){local list=[];foreach(b in ::state.actors)if(b!=a&&this.memberPlayer(b)&&abs(a.distance-b.distance)<=radius)list.push(b);return list;};
local bro=fresh();expect(!A.promote("toad").ok,"level one rejects ordinary route");bro=ready();bro.battles=5;expect(!A.promote("toad").ok,"six actual battles required");bro.battles=6;
local stars=A.captureTalentState(bro),gear=bro.gear,wounds=bro.wounds,perks=bro.perks;
expect(A.promote("toad").ok&&::World.Assets.money==5000,"first promotion free at7/6");
expect(equalTalentData(stars.talents,bro.talents)&&equalTalentData(stars.attributes,bro.m.Attributes),"route does not change stars or pending rolls");
expect(bro.skills.derived.MeleeSkill==53&&bro.skills.derived.MeleeDefense==5&&bro.skills.derived.RangedDefense==6&&bro.skills.derived.DamageTotalMult==1.0,"toad V2 permanent stats");
local active=bro.skills.getSkillByID("actives.afeix_wawa");A.syncPromotion(bro);A.syncPromotion(bro);expect(bro.skills.getSkillByID(active.getID())==active&&bro.skills.all.len()==2,"synchronization keeps skill instance");
bro.level=9;::state.progress=12;expect(!A.promote("jiahao").ok,"respec seven day cooldown");::day=8;::World.Assets.money=1499;expect(!A.promote("jiahao").ok,"respec price required");::World.Assets.money=1500;
expect(A.promote("jiahao").ok&&::World.Assets.money==0,"respec pays1500 once");expect(!A.promote("jiahao").ok,"repeat route cannot charge");
expect(A.circleRate()==0.08&&bro.skills.derived.Bravery==49&&bro.skills.derived.MeleeSkill==47,"jiahao V2 stats and rate");
expect(bro.gear==gear&&bro.wounds==wounds&&bro.perks==perks&&equalTalentData(stars.attributes,bro.m.Attributes),"route change preserves possessions and upgrades");
::state.roots=true;bro.level=8;bro.battles=12;expect(!A.promote("feidie").ok,"hidden route level9");bro.level=9;bro.battles=11;expect(!A.promote("feidie").ok,"hidden route twelve battles");bro.battles=12;
expect(A.promote("feidie").ok&&::World.Assets.money==0,"first hidden route free with all gates");expect(A.circleRate()==0.05&&bro.skills.derived.MeleeSkill==50&&bro.skills.derived.MeleeDefense==4,"feidie uses its own modest stats");
foreach(failure in ["failNew","failAdd","failArt"]){bro=ready();A.promote("toad");bro.level=9;::state.progress=12;::day=8;::World.Assets.money=1500;local prior=bro.skills.getSkillByID("actives.afeix_wawa");prior.m.Used=true;::state[failure]=true;
 expect(!A.promote("jiahao").ok&&A.route()=="toad"&&::World.Assets.money==1500,"rollback route and wallet "+failure);
 expect(bro.skills.getSkillByID(prior.getID())==prior&&prior.m.Used&&bro.skills.all.len()==2,"rollback preserves exact prior instances "+failure);
 expect(A.promote("jiahao").ok&&::World.Assets.money==0,"retry succeeds "+failure);
}
foreach(route in ["toad","jiahao","feidie"]){
 bro=ready();if(route=="feidie"){bro.level=9;bro.battles=12;::state.roots=true;}
 expect(A.promote(route).ok,"prepare "+route);
 local close=makeActor("close",1,1),second=makeActor("second",1,2),extra=makeActor("extra",1,2),far=makeActor("far",1,3),enemy=makeActor("enemy",2,1),dead=makeActor("dead",1,1);dead.alive=false;
 ::state.actors=[bro,close,second,extra,far,enemy,dead];::round=1;beginBattle();active=bro.skills.getSkillByID(A.PromotionActiveIDs[route]);local price=route=="toad"?0:(route=="jiahao"?25:20),ap=route=="toad"?1:3,fat=route=="toad"?18:20;
 local before=::World.Assets.money;bro.ap=ap-1;expect(!active.use(null)&&::World.Assets.money==before,"native AP gate "+route);bro.ap=ap;
 expect(active.use(null)&&bro.ap==0&&bro.fatigue==fat&&::World.Assets.money==before-price,"native pays exactly once "+route);
 expect(!active.isUsable(),"cooldown immediately blocks reuse "+route);
 local loaded=::new(A.PromotionActivePaths[route]),io=stream();active.onSerialize(io);loaded.onDeserialize(io);bro.skills.removeAllByID(active.getID());bro.skills.add(loaded);active=loaded;
 expect(!active.isUsable()&&active.m.Used,"loading skill cannot reset actor budget "+route);
 if(route=="toad")expect(bro.skills.derived.MeleeSkill==61&&bro.skills.derived.MeleeDefense==0&&close.skills.all.len()==0,"permanent route6 plus temporary wawa8 minus defense5");
 else {local count=0;foreach(a in ::state.actors)if(a.skills.hasSkill(route=="jiahao"?"effects.afeix_haoqi":"effects.afeix_feidie"))count++;expect(count==3&&far.skills.all.len()==0&&enemy.skills.all.len()==0&&dead.skills.all.len()==0,"team cap and faction filters "+route);}
 local effect=bro.skills.getSkillByID(route=="toad"?"effects.afeix_wawa":(route=="jiahao"?"effects.afeix_haoqi":"effects.afeix_feidie"));
 if(route=="toad"){effect.onTurnStart();expect(!bro.skills.hasSkill(effect.getID()),"wawa expires next own start");}
 else {effect.onTurnEnd();expect(bro.skills.hasSkill(effect.getID()),"support survives the casting turn end");local phase=stream();effect.onSerialize(phase);effect.onDeserialize(phase);effect.onTurnStart();expect(bro.skills.hasSkill(effect.getID()),"support lasts through next own turn after loading");effect.onTurnEnd();expect(!bro.skills.hasSkill(effect.getID()),"support expires at next own end");}
 ::round=route=="toad"?4:5;bro.ap=9;bro.fatigue=0;expect(active.use(null),"second permitted use "+route);::round=12;bro.ap=9;bro.fatigue=0;expect(!active.isUsable(),"third use blocked "+route);
 endBattle();bro.memory.clear();beginBattle();expect(active.isUsable(),"new battle restores budget "+route);
}
print("TESTS_PASSED="+::passed+"\n");
