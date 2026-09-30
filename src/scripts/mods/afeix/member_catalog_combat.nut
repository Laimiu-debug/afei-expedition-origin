local A=::AfeixExpedition;
A.catalogWoundedNeighbor <- function(a){foreach(b in this.memberAllies(a,1))if(b.getHitpoints()<=b.getHitpointsMax()*0.5)return true;return false;};
A.catalogHitByOther <- function(target,a){
    return this.catalogGet(target,"hit_round",-1)==this.memberRound()
        && (this.catalogGet(target,"hit_first")!=a.getID()||(this.catalogGet(target,"hit_second")>0&&this.catalogGet(target,"hit_second")!=a.getID()));
};
A.catalogPassiveStats <- function(a,key,p){
    if(key=="know_rules")p.MeleeSkill+=this.catalogGet(a,"insight")*3;
    if(key=="small_heart"&&this.memberAllies(a,2).len()==0)p.Bravery-=8;
    if(key=="chaoju"){local n=this.catalogGet(a,"spotlight");p.RangedSkill+=n*3;p.Bravery+=n*3;}
    if(key=="ouqi")p.RerollMoraleChance=::Math.max(p.RerollMoraleChance,25);
    if(key=="scout_path"){p.Vision+=1;if(this.memberRound()<=2)p.Initiative+=10;}
    if(key=="quail_alarm"&&this.memberRound()<=2){p.Initiative+=15;p.Vision+=1;}
    if(key=="companion"&&this.memberAllies(a,2).len()>0)p.Bravery+=6;
    if(key=="own_people"&&this.memberShield(a)&&this.catalogWoundedNeighbor(a))p.Bravery+=6;
    if(key=="five_elder"&&this.memberAllies(a,1).len()>=2)p.Bravery+=6;
    if(key=="leave_not_gone"&&this.catalogWoundedNeighbor(a))p.Bravery+=10;
    if(key=="not_fooled")foreach(label in ["MentalAttack","Fear","Charm"])
        if(label in ::Const.MoraleCheckType)p.MoraleCheckBravery[::Const.MoraleCheckType[label]]+=15;
};
A.catalogPassiveDefense <- function(a,key,attacker,skill,p){
    if((key=="small_heart"||key=="pang_anchor")&&this.memberShield(a)&&this.memberAllies(a,1).len()>0)this.balanceDefense(p,4);
    if(key=="own_people"&&this.memberShield(a)&&this.catalogWoundedNeighbor(a))this.balanceDefense(p,4);
    if(key=="five_elder"&&this.memberAllies(a,1).len()>=2)this.balanceDefense(p,4);
    if(key=="leave_not_gone"&&this.catalogWoundedNeighbor(a))this.balanceDefense(p,5);
};
A.catalogAssistBonus <- function(a,s,target,penalties=false){
    // Shared budget for marks and temporary next-attack buffs. Native weapon,
    // perk, terrain and personal conditional bonuses are calculated separately.
    local n=0,penalty=0,ranged=s.isRanged();
    if(this.memberPlayer(a)&&target!=null&&!a.isAlliedWith(target))foreach(key in ["abacus_mark","berry_mark"]){
        local e=this.catalogFindEffect(target,key);
        if(e!=null&&e.valid()&&(key!="berry_mark"||ranged))n+=this.CatalogEffects[key].mark;
    }
    foreach(e in a.getSkills().m.Skills)if(!e.isGarbage()&&"CatalogEffect" in e.m&&e.valid()){
        local d=this.CatalogEffects[e.m.Key];
        if("hit" in d&&(!("melee" in d)||!d.melee||!ranged)){
            if(d.hit>0)n+=d.hit;else penalty+=d.hit;
        }
    }
    return penalties ? penalty : ::Math.min(10,n);
};
A.catalogBoost <- function(a,s,target){
    if(!this.catalogSingle(s)||target==null||a.isAlliedWith(target))return 0;
    local r=this.memberRound(),n=0,ranged=s.isRanged(),t=target.getID();
    foreach(key in ["teammate_ball","quail_courage"])if(this.catalogHas(a,key)&&this.catalogGet(a,key+"_round",-1)!=r
        &&this.catalogHitByOther(target,a))n+=5;
    if(this.catalogHas(a,"good_card")&&!ranged&&this.catalogGet(a,"good_card_round",-1)!=r&&this.catalogGet(target,"hit_round",-1)==r&&this.catalogGet(target,"hit_second")>0)n+=8;
    if(this.catalogHas(a,"biantai")&&ranged&&this.catalogGet(a,"last_ranged")>0&&this.catalogGet(a,"last_ranged")!=t&&this.catalogGet(a,"biantai_round",-1)!=r)n+=6;
    if(this.catalogHas(a,"return_arrow")&&ranged&&this.catalogGet(a,"steps_round",-1)==r&&this.catalogGet(a,"ordinary_turn_steps")>=1&&this.catalogGet(a,"return_arrow_round",-1)!=r)n+=5;
    if(this.catalogHas(a,"alien_eye")&&ranged&&!this.catalogGet(a,"turn_moved"))n+=5;
    if(this.catalogHas(a,"signal_delay")&&ranged&&this.catalogGet(a,"signal_until")>=r)n+=8;
    if(this.catalogHas(a,"berry_eye")&&ranged&&this.catalogNearbyPlayers(target,1).len()>0&&this.catalogGet(a,"berry_eye_round",-1)!=r)n+=5;
    if(this.catalogHas(a,"half_step")&&a.getInitiative()>target.getInitiative()&&(this.catalogGet(a,"half_round",-1)!=r||this.catalogGet(a,"half_count")<1))n+=this.trainingRank(a,"half_step")>=2?7:5;
    if(this.catalogHas(a,"read_beat")&&!ranged&&this.catalogGet(a,"beat_round",-1)==r&&this.catalogGet(a,"beat_target")==t)n+=6;
    if(this.catalogHas(a,"snake_read")&&!ranged&&this.catalogGet(a,"snake_target")==t)n+=6;
    if(this.catalogHas(a,"door_mine")&&!ranged&&this.catalogNearbyPlayers(target,1).len()>=2&&this.catalogGet(a,"door_mine_round",-1)!=r)n+=5;
    if(this.catalogHas(a,"abs_comeback")&&this.catalogThrowing(a)&&this.catalogGet(a,"comeback_until")>=r)n+=8;
    if(this.catalogHas(a,"no_last_throw")&&this.catalogThrowing(a)&&this.catalogGet(a,"last_throw_count")<3){
        local pending=this.catalogGet(a,"attempt_serial")>this.catalogGet(a,"finished_serial")&&this.catalogGet(a,"attempt_target")==t;
        local ammo=pending?this.catalogGet(a,"attempt_ammo"):a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getAmmo();
        if(ammo<=2&&ammo>0)n+=6;
    }

    n+=this.catalogAssistBonus(a,s,target);
    return n;
};
A.catalogAttackProperties <- function(a,s,t,p){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.catalogSingle(s))return;
    local n=this.memberPlayer(a)&&t!=null&&!a.isAlliedWith(t)?this.catalogBoost(a,s,t):this.catalogAssistBonus(a,s,t);
    local field=s.isRanged()?"RangedSkill":"MeleeSkill";
    this.balanceHit(p,field,n);
    p[field]+=this.catalogAssistBonus(a,s,t,true);
    if(this.memberPlayer(a)&&this.catalogGet(a,"fear_penalty"))p[field]-=5;
};
A.catalogAttackResult <- function(a,s,target,hit){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.catalogSingle(s)||target==null||a.isAlliedWith(target))return;
    local serial=this.catalogGet(a,"attempt_serial"),r=this.memberRound();
    if(serial<=0||this.catalogGet(a,"finished_serial",-1)==serial)return;
    this.catalogSet(a,"finished_serial",serial);
    local ranged=s.isRanged(),id=target.getID();
    local nearby=target.isPlacedOnMap()?this.catalogNearbyPlayers(target,1).len()
        :(this.catalogGet(a,"attempt_target")==id?this.catalogGet(a,"attempt_nearby"):0);
    // Resolve conditions against pre-hit memory, then publish this attack's hit.
    if(this.memberPlayer(a)){
        foreach(key in ["teammate_ball","quail_courage"])if(this.catalogHas(a,key)&&this.catalogHitByOther(target,a))this.catalogSet(a,key+"_round",r);
        if(!ranged&&this.catalogHas(a,"good_card")&&this.catalogGet(target,"hit_round",-1)==r&&this.catalogGet(target,"hit_second")>0)this.catalogSet(a,"good_card_round",r);
        if(ranged){
            if(this.catalogGet(a,"last_ranged")>0&&this.catalogGet(a,"last_ranged")!=id)this.catalogSet(a,"biantai_round",r);
            this.catalogSet(a,"last_ranged",id);
            if(this.catalogGet(a,"steps_round",-1)==r&&this.catalogGet(a,"ordinary_turn_steps")>=1)this.catalogSet(a,"return_arrow_round",r);
            if(nearby>0)this.catalogSet(a,"berry_eye_round",r);
            local had=this.catalogGet(a,"signal_until")>=r;this.catalogSet(a,"signal_until",0);
            if(!hit&&this.catalogHas(a,"signal_delay")&&this.catalogOnce(a,"signal_gain_round"))this.catalogSet(a,"signal_until",r+1);
        }
        if(this.catalogHas(a,"half_step")&&a.getInitiative()>target.getInitiative()){
            if(this.catalogGet(a,"half_round",-1)!=r){this.catalogSet(a,"half_round",r);this.catalogSet(a,"half_count",0);}
            this.catalogSet(a,"half_count",this.catalogGet(a,"half_count")+1);
        }
        if(!ranged){
            local hadPath=this.catalogGet(a,"next_path_ready");
            this.catalogSet(a,"next_path_ready",0);
            if(!hadPath&&hit&&this.catalogHas(a,"next_path")&&this.catalogOnce(a,"next_path_round"))this.catalogSet(a,"next_path_ready",1);
            if(this.catalogGet(a,"beat_target")==id)this.catalogSet(a,"beat_target",0);
            if(this.catalogGet(a,"snake_target")==id)this.catalogSet(a,"snake_target",0);
            if(nearby>=2)this.catalogSet(a,"door_mine_round",r);
            if(hit){this.catalogSet(a,"turn_melee_hit",1);this.catalogSet(a,"turn_hit_target",id);}
        }
        if(this.catalogThrowing(a)){
            this.catalogSet(a,"comeback_until",0);
            // The weapon onUse already consumed ammunition; capture the pre-use count.
            if(this.catalogGet(a,"attempt_ammo")<=2&&this.catalogGet(a,"attempt_ammo")>0)this.catalogSet(a,"last_throw_count",this.catalogGet(a,"last_throw_count")+1);
        }
        this.catalogSet(a,"fear_penalty",0);
        if(this.catalogHas(a,"chaoju")&&this.catalogOnce(a,hit?"spot_hit_round":"spot_miss_round"))this.catalogSet(a,"spotlight",::Math.max(0,::Math.min(2,this.catalogGet(a,"spotlight")+(hit?1:-1))));
        if(hit&&target.isAlive()&&!target.isDying()){
            if(this.catalogGet(target,"hit_round",-1)!=r){this.catalogSet(target,"hit_round",r);this.catalogSet(target,"hit_first",a.getID());this.catalogSet(target,"hit_second",0);}
            else if(this.catalogGet(target,"hit_first")!=a.getID())this.catalogSet(target,"hit_second",a.getID());
        }
        if(hit&&ranged&&this.catalogHas(a,"berry_reserve")&&nearby>0&&this.catalogOnce(a,"berry_recover_round"))this.catalogRecover(a,3);
        if(!hit&&!ranged)foreach(b in this.memberAllies(a,1))if(this.catalogHas(b,"read_beat")&&this.catalogOnce(b,"beat_gain_round")){this.catalogSet(b,"beat_target",id);this.catalogSet(b,"beat_round",r);}
    }
    foreach(key in ["abacus_mark","berry_mark"]){local e=this.catalogFindEffect(target,key);if(e!=null&&e.valid()&&a.getFaction()==::Const.Faction.Player&&(key!="berry_mark"||ranged))e.removeSelf();}
    foreach(e in clone a.getSkills().m.Skills)if(!e.isGarbage()&&"CatalogEffect" in e.m&&e.valid()){
        local d=this.CatalogEffects[e.m.Key];
        if(("discount" in d&&(!("throwing" in d)||!d.throwing||this.catalogThrowing(a)))||("hit" in d&&(!("melee" in d)||!d.melee||!ranged)))e.removeSelf();
    }
    a.getSkills().update();if(target.isAlive()&&!target.isDying())target.getSkills().update();
};
A.catalogReceived <- function(a,attacker,s,hit){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.memberPlayer(a)||attacker==null||attacker.isAlliedWith(a)||!this.catalogSingle(s))return;
    local r=this.memberRound();
    if(!hit) foreach(b in this.memberAllies(a,1)) if(this.catalogHas(b,"breathe_easy")&&this.memberShield(b)) {
        local passive=b.getSkills().getSkillByID("trait.afeix_member_breathe_easy");
        if(passive!=null) passive.onProtectedMiss();
    }
    if(!s.isRanged()&&this.catalogHas(a,"snake_read")&&this.catalogOnce(a,"snake_seen_round")){
        this.catalogSet(a,"snake_target",attacker.getID());this.catalogSet(a,"snake_until_turn",this.catalogGet(a,"turn_serial")+1);
    }
    if(hit){
        if(this.catalogHas(a,"pang_breath")&&this.catalogOnce(a,"pang_recover_round"))this.catalogRecover(a,this.trainingRank(a,"pang_breath")>=2?4:3);
        if(this.catalogFindEffect(a,"long_watch")!=null&&this.catalogOnce(a,"watch_recover_round"))this.catalogRecover(a,4);
    }
    if(this.catalogHas(a,"abs_comeback")&&!hit&&this.catalogOnce(a,"comeback_round"))this.catalogSet(a,"comeback_until",r+1);
};
A.catalogTurnStart <- function(a){
    if(!this.isOrigin()||!::Tactical.isActive())return;
    this.catalogSet(a,"next_path_ready",0);
    this.catalogSet(a,"turn_serial",this.catalogGet(a,"turn_serial")+1);
    this.catalogSet(a,"turn_moved",0);this.catalogSet(a,"turn_used",0);this.catalogSet(a,"turn_melee_hit",0);this.catalogSet(a,"turn_hit_target",0);
    if(this.catalogHas(a,"optimist")&&!this.catalogGet(a,"optimist_used")&&this.memberPlayer(a)){
        local morale=a.getMoraleState();if(morale==::Const.MoraleState.Wavering||morale==::Const.MoraleState.Breaking){this.catalogSet(a,"optimist_used",1);a.setMoraleState(morale+1);this.catalogRecover(a,4);}
    }
    if(this.catalogHas(a,"shift_arrive")){
        local changed=false,previous=this.catalogGet(a,"shift_serial");
        foreach(b in this.memberAllies(a,1)){if(previous>0&&this.catalogGet(a,"adj_"+b.getID())!=previous)changed=true;this.catalogSet(a,"adj_"+b.getID(),previous+1);}
        this.catalogSet(a,"shift_serial",previous+1);if(changed&&this.catalogOnce(a,"shift_round")){local n=this.catalogRecover(a,::Math.min(4,16-this.catalogGet(a,"shift_total")));this.catalogSet(a,"shift_total",this.catalogGet(a,"shift_total")+n);}
    }
};
A.catalogTurnEnd <- function(a){
    if(!this.isOrigin()||!::Tactical.isActive()||!this.memberPlayer(a))return;
    this.catalogSet(a,"next_path_ready",0);
    foreach(key,amount in {segment_breath=8,spare_breath=6,one_more_night=8})if(this.catalogHas(a,key)&&!this.catalogGet(a,"turn_used")&&this.catalogEnemies(a).len()==0&&this.catalogOnce(a,key+"_round"))this.catalogRecover(a,amount);
    if(this.catalogHas(a,"look_flag")&&this.catalogGet(a,"ordinary_turn_steps")>0)
        foreach(c in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
            if(this.memberPlayer(c)&&["afei","damou","mocha"].find(this.characterId(c))!=null&&c.getTile().getDistanceTo(a.getTile())<=3){this.catalogEffect(a,"look_flag",a);break;}
    if(this.catalogHas(a,"bell_lead")&&this.catalogOnce(a,"bell_round")){local best=null;foreach(b in this.memberAllies(a,1))if(best==null||(b.getFatigue()>best.getFatigue()||(b.getFatigue()==best.getFatigue()&&b.getID()<best.getID())))best=b;if(best!=null)this.catalogRecover(best,this.trainingRank(a,"bell_lead")>=2?4:3);}
    if(this.catalogGet(a,"snake_until_turn")<=this.catalogGet(a,"turn_serial"))this.catalogSet(a,"snake_target",0);
};
A.catalogMoved <- function(a,steps=0){
    if(!this.isOrigin()||!::Tactical.isActive())return;
    this.catalogSet(a,"turn_moved",1);this.catalogSet(a,"move_serial",this.catalogGet(a,"move_serial")+1);
    for(local i=0;i<steps;++i)this.catalogWalkStep(a);
};
A.catalogWalkStep <- function(a){
    if(this.catalogGet(a,"steps_round",-1)!=this.memberRound()){this.catalogSet(a,"steps_round",this.memberRound());this.catalogSet(a,"steps",0);}
    this.catalogSet(a,"steps",this.catalogGet(a,"steps")+1);
    if(this.catalogHas(a,"start_run")&&this.memberRound()<=4&&this.catalogOnce(a,"start_run_round"))this.catalogRecover(a,2);
    if(this.catalogHas(a,"curve_force")&&this.catalogGet(a,"steps")==2)this.catalogRecover(a,3);
};
