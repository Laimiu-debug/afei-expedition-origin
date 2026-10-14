// Instrument the installed main/DLC functions without altering their results.
// Paused AI, direct native kills on the copied campaign; originals are unsaved.
::AfeixKillProbe <- {Done=false,Active=false,Counts={},Next=0.0,Started=0.0,Sample=0,FrameAt=0.0,AwaitFrame=false};
local wrap=function(fn,name){return function(...){
    local p=::AfeixKillProbe;
    if(p.Active)p.Counts[name]<-(name in p.Counts?p.Counts[name]:0)+1;
    local args=[this];args.extend(vargv);
    return fn.bindenv(this).acall(args);
};};
// Install instrumentation after deserialization. Replacing bare-container
// methods before loading changes native registered structure identities.
::AfeixInstallKillProfile <- function(){
    local A=::AfeixExpedition;
    foreach(name in ["tryTurtleAwakening","refreshMemberAura","syncCharacterArt","hasPortraitArt","hideOriginalPortraitParts","characterId"])
        A[name]=wrap(A[name],name);
    foreach(f in ::Tactical.Entities.getAllInstances())foreach(a in f){
        local skills=a.getSkills();skills.update=wrap(skills.update,"skills_update");
    }
};
::mods_hookExactClass("states/tactical_state",function(o){
    local update=o.onUpdate;
    o.onUpdate=function(){
        local p=::AfeixKillProbe,now=this.Time.getRealTimeF();
        if(p.AwaitFrame){
            ::logInfo("AFEIX_KILL_PROBE NEXT_FRAME sample="+p.Sample+" gap_ms="+((now-p.FrameAt)*1000.0));
            p.AwaitFrame=false;
        }
        local result=update.bindenv(this)();
        if(p.Done)return result;
        try{
            if(p.Started==0.0){
                p.Started=now;p.Next=now+5.0;
                this.setPause(true);this.m.IsAIPaused=true;
                ::AfeixInstallKillProfile();
                local entities=::Tactical.Entities.get(),all=entities.getAllInstances;
                entities.getAllInstances=wrap(all,"battle_scans");
                ::logInfo("AFEIX_KILL_PROBE START version="+::AfeixExpedition.Version);
            }
            if(now<p.Next)return result;
            p.Next=now+3.0;
            local players=::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player),killer=null,victim=null,skill=null;
            foreach(a in players)if(a.isAlive()&&!a.isDying()&&a.isPlacedOnMap()&&a.isPlayerControlled()){
                if(killer==null)killer=a;
                if(::AfeixExpedition.characterId(a)==(p.Sample%2==0?"afei":"damou")){killer=a;break;}
            }
            foreach(f in ::Tactical.Entities.getAllInstances())foreach(a in f)
                if(victim==null&&a.isAlive()&&!a.isDying()&&a.isPlacedOnMap()&&!a.isAlliedWithPlayer()
                    &&(p.Sample!=1||a.getType()==::Const.EntityType.Ghost))victim=a;
            if(killer==null||victim==null)throw "missing live killer/victim";
            foreach(s in killer.getSkills().m.Skills)if(skill==null&&s.isAttack())skill=s;
            ++p.Sample;p.Counts={};p.Active=true;
            local start=::Time.getRealTimeF(),name=victim.getName();
            victim.kill(killer,skill,::Const.FatalityType.None,false);
            local elapsed=(::Time.getRealTimeF()-start)*1000.0;
            p.Active=false;
            ::logInfo("AFEIX_KILL_PROBE SAMPLE n="+p.Sample+" killer="+::AfeixExpedition.characterId(killer)+" victim="+name+" native_kill_ms="+elapsed);
            foreach(name,count in p.Counts)::logInfo("AFEIX_KILL_PROBE COUNT n="+p.Sample+" name="+name+" value="+count);
            p.FrameAt=now;p.AwaitFrame=true;
            if(p.Sample==3){p.Done=true;::logInfo("AFEIX_KILL_PROBE COMPLETE samples=3");}
        }catch(error){p.Active=false;p.Done=true;::logError("AFEIX_KILL_PROBE FAILED "+error);}
        return result;
    };
});
