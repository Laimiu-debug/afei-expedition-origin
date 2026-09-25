this.afei_talk_event <- this.inherit("scripts/events/event", {
	m = {Notice = "", AutoPage = ""},

	function create()
	{
		this.m.ID = "event.afei_talk";
		this.m.Title = "黑旗边的事";
		this.m.Cooldown = 0.25 * this.World.getTime().SecondsPerDay;
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

	// 优先级：新的主线节点 > 伙伴的成长回访。候选伙伴只在酒馆相遇。
	function onUpdateScore()
	{
		this.m.Score = 0;
		local A = ::AfeiExpedition;
		if (!A.isAfeiOrigin() || !A.safe()) return;
		this.m.AutoPage = "";

		for (local n = 1; n <= 9; n ++)
		{
			if (A.mainAvailable(n) && !A.w("talk_noticed_m0" + n))
			{
				this.m.AutoPage = "talk:main:" + n;
				this.m.Score = 40;
				return;
			}
		}

		foreach (b in A.roster())
		{
			local cid = A.cid(b);
			if (cid != "" && !A.grown(b) && !A.g(b, "camped") && A.growthCond(cid, b) && !A.w("talk_noticed_grow_" + cid))
			{
				this.m.AutoPage = "talk:growth:" + cid;
				this.m.Score = 22;
				return;
			}
		}

	}

	function onPrepare()
	{
		local p = split(this.m.AutoPage, ":");
		if (p.len() == 3)
		{
			if (p[1] == "main") ::AfeiExpedition.sw("talk_noticed_m0" + p[2], true);
			else if (p[1] == "growth") ::AfeiExpedition.sw("talk_noticed_grow_" + p[2], true);
			else if (p[1] == "recruit") ::AfeiExpedition.sw("known_" + p[2], true);
		}
		this.m.Notice = "";
	}

	function onDetermineStartScreen()
	{
		return this.m.AutoPage != "" ? this.m.AutoPage : "talk:welcome";
	}

	function getScreen(id)
	{
		return ::AfeiExpedition.talkPage(this, id);
	}

	function buildText(text)
	{
		return text;
	}

	function onClear()
	{
		this.m.Notice = "";
	}
});
