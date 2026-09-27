this.scenario_afeix_facing_playtest <- this.inherit("scripts/scenarios/tactical/scenario_template", {
    m = { AfeixFacingPlaytest = true },

    function generate() {
        this.createStash();
        local map = this.MapGen.get("tactical.combat_basics");
        this.Tactical.resizeScene(map.getMinX(), map.getMinY());
        map.fill({ X = 0, Y = 0, W = map.getMinX(), H = map.getMinY() }, null);
        for (local x = 10; x <= 20; x++) for (local y = 10; y <= 21; y++) {
            local tile = this.Tactical.getTileSquare(x, y);
            tile.removeObject(); tile.Level = 0;
        }
        this.Stash.clear(); this.Stash.resize(63); this.Stash.setLocked(true);

        this.addAlly("afei", "afei_normal", "01 Afei Normal - LEFT / RIGHT", 14, 14, 170);
        this.addAlly("damou", "damou", "02 Damou - heavy armor visible", 12, 12, 169);
        this.addAlly("mocha", "mocha", "03 Mocha - no helmet", 12, 14, 168);
        this.addAlly("afei", "afei_toad", "04 Afei Toad - Human", 12, 16, 167);
        this.addAlly("afei", "afei_jiahao", "05 Afei Jiahao", 12, 18, 166);
        this.addAlly("afei", "afei_jiahao", "06 Afei Feidie - Human", 14, 16, 165, true);
        this.addAlly("bottle", "bottle", "07 Bottle", 14, 12, 164);
        this.addAlly("keke", "keke", "08 Keke", 14, 18, 163);
        this.addAlly("wangdazhi", "wangdazhi", "09 Wangdazhi", 12, 20, 162);
        this.addAlly(null, null, "10 Native Reference", 14, 20, 161);

        local right = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 15, 14 - 15 / 2);
        right.setFaction(this.Const.Faction.Bandits);
        right.setName("Native Enemy RIGHT");
        right.getItems().equip(this.new("scripts/items/weapons/wooden_stick"));
        right.getItems().equip(this.new("scripts/items/armor/leather_tunic"));
        this.configureTarget(right);
        local left = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie_player", 13, 14 - 13 / 2);
        left.setFaction(this.Const.Faction.Undead);
        left.setName("Custom Enemy LEFT - mirrored Damou");
        left.getItems().equip(this.new("scripts/items/weapons/wooden_stick"));
        left.getFlags().set("afeix_character", "damou");
        left.m.afeixPlaytestBrush <- ::AfeixExpedition.Art.Prefix + "damou";
        ::AfeixExpedition.syncCharacterArt(left);
        this.configureTarget(left);
        this.m.Music = this.Const.Music.CreditsTracks;
        this.Tactical.CameraDirector.addMoveToTileEvent(0, this.Tactical.getTile(14, 16 - 14 / 2), 0, null, null, 0, 0);
        ::logInfo("AFEIX_FACING_TEST: READY; 10 allies / 2 opponents; production art hooks active");
    },

    function addAlly(key, form, name, x, y, initiative, disc = false) {
        local bro = this.Tactical.spawnEntity("scripts/entity/tactical/player", x, y - x / 2);
        this.World.getPlayerRoster().add(bro);
        bro.setFaction(this.Const.Faction.Player);
        bro.setScenarioValues(); bro.setName(name); bro.setTitle("");
        local items = bro.getItems(); items.clear();
        items.equip(this.new("scripts/items/weapons/arming_sword"));
        items.equip(this.new("scripts/items/shields/wooden_shield"));
        items.equip(this.new("scripts/items/armor/mail_shirt"));
        if (key == null || key == "damou") items.equip(this.new("scripts/items/helmets/full_helm"));
        local properties = bro.getBaseProperties();
        properties.Initiative = initiative; properties.Hitpoints = 500; properties.Bravery = 100;
        properties.Stamina = 300; properties.MeleeSkill = 85;
        bro.getSkills().update(); bro.setHitpoints(bro.getHitpointsMax());
        if (key != null) {
            bro.getFlags().set("afeix_character", key);
            bro.m.afeixPlaytestBrush <- ::AfeixExpedition.Art.Prefix + form;
            // Afei alternate copies use the production resurrected-art guard
            // solely to avoid attaching the global feidie route to every copy.
            if (key == "afei" && !disc) bro.m.afeixResurrectedPortrait <- bro.m.afeixPlaytestBrush;
            if (!::AfeixExpedition.syncCharacterArt(bro)) throw "AFEIX_FACING_TEST art missing: " + form;
            foreach (layer in ::AfeixExpedition.Art.HiddenLayers)
                if (bro.hasSprite(layer) && bro.getSprite(layer).Visible)
                    throw "AFEIX_FACING_TEST native layer visible: " + name + "/" + layer;
        }
        ::logInfo("AFEIX_FACING_TEST: actor=" + name + " brush=" + bro.getSprite("body").getBrush().Name
            + " equipment=mail_shirt/full_helm/sword/shield disc=" + disc);
        return bro;
    },

    function configureTarget(actor) {
        local properties = actor.getBaseProperties();
        properties.Initiative = 1; properties.Hitpoints = 1000; properties.MeleeSkill = 1;
        properties.MeleeDefense = 0; properties.Bravery = 100;
        actor.getSkills().update(); actor.setHitpoints(actor.getHitpointsMax());
        actor.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Roam] = 0.0;
    }
});
