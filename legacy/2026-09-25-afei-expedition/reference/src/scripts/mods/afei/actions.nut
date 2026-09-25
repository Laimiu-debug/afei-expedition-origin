local A=::AfeiExpedition;
A.fatigueDiscount <- function(a,s) {
    local n=0,weapon=this.weaponSkill(s),special=s.getID().find("actives.afei_")==0;
    if(special && this.SkillDefs[s.m.AfeiKey].order)return 0;
    if(weapon && this.activeBuff(a,"shadow"))n=8;
    if((weapon || special) && this.activeBuff(a,"cup"))n=::Math.max(n,this.battleG(a,"cup_value"));
    if(weapon && !s.isRanged() && this.has(a,"together_lift") && this.allies(a,2).len()>=2)n=::Math.max(n,2);
    if(weapon && this.weaponType(a,::Const.Items.WeaponType.Throwing) && this.battleG(a,"budget_ready"))n=::Math.max(n,5);
    if(this.ordinary(s) && !s.isRanged() && this.has(a,"long_run_breath") && a.getFatigue()>=a.getFatigueMax()*0.6)n=::Math.max(n,2);
    
    return n;
};
A.actionFatigue <- function(a,key) {
    local d=this.SkillDefs[key],n=d.fatigue;
    if(this.grown(a)) {local values={unselectable=16,shrink_cover=14,short_sprint=10,line_detour=9,door_block=12};if(key in values)n=values[key];}
    if(d.weapon) {local basic=this.basicAttack(a,key=="catch_rear");if(basic!=null)n=::Math.ceil(n*basic.m.FatigueCostMult);if(this.has(a,"finals_moment") && key!="catch_rear" && this.round()>=5)n+=3;}
    local cut=0;if(!d.order && this.activeBuff(a,"cup"))cut=this.battleG(a,"cup_value");if(d.weapon && this.activeBuff(a,"shadow"))cut=::Math.max(cut,8);
    if(d.weapon && key!="catch_rear" && this.has(a,"together_lift") && this.allies(a,2).len()>=2)cut=::Math.max(cut,2);
    return ::Math.max(0,n-cut);
};
A.basicAttack <- function(a,ranged=false) {local weapon=this.weapon(a);if(weapon==null)return null;foreach(s in a.getSkills().m.Skills)if(s.isActive() && s.isAttack() && s.isTargeted() && s.getItem()==weapon && s.isRanged()==ranged && this.BasicAttacks.find(s.getID())!=null && !("IsAOE" in s.m && s.m.IsAOE))return s;return null;};
A.actionUsable <- function(a,key) {
    local d=this.SkillDefs[key];if(!d.active || !this.ready(a) || this.g(a,"camped"))return false;
    if(this.battleG(a,"cooldown_"+key)>this.round())return false;
    local limit=d.limit;if(key=="return_road" && this.grown(a))limit=2;if(key=="bear_strike" && this.grown(a))limit=3;
    if(limit>0 && this.battleG(a,"used_"+key)>=limit)return false;if(d.order && !this.canUseOrder())return false;
    if(["guard_gate","guard_nest","cover_up","shrink_cover","guard_self","hold_curtain"].find(key)!=null && !this.shield(a))return false;
    if(["toad_escape","guard_swap","foot_point","return_road","king_dance","curtain_yield","short_sprint","gaga_charge","line_detour"].find(key)!=null && this.rooted(a))return false;
    if(key=="toad_escape" && a.getHitpoints()>a.getHitpointsMax()*0.5 && this.enemies(a).len()<2)return false;
    if(key=="unselectable" && this.enemies(a).len()>0)return false;
    if(key=="nicotine" && a.getFatigue()<=0)return false;
    if(key=="full_circle" && !this.w("awakened"))return false;
    if(key=="bear_strike" && this.battleG(a,"understand")<1)return false;
    if(key=="prince_order") {local c=this.named("C01");if(a.getID()!=this.w("battle_proxy") || (c!=null && this.battleG(c,"deployed") && this.ready(c)))return false;}
    if(key=="curtain_yield" && !this.battleG(a,"curtain_enemy"))return false;
    if(key=="lock_wagon" && !(this.grown(a) && this.battleG(a,"used_lock_wagon")==0) && ::World.Assets.getArmorParts()<2)return false;
    if(d.weapon) {local w=this.weapon(a),s=this.basicAttack(a,key=="catch_rear");if(w==null || s==null)return false;
        if(["bottle_breakthrough","gaga_charge","snake_trial"].find(key)!=null && (!w.isItemType(::Const.Items.ItemType.MeleeWeapon) || !w.isItemType(::Const.Items.ItemType.OneHanded)))return false;
        if(key=="catch_rear" && (!w.isWeaponType(::Const.Items.WeaponType.Bow) || !("getAmmo" in s) || s.getAmmo()<=0))return false;
        if(key=="breach_strike" && (!w.isItemType(::Const.Items.ItemType.TwoHanded) || !w.isWeaponType(::Const.Items.WeaponType.Polearm)))return false;
    }
    if(this.activeBuff(a,"shrink") && d.weapon)return false;return true;
};
A.emptyStep <- function(from,to,occupied=null,flat=true) {if(from==null || to==null || from.getDistanceTo(to)!=1 || from.Level!=to.Level || (!to.IsEmpty && (occupied==null || to.getEntity()!=occupied)))return false;return !flat || ::Const.DefaultMovementAPCost[to.Type]<=2;};
A.path <- function(a,to,max=2) {local from=a.getTile();if(to.IsEmpty && this.emptyStep(from,to))return [to];if(max<2 || !to.IsEmpty || from.getDistanceTo(to)!=2)return null;for(local i=0;i<6;i++)if(from.hasNextTile(i)) {local mid=from.getNextTile(i);if(this.emptyStep(from,mid) && this.emptyStep(mid,to))return [mid,to];}
return null;};
A.validEnemy <- function(a,tile,range) {return tile!=null && tile.IsOccupiedByActor && tile.IsVisibleForPlayer && !tile.getEntity().isAlliedWith(a) && tile.getEntity().isAlive() && a.getTile().getDistanceTo(tile)<=range;};
A.actionTarget <- function(skill,a,tile) {
    if(tile==null)return false;local key=skill.m.AfeiKey,d=this.SkillDefs[key],sel=skill.m.Selection;
    if(sel!=null && this.multi(key))return this.selectionTarget(skill,a,tile); // complete plan is validated atomically before payment
    if(d.target=="self")return tile.ID==a.getTile().ID;
    if(d.target=="empty")return this.path(a,tile,d.range)!=null;
    if(!tile.IsOccupiedByActor || !tile.IsVisibleForPlayer)return false;
    local t=tile.getEntity();if(a.getTile().getDistanceTo(tile)>skill.getMaxRange())return false;
    if(d.target=="enemy") {
        if(!this.validEnemy(a,tile,skill.getMaxRange()))return false;
        if(key=="mouth_strong")return this.mentalTarget(t,false) && this.basicAttack(t)!=null && this.basicAttack(t).isInRange(a.getTile()) && this.basicAttack(t).onVerifyTarget(t.getTile(),a.getTile());
        if(key=="snake_trial" && this.battleG(t,"snake_applied_round",-1)==this.round())return false;
        if(key=="door_block")return this.humanoid(t) && this.pushCharges(t)==0;
        if(d.weapon && key!="catch_rear") {local atk=this.basicAttack(a);if(atk==null || !atk.isInRange(tile) || !atk.onVerifyTarget(a.getTile(),tile))return false;}
        if(key=="dog_bark" || key=="bear_strike")return this.mentalTarget(t);
        if(key=="catch_rear")return a.getTile().getDistanceTo(tile)>=2 && this.allies(t,1).len()>0;
        return true;
    }
    if(!this.player(t) || !this.ready(t))return false;
    if(key=="borrow_strike")return t.getBaseProperties().MeleeSkill>a.getBaseProperties().MeleeSkill;
    if(key=="spare_key")return t.getSkills().hasSkill("effects.net") || t.getSkills().hasSkill("effects.web");
    if(key=="guard_swap" || key=="return_road")return t!=a && !this.rooted(t) && t.getCurrentProperties().IsMovable && t.getTile().Level==a.getTile().Level;
    if(["cover_up","pokemon"].find(key)!=null)return t!=a;
    if(key=="catch_baton")return t!=a && !this.battleG(t,"acted_"+this.round());
    if(key=="dui_sentence")return t!=a && this.relaySource(a,t)!=null;
    if(key=="pang_share")return t!=a && this.distance(a,t)==1;
    return true;
};
A.multi <- function(key) {return ["abacus_mark","shadow_captain","steady_hand","cup_signal","catch_rear","gaga_charge","return_road","king_dance","door_block"].find(key)!=null;};
A.selectionHint <- function(skill) {local key=skill.m.AfeiKey;if(key=="cup_signal")return "先用调节看懂定好层数，再点人。点满3人即生效；人未满可按确认选择，点已选的人可取消。未生效不扣费。";if(["abacus_mark","shadow_captain","steady_hand"].find(key)!=null)return "点选加入，再点一次取消。人数点满即生效；未满可按确认选择。未生效不扣费。";if(key=="catch_rear")return "先选敌人，再选其相邻的受护伙伴，第二下即生效。";if(key=="gaga_charge")return "先选落脚空格，再选该格邻接的敌人，第二下即生效。";if(key=="return_road")return "先选伙伴，再选自己将去的相邻空格，第二下双方一起走。";if(key=="king_dance")return "先选相邻落点，再选受益伙伴。人数点满即生效；未满时点自己，或按确认选择。";if(key=="door_block")return "先选敌人，再选把他推入的同高空格，第二下即生效。";return "合法目标与成本全部确认后才扣费。";};
A.finishSelection <- function(skill,a) {
 local ok=this.commitAction(skill,a,skill.m.Selection);
 if(ok)skill.m.Selection=null;
 return ok;
};
A.selectAction <- function(skill,a,tile) {
    local key=skill.m.AfeiKey;if(!this.actionUsable(a,key))return false;this.cancelSelections(a,key);
    if(tile==null)tile=a.getTile();
    if(!this.multi(key)) {if(!this.actionTarget(skill,a,tile))return false;return this.commitAction(skill,a,{tile=tile,targets=[],extra=0});}
    if(skill.m.Selection==null)skill.m.Selection={tile=null,targets=[],extra=0};local plan=skill.m.Selection;
    if(["abacus_mark","shadow_captain","steady_hand","cup_signal"].find(key)!=null) {
        
        if(!tile.IsOccupiedByActor)return false;local t=tile.getEntity();local max=key=="abacus_mark"?(this.grown(a)?2:1):(key=="shadow_captain"?2:(key=="cup_signal"?3:(this.grown(a)?5:4)));
        local at=plan.targets.find(t);if(at!=null)plan.targets.remove(at);else if(plan.targets.len()<max && this.selectionTarget(skill,a,tile))plan.targets.push(t);
        if(plan.targets.len()==max) {local ok=this.finishSelection(skill,a);if(ok)return ok;}
        a.setDirty(true);return false;
    }
    if(plan.tile==null) {if(!this.selectionTarget(skill,a,tile))return false;plan.tile=tile;a.setDirty(true);return false;}
    if(key=="king_dance") {
        local cap=this.grown(a)?3:2;
        if(tile.ID==a.getTile().ID && plan.tile!=null && plan.targets.len()>0) return this.finishSelection(skill,a);
        if(tile.IsOccupiedByActor) {local t=tile.getEntity();if(t!=a && this.player(t) && this.ready(t) && plan.tile.getDistanceTo(tile)==1 && plan.targets.find(t)==null && plan.targets.len()<cap)plan.targets.push(t);}
        if(plan.targets.len()==cap) {local ok=this.finishSelection(skill,a);if(ok)return ok;}
        a.setDirty(true);return false;
    }
    plan.targets=[tile];local ok=this.commitAction(skill,a,plan);if(ok)skill.m.Selection=null;return ok;
};
A.commitAction <- function(skill,a,plan) {
    local key=skill.m.AfeiKey,d=this.SkillDefs[key],tile=plan.tile==null?a.getTile():plan.tile,t=tile.IsOccupiedByActor?tile.getEntity():null;
    if(!this.actionUsable(a,key) || a.getActionPoints()<skill.getActionPointCost() || a.getFatigue()+skill.getFatigueCost()>a.getFatigueMax())return false;
    if(!this.validatePlan(skill,a,plan))return false;
    local tools=key=="lock_wagon" && !(this.grown(a) && this.battleG(a,"used_lock_wagon")==0)?2:0;if(!this.canPay(0,0,tools))return false;
    if(d.order && !this.consumeOrder())return false;
    local cost=skill.getFatigueCost();a.setActionPoints(a.getActionPoints()-skill.getActionPointCost());a.setFatigue(a.getFatigue()+cost);if(tools)this.pay(0,0,tools);
    this.battleInc(a,"used_"+key);this.battleS(a,"cooldown_"+key,this.round()+(key=="return_road" && this.grown(a)?2:d.cooldown));this.battleS(a,"used_action",true);
    if(!d.order) {this.removeBuff(a,"cup");if(d.weapon)this.removeBuff(a,"shadow");}
    if(d.weapon)this.removeBuff(a,"hidden");
    this.executeAction(skill,a,plan);a.getSkills().update();a.setDirty(true);return true;
};
A.validatePlan <- function(skill,a,plan) {
    local key=skill.m.AfeiKey,tile=plan.tile==null?a.getTile():plan.tile;
    if(["abacus_mark","shadow_captain","steady_hand","cup_signal"].find(key)!=null) {
        if(plan.targets.len()==0)return false;local max=key=="abacus_mark"?(this.grown(a)?2:1):(key=="shadow_captain"?2:(key=="steady_hand"?(this.grown(a)?5:4):3));if(plan.targets.len()>max)return false;
        local unique={};foreach(t in plan.targets) {if(t!=null && t.getID() in unique)return false;if(t!=null)unique[t.getID()]<-true;if(t==null || !t.isAlive() || this.distance(a,t)>skill.getMaxRange())return false;if(key=="abacus_mark") {if(t.isAlliedWith(a) || !t.getTile().IsVisibleForPlayer)return false;}
else if(!this.ready(t) || !this.player(t))return false;}
        if(key=="cup_signal" && (plan.extra<0 || plan.extra>2 || plan.extra>this.battleG(a,"understand")))return false;
        return true;
    }
    if(key=="catch_rear") {if(plan.targets.len()!=1 || !this.validEnemy(a,tile,4) || a.getTile().getDistanceTo(tile)<2)return false;local other=plan.targets[0];if(!other.IsOccupiedByActor || !this.player(other.getEntity()) || !this.ready(other.getEntity()) || other.getDistanceTo(tile)!=1)return false;return this.basicAttack(a,true).onVerifyTarget(a.getTile(),tile);}
    if(key=="gaga_charge")return plan.targets.len()==1 && this.path(a,tile,1)!=null && plan.targets[0].IsOccupiedByActor && !plan.targets[0].getEntity().isAlliedWith(a) && tile.getDistanceTo(plan.targets[0])==1;
    if(key=="return_road") {if(plan.targets.len()!=1 || !tile.IsOccupiedByActor)return false;local b=tile.getEntity(),dest=plan.targets[0];if(!this.ready(b) || this.rooted(b) || this.distance(a,b)!=1)return false;for(local dir=0;dir<6;dir++)if(a.getTile().hasNextTile(dir) && a.getTile().getNextTile(dir).ID==dest.ID && b.getTile().hasNextTile(dir)) {local bd=b.getTile().getNextTile(dir);return this.emptyStep(a.getTile(),dest,b,false) && this.emptyStep(b.getTile(),bd,a,false) && dest.ID!=bd.ID;}
return false;}
    if(key=="king_dance") {if(this.path(a,tile,1)==null)return false;foreach(b in plan.targets)if(b==a || !this.player(b) || !this.ready(b) || tile.getDistanceTo(b.getTile())!=1)return false;return plan.targets.len()>0;}
    if(key=="door_block")return plan.targets.len()==1 && this.validEnemy(a,tile,1) && this.humanoid(tile.getEntity()) && this.pushCharges(tile.getEntity())==0 && this.emptyStep(tile,plan.targets[0],null,false) && a.getTile().getDistanceTo(plan.targets[0])>=a.getTile().getDistanceTo(tile);
    return this.actionTarget(skill,a,tile);
};
A.executeAction <- function(skill,a,plan) {
    local key=skill.m.AfeiKey,tile=plan.tile==null?a.getTile():plan.tile,t=tile.IsOccupiedByActor?tile.getEntity():null;
    switch(key) {
        case "wawa_call":local value=::Math.max(6,::Math.min(20,6+::Math.floor((a.getBaseProperties().Bravery-20)/5.0)));foreach(b in this.allies(a,this.grown(a)?4:3,false))this.orderBuff(a,b,"wawa",value);break;
        case "full_circle":foreach(b in this.allies(a,4,false)) {this.recover(b,20);this.orderBuff(a,b,"circle",20);}
break;
        case "toad_escape":this.movePath(a,[tile],true);break;
        case "abacus_mark":foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)if(this.battleG(b,"abacus_source")==a.getID())this.removeBuff(b,"abacus");foreach(b in plan.targets)this.buff(b,"abacus",{source=a.getID()});break;
        case "pang_share":this.buff(t,"pang",{source=a.getID(),defense=this.grown(a)?6:4},2);break;
        case "berry_mark":foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)if(this.battleG(b,"berry_source")==a.getID())this.removeBuff(b,"berry");this.buff(t,"berry",{source=a.getID()},this.grown(a)?3:2);break;
        case "shadow_captain":foreach(b in plan.targets)this.buff(b,"shadow",{source=a.getID()});break;
        case "borrow_strike":this.buff(a,"borrow",{value=::Math.min(this.grown(a)?15:10,t.getBaseProperties().MeleeSkill-a.getBaseProperties().MeleeSkill),charges=this.grown(a)?3:2});break;
        case "bottle_breakthrough":this.performWeapon(a,t,key);if(!this.grown(a)){this.buff(a,"bottlepen");this.untilStart(a,"bottlepen");}
