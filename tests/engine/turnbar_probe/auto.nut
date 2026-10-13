::mods_hookExactClass("states/main_menu_state", function(o) {
    local shown=o.main_menu_screen_onScreenShown, added=o.onSiblingAdded;
    o.main_menu_screen_onScreenShown=function(){
        local r=shown.bindenv(this)();
        if (!("AfeixGhostProbeStarted" in this.m)) {
            this.m.AfeixGhostProbeStarted <- true;
            this.m.SelectedScenarioID = 0;
            ::logInfo("AFEIX_GHOST_PROBE AUTO_START standalone scenario; campaign not loaded");
            this.LoadingScreen.show();
        }
        return r;
    };
    o.onSiblingAdded=function(name){
        local r=added.bindenv(this)(name);
        if(name=="TacticalState"&&this.m.SelectedScenarioID==0)
            this.RootState.get(name).setScenario(this.new("scripts/scenarios/tactical/scenario_afeix_ghost_probe"));
        return r;
    };
});
::mods_hookExactClass("states/tactical_state", function(o) {
    local update=o.onUpdate;
    o.onUpdate=function(){
        local r=update.bindenv(this)();
        if(this.m.Scenario!=null&&"AfeixGhostProbe" in this.m.Scenario.m) this.m.Scenario.tick();
        return r;
    };
});
