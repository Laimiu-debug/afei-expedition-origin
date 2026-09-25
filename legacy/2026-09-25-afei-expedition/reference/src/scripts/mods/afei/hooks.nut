// Legacy Mod Hooks, using the actual 1.5.2.3 class paths and callbacks.
::include("scripts/mods/afei/native_adapters");
::include("scripts/mods/afei/attack_adapter");
::mods_hookExactClass("skills/skill",function(o) {
 local fatigue=o.getFatigueCost;
 o.getFatigueCost=function() {local n=fatigue();return ::AfeiExpedition.isAfeiOrigin() && ::Tactical.isActive()?::AfeiExpedition.ordinaryFatigue(this,n):n;};
 local usable=o.isUsableOn;
 o.isUsableOn=function(tile,origin=null) {
   if(!usable(tile,origin))return false;local A=::AfeiExpedition;if(!A.isAfeiOrigin())return true;
   local a=this.getContainer().getActor();if(A.activeBuff(a,"shrink") && this.isAttack())return false;
   return !tile.IsOccupiedByActor || A.targetAllowed(a,this,tile.getEntity(),origin);
 };
 local use=o.use;
 o.use=function(tile,free=false) {
   local A=::AfeiExpedition;if(!A.isAfeiOrigin())return use(tile,free);
   local a=this.getContainer().getActor();if(A.activeBuff(a,"shrink") && this.isAttack())return false;
   if(tile!=null && tile.IsOccupiedByActor && !A.targetAllowed(a,this,tile.getEntity()))return false;
   if(!this.isUsable() || (!free && !this.isAffordable()))return false;
   if(A.weaponType(a,::Const.Items.WeaponType.Throwing))A.battleS(a,"ammo_before",A.weapon(a).getAmmo());
   if(this.isAttack())A.removeBuff(a,"hidden");
   local previous=a.getActionPoints();local ok=use(tile,free);
   // 确认/取消/调节看懂是选择过程中的按钮。用完就清选择的话，敲杯层数和多目标都会被自己抹掉。
   local control=this.getID().find("special.afei_")==0;
   if(!control && (ok || a.getActionPoints()<previous)) {
     A.battleS(a,"used_action",true);A.cancelSelections(a);
     if(A.weaponSkill(this)) {A.removeBuff(a,"shadow");A.removeBuff(a,"cup");if(A.ordinary(this) && A.weaponType(a,::Const.Items.WeaponType.Throwing))A.battleS(a,"budget_ready",false);}
   }
   return ok;
 };
 local hit=o.getHitchance;
 o.getHitchance=function(t) {local A=::AfeiExpedition;return hit(A.isAfeiOrigin()?A.intercept(this.getContainer().getActor(),this,t,false):t);};
});
::mods_hookExactClass("skills/skill_container",function(o) {
 local use=o.buildPropertiesForUse;
 o.buildPropertiesForUse=function(s,t) {local p=use(s,t);if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.attackProperties(this.getActor(),s,t,p);return p;};
 local defense=o.buildPropertiesForDefense;
 o.buildPropertiesForDefense=function(a,s) {local p=defense(a,s);if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.defenseProperties(this.getActor(),a,s,p);return p;};
 local hit=o.onTargetHit;
 o.onTargetHit=function(s,t,part,hp,armor) {hit(s,t,part,hp,armor);if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.attackResult(this.getActor(),s,t,true);};
 local miss=o.onTargetMissed;
 o.onTargetMissed=function(s,t) {miss(s,t);if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.attackResult(this.getActor(),s,t,false);};
});
::mods_hookExactClass("entity/tactical/actor",function(o) {
 local turn=o.onTurnStart;
 o.onTurnStart=function() {
   local A=::AfeiExpedition;if(!A.isAfeiOrigin())return turn();
   local p=this.getCurrentProperties(),rate=p.FatigueRecoveryRate,penalty=A.battleG(this,"nicotine_debt")>0;
   if(penalty)p.FatigueRecoveryRate=::Math.max(0,rate-5);local result=turn();p.FatigueRecoveryRate=rate;
   if(penalty)A.battleInc(this,"nicotine_debt",-1);return result;
 };
 local step=o.onMovementStep;
 o.onMovementStep=function(tile,level) {
   local A=::AfeiExpedition;if(!A.isAfeiOrigin())return step(tile,level);
   if(A.rooted(this) || A.battleG(this,"trap_root"))return false;
   local before=this.getFatigue(),from=this.getTile(),cut=A.movementDiscount(this,tile,level),p=this.getCurrentProperties(),old=p.MovementFatigueCostAdditional;
   // Native cost and terrain still decide affordability; only the permitted fixed reduction changes.
   p.MovementFatigueCostAdditional-=cut;local ok=step(tile,level);p.MovementFatigueCostAdditional=old;
   if(ok) {if(this.getFatigue()<before)this.setFatigue(before);A.movementStep(this,from,tile,true,level);}
return ok;
 };
 local aoo=o.onAttackOfOpportunity;
 o.onAttackOfOpportunity=function(target,enter) {
   local A=::AfeiExpedition;if(!A.isAfeiOrigin())return aoo(target,enter);
   if(!enter && A.activeBuff(target,"withdraw") && A.battleG(target,"withdraw_enemy")==this.getID()) {
     local source=A.findActor(A.battleG(target,"withdraw_source"));A.removeBuff(target,"withdraw");if(source!=null)A.battleS(source,"withdraw",true);return false;
   }
   A.battleS(this,"aoo_active",true);local result=aoo(target,enter);A.battleS(this,"aoo_active",false);return result;
 };
  local death=o.onDeath;
  o.onDeath=function(killer,skill,tile,fatality) {
    local A=::AfeiExpedition,id=A.cid(this);if(A.isAfeiOrigin()) {
      local wasBottle=id=="C04";
     if(A.player(this) && !A.battleG(this,"died")) {A.battleS(this,"died",true);A.inc("battle_deaths");local id=A.cid(this);if(id!="")A.sw("dead_"+id,true);if(id=="C01")A.sw("captain_dead",true);}
     if(this.getFlags().get("afei_frost_unhold"))A.sw("m07_target_killed",true);
     A.onLeave(this,false);
     if(wasBottle)::Time.scheduleEvent(::TimeUnit.Real,500,function(_t){::AfeiExpedition.tryOfferBicycleAbandonAfterBottleLeave();},null);
    }
    if(A.isAfeiOrigin() && ["C01","C02","C03","C04","C05","C06"].find(id)!=null)
     return A.withCorpseAppearance(this,function() {return death(killer,skill,tile,fatality);});
    return death(killer,skill,tile,fatality);
 };
 local tooltip=o.getTooltip;
 o.getTooltip=function(s=null) {
   local result=tooltip(s),A=::AfeiExpedition;if(!A.isAfeiOrigin() || !::Tactical.isActive())return result;
   local effects="";foreach(k in A.BuffKeys)if(A.activeBuff(this,k))effects+=k+" ";
   if(effects!="")result.push({id=910,type="text",icon="ui/icons/special.png",text="黑旗效果："+A.effectNames(this)});
   if(A.activeBuff(this,"steady") || A.activeBuff(this,"gate") || A.activeBuff(this,"curtain"))result.push({id=911,type="text",icon="ui/icons/special.png",text="尚未使用的推拉免疫："+A.pushCharges(this)});
   return result;
 };
});
::mods_hookExactClass("entity/tactical/player",function(o) {
 local appearance=o.onAppearanceChanged;
 o.onAppearanceChanged=function(look,dirty=true) {
  local result=appearance(look,dirty),A=::AfeiExpedition,id=A.cid(this);
  if(A.isAfeiOrigin() && ["C01","C02","C03","C04","C05","C06"].find(id)!=null)A.applyLook(this,id);
  return result;
 };
 local wage=o.getDailyCost;
 o.getDailyCost=function() {local n=wage();return ::AfeiExpedition.isAfeiOrigin() && ::AfeiExpedition.g(this,"camped")?::Math.max(2,::Math.ceil(n*0.35)):n;};
 local food=o.getDailyFood;
 o.getDailyFood=function() {return ::AfeiExpedition.isAfeiOrigin() && ::AfeiExpedition.g(this,"camped")?0:food();};
 local xp=o.addXP;
 o.addXP=function(n,scale=true) {local A=::AfeiExpedition;if(A.isAfeiOrigin()) {if(A.g(this,"camped"))return;if(::Tactical.isActive() && A.battleG(this,"mentor"))n=::Math.floor(n*1.5);if(A.cid(this)=="C01" && A.w("bicycle_xp"))n=::Math.floor(n*1.5);}
return xp(n,scale);};
 local load=o.onDeserialize;
   o.onDeserialize=function(input) {load(input);local A=::AfeiExpedition,id=A.cid(this);if(A.isAfeiOrigin() && id in A.Characters) {A.installSkills(this,id);if(!A.g(this,"tavern_candidate"))A.markEverRecruited(id);A.sw("known_"+id,true);if(["C01","C02","C03","C04","C05","C06"].find(id)!=null)A.applyLook(this,id);else this.onAppearanceChanged(this.getItems().getAppearance(),true);}
};
});
::mods_hookExactClass("states/tactical_state",function(o) {
 local round=o.turnsequencebar_onNextRound;
 o.turnsequencebar_onNextRound=function(n) {local A=::AfeiExpedition;if(A.isAfeiOrigin() && n>1)A.endRound();local result=round(n);if(A.isAfeiOrigin() && n==1)A.startBattle();return result;};
 local end=o.onBattleEnded;
 o.onBattleEnded=function() {
   local A=::AfeiExpedition;if(A.isAfeiOrigin() && !this.m.IsExitingToMenu) {
     local r=::Tactical.Entities.getCombatResult(),victory=r==::Const.Tactical.CombatResult.EnemyDestroyed || r==::Const.Tactical.CombatResult.EnemyRetreated;
     A.settleBattle(victory,!this.isScenarioMode() && A.w("battle_had_enemy"));
   }
   local result=end();return result;
 };
 local move=o.handleInvoluntaryMovement;
 o.handleInvoluntaryMovement=function(victim,pusher,from,to,skill,damage,callback) {
   local A=::AfeiExpedition;if(A.isAfeiOrigin() && A.consumePushImmunity(victim))return false;
   return move(victim,pusher,from,to,skill,damage,callback);
 };
});
::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",function(o) {
 local wait=o.entityWaitTurn;
 o.entityWaitTurn=function(a) {if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.battleS(a,"waited",true);return wait(a);};
});
::mods_hookExactClass("contracts/contract_manager",function(o) {
 local finish=o.finishActiveContract;
 o.finishActiveContract=function(cancelled=false) {
   local c=this.m.Active,A=::AfeiExpedition;if(c!=null && A.isAfeiOrigin()) {A.contractComplete(c,!cancelled);A.escortResult(c,!cancelled);}
   return finish(cancelled);
 };
 local retreat=o.onActorRetreated;
 o.onActorRetreated=function(a,id) {if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.onLeave(a,true);return retreat(a,id);};
});
::mods_hookExactClass("states/world_state",function(o) {
 local key=o.onKeyInput;
 o.onKeyInput=function(k) {
   // Battle Brothers key ids: F5=75, F8=78, F9=79 (not SDL scancodes; 65 is numpad-adjacent, not F8)
   if(k.getState()==0 && k.getKey()==78) {
     try { if(::AfeiExpedition.showLedger()) return true; } catch(error) {}
   }
   return key(k);
 };
 local update=o.onUpdate;
 o.onUpdate=function() {local result=update();if(::AfeiExpedition.isAfeiOrigin())::AfeiExpedition.worldTick();return result;};
});
::mods_hookExactClass("entity/world/settlements/buildings/tavern_building",function(o) {
 local clicked=o.onClicked;
 o.onClicked=function(screen) {local result=clicked(screen),town=::AfeiExpedition.town();::Time.scheduleEvent(::TimeUnit.Real,250,function(_t){::AfeiExpedition.offerTavernGuest(town);},null);return result;};
});
::mods_hookExactClass("entity/world/settlement",function(o) {
 local updateRoster=o.updateRoster;
 o.updateRoster=function(force=false) {local result=updateRoster(force);::AfeiExpedition.ensureTownCandidates(this);return result;};
});
::mods_hookExactClass("states/world/asset_manager",function(o) {
 local daily=o.getDailyMoneyCost;
 o.getDailyMoneyCost=function() {local A=::AfeiExpedition;return daily()+(A.isAfeiOrigin() && A.w("camp_enabled") && A.activeCount()<A.roster().len()?30:0);};
 local update=o.update;
 o.update=function(state) {
   local A=::AfeiExpedition;if(!A.isAfeiOrigin())return update(state);
   local before=this.m.ArmorParts,repair=this.isCamping();local result=update(state),cost=before-this.m.ArmorParts;
   if(repair && cost>0) {local paid=A.repairPaid(cost);this.m.ArmorParts+=cost-paid;}
   return result;
 };
});
::mods_hookExactClass("items/item",function(o) {
 local price=o.getBuyPrice;
 o.getBuyPrice=function() {local n=price();return ::AfeiExpedition.isAfeiOrigin()?::AfeiExpedition.discountedPrice(this,n):n;};
 local bought=o.setBought;
 o.setBought=function(v) {local A=::AfeiExpedition;if(v && A.isAfeiOrigin()) {local kind=A.canBuyDiscount(this);if(kind=="food"){A.sw("shopping_day",A.day());A.sw("shopping_armed",false);}
else if(kind=="purse")A.sw("purse_day",A.day());}
return bought(v);};
});
::mods_hookExactClass("skills/backgrounds/character_background",function(o) {
 local appear=o.setAppearance;
 o.setAppearance=function() {
  appear();
  local A=::AfeiExpedition;
  if(!A.isAfeiOrigin()) return;
  local actor=this.getContainer().getActor();
  if(actor!=null) A.applyLook(actor,A.cid(actor));
 };
});
::mods_hookExactClass("ui/screens/character/character_screen",function(o) {
 local dismiss=o.onDismissCharacter;
 o.onDismissCharacter=function(data) {
   local A=::AfeiExpedition;local b=::Tactical.getEntityByID(data[0]);
   if(b!=null && A.isAfeiOrigin()) {
     if(A.cid(b)=="C01")return;
     local wasBottle=A.cid(b)=="C04";
     local result=dismiss(data);
     if(wasBottle)A.tryOfferBicycleAbandonAfterBottleLeave();
     return result;
   }
   return dismiss(data);
 };
});
