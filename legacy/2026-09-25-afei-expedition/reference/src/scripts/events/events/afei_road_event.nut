this.afei_road_event <- this.inherit("scripts/events/event", {
	m = {AutoPage = ""},

	function create()
	{
		this.m.ID = "event.afei_road";
		this.m.Title = "行路途中……";
		this.m.Cooldown = 2.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{}",
			Image = "",
			List = [],
			Characters = [],
			Options = [{Text = "先这样。", function getResult(_event) { return 0; }}],
			function start(_event) {}
		});
	}

	// 世界地图行军时弹出名场面；不在营地、不在战斗、不贴着城镇
	function onUpdateScore()
	{
		this.m.Score = 0;
		local A = ::AfeiExpedition;
		if (!A.isAfeiOrigin()) return;
		if (::Tactical.isActive() || ::World.State.getCombatStartTime() != 0) return;
		if (::World.Assets.isCamping() || A.town() != null) return;
		this.m.AutoPage = "";
		local pool = [];
		foreach (rid, d in A.RoadTales)
		{
			if (A.w("road_seen_" + rid)) continue;
			local ready = true;
			foreach (cid in d.who)
			{
				if (A.named(cid, true) == null) { ready = false; break; }
			}
			if (ready) pool.push(rid);
		}
		if (pool.len() == 0) return;
		this.m.AutoPage = "road:" + pool[::Math.rand(0, pool.len() - 1)];
		this.m.Score = 6;
	}

	function onPrepare()
	{
		local p = split(this.m.AutoPage, ":");
		if (p.len() >= 2 && p[0] == "road") ::AfeiExpedition.sw("road_seen_" + p[1], true);
	}

	function onDetermineStartScreen()
	{
		return this.m.AutoPage;
	}

	function getScreen(id)
	{
		return ::AfeiExpedition.roadPage(this, id);
	}

	function onClear() {}
});
