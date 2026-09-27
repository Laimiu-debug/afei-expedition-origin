// Optional art-test origin. Delete this one file from a distribution that should
// provide only reusable brushes + the appearance helper.
this.afeix_art_preview_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {},

    function create()
    {
        this.m.ID = "scenario.afeix_art_preview";
        this.m.Name = "阿飞美术验收（测试）";
        this.m.Description = "[p=c][img]gfx/ui/events/event_80.png[/img][/p][p]仅供美术检查的独立起源。四名同规格队员分别展示正常、蛤蟆人、嘉豪、飞碟。飞碟在本测试中使用嘉豪主体，并非正式转职规则。[/p][p]开局不穿外层盔甲，以便检查基础衣装。仓库提供布甲、棉甲、链甲、开面盔和封闭盔，可逐件换装。战斗、受伤、倒地与保存读取沿用原版。没有转职技能、成长任务或平衡调整。[/p]";
        this.m.Difficulty = 1;
        this.m.Order = 98;
        this.m.IsFixedLook = true;
    },

    function isValid()
    {
        return "AfeiArtV1" in getroottable() && "mods_hookExactClass" in getroottable();
    },

    function onSpawnAssets()
    {
        local roster = this.World.getPlayerRoster();
        local forms = ["normal", "toad", "jiahao", "feidie"];
        local names = ["阿飞·正常", "阿飞·蛤蟆人", "阿飞·嘉豪", "阿飞·飞碟"];
        for (local i = 0; i < forms.len(); i++)
        {
            local bro = roster.create("scripts/entity/tactical/player");
            bro.setStartValuesEx(["companion_1h_background"], false);
            bro.getItems().clear();
            bro.setName(names[i]);
            bro.setTitle("");
            bro.getBackground().m.RawDescription = "此人仅是阿飞美术检查用的角色副本，用于观察分层、换装、伤势、尸体与存档恢复。";
            bro.m.HireTime = this.Time.getVirtualTimeF();
            bro.setPlaceInFormation(3 + i);
            bro.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
            bro.getItems().equip(this.new("scripts/items/shields/wooden_shield"));
            bro.getSkills().update();
            bro.setHitpoints(bro.getHitpointsMax());
            ::AfeiArtV1.setForm(bro, forms[i]);
        }

        local stash = this.World.Assets.getStash();
        stash.resize(stash.getCapacity() + 24);
        foreach (path in [
            "scripts/items/armor/linen_tunic",
            "scripts/items/armor/padded_surcoat",
            "scripts/items/armor/mail_shirt",
            "scripts/items/helmets/nasal_helmet",
            "scripts/items/helmets/full_helm"
        ])
        {
            for (local i = 0; i < 4; i++) stash.add(this.new(path));
        }
        stash.add(this.new("scripts/items/supplies/ground_grains_item"));
        stash.add(this.new("scripts/items/supplies/ground_grains_item"));
        this.World.Assets.m.Money = 2000;
        this.World.Assets.m.ArmorParts = 40;
        this.World.Assets.m.Medicine = 40;
        this.World.Assets.m.Ammo = 30;
        this.World.Assets.updateFood();
    },

    function onSpawnPlayer()
    {
        local settlements = this.World.EntityManager.getSettlements();
        if (settlements.len() == 0) throw "Afei art preview: no settlement in generated world";
        local village = settlements[0];
        foreach (town in settlements)
        {
            if (!town.isMilitary() && !town.isIsolatedFromRoads() && town.getSize() >= 2)
            {
                village = town;
                break;
            }
        }

        local villageTile = village.getTile();
        local spawnTile = null;
        local shortest = 9000;
        local nav = this.World.getNavigator().createSettings();
        nav.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
        for (local x = this.Math.max(2, villageTile.SquareCoords.X - 4); x <= this.Math.min(this.Const.World.Settings.SizeX - 2, villageTile.SquareCoords.X + 4); x++)
        {
            for (local y = this.Math.max(2, villageTile.SquareCoords.Y - 4); y <= this.Math.min(this.Const.World.Settings.SizeY - 2, villageTile.SquareCoords.Y + 4); y++)
            {
                if (!this.World.isValidTileSquare(x, y)) continue;
                local tile = this.World.getTileSquare(x, y);
                if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied || tile.getDistanceTo(villageTile) <= 1) continue;
                local path = this.World.getNavigator().findPath(tile, villageTile, nav, 0);
                if (!path.isEmpty() && path.getSize() < shortest)
                {
                    spawnTile = tile;
                    shortest = path.getSize();
                }
            }
        }
        if (spawnTile == null) throw "Afei art preview: no reachable spawn tile near starting settlement";
        this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", spawnTile.Coords.X, spawnTile.Coords.Y);
        this.World.Assets.updateLook(1);
        this.World.getCamera().setPos(this.World.State.m.Player.getPos());
    }
});