break;
        case "unselectable":this.buff(a,"hidden");this.untilStart(a,"hidden");break;
        case "dog_bark":this.buff(t,"dog",null,100000,this.battleG(t,"turns")+1);break;
        case "guard_swap":this.battleS(a,"swap_partner",t.getID());::Tactical.getNavigator().switchEntities(a,t,null,null,1.0);break;
        case "nicotine":this.recover(a,15);this.battleS(a,"nicotine_debt",2);break;
        case "cover_up":this.stance(a,"cover");this.battleS(a,"cover_target",t.getID());break;
        case "drum":this.battleS(a,"drum_gate",true);foreach(b in this.allies(a,3,false))this.buff(b,"drum",{source=a.getID()},100000);break;
        case "guard_gate":this.stance(a,"gate");this.battleS(a,"gate_aoo_used",false);this.battleS(a,"drum_gate",true);break;
        case "prince_order":foreach(b in this.allies(a,3,false))this.orderBuff(a,b,"prince",10,5);break;
        case "dui_sentence":local copy=this.relaySource(a,t);if(copy!=null) {local seq=this.battleG(a,copy+"_seq");this.buff(t,copy,{bravery=this.battleG(a,copy+"_bravery"),defense=this.battleG(a,copy+"_defense"),source=this.battleG(a,copy+"_source"),seq=seq},this.battleG(a,copy+"_until")-this.round()+1);this.battleS(t,"received_order_"+seq,true);this.sw("relayed_"+this.battleKey()+"_"+seq,true);this.battleS(a,"relay",true);}
