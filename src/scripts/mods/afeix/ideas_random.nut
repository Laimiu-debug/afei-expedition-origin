// Repeatable travel scenes. Keep prerequisites and effects beside the dialogue
// so exports and tests inspect exactly what the running game selects.
local A=::AfeixExpedition;
A.RandomIdeaOrder <- ["dao_sign","bao_spares","er_blanket","cao_chorus","mocha_receipt",
    "xiaoyueya_salvage","xiaoning_map","xiaogui_board","shuaizi_rhythm","songnuanyang_notes"];
local scenes={
    dao_sign={title="此路不通，除非飞队不走",days=8,weight=6,
        random={place="road",members=[],minimum=3},
        text="岔路口多了块新牌：飞队请走此路。箭头指着一片羊圈。\n\n挂着倒飞派布条的人抱臂站在旁边：‘路线建议，免费提供。’你们换个方向，他就把牌转过来。\n\n队尾有人问他到底想让谁进羊圈。那人答得很快：‘谁急谁进。’羊叫了一声，他连忙补充：‘不包括这位。’",
        choices=["认准原来的路标，走。（全队心情 -0.25）","站住，把这块牌的道理讲清楚。（全队心情 -0.5）","买支炭笔，替羊写一句谢绝参观。（克朗 -10；全队心情 -0.1）"],
        outcomes=["你们绕过牌子，沿旧路标继续走。背后立刻传来一句‘不敢接受建议’。\n\n大家一路没接茬，只是看见下一个羊圈时，不约而同走远了些。羊也挺冤的。",
            "解释进行到第三遍，对方已经把‘路线建议’改成了‘辩论现场’。羊挤在栅栏边，倒是听得很齐。\n\n你们最终还是走了原来的路。脚下没绕远，心里堵了一大圈。",
            "附近小贩收了十克朗，把炭笔交给你。新字写得端正，羊站在后面，像是验收过了。\n\n举牌人准备再说两句，你们指指‘谢绝参观’，已经迈开了脚。大家仍有些扫兴，好歹最后一句留给了羊。"],
        effects=[{mood=[{who="all",delta=-0.25}]},{mood=[{who="all",delta=-0.5}]},{money=-10,mood=[{who="all",delta=-0.1}]}]},
    bao_spares={title="保飞后勤，这回不带锅",days=8,weight=6,
        random={place="either",members=[],minimum=3},
        text="保飞派的小车又来了。车把上挂着两只袋子，一只装零件，一只装药包，正中贴着：每队一份。\n\n来人见你们往车底看，先把双手一摊：‘锅在家。今天保的是螺丝和膝盖。’\n\n他拿起一根歪钉：‘别嫌小，上回整辆车就差这么一根。你们当时喊了八个人抬，喊得挺有气势。’",
        choices=["拿零件。八个人还有别的活。（工具 +4）","拿药包。上回抬车的膝盖还记得。（药品 +2）","这次够用，给后面的车队留着。（不领取）"],
        outcomes=["四份工具点清入库。送货人特意把钉子举到眼前：‘先量孔，再敲。别敲不进去就开动员会。’\n\n负责修车的人接过袋子，郑重保证，今天尽量不征召整个前排。",
            "药包检查妥当，进了公共储备。来人又问谁负责抬车，你们互相指了一圈。\n\n他叹口气：‘行，看来上回大家都很有担当，就是没带工具。’",
            "两只袋子重新系好，小车继续往前走。临走前，对方在名单上记了个小勾。\n\n有人问勾代表什么。他说：‘今天没把两个袋子一起拿走。值得记录。’"],
        effects=[{tools=4},{medicine=2},{}]},
    er_blanket={title="飞爹的床位，大家的脚位",days=8,weight=6,
        random={place="safe",members=["afei"],minimum=3},
        text="儿飞派来探营，把能找到的软垫全堆到了阿飞身下。团长一坐，整个人高了半截。\n\n‘这样像不像大哥？’\n\n旁边有人抱着自己的铺盖：‘像。就是大哥的左扶手原来是我的枕头。’\n\n阿飞再往下看，右边还露着一双没地方放的脚。送垫子的人挠挠头：附近行脚商倒还有铺盖，只是这回得花钱。",
        choices=["添些铺盖，大家都睡舒服点。（克朗 -30；全队心情 +0.25）","把借来的还回去，我这层草就挺好。（阿飞心情 +0.25）","各领各的，照原来的安排休息。（无数值变化）"],
        outcomes=["新铺盖分了下去，阿飞亲自试着躺平，确定没人再拿腿给团长当扶手。\n\n来探营的人想替他留一层软垫，他拍了拍旁边的空地：‘留这个。下回来了能坐着说话。’",
            "垫子一层层还回去，阿飞终于回到正常高度。他拿掌心压了压草铺，忽然笑起来。\n\n‘这就对了。明早站起来，才显得我长高。’刚才抱铺盖的人给他把歪掉的那角理平，没有拆穿。",
            "营里照原先的位置重新铺好。阿飞负责念名字，送垫子的人负责归还，忙得像在发装备。\n\n最后剩下的那只枕头，果然属于一直没能插上话的人。今晚总算每个人都找到了自己的位置。"],
        effects=[{money=-30,mood=[{who="all",delta=0.25}]},{mood=[{who=["afei"],delta=0.25}]},{}]},
    cao_chorus={title="口号喊齐，桌子撤离",days=10,weight=5,
        random={place="safe",members=["afei"],minimum=3},
        text="曹飞派这回带来了三句新口号。第一句喊阿飞，第二句喊飞队，第三句太长，喊到一半有人先换了两口气。\n\n阿飞听得起劲，手已经习惯性抬起来。旁边的人悄悄把桌子搬走，留给他一团空气。\n\n‘今天练嗓子。’领喊的人赶紧解释，‘手掌休息。要是不想练，附近的热茶摊也能坐一会儿。’",
        choices=["删掉第三句，剩下的大家一起喊。（全队心情 +0.25）","给大家买茶，吹牛也得润嗓子。（克朗 -25；全队心情 +0.5）","今晚留点安静，明天还有路。（无数值变化）"],
        outcomes=["两句口号终于喊齐了。阿飞举起手，所有人都紧张了一下；他只是打着拍子，让最后排也跟上。\n\n散场时大家心里挺热乎，桌子也完整地搬了回来。这回没有人需要领纱布。",
            "热茶沿着队伍传了一圈。阿飞把那句最长的口号念给大家听，念到第三个转折，自己也笑场了。\n\n你们给它起了新名字：曹飞派换气练习。茶钱结清时，营里的人还在拿它互相逗乐。",
            "来人把写着口号的布条卷好，声音也跟着放轻。阿飞目送他们走远，才发现自己的手还举在半空。\n\n他顺势挠了挠头，假装刚才一直是在干这件事。"],
        effects=[{mood=[{who="all",delta=0.25}]},{money=-25,mood=[{who="all",delta=0.5}]},{}]},
    mocha_receipt={title="账能平，凳子不能算两遍",days=9,weight=5,
        random={place="town",members=["mocha"],minimum=2},
        text="午夜抹抹茶把最近一张店铺收据摊在柜上，用指尖按住两行。\n\n‘这里收了凳子钱。这里，又收了坐下的钱。’\n\n掌柜说第二项是服务。抹茶看着那张一直没人扶过的凳子，拨了一下算盘：‘它自己服务自己？’\n\n掌柜终于认账，愿意退回多收的三十五克朗。抹茶没急着接，先看了看你。",
        choices=["钱拿回来，这次听算盘的。（克朗 +35）","用这笔抵给歇脚的苦工，写清是谁查的账。（抹茶心情 +0.5）","请他更正账目就好，咱们走。（放弃退款）"],
        outcomes=["三十五克朗一枚不少回到公款里。抹茶把新收据折好，连同旧的收进账本。\n\n掌柜问旧的留着干什么。他答：‘万一下次还要向凳子收呼吸钱，我好认得笔迹。’",
            "掌柜另开一张清楚的单子，写上给苦工们的歇脚茶水。抹茶把受赠人数也一一对过，才点头收起算盘。\n\n‘查账的人不用写太大。’他说完，又把那一行往亮处挪了挪。",
            "抹茶盯着掌柜把重复收费的那行划掉，确认新单子上的数总算能对上。\n\n走出店门，他回头看了一眼凳子：‘便宜你了，今天没让你出来作证。’"],
        effects=[{money=35},{mood=[{who=["mocha"],delta=0.5}]},{}]},
    xiaoyueya_salvage={title="先别扔，我超市还没关",days=9,weight=5,
        random={place="road",members=["xiaoyueya"],minimum=2},
        text="小月牙在一辆旧货车边停下来，已经把三根铁条、两只铜扣和一截说不清用处的东西排成了货架。\n\n‘看，新分店。’\n\n车主说这些零碎可以白拿，旁边另一包好零件得付二十克朗。小月牙两手一合：‘赠品和进货都有了，就差开张。’\n\n她看见你盯着那截奇怪的东西，立刻补充：‘这个先别问，问了就只能按废铁算。’",
        choices=["只拿能用的，别把货架也搬走。（工具 +3）","再买那包好零件，回营一起整理。（克朗 -20；工具 +5）","今天不停业，今天直接不营业。（无数值变化）"],
        outcomes=["可用的零碎收进工具袋。小月牙举着那截神秘东西追了两步，最终还是承认暂时不知道它该接在哪儿。\n\n车主在后面挥手：‘知道了回来告诉我！’看样子它已经神秘了很久。",
            "付清钱后，小月牙把买来的和白拿的分开点好，凑成五份工具。她还想给袋子写上分店名字，被提醒这是公用库房。\n\n她想了想，写成了：超市大客户。",
            "小月牙把零件摆回原处，最后替那三根铁条排得齐齐整整。\n\n你问这又是在干什么。她拍拍手：‘不开店也得给同行留个好印象。’车主看着自己的废料堆，第一次觉得该挂块招牌。"],
        effects=[{tools=3},{money=-20,tools=5},{}]},
    xiaoning_map={title="这张饼上，河往哪儿流",days=8,weight=5,
        random={place="road",members=["xiaoning","laocai"],minimum=2},
        text="小宁在公用地图上画了个圆，又在圆里添两笔。老蔡看了很久，问哪条是河。\n\n‘饼边上那条。’\n\n‘我们从哪儿过？’\n\n‘没咬过的地方。’\n\n老蔡把自己的木旗摆到图上：‘好。现在假定我完全没吃过这张地图。’路边恰好有个认路的车夫，二十克朗就肯替你们把这一段标清。",
        choices=["让小宁逐处讲，老蔡来补图例。（两人心情 +0.25）","请车夫核清路口，再给全队讲一遍。（克朗 -20；全队心情 +0.25）","收起新图，先沿已经确认的路走。（无数值变化）"],
        outcomes=["小宁从第一笔慢慢解释，老蔡把‘饼边’改成河，把‘焦的地方’改成树林。\n\n最后还剩一个小点。小宁看了一会儿，默默用袖口擦掉：那个真的只是口水。两个人同时松了口气。",
            "车夫先问你们饿不饿，然后才接过笔。他把能确认的路口一一标清，老蔡逐项核对，小宁负责解释自己原先画的是什么。\n\n全队围过来看完，总算不用靠想象一张饼来理解下一段路。",
            "老蔡把新图夹回本子，仍按先前确认的路安排前后队。小宁没争辩，只在页角补了一行小字：图例尚未烤熟。\n\n这回大家都看懂了。"],
        effects=[{mood=[{who=["xiaoning","laocai"],delta=0.25}]},{money=-20,mood=[{who="all",delta=0.25}]},{}]},
    xiaogui_board={title="飞爹观棋，请收回第三只手",days=9,weight=5,
        random={place="safe",members=["afei","xiaogui"],minimum=2},
        text="溺水小龟坐上木箱，在棋盘前把自己的名牌摆正。阿飞站在旁边，刚看两步，手就伸过来了。\n\n‘你这个应该——’\n\n小龟抱住棋盘：‘飞爹，你坐哪边？’\n\n阿飞说自己只负责指导。小龟指着两边的空凳：‘那得另外给你画第三边。’旁边的人已经开始替他找炭笔。",
        choices=["请阿飞把手收回去，让小龟自己下。（小龟心情 +0.5；阿飞 -0.25）","另开一盘，阿飞坐下当对手。（两人心情 +0.25）","先收棋盘，留到两人都有空再下。（无数值变化）"],
        outcomes=["小龟终于落下自己想走的那步，输赢都认。她把名牌摆得更正了些。\n\n阿飞在背后憋得转了两圈，最后只挤出一句‘我早看到了’。旁边立刻有人递来一只杯子，让他的手也有事情做。",
            "阿飞坐下以后，才发现轮到自己走时，旁边的建议格外多。小龟学着他的口气：‘你这个应该——’说到一半，自己先笑了。\n\n两个人约定谁落子谁作主，名牌一左一右摆好，这次总算只有两边。",
            "棋子各归各盒，小龟自己把名牌收起来。阿飞还想留一句最后指导，被盒盖咔哒一声截住。\n\n‘下回坐下再说。’小龟拍了拍空凳。阿飞点头，这个邀请倒听得很清楚。"],
        effects=[{mood=[{who=["xiaogui"],delta=0.5},{who=["afei"],delta=-0.25}]},{mood=[{who=["afei","xiaogui"],delta=0.25}]},{}]},
    shuaizi_rhythm={title="先别鼓掌，她还没落地",days=8,weight=5,
        random={place="safe",members=["shuaizi","xiaopangxu"],minimum=2},
        text="白小帅子敲了四声，小胖踩着拍子转身，靴底在地上划出半个利落的圈。\n\n围观的人刚想鼓掌，帅子急忙抬手：‘等一下！她落地还占一拍！’\n\n果然，最后那只脚晃了一下，稳稳站住。小胖喘匀气，认真要求再来一次。有人提议买壶热饮当休息场，至少能让围观的人先把手占住。",
        choices=["请大家喝一轮，给这段留个完整的场。（克朗 -20；全队心情 +0.5）","帮她们数拍，练到两个人都满意。（帅子、小胖心情 +0.25）","今晚先收鼓，留点精神赶路。（无数值变化）"],
        outcomes=["杯子分了一圈，喝彩的人也终于懂得等最后一拍。小胖这次站得很稳，帅子的第四声落下，掌声才一起响起来。\n\n有人举杯问能不能再来一段。两个人对视一下，先痛痛快快喝了口热的。",
            "你们把最容易抢的那一拍拆开数。帅子敲一下，小胖踩一下，再把整段接回来。\n\n结束时没有很大的动静，两个人却同时点了头。收鼓的人说，这一遍比刚才那轮掌声管用。",
            "鼓皮盖好，鞋底的泥也拍干净。小胖临走又比了一下那个转身，帅子没出声，只用四根手指替她数完。\n\n最后一只脚落稳，她们才各自去收行李。"],
        effects=[{money=-20,mood=[{who="all",delta=0.5}]},{mood=[{who=["shuaizi","xiaopangxu"],delta=0.25}]},{}]},
    songnuanyang_notes={title="英雄事迹，先核对一下",days=10,weight=5,
        random={place="safe",members=["afei","songnuanyang"],minimum=3},
        text="宋暖阳把新写的旅途小记念给阿飞听。前两句是天气，第三句写团长搬箱子时被自己的披风绊了一下。\n\n阿飞清清嗓子：‘这段有没有更适合传出去的版本？’\n\n宋暖阳把笔停在纸边：‘后面还有你爬起来继续搬。要一起删吗？’\n\n阿飞没立刻回答。营火边的人已经坐近了，显然对两个版本都很感兴趣。",
        choices=["都念出来。人没摔散，箱子也搬到了。（全队心情 +0.25）","先请阿飞把后半段讲完，你再记。（两人心情 +0.5）","留作私下的小记，今晚先收起来。（无数值变化）"],
        outcomes=["笑声在绊倒那句起来，到重新搬箱子时慢慢轻了。有人补充，自己当时也扶着另一头，手还被压红了一块。\n\n宋暖阳把漏掉的名字添上。阿飞看着一页挤挤挨挨的人名，觉得这篇比只写团长更像你们这支队伍。",
            "阿飞从那声‘哇’讲起，讲到谁先扶箱子，又是谁替他把披风拎起来。他本想把自己说得从容一点，说到一半却自己笑了。\n\n宋暖阳没催，等他讲完才落笔。阿飞凑过去看：‘那个笑，也记上。’",
            "宋暖阳合起本子，没有替故事再换一个更响亮的结尾。阿飞往旁边坐了一点，让出能烤到火的位置。\n\n过了一会儿，他还是轻声问：‘我继续搬那句，写得怎么样？’"],
        effects=[{mood=[{who="all",delta=0.25}]},{mood=[{who=["afei","songnuanyang"],delta=0.5}]},{}]}
};
foreach(key in A.RandomIdeaOrder)A.IdeaScenes[key] <- scenes[key];

