::mods_hookExactClass("states/world_state", function(o) {
    local onKeyInput = o.onKeyInput;
    o.onKeyInput = function(key) {
        // Native key codes: Escape = 41, F8 = 78, released = 0.
        if (key.getState() == 0 && key.getKey() == 41 && ::AfeixExpedition.closeLedger(this)) return true;
        if (key.getState() == 0 && key.getKey() == 78 && ::AfeixExpedition.openLedger()) return true;
        return onKeyInput.bindenv(this)(key);
    };
    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function(input) {
        local result = onDeserialize.bindenv(this)(input);
        local A = ::AfeixExpedition;
        // Player deserialization can precede Assets restoring the saved origin.
        // The completed world load is the first reliable point for this check.
        A.PaymentContext = null;
        A.TavernTown <- 0;
        if (A.isOrigin()) {
            if ("migrateProgress" in A) A.migrateProgress();
            foreach (bro in A.roster()) A.restoreCharacterMetadata(bro);
            if ("restoreHireCandidate" in A) A.restoreHireCandidate();
            if ("ensureStoryItems" in A) A.ensureStoryItems();
            ::World.Assets.updateFormation();
        }
        return result;
    };
});

// Settlement entry happens before the native town screen gathers contract icons.
::mods_hookExactClass("entity/world/settlement", function(o) {
    local onEnter = o.onEnter;
    o.onEnter = function() {
        local result = onEnter.bindenv(this)();
        if (result) {
            local A = ::AfeixExpedition;
            // Prepare before the native crowd building hides an empty roster.
            A.ensureTownRecruit(this);
            A.ensureTownLetter(this);
            A.ensureStoryItems();
        }
        return result;
    };
    local updateRoster = o.updateRoster;
    o.updateRoster = function(force = false) {
        return ::AfeixExpedition.withProtectedCandidates(this, updateRoster, force);
    };
});

foreach (path in ["factions/settlement_faction", "factions/city_state_faction"]) {
    ::mods_hookExactClass(path, function(o) {
        local isReadyForContract = o.isReadyForContract;
        o.isReadyForContract = function() {
            return ::AfeixExpedition.withNativeContractSupply(this, isReadyForContract);
        };
    });
}

// Recruit-display mods can replace queryHireInformation on the live module.
// Prepare at the screen's entry point too, before calling whichever converter
// is installed. world_town_screen is a native bare table, so use NewObject.
::mods_hookNewObject("ui/screens/world/world_town_screen", function(o) {
    local showHireDialog = o.showHireDialog;
    o.showHireDialog = function() {
        local A = ::AfeixExpedition;
        if (A.isOrigin() && this.m.JSHandle != null && this.isVisible()) {
            local hire = this.getHireDialogModule();
            if (hire != null) A.ensureTownRecruit(::World.getEntityByID(hire.m.RosterID));
        }
        return showHireDialog.bindenv(this)();
    };
});

::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_hire_dialog_module", function(o) {
    local queryHireInformation = o.queryHireInformation;
    o.queryHireInformation = function() {
        if (::AfeixExpedition.isOrigin())
            ::AfeixExpedition.ensureTownRecruit(::World.getEntityByID(this.m.RosterID));
        return queryHireInformation.bindenv(this)();
    };
    local onHireRosterEntry = o.onHireRosterEntry;
    o.onHireRosterEntry = function(id) {
        local bro = this.findEntityWithinRoster(id);
        local result = onHireRosterEntry.bindenv(this)(id);
        // Commit our identity only after native funds/space checks and transfer succeed.
        if (result != null && result.Result == 0 && bro != null)
            ::AfeixExpedition.onNativeHired(bro);
        return result;
    };
});

// Keep native drinks and rumors. After the tavern has opened, let an eligible
// encounter interrupt it; closing the event returns to the normal tavern.
::mods_hookExactClass("entity/world/settlements/buildings/tavern_building", function(o) {
    local onClicked = o.onClicked;
    o.onClicked = function(townScreen) {
        local result = onClicked.bindenv(this)(townScreen);
        local A = ::AfeixExpedition;
        if (!A.isOrigin()) return result;
        local townID = this.getSettlement().getID();
        ::Time.scheduleEvent(::TimeUnit.Real, 350, function(tag) {
            if (!::AfeixExpedition.isOrigin() || ::World.State == null) return;
            local screen = ::World.State.m.WorldTownScreen;
            local town = ::AfeixExpedition.currentTown();
            if (town == null || town.getID() != tag || screen == null || !screen.isVisible()
                || screen.m.LastActiveModule != screen.getTavernDialogModule()) return;
            ::AfeixExpedition.openLedger("tavern", tag);
        }, townID);
        return result;
    };
});

