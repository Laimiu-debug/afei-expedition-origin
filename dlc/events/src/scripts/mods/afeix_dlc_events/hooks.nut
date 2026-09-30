// The base tavern's delayed callback already validates the visible town/dialog.
// Wrap that entry point so a hit replaces one encounter, and a miss falls through.
// Empty content leaves the base callback completely untouched.
if (::AfeixEventsDLC.Order.len() > 0 && !("HooksInstalled" in ::AfeixEventsDLC)) {
    ::AfeixEventsDLC.HooksInstalled <- true;
    ::mods_hookExactClass("states/world_state", function(o) {
        local show = o.showEventScreen;
        o.showEventScreen = function(event, isContract = false, playSound = true) {
            local result = show.bindenv(this)(event, isContract, playSound);
            if (result && event.getID() == ::AfeixEventsDLC.EventID) ::AfeixEventsDLC.markShown(event);
            return result;
        };
    });
    local openLedger = ::AfeixExpedition.openLedger;
    ::AfeixExpedition.openLedger = function(page = "home", tavernTown = 0) {
        if (page == "tavern" && ::AfeixEventsDLC.tryTavern(tavernTown)) return true;
        return openLedger.bindenv(this)(page, tavernTown);
    };
}