A.randomIdeaActorsPresent <- function(key) {
    local d=this.IdeaScenes[key].random,count=0;
    foreach(a in this.roster())if(this.ideaAlive(a))++count;
    if(count<d.minimum)return false;
    foreach(member in d.members)if(!this.ideaAlive(this.findCharacter(member)))return false;
    return true;
};
A.randomIdeaEligible <- function(key) {
    if(!this.randomIdeaActorsPresent(key))return false;
    local place=this.IdeaScenes[key].random.place,safe=this.canManage();
    if(place=="town")return safe&&this.currentTown()!=null;
    if(place=="safe")return safe;
    local road=!safe&&this.isWorldPartyMoving();
    return place=="road"?road:(safe||road);
};
A.resolveRandomIdea <- function(key,choice) {
    // Event presentation pauses camping/movement; only live actors and resources
    // are rechecked here. The common resolver owns token and cooldown commits.
    if(!this.randomIdeaActorsPresent(key))return this.result(false,"这段相遇的当事人已不在队中，或同行人数不足。");
    local d=this.IdeaScenes[key],effect=d.effects[choice],assets=::World.Assets;
    local changes=[],specs={money={field="Money",add="addMoney",set="setMoney",label="克朗"},
        tools={field="ArmorParts",add="addArmorParts",set="setArmorParts",label="工具"},
        medicine={field="Medicine",add="addMedicine",set="setMedicine",label="药品"}};
    // Validate every leg first and preserve fractional supplies. Apply money last
    // so a clamped supply grant cannot charge the player for an incomplete deal.
    foreach(kind in ["tools","medicine","money"])if(kind in effect) {
        local s=specs[kind],old=assets.m[s.field],value=old+effect[kind];
        if(value<0)return this.result(false,s.label+"不足；可以改选不花费物资的选项。");
        if(kind!="money") {
            local cap=::Const.Difficulty.MaxResources[assets.m.EconomicDifficulty][s.field]+assets.m[s.field+"MaxAdditional"];
            if(value>cap)return this.result(false,s.label+"储备装不下整份；本次未领取、未扣款，可以改选或稍后再遇。");
        }
        changes.push({spec=s,old=old,delta=effect[kind]});
    }
    local applied=[];
    try {
        foreach(c in changes) {
            applied.push(c);
            assets[c.spec.add](c.delta);
            if(assets.m[c.spec.field]!=c.old+c.delta)throw "Incomplete random event exchange";
        }
    } catch(error) {
        foreach(c in applied)assets[c.spec.set](c.old);
        return this.result(false,"物资未能完整登记，本次交换已撤回，可以改选其他选项。");
    }
    if("mood" in effect)foreach(m in effect.mood) {
        local list=[];
        if(typeof m.who=="string")list=this.roster();
        else foreach(member in m.who)list.push(this.findCharacter(member));
        this.ideaMood(list,m.delta,d.title);
    }
    return this.result(true,d.outcomes[choice]);
};
