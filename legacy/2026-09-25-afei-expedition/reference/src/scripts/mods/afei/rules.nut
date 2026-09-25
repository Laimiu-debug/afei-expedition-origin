local A=::AfeiExpedition;
A.BasicAttacks <- ["actives.thrust","actives.stab","actives.slash","actives.cleave","actives.chop","actives.bash","actives.pound","actives.strike","actives.flail","actives.hammer","actives.crush_armor","actives.prong","actives.impale","actives.hook","actives.smite","actives.shoot_bow","actives.quick_shot","actives.aimed_shot","actives.shoot_bolt","actives.throw_javelin","actives.throw_axe","actives.throw_spear"];
A.ordinary <- function(s) {return this.weaponSkill(s) && this.BasicAttacks.find(s.getID())!=null && this.battleG(s.getContainer().getActor(),"weapon_context","")=="";};
A.clearBattleFlags <- function(a) {
 local remove=[];foreach(k,v in a.getFlags().m)if(k.find("afei_b")==0 && k.len()>6 && k[6]>=48 && k[6]<=57)remove.push(k);
 foreach(k in remove)a.getFlags().remove(k);
};
A.legalSingle <- function(a,s,t,origin=null) {
 if(a==null || s==null || t==null || !t.isAlive() || t.isAlliedWith(a) || !t.isAttackable())return false;
 local tile=t.getTile();if(origin==null)origin=a.getTile();
 return (!s.m.IsVisibleTileNeeded || tile.IsVisibleForEntity) && s.isInRange(tile,origin) && s.onVerifyTarget(origin,tile);
};
A.targetAllowed <- function(a,s,t,origin=null) {
 if(!s.isTargeted() || s.isAOE() || a.isAlliedWith(t))return true;
 if(this.activeBuff(a,"taunt") && this.weaponSkill(s) && !s.isRanged()) {
   local source=this.findActor(this.battleG(a,"taunt_source"));
   if(this.ready(source) && source.getID()!=t.getID() && this.distance(a,source)==1 && this.legalSingle(a,s,source,origin))return false;
 }
 if(this.activeBuff(t,"hidden"))foreach(other in this.actors())if(other.getID()!=t.getID() && this.player(other) && this.legalSingle(a,s,other,origin))return false;
 return true;
};
A.intercept <- function(a,s,t,consume=true) {
 if(!this.weaponSkill(s) || s.isRanged() || a.isAlliedWith(t))return t;
 foreach(b in this.allies(t,1))if(this.activeBuff(b,"cover") && this.battleG(b,"cover_target")==t.getID() && this.battleG(b,"cover_charges")>0 && this.legalSingle(a,s,b)) {
   if(consume) {this.battleS(b,"cover_charges",0);this.battleS(b,"cover",true);this.battleS(b,"cover_reduce_attacker",a.getID());this.battleS(b,"cover_reduce_skill",s.getID());}
   return b;
 }
 return t;
};
A.lifeDamage <- function(a,attacker,skill,damage) {
 if(damage<=0)return damage;local reduction=0.0;
 if(this.weaponSkill(skill)) {
   if(this.battleG(a,"cover_reduce_attacker")==this.id(attacker) && this.battleG(a,"cover_reduce_skill","")==skill.getID()) {reduction=0.15;this.battleS(a,"cover_reduce_attacker",0);}
   if(this.activeBuff(a,"shrink") && this.battleG(a,"shrink_charges")>0) {reduction=::Math.maxf(reduction,0.2);this.battleInc(a,"shrink_charges",-1);}
 }
 if(this.activeBuff(a,"selfguard") && this.battleG(a,"selfguard_charges")>0) {reduction=::Math.maxf(reduction,this.grown(a)?0.15:0.1);this.battleInc(a,"selfguard_charges",-1);}
 return ::Math.floor(damage*(1.0-reduction));
};
A.ignoreMoraleFailure <- function(a) {
 if(!this.has(a,"optimist") || this.battleG(a,"optimist_used")>=(this.grown(a)?2:1) || this.seenThisRound(a,"optimist"))return false;
 this.once(a,"optimist");this.battleInc(a,"optimist_used");return true;
};
A.defenseProperties <- function(a,attacker,skill,p) {
 if(attacker==null || skill==null || !this.weaponSkill(skill) || skill.isRanged())return;
 if(this.has(a,"remember_shield") && this.shield(a) && this.battleG(a,"shield_enemy")==attacker.getID() && this.battleG(a,"shield_until",-1)>=this.round()) {
   // Respect the same +15 cap as current-property defenses.
   p.MeleeDefense+=::Math.max(0,::Math.min(6,15-this.battleG(a,"property_md")));
 }
};
A.movementDiscount <- function(a,to,level) {
 if(level!=0 || ::Const.DefaultMovementAPCost[to.Type]>2)return 0;
 local n=0,count=this.battleG(a,"normal_moves"),flat=this.battleG(a,"flat_moves");
 if(this.has(a,"start_run") && this.battleG(a,"turns")==1 && flat==0)n=2;
 if(this.cid(a)=="C15" && this.grown(a) && count==0)n=::Math.max(n,2);
 if(this.has(a,"curve_force") && flat==1 && !this.seenThisRound(a,"curve"))n=::Math.max(n,3);
 return n;
};
A.movementStep <- function(a,from,to,ordinary,level=0) {
 this.battleS(a,"moved_this_turn",true);
 if(ordinary) {
   this.battleInc(a,"moves_round_"+this.round());this.battleInc(a,"normal_moves");
   if(level==0 && ::Const.DefaultMovementAPCost[to.Type]<=2) {this.battleInc(a,"flat_moves");if(this.battleG(a,"flat_moves")==2)this.once(a,"curve");}
   this.battleS(a,"same_level_moves",level==0 && this.battleG(a,"normal_moves")==1?1:0);this.battleS(a,"last_left_tile",from.ID);
 }
else this.battleS(a,"same_level_moves",0);
 foreach(b in this.actors())if(b.getID()!=a.getID() && this.activeBuff(b,"curtain") && b.getTile().getDistanceTo(from)==1 && b.getTile().getDistanceTo(to)>1)this.battleS(b,"curtain_leave",true);
 if(ordinary) {
   local trap="trap_"+this.battleKey()+"_"+to.ID,owner=this.findActor(this.w(trap));
   if(owner!=null && !a.isAlliedWith(owner) && this.isHumanlike(a) && !a.getCurrentProperties().IsImmuneToRoot) {this.sw(trap,0);this.battleS(a,"trap_root",true);a.getSkills().update();}
   if(this.w("bell_round",-1)==this.round() && this.w("bell_tile",-1)==to.ID) {
     local source=this.findActor(this.w("bell_owner"));this.sw("bell_tile",-1);
     if(source!=null && this.player(a) && source.getID()!=a.getID()) {if(this.recover(a,3)>0)this.battleS(source,"bell",true);}
   }
 }
 foreach(b in this.actors())if(b.isAlive())b.getSkills().update();
};
A.onLeave <- function(a,retreated=false) {
 if(retreated && this.player(a) && !this.w("retreat_triggered")) {
   this.sw("retreat_triggered",true);foreach(b in this.actors())if(this.ready(b) && this.has(b,"leave_not_gone"))this.buff(b,"leave");
 }
 foreach(k in this.BuffKeys)this.removeBuff(a,k);
 this.battleS(a,"deployed",false);this.battleS(a,"understand",0);this.battleS(a,"spotlight",0);this.battleS(a,"budget_ready",false);
};
A.canBuyDiscount <- function(item) {
 if(item.isSold() || item.isBought())return "";
 if(item.isItemType(::Const.Items.ItemType.Food) && this.named("C07",true)!=null && this.w("shopping_armed") && this.w("shopping_day",-1)!=this.day())return "food";
 if(this.named("C31",true)!=null && this.w("purse_day",-1)!=this.day() && ["supplies.armor_parts","supplies.medicine","supplies.ammo"].find(item.getID())!=null)return "purse";
 return "";
};
A.discountedPrice <- function(item,price) {local kind=this.canBuyDiscount(item);if(kind=="")return price;return ::Math.ceil(price-::Math.min(30,price*(kind=="food"?0.15:0.05)));};
A.repairPaid <- function(cost) {
 if(cost<=0 || this.named("C02",true)==null)return cost;
 local paid=cost;if(cost>=2 && this.w("scrap_charges")>0) {paid-=1;this.inc("scrap_charges",-1);}
 local n=this.w("scrap_progress")+paid;while(n>=7) {n-=7;this.sw("scrap_charges",::Math.min(3,this.w("scrap_charges")+1));}
this.sw("scrap_progress",n);return paid;
};
A.worldTick <- function() {
 if(!this.isAfeiOrigin())return;
 if(this.w("camp_enabled")) {
   local active=0;foreach(b in this.roster()) {if(this.g(b,"camped"))b.setPlaceInFormation(27);else {active++;if(active>20){this.s(b,"camped",true);b.setPlaceInFormation(27);}
}
}
 }
 this.noteBottlePresence();
 this.refreshMilestones();
 this.applyLooks();
};
A.applyLook <- function(b,id) {
  if(b==null || ["C01","C02","C03","C04","C05","C06"].find(id)==null || !b.hasSprite("body"))return;
  // The painted head, hair and costume are one bust. Keep the game's weapon
  // and shield sprites so equipment changes still appear in combat.
  b.m.IsHidingHelmet=true;
  local body=b.getSprite("body");body.setBrush("afei_figure_"+id);body.Color=b.createColor("#ffffff");body.Saturation=1.0;body.Visible=true;
  foreach(layer in ["head","hair","beard","beard_top","armor","armor_upgrade_back","armor_upgrade_front","helmet","helmet_damage"])
   if(b.hasSprite(layer))b.getSprite(layer).Visible=false;
  b.setDirty(true);
};
A.withCorpseAppearance <- function(b,death) {
  // Native player.onDeath builds a separate corpse from item appearance,
  // ignoring the live sprite visibility flags. Suppress duplicate head/armor
  // only while it creates the corpse, then restore the item state.
  local app=b.getItems().getAppearance();
  local hidden=["HideCorpseHead","CorpseArmor","CorpseArmorUpgrade","CorpseArmorUpgradeBack","CorpseArmorUpgradeFront","HelmetCorpse"];
  local previous={};foreach(key in hidden) {previous[key] <- app[key];app[key]=key=="HideCorpseHead"?true:"";}
  local result=null,error=null;
  try {result=death();} catch(e) {error=e;}
  foreach(key in hidden)app[key]=previous[key];
  if(error!=null)throw error;
  return result;
};
A.applyLooks <- function() {
 if(!this.isAfeiOrigin()) return;
 foreach(b in this.roster()) {
  local id=this.g(b,"named_id");
  if(id!=null && id!="") {this.sw("known_"+id,true);this.applyLook(b,id);}
 }
};
A.ordinaryFatigue <- function(s,cost) {
 local a=s.getContainer().getActor();if(!this.weaponSkill(s))return cost;
 if(!s.isRanged() && this.has(a,"finals_moment") && this.round()>=5)cost+=3;
 return ::Math.max(0,::Math.ceil(cost-this.fatigueDiscount(a,s)));
};
A.cancelSelections <- function(a,keep="") {foreach(s in a.getSkills().m.Skills)if("AfeiKey" in s.m && s.m.AfeiKey!=keep)s.m.Selection=null;};
A.selectionTarget <- function(skill,a,tile) {
 local key=skill.m.AfeiKey,plan=skill.m.Selection;
 if(plan==null)return false;
 if(["abacus_mark","shadow_captain","steady_hand","cup_signal"].find(key)!=null) {
   if(!tile.IsOccupiedByActor || !tile.IsVisibleForPlayer || a.getTile().getDistanceTo(tile)>skill.getMaxRange())return false;
   local t=tile.getEntity();return key=="abacus_mark"?(!t.isAlliedWith(a) && t.isAlive()):(this.ready(t) && this.player(t));
 }
 if(plan.tile==null) {skill.m.Selection=null;local valid=this.actionTarget(skill,a,tile);skill.m.Selection=plan;return valid;}
 if(key=="king_dance")return tile.IsOccupiedByActor && tile.getEntity()!=a && this.player(tile.getEntity()) && this.ready(tile.getEntity()) && plan.tile.getDistanceTo(tile)==1;
 local proposed={tile=plan.tile,targets=[tile],extra=plan.extra};return this.validatePlan(skill,a,proposed);
};
A.pendingSkill <- function(a) {foreach(s in a.getSkills().m.Skills)if("AfeiKey" in s.m && s.m.Selection!=null)return s;return null;};
A.confirmSelection <- function(a) {local s=this.pendingSkill(a);if(s==null)return false;local ok=this.commitAction(s,a,s.m.Selection);if(ok)s.m.Selection=null;return ok;};
A.pushCharges <- function(a) {local n=0;foreach(k in ["steady","gate","curtain"])if(this.activeBuff(a,k))n+=this.battleG(a,k+"_charges");return n;};
A.effectNames <- function(a) {
 local names={wawa="哇哇叫",prince="太子发令",steady="稳一手",circle="全力圈",borrow="借招",abacus="地精算盘记账",shadow="幕后队长",cup="敲杯为号",bottlepen="突破后防御空当",dog="狗叫",hidden="无法选中",loyalty="忠诚护团",drum="定拍",pokemon="保可梦守望",withdraw="指定撤步",bear="小熊出击",foot="踩点",brake="急刹",leave="说走不是真的走",gate="守门",nest="守窝",cover="顶上去",taunt="嘴强王者",shrink="缩进奶盖",watch="长轮守门",dance="大王舞",beat="读拍",selfguard="先护住自己",sprint="短坡冲刺",snake="蛇形试招",curtain="撑住幕布",baton="接住这一棒",duck="侧身回环",blue="蓝旗开场",moon="月饼准备",comeback="返场",pang="借你半面盾",berry="红线记号"};
 local text="号令 "+this.w("order_used")+" / "+this.w("order_max",2)+"；本轮已用："+(this.w("order_round",-1)==this.round()?"是":"否")+"。\n";
 foreach(k in this.BuffKeys)if(this.activeBuff(a,k) && k in names)text+=names[k]+"；";
 if(this.has(a,"know_rules"))text+="看懂 "+this.battleG(a,"understand")+"层；";
 if(this.has(a,"chaoju"))text+="聚光 "+this.battleG(a,"spotlight")+"层；";
 local s=this.pendingSkill(a);if(s!=null) {text+="\n正在选择："+s.getName()+"；已选"+s.m.Selection.targets.len()+"人 / 格；";if(s.m.AfeiKey=="cup_signal")text+="投入看懂"+s.m.Selection.extra+"层；";text+="点满即生效。未满可按确认选择，或按取消选择清空。";}
 return text;
};
A.showLedger <- function() {
 if(!this.isAfeiOrigin()) return false;
 if(("State" in ::Tactical) && ::Tactical.State != null) return false;
 if(::World.Events.hasActiveEvent()) return false;
 local e=::World.Events.getEvent("event.afei_ledger");
 if(e==null) return false;
 e.m.AutoPage="home";
 local state=::World.State;
 if(state.m.MenuStack.hasBacksteps()) {
  if(state.m.WorldTownScreen != null && state.m.WorldTownScreen.isVisible() && !state.m.EventScreen.isVisible() && !state.m.EventScreen.isAnimating()) {
   ::World.Events.m.ActiveEvent=e;
   ::World.Events.m.IsEventShown=true;
   e.fire();
   state.showEventScreenFromTown(e);
   return true;
  }
  return false;
 }
 return ::World.Events.fire("event.afei_ledger",false);
};
