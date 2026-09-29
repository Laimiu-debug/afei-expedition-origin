// Use the installed game's real skill.use, costs, range checks and persistence.
// Only engine visuals and attack resolution are replaced; this is not an engine run.
::Const <- { SkillType={None=0,Active=1,StatusEffect=2,Trait=4,Terrain=8,Special=16}, SkillOrder={Any=0,OffensiveTargeted=1,NonTargeted=2,Trait=100},
    Faction={Player=1}, MoraleState={Fleeing=0,Breaking=1,Wavering=2,Steady=4}, MoraleCheckType={MentalAttack=0}, ProjectileType={None=0}, SkillCounter=0,
    ItemSlot={Mainhand=0,Offhand=1,Body=2,Head=3,Accessory=4}, Items={WeaponType={Throwing=1},ItemType={Shield=1,MeleeWeapon=2,OneHanded=4,TwoHanded=8,Food=16}},
    EntityType={OrcYoung=10,GoblinFighter=11}, Injury={CuttingBody=[],CuttingHead=[]},
    Combat={WeaponSpecFatigueMult=0.75}, BodyPart={Body=0,Head=1},
    Tactical={AttackEffectChop=0,AttackEffectBash=0,HitInfo={DamageRegular=0,DamageArmor=0,DamageDirect=0,BodyPart=0,BodyDamageMult=1.0,FatalityChanceMult=1.0}}
};
::Math <- { min=function(a,b){return a<b?a:b;},max=function(a,b){return a>b?a:b;},
    minf=function(a,b){return a<b?a:b;},maxf=function(a,b){return a>b?a:b;}, abs=function(v){return ::abs(v);},
    ceil=function(v){return ::ceil(v);},floor=function(v){return ::floor(v);},round=function(v){return ::floor(v+0.5);},rand=function(a,b){return a;} };
::state <- {origin=true,tactical=false,round=1,actors=[],serial=0,hit=true,attacks=[],flags={}};
::Time <- {getRound=function(){return ::state.round;}};
::Tactical <- {isActive=function(){return ::state.tactical;},
    worldToTile=function(v){return v;},getTile=function(v){return {Level=0};},
    Entities={getInstancesOfFaction=function(f){local r=[];foreach(a in ::state.actors)if(a.faction==f)r.push(a);return r;}},
    getEntityByID=function(id){foreach(a in ::state.actors)if(a.id==id)return a;return null;}};
::isKindOf <- function(a,kind){return a.human && kind=="human";};
::logDebug <- function(t){};
::WeakTableRef <- function(t){return t;};
::createVec <- function(x,y){return {X=x,Y=y};};
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){};
::mods_queue <- function(...){};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
::AfeixExpedition.isOrigin=function(){return ::state.origin;};
::AfeixExpedition.get=function(k,fallback=0){return k in ::state.flags?::state.flags[k]:fallback;};
::AfeixExpedition.set=function(k,v){::state.flags[k]<-v;return v;};
::AfeixExpedition.characterId=function(a){return a.key;};
::AfeixExpedition.syncRosterTalents=function(a){};
::productionSyncBalance <- ::AfeixExpedition.syncBalance;
::AfeixExpedition.syncBalance=function(a){}; // V2 base/traits covered separately by test_balance_v26.nut.
::AfeixExpedition.syncPersonalGrowth=function(a){};
::AfeixExpedition.syncPromotion=function(a){};
::AfeixExpedition.syncCharacterArt=function(a){};
::definitions <- {};
dofile(".cache/afei-art/native-contract-fixture/skill.nut");
::definitions["scripts/skills/skill"] <- ::skill;
function loadDefinition(path) {
    if(path in ::definitions)return ::definitions[path];
    local pieces=split(path,"/"),name=pieces[pieces.len()-1];
    if(["chop","split_man","rotation","taunt","character_trait"].find(name)!=null)dofile(".cache/afei-art/native-contract-fixture/"+name+".nut");
    else dofile("src/"+path+".nut");
    ::definitions[path]<-getroottable()[name];return ::definitions[path];
}
::inherit <- function(path,data) {
    local parent=loadDefinition(path),r=clone parent;r.m=clone parent.m;
    foreach(k,v in data)if(k=="m"){foreach(mk,mv in v)r.m[mk]<-mv;}else r[k]<-v;
    local p=split(path,"/");r[p[p.len()-1]]<-parent;
    if("catalogTestHook" in getroottable())::catalogTestHook(path,r);
    return r;
};
getroottable()["new"] <- function(path) {
    local definition=loadDefinition(path),o=clone definition;o.setdelegate(getroottable());o.m=clone definition.m;
    foreach(k,v in definition)if(typeof v=="table"&&k!="m"){
        local baseProps={};foreach(bk,bv in v)if(typeof bv=="function")baseProps[bk]<-bv.bindenv(o);o[k]=baseProps;
    }
    o.spawnOverlay=function(...){};o.spawnAttackEffect=function(...){};
    o.create();o.m.SoundOnUse=[];
    return o;
};
function properties() {return {MeleeSkill=60,RangedSkill=50,MeleeDefense=10,RangedDefense=8,Bravery=50,Initiative=100,
    RerollMoraleChance=0,Vision=7,IsRooted=false,IsStunned=false,IsMovable=true,IsImmuneToRotation=false,IsImmuneToRoot=false,
    IsImmuneToKnockBackAndGrab=false,MoraleCheckBravery=[0],DamageReceivedRegularMult=1.0,
    FatigueRecoveryRate=15,FatigueEffectMult=1.0,FatigueOnSkillUse=0,SkillCostAdjustments=[],AdditionalActionPointCost=0,
    IsAbleToUseSkills=true,IsAbleToUseWeaponSkills=true,IsSkillUseFree=false,IsSkillUseHalfCost=false,
    IsImmuneToFearAndPanic=false,IsSpecializedInAxes=false,DamageArmorMult=1.0,MeleeDamageMult=1.0,
    DamageReceivedTotalMult=1.0,DamageRegularMin=40,DamageRegularMax=40,DamageRegularMult=1.0,DamageTotalMult=1.0,
    DamageDirectMult=1.0,DamageDirectAdd=0.0,DamageDirectMeleeAdd=0.0,DamageAgainstMult=[1.0,1.5]};}
