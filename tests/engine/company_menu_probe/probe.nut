// Local engine diagnostic: load only a copied campaign, never write campaigns.
::AfeixCompanyProbe <- {
    Stage=0, Next=0.0, Started=0.0, Done=false, Checks=0,
    function check(ok,label){if(!ok)throw label;++this.Checks;::logInfo("AFEIX_COMPANY_PROBE PASS "+label);},
    function key(code){return {getKey=function(){return code;},getState=function(){return 0;}};},
    function screen(state){
        local e=::World.Events.m.ActiveEvent;
        this.check(e!=null&&e.getID()=="event.afeix_ledger","native ledger active");
        this.check(state.m.EventScreen.isVisible()&&!state.m.EventScreen.isAnimating(),"native event UI ready");
        local s=e.m.ActiveScreen;
        this.check(s.Options.len()<=6,"six-button native limit ID="+s.ID);
        foreach(i,o in s.Options)::logInfo("AFEIX_COMPANY_PROBE OPTION "+s.ID+" "+i+" "+o.Text);
        return s;
    },
    function press(state,label){
        local s=this.screen(state),index=null;
        foreach(i,o in s.Options)if(o.Text==label)index=i;
        this.check(index!=null,"button available "+label);
        state.m.EventScreen.onButtonPressed(index);
    },
    function tick(state){
        if(this.Done)return;
        local now=::Time.getRealTimeF();
        if(now<this.Next)return;
        this.Next=now+2.0;
        if(this.Started==0.0)this.Started=now;
        if(now-this.Started>65)throw "menu probe timeout";
        ::logInfo("AFEIX_COMPANY_PROBE STEP "+this.Stage);
        local town=state.m.WorldTownScreen;
        if(this.Stage==0){
            if(!state.isVisible()||state.isInLoadingScreen())return;
            local chosen=null;
            foreach(t in ::World.EntityManager.getSettlements())if(t.isAlive()&&t.isAlliedWithPlayer()&&t.hasBuilding("building.tavern")){
                if(chosen==null)chosen=t;
                if(t.getName()=="Dunkeltal"){chosen=t;break;}
            }
            this.check(chosen!=null,"friendly town exists");
            this.check(state.enterLocation(chosen),"native enterLocation "+chosen.getName());
        }else if(this.Stage==1){
            if(!town.isVisible()||town.isAnimating())return;
            town.getTown().getBuilding("building.tavern").onClicked(town);
        }else if(this.Stage==2){
            if(town.isAnimating()||town.getTavernDialogModule().isAnimating())return;
            ::logInfo("AFEIX_COMPANY_PROBE CONTEXT origin="+::AfeixExpedition.isOrigin()+" visible="+town.isVisible()+" module="+(town.m.LastActiveModule==town.getTavernDialogModule())+" tactical="+::Tactical.isActive()+" tacticalState="+("State" in ::Tactical&&::Tactical.State!=null)+" combat="+state.getCombatStartTime()+" loading="+::LoadingScreen.isVisible()+" loadingAnimation="+::LoadingScreen.isAnimating());
            if(::World.Events.m.ActiveEvent!=null){
                ::logInfo("AFEIX_COMPANY_PROBE EVENT visible="+state.m.EventScreen.isVisible()+" animating="+state.m.EventScreen.isAnimating()+" connected="+(state.m.EventScreen.m.JSHandle!=null)+" ID="+::World.Events.m.ActiveEvent.m.ActiveScreen.ID);
                this.check(::World.Events.m.ActiveEvent.getID()=="event.afeix_ledger","automatic tavern ledger");
                // Dismiss the automatic story through its native event input;
                // F8 and Escape are exercised after this initial interruption.
                state.m.EventScreen.onButtonPressed(-1);
                return;
            }
            if(town.m.LastActiveModule!=town.getTavernDialogModule()){
                town.showTavernDialog();
                return;
            }
            this.check(::AfeixExpedition.isAtTavern(),"actual tavern context");
            this.check(state.onKeyInput(this.key(78)),"F8 handled in tavern");
        }else if(this.Stage==3){
            local s=this.screen(state);
            if(s.ID!="home"){
                this.check(s.Options.top().Text.find("返回")!=null||s.Options.top().Text.find("合上")!=null,"story navigation footer");
                state.m.EventScreen.onButtonPressed(s.Options.len()-1);
                return;
            }
            this.press(state,"战团事务");
        }else if(this.Stage==4){
            local s=this.screen(state);
            this.check(s.ID=="company"&&s.Options.len()==6,"company first page displayed");
            this.press(state,"下一页");
        }else if(this.Stage==5){
            this.check(this.screen(state).ID=="company:4","company second page displayed");
            this.press(state,"阿飞外观");
        }else if(this.Stage==6){
            this.check(this.screen(state).ID==::AfeixSkinsDLC.Page+":0","installed wardrobe page displayed");
            this.press(state,"返回战团事务");
        }else if(this.Stage==7){
            this.check(this.screen(state).ID=="company","wardrobe return displayed");
            this.press(state,"下一页");
        }else if(this.Stage==8){
            this.press(state,"回到第一页");
        }else if(this.Stage==9){
            this.check(this.screen(state).ID=="company:0","first-page return displayed");
            this.press(state,"返回名册");
        }else if(this.Stage==10){
            this.check(this.screen(state).ID=="home","home return displayed");
            state.onKeyInput(this.key(41));
        }else if(this.Stage==11){
            this.check(::World.Events.m.ActiveEvent==null&&!state.m.EventScreen.isVisible(),"native ledger closed");
            this.check(town.isVisible()&&::AfeixExpedition.isAtTavern(),"tavern restored");
            this.check(state.onKeyInput(this.key(78)),"F8 reopened after Escape");
        }else if(this.Stage==12){
            this.screen(state);
            state.onKeyInput(this.key(41));
        }else if(this.Stage==13){
            this.check(::World.Events.m.ActiveEvent==null&&!state.m.EventScreen.isVisible(),"second close completed");
            this.Done=true;
            ::logInfo("AFEIX_COMPANY_PROBE COMPLETE checks="+this.Checks+" version="+::AfeixExpedition.Version);
            return;
        }
        ++this.Stage;
    }
};
::mods_hookExactClass("states/main_menu_state",function(o){
    local shown=o.main_menu_screen_onScreenShown;
    o.main_menu_screen_onScreenShown=function(){
        local result=shown.bindenv(this)();
        if(!("AfeixCompanyProbeStarted" in this.m)){
            this.m.AfeixCompanyProbeStarted<-true;
            this.m.SelectedScenarioID=999;
            this.m.SelectedCampaignFileName="/*CAMPAIGN_COPY*/";
            ::logInfo("AFEIX_COMPANY_PROBE LOAD_COPY saving suppressed");
            this.LoadingScreen.show();
        }
        return result;
    };
});
::mods_hookExactClass("states/world_state",function(o){
    o.saveCampaign=function(name,label=null){::logInfo("AFEIX_COMPANY_PROBE BLOCK_SAVE "+name);};
    o.autosave=function(){};
    local load=o.loadCampaign,update=o.onUpdate;
    o.loadCampaign=function(name){
        local result=load.bindenv(this)(name);
        this.m.IsAutosaving=false;
        this.m.AfeixCompanyProbeLoadedAt<-this.Time.getRealTimeF();
        ::logInfo("AFEIX_COMPANY_PROBE LOADED version="+::AfeixExpedition.Version);
        return result;
    };
    o.onUpdate=function(){
        if(!::AfeixCompanyProbe.Done&&"AfeixCompanyProbeLoadedAt" in this.m&&this.Time.getRealTimeF()>this.m.AfeixCompanyProbeLoadedAt+3.0){
            try{::AfeixCompanyProbe.tick(this);}catch(error){
                ::AfeixCompanyProbe.Done=true;
                ::logError("AFEIX_COMPANY_PROBE FAILED "+error);
            }
        }
        return update.bindenv(this)();
    };
});
