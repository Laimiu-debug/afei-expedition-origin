this.afeix_combat_memory <- this.inherit("scripts/skills/skill",{
    m={State=null,IncomingSkill=null},
    function create(){this.m.ID="special.afeix_combat_memory";this.m.Type=this.Const.SkillType.Special;this.m.IsHidden=true;this.m.IsSerialized=true;this.m.IsRemovedAfterBattle=true;this.m.State={};},
    function onCombatStarted(){this.m.State={};},
    function onAnySkillUsed(s,target,p){::AfeixExpedition.catalogAttackProperties(this.getContainer().getActor(),s,target,p);},
    function onTargetHit(s,target,part,hp,armor){::AfeixExpedition.catalogAttackResult(this.getContainer().getActor(),s,target,true);},
    function onTargetMissed(s,target){::AfeixExpedition.catalogAttackResult(this.getContainer().getActor(),s,target,false);},
    function onMissed(attacker,s){::AfeixExpedition.catalogReceived(this.getContainer().getActor(),attacker,s,false);},
    function onBeforeDamageReceived(attacker,s,info,p){
        this.m.IncomingSkill=s;
        local A=::AfeixExpedition,a=this.getContainer().getActor();
        if(A.isOrigin()&&::Tactical.isActive()&&attacker!=null&&A.catalogSingle(s)&&A.catalogGet(a,"cover_attacker")==attacker.getID()&&A.catalogGet(a,"cover_serial",-1)==A.catalogGet(attacker,"attempt_serial"))p.DamageReceivedTotalMult*=0.85;
    },
    function onDamageReceived(attacker,hp,armor){::AfeixExpedition.catalogReceived(this.getContainer().getActor(),attacker,this.m.IncomingSkill,true);this.m.IncomingSkill=null;},
    function onBeingAttacked(attacker,s,p){
        local A=::AfeixExpedition,a=this.getContainer().getActor();
        if(!A.isOrigin()||!::Tactical.isActive()||!A.memberPlayer(a))return;
        foreach(b in A.memberAllies(a,1))if(A.catalogHas(b,"hold_ground")&&A.memberShield(b)&&!A.catalogGet(b,"turn_moved")){p.MeleeDefense+=3;break;}
    },
    function onTurnEnd(){::AfeixExpedition.catalogTurnEnd(this.getContainer().getActor());},
    function onSerialize(out){this.skill.onSerialize(out);out.writeU16(this.m.State.len());foreach(k,v in this.m.State){out.writeString(k);out.writeI32(v);}},
    function onDeserialize(input){this.skill.onDeserialize(input);this.m.State={};local n=input.readU16();for(local i=0;i<n;++i){local k=input.readString();this.m.State[k]<-input.readI32();}}
});