this.battleS(a,"fear_penalty_until",-1);break;
        case "steady_hand":this.battleS(a,"steady",true);foreach(b in plan.targets) {this.orderBuff(a,b,"steady",6,6);this.battleS(b,"steady_charges",1);}
break;
        case "catch_rear":local b=plan.targets[0].getEntity();this.performWeapon(a,t,key);this.buff(b,"withdraw",{enemy=t.getID(),source=a.getID()},100000,this.battleG(b,"turns")+1);break;
        case "gaga_charge":local enemy=plan.targets[0].getEntity();if(this.movePath(a,[tile],false) && this.ready(a)) {this.battleS(a,"charge",true);if(this.performWeapon(a,enemy,key))this.pushAway(a,enemy);}
break;
        case "guard_nest":this.stance(a,"nest");break;
        case "lock_wagon":this.sw("trap_"+this.battleKey()+"_"+tile.ID,a.getID());break;
        case "spare_key":if(t.getSkills().hasSkill("effects.net"))t.getSkills().removeByID("effects.net");else t.getSkills().removeByID("effects.web");this.battleS(a,"net_freed",true);break;
        case "foot_point":if(this.movePath(a,this.path(a,tile),false))this.buff(a,"foot",null,100000,this.battleG(a,"turns")+1);break;
        case "hard_brake":this.stance(a,"brake");break;
        case "return_road":this.synchronousStep(a,t,plan.targets[0]);this.battleS(a,"return_partner",t.getID());break;
        case "pokemon":this.battleS(a,"pokemon_target",t.getID());this.battleS(a,"threat",0);this.buff(t,"pokemon",{source=a.getID()});break;
        case "bear_strike":this.battleInc(a,"understand",-1);this.s(a,"bear_used",true);this.buff(t,"bear");break;
        case "cup_signal":this.battleInc(a,"understand",-plan.extra);this.s(a,"cup_used",true);foreach(b in plan.targets)this.buff(b,"cup",{value=4+2*plan.extra});break;
        case "mouth_strong":this.buff(t,"taunt",{source=a.getID()},100000,this.battleG(t,"turns")+1);break;
        case "shrink_cover":this.stance(a,"shrink");break;
        case "long_watch":this.stance(a,"watch");break;
        case "king_dance":if(this.movePath(a,[tile],false) && this.ready(a))foreach(b in plan.targets) {this.buff(b,"dance",null,100000,this.battleG(b,"turns")+1);this.bump(a,"dance_recipients");}
