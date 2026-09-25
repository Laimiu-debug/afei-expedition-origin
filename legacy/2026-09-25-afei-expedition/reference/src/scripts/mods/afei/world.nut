local A=::AfeiExpedition;
A.food <- function() { local n=0.0; foreach(i in ::World.Assets.getFoodItems()) if(i.getBestBeforeTime()>this.now()) n+=i.getAmount(); return n; };
A.canPay <- function(money=0,food=0,tools=0) { return ::World.Assets.getMoney()>=money && this.food()>=food && ::World.Assets.getArmorParts()>=tools; };
A.pay <- function(money=0,food=0,tools=0) {
    if(!this.canPay(money,food,tools)) return false;
    local left=food.tofloat(), stash=::World.Assets.getStash();
    local items=::World.Assets.getFoodItems(); items.sort(::World.Assets.sortFoodByFreshness);
    foreach(i in items) { if(left<=0) break; if(i.getBestBeforeTime()<=this.now()) continue;
        local take=::Math.minf(left,i.getAmount()); i.setAmount(i.getAmount()-take); left-=take; if(i.getAmount()<=0) stash.remove(i); }
    ::World.Assets.addMoney(-money); ::World.Assets.addArmorParts(-tools); ::World.Assets.updateFood(); return true;
};
A.trySpendFoodApprox <- function(n) { return this.pay(0,n,0); }; // compatibility, now exact units
A.town <- function() { local p=::World.State.getPlayer(); if(p==null) return null; foreach(t in ::World.EntityManager.getSettlements()) if(!t.isMilitary() && t.isAlliedWithPlayer() && t.getTile().getDistanceTo(p.getTile())<=1) return t; return null; };
A.safe <- function() {
    if(::Tactical.isActive() || ::World.State.getCombatStartTime()!=0) return false;
    if(this.town()!=null) return true;
    if(!::World.Assets.isCamping() || !::World.State.isCampingAllowed()) return false;
    foreach(e in ::World.getAllEntitiesAtPos(::World.State.getPlayer().getPos(),400.0))
        if(e!=null && e.isAlive() && !e.isAlliedWithPlayer() && e.getTroops().len()>0) return false;
    return true;
};
A.spendHours <- function(n) {
    // Let native asset updates perform normal wages, food, repair and healing for each elapsed hour.
    for(local i=0;i<n;i++) { ::Time.setVirtualTime(this.now()+this.hours(1)); ::World.Assets.update(::World.State); }
    ::World.State.updateTopbarAssets();
};
A.bumpCohesion <- function(n,ordinary=false) {
    if(ordinary && n>0) { if(this.w("cohesion_day",-1)!=this.day()) { this.sw("cohesion_day",this.day());this.sw("cohesion_gain",0); }
        n=::Math.min(n,::Math.max(0,6-this.w("cohesion_gain"))); this.inc("cohesion_gain",n); }
    this.sw("cohesion",::Math.max(0,::Math.min(100,this.w("cohesion",25)+n)));
    this.sw("cohesion_peak",::Math.max(this.w("cohesion_peak",25),this.w("cohesion")));
};
A.eligible <- function(id) { local d=this.Characters[id]; if(d.recruit_id=="" || this.w("ever_"+id)) return false;
    // Once the invitation has been completed, a later cohesion loss cannot undo it.
    if(this.w("recruit_ready_"+id))return true;
    if(this.day()<d.day || this.getPaidContracts()<d.contracts || this.w("cohesion",25)<d.cohesion) return false;
    foreach(m in d.requires_m) if(!this.w(m.slice(0,3).tolower()+"_done")) return false;
    return true;
};
A.isKnown <- function(id) { return this.w("known_"+id) || this.w("ever_"+id) || this.named(id)!=null; };
A.knownIds <- function() { local ids=[];foreach(id,d in this.Characters)if(this.isKnown(id))ids.push(id);ids.sort();return ids; };
A.hireCost <- function(id) { local n=this.Characters[id].fee; if(this.w("quote","")==id && this.named("C03",true)!=null) n-=::Math.min(200,::Math.floor(n*0.2)); return n; };
A.quote <- function(id) { if(!this.safe() || !this.eligible(id) || this.named("C03",true)==null || this.now()<this.w("steal_until")) return false; this.spendHours(2); this.sw("quote",id); return true; };
A.installSkills <- function(b,id) { foreach(s in this.Characters[id].skills) { if(s.id=="full_circle" && !this.w("awakened")) continue;
    if(!b.getSkills().hasSkill("actives.afei_"+s.id)) b.getSkills().add(::new("scripts/skills/actives/afei_"+s.id)); }
    foreach(control in ["confirm","cancel","cup_power"])if(!b.getSkills().hasSkill("special.afei_"+control))b.getSkills().add(::new("scripts/skills/special/afei_"+control));
    if(!b.getSkills().hasSkill("special.afei_named_brother")) b.getSkills().add(::new("scripts/skills/special/afei_named_brother"));
    if(!b.getSkills().hasSkill("special.afei_rules")) b.getSkills().add(::new("scripts/skills/special/afei_rules"));
};
A.configureBrother <- function(b,id,place=27,joined=true) {
    local d=this.Characters[id];
    b.setName(d.name); b.setTitle(id=="C01"?"团长":(id=="C02" || id=="C03"?"副队长":"黑旗伙伴"));
    // Origin data already includes background characteristics: never add random traits.
    local remove=[]; foreach(s in b.getSkills().m.Skills) if(s.getID().find("trait.")==0) remove.push(s.getID());
    foreach(s in remove) b.getSkills().removeByID(s);
    local p=b.getBaseProperties(); local names=["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
    foreach(i,k in names) p[k]=d.attrs[i];
    local talents=b.getTalents(); talents.resize(::Const.Attributes.COUNT,0); foreach(i,v in talents) talents[i]=0;
    foreach(k,v in d.stars) talents[::Const.Attributes[k]]=v;
    b.m.Level=1;b.m.XP=::Const.LevelXP[0];b.m.LevelUps=0;b.getBackground().m.DailyCost=d.wage;b.getBackground().m.DailyCostMult=1.0;
    this.s(b,"named_id",id);this.s(b,"joined_at",joined?this.now():0);this.s(b,"camped",false);this.s(b,"schema",this.Schema);
    this.applyLook(b,id);
    if(id=="C01") { this.s(b,"captain_afei",true); b.getFlags().set("IsPlayerCharacter",true); }
    b.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints-1);this.installSkills(b,id); b.getSkills().update();b.setHitpoints(b.getHitpointsMax());b.setPlaceInFormation(place);
    if(joined)this.finalizeNamedHire(b);
    return b;
};
A.makeBrother <- function(id,place=27) {
    local d=this.Characters[id],b=::World.getPlayerRoster().create("scripts/entity/tactical/player");b.setStartValuesEx([d.background],false);
    this.configureBrother(b,id,place,true);::World.Assets.updateFormation();return b;
};
A.finalizeNamedHire <- function(b) {
    local id=this.cid(b);if(id=="" || !(id in this.Characters))return false;
    if(!this.w("ever_"+id))foreach(other in this.roster())if(other.getID()!=b.getID() && !this.g(other,"camped"))this.unique(other,"sign_witness",id);
    this.s(b,"tavern_candidate",false);
    this.s(b,"joined_at",this.now());this.markEverRecruited(id);this.sw("known_"+id,true);this.sw("candidate_town_"+id,"");
    local rid=this.Characters[id].recruit_id;if(rid!="")this.sw(rid.tolower()+"_done",true);
    if(this.w("quote","")==id){this.sw("quote","");this.sw("steal_until",this.now()+this.hours(168));local c=this.named("C03",true);if(c!=null)this.unique(c,"steal_hire",id);}
    if(this.activeCount()>20){this.s(b,"camped",true);b.setPlaceInFormation(27);}
    if(id=="C04")this.sw("bottle_was_present",true);
    return true;
};
A.createTavernCandidate <- function(roster,id) {
    foreach(b in roster.getAll())if(this.cid(b)==id)return b;
    local d=this.Characters[id],b=roster.create("scripts/entity/tactical/player");b.setStartValuesEx([d.background],false);
    this.configureBrother(b,id,27,false);b.m.HiringCost=this.hireCost(id);this.s(b,"tavern_candidate",true);return b;
};
A.ensureTownCandidates <- function(town) {
    if(town==null || !this.isAfeiOrigin() || !town.hasBuilding("building.tavern"))return;
    local roster=::World.getRoster(town.getID());foreach(id,d in this.Characters)if(this.w("recruit_ready_"+id) && !this.w("ever_"+id) && this.w("candidate_town_"+id,"")==town.getID())this.createTavernCandidate(roster,id);
};
A.offerTavernGuest <- function(town) {
    if(town==null || !this.isAfeiOrigin())return false;
    if(this.w("tavern_guest_day",-1)==this.day())return false;
    local ids=[];foreach(id,d in this.Characters)if(this.eligible(id) && !this.isKnown(id))ids.push(id);ids.sort();if(ids.len()==0)return false;
    local id=ids[0];this.sw("tavern_guest_day",this.day());this.sw("known_"+id,true);this.sw("candidate_town_"+id,town.getID());this.sw("candidate_town_name_"+id,town.getName());
    local e=::World.Events.getEvent("event.afei_talk");if(e==null)return false;e.m.AutoPage="talk:recruit:"+id;e.m.Notice="";
    ::World.Events.m.ActiveEvent=e;::World.Events.m.IsEventShown=true;e.fire();::World.State.showEventScreenFromTown(e);return true;
};
A.refreshReadyCandidates <- function() {foreach(id,d in this.Characters)if(this.w("recruit_ready_"+id) && !this.w("ever_"+id)){local tid=this.w("candidate_town_"+id,"");foreach(t in ::World.EntityManager.getSettlements())if(t.getID()==tid){this.ensureTownCandidates(t);break;}}};
A.hire <- function(id) {
    if(!this.safe() || !this.eligible(id) || !this.w("recruit_ready_"+id) || this.roster().len()>=(this.w("camp_enabled")?39:20)) return false;
    local fee=this.hireCost(id);if(!this.canPay(fee)) return false;
    local b=this.makeBrother(id);this.pay(fee);
    if(this.w("quote","")==id) { this.sw("quote","");this.sw("steal_until",this.now()+this.hours(168));local c=this.named("C03",true);if(c!=null) this.unique(c,"steal_hire",id); }
    if(this.activeCount()>20) { this.s(b,"camped",true);b.setPlaceInFormation(27); }
    if(id=="C04") this.sw("bottle_was_present",true);
    this.sw(this.Characters[id].recruit_id.tolower()+"_done",true);return true;
};
A.activeCount <- function() { local n=0;foreach(b in this.roster()) if(!this.g(b,"camped")) ++n;return n; };
A.atCamp <- function() { local t=this.town();return t!=null && this.w("camp_enabled") && t.getID()==this.w("camp_home_id"); };
A.assignCamp <- function(activeIds) {
    if(!this.atCamp() || activeIds.len()==0 || activeIds.len()>20 || this.roster().len()-activeIds.len()>19) return false;
    local seen={};foreach(id in activeIds) { if(id in seen) return false;seen[id]<-true; }
    local found=0;foreach(b in this.roster()) if(b.getID() in seen) ++found;if(found!=activeIds.len()) return false;
    this.spendHours(4);foreach(b in this.roster()) { local camp=!(b.getID() in seen);this.s(b,"camped",camp);if(camp)b.setPlaceInFormation(27); }
    ::World.Assets.updateFormation();return true;
};
A.setProxy <- function(id) { local b=this.named(id,true);if(b==null || id=="C01" || b.getPlaceInFormation()>17)return false;this.sw("selected_proxy",id);return true; };
A.review <- function() {
    if(!this.safe() || !this.w("m02_done") || this.now()<this.w("review_until") || !this.pay(80,6)) return false;
    this.spendHours(3);this.sw("review_until",this.now()+this.hours(72));this.bumpCohesion(5);
    foreach(b in this.roster()) if(!this.g(b,"camped"))this.bump(b,"reviews");return true;
};
A.ropeTrain <- function() { local b=this.named("C07",true);if(b==null || !this.safe() || this.now()<this.g(b,"rope_until") || !this.pay(0,3))return false;this.spendHours(2);this.bump(b,"rope_train");this.s(b,"rope_until",this.now()+this.hours(72));return true; };
A.contractComplete <- function(c,success) {
    local key="contract_done_"+c.getID(); if(!success || this.w(key))return;
    local payment=c.m.Payment.getOnCompletion()+c.m.Payment.getInAdvance(); if(payment<=0)return;
    this.sw(key,true);this.completePaid("contract_"+c.getID(),c.getType().find("escort")!=null);
};
A.campAbility <- function(id,selected) {
    local owner=this.named(id=="moon_cake"?"C22":"C16",true);
    if(owner==null || !this.safe() || selected.len()==0 || this.now()<this.g(owner,id+"_until"))return false;
    local limit=id=="moon_cake"?3:2;if(selected.len()>limit || (id=="moon_cake" && selected.find(owner)==null))return false;
    local checked={};foreach(b in selected) {if(b==null || this.g(b,"camped") || b.getID() in checked)return false;checked[b.getID()]<-true;}
    if(!this.pay(0,6))return false;this.spendHours(id=="moon_cake"?2:4);
    this.s(owner,id+"_until",this.now()+this.hours(id=="moon_cake"?72:168));
    foreach(b in selected) if(id=="moon_cake")this.s(b,"moon_ready_until",this.now()+this.hours(168));else this.s(b,"quarrel_until",0);
    if(id=="moon_cake")this.bump(owner,"moon_cake");else this.bumpCohesion(3);return true;
};
A.budgetPrepare <- function(selected) { local b=this.named("C31",true);if(b==null || b.getPlaceInFormation()>17 || !this.safe() || selected.len()==0 || selected.len()>(this.grown(b)?2:1))return false;
    local seen={};foreach(a in selected) {if(a==null || this.g(a,"camped") || a.getPlaceInFormation()>17 || a.getID() in seen)return false;seen[a.getID()]<-true;}
    foreach(a in this.roster())this.s(a,"budget_ready",false);
    foreach(a in selected)this.s(a,"budget_ready",true);return true;
};
A.hasBicycleItem <- function() {
    local stash=::World.Assets.getStash();
    foreach(i in stash.getItems()) if(i!=null && i.getID()=="accessory.afei_bicycle") return true;
    foreach(b in this.roster()) foreach(item in b.getItems().getAllItems()) if(item!=null && item.getID()=="accessory.afei_bicycle") return true;
    return false;
};
A.removeAllBicycles <- function() {
    local stash=::World.Assets.getStash(),remove=[];
    foreach(i in stash.getItems()) if(i!=null && i.getID()=="accessory.afei_bicycle") remove.push(i);
    foreach(i in remove) stash.remove(i);
    foreach(b in this.roster()) {
        local drop=[];
        foreach(item in b.getItems().getAllItems()) if(item!=null && item.getID()=="accessory.afei_bicycle") drop.push(item);
        foreach(item in drop) {
            if(b.getItems().getItemAtSlot(::Const.ItemSlot.Accessory)==item) b.getItems().unequip(item);
            else b.getItems().removeFromBag(item);
        }
    }
};
A.abandonBicycleForXp <- function() {
    if(this.w("bicycle_xp") || this.w("bicycle_prompt_done") || !this.hasBicycleItem()) return false;
    this.removeAllBicycles();this.sw("bicycle_xp",true);this.sw("bicycle_prompt_done",true);
    local afei=this.named("C01");if(afei!=null) this.s(afei,"bicycle_xp",true);
    return true;
};
A.keepBicycleNoXp <- function() { this.sw("bicycle_prompt_done",true); return true; };
A.tryOfferBicycleAbandonAfterBottleLeave <- function() {
    if(!this.isAfeiOrigin() || this.w("bicycle_prompt_done") || this.w("bicycle_xp")) return;
    if(!this.hasBicycleItem()) { this.sw("bicycle_prompt_done",true); return; }
    this.sw("bottle_fallback",true);
    try { ::World.Events.fire("event.afei_bottle_leave_bicycle"); } catch(error) { this.sw("bottle_fallback",false); }
};
// 剧情放手：把小酒瓶移出名册（保留招募史，名册中显示为离队纪念）
A.bottleFarewellRelease <- function() {
    local b=this.named("C04");
    if(b==null) return false;
    // A bicycle carried by the departing brother would be removed with him.
    foreach(item in b.getItems().getAllItems()) if(item!=null && item.getID()=="accessory.afei_bicycle") return false;
    local oldPlace=b.getPlaceInFormation();
    try {
        b.setPlaceInFormation(27);
        ::World.getPlayerRoster().remove(b);
    } catch(error) {
        b.setPlaceInFormation(oldPlace);
        return false;
    }
    if(this.named("C04")!=null) {b.setPlaceInFormation(oldPlace);return false;}
    if(this.w("quote","")=="C04") this.sw("quote","");
    this.sw("bottle_fallback",false);
    this.sw("bottle_was_present",false);
    return true;
};
A.noteBottlePresence <- function() {
    if(!this.isAfeiOrigin()) return;
    local present=this.named("C04")!=null;
    if(this.w("bottle_was_present") && !present) this.tryOfferBicycleAbandonAfterBottleLeave();
    this.sw("bottle_was_present",present);
};
