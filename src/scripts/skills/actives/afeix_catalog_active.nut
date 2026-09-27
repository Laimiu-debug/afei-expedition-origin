this.afeix_catalog_active <- this.inherit("scripts/skills/actives/afeix_member_active",{
    m={},
    function create(){this.afeix_member_active.create();},
    function configure(key){
        this.afeix_member_active.configure(key);
        local d=::AfeixExpedition.MemberSkillDefs[key];
        this.m.MinRange=d.target=="ally_self"||d.target=="self"?0:1;
        this.m.IsTargetingActor=d.target!="empty";
        this.m.IsVisibleTileNeeded=d.target!="self";
    },
    function isUsable(){return this.afeix_member_active.isUsable()&&::AfeixExpedition.catalogActiveAllowed(this);},
    function onVerifyTarget(origin,tile){return ::AfeixExpedition.catalogReadyTarget(this,origin,tile);},
    function onUse(user,tile){
        if(user!=this.getContainer().getActor()||!this.isUsable()||!this.onVerifyTarget(user.getTile(),tile))return false;
        local A=::AfeixExpedition,d=A.MemberSkillDefs[this.m.Key];
        this.m.ReadyRound=A.memberRound()+d.cd;this.m.Used=true;
        return A.catalogAction(this,user,tile);
    },
    function onAnySkillUsed(s,target,p){
        if(s==null||s!=this.m.ExecutingNative)return;
        if(this.m.Key=="snake_trial"){p.DamageRegularMult*=0.8;p.DamageArmorMult*=0.8;}
        if(this.m.Key=="gaga_charge"){p.MeleeSkill-=5;p.DamageArmorMult*=1.2;}
    }
});
