// Local engine reproduction only. Never include in release packages.
::mods_registerMod("mod_afeix_net_playtest", 1, "AFEIX Net Death Engine Test");
::mods_queue("mod_afeix_net_playtest", "mod_afeix_expedition, >mod_afeix_dlc_xiwen_regen", function() {
    local A=::AfeixExpedition;
    A.isNetPlaytest <- function(){return "State" in ::Tactical&&::Tactical.State!=null&&::Tactical.State.m.Scenario!=null&&"AfeixNetTest" in ::Tactical.State.m.Scenario.m;};
    A.NetTestFlags <- {};
    local origin=A.isOrigin,get=A.get,set=A.set,idea=A.ideaBattleTurn;
    A.isOrigin=function(){return this.isNetPlaytest()||origin.bindenv(this)();};
    A.get=function(k,fallback=0){return this.isNetPlaytest()?(k in this.NetTestFlags?this.NetTestFlags[k]:fallback):get.bindenv(this)(k,fallback);};
    A.set=function(k,v){if(this.isNetPlaytest()){this.NetTestFlags[k]<-v;return v;}
return set.bindenv(this)(k,v);};
    // No campaign statistics manager in a standalone tactical scenario.
    A.ideaBattleTurn=function(){if(!this.isNetPlaytest())return idea.bindenv(this)();};
    ::mods_hookExactClass("states/main_menu_state",function(o){
        local added=o.onSiblingAdded,query=o.scenario_menu_module_onQueryData;
        o.onSiblingAdded=function(name){local r=added.bindenv(this)(name);if(name=="TacticalState"&&this.m.SelectedScenarioID==0)this.RootState.get(name).setScenario(this.new("scripts/scenarios/tactical/scenario_afeix_net_playtest"));return r;};
        o.scenario_menu_module_onQueryData=function(){local entries=query.bindenv(this)();foreach(e in entries)if(e.id==0){e.name="AFEIX NET / HEADSHOT TEST";e.description="[p]Local test: throw net, fail escape, enemy headshot kills Damou, continue turns. No campaign saves. Press F7 to run the staged reproduction.[/p]";}
return entries;};
    });
    ::mods_hookExactClass("states/tactical_state",function(o){
        local key=o.onKeyInput;
        o.onKeyInput=function(k){if(k.getState()==0&&(k.getKey()==77||k.getKey()==78)&&::AfeixExpedition.isNetPlaytest()){this.m.Scenario.runTest(k.getKey()==78);return true;}
return key.bindenv(this)(k);};
    });
    ::mods_hookExactClass("entity/tactical/player",function(o){
        local death=::mods_getMember(o,"onDeath");
        ::mods_override(o,"onDeath",function(k,s,t,f){
            if(::AfeixExpedition.isNetPlaytest())::logInfo("AFEIX_NET_TEST DEATH_BEGIN "+this.getName()+" fatality="+f);
            local r=death.bindenv(this)(k,s,t,f);
            if(::AfeixExpedition.isNetPlaytest())::logInfo("AFEIX_NET_TEST DEATH_END "+this.getName());
            return r;
        });
    });
    ::logInfo("AFEIX_NET_TEST registered; Scenarios > first entry");
});
