local A=::AfeiExpedition;
A.BuffKeys <- ["wawa","prince","steady","circle","borrow","abacus","shadow","cup","bottlepen","dog","hidden","loyalty","drum","pokemon","withdraw","bear","foot","brake","leave","gate","nest","cover","taunt","shrink","watch","dance","beat","selfguard","sprint","snake","curtain","detour","baton","duck","blue","moon","comeback","pang","berry"];
A.buff <- function(a,key,values=null,rounds=2,turnEnd=0) {
    this.battleS(a,"buff_"+key,true);this.battleS(a,key+"_age",this.inc("buff_serial"));this.battleS(a,key+"_until",this.round()+rounds-1);
    this.battleS(a,key+"_turnend",turnEnd);this.battleS(a,key+"_turnstart",0);
    if(values!=null)foreach(k,v in values)this.battleS(a,key+"_"+k,v);
    if(!a.getSkills().hasSkill("special.afei_rules"))a.getSkills().add(::new("scripts/skills/special/afei_rules"));
    a.getSkills().update();
};
A.activeBuff <- function(a,key) {
    if(!a.isAlive() || !a.isPlacedOnMap())return false;
    if(!this.battleG(a,"buff_"+key) || this.battleG(a,key+"_until",-1)<this.round())return false;
    local end=this.battleG(a,key+"_turnend"),start=this.battleG(a,key+"_turnstart");
    if(end && this.battleG(a,"turns")>end)return false;if(start && this.battleG(a,"turns")>=start)return false;
    if(["gate","nest","cover","shrink","selfguard","curtain"].find(key)!=null && (!this.ready(a) || !this.shield(a) || this.battleG(a,key+"_tile",-1)!=a.getTile().ID))return false;
    if(key=="brake" && this.battleG(a,key+"_tile",-1)!=a.getTile().ID)return false;
    if(key=="pokemon") {local owner=this.findActor(this.battleG(a,"pokemon_source"));if(!this.ready(owner) || this.battleG(owner,"pokemon_target")!=a.getID())return false;}
    return true;
};
A.removeBuff <- function(a,key) { this.battleS(a,"buff_"+key,false); };
A.untilStart <- function(a,key) { this.battleS(a,key+"_turnstart",this.battleG(a,"turns")+1);this.battleS(a,key+"_until",100000); };
A.stance <- function(a,key) {
    foreach(k in ["gate","nest","cover","shrink","watch","selfguard","curtain","brake"])this.removeBuff(a,k);
    this.buff(a,key,{tile=a.getTile().ID,charges=(key=="shrink"?2:1)},100000);this.untilStart(a,key);
};
A.rooted <- function(a) { if(a.getCurrentProperties().IsRooted)return true;foreach(k in ["gate","nest","cover","shrink","curtain","brake"])if(this.activeBuff(a,k))return true;return false; };
A.weaponSkill <- function(s) { return s!=null && s.isAttack() && s.m.IsTargeted && !s.m.IsAOE && s.getItem()!=null && s.getItem().isItemType(::Const.Items.ItemType.Weapon); };
A.ordinary <- function(s) { return this.weaponSkill(s) && s.getID().find("actives.afei_")!=0; };
A.startBattle <- function() {
    foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)this.clearBattleFlags(a);
    this.inc("battle_id");this.sw("retreat_triggered",false);this.sw("battle_had_enemy",false);this.sw("battle_running",true);this.sw("battle_deaths",0);this.sw("m07_target_killed",false);this.sw("order_used",0);this.sw("order_round",-1);this.sw("order_serial",0);
    local actors=this.actors(),captain=null,proxy=null,budgetOwner=false;foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)if(a.isAlive() && !a.isAlliedWithPlayer() && !a.isNonCombatant())this.sw("battle_had_enemy",true);
    foreach(a in actors)if(this.player(a) && this.cid(a)=="C31")budgetOwner=true;
    foreach(a in actors) {if(!this.player(a))continue;this.battleS(a,"deployed",true);this.battleS(a,"turns",0);foreach(b in actors)if(this.player(b))this.battleS(a,"old_adj_"+b.getID(),a.getTile().getDistanceTo(b.getTile())==1);this.battleS(a,"key_ready",this.w("m06_done"));this.battleS(a,"rope_ready",this.g(a,"rope_train")>=2);
        if(this.cid(a)=="C01")captain=a;if(this.cid(a)==this.w("selected_proxy",""))proxy=a;
        local levels=[];foreach(b in actors)if(this.player(b) && b.getID()!=a.getID())levels.push(b.getLevel());levels.sort();
        local median=levels.len()==0?0:(levels.len()%2?levels[levels.len()/2]:(levels[levels.len()/2-1]+levels[levels.len()/2])/2.0);
        this.battleS(a,"mentor",this.cid(a)!="" && a.getLevel()<7 && levels.len()>0 && a.getLevel()<=median-3);
        if(this.g(a,"moon_ready_until")>=this.now() && this.g(a,"moon_ready_until")>0) {this.buff(a,"moon",null,2);this.s(a,"moon_ready_until",0);}
        this.battleS(a,"budget_ready",budgetOwner && this.g(a,"budget_ready",false));this.s(a,"budget_ready",false);
        if(!a.getSkills().hasSkill("special.afei_rules"))a.getSkills().add(::new("scripts/skills/special/afei_rules"));
    }
    this.sw("battle_proxy",this.id(proxy));this.sw("battle_afei_rest",captain==null && this.named("C01")!=null);
    this.sw("order_max",captain!=null && this.w("awakened")?3:2);
    foreach(a in actors)if(this.has(a,"blue_form"))foreach(b in this.allies(a,1,false))this.buff(b,"blue",null,1);
};
A.canUseOrder <- function() { return this.w("order_used")<this.w("order_max",2) && this.w("order_round",-1)!=this.round(); };
A.consumeOrder <- function() {if(!this.canUseOrder())return false;this.inc("order_used");this.sw("order_round",this.round());this.inc("order_serial");return true;};
A.orderBuff <- function(source,target,key,bravery=0,defense=0) {
    local seq=this.w("order_serial");this.buff(target,key,{bravery=bravery,defense=defense,source=source.getID(),seq=seq});this.battleS(target,"received_order_"+seq,true);
    if(this.cid(source)=="C01" && this.has(target,"fear_afei")) {
        this.battleS(target,"afei_order",true);if(!this.battleG(target,"fear_used")) {this.battleS(target,"fear_used",true);this.recover(target,8);if(!this.grown(target))this.battleS(target,"fear_penalty_until",this.round());}
    }
};
A.properties <- function(a,p) {
    if(!this.isAfeiOrigin() || !::Tactical.isActive() || !this.player(a) || this.g(a,"camped"))return;
    local md=0,rd=0,br=0,ini=0,me=0,ra=0,orderBr=0,orderMD=0,opening=0;
    foreach(k in ["wawa","prince","steady","circle"])if(this.activeBuff(a,k)) {orderBr=::Math.max(orderBr,this.battleG(a,k+"_bravery"));orderMD=::Math.max(orderMD,this.battleG(a,k+"_defense"));}
    if(this.battleG(a,"trap_root"))p.IsRooted=true;
    if(this.has(a,"chaoju")) {ra+=3*this.battleG(a,"spotlight");br+=3*this.battleG(a,"spotlight");}
    if(this.has(a,"small_heart")) {if(this.allies(a,2).len()==0 && !this.grown(a))br-=8;else if(this.shield(a) && this.allies(a,1).len())md+=4;}
    if(this.has(a,"pang_anchor") && this.shield(a) && this.allies(a,1).len()>0)md+=4;
    if(this.activeBuff(a,"pang")) {md+=this.battleG(a,"pang_defense");br+=4;}
    if(this.has(a,"loyalty")) {local c=this.center();if(c!=null && this.distance(a,c)<=(this.grown(a)?3:2))br+=10;}
    if(this.activeBuff(a,"loyalty"))md+=4;
    if(this.has(a,"only_man"))foreach(b in this.allies(a,1))if(!this.shield(b) || (this.activeBuff(a,"cover") && this.battleG(a,"cover_target")==b.getID())) {md+=6;break;}
    if(this.has(a,"goose_bully")) {local foes=this.enemies(a).len();if(foes>0 && this.allies(a,1).len()>=foes) {me+=5;br+=5;}
}
    if(this.has(a,"five_elder") && this.allies(a,1).len()>=2) {md+=4;br+=6;}
    foreach(b in this.allies(a,1)) {
        if(this.has(b,"hold_ground") && this.shield(b) && !this.battleG(b,"moved_this_turn"))md+=this.grown(b)?5:3;
        if(this.activeBuff(b,"nest"))rd+=6;
    }
    if(this.activeBuff(a,"nest"))rd+=6;
    if(this.activeBuff(a,"bottlepen"))md-=5;
    if(this.activeBuff(a,"brake")) {md+=4;rd+=12;}
    if(this.activeBuff(a,"leave")) {md+=5;br+=10;}
    if(this.activeBuff(a,"shrink"))md+=8;
    if(this.activeBuff(a,"watch")) {md+=8;rd+=8;ini-=10;}
    if(this.activeBuff(a,"selfguard"))md+=8;
    if(this.activeBuff(a,"curtain"))md+=7;
    if(this.activeBuff(a,"pokemon")) {rd+=8;local c=this.findActor(this.battleG(a,"pokemon_source"));if(c!=null && this.grown(c))md+=4;}
    if(this.activeBuff(a,"foot"))ini+=15;
    if(this.activeBuff(a,"dance"))ini+=12;
    if(this.activeBuff(a,"duck"))ini+=10;
    if(this.activeBuff(a,"blue"))opening=12;
    
    if(this.activeBuff(a,"moon"))br+=6;
    if(this.battleG(a,"drum_br_turn")==this.battleG(a,"turns") && this.battleG(a,"drum_br_turn")>0)br+=5;
    if(this.battleG(a,"look_br_turn",-1)==this.battleG(a,"turns"))br+=6;
    p.MeleeSkill+=::Math.min(15,me);p.RangedSkill+=::Math.min(15,ra);
    this.battleS(a,"property_md",::Math.max(-15,::Math.min(15,md+orderMD)));p.MeleeDefense+=this.battleG(a,"property_md");p.RangedDefense+=::Math.max(-15,::Math.min(15,rd));
    p.Bravery+=::Math.min(30,orderBr+br)+(this.w("cohesion",25)<30?-3:(this.w("cohesion",25)>=70?3:0));
    p.Initiative+=::Math.min(20,ini+opening);
};
A.attackProperties <- function(a,s,t,p) {
    if(!this.isAfeiOrigin() || t==null || !this.weaponSkill(s))return;
    local baseTotal=p.DamageTotalMult,baseArmor=p.DamageArmorMult;local hit=0,negative=0;local enemy=!a.isAlliedWith(t),ranged=s.isRanged();
    if(this.activeBuff(a,"dog") && !ranged)negative=-8;
    if(this.activeBuff(a,"bear"))negative=::Math.min(negative,-10);
    if(this.activeBuff(a,"snake"))negative=::Math.min(negative,-6);
    if(this.battleG(a,"fear_penalty_until",-1)>=this.round())negative-=5;
    if(this.activeBuff(a,"borrow") && !ranged)hit+=this.battleG(a,"borrow_value");
    if(this.activeBuff(t,"abacus") && enemy)hit+=10;
    if(enemy && ranged && this.ordinary(s) && this.activeBuff(t,"berry")) {local source=this.findActor(this.battleG(t,"berry_source"));if(source!=null && a.isAlliedWith(source))hit+=8;}
    if(enemy && ranged && this.ordinary(s) && this.has(a,"berry_eye") && !this.seenThisRound(a,"berry_eye") && this.allies(t,1).len()>0)hit+=5;
    if(this.activeBuff(a,"baton"))hit+=5;
    if(!ranged && this.activeBuff(a,"sprint"))hit+=8;
    if(this.activeBuff(a,"beat") && enemy && !ranged && this.battleG(a,"beat_target")==t.getID())hit+=6;
    if(this.has(a,"teammate_ball") && enemy && !this.seenThisRound(a,"ball") && this.battleG(t,"hit_round",-1)==this.round() && this.battleG(t,"hit_first")!=a.getID())hit+=5;
    if(this.has(a,"good_card") && enemy && !ranged && !this.seenThisRound(a,"good_card") && this.battleG(t,"hit_round",-1)==this.round() && this.battleG(t,"hit_second") && this.battleG(t,"hit_first")!=a.getID() && this.battleG(t,"hit_second")!=a.getID())hit+=10;
    if(this.has(a,"biantai") && ranged && enemy && this.battleG(a,"last_ranged_target") && this.battleG(a,"last_ranged_target")!=t.getID() && !this.seenThisRound(a,"biantai"))hit+=8;
    if(this.has(a,"return_arrow") && ranged && this.battleG(a,"moves_round_"+this.round())>=(this.grown(a)?1:2) && !this.seenThisRound(a,"return_arrow"))hit+=7;
    if(this.has(a,"half_step") && this.battleG(a,"halfstep_"+this.round())<2 && a.getInitiative()>t.getInitiative())hit+=5;
    if(this.has(a,"pokemon") && ranged && this.battleG(a,"threat")==t.getID() && !this.seenThisRound(a,"pokemon_attack"))hit+=8;
    if(this.has(a,"snake_read") && !ranged && this.battleG(a,"qin_until_turn")>=this.battleG(a,"turns") && this.battleG(a,"qin_target")==t.getID() && !this.seenThisRound(a,"qin"))hit+=6;
    if(this.has(a,"door_mine") && !ranged && this.ordinary(s) && this.allies(t,1).len()>=2 && !this.seenThisRound(a,"door_mine"))hit+=5;
    if(this.has(a,"half_react") && this.ordinary(s) && !ranged && !this.battleG(a,"waited") && !this.battleG(t,"acted_"+this.round()) && !this.seenThisRound(a,"half_react"))hit+=6;
    if(this.has(a,"two_steps") && this.ordinary(s) && !ranged && this.weaponType(a,::Const.Items.WeaponType.Spear) && this.battleG(a,"same_level_moves")==1 && !this.seenThisRound(a,"two_steps"))hit+=5;
    if(this.weaponType(a,::Const.Items.WeaponType.Throwing)) {
        if(this.activeBuff(a,"comeback"))hit+=10;
        if(this.has(a,"no_last_throw") && this.ordinary(s) && this.battleG(a,"last_throw_uses")<2 && this.battleG(a,"ammo_before",this.weapon(a).getAmmo())==1)hit+=6;
    }
    if(this.activeBuff(a,"gate") && this.battleG(a,"aoo_active") && !this.battleG(a,"gate_aoo_used"))hit+=10;
    local special=this.battleG(a,"weapon_context","");
    if(special=="bottle_breakthrough")hit+=10;
    if(special=="gaga_charge") {if(!this.grown(a))negative-=5;p.DamageArmorMult*=1.1;}
    if(special=="breach_strike" && !this.grown(a))negative-=5;
    if(special=="snake_trial") {p.DamageTotalMult*=this.grown(a)?0.9:0.8;}
    if(special=="catch_rear")p.DamageTotalMult*=0.5;
    if(this.has(a,"together_lift") && !ranged && this.allies(a,2).len()>=2)p.DamageArmorMult*=1.1;
    if(this.has(a,"finals_moment") && !ranged && this.round()>=5)p.DamageTotalMult*=1.1;
    if(this.has(a,"lvbu_weapon") && this.weapon(a)!=null && this.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded) && this.weaponType(a,::Const.Items.WeaponType.Polearm) && !this.battleG(a,"lvbu_target_"+t.getID()))p.DamageTotalMult*=1.1;
    // Current-property bonuses already used some of the origin's +15 budget.
    local baseline=0;if(ranged && this.has(a,"chaoju"))baseline=3*this.battleG(a,"spotlight");
    if(!ranged && this.has(a,"goose_bully") && this.enemies(a).len()>0 && this.allies(a,1).len()>=this.enemies(a).len())baseline=5;
    local delta=::Math.max(0,::Math.min(hit,15-baseline))+::Math.max(-15,negative);
    if(ranged)p.RangedSkill+=delta;else p.MeleeSkill+=delta;
    if(baseTotal>0)p.DamageTotalMult=::Math.minf(p.DamageTotalMult,baseTotal*1.25);if(baseArmor>0 && baseTotal>0 && p.DamageTotalMult*p.DamageArmorMult>baseTotal*baseArmor*1.25)p.DamageArmorMult=baseTotal*baseArmor*1.25/p.DamageTotalMult;
};
A.attackAttempt <- function(a,s,t) {
    if(!this.weaponSkill(s) || t==null)return;
    local enemy=!a.isAlliedWith(t),range=s.isRanged(),ranged=range;
    if(!enemy)return;
    if(this.has(a,"berry_reserve") && ranged && this.ordinary(s))this.battleS(a,"berry_support_attempt",this.allies(t,1).len()>0);
    if(ranged && this.ordinary(s) && this.activeBuff(t,"berry")) {local source=this.findActor(this.battleG(t,"berry_source"));if(source!=null && a.isAlliedWith(source)) {if(a.getID()!=source.getID())this.battleS(source,"berry_follow",true);this.removeBuff(t,"berry");}}
    if(ranged && this.ordinary(s) && this.has(a,"berry_eye") && this.allies(t,1).len()>0)this.once(a,"berry_eye");
    if(this.activeBuff(a,"taunt") && this.battleG(a,"taunt_source")==t.getID() && !range) {this.battleS(t,"taunt",true);this.removeBuff(a,"taunt");}
    if(this.has(a,"no_last_throw") && this.ordinary(s) && this.weaponType(a,::Const.Items.WeaponType.Throwing) && this.battleG(a,"ammo_before",this.weapon(a).getAmmo())==1 && this.battleG(a,"last_throw_uses")<2)this.battleInc(a,"last_throw_uses");
    if(this.has(a,"teammate_ball") && !this.seenThisRound(a,"ball") && this.battleG(t,"hit_round",-1)==this.round() && this.battleG(t,"hit_first")!=a.getID()) {this.once(a,"ball");this.battleS(a,"ball",true);this.unique(a,"ball_partners",this.battleG(t,"hit_first"));}
    if(this.has(a,"good_card") && !range && this.battleG(t,"hit_second") && this.battleG(t,"hit_round",-1)==this.round())this.once(a,"good_card");
    if(this.has(a,"biantai") && range) {if(this.battleG(a,"last_ranged_target") && this.battleG(a,"last_ranged_target")!=t.getID() && this.once(a,"biantai"))this.battleS(a,"biantai",true);this.battleS(a,"last_ranged_target",t.getID());}
    if(this.has(a,"return_arrow") && range && this.battleG(a,"moves_round_"+this.round())>=(this.grown(a)?1:2))this.once(a,"return_arrow");
    if(this.has(a,"half_step") && a.getInitiative()>t.getInitiative() && this.battleG(a,"halfstep_"+this.round())<2) {this.battleInc(a,"halfstep_"+this.round());this.battleS(a,"halfstep",true);}
    if(this.has(a,"pokemon") && range && this.battleG(a,"threat")==t.getID())this.once(a,"pokemon_attack");
    if(this.has(a,"snake_read") && !ranged && this.battleG(a,"qin_until_turn")>=this.battleG(a,"turns") && this.battleG(a,"qin_target")==t.getID() && this.once(a,"qin")) {this.battleS(a,"qin",true);this.battleS(a,"qin_target",0);}
    if(this.has(a,"half_react") && !range && !this.battleG(a,"waited") && !this.battleG(t,"acted_"+this.round()))this.once(a,"half_react");
    if(this.has(a,"two_steps") && this.battleG(a,"same_level_moves")==1)this.once(a,"two_steps");
    if(this.has(a,"lvbu_weapon") && this.weapon(a)!=null && this.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded) && this.weaponType(a,::Const.Items.WeaponType.Polearm)) {this.once(a,"lvbu");this.battleS(a,"lvbu_target_"+t.getID(),true);}
    if(this.has(a,"goose_bully") && this.enemies(a).len()>0 && this.allies(a,1).len()>=this.enemies(a).len())this.battleS(a,"goose",true);
    if(this.activeBuff(a,"borrow") && !range) {this.battleInc(a,"borrow_charges",-1);if(this.battleG(a,"borrow_charges")<=0)this.removeBuff(a,"borrow");}
    if(this.activeBuff(a,"baton")) {local source=this.findActor(this.battleG(a,"baton_source"));if(source!=null)this.bump(source,"baton_attacks");this.removeBuff(a,"baton");}
    if(this.activeBuff(a,"comeback") && this.weaponType(a,::Const.Items.WeaponType.Throwing)) {this.battleS(a,"comeback_throw",true);this.removeBuff(a,"comeback");}
    foreach(k in ["abacus"])this.removeBuff(t,k);
    if(!range)this.removeBuff(a,"sprint");if(!range && this.battleG(a,"beat_target")==t.getID())this.removeBuff(a,"beat");this.removeBuff(a,"bear");
    if(this.has(a,"door_mine") && this.ordinary(s) && !range && this.allies(t,1).len()>=2)this.once(a,"door_mine");
    this.battleS(a,"fear_penalty_until",-1);
    if(this.activeBuff(a,"gate") && this.battleG(a,"aoo_active"))this.battleS(a,"gate_aoo_used",true);
    // Observe attempts, never previews or non-weapon actions.
    foreach(b in this.actors())if(this.has(b,"know_rules") && this.ready(b) && this.distance(a,b)<=4 && a.getTile().IsVisibleForPlayer && !a.isAlliedWith(b)) {
        local k="observed_"+a.getID();if(this.battleG(b,k,"")==s.getID() && this.once(b,"understand")) {local n=::Math.min(this.grown(b)?3:2,this.battleG(b,"understand")+1);this.battleS(b,"understand",n);this.battleS(b,"understand_peak",::Math.max(n,this.battleG(b,"understand_peak")));}
this.battleS(b,k,s.getID());
    }
};
A.attackResult <- function(a,s,t,hit) {
    if(!this.weaponSkill(s) || t==null || a.isAlliedWith(t))return;
    if(this.activeBuff(t,"pang")) {local source=this.findActor(this.battleG(t,"pang_source"));if(source!=null && source.isAlliedWith(t))this.battleS(source,"pang_guard",true);}
    if(hit && s.isRanged() && this.ordinary(s) && this.has(a,"berry_reserve") && this.battleG(a,"berry_support_attempt") && this.once(a,"berry_reserve"))this.recover(a,2);
    this.battleS(a,"berry_support_attempt",false);
    if(hit) {if(this.battleG(t,"hit_round",-1)!=this.round()) {this.battleS(t,"hit_round",this.round());this.battleS(t,"hit_first",a.getID());this.battleS(t,"hit_second",0);}
else if(this.battleG(t,"hit_first")!=a.getID())this.battleS(t,"hit_second",a.getID());}
    if(this.has(a,"chaoju") && this.once(a,hit?"spot_hit":"spot_miss")) {local n=::Math.max(0,::Math.min(3,this.battleG(a,"spotlight")+(hit?1:-1)));this.battleS(a,"spotlight",n);this.battleS(a,"spotlight_peak",::Math.max(n,this.battleG(a,"spotlight_peak")));}
    if(hit && !s.isRanged() && this.has(a,"curtain_yield"))this.battleS(a,"curtain_enemy",t.getID());
    if(!s.isRanged() && this.has(t,"snake_read") && this.once(t,"qin_observe")) {this.battleS(t,"qin_target",a.getID());this.battleS(t,"qin_until_turn",this.battleG(t,"turns")+1);}
    if(hit && !s.isRanged() && this.shield(t) && this.has(t,"remember_shield") && this.once(t,"remember_shield")) {this.battleS(t,"shield_enemy",a.getID());this.battleS(t,"shield_until",this.round());}
    if(!hit && !s.isRanged() && this.has(t,"duck_turn") && this.once(t,"duck"))this.buff(t,"duck",null,100000,this.battleG(t,"turns")+1);
    if(this.has(t,"abs_comeback") && (!hit || this.activeBuff(t,"shrink")) && t.isAlive() && this.once(t,"comeback"))this.buff(t,"comeback");
    if(this.activeBuff(t,"watch") && hit && this.once(t,"watch"))this.recover(t,this.grown(t)?7:4);
    if(this.activeBuff(t,"pokemon")) {local c=this.findActor(this.battleG(t,"pokemon_source"));if(this.ready(c)) {if(a.getTile().IsVisibleForPlayer)this.battleS(c,"threat",a.getID());this.unique(c,"pokemon_attacked_partners",t.getID());if(!hit && this.once(c,"pokemon_miss"))this.recover(c,4);}
}
    local center=this.center();if(hit && center!=null && center.getID()==t.getID())foreach(b in this.actors())if(this.has(b,"loyalty") && this.ready(b) && this.distance(b,t)<=(this.grown(b)?3:2) && this.once(b,"loyalty"))this.buff(b,"loyalty",null,1);
    if(!hit && !s.isRanged())foreach(b in this.allies(a,1))if(this.has(b,"read_beat") && this.once(b,"read_beat"))this.buff(b,"beat",{target=t.getID()},1);
    if(hit && !s.isRanged() && this.ordinary(s) && this.has(a,"next_path")) {this.battleS(a,"next_path_target",t.getID());this.battleS(a,"next_path_skill",s.getID());this.battleS(a,"next_path_ready",true);}
    a.getSkills().update();t.getSkills().update();
};
A.turnStart <- function(a) {
    if(this.round()<1 || !this.w("battle_running") || this.seenThisRound(a,"turn_start"))return;
    this.once(a,"turn_start");this.battleInc(a,"turns");this.battleS(a,"moved_this_turn",false);this.battleS(a,"same_level_moves",0);this.battleS(a,"normal_moves",0);this.battleS(a,"flat_moves",0);this.battleS(a,"curtain_enemy",0);this.battleS(a,"next_path_ready",false);this.battleS(a,"used_action",false);this.battleS(a,"waited",false);
    if(this.activeBuff(a,"drum")) {local amount=this.recover(a,8),source=this.findActor(this.battleG(a,"drum_source"));this.battleS(a,"drum_br_turn",this.battleG(a,"turns"));if(amount>0 && source!=null && source.getID()!=a.getID() && !this.battleG(source,"drum_got_"+a.getID())) {this.battleS(source,"drum_got_"+a.getID(),true);this.battleInc(source,"drum_recipients");}
this.removeBuff(a,"drum");}
    if(this.has(a,"shift_arrive")) {foreach(b in this.allies(a,1))if(!this.battleG(a,"old_adj_"+b.getID())) {this.recover(a,5);break;}
foreach(b in this.actors())this.battleS(a,"old_adj_"+b.getID(),this.distance(a,b)==1);}
    a.getSkills().update();
};
A.turnEnd <- function(a) {
    if(this.round()<1 || !this.w("battle_running") || this.seenThisRound(a,"turn_end"))return;this.once(a,"turn_end");this.battleS(a,"acted_"+this.round(),true);
    if(this.has(a,"segment_breath") && !this.battleG(a,"used_action") && this.enemies(a).len()==0)this.recover(a,8);
    if(this.has(a,"look_flag") && this.battleG(a,"moved_this_turn")) {local c=this.center();if(c!=null && this.distance(a,c)<=3) {this.battleS(a,"look_br_turn",this.battleG(a,"turns"));this.bump(a,"look_flag");}
}
    if(this.has(a,"bell_lead") && this.battleG(a,"last_left_tile",-1)>=0) {this.sw("bell_tile",this.battleG(a,"last_left_tile"));this.sw("bell_owner",a.getID());this.sw("bell_round",this.round());}
    foreach(k in this.BuffKeys)if(this.battleG(a,k+"_turnend") && this.battleG(a,"turns")>=this.battleG(a,k+"_turnend"))this.removeBuff(a,k);
    this.battleS(a,"trap_root",false);this.battleS(a,"curtain_enemy",0);this.removeBuff(a,"sprint");
};
A.endRound <- function() {
    this.sw("bell_tile",-1);
    foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)if(a!=null && a.isAlive()) {
        foreach(k in this.BuffKeys)if(this.battleG(a,"buff_"+k) && this.battleG(a,k+"_until",-1)<=this.round()) {if(k=="circle")a.setFatigue(::Math.min(a.getFatigueMax(),a.getFatigue()+10));this.removeBuff(a,k);}
        a.getSkills().update();
    }
};