// These managers are native tables created with new(), not inherit() classes.
::mods_hookNewObject("states/world/asset_manager", function(o) {
    local updateFormation = o.updateFormation;
    o.updateFormation = function(considerMaxBros = false) {
        if (!::AfeixExpedition.isOrigin()) return updateFormation.bindenv(this)(considerMaxBros);
        this.m.BrothersMax = ::AfeixExpedition.RosterMax;
        this.m.BrothersMaxInCombat = ::AfeixExpedition.CombatMax;
        this.m.BrothersScaleMax = ::AfeixExpedition.CombatMax;
        ::AfeixExpedition.enforceFormation();
    };
    local getFormation = o.getFormation;
    o.getFormation = function() {
        return ::AfeixExpedition.isOrigin() ? ::AfeixExpedition.formation() : getFormation.bindenv(this)();
    };
});

local contractWrappers = {};
::mods_hookBaseClass("contracts/contract", function(o) {
    // Native 1.5.2.3 invokes screen choices/start and state callbacks through
    // these methods. Legacy Hooks supplies the raw child table before inherited
    // members are flattened: resolve and replace at the original definition
    // table as required by Legacy Hooks. Track wrappers for shared prototypes.
    foreach (method in ["processInput", "setScreen", "setState", "update",
        "onActorKilled", "onActorRetreated", "onRetreatedFromCombat",
        "onCombatVictory", "onPartyDestroyed", "onLocationDestroyed"]) {
        local callback = ::mods_getMember(o, method);
        if (callback in contractWrappers) continue;
        if (method == "onCombatVictory") {
            local onCombatVictory = callback;
            callback = function(combatID) {
                local A = ::AfeixExpedition;
                local isCourier = A.isCourierContract(A.contractType(this));
                if (!isCourier && "noteCircleVictory" in A) A.noteCircleVictory(this.getID());
                return onCombatVictory.bindenv(this)(combatID);
            };
        }
        local wrapped = ::AfeixExpedition.wrapContractCallback(callback);
        contractWrappers[wrapped] <- true;
        ::mods_override(o, method, wrapped);
    }
});

local eventWrappers = {};
::mods_hookBaseClass("events/event", function(o) {
    foreach (method in ["fire", "processInput", "setScreen", "update"]) {
        local callback = ::mods_getMember(o, method);
        if (callback in eventWrappers) continue;
        local wrapped = ::AfeixExpedition.wrapNonContractCallback(callback);
        eventWrappers[wrapped] <- true;
        ::mods_override(o, method, wrapped);
    }
});

::mods_hookNewObject("states/world/asset_manager", function(o) {
    local addMoney = o.addMoney;
    o.addMoney = function(amount) {
        local A = ::AfeixExpedition;
        if (!A.isOrigin() || A.PaymentContext == null || amount <= 0) return addMoney.bindenv(this)(amount);
        local id = A.PaymentContext, before = this.getMoney();
        local result = addMoney.bindenv(this)(amount);
        local received = this.getMoney() - before;
        if (received > 0) A.noteContractIncome(id, received);
        return result;
    };
});

::mods_hookNewObject("contracts/contract_manager", function(o) {
    local finishActiveContract = o.finishActiveContract;
    o.finishActiveContract = function(cancelled = false) {
        local A = ::AfeixExpedition;
        if (!A.isOrigin() || this.m.Active == null) return finishActiveContract.bindenv(this)(cancelled);
        local id = this.m.Active.getID();
        if ("noteContractType" in A) A.noteContractType(this.m.Active);
        local result = A.withPaymentContext(id, finishActiveContract, [this, cancelled]);
        // Commit only after the native manager actually closes the contract.
        if (this.m.Active == null) A.finishContractPayment(id, cancelled);
        return result;
    };
});

::mods_hookExactClass("entity/tactical/player", function(o) {
    local onCombatStart = o.onCombatStart;
    o.onCombatStart = function() {
        if ("resetEcigRound" in ::AfeixExpedition) ::AfeixExpedition.resetEcigRound(this);
        return onCombatStart.bindenv(this)();
    };
    local onDeath = o.onDeath;
    o.onDeath = function(killer, skill, tile, fatality) {
        local A = ::AfeixExpedition, key = A.characterId(this);
        if (A.isOrigin()) A.updateRecruitEligibility();
        if (A.isOrigin() && key != "" && fatality != ::Const.FatalityType.Unconscious)
            A.set("dead_" + key, true);
        return onDeath.bindenv(this)(killer, skill, tile, fatality);
    };
});

::mods_hookNewObject("ui/screens/character/character_screen", function(o) {
    local onDismissCharacter = o.onDismissCharacter;
    o.onDismissCharacter = function(data) {
        local A = ::AfeixExpedition, key = "";
        if (A.isOrigin()) {
            A.updateRecruitEligibility();
            key = A.characterId(::Tactical.getEntityByID(data[0]));
        }
        local result = onDismissCharacter.bindenv(this)(data);
        if (key != "" && A.findCharacter(key) == null) A.set("departed_" + key, true);
        return result;
    };
});
