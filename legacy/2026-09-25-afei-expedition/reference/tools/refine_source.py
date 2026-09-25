"""One-time integration corrections; retained as implementation provenance."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'src'
def edit(path, replacements):
 p=SRC/path;s=p.read_text(encoding='utf-8')
 for old,new in replacements:
  if old not in s:raise ValueError(f'{path}: missing {old[:90]}')
  s=s.replace(old,new)
 p.write_text(s,encoding='utf-8')
edit('scripts/mods/afei/rules.nut',[("leave_said","leave_not_gone"),("::World.Events.isEventVisible()","::World.Events.hasActiveEvent()")])
edit('scripts/mods/afei/native_adapters.nut',[("not_tricked","not_fooled"),("if (_change < 0 && ::AfeiExpedition.isAfeiOrigin()", "if (_change < 0 && _type != this.Const.MoraleCheckType.MentalAttack && ::AfeiExpedition.isAfeiOrigin()")])
edit('scripts/mods/afei/journeys.nut',[("local tile=path.getTile(i);", "local tile=::World.getTile(path.getCurrent());path.pop();"),("for(local i=0;i<path.getSize();i++)", "while(!path.isEmpty())")])
edit('scripts/entity/world/locations/afei_frost_shadow_location.nut',[("this.m.CombatLocation.Template[0]=\"tactical.enemies\"", "this.m.CombatLocation.Template[0]=null")])
edit('scripts/mods/afei/core.nut',[("!a.getFlags().get(\"Sleeping\") && !a.getFlags().get(\"Charmed\")", "!a.getSkills().hasSkill(\"effects.sleeping\") && !a.getSkills().hasSkill(\"effects.charmed\")")])
edit('scripts/mods/afei/world.nut',[
 ('this.installSkills(b,id); b.getSkills().update();','b.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints-1);this.installSkills(b,id); b.getSkills().update();'),
 ('if(selected.len()>limit)return false;', 'if(selected.len()>limit || (id=="moon_cake" && selected.find(owner)==null))return false;'),
 ('if(!b.getSkills().hasSkill("special.afei_named_brother"))', 'foreach(control in ["confirm","cancel","cup_power"])if(!b.getSkills().hasSkill("special.afei_"+control))b.getSkills().add(::new("scripts/skills/special/afei_"+control));\n    if(!b.getSkills().hasSkill("special.afei_named_brother"))')])
edit('scripts/skills/afei_skill.nut',[("this.m.IsSerialized=false;","this.m.IsSerialized=true;"),('function getMaxRange() {return', 'function getMaxRange() {if(this.m.AfeiKey=="breach_strike") {local s=::AfeiExpedition.basicAttack(this.getContainer().getActor());if(s!=null)return s.getMaxRange();}return')])
edit('scripts/skills/special/afei_rules.nut',[("this.m.IsHidden=true;this.m.IsSerialized=false;", "this.m.IsHidden=false;this.m.IsSerialized=true;"),('function onUpdate(p)', 'function isHidden() {return !::Tactical.isActive();},\n    function getTooltip() {return [{id=1,type="title",text=this.m.Name},{id=2,type="description",text=::AfeiExpedition.effectNames(this.getContainer().getActor())}];},\n    function onUpdate(p)')])
edit('scripts/mods/afei/combat.nut',[
 ('this.battleS(a,"buff_"+key,true);','this.battleS(a,"buff_"+key,true);this.battleS(a,key+"_age",this.inc("buff_serial"));'),
 ('if(!this.battleG(a,"buff_"+key)', 'if(!a.isAlive() || !a.isPlacedOnMap())return false;\n    if(!this.battleG(a,"buff_"+key)'),
 ('this.inc("battle_id");','foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)this.clearBattleFlags(a);\n    this.inc("battle_id");this.sw("retreat_triggered",false);this.sw("battle_had_enemy",false);'),
 ('local actors=this.actors(),captain=null,proxy=null;', 'local actors=this.actors(),captain=null,proxy=null;foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)if(a.isAlive() && !a.isAlliedWithPlayer() && !a.isNonCombatant())this.sw("battle_had_enemy",true);'),
 ('this.battleS(a,"turns",0);','this.battleS(a,"turns",0);foreach(b in actors)if(this.player(b))this.battleS(a,"old_adj_"+b.getID(),a.getTile().getDistanceTo(b.getTile())==1);'),
 ('p.MeleeDefense+=::Math.max(-15,::Math.min(15,md+orderMD));','this.battleS(a,"property_md",::Math.max(-15,::Math.min(15,md+orderMD)));p.MeleeDefense+=this.battleG(a,"property_md");'),
 ('p.Bravery+=orderBr+::Math.max(-15,::Math.min(15,br))', 'p.Bravery+=::Math.min(30,orderBr+br)'),
 ('if(this.has(a,"start_run") && this.round()<=2)opening=::Math.max(opening,8);',''),
 ('if(this.battleG(a,"look_br_round",-1)==this.round())br+=6;', 'if(this.battleG(a,"look_br_turn",-1)==this.battleG(a,"turns"))br+=6;'),
 ('if(this.has(a,"chaoju"))', 'if(this.battleG(a,"trap_root"))p.IsRooted=true;\n    if(this.has(a,"chaoju"))'),
 ('local hit=0,negative=0;', 'local baseTotal=p.DamageTotalMult,baseArmor=p.DamageArmorMult;local hit=0,negative=0;'),
 ('if(this.activeBuff(a,"sprint"))hit+=8;', 'if(!ranged && this.activeBuff(a,"sprint"))hit+=8;'),
 ('if(this.activeBuff(a,"beat") && enemy)hit+=6;', 'if(this.activeBuff(a,"beat") && enemy && !ranged && this.battleG(a,"beat_target")==t.getID())hit+=6;'),
 ('if(this.has(a,"snake_read") && this.battleG(a,"qin_target")==t.getID()', 'if(this.has(a,"snake_read") && !ranged && this.battleG(a,"qin_until_turn")>=this.battleG(a,"turns") && this.battleG(a,"qin_target")==t.getID()'),
 ('this.has(a,"half_react") && !ranged &&', 'this.has(a,"half_react") && this.ordinary(s) && !ranged &&'),
 ('this.has(a,"two_steps") && !ranged &&', 'this.has(a,"two_steps") && this.ordinary(s) && !ranged &&'),
 ('this.has(a,"no_last_throw") && this.battleG(a,"last_throw_uses")<2 && this.weapon(a).getAmmo()==1', 'this.has(a,"no_last_throw") && this.ordinary(s) && this.battleG(a,"last_throw_uses")<2 && this.battleG(a,"ammo_before",this.weapon(a).getAmmo())==1'),
 (' && !this.seenThisRound(a,"lvbu")',''),
 ('this.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded) &&', 'this.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded) && this.weaponType(a,::Const.Items.WeaponType.Polearm) &&'),
 ('if(ranged)p.RangedSkill+=delta;else p.MeleeSkill+=delta;', 'if(ranged)p.RangedSkill+=delta;else p.MeleeSkill+=delta;\n    if(baseTotal>0)p.DamageTotalMult=::Math.minf(p.DamageTotalMult,baseTotal*1.25);if(baseArmor>0 && baseTotal>0 && p.DamageTotalMult*p.DamageArmorMult>baseTotal*baseArmor*1.25)p.DamageArmorMult=baseTotal*baseArmor*1.25/p.DamageTotalMult;'),
 ('local enemy=!a.isAlliedWith(t),range=s.isRanged();', 'local enemy=!a.isAlliedWith(t),range=s.isRanged(),ranged=range;'),
 ('if(!enemy)return;', 'if(!enemy)return;\n    if(this.activeBuff(a,"taunt") && this.battleG(a,"taunt_source")==t.getID() && !range) {this.battleS(t,"taunt",true);this.removeBuff(a,"taunt");}\n    if(this.has(a,"no_last_throw") && this.ordinary(s) && this.weaponType(a,::Const.Items.WeaponType.Throwing) && this.battleG(a,"ammo_before",this.weapon(a).getAmmo())==1 && this.battleG(a,"last_throw_uses")<2)this.battleInc(a,"last_throw_uses");'),
 ('if(this.has(a,"lvbu_weapon"))', 'if(this.has(a,"lvbu_weapon") && this.weapon(a)!=null && this.weapon(a).isItemType(::Const.Items.ItemType.TwoHanded) && this.weaponType(a,::Const.Items.WeaponType.Polearm))'),
 ('foreach(k in ["sprint","beat","bear","snake"])this.removeBuff(a,k);', 'if(!range)this.removeBuff(a,"sprint");if(!range && this.battleG(a,"beat_target")==t.getID())this.removeBuff(a,"beat");this.removeBuff(a,"bear");\n    if(this.has(a,"door_mine") && this.ordinary(s) && !range && this.allies(t,1).len()>=2)this.once(a,"door_mine");'),
 ('if(hit && this.has(a,"curtain_yield"))', 'if(hit && !s.isRanged() && this.has(a,"curtain_yield"))'),
 ('if(this.has(t,"snake_read"))this.battleS(t,"qin_target",a.getID());', 'if(!s.isRanged() && this.has(t,"snake_read") && this.once(t,"qin_observe")) {this.battleS(t,"qin_target",a.getID());this.battleS(t,"qin_until_turn",this.battleG(t,"turns")+1);}'),
 ('if(hit && this.has(t,"remember_shield"))', 'if(hit && !s.isRanged() && this.shield(t) && this.has(t,"remember_shield") && this.once(t,"remember_shield"))'),
 ('if(!hit && this.has(t,"duck_turn") && this.once(t,"duck"))this.buff(t,"duck",null,1);', 'if(!hit && !s.isRanged() && this.has(t,"duck_turn") && this.once(t,"duck"))this.buff(t,"duck",null,100000,this.battleG(t,"turns")+1);'),
 ('if(!hit)foreach(b in this.allies(a,3))if(this.has(b,"read_beat"))', 'if(!hit && !s.isRanged())foreach(b in this.allies(a,1))if(this.has(b,"read_beat") && this.once(b,"read_beat"))'),
 ('if(hit && this.ordinary(s) && this.has(a,"next_path")) {this.battleS(a,"next_path_skill",s.getID());', 'if(hit && !s.isRanged() && this.ordinary(s) && this.has(a,"next_path")) {this.battleS(a,"next_path_target",t.getID());this.battleS(a,"next_path_skill",s.getID());'),
 ('if(this.seenThisRound(a,"turn_start"))return;', 'if(this.round()<1 || !this.w("battle_running") || this.seenThisRound(a,"turn_start"))return;'),
 ('this.battleS(a,"same_level_moves",0);this.battleS(a,"used_action",false);', 'this.battleS(a,"same_level_moves",0);this.battleS(a,"normal_moves",0);this.battleS(a,"flat_moves",0);this.battleS(a,"curtain_enemy",0);this.battleS(a,"next_path_ready",false);this.battleS(a,"used_action",false);'),
 ('if(this.seenThisRound(a,"turn_end"))return;', 'if(this.round()<1 || !this.w("battle_running") || this.seenThisRound(a,"turn_end"))return;'),
 ('this.battleS(a,"look_br_round",this.round()+1);','this.battleS(a,"look_br_turn",this.battleG(a,"turns"));'),
 ('this.battleS(a,"trap_root",false);', 'this.battleS(a,"trap_root",false);this.battleS(a,"curtain_enemy",0);this.removeBuff(a,"sprint");'),
 ('A.endRound <- function() {', 'A.endRound <- function() {\n    this.sw("bell_tile",-1);'),
 ('if(this.has(a,"snake_read") && !ranged && this.battleG(a,"qin_until_turn")>=this.battleG(a,"turns") && this.battleG(a,"qin_target")==t.getID() && this.once(a,"qin"))this.battleS(a,"qin",true);', 'if(this.has(a,"snake_read") && !ranged && this.battleG(a,"qin_until_turn")>=this.battleG(a,"turns") && this.battleG(a,"qin_target")==t.getID() && this.once(a,"qin")) {this.battleS(a,"qin",true);this.battleS(a,"qin_target",0);}')
])
edit('scripts/mods/afei/actions.nut',[
 ('a.getSkills().getAllSkills()', 'a.getSkills().m.Skills'),
 ('::Const.Tactical.Actor.ActionPointCosts', '::Const.DefaultMovementAPCost'),
 (' && s.getID().find("actives.afei_")!=0', ' && this.BasicAttacks.find(s.getID())!=null'),
 ('if(this.ordinary(s) && this.has(a,"next_path") && this.battleG(a,"next_path_ready") && this.battleG(a,"next_path_skill","")!=s.getID())n=::Math.max(n,4);',''),
 ('if(key=="breach_strike" &&', 'if(key=="breach_strike" &&'),
 ('if(d.target=="self")return true;', 'if(d.target=="self")return tile.ID==a.getTile().ID;'),
 ('if(!this.validEnemy(a,tile,d.range))return false;', 'if(!this.validEnemy(a,tile,skill.getMaxRange()))return false;'),
 ('if(key=="dog_bark" || key=="bear_strike")', 'if(key=="snake_trial" && this.battleG(t,"snake_applied_round",-1)==this.round())return false;\n        if(key=="door_block")return this.humanoid(t) && this.pushCharges(t)==0;\n        if(d.weapon && key!="catch_rear") {local base=this.basicAttack(a);if(base==null || !base.isInRange(tile) || !base.onVerifyTarget(a.getTile(),tile))return false;}\n        if(key=="dog_bark" || key=="bear_strike")'),
 ('if(sel!=null && this.multi(key))return true;', 'if(sel!=null && this.multi(key))return this.selectionTarget(skill,a,tile);'),
 ('if(key=="cup_signal")return "先点选友军（最多3人），再点自己确认；按技能旁的备选按钮可选择0/1/2层看懂。未确认不扣费。";', 'if(key=="cup_signal")return "点选至多3人；用调节看懂按钮选择0/1/2层，最后按确认选择。未确认不扣费。";'),
 ('点选目标可加入/取消选择，最后点自己确认', '点选目标可加入/取消选择，最后按确认选择'),
 ('if(tile.ID==a.getTile().ID && plan.targets.len()>0) {local ok=this.commitAction(skill,a,plan);if(ok)skill.m.Selection=null;return ok;}', ''),
 ('if(plan.tile==null) {if(!this.actionTarget(skill,a,tile))return false;', 'if(plan.tile==null) {if(!this.selectionTarget(skill,a,tile))return false;'),
 ('this.actionTarget(clone skill,a,tile)', 'this.selectionTarget(skill,a,tile)'),
 ('(this.grown(a)?5:4)', '4'),
 ('local key=skill.m.AfeiKey;if(!this.actionUsable(a,key))return false;', 'local key=skill.m.AfeiKey;if(!this.actionUsable(a,key))return false;this.cancelSelections(a,key);'),
 ('if(plan.targets.len()==0)return false;', 'if(plan.targets.len()==0)return false;local max=key=="abacus_mark"?(this.grown(a)?2:1):(key=="shadow_captain"?2:(key=="steady_hand"?4:3));if(plan.targets.len()>max)return false;'),
 ('foreach(t in plan.targets) {if(t==null', 'local unique={};foreach(t in plan.targets) {if(t!=null && t.getID() in unique)return false;if(t!=null)unique[t.getID()]<-true;if(t==null'),
 ('return this.emptyStep(a.getTile(),dest,b) && this.emptyStep(b.getTile(),bd,a)', 'return this.emptyStep(a.getTile(),dest,b,false) && this.emptyStep(b.getTile(),bd,a,false)'),
 ('foreach(b in plan.targets)if(!this.ready(b)', 'foreach(b in plan.targets)if(b==a || !this.player(b) || !this.ready(b)'),
 ('this.humanoid(tile.getEntity()) && this.emptyStep(tile,plan.targets[0])', 'this.humanoid(tile.getEntity()) && this.pushCharges(tile.getEntity())==0 && this.emptyStep(tile,plan.targets[0],null,false) && a.getTile().getDistanceTo(plan.targets[0])>=a.getTile().getDistanceTo(tile)'),
 ('A.emptyStep <- function(from,to,occupied=null)', 'A.emptyStep <- function(from,to,occupied=null,flat=true)'),
 ('return ::Const.DefaultMovementAPCost[to.Type]<=2;', 'return !flat || ::Const.DefaultMovementAPCost[to.Type]<=2;'),
 ('case "king_dance":if(this.movePath(a,[tile],false) && this.ready(a))foreach(b in plan.targets) {this.buff(b,"dance");', 'case "king_dance":if(this.movePath(a,[tile],false) && this.ready(a))foreach(b in plan.targets) {this.buff(b,"dance",null,100000,this.battleG(b,"turns")+1);'),
 ('case "snake_trial":if(this.performWeapon(a,t,key))this.buff(t,"snake");', 'case "snake_trial":if(this.performWeapon(a,t,key)) {this.buff(t,"snake",null,100000,this.battleG(t,"turns")+1);this.battleS(t,"snake_applied_round",this.round());}'),
 ('case "line_detour":this.movePath(a,[tile],false,this.enemies(a).len()==1?this.enemies(a)[0].getID():0);', 'case "line_detour":local ignore=0;foreach(enemy in this.enemies(a))if(enemy.getTile().getDistanceTo(tile)==1){ignore=enemy.getID();break;}this.movePath(a,[tile],false,ignore);'),
 ('{e.onMovementInZoneOfControl(a,false);if(!this.ready(a)', '{if(e.onMovementInZoneOfControl(a,false))e.onAttackOfOpportunity(a,false);if(!this.ready(a)'),
 ('this.battleS(a,"special_moving",true);::Tactical', 'local from=a.getTile();this.battleS(a,"special_moving",true);::Tactical'),
 ('this.battleS(a,"moved_this_turn",true);', 'this.movementStep(a,from,tile,false);'),
 ('this.emptyStep(a.getTile(),tile) || this.consumePushImmunity(a)', 'this.emptyStep(a.getTile(),tile,null,false) || this.consumePushImmunity(a)'),
 ('this.emptyStep(t.getTile(),tile) &&', 'this.emptyStep(t.getTile(),tile,null,false) &&'),
 ('if(key=="catch_rear")basic.consumeAmmo();', 'if(key=="catch_rear")basic.consumeAmmo();'),
 ('if(key=="lock_wagon" &&', 'if(key=="lock_wagon" &&'),
 ('this.round()+(key=="return_road" && this.grown(a)?2:d.cooldown)', 'this.round()+(key=="return_road" && this.grown(a)?2:d.cooldown)'),
 ('if(key=="curtain_yield" && !this.battleG(a,"curtain_enemy"))', 'if(key=="curtain_yield" && !this.battleG(a,"curtain_enemy"))')
])
edit('scripts/mods/afei/growth.nut',[
 ('this.sw("m07_medal",true);','this.sw("m07_medal",true);local stash=::World.Assets.getStash();if(stash.getNumberOfEmptySlots()==0)stash.resize(stash.getCapacity()+1);stash.add(::new("scripts/items/misc/afei_frost_medal_item"));'),
 ('this.getJiahaoCount()<16)', 'this.getJiahaoCount()<16 && !this.w("captain_dead"))')])
print('Applied integration corrections')
