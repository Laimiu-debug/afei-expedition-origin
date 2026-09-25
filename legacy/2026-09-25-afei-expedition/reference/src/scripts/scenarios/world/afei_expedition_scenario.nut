this.afei_expedition_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
 m={},
 function create() {this.m.ID="scenario.afei_expedition";this.m.Name="大飞午远征团";this.m.Description="[p]阿飞、抹茶、王大谋从烟港上路。黑旗只记已经相识的名字；更多伙伴要沿路留下线索，再到酒馆里真正遇见。[/p][p]世界地图 F8 打开黑旗：主线、已知伙伴、营地与战前代理。每战12人；团队号令共用2次，每轮1次。阿飞身故后仍可继续残旗故事。[/p]";this.m.Difficulty=2;this.m.Order=86;this.m.IsFixedLook=true;},
 function isValid() {return true;},
 function onSpawnAssets() {
   local A=::AfeiExpedition;local afei=A.makeBrother("C01",12);A.makeBrother("C02",13);A.makeBrother("C03",3);A.sw("selected_proxy","C03");
   afei.getItems().equip(this.new("scripts/items/accessory/afei_ecig_item"));
   this.World.Assets.m.BusinessReputation=0;this.World.Assets.m.Money=1800;this.World.Assets.m.ArmorParts=30;this.World.Assets.m.Medicine=15;this.World.Assets.m.Ammo=25;
   local stash=this.World.Assets.getStash();stash.resize(stash.getCapacity()+9);
   foreach(i in this.World.Assets.getFoodItems())stash.remove(i);
   local food=this.new("scripts/items/supplies/ground_grains_item");food.setAmount(25);stash.add(food);food=this.new("scripts/items/supplies/ground_grains_item");food.setAmount(30);stash.add(food);
   stash.add(this.new("scripts/items/accessory/afei_bicycle_item"));
   this.World.Assets.updateFood();A.sw("cohesion",25);A.sw("cohesion_peak",25);A.sw("schema",A.Schema);foreach(id in ["C01","C02","C03"])A.sw("known_"+id,true);
 },
	function onSpawnPlayer()
	{
		local randomVillage;

		for (local i = 0; i != this.World.EntityManager.getSettlements().len(); i++)
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 2)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
		local closest;
		local closestDist = 9000;

		for (local x = this.Math.max(2, randomVillageTile.SquareCoords.X - 4); x <= this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4); x++)
		{
			for (local y = this.Math.max(2, randomVillageTile.SquareCoords.Y - 4); y <= this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4); y++)
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
					{
					}
					else if (tile.getDistanceTo(randomVillageTile) <= 1)
					{
					}
					else
					{
						local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

						if (!path.isEmpty() && path.getSize() < closestDist)
						{
							closestDist = path.getSize();
							closest = tile;
						}
					}
				}
			}
		}

		if (closest != null)
		{
			randomVillageTile = closest;
		}

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(1);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());

		try
		{
			this.World.Flags.set(::AfeiExpedition.Flags.SafeDeliveryHome, randomVillage.getID());
		}
		catch (error)
		{
			this.World.Flags.set(::AfeiExpedition.Flags.SafeDeliveryHome, "");
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			// 本体 1.5.2.3 的 Const.Music 没有 NewCampaignTracks（汉化环境同样缺失），直接引用会中断开场事件
			if ("NewCampaignTracks" in this.Const.Music)
			{
				this.Music.setTrackList([
					this.Const.Music.NewCampaignTracks[0]
				], this.Const.Music.CrossFadeTime);
			}

			this.World.Events.fire("event.afei_talk");
		}, null);
	}


 function onInit() {this.World.Assets.m.BrothersMax=::AfeiExpedition.w("camp_enabled")?39:20;this.World.Assets.m.BrothersMaxInCombat=12;},
 function onCombatFinished() {if(::AfeiExpedition.named("C01")==null)::AfeiExpedition.sw("captain_dead",true);return true;},
 function onUpdateHiringRoster(roster) {local town=::AfeiExpedition.town();if(town!=null)::AfeiExpedition.ensureTownCandidates(town);},
 function onHired(b) {if(::AfeiExpedition.cid(b)!="")::AfeiExpedition.finalizeNamedHire(b);},
 function onUpdateLevel(b) {::AfeiExpedition.tryAwakenAfei();}
});
