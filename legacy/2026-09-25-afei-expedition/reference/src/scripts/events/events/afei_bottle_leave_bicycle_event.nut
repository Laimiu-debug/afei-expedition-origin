this.afei_bottle_leave_bicycle_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		local art = ::AfeiExpedition.eventArt("scene_farewell");
		if (art == "") art = "[img]gfx/ui/events/event_65.png[/img]{";
		this.m.ID = "event.afei_bottle_leave_bicycle";
		this.m.IsSpecial = true;
		this.m.Title = "夜里……";
		this.m.Screens.push({
			ID = "Night",
			Text = art + "夜里换过两班岗。火堆边还坐着一个人。瓶队把行李捆好了，靠在脚边。他难得没有抢先开口。%SPEECH_ON%团长。我想走一段自己的路。%SPEECH_OFF%火光把他的影子投在车辕上。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "留下。",
					function getResult(_event)
					{
						::AfeiExpedition.sw("bottle_story_done", true);
						return "Stay";
					}

				},
				{
					Text = "让他走。",
					function getResult(_event)
					{
						return "Lantern";
					}

				}
			],
			function start(_event)
			{
				local b = ::AfeiExpedition.named("C04");
				if (b != null) this.Characters.push(b.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Stay",
			Text = art + "阿飞在他旁边坐下。%SPEECH_ON%位置给你留着。%SPEECH_OFF%瓶队盯着火看了很久，把行李的绳结解开了。%SPEECH_ON%那再踢一场。%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "好。",
					function getResult(_event)
					{
						::AfeiExpedition.bumpCohesion(4);
						return 0;
					}

				}
			],
			function start(_event)
			{
				local b = ::AfeiExpedition.named("C04");
				if (b != null) this.Characters.push(b.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "瓶队留下了。磨合＋4"
				});
			}

		});
		this.m.Screens.push({
			ID = "Lantern",
			Text = art + "火堆噼啪响了一声。影子在车辕上转了一圈。\n\n酒馆空地上，阿飞把球传慢了一拍。他跑出去，又折回来接住。\n大谋顶住盾墙，他从侧面挤出去。门开了。\n第五轮。帅子数到四。他还在。\n黑旗挂上车那天，他挤到最前面，把名字签在第一个。\n\n天快亮了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "送到路口。",
					function getResult(_event)
					{
						if (!::AfeiExpedition.bottleFarewellRelease()) return "ReleaseFailed";
						::AfeiExpedition.sw("bottle_story_done", true);
						return ::AfeiExpedition.hasBicycleItem() ? "Bike" : "NoBike";
					}

				}
			],
			function start(_event)
			{
				local b = ::AfeiExpedition.named("C04");
				if (b != null) this.Characters.push(b.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "ReleaseFailed",
			Text = "名册暂时没能完成离队交接。瓶队仍在队中。若自行车在他身上，先把车放进行囊，再来送他上路。",
			Image = "",
			List = [],
			Characters = [],
			Options = [{Text = "先收拾行李，稍后再谈。", function getResult(_event) { return 0; }}],
			function start(_event) {}
		});
		this.m.Screens.push({
			ID = "NoBike",
			Text = "瓶队走了。行囊里早就没有那辆旧自行车，路口只剩风声。",
			Image = "",
			List = [],
			Characters = [],
			Options = [{Text = "继续上路。", function getResult(_event) { ::AfeiExpedition.keepBicycleNoXp(); return 0; }}],
			function start(_event) {}
		});
		this.m.Screens.push({
			ID = "Bike",
			Text = art + "路口风很大。瓶队把那辆旧自行车立在车辕边。铃铛被风吹得轻响。%SPEECH_ON%这个留给你们。%SPEECH_OFF%他拍了拍车把，回头看了一眼黑旗，挥挥手，走了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "把车推下山坡。",
					function getResult(_event)
					{
						::AfeiExpedition.abandonBicycleForXp();
						return "Abandoned";
					}

				},
				{
					Text = "把车留下。",
					function getResult(_event)
					{
						::AfeiExpedition.keepBicycleNoXp();
						return "Kept";
					}

				}
			],
			function start(_event) {}

		});
		this.m.Screens.push({
			ID = "BikeGone",
			Text = art + "行囊里那辆旧自行车还在。铃铛被风吹得轻响。车上没人再骑它了。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "把车推下山坡。",
					function getResult(_event)
					{
						::AfeiExpedition.abandonBicycleForXp();
						return "Abandoned";
					}

				},
				{
					Text = "把车留下。",
					function getResult(_event)
					{
						::AfeiExpedition.keepBicycleNoXp();
						return "Kept";
					}

				}
			],
			function start(_event) {}

		});
		this.m.Screens.push({
			ID = "Abandoned",
			Text = art + "车沿着坡道歪歪斜斜地跑。铃声先是急，后来越来越远。阿飞一直没回头。\n\n第二天，他比所有人都早一步上路。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "走吧。",
					function getResult(_event)
					{
						return 0;
					}

				}
			],
			function start(_event)
			{
				this.List.push({
					id = 11,
					icon = "ui/icons/special.png",
					text = "车铃声消失在山路尽头"
				});
			}

		});
		this.m.Screens.push({
			ID = "Kept",
			Text = art + "阿飞把车扶回车辕旁。夜里风一吹，铃铛偶尔响一声，像还有人会回来骑它。}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "走吧。",
					function getResult(_event)
					{
						return 0;
					}

				}
			],
			function start(_event)
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "旧车仍留在行囊里"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local A = ::AfeiExpedition;
		this.m.Score = 0;
		if (!A.isAfeiOrigin() || !A.safe()) return;
		if (A.w("bottle_story_done")) return;
		if (A.named("C04", true) == null) return;

		// 阿飞站稳了（完成个人成长「蛤蟆站稳」），或上路满六十日
		if (!A.w("growth_done_C01") && A.day() < 60) return;
		this.m.Score = 40;
	}

	function onDetermineStartScreen()
	{
		// 兜底路径（瓶队被提前解雇/阵亡而消失）直接进入自行车抉择
		return ::AfeiExpedition.w("bottle_fallback") ? "BikeGone" : "Night";
	}

	function onPrepare() {}

	function onPrepareVariables(_vars) {}

	function onClear()
	{
		::AfeiExpedition.sw("bottle_fallback", false);
	}
});
