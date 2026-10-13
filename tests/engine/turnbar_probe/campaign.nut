// Local diagnostic only. Load a byte-identical copy, suppress campaign writes,
// start the combat at that saved position, and end only normal player turns.
::AfeixCampaignProbe <- {NextTick=0.0,Started=0.0,Ticks=0,Done=false};
::mods_hookExactClass("states/main_menu_state", function(o) {
    local shown=o.main_menu_screen_onScreenShown;
    o.main_menu_screen_onScreenShown=function(){
        local result=shown.bindenv(this)();
        if (!("AfeixCampaignProbeStarted" in this.m)) {
            this.m.AfeixCampaignProbeStarted <- true;
            this.m.SelectedScenarioID=999;
            this.m.SelectedCampaignFileName="/*CAMPAIGN_COPY*/";
            ::logInfo("AFEIX_CAMPAIGN_PROBE LOAD_COPY saving suppressed");
            this.LoadingScreen.show();
        }
        return result;
    };
});
::mods_hookExactClass("states/world_state", function(o) {
    o.saveCampaign=function(name,label=null){::logInfo("AFEIX_CAMPAIGN_PROBE BLOCK_SAVE name="+name);};
    o.autosave=function(){};
    local load=o.loadCampaign,update=o.onUpdate;
    o.loadCampaign=function(name){
        local result=load.bindenv(this)(name);
        this.m.IsAutosaving=false;
        this.m.AfeixCampaignProbeLoadedAt <- this.Time.getRealTimeF();
        ::logInfo("AFEIX_CAMPAIGN_PROBE LOADED roster="+this.World.getPlayerRoster().getSize()+" ironman="+this.World.Assets.isIronman()+" afeix_version="+::AfeixExpedition.Version);
        return result;
    };
    o.onUpdate=function(){
        if("AfeixCampaignProbeLoadedAt" in this.m && !("AfeixCampaignProbeEngaged" in this.m)
            && this.Time.getRealTimeF()>this.m.AfeixCampaignProbeLoadedAt+3.0 && this.isVisible() && !this.isInLoadingScreen()){
            this.m.AfeixCampaignProbeEngaged <- true;
            local pos=this.m.Player.getPos(),properties=this.getLocalCombatProperties(pos);
            ::logInfo("AFEIX_CAMPAIGN_PROBE LOCAL_COMBAT entities="+properties.Entities.len()+" parties="+properties.Parties.len()+" seed="+this.m.CombatSeed);
            foreach(e in properties.Entities) ::logInfo("AFEIX_CAMPAIGN_PROBE ENEMY "+e.Script);
            if(properties.Entities.len()>0){
                this.m.EngageByPlayer=true;this.m.EngageCombatPos=pos;
                this.initLoadingScreenHandler();this.LoadingScreen.show();
            }
        }
        return update.bindenv(this)();
    };
});
::mods_hookExactClass("states/tactical_state", function(o) {
    local update=o.onUpdate;
    o.onUpdate=function(){
        local result=update.bindenv(this)(),probe=::AfeixCampaignProbe,now=this.Time.getRealTimeF();
        if(probe.Done||now<probe.NextTick)return result;
        probe.NextTick=now+0.5;++probe.Ticks;
        if(probe.Started==0.0)probe.Started=now;
        local bar=this.Tactical.TurnSequenceBar,actor=bar.getActiveEntity();
        if(probe.Ticks%4==0) ::logInfo("AFEIX_CAMPAIGN_PROBE STATE t="+(now-probe.Started)+" locked="+bar.m.IsLocked+" current="+bar.m.CurrentEntities.len()+" active="+(actor==null?0:actor.getID())+" paused="+this.m.IsGamePaused+" aiPaused="+this.m.IsAIPaused+" round="+bar.m.CurrentRound);
        if(actor!=null&&!bar.m.IsLocked&&actor.isPlayerControlled()&&!actor.isDying()&&actor.getMoraleState()!=this.Const.MoraleState.Fleeing&&!this.isInputLocked()){
            ::logInfo("AFEIX_CAMPAIGN_PROBE END_PLAYER id="+actor.getID()+" morale="+actor.getMoraleState());
            bar.onNextTurnButtonPressed();
        }
        if(now-probe.Started>240){probe.Done=true;::logInfo("AFEIX_CAMPAIGN_PROBE COMPLETE");}
        return result;
    };
});
