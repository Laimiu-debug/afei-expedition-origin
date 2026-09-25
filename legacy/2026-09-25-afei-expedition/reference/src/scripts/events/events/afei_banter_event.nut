this.afei_banter_event <- this.inherit("scripts/events/event", {
	m = {AutoPage = ""},

	function create()
	{
		this.m.ID = "event.afei_banter";
		this.m.Title = "扎营时……";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{}",
			Image = "",
			List = [],
			Characters = [],
			Options = [{Text = "先这样。",function getResult(_event){return 0;}}],
			function start(_event) {}
		});
	}

	// 正事对话权重 14–40。闲聊更低，给路上的普通事件留位置。每段只演一次
	function onUpdateScore()
	{
		this.m.Score = 0;
		local A = ::AfeiExpedition;
		if (!A.isAfeiOrigin() || !A.safe()) return;
		this.m.AutoPage = "";
		local pool = [];
		foreach (bid, d in A.Banters)
		{
			if (A.w("banter_seen_" + bid)) continue;
			local ready = true;
			foreach (cid in d.who)
			{
				if (A.named(cid, true) == null) { ready = false; break; }
			}
			if (ready) pool.push(bid);
		}
		if (pool.len() == 0) return;
		this.m.AutoPage = "banter:" + pool[::Math.rand(0, pool.len() - 1)];
		this.m.Score = 8;
	}

	function onPrepare()
	{
		local p = split(this.m.AutoPage, ":");
		if (p.len() >= 2 && p[0] == "banter") ::AfeiExpedition.sw("banter_seen_" + p[1], true);
	}

	function onDetermineStartScreen()
	{
		return this.m.AutoPage;
	}

	function getScreen(id)
	{
		return ::AfeiExpedition.banterPage(this, id);
	}

	function onClear() {}
});
