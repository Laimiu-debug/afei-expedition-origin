// V2 definitions are applied after the legacy modules, including optional DLC.
local A=::AfeixExpedition;
A.BalanceFields <- ["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
A.applyBalanceDefinition <- function(key) {
    if (!(key in this.Characters) || !(key in this.BalanceV26.people)) return;
    local p=this.BalanceV26.people[key], d=this.Characters[key];
    foreach(field in ["attrs","stars","wage","equipment","bag"]) d[field]=p[field];
    d.hireCost=p.suggested_price;
    if(!d.isCaptain)this.EncounterRequirements[key]<-{days=p.day,battles=p.battles,jobs=p.contracts,towns=p.towns,level=p.highest_level};
    local keys=[];
    foreach(k,s in this.BalanceV26.skills) if(s.owner==key) {
        if(!(k in this.MemberSkillDefs))this.MemberSkillDefs[k]<-{};
        foreach(field,value in s)this.MemberSkillDefs[k][field]<-value;
        if(s.active)this.MemberSkillDefs[k].once<-false;
        if(s.uses_per_battle!=null)this.MemberSkillDefs[k].limit<-s.uses_per_battle;
        keys.push(k);
    }
    // Existing ordering is stable; new skill books have an explicit display order.
    if(key=="yanzi")this.MemberSkills[key]<-["yanzi_watch","yanzi_cover","yanzi_reply"];
    if(key=="xiwen"){
        this.MemberSkills[key]<-["xiwen_read","xiwen_cover","xiwen_travel"];
        this.CatalogEffects.xiwen_cover <- {md=8,rd=5,start=true,tether=true};
    }
};
foreach(key in A.CharacterOrder)A.applyBalanceDefinition(key);
if ("recruitment" in A.BalanceV26) A.configureRecruitment(A.BalanceV26.recruitment);
A.TalentRevision=3;
A.RebalancedTalentKeys=[];
foreach(key,p in A.BalanceV26.people)A.RebalancedTalentKeys.push(key);

A.balanceTraits <- function(bro,fresh=false) {
    local key=this.characterId(bro);
    if(!(key in this.BalanceV26.people))return;
    local f=bro.getFlags();
    if(f.has("afeix_balance_v26"))return;
    local p=this.BalanceV26.people[key], skills=bro.getSkills(), added=array(8,0), prepared=[];
    // Native backgrounds also carry the Trait bit. Match only ordinary traits,
    // as the native player's random-trait selection does, and keep backgrounds.
    if(fresh) foreach(s in clone skills.m.Skills)
        if(s.getType()==::Const.SkillType.Trait && s.getID().find("trait.afeix_")!=0)skills.removeAllByID(s.getID());
    foreach(traitKey in p.fixed_traits) {
        local d=this.BalanceV26.traits[traitKey], conflict=false;
        if(skills.hasSkill(d.id))continue;
        if(!fresh)foreach(ex in d.excluded)if(skills.hasSkill("trait."+ex))conflict=true;
        if(conflict)continue;
        prepared.push({id=d.id,skill=::new(d.path)});
        foreach(i,n in d.delta)added[i]+=n;
    }
    local properties=bro.getBaseProperties();
    local previous=[],inserted=[];
    foreach(field in this.BalanceFields)previous.push(properties[field]);
    try {
        foreach(entry in prepared){inserted.push(entry.id);skills.add(entry.skill);}
        foreach(i,field in this.BalanceFields)
            properties[field] += (fresh ? 0 : p.attrs[i]-p.old_attrs[i])-added[i];
    } catch(error) {
        foreach(id in inserted)skills.removeAllByID(id);
        foreach(i,field in this.BalanceFields)properties[field]=previous[i];
        throw error;
    }
    f.set("afeix_balance_v26",true);
    if(!fresh)f.set("afeix_v26_legacy_traits",true);
};
A.syncBalance <- function(bro) {
    local key=this.characterId(bro);
    if(!(key in this.BalanceV26.people))return;
    this.balanceTraits(bro);
    if(this.BalanceV26.people[key].level_bonus_per_level[1]>0 && !bro.getSkills().hasSkill("trait.afeix_endurance"))
        bro.getSkills().add(::new("scripts/skills/traits/afeix_endurance"));
};
A.balanceJoinLevel <- function(key,freeze=false) {
    if(this.Characters[key].isCaptain)return 1;
    local saved=this.get("v26_join_level_"+key,0);
    if(saved>0)return saved;
    // The member's recruitment phase owns this cap, even when hired much later.
    local cap=this.BalanceV26.people[key].join_level;
    local level=::Math.max(1,::Math.min(cap,1+::Math.floor((this.discoveryMetrics().level-2)/2.0).tointeger()));
    if(freeze)this.set("v26_join_level_"+key,level);
    return level;
};
A.balanceCatchup <- function(bro,key) {
    local level=this.balanceJoinLevel(key,true);
    // Native pending attribute rows and perks remain unspent. No battle credit.
    bro.m.Level=level;bro.m.XP=::Const.LevelXP[level-1];bro.m.LevelUps=level-1;bro.m.PerkPoints=level-1;
};
A.recruitPrice=function(key) {
    if(!(key in this.BalanceV26.people))return this.Characters[key].hireCost;
    if(this.Characters[key].isCaptain)return 0;
    local p=this.BalanceV26.people[key], fee=::Math.max(0,p.service_fee-this.get("hire_discount_"+key,0));
    local discount=this.catalogRecruitDiscount(fee), level=this.balanceJoinLevel(key);
    return (::Math.ceil((fee-discount+0.6*p.equipment_value+120*::pow(level-1,1.5))/10)*10).tointeger();
};
local originalMetrics=A.discoveryMetrics;
A.discoveryMetrics=function(){local result=originalMetrics.bindenv(this)();result.days<-::World.getTime().Days;return result;};

// Stable recipient selection also powers the targeting tooltip.
A.balanceTargets <- function(source,center,radius,limit=3,includeSelf=true) {
    if(center==null||!center.isPlacedOnMap())return [];
    local list=this.memberAllies(center,radius);
    if(includeSelf&&this.memberPlayer(center))list.push(center);
    list.sort(function(a,b){
        if(a==b)return 0;
        if(a==source)return -1;if(b==source)return 1;
        local da=a.getTile().getDistanceTo(center.getTile()), db=b.getTile().getDistanceTo(center.getTile());
        if(da!=db)return da<db?-1:1;
        if(a.getFatigue()!=b.getFatigue())return a.getFatigue()>b.getFatigue()?-1:1;
        return a.getID()<b.getID()?-1:1;
    });
    while(list.len()>limit)list.pop();return list;
};
A.promotionTargets=function(user,radius){return this.balanceTargets(user,user,radius);};
A.balanceRouteReady <- function(actor,route,legacyUsed=false) {
    local memory=this.catalogMemory(actor), known=memory!=null&&"route_uses" in memory.m.State;
    // A mid-battle save from the previous release had one serialized use.
    if(!known&&legacyUsed){this.catalogSet(actor,"route_uses",1);this.catalogSet(actor,"route_ready",this.memberRound()+(route=="toad"?3:4));}
    return this.catalogGet(actor,"route_uses")<2&&this.catalogGet(actor,"route_ready")<=this.memberRound();
};
