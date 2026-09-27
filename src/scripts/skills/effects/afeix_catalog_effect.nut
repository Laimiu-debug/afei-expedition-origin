this.afeix_catalog_effect <- this.inherit("scripts/skills/skill",{
    m={CatalogEffect=true,Key="",Source=0,SourceTile=0,SourceTurn=0,SourceMove=0,Turns=1,UntilRound=0,Bonus=0,Charges=1,Started=false,Consumed=false},
    function create(){this.m.ID="effects.afeix_catalog_pending";this.m.Type=this.Const.SkillType.StatusEffect;this.m.IsActive=false;this.m.IsStacking=false;this.m.IsSerialized=true;this.m.IsRemovedAfterBattle=true;},
    function configure(key,source=null){
        local A=::AfeixExpedition,d=A.MemberSkillDefs[key],e=A.CatalogEffects[key];
        this.m.Key=key;this.m.ID="effects.afeix_catalog_"+key;this.m.Name=d.name;this.m.Description=d.text;this.m.Icon="skills/afeix_member_"+key+".png";
        this.m.Source=source==null?0:source.getID();this.m.SourceTile=source==null?0:source.getTile().ID;
        this.m.SourceTurn=source==null?0:A.catalogGet(source,"turn_serial");this.m.SourceMove=source==null?0:A.catalogGet(source,"move_serial");
        this.m.Turns="turns" in e?e.turns:1;this.m.Charges="charges" in e?e.charges:1;
        this.m.UntilRound=0;this.m.Bonus=0;this.m.Started=false;this.m.Consumed=false;
    },
    function definition(){return ::AfeixExpedition.CatalogEffects[this.m.Key];},
    function source(){return this.m.Source==0 ? null : ::Tactical.getEntityByID(this.m.Source);},
    function valid(){
        local A=::AfeixExpedition;
        if(!A.isOrigin()||!::Tactical.isActive()||this.m.Consumed||this.m.Turns<=0||this.m.Charges<=0)return false;
        if(this.m.UntilRound>0&&A.memberRound()>=this.m.UntilRound)return false;
        local d=this.definition(),s=this.source(),t=this.getContainer().getActor();
        if(("anchor" in d&&d.anchor)||("tether" in d&&d.tether)||("shield" in A.MemberSkillDefs[this.m.Key]&&A.MemberSkillDefs[this.m.Key].shield)){
            local broken=!A.memberPlayer(s)||!s.isAlliedWith(t)||!t.isPlacedOnMap();
            if(!broken&&A.MemberSkillDefs[this.m.Key].shield&&!A.memberShield(s))broken=true;
            if(!broken&&(this.m.Key=="cover_up"||("tether" in d&&d.tether)))if(s.getTile().getDistanceTo(t.getTile())>1)broken=true;
            if(!broken&&"anchor" in d&&d.anchor)if(s.getTile().ID!=this.m.SourceTile||A.catalogGet(s,"move_serial")!=this.m.SourceMove)broken=true;
            if(!broken&&this.m.Key=="cover_up"&&A.catalogGet(s,"turn_serial")!=this.m.SourceTurn)broken=true;
            if(broken){this.m.Consumed=true;return false;}
        }
        return true;
    },
    function isHidden(){return !this.valid();},
    function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];},
    function bonus(field){
        local d=this.definition(),map={MeleeDefense="md",RangedDefense="rd",Bravery="br"};
        if(!(field in map)||!(map[field] in d))return 0;
        local n=d[map[field]];
        if(this.m.Key=="pang_share"&&field=="MeleeDefense"&&::AfeixExpedition.get("growth_done_xiaopangxu",false))n=6;
        return n;
    },
    function onUpdate(p){
        if(!this.valid())return;
        local A=::AfeixExpedition,d=this.definition();
        A.catalogGuard(this,p,["Bravery"]);
        foreach(field,key in {Initiative="init",MeleeSkill="ma",RangedSkill="ra"})if(key in d)p[field]+=d[key];
        if("noWeapon" in d&&d.noWeapon)p.IsAbleToUseWeaponSkills=false;
        if("root" in d&&d.root)p.IsRooted=true;
        if("lock" in d&&d.lock)p.IsRooted=true;
        if("push" in d&&d.push)p.IsImmuneToKnockBackAndGrab=true;
    },
    function onBeingAttacked(a,s,p){if(this.valid())::AfeixExpedition.catalogGuard(this,p,["MeleeDefense","RangedDefense"]);},
    function onBeforeDamageReceived(a,s,info,p){
        if(!this.valid()||s==null||!s.m.IsWeaponSkill)return;
        local d=this.definition();if("regular" in d)p.DamageReceivedRegularMult*=d.regular;
    },
    function onMovementFinished(){
        local d=this.definition();if("anchor" in d&&d.anchor&&this.m.Source==this.getContainer().getActor().getID())this.removeSelf();
    },
    function onTurnStart(){
        local d=this.definition();
        if(!this.valid()){this.removeSelf();return;}
        if("recover" in d&&!this.m.Started)::AfeixExpedition.catalogRecover(this.getContainer().getActor(),d.recover);
        this.m.Started=true;
        if("start" in d&&d.start&&this.m.Key!="cover_up")this.removeSelf();
    },
    function onTurnEnd(){
        local d=this.definition();
        if("mark" in d)return; // Marks expire by global rounds, not the victim's turns.
        if("recover" in d){if(this.m.Started)this.removeSelf();return;}
        if(!("start" in d)&&--this.m.Turns<=0)this.removeSelf();
    },
    function onNewRound(){if(!this.valid())this.removeSelf();},
    function onSerialize(out){
        this.skill.onSerialize(out);out.writeString(this.m.Key);
        foreach(k in ["Source","SourceTile","SourceTurn","SourceMove","Turns","UntilRound","Bonus","Charges"])out.writeI32(this.m[k]);
        out.writeBool(this.m.Started);out.writeBool(this.m.Consumed);
    },
    function onDeserialize(input){
        this.skill.onDeserialize(input);this.configure(input.readString());
        foreach(k in ["Source","SourceTile","SourceTurn","SourceMove","Turns","UntilRound","Bonus","Charges"])this.m[k]=input.readI32();
        this.m.Started=input.readBool();this.m.Consumed=input.readBool();
    }
});