function useLegacySkillFixture() {
    // Effect-only regression cases intentionally equip combinations. Production gating
    // is exercised without this override in test_member_training.nut.
    ::AfeixExpedition.catalogLearned=function(a,key){
        if(!this.isOrigin()||a==null)return false;
        local d=this.MemberSkillDefs[key];return !("growth" in d)||!d.growth||this.get("growth_done_"+d.owner,false);
    };
}
function makeActor(key,pos=0,faction=1) {
    local a={key=key,id=++::state.serial,pos=pos,faction=faction,alive=true,dying=false,placed=true,controlled=true,
        human=true,type=0,morale=4,ap=9,fatigue=0,fatigueMax=100,weapon=null,shield=null,props=properties(),baseProps=properties(),received=[],hp=100,
        getName=function(){return this.key;},getID=function(){return this.id;},getType=function(){return this.type;},
        isAlive=function(){return this.alive;},isDying=function(){return this.dying;},isPlacedOnMap=function(){return this.placed;},isAttackable=function(){return true;},
        getFaction=function(){return this.faction;},isPlayerControlled=function(){return this.controlled;},getMoraleState=function(){return this.morale;},
        isAlliedWith=function(b){return this.faction==b.faction;},getCurrentProperties=function(){return this.props;},
        isHiddenToPlayer=function(){return false;},getHitpoints=function(){return this.hp;},getHitpointsMax=function(){return 100;},
        getInitiative=function(){return this.props.Initiative;},setMoraleState=function(v){this.morale=v;},
        getActionPoints=function(){return this.ap;},setActionPoints=function(v){this.ap=v;},getFatigue=function(){return this.fatigue;},
        setFatigue=function(v){this.fatigue=v;},getFatigueMax=function(){return this.fatigueMax;},setPreviewSkillID=function(v){},
        getSkills=function(){return this.skills;},getItems=function(){return this.items;},getTile=function(){return this.tile;},
        onDamageReceived=function(user,s,hit){this.received.push(clone hit);}
    };
    a.level<-1;a.flags<-{values={},has=function(k){return k in this.values;},get=function(k){return this.values[k];},set=function(k,v){this.values[k]<-v;}};
    a.getLevel<-function(){return this.level;};a.getBaseProperties<-function(){return this.baseProps;};a.getFlags<-function(){return this.flags;};
    a.tile<-{owner=a,ID=100+a.id,Level=0,Pos={X=pos,Y=0},IsOccupiedByActor=true,IsEmpty=false,IsVisibleForEntity=true,IsVisibleForPlayer=true,
        getEntity=function(){return this.owner;},getDistanceTo=function(t){return abs(this.owner.pos-t.owner.pos);},
        hasNextTile=function(i){return i<this.owner.neighbors.len();},getNextTile=function(i){return this.owner.neighbors[i].tile;}};
    a.neighbors<-[];
    a.items<-{actor=a,getItemAtSlot=function(slot){return slot==0?this.actor.weapon:(slot==1?this.actor.shield:null);}};
    a.skills<-{actor=a,m={Skills=[]},busy=false,
        getActor=function(){return this.actor;},
        getSkillByID=function(id){foreach(s in this.m.Skills)if(!s.isGarbage()&&s.getID()==id)return s;return null;},
        hasSkill=function(id){return this.getSkillByID(id)!=null;},
        removeAllByID=function(id){foreach(s in clone this.m.Skills)if(s.getID()==id)s.removeSelf();this.update();},
        add=function(s){s.m.Container=this;this.m.Skills.push(s);this.update();},
        update=function(){
            if(this.busy)return;this.busy=true;local keep=[];foreach(s in this.m.Skills)if(!s.isGarbage())keep.push(s);this.m.Skills=keep;
            this.actor.props=clone this.actor.baseProps;this.actor.props.SkillCostAdjustments=[];
            this.actor.props.MoraleCheckBravery=clone this.actor.baseProps.MoraleCheckBravery;
            foreach(s in clone this.m.Skills)s.onUpdate(this.actor.props);
            foreach(s in clone this.m.Skills)s.onAfterUpdate(this.actor.props);this.busy=false;
        },
        buildPropertiesForUse=function(s,target){local p=clone this.actor.props;p.DamageAgainstMult=clone p.DamageAgainstMult;foreach(effect in clone this.m.Skills)if(!effect.isGarbage())effect.onAnySkillUsed(s,target,p);return p;},
        defense=function(attacker,s){local p=clone this.actor.props;foreach(e in this.m.Skills)if(!e.isGarbage())e.onBeingAttacked(attacker,s,p);return p;},
        damage=function(attacker,s){local p=clone this.actor.props;foreach(e in this.m.Skills)if(!e.isGarbage())e.onBeforeDamageReceived(attacker,s,{},p);return p;}
    };
    ::state.actors.push(a);return a;
}
function equip(a,two=false,shield=false) {
    a.weapon={mask=2|(two?8:4),uses=0,throwing=false,ammo=5,isNull=function(){return false;},isItemType=function(n){return (this.mask&n)!=0;},
        isWeaponType=function(n){return this.throwing&&n==1;},getAmmo=function(){return this.ammo;},onUse=function(s){this.uses++;if(this.throwing)this.ammo--;}};
    if(shield)a.shield={isItemType=function(n){return n==1;}};else a.shield=null;
    local s=::new("scripts/skills/actives/"+(two?"split_man":"chop"));s.m.Item=a.weapon;
    s.attackEntity=function(user,target){
        local p=user.skills.buildPropertiesForUse(this,target);::state.attacks.push({id=this.getID(),p=p});
        if(::state.hit){foreach(e in clone user.skills.m.Skills)if(!e.isGarbage())e.onTargetHit(this,target,::Const.BodyPart.Body,40,40);}
        else foreach(e in clone user.skills.m.Skills)if(!e.isGarbage())e.onTargetMissed(this,target);
        return ::state.hit;
    };
    a.skills.add(s);return s;
}
function event(a,name) {foreach(s in clone a.skills.m.Skills)if(!s.isGarbage())s[name]();a.skills.update();}
function fresh() {::state.origin=true;::state.tactical=true;::state.round=1;::state.actors=[];::state.hit=true;::state.attacks=[];::state.flags={};}
function active(a,key){return a.skills.getSkillByID("actives.afeix_member_"+key);}
function passive(a,key){return a.skills.getSkillByID("trait.afeix_member_"+key);}
function effect(a,key){return a.skills.getSkillByID("effects.afeix_member_"+key);}
function roundtrip(s,path) {
    local io={data=[],i=0,getMetaData=function(){return {getVersion=function(){return 99;}};},
        writeBool=function(v){this.data.push(v);},readBool=function(){return this.data[this.i++];},
        readU8=function(){return this.data[this.i++];},writeU8=function(v){this.data.push(v);},writeI32=function(v){this.data.push(v);},readI32=function(){return this.data[this.i++];},
        writeU16=function(v){this.data.push(v);},readU16=function(){return this.data[this.i++];},
        writeF32=function(v){this.data.push(v);},readF32=function(){return this.data[this.i++];},
        writeString=function(v){this.data.push(v);},readString=function(){return this.data[this.i++];}};
    s.onSerialize(io);local result=::new(path);result.onDeserialize(io);if(io.i!=io.data.len())throw "serialization left unread data";return result;
}
