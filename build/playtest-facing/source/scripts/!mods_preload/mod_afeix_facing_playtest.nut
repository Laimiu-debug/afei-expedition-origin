// Development-only adapter. Not included in the production gameplay ZIP.
::mods_registerMod("mod_afeix_facing_playtest", 1, "AFEIX Facing Art Playtest (DEV ONLY)");
::mods_queue("mod_afeix_facing_playtest", "mod_afeix_expedition", function() {
    local A = ::AfeixExpedition;
    A.isFacingPlaytest <- function() {
        return "Tactical" in getroottable() && "State" in ::Tactical && ::Tactical.State != null
            && ::Tactical.State.m.Scenario != null
            && "AfeixFacingPlaytest" in ::Tactical.State.m.Scenario.m;
    };
    // Only the dev actors bypass the campaign-origin/route lookup. Rendering,
    // equipment hiding, native turning, injury and death use production code.
    local characterPortraitBrush = A.characterPortraitBrush;
    A.characterPortraitBrush = function(bro) {
        if (this.isFacingPlaytest() && bro != null && "afeixPlaytestBrush" in bro.m)
            return bro.m.afeixPlaytestBrush;
        return characterPortraitBrush.bindenv(this)(bro);
    };
    local route = A.route;
    A.route = function() { return this.isFacingPlaytest() ? "feidie" : route.bindenv(this)(); };

    ::mods_hookExactClass("states/main_menu_state", function(o) {
        local onSiblingAdded = o.onSiblingAdded;
        o.onSiblingAdded = function(stateName) {
            local result = onSiblingAdded.bindenv(this)(stateName);
            if (stateName == "TacticalState" && this.m.SelectedScenarioID == 0) {
                local state = this.RootState.get(stateName);
                state.setScenario(this.new("scripts/scenarios/tactical/scenario_afeix_facing_playtest"));
            }
            return result;
        };
        local query = o.scenario_menu_module_onQueryData;
        o.scenario_menu_module_onQueryData = function() {
            local entries = query.bindenv(this)();
            foreach (entry in entries) if (entry.id == 0) {
                entry.name = "AFEIX Facing Art Test";
                entry.description = "[p=c]DEV ONLY - 10 allies, 2 opponents. Three captains, human Afei routes, native equipment, women and native comparison. No campaign or saves. Select the normal Afei between two enemies to test left/right attacks.[/p]";
            }
            return entries;
        };
    });
    ::logInfo("AFEIX_FACING_TEST: development scenario registered; Scenarios -> first entry");
});
