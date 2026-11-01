local A=::AfeixExpedition;
A.CatalogContext <- null;
A.CatalogMoving <- false;
A.catalogLearned <- function(a,key) {
    if (!this.isOrigin() || a==null) return false;
    return this.trainingRank(a,key)>0;
};
A.catalogHas <- function(a,key) {
    if (!this.isOrigin() || a==null || !(key in this.MemberSkillDefs) || !this.catalogLearned(a,key)) return false;
    local d=this.MemberSkillDefs[key];
    return a.getSkills().hasSkill((d.active?"actives.":"trait.")+"afeix_member_"+key);
};
A.catalogMemory <- function(a,create=false) {
    local s=a.getSkills().getSkillByID("special.afeix_combat_memory");
    if (s==null && create) { s=::new("scripts/skills/special/afeix_combat_memory"); a.getSkills().add(s); }
    return s;
};
A.catalogGet <- function(a,key,fallback=0) { local s=this.catalogMemory(a);return s!=null && key in s.m.State?s.m.State[key]:fallback; };
A.catalogSet <- function(a,key,value) { this.catalogMemory(a,true).m.State[key] <- value; return value; };
A.catalogOnce <- function(a,key) { if(this.catalogGet(a,key,-1)==this.memberRound())return false;this.catalogSet(a,key,this.memberRound());return true; };
A.catalogRecover <- function(a,amount) {
    if(!this.memberPlayer(a))return 0;
    if(this.catalogGet(a,"recover_round",-1)!=this.memberRound()){this.catalogSet(a,"recover_round",this.memberRound());this.catalogSet(a,"recover_amount",0);}
    local n=::Math.max(0,::Math.min(amount,::Math.min(a.getFatigue(),8-this.catalogGet(a,"recover_amount"))));
    a.setFatigue(a.getFatigue()-n);this.catalogSet(a,"recover_amount",this.catalogGet(a,"recover_amount")+n);a.getSkills().update();return n;
};
A.catalogEnemies <- function(a) {
    local result=[];
    if(a==null||!a.isPlacedOnMap())return result;
    for(local i=0;i<6;++i)if(a.getTile().hasNextTile(i)){
        local tile=a.getTile().getNextTile(i);
        if(tile.IsOccupiedByActor){local b=tile.getEntity();if(b.isAlive()&&!b.isDying()&&!b.isAlliedWith(a))result.push(b);}
    }
    return result;
};
A.catalogNearbyPlayers <- function(target,radius){
    local list=[];
    // Native damage resolution can remove a killed target before onTargetHit.
    // getTile() on that entity throws inside the engine, rather than returning null.
    if(target==null||!target.isPlacedOnMap())return list;
    local tile=target.getTile();
    foreach(a in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))if(a!=target&&this.memberPlayer(a)&&a.getTile().getDistanceTo(tile)<=radius)list.push(a);
    return list;
};
A.catalogThrowing <- function(a) {
    local w=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    return w!=null && "isWeaponType" in w && w.isWeaponType(::Const.Items.WeaponType.Throwing);
};
A.catalogSingle <- function(s) {return s!=null && s.isAttack() && s.m.IsWeaponSkill && !s.isAOE() && s.getItem()!=null;};
A.catalogEffect <- function(target,key,source=null) {
    local id="effects.afeix_catalog_"+key,s=target.getSkills().getSkillByID(id);
    if(s==null){s=::new("scripts/skills/effects/afeix_catalog_effect");s.configure(key,source);target.getSkills().add(s);}
    else {s.configure(key,source);target.getSkills().update();if(s.m.Overlay!="")s.spawnIcon(s.m.Overlay,target.getTile());}
    return s;
};
A.catalogFindEffect <- function(a,key) {return a.getSkills().getSkillByID("effects.afeix_catalog_"+key);};
A.catalogRemove <- function(a,key) {a.getSkills().removeAllByID("effects.afeix_catalog_"+key);};
A.catalogNet <- function(a) {
    foreach(id in ["effects.net","effects.reinforced_net"])if(a.getSkills().hasSkill(id))return id;
    return null;
};
A.catalogMovable <- function(a) {
    local p=a.getCurrentProperties();
    return this.memberPlayer(a) && !p.IsRooted && !p.IsStunned && p.IsMovable && !p.IsImmuneToRotation;
};
A.catalogVirtual <- function(a,path) {local s=::new(path);s.setContainer(a.getSkills());return s;};
A.catalogGuard <- function(effect,properties,fields) {
    local target=effect.getContainer().getActor();
    foreach(field in fields){
        local prior=0;
        foreach(key in ["borrow_strike","steady_hand","guard_nest","pokemon"]){
            local s=target.getSkills().getSkillByID("effects.afeix_member_"+key);
            if(s!=null&&s.valid())prior=::Math.max(prior,s.bonus(field));
        }
        local best=null,amount=prior;
        foreach(s in target.getSkills().m.Skills)if(!s.isGarbage()&&"CatalogEffect" in s.m&&s.valid()){
            local n=s.bonus(field);if(n>amount){amount=n;best=s;}
        }
        if(field=="MeleeDefense")amount=::Math.min(8,amount);
        if(best==effect)properties[field]+=::Math.max(0,amount-prior);
    }
};
A.catalogDiscount <- function(a,s) {
    local special=s!=null&&s.m.IsWeaponSkill&&"nativeAttack" in s&&s.nativeAttack()!=null;
    if(!this.catalogSingle(s)&&!special)return 0;
    local best=0;
    foreach(e in a.getSkills().m.Skills)if(!e.isGarbage()&&"CatalogEffect" in e.m&&e.valid()){
        local d=this.CatalogEffects[e.m.Key];
        if("discount" in d && (!("throwing" in d)||!d.throwing||this.catalogThrowing(a)))best=::Math.max(best,d.discount+e.m.Bonus);
    }
    return best;
};
A.catalogReadyTarget <- function(skill,origin,tile) {
    local a=skill.getContainer().getActor(),d=this.MemberSkillDefs[skill.m.Key];
    if(d.target=="self")return true;
    if(tile==null || !tile.IsVisibleForEntity || origin.getDistanceTo(tile)>d.range)return false;
    if(d.mode=="step")return this.catalogMovable(a)&&tile.IsEmpty&&origin.Level==tile.Level&&origin.getDistanceTo(tile)==1;
    if(!tile.IsOccupiedByActor)return false;
    local t=tile.getEntity();
    if(d.target=="ally"||d.target=="ally_self"){
        if(!this.memberPlayer(t)||!a.isAlliedWith(t)||(a==t&&d.target!="ally_self"))return false;
        if(d.mode=="swap")return a!=t&&this.catalogMovable(a)&&this.catalogMovable(t)&&origin.Level==tile.Level;
        if(d.mode=="unnet")return this.catalogNet(t)!=null;
        return true;
    }
    if(!t.isAlive()||t.isDying()||a.isAlliedWith(t))return false;
    if(d.mode=="weapon") {local native=this.memberBasicAttack(a,false);return native!=null&&native.isInRange(tile)&&native.onVerifyTarget(origin,tile);}
    if(d.mode=="mark")return true;
    if(!this.memberMentalTarget(t))return false;
    if(d.mode=="snare")return !t.getCurrentProperties().IsImmuneToRoot && !t.getCurrentProperties().IsRooted;
    if(d.mode=="taunt"){
        if(!::isKindOf(t,"human"))return false;
        foreach(s in t.getSkills().m.Skills)if(this.catalogSingle(s)&&!s.isRanged()&&s.isUsable()&&s.isInRange(origin)&&s.onVerifyTarget(tile,origin))return true;
        return false;
    }
    return true;
};
A.catalogActiveAllowed <- function(skill) {
    local a=skill.getContainer().getActor(),key=skill.m.Key,d=this.MemberSkillDefs[key];
    if(!this.catalogLearned(a,key)||(d.once&&skill.m.Used))return false;
    if("limit" in d&&this.catalogGet(a,"uses_"+key)>=d.limit)return false;
    if(d.mode=="step"||d.mode=="swap")if(!this.catalogMovable(a)||this.catalogGet(a,"special_move_turn",-1)==this.catalogGet(a,"turn_serial"))return false;
    if(d.mode=="snare"&&::World.Assets.getArmorParts()<2)return false;
    if(key=="unselectable"&&this.catalogEnemies(a).len()>0)return false;
    if(key=="curtain_yield"&&!this.catalogGet(a,"turn_melee_hit"))return false;
    if(key=="prince_order"){
        foreach(b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))if(this.characterId(b)=="afei"&&this.memberPlayer(b))return false;
    }
    return true;
};
A.catalogAction <- function(skill,user,tile) {
    local key=skill.m.Key,d=this.MemberSkillDefs[key];
    this.catalogSet(user,"turn_used",1);
    if(d.mode=="step"||d.mode=="swap")this.catalogSet(user,"special_move_turn",this.catalogGet(user,"turn_serial"));
    this.catalogSet(user,"uses_"+key,this.catalogGet(user,"uses_"+key)+1);
    if(d.mode=="weapon"){
        local native=this.memberBasicAttack(user,false);skill.m.ExecutingNative=native;
        local hit=false;
        try {hit=native.useForFree(tile);}catch(error){skill.m.ExecutingNative=null;throw error;}
        skill.m.ExecutingNative=null;
        if(key=="snake_trial"){
            this.catalogSet(user,"turn_hit_target",0);
            if(hit&&tile.IsOccupiedByActor&&tile.getEntity().isAlive())this.catalogEffect(tile.getEntity(),key,user);
        }
    } else if(d.mode=="swap"){
        local target=tile.getEntity(),s=this.catalogVirtual(user,"scripts/skills/actives/rotation");this.CatalogMoving=true;
        try{s.onUse(user,tile);}catch(error){this.CatalogMoving=false;throw error;}this.CatalogMoving=false;
        this.catalogSet(user,"turn_moved",1);this.catalogSet(target,"turn_moved",1);
    } else if(d.mode=="step"){
        this.CatalogMoving=true;
        try{::Tactical.getNavigator().teleport(user,tile,null,null,false);}catch(error){this.CatalogMoving=false;throw error;}this.CatalogMoving=false;
        this.catalogSet(user,"turn_moved",1);
        if(key=="king_dance"){
            // Teleport animations can finish later; use the chosen destination.
            local allies=[];
            foreach(b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))if(b!=user&&this.memberPlayer(b)&&b.getTile().getDistanceTo(tile)<=1)allies.push(b);
            allies.sort(function(a,b){if(a==b)return 0;if(a.getFatigue()!=b.getFatigue())return a.getFatigue()>b.getFatigue()?-1:1;return a.getID()<b.getID()?-1:1;});
            for(local i=0;i<::Math.min(2,allies.len());i++)this.catalogEffect(allies[i],key,user);
        }
        else if(key in this.CatalogEffects)this.catalogEffect(user,key,user);
    } else if(d.mode=="taunt") this.catalogVirtual(user,"scripts/skills/actives/taunt").onUse(user,tile);
    else if(d.mode=="unnet"){local t=tile.getEntity();t.getSkills().removeAllByID(this.catalogNet(t));t.getSkills().update();}
    else if(d.mode=="snare"){::World.Assets.addArmorParts(-2);local target=tile.getEntity(),chance=::Math.max(5,::Math.min(95,user.getCurrentProperties().MeleeSkill+10-target.getCurrentProperties().MeleeDefense));if(::Math.rand(1,100)<=chance)this.catalogEffect(target,key,user);}
    else if(d.mode=="mark"){
        local previous=this.catalogGet(user,"mark_"+key),old=previous==0 ? null : ::Tactical.getEntityByID(previous);
        if(old!=null)this.catalogRemove(old,key);
        local e=this.catalogEffect(tile.getEntity(),key,user);e.m.UntilRound=key=="abacus_mark"?0:this.memberRound()+2;
        this.catalogSet(user,"mark_"+key,tile.getEntity().getID());
    } else if(d.mode=="cover"){
        local e=this.catalogEffect(tile.getEntity(),key,user);
        e.m.SourceTurn=this.catalogGet(user,"turn_serial");
    } else {
        local center=tile!=null&&tile.IsOccupiedByActor?tile.getEntity():user;
        local targets=d.mode=="team"?this.balanceTargets(user,key=="drum"?center:user,d.range):[];
        if(d.mode!="team"){if(d.target=="self")targets.push(user);else targets.push(tile.getEntity());}
        if(key=="yanzi_cover")targets.push(user);
        local insight=0;
        foreach(b in targets){local e=this.catalogEffect(b,key,user);if(key=="cup_signal")e.m.Bonus=insight*2;b.getSkills().update();}

    }
    user.getSkills().update();
    return true;
};
