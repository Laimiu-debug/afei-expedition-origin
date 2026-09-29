local A=::AfeixExpedition;
// Each native property rebuild gets fresh budget counters. Native contributions
// never enter these counters; penalties remain independent of positive bonuses.
A.balanceHit <- function(p,field,amount) {
    if(amount<=0){p[field]+=amount;return;}
    local id="AfeixV26_"+field, used=id in p?p[id]:0, add=::Math.max(0,::Math.min(amount,10-used));
    p[id]<-used+add;p[field]+=add;
};
A.balanceDefense <- function(p,amount) {
    local used="AfeixV26_Defense" in p?p.AfeixV26_Defense:0, add=::Math.max(0,::Math.min(amount,6-used));
    p.AfeixV26_Defense<-used+add;p.MeleeDefense+=add;
};
foreach(key,patch in {
    drum={recover=6}, guard_gate={md=6}, unselectable={rd=20,anchor=true},
    prince_order={md=4,br=8,turns=1},catch_rear={rd=10},drool={ra=-8},
    pang_share={turns=1,tether=true},king_dance={init=10},budget_share={discount=6},
    foot_point={init=12},look_flag={br=8},turtle_cover={turns=1}
})foreach(field,value in patch)A.CatalogEffects[key][field]<-value;
A.CatalogEffects.yanzi_cover <- {rd=8,start=true};
// Drum may choose a nearby friendly center; all other team skills center on user.
A.MemberSkillDefs.drum.target="ally_self";
A.MemberSkillDefs.drum.mode="team";

