// Temporary local review adapter. Never ship this file in the production mod.
::mods_registerMod("mod_afeix_discovery_review", 1, "Afeix Local Review Adapter");
::mods_queue("mod_afeix_discovery_review", "mod_afeix_expedition", function() {
    ::mods_hookExactClass("scenarios/world/afeix_expedition_scenario", function(o) {
        local onSpawnAssets = o.onSpawnAssets;
        o.onSpawnAssets = function() {
            local result = onSpawnAssets.bindenv(this)();
            ::AfeixExpedition.set("review_session_20260927", true);
            return result;
        };
    });
    ::mods_hookExactClass("states/world_state", function(o) {
        local onKeyInput = o.onKeyInput;
        o.onKeyInput = function(key) {
            local A = ::AfeixExpedition;
            if (key.getState() != 0 || !A.isOrigin() || !A.get("review_session_20260927", false)
                || ::Tactical.isActive() || ::World.Events.hasActiveEvent() || this.getCombatStartTime() != 0)
                return onKeyInput.bindenv(this)(key);
            if (key.getKey() == 77) {
                // One reproducible first-job checkpoint, no other conditions skipped.
                A.set("paid_contracts", 1);
                ::logInfo("AFEIX_DISCOVERY_REVIEW: first job checkpoint; only normal eligibility will be evaluated");
                return true;
            }
            if (key.getKey() == 76 && !this.m.MenuStack.hasBacksteps() && !A.get("review_save_created", false)) {
                foreach (id in A.CharacterOrder) if (A.findCharacter(id) == null) A.makeCharacter(id);
                if (A.roster().len() != 34) throw "Review roster must contain exactly 34 members";
                local selected = [];
                foreach (id in A.CharacterOrder) {
                    local bro = A.findCharacter(id);
                    if (selected.len() < 10) selected.push(bro.getID());
                    ::logInfo("AFEIX_DISCOVERY_REVIEW: member=" + id + " brush=" + A.characterPortraitBrush(bro));
                }
                A.applyFormation(selected);
                ::World.Assets.m.Name = "阿飞全员审阅";
                ::World.Assets.setMoney(200000);
                A.set("review_save_created", true);
                this.setPause(true);
                this.saveCampaign("afeix_all_members_20260927_v09", "阿飞全员审阅 · 34人 · v0.9");
                A.refreshAssets();
                ::logInfo("AFEIX_DISCOVERY_REVIEW: SAVED 34 members, 10 active, production origin, native save format");
                return true;
            }
            return onKeyInput.bindenv(this)(key);
        };
    });
});
