local A=::AfeixExpedition;
A.catalogWoundedNeighbor <- function(a){foreach(b in this.memberAllies(a,1))if(b.getHitpoints()<=b.getHitpointsMax()*0.5)return true;return false;};
A.catalogHitByOther <- function(target,a){
    return this.catalogGet(target,"hit_round",-1)==this.memberRound()
        && (this.catalogGet(target,"hit_first")!=a.getID()||(this.catalogGet(target,"hit_second")>0&&this.catalogGet(target,"hit_second")!=a.getID()));
};
A.catalogPassiveStats <- function(a,key,p){
    if(key=="small_heart"&&this.memberAllies(a,2).len()==0)p.Bravery-=8;
    if(key=="chaoju"){local n=this.catalogGet(a,"spotlight");p.RangedSkill+=n*3;p.Bravery+=n*3;}
    if(key=="ouqi")p.RerollMoraleChance=::Math.max(p.RerollMoraleChance,20);
    if(key=="scout_path"){p.Vision+=1;if(this.memberRound()==1)p.Initiative+=10;}
    if(key=="quail_alarm"&&this.memberRound()==1){p.Initiative+=15;p.Vision+=1;}
    if(key=="companion"&&this.memberAllies(a,2).len()>0)p.Bravery+=6;
    if(key=="own_people"&&this.memberShield(a)&&this.catalogWoundedNeighbor(a))p.Bravery+=6;
    if(key=="five_elder"&&this.memberAllies(a,1).len()>=2)p.Bravery+=6;
    if(key=="leave_not_gone"&&this.catalogWoundedNeighbor(a))p.Bravery+=10;
    if(key=="not_fooled")foreach(label in ["MentalAttack","Fear","Charm"])
        if(label in ::Const.MoraleCheckType)p.MoraleCheckBravery[::Const.MoraleCheckType[label]]+=15;
};
A.catalogPassiveDefense <- function(a,key,attacker,skill,p){
    if((key=="small_heart"||key=="pang_anchor")&&this.memberShield(a)&&this.memberAllies(a,1).len()>0)p.MeleeDefense+=4;
    if(key=="own_people"&&this.memberShield(a)&&this.catalogWoundedNeighbor(a))p.MeleeDefense+=4;
    if(key=="five_elder"&&this.memberAllies(a,1).len()>=2)p.MeleeDefense+=4;
    if(key=="leave_not_gone"&&this.catalogWoundedNeighbor(a))p.MeleeDefense+=5;
    if(key=="remember_shield"&&attacker!=null&&this.memberShield(a)&&this.catalogGet(a,"shield_round",-1)==this.memberRound()&&this.catalogGet(a,"shield_attacker")==attacker.getID())p.MeleeDefense+=6;
};
A.catalogBoost <- function(a,s,target){
    if(!this.catalogSingle(s)||target==null||a.isAlliedWith(target))return 0;
    local r=this.memberRound(),n=0,ranged=s.isRanged(),t=target.getID();
    foreach(key in ["teammate_ball","quail_courage"])if(this.catalogHas(a,key)&&this.catalogGet(a,key+"_round",-1)!=r
        &&this.catalogHitByOther(target,a))n+=5;
    if(this.catalogHas(a,"good_card")&&!ranged&&this.catalogGet(a,"good_card_round",-1)!=r&&this.catalogGet(target,"hit_round",-1)==r&&this.catalogGet(target,"hit_second")>0)n+=10;
    if(this.catalogHas(a,"biantai")&&ranged&&this.catalogGet(a,"last_ranged")>0&&this.catalogGet(a,"last_ranged")!=t&&this.catalogGet(a,"biantai_round",-1)!=r)n+=8;
    if(this.catalogHas(a,"return_arrow")&&ranged&&this.catalogGet(a,"steps_round",-1)==r&&this.catalogGet(a,"steps")>=2&&this.catalogGet(a,"return_arrow_round",-1)!=r)n+=7;
    if(this.catalogHas(a,"alien_eye")&&ranged&&!this.catalogGet(a,"turn_moved"))n+=6;
    if(this.catalogHas(a,"signal_delay")&&ranged&&this.catalogGet(a,"signal_until")>=r)n+=8;
    if(this.catalogHas(a,"berry_eye")&&ranged&&this.catalogNearbyPlayers(target,1).len()>0&&this.catalogGet(a,"berry_eye_round",-1)!=r)n+=5;
    if(this.catalogHas(a,"half_step")&&a.getInitiative()>target.getInitiative()&&(this.catalogGet(a,"half_round",-1)!=r||this.catalogGet(a,"half_count")<2))n+=5;
    if(this.catalogHas(a,"read_beat")&&!ranged&&this.catalogGet(a,"beat_round",-1)==r&&this.catalogGet(a,"beat_target")==t)n+=6;
    if(this.catalogHas(a,"snake_read")&&!ranged&&this.catalogGet(a,"snake_target")==t)n+=6;
    if(this.catalogHas(a,"door_mine")&&!ranged&&this.catalogNearbyPlayers(target,1).len()>=2&&this.catalogGet(a,"door_mine_round",-1)!=r)n+=5;
    if(this.catalogHas(a,"abs_comeback")&&this.catalogThrowing(a)&&this.catalogGet(a,"comeback_until")>=r)n+=10;
    if(this.catalogHas(a,"no_last_throw")&&this.catalogThrowing(a)&&this.catalogGet(a,"last_throw_count")<2){
        local pending=this.catalogGet(a,"attempt_serial")>this.catalogGet(a,"finished_serial")&&this.catalogGet(a,"attempt_target")==t;
        local ammo=pending?this.catalogGet(a,"attempt_ammo"):a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getAmmo();
        if(ammo==1)n+=6;
    }
    if(this.catalogGet(a,"fear_round",-1)==r&&this.catalogGet(a,"fear_penalty"))n-=5;
    foreach(key in ["abacus_mark","berry_mark"]){local e=this.catalogFindEffect(target,key);if(e!=null&&e.valid()&&(key!="berry_mark"||ranged))n+=this.CatalogEffects[key].mark;}
    return n;
};
A.catalogAttackProperties <- function(a,s,t,p){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.catalogSingle(s))return;
    if(this.memberPlayer(a)){
        local n=this.catalogBoost(a,s,t);if(s.isRanged())p.RangedSkill+=n;else p.MeleeSkill+=n;
    }
    foreach(e in a.getSkills().m.Skills)if(!e.isGarbage()&&"CatalogEffect" in e.m&&e.valid()){
        local d=this.CatalogEffects[e.m.Key];
        if("hit" in d&&(!("melee" in d)||!d.melee||!s.isRanged())){if(s.isRanged())p.RangedSkill+=d.hit;else p.MeleeSkill+=d.hit;}
    }
};
A.catalogAttackResult <- function(a,s,target,hit){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.catalogSingle(s)||target==null||a.isAlliedWith(target))return;
    local serial=this.catalogGet(a,"attempt_serial"),r=this.memberRound();
    if(serial<=0||this.catalogGet(a,"finished_serial",-1)==serial)return;
    this.catalogSet(a,"finished_serial",serial);
    local ranged=s.isRanged(),id=target.getID();
    // Resolve conditions against pre-hit memory, then publish this attack's hit.
    if(this.memberPlayer(a)){
        foreach(key in ["teammate_ball","quail_courage"])if(this.catalogHas(a,key)&&this.catalogHitByOther(target,a))this.catalogSet(a,key+"_round",r);
        if(!ranged&&this.catalogHas(a,"good_card")&&this.catalogGet(target,"hit_round",-1)==r&&this.catalogGet(target,"hit_second")>0)this.catalogSet(a,"good_card_round",r);
        if(ranged){
            if(this.catalogGet(a,"last_ranged")>0&&this.catalogGet(a,"last_ranged")!=id)this.catalogSet(a,"biantai_round",r);
            this.catalogSet(a,"last_ranged",id);
            if(this.catalogGet(a,"steps_round",-1)==r&&this.catalogGet(a,"steps")>=2)this.catalogSet(a,"return_arrow_round",r);
            if(this.catalogNearbyPlayers(target,1).len()>0)this.catalogSet(a,"berry_eye_round",r);
            local had=this.catalogGet(a,"signal_until")>=r;this.catalogSet(a,"signal_until",0);
            if(!hit&&this.catalogHas(a,"signal_delay")&&this.catalogOnce(a,"signal_gain_round"))this.catalogSet(a,"signal_until",r+1);
        }
        if(this.catalogHas(a,"half_step")&&a.getInitiative()>target.getInitiative()){
            if(this.catalogGet(a,"half_round",-1)!=r){this.catalogSet(a,"half_round",r);this.catalogSet(a,"half_count",0);}
            this.catalogSet(a,"half_count",this.catalogGet(a,"half_count")+1);
        }
        if(!ranged){
            if(this.catalogGet(a,"beat_target")==id)this.catalogSet(a,"beat_target",0);
            if(this.catalogGet(a,"snake_target")==id)this.catalogSet(a,"snake_target",0);
            if(this.catalogNearbyPlayers(target,1).len()>=2)this.catalogSet(a,"door_mine_round",r);
            if(hit){this.catalogSet(a,"turn_melee_hit",1);this.catalogSet(a,"turn_hit_target",id);}
        }
        if(this.catalogThrowing(a)){
            this.catalogSet(a,"comeback_until",0);
            // The weapon onUse already consumed ammunition; capture the pre-use count.
            if(this.catalogGet(a,"attempt_ammo")==1)this.catalogSet(a,"last_throw_count",this.catalogGet(a,"last_throw_count")+1);
        }
        this.catalogSet(a,"fear_penalty",0);
        if(this.catalogHas(a,"chaoju")&&this.catalogOnce(a,hit?"spot_hit_round":"spot_miss_round"))this.catalogSet(a,"spotlight",::Math.max(0,::Math.min(3,this.catalogGet(a,"spotlight")+(hit?1:-1))));
        if(hit){
            if(this.catalogGet(target,"hit_round",-1)!=r){this.catalogSet(target,"hit_round",r);this.catalogSet(target,"hit_first",a.getID());this.catalogSet(target,"hit_second",0);}
            else if(this.catalogGet(target,"hit_first")!=a.getID())this.catalogSet(target,"hit_second",a.getID());
            if(ranged&&this.catalogHas(a,"berry_reserve")&&this.catalogNearbyPlayers(target,1).len()>0&&this.catalogOnce(a,"berry_recover_round"))this.catalogRecover(a,2);
        }else if(!ranged)foreach(b in this.memberAllies(a,1))if(this.catalogHas(b,"read_beat")&&this.catalogOnce(b,"beat_gain_round")){this.catalogSet(b,"beat_target",id);this.catalogSet(b,"beat_round",r);}
    }
    foreach(key in ["abacus_mark","berry_mark"]){local e=this.catalogFindEffect(target,key);if(e!=null&&e.valid()&&a.getFaction()==::Const.Faction.Player&&(key!="berry_mark"||ranged))e.removeSelf();}
    foreach(e in clone a.getSkills().m.Skills)if(!e.isGarbage()&&"CatalogEffect" in e.m&&e.valid()){
        local d=this.CatalogEffects[e.m.Key];
        if(("discount" in d&&(!("throwing" in d)||!d.throwing||this.catalogThrowing(a)))||("hit" in d&&(!("melee" in d)||!d.melee||!ranged)))e.removeSelf();
    }
    a.getSkills().update();target.getSkills().update();
};
A.catalogReceived <- function(a,attacker,s,hit){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.memberPlayer(a)||attacker==null||attacker.isAlliedWith(a)||!this.catalogSingle(s))return;
    local r=this.memberRound();
    if(!s.isRanged()&&this.catalogHas(a,"snake_read")&&this.catalogOnce(a,"snake_seen_round"))this.catalogSet(a,"snake_target",attacker.getID());
    if(hit){
        if(this.catalogHas(a,"pang_breath")&&this.catalogOnce(a,"pang_recover_round"))this.catalogRecover(a,3);
        if(this.catalogFindEffect(a,"long_watch")!=null&&this.catalogOnce(a,"watch_recover_round"))this.catalogRecover(a,4);
        if(!s.isRanged()&&this.memberShield(a)&&this.catalogHas(a,"remember_shield")&&this.catalogOnce(a,"shield_round"))this.catalogSet(a,"shield_attacker",attacker.getID());
    }
    if(this.catalogHas(a,"abs_comeback")&&(!hit||this.catalogFindEffect(a,"shrink_cover")!=null)&&this.catalogOnce(a,"comeback_round"))this.catalogSet(a,"comeback_until",r+1);
};
A.catalogTurnStart <- function(a){
    if(!this.isOrigin()||!::Tactical.isActive())return;
    this.catalogSet(a,"turn_serial",this.catalogGet(a,"turn_serial")+1);
    this.catalogSet(a,"turn_moved",0);this.catalogSet(a,"turn_used",0);this.catalogSet(a,"turn_melee_hit",0);this.catalogSet(a,"turn_hit_target",0);
    if(this.catalogHas(a,"optimist")&&!this.catalogGet(a,"optimist_used")&&this.memberPlayer(a)){
        local morale=a.getMoraleState();if(morale==::Const.MoraleState.Wavering||morale==::Const.MoraleState.Breaking){this.catalogSet(a,"optimist_used",1);a.setMoraleState(morale+1);}
    }
    if(this.catalogHas(a,"shift_arrive")){
        local changed=false,previous=this.catalogGet(a,"shift_serial");
        foreach(b in this.memberAllies(a,1)){if(previous>0&&this.catalogGet(a,"adj_"+b.getID())!=previous)changed=true;this.catalogSet(a,"adj_"+b.getID(),previous+1);}
        this.catalogSet(a,"shift_serial",previous+1);if(changed&&this.catalogOnce(a,"shift_round"))this.catalogRecover(a,5);
    }
};
A.catalogTurnEnd <- function(a){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.memberPlayer(a))return;
    foreach(key,amount in {segment_breath=8,spare_breath=4,one_more_night=6})if(this.catalogHas(a,key)&&!this.catalogGet(a,"turn_used")&&this.catalogEnemies(a).len()==0&&this.catalogOnce(a,key+"_round"))this.catalogRecover(a,amount);
    if(this.catalogHas(a,"look_flag")&&this.catalogGet(a,"turn_moved"))
        foreach(c in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
            if(this.memberPlayer(c)&&["afei","damou","mocha"].find(this.characterId(c))!=null&&c.getTile().getDistanceTo(a.getTile())<=3){this.catalogEffect(a,"look_flag",a);break;}
    if(this.catalogHas(a,"bell_lead")&&this.catalogOnce(a,"bell_round")){local best=null;foreach(b in this.memberAllies(a,1))if(best==null||b.getFatigue()>best.getFatigue())best=b;if(best!=null)this.catalogRecover(best,3);}
    this.catalogSet(a,"snake_target",0);
};
A.catalogMoved <- function(a,steps=0){
    if(!this.isOrigin()||!::Tactical.isActive())return;
    this.catalogSet(a,"turn_moved",1);this.catalogSet(a,"move_serial",this.catalogGet(a,"move_serial")+1);
    for(local i=0;i<steps;++i)this.catalogWalkStep(a);
};
A.catalogWalkStep <- function(a){
    if(this.catalogGet(a,"steps_round",-1)!=this.memberRound()){this.catalogSet(a,"steps_round",this.memberRound());this.catalogSet(a,"steps",0);}
    this.catalogSet(a,"steps",this.catalogGet(a,"steps")+1);
    if(this.catalogHas(a,"start_run")&&!this.catalogGet(a,"start_used")){this.catalogSet(a,"start_used",1);this.catalogRecover(a,2);}
    if(this.catalogHas(a,"curve_force")&&this.catalogGet(a,"steps")==2)this.catalogRecover(a,3);
};
