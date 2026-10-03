this.afeix_expedition_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {},
    function create()
    {
        this.m.ID = "scenario.afeix_expedition";
        this.m.Name = "阿飞远征团";
        this.m.Description = "[p=c][img]gfx/ui/events/afeix_douyu.png[/img][/p][p]阿飞、王大谋、午夜抹抹茶围着营火商量大陆上的路，夜里却走进同一个梦：刀一十人齐聚黑旗下，全员11级、传奇装备，雾中的斗鱼等待挑战。[/p][p][color=#bcad8c]梦醒启程：[/color]短暂的梦境之后，三人带着原来的行囊上路，在战斗与旅行中寻找伙伴；也可跳过梦境直接启程。[/p][p][color=#bcad8c]自由组队：[/color]从队伍中挑选最多十二人出战，亲自成长，再次挑战斗鱼。世界地图按 F8 打开黑旗名册。[/p]";
        this.m.Difficulty = 2;
        this.m.Order = 87;
        this.m.IsFixedLook = false;
    },
    function isValid() { return "AfeixExpedition" in getroottable(); },
    function onInit()
    {
        this.World.Assets.m.BrothersMax = ::AfeixExpedition.RosterMax;
        this.World.Assets.m.BrothersMaxInCombat = ::AfeixExpedition.CombatMax;
        // Vanilla counts the strongest brothers, including reserves. Cap that
        // pool at the same twelve seats this origin can actually deploy.
        this.World.Assets.m.BrothersScaleMax = ::AfeixExpedition.CombatMax;
    },
    function onSpawnAssets()
    {
        local A = ::AfeixExpedition;
        A.resetDreamRuntime();
        A.set("schema", A.Schema);
        // Native setCampaignSettings has already applied the chosen budget.
        // Keep our medium-budget baseline while respecting high/low resources.
        this.World.Assets.m.Money = (this.World.Assets.m.Money * 0.9).tointeger();
        this.World.Assets.m.ArmorParts = (this.World.Assets.m.ArmorParts * 1.5).tointeger();
        this.World.Assets.m.Medicine = (this.World.Assets.m.Medicine * 0.75).tointeger();
        this.World.Assets.m.Ammo = (this.World.Assets.m.Ammo * 0.625).tointeger();
        if (A.makeCharacter("afei", 3) == null || A.makeCharacter("damou", 4) == null || A.makeCharacter("mocha", 12) == null)
            throw "AfeixExpedition: failed to create the three starting captains";
        local stash = this.World.Assets.getStash();
        foreach (food in this.World.Assets.getFoodItems()) stash.remove(food);
        for (local i = 0; i < 2; i++)
        {
            local food = this.new("scripts/items/supplies/ground_grains_item");
            food.setAmount(25);
            stash.add(food);
        }
        this.World.Assets.updateFood();
        A.ensureStoryItems();
        if ("enforceFormation" in A) A.enforceFormation();
    },
    function onSpawnPlayer()
    {
        ::AfeixExpedition.resetDreamRuntime();
        local settlements = this.World.EntityManager.getSettlements();
        local candidates = [];
        foreach (town in settlements)
            if (!town.isMilitary() && !town.isIsolatedFromRoads() && town.isAlliedWithPlayer()) candidates.push(town);
        // Find a reachable free starting tile with bounded searches, even on an
        // unusual map where the first settlement has no suitable nearby road.
        local village = null;
        local spawnTile = null;
        local nav = this.World.getNavigator().createSettings();
        nav.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
        foreach (town in candidates)
        {
            local center = town.getTile();
            local tiles = [];
            for (local x = this.Math.max(2, center.SquareCoords.X - 4); x <= this.Math.min(this.Const.World.Settings.SizeX - 2, center.SquareCoords.X + 4); x++)
            {
                for (local y = this.Math.max(2, center.SquareCoords.Y - 4); y <= this.Math.min(this.Const.World.Settings.SizeY - 2, center.SquareCoords.Y + 4); y++)
                {
                    if (!this.World.isValidTileSquare(x, y)) continue;
                    local tile = this.World.getTileSquare(x, y);
                    if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied || tile.getDistanceTo(center) <= 1) continue;
                    tiles.push({ Tile = tile, Distance = tile.getDistanceTo(center) });
                }
            }
            // Try nearby tiles first, stopping at the first reachable one.
            // The old full 9x9 scan ran pathfinding even after finding a spawn.
            tiles.sort(function(a, b) { return a.Distance <=> b.Distance; });
            foreach (candidate in tiles)
            {
                local path = this.World.getNavigator().findPath(candidate.Tile, center, nav, 0);
                if (path.isEmpty()) continue;
                spawnTile = candidate.Tile;
                break;
            }
            if (spawnTile != null) { village = town; break; }
        }
        if (spawnTile == null) throw "AfeixExpedition: no reachable free starting tile near a friendly settlement";
        ::AfeixExpedition.set("home_id", village.getID());
        ::AfeixExpedition.set("home_name", village.getNameOnly());
        this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", spawnTile.Coords.X, spawnTile.Coords.Y);
        this.World.Assets.updateLook(1);
        this.World.getCamera().setPos(this.World.State.m.Player.getPos());
        ::AfeixExpedition.initializeDreamOpening();
    },
    function onCombatFinished() { return true; }
});
