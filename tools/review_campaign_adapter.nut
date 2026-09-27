// Local test/save generator, packaged separately. Never include in the production mod.
::mods_registerMod("mod_afeix_review_campaign", 1, "Afeix 34 Member Review");
::mods_queue("mod_afeix_review_campaign", "mod_afeix_expedition", function() {
    ::mods_hookExactClass("scenarios/world/afeix_expedition_scenario", function(o) {
        local spawn = o.onSpawnAssets;
        o.onSpawnAssets = function() {
            local result = spawn.bindenv(this)();
            ::AfeixExpedition.set("review_campaign_v11", true);
            return result;
        };
    });
    ::mods_hookExactClass("states/world_state", function(o) {
        local input = o.onKeyInput;
        o.onKeyInput = function(key) {
            local A = ::AfeixExpedition;
            if (key.getState() != 0 || !A.isOrigin() || !A.get("review_campaign_v11", false)
                || ::Tactical.isActive() || ::World.Events.hasActiveEvent() || this.getCombatStartTime() != 0
                || this.m.MenuStack.hasBacksteps()) return input.bindenv(this)(key);
            if (key.getKey() == 76 && !A.get("review_ready_v11", false)) { // F6: generate review save
                foreach (id in A.CharacterOrder) if (A.findCharacter(id) == null) A.makeCharacter(id);
                if (A.roster().len() != 34) throw "Review campaign requires exactly 34 members";
                local selected = [];
                foreach (id in A.CharacterOrder) {
                    local bro = A.findCharacter(id);
                    if (selected.len() < 10) selected.push(bro.getID());
                    ::logInfo("AFEIX_REVIEW_V11 member=" + id + " level=" + bro.getLevel() + " brush=" + A.characterPortraitBrush(bro));
                }
                A.applyFormation(selected);
                A.ensureStoryItems();
                ::World.Assets.m.Name = "阿飞全员审阅";
                ::World.Assets.setMoney(200000);
                ::World.Assets.m.Medicine = 300;
                ::World.Assets.m.ArmorParts = 300;
                ::World.Assets.m.Ammo = 1000;
                for (local i = 0; i < 10; i++) {
                    local food = ::new("scripts/items/supplies/ground_grains_item"); food.setAmount(50);
                    if (::World.Assets.getStash().add(food) == null) break;
                }
                A.set("review_ready_v11", true);
                this.setPause(true); A.refreshAssets();
                this.saveCampaign("afeix_all_34_v11", "阿飞全员审阅 · 34人 · 自行车与电子烟");
                ::logInfo("AFEIX_REVIEW_V11 SAVED count=" + A.roster().len() + " active=" + A.deployedIds().len()
                    + " ecig=" + (A.findKeepsake("accessory.afeix_ecig") != null) + " bicycle=" + (A.findKeepsake("misc.afeix_bicycle") != null));
                return true;
            }
            if (key.getKey() == 75 && A.get("review_ready_v11", false)) { // F5: actual campaign combat
                local p = this.getLocalCombatProperties(this.getPlayer().getPos(), true);
                p.CombatID = "afeix_review_v11";
                p.Parties = []; p.Entities = [];
                p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Line;
                p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Line;
                ::Const.World.Common.addUnitsToCombat(p.Entities, ::Const.World.Spawn.BanditRaiders, 40,
                    ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits).getID());
                this.startScriptedCombat(p, true, true, true);
                ::logInfo("AFEIX_REVIEW_V11 COMBAT_REQUESTED enemies=" + p.Entities.len());
                return true;
            }
            return input.bindenv(this)(key);
        };
    });
});