local oldStats=A.catalogPassiveStats;
A.catalogPassiveStats=function(a,key,p) {
    // Stat-based hit bonuses use the same cap as attack-time bonuses.
    if(key=="know_rules")this.balanceHit(p,"MeleeSkill",this.catalogGet(a,"insight")*3);
    else if(key=="chaoju"){local n=this.catalogGet(a,"spotlight");this.balanceHit(p,"RangedSkill",n*3);p.Bravery+=n*3;}
    else oldStats.bindenv(this)(a,key,p);
    if(key=="companion"&&this.memberAllies(a,2).len()>0)p.Initiative+=5;
};
local oldBoost=A.catalogBoost;
A.catalogBoost=function(a,s,target) {
    local n=oldBoost.bindenv(this)(a,s,target);
    if(!this.catalogSingle(s)||target==null||s.isRanged()||a.isAlliedWith(target))return n;
    if(this.catalogHas(a,"yanzi_watch")&&!this.catalogGet(a,"turn_moved")&&this.catalogGet(a,"yanzi_watch_turn",-1)!=this.catalogGet(a,"turn_serial"))n+=5;
    foreach(key in ["yanzi_reply","xiwen_read"]){
        if(!this.catalogHas(a,key)||!this.catalogGet(a,key+"_ready"))continue;
        if(key=="xiwen_read"&&(!this.memberWeapon(a,false)||this.catalogGet(a,key+"_target")!=target.getID()))continue;
        n+=key=="yanzi_reply"?6:(this.trainingRank(a,key)>=2?10:8);
    }
    return n;
};
local oldReceived=A.catalogReceived;
A.catalogReceived=function(a,attacker,s,hit) {
    oldReceived.bindenv(this)(a,attacker,s,hit);
    if(hit||!this.memberPlayer(a)||attacker==null||attacker.isAlliedWith(a)||!this.catalogSingle(s)||s.isRanged())return;
    // Free reactions and area attacks never earn a riposte mark.
    if(this.catalogGet(attacker,"paid_attempt")!=this.catalogGet(attacker,"attempt_serial"))return;
    foreach(key in ["yanzi_reply","xiwen_read"]){
        if(!this.catalogHas(a,key)||this.catalogGet(a,key+"_ready"))continue;
        if(key=="xiwen_read"&&(!this.memberWeapon(a,false)||!attacker.isPlacedOnMap()||a.getTile().getDistanceTo(attacker.getTile())!=1))continue;
        if(!this.catalogOnce(a,key+"_gain_round"))continue;
        this.catalogSet(a,key+"_ready",1);this.catalogSet(a,key+"_target",attacker.getID());
        this.catalogSet(a,key+"_until_turn",this.catalogGet(a,"turn_serial")+1);
    }
};
local oldResult=A.catalogAttackResult;
A.catalogAttackResult=function(a,s,target,hit) {
    local eligible=this.catalogSingle(s)&&target!=null&&!a.isAlliedWith(target)&&!s.isRanged();
    oldResult.bindenv(this)(a,s,target,hit);
    if(!eligible)return;
    this.catalogSet(a,"yanzi_watch_turn",this.catalogGet(a,"turn_serial"));
    this.catalogSet(a,"yanzi_reply_ready",0);
    if(this.catalogGet(a,"xiwen_read_target")==target.getID()&&this.memberWeapon(a,false))this.catalogSet(a,"xiwen_read_ready",0);
};
local oldTurnStart=A.catalogTurnStart;
A.catalogTurnStart=function(a) {
    if(!this.isOrigin()||!::Tactical.isActive())return;
    this.catalogSet(a,"previous_walked",this.catalogGet(a,"ordinary_turn_steps"));
    this.catalogSet(a,"ordinary_turn_steps",0);
    oldTurnStart.bindenv(this)(a);
};
A.balanceAfterTurnStart <- function(a) {
    if(!this.isOrigin()||!::Tactical.isActive()||!this.memberPlayer(a))return;
    foreach(key,d in this.MemberSkillDefs)if(!d.active&&this.catalogHas(a,key)&&this.trainingRank(a,key)>=2&&key!="xiwen_read"&&key!="xiwen_travel")
        if(this.catalogOnce(a,"mastery_recovery_round"))this.catalogRecover(a,1);
    if(this.catalogHas(a,"turtle_bond")&&this.memberShield(a))foreach(b in this.memberAllies(a,3))if(this.characterId(b)=="afei"&&this.catalogOnce(a,"turtle_recovery_round"))this.catalogRecover(a,2);
    if(this.catalogHas(a,"xiwen_travel")&&this.catalogGet(a,"previous_walked")>0&&this.catalogGet(a,"turn_serial")>1){
        local weight=0;
        foreach(slot in [::Const.ItemSlot.Body,::Const.ItemSlot.Head]){local item=a.getItems().getItemAtSlot(slot);if(item!=null)weight-=item.getStaminaModifier();}
        if(weight<=15&&this.catalogOnce(a,"xiwen_travel_round"))this.catalogRecover(a,this.trainingRank(a,"xiwen_travel")>=2?3:2);
    }
    if(this.catalogHas(a,"fear_afei")&&!this.catalogGet(a,"fear_used")&&this.catalogGet(a,"turn_serial")==1&&a.getFatigue()>=4){
        local present=false;foreach(b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))if(this.characterId(b)=="afei")present=true;
        if(!present){this.catalogSet(a,"fear_used",1);this.catalogRecover(a,4);}
    }
};
local oldTurnEnd=A.catalogTurnEnd;
A.catalogTurnEnd=function(a) {
    oldTurnEnd.bindenv(this)(a);
    if(!this.isOrigin()||!::Tactical.isActive())return;
    foreach(key in ["yanzi_reply","xiwen_read"])if(this.catalogGet(a,key+"_until_turn")<=this.catalogGet(a,"turn_serial"))this.catalogSet(a,key+"_ready",0);
    this.catalogRemove(a,"short_sprint");
};
local oldWalk=A.catalogWalkStep;
A.catalogWalkStep=function(a){this.catalogSet(a,"ordinary_turn_steps",this.catalogGet(a,"ordinary_turn_steps")+1);oldWalk.bindenv(this)(a);};
local oldMoved=A.catalogMoved;
A.catalogMoved=function(a,steps=0){oldMoved.bindenv(this)(a,steps);if(this.isOrigin()&&::Tactical.isActive())this.catalogRemove(a,"unselectable");};

// Matching both temporary defense families avoids cross-family stacking.
A.balanceCoverPenalty <- function(source) {
    local penalty=0;
    foreach(a in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)){
        local e=this.catalogFindEffect(a,"xiwen_cover");
        if(e!=null&&e.m.Source==source.getID()&&e.valid())penalty=this.trainingRank(source,"xiwen_cover")>=2?2:3;
    }
    return penalty;
};
