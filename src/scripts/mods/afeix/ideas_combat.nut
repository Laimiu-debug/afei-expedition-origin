local A=::AfeixExpedition;
A.ideaBattleTurn <- function() {
    if(!this.isOrigin()||!::Tactical.isActive())return;
    local battle=::World.Statistics.getFlags().getAsInt("LastCombatID")+1;
    if(this.get("ideas_battle")==battle)return;
    this.set("ideas_battle",battle);this.set("ideas_afei_hurt",false);
    this.set("ideas_feidie_battle",false);
    local afei=null, players=::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
    foreach(a in players)if(this.characterId(a)=="afei"&&a.isAlive()&&a.isPlacedOnMap())afei=a;
    if(afei==null)return;
    this.set("ideas_feidie_battle",this.route()=="feidie");
    local ticket=this.get("ideas_cao_serial");
    if(ticket<=0||this.get("ideas_cao_until")<=this.worldNow()||this.get("ideas_cao_used")==ticket)return;
    // First actual turn sees the complete deployed roster, including arena rules.
    this.set("ideas_cao_used",ticket);this.set("ideas_cao_until",0);
    foreach(a in players)if(a.isAlive()&&a.isPlacedOnMap()&&this.ideaFlag(a,"cao_ticket")==ticket) {
        if(!a.getSkills().hasSkill("effects.afeix_cao_courage"))a.getSkills().add(::new("scripts/skills/effects/afeix_cao_courage"));
    }
    afei.getSkills().add(::new("scripts/skills/effects/afeix_cao_bleeding"));
};
A.finishIdeasBattle <- function() {
    if(!this.isOrigin())return;
    local stats=::World.Statistics.getFlags(),id=stats.getAsInt("LastCombatID");
    if(this.get("ideas_battle")!=id||this.get("ideas_finished")==id)return;
    this.set("ideas_finished",id);
    local now=this.worldNow();
    if(stats.getAsInt("LastCombatResult")==1) {
        this.set("ideas_wins",this.get("ideas_wins")+1);
        if(this.get("ideas_dao_wait",false)) {
            this.set("ideas_dao_wait",false);this.set("ideas_dao_reply",true);this.set("ideas_dao_reply_until",now+this.daysInSeconds(3));
        }
    }
    local afei=this.findCharacter("afei");
    if(this.get("ideas_feidie_battle",false)&&this.get("ideas_afei_hurt",false)&&this.ideaAlive(afei)
        &&afei.getHitpoints()<=afei.getHitpointsMax()*0.5&&!this.get("ideas_hurt_open",false)&&now>=this.get("ideas_hurt_cd")) {
        local list=this.ideaChildren();
        if(list.len()>0) {
            this.ideaMood(list,-0.5,"飞爹负伤，儿飞派担忧");
            foreach(a in list)this.ideaMark(a,"hurt",id);
            this.set("ideas_hurt_token",id);this.set("ideas_hurt_at",now);this.set("ideas_hurt_cd",now+this.daysInSeconds(3));
            this.set("ideas_hurt_open",true);this.set("ideas_hurt_notice",true);
        }
    }
};
// Existing temporary resolve buffs keep their original contribution. The new
// event adds only the gap to +20, so it never inflates an existing stack.
A.ideaCourageContribution <- function(a) {
    local member=0,catalog=0,promotion=0;
    foreach(s in a.getSkills().m.Skills)if(!s.isGarbage()) {
        if("CatalogEffect" in s.m&&s.valid())catalog=::Math.max(catalog,s.bonus("Bravery"));
        else if("BraveryBonus" in s.m)promotion+=s.m.BraveryBonus;
        else if(["effects.afeix_member_borrow_strike","effects.afeix_member_steady_hand","effects.afeix_member_guard_nest","effects.afeix_member_pokemon"].find(s.getID())!=null&&s.valid())member=::Math.max(member,s.bonus("Bravery"));
    }
    return ::Math.max(0,20-::Math.max(member,catalog)-promotion);
};