break;
        case "curtain_yield":this.movePath(a,[tile],false,this.battleG(a,"curtain_enemy"));this.battleS(a,"curtain",true);this.battleS(a,"curtain_enemy",0);break;
        case "guard_self":this.stance(a,"selfguard");break;
        case "short_sprint":if(this.movePath(a,this.path(a,tile),false)) {this.buff(a,"sprint",null,1);this.battleS(a,"sprint",true);}
break;
        case "snake_trial":if(this.performWeapon(a,t,key)) {this.buff(t,"snake",null,100000,this.battleG(t,"turns")+1);this.battleS(t,"snake_applied_round",this.round());}
break;
        case "hold_curtain":this.stance(a,"curtain");break;
        case "breach_strike":if(this.performWeapon(a,t,key))this.pushAway(a,t);break;
        case "line_detour":local ignore=0;foreach(enemy in this.enemies(a))if(enemy.getTile().getDistanceTo(tile)==1){ignore=enemy.getID();break;}
this.movePath(a,[tile],false,ignore);break;
        case "catch_baton":this.buff(t,"baton",{source=a.getID()},1);break;
        case "door_block":if(::Math.rand(1,100)<=::Math.max(5,::Math.min(95,a.getCurrentProperties().MeleeSkill+5-t.getCurrentProperties().MeleeDefense)) && this.pushTo(t,plan.targets[0]))this.bump(a,"door_success");break;
    }
};
A.relaySource <- function(a,t) {foreach(k in ["wawa","steady","prince"])if(this.activeBuff(a,k)) {local seq=this.battleG(a,k+"_seq");if(!this.battleG(t,"received_order_"+seq) && !this.w("relayed_"+this.battleKey()+"_"+seq))return k;}
return null;};
A.performWeapon <- function(a,t,key) {local basic=this.basicAttack(a,key=="catch_rear");if(basic==null || t==null || !t.isAlive())return false;this.battleS(a,"weapon_context",key);if(key=="catch_rear")basic.consumeAmmo();local hit=basic.attackEntity(a,t);this.battleS(a,"weapon_context","");return hit;};
A.movePath <- function(a,path,immune=false,except=0) {
    if(path==null)return false;
    foreach(tile in path) {
        if(!this.ready(a) || a.getCurrentProperties().IsRooted)return false;
        if(!immune)foreach(e in this.enemies(a))if(e.getID()!=except && e.hasZoneOfControl()) {if(e.onMovementInZoneOfControl(a,false))e.onAttackOfOpportunity(a,false);if(!this.ready(a) || a.getCurrentProperties().IsRooted)return false;}
        local from=a.getTile();this.battleS(a,"special_moving",true);::Tactical.getNavigator().teleport(a,tile,null,null,false);this.battleS(a,"special_moving",false);this.movementStep(a,from,tile,false);
    }
    return true;
};
A.synchronousStep <- function(a,b,dest) {for(local i=0;i<6;i++)if(a.getTile().hasNextTile(i) && a.getTile().getNextTile(i).ID==dest.ID) {
    local bd=b.getTile().getNextTile(i);if(dest.ID==b.getTile().ID) {this.movePath(b,[bd],true);this.movePath(a,[dest],true);}
else {this.movePath(a,[dest],true);this.movePath(b,[bd],true);}
return true;}
return false;};
A.consumePushImmunity <- function(a) {local selected=null,expiry=100001;foreach(k in ["steady","gate","curtain"])if(this.activeBuff(a,k) && this.battleG(a,k+"_charges")>0 && this.battleG(a,k+"_until")<expiry) {selected=k;expiry=this.battleG(a,k+"_until");}
if(selected==null)return false;this.battleInc(a,selected+"_charges",-1);return true;};
A.pushTo <- function(a,tile) {if(!this.humanoid(a) || !this.emptyStep(a.getTile(),tile,null,false) || this.consumePushImmunity(a))return false;::Tactical.getNavigator().teleport(a,tile,null,null,false);return true;};
A.pushAway <- function(a,t) {local best=null,dist=a.getTile().getDistanceTo(t.getTile());for(local i=0;i<6;i++)if(t.getTile().hasNextTile(i)) {local tile=t.getTile().getNextTile(i);if(this.emptyStep(t.getTile(),tile,null,false) && a.getTile().getDistanceTo(tile)>dist) {best=tile;dist=a.getTile().getDistanceTo(tile);}
}
return best!=null && this.pushTo(t,best);};
