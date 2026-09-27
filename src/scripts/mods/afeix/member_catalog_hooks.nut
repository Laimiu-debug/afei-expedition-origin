local A=::AfeixExpedition;
A.CatalogCheckingTarget <- false;
A.catalogTargetAllowed <- function(s,origin,target){
    if(this.CatalogCheckingTarget||!this.isOrigin()||!::Tactical.isActive()||!this.catalogSingle(s)||target==null||!target.IsOccupiedByActor)return true;
    local actor=s.getContainer().getActor(),t=target.getEntity(),e=this.catalogFindEffect(t,"unselectable");
    if(actor.getFaction()==::Const.Faction.Player||e==null||!e.valid())return true;
    local other=false;this.CatalogCheckingTarget=true;
    try{
        foreach(b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))if(b!=t&&this.memberPlayer(b)&&s.isInRange(b.getTile(),origin)&&s.onVerifyTarget(origin,b.getTile())&&b.getTile().IsVisibleForEntity){other=true;break;}
    }catch(error){this.CatalogCheckingTarget=false;throw error;}
    this.CatalogCheckingTarget=false;return !other;
};
A.catalogSkillCode <- function(s){local n=7;foreach(c in s.getID())n=(n*31+c)&0x7fffffff;return n;};
A.catalogBeforeSkill <- function(s,tile){
    local a=s.getContainer().getActor();
    if(a==null||!a.isAlive()||!a.isPlacedOnMap())return tile;
    this.catalogSet(a,"turn_used",1);
    if(!this.catalogSingle(s))return tile;
    this.catalogRemove(a,"unselectable");
    this.catalogSet(a,"attempt_serial",this.catalogGet(a,"attempt_serial")+1);
    this.catalogSet(a,"attempt_target",tile!=null&&tile.IsOccupiedByActor?tile.getEntity().getID():0);
    this.catalogSet(a,"attempt_ammo",this.catalogThrowing(a)?a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getAmmo():0);
    if(a.getFaction()!=::Const.Faction.Player){
        local code=this.catalogSkillCode(s),last=this.catalogGet(a,"last_weapon");
        if(code==last)foreach(b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
            if(this.memberPlayer(b)&&this.catalogHas(b,"know_rules")&&b.getTile().getDistanceTo(a.getTile())<=4&&!a.isHiddenToPlayer()&&this.catalogOnce(b,"insight_round"))
                this.catalogSet(b,"insight",::Math.min(2,this.catalogGet(b,"insight")+1));
        this.catalogSet(a,"last_weapon",code);
        if(!s.isRanged()&&tile!=null&&tile.IsOccupiedByActor){
            local e=this.catalogFindEffect(tile.getEntity(),"cover_up");
            if(e!=null&&e.valid()){
                local cover=e.source();
                if(cover!=null&&s.isInRange(cover.getTile())&&s.onVerifyTarget(a.getTile(),cover.getTile())){
                    e.m.Consumed=true;this.catalogSet(cover,"cover_attacker",a.getID());this.catalogSet(cover,"cover_serial",this.catalogGet(a,"attempt_serial"));
                    this.catalogSet(a,"attempt_target",cover.getID());return cover.getTile();
                }
            }
        }
    }
    return tile;
};
A.catalogAfterSkill <- function(s,result){
    if(!result)return;
    local a=s.getContainer().getActor();
    if(this.characterId(a)!="afei"||["actives.afeix_haoqi","actives.afeix_feidie"].find(s.getID())==null)return;
    foreach(b in this.memberAllies(a,3))if(this.catalogHas(b,"fear_afei")&&!this.catalogGet(b,"fear_used")){
        this.catalogSet(b,"fear_used",1);this.catalogSet(b,"fear_penalty",1);this.catalogSet(b,"fear_round",this.memberRound());this.catalogRecover(b,8);
    }
};
// skill is a native bare table. Hook its derived definitions, wrapping each
// original member only once; retain native range, payment and damage code.
local wrapped={};
local wrapOnce=function(o,name,make){
    local current=::mods_getMember(o,name);if(current in wrapped)return;
    local replacement=make(current);wrapped[replacement]<-true;::mods_override(o,name,replacement);
};
::mods_hookBaseClass("skills/skill",function(o){
    wrapOnce(o,"onVerifyTarget",function(original){return function(origin,tile){
        return original.bindenv(this)(origin,tile)&&::AfeixExpedition.catalogTargetAllowed(this,origin,tile);
    };});
    wrapOnce(o,"getFatigueCost",function(original){return function(){
        local cost=original.bindenv(this)(),A=::AfeixExpedition;
        if(!A.isOrigin()||!::Tactical.isActive()||this.getContainer()==null)return cost;
        local a=this.getContainer().getActor(),cut=A.catalogDiscount(a,this);
        if(this.getID()=="actives.afeix_member_snake_trial"&&A.catalogHas(a,"next_path")&&A.catalogGet(a,"turn_hit_target")>0)cut=::Math.max(cut,4);
        return ::Math.max(0,cost-cut);
    };});
    wrapOnce(o,"use",function(original){return function(tile,free=false){
        local A=::AfeixExpedition;
        if(!A.isOrigin()||!::Tactical.isActive())return original.bindenv(this)(tile,free);
        if(!this.isUsable()||(!free&&!this.isAffordable()))return false;
        if(this.isTargeted()&&(tile==null||(this.m.IsVisibleTileNeeded&&!tile.IsVisibleForEntity)||!this.isInRange(tile)||!this.onVerifyTarget(this.getContainer().getActor().getTile(),tile)))return false;
        local target=A.catalogBeforeSkill(this,tile),result=original.bindenv(this)(target,free);
        A.catalogAfterSkill(this,result);return result;
    };});
});
::mods_hookExactClass("entity/tactical/actor",function(o){
    local start=o.onTurnStart;
    o.onTurnStart=function(){::AfeixExpedition.catalogTurnStart(this);return start.bindenv(this)();};
    // Navigator teleports may finish asynchronously. Count paid walking steps,
    // never infer a normal step from a temporary global teleport flag.
    local step=o.onMovementStep,undo=o.onMovementUndo;
    o.onMovementStep=function(tile,levelDifference){
        local result=step.bindenv(this)(tile,levelDifference),A=::AfeixExpedition;
        if(result&&A.isOrigin()&&::Tactical.isActive())A.catalogSet(this,"ordinary_pending",A.catalogGet(this,"ordinary_pending")+1);
        return result;
    };
    o.onMovementUndo=function(tile,levelDifference){
        local result=undo.bindenv(this)(tile,levelDifference),A=::AfeixExpedition;
        if(A.isOrigin()&&::Tactical.isActive())A.catalogSet(this,"ordinary_pending",::Math.max(0,A.catalogGet(this,"ordinary_pending")-1));
        return result;
    };
    local move=o.onMovementFinish;
    o.onMovementFinish=function(tile){
        local A=::AfeixExpedition,result=move.bindenv(this)(tile);
        if(A.isOrigin()&&::Tactical.isActive()){
            local pending=A.catalogGet(this,"ordinary_pending");
            A.catalogSet(this,"ordinary_pending",0);A.catalogMoved(this,pending);
        }
        return result;
    };
});
::mods_hookExactClass("entity/tactical/player",function(o){
    local begin=o.onCombatStart;
    o.onCombatStart=function(){
        if(::AfeixExpedition.isOrigin())::AfeixExpedition.catalogMemory(this,true);
        return begin.bindenv(this)();
    };
});
