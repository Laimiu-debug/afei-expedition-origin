// Development-only scene; no campaign load/save and never shipped in src.
::mods_registerMod("mod_afeix_overlay_playtest", 1, "AFEIX Overlay Visual Test");
::mods_queue("mod_afeix_overlay_playtest", "mod_afeix_expedition", function() {
    ::mods_hookExactClass("scenarios/tactical/scenario_combat_basics", function(o) {
        local generate=o.generate;
        o.generate=function() {
            generate.bindenv(this)();
            ::Tactical.getTileSquare(17,15).removeObject();
            local boss=::Tactical.spawnEntity("scripts/entity/tactical/enemies/afeix_douyu",17,15-17/2);
            boss.setFaction(::Const.Faction.Beasts);
            ::AfeixExpedition.memberEffect(boss,"breakthrough_exposed",null,1);
            boss.updateOverlay();
            ::AfeixExpedition.OverlayTestBoss <- boss;
            local actor=::World.getPlayerRoster().getAll()[0];
            actor.getItems().equip(::new("scripts/items/accessory/afeix_ecig_item"));
            actor.setHitpoints(actor.getHitpointsMax()-15);
            ::AfeixExpedition.OverlayTestActor <- actor;
            ::logInfo("AFEIX_OVERLAY_TEST READY boss_hp="+boss.getHitpoints()+" scale="+boss.getSprite("body").Scale);
        };
    });
    ::mods_hookExactClass("states/tactical_state", function(o) {
        local key=o.onKeyInput;
        o.onKeyInput=function(k) {
            if(k.getState()==0 && "OverlayTestBoss" in ::AfeixExpedition) {
                local boss=::AfeixExpedition.OverlayTestBoss;
                if(k.getKey()==76) {
                    boss.setHitpoints(boss.getHitpointsMax()/2);boss.updateOverlay();
                    ::logInfo("AFEIX_OVERLAY_TEST HALF_HP "+boss.getHitpoints());return true;
                }
                if(k.getKey()==77) {
                    local actor=::AfeixExpedition.OverlayTestActor;
                    local s=actor.getSkills().getSkillByID("actives.afeix_ecig_puff");
                    local result=s.use(actor.getTile());
                    ::logInfo("AFEIX_OVERLAY_TEST ECIG used="+result+" hp="+actor.getHitpoints());return true;
                }
            }
            return key.bindenv(this)(k);
        };
    });
});
