local A = ::AfeixExpedition;
A.IdeaScenes <- {
    dao = { title="战报没看，结论已有", days=7, weight=10,
        text="路边支着一张桌子，牌上写着‘倒飞点评，分文不取’。\n\n你们还没走近，主讲的人已经拍下结论：‘飞队的问题，我昨晚就说了！’一个队员问他看过战报没有，对方把桌上空白的纸一翻：‘看了还怎么客观？’\n\n队里有人已经开始撸袖子。旁边负责收拾行李的赶紧提醒：‘别争，他连咱们还嘴的标题都写好了。’你探头一看：黑旗急了。",
        choices=["走，他连咱们明天输什么都编好了。（全队心情 -0.5）","给我腾个位置，今天把这账辩明白。（全队心情 -0.75）"],
        outcomes=["你们没停，对方立刻宣布这是无言以对。一个队员回头瞪他，他又宣布这是恼羞成怒。\n\n车轮转过路口，队伍里终于有人闷闷地说：‘他那张嘴，比咱们出战人数还满。’没人笑得出来，但至少已经听不见了。", "你们从阵线讲到补给，从补给讲到最后一击。对方听得很认真，每隔一会儿就在纸上添一个‘急’字。\n\n等队伍重新上路，大家才发现整场辩论唯一学会新东西的是桌下那条狗：有人提高嗓门，它就跟着叫。"] },
    bao = { title="保飞可以，保锅不行", days=6, weight=12,
        text="一辆小推车挡在路边，上面摆着面包和药包，旁边还立着一口黑锅。旗子很醒目：保飞后勤。\n\n送货的人抢先解释：‘吃的送飞队，药也送飞队。锅不送。’\n\n有人问为什么，他拍了拍锅沿：‘上回有人说全怪装备不好，差点把我这口煮汤的也算进去。’说完又把面包往你们这边推了推：‘拿着吧。嘴硬归嘴硬，别饿着打。’",
        choices=["面包药品收下，锅你自己看牢。（食物 25、药品 4；全队心情 +0.25）","这回够吃，先送给前面缺粮的人。（不领取）"],
        outcomes=["后勤把补给一项项收好。送货人盯着那口锅，直到最后一双手从车边离开，才松了口气。\n\n有人咬了一口面包，说今天的装备确实不错。送货人立刻把锅往身后挪了半步。", "对方看了看你们的行囊，点点头，把药包重新压稳。\n\n临走时他还不忘叮嘱：‘要是路上碰见倒飞派，锅是我的，别替我送人。’你们答应得很快，这回连锅的责任也分清了。"] },
    er = { title="飞爹，请先张嘴", days=6, weight=12,
        text="‘飞爹！’\n\n阿飞循声回头，挺胸，收腹，把刚到嘴边的一口气重新酝酿成威严：‘都来了？今天我给你们讲——’\n\n一篮口粮已经送到他面前。来人又把药包往旁边一放：‘讲可以，先吃。上回您空着肚子吼半天，我们一直分不清哪声是军令，哪声是胃。’\n\n阿飞看了一圈，发现大家对分辨军令这件事，意见出奇地一致。",
        choices=["先给大家分。我这叫开饭前训话。（食物 25、药品 3；儿飞派心情 +0.25）","今天真够了，别把自己也喂穷了。（不领取）"],
        outcomes=["阿飞本想亲自主持分粮，刚喊完‘按顺序’，自己手里先被塞了一份。\n\n‘飞爹，您排第一个。’\n\n他低头吃了两口，才想起来该说谢谢。那几个等着听的人笑得比刚才还开心，连‘不许学我说话’也照单全收了。", "来人还想再塞，阿飞把篮子轻轻推回去：‘你们先把自己那顿吃好，我这里不是收贡品的。’\n\n对方终于把篮子提稳，却仍不肯服输：‘行，那下回您少吼两声，算替我们省饭。’阿飞张了张嘴，决定这句先不接。"] },
    cao = { title="掌声很响，手也很响", days=10, weight=8,
        text="曹飞派把营里的气氛炒得滚烫。\n\n‘阿飞往前一站，对面先少三分胆！’\n\n阿飞站起来。\n\n‘阿飞往桌上一拍，铁甲也得开条缝！’\n\n阿飞一掌拍下去。桌子没开缝，手先开了。前排看得热血上涌，后排已经在擦兵器，只有抹茶盯着桌上的血：‘先说好，气氛可以免费，纱布得入账。’\n\n接受后保留 24 小时。阿飞下一次实际出战时，事件当时在册且同场者决心 +20，持续两个自身回合；阿飞同时获得两次基础 5 点流血。待命者不受益，资格随该战消耗。",
        choices=["这点血算彩头，下一仗我先上！（全队鼓舞；阿飞流血）","都别鼓掌了，谁来给我缠两圈？（药品 -2；阿飞心情 +0.25）","气势留心里，手先拿布捂着。（不获得状态）"],
        outcomes=["阿飞把伤手藏到披风后，换另一只手指向营外。所有人都下意识握紧了兵器。\n\n抹茶把账本合上：‘好，记住现在这个劲。到时候你们负责勇，阿飞负责别往新绷带上签名。’\n\n热血保留 24 小时；须阿飞亲自出战，鼓舞和流血才在那场战斗启用。", "绷带绕了两圈，阿飞就开始指挥：‘别绑得像我输了。’\n\n抹茶在结头上打了个挺精神的结：‘放心，账上写的是获胜准备费。’\n\n阿飞满意地把手举起来，下一轮掌声刚起，他立刻把手收回了桌底。", "你们给伤口压上干净布，顺便把那几个准备再喊一轮的人劝离了桌边。\n\n阿飞仍想补一句狠话，抹茶已经把桌子转了个方向：‘下次拍这边，没毛刺。’\n\n众人散去，今晚最完整地保留下来的，是那张桌子。"] },
    hurt = { title="飞碟返厂，嘴还没坏", days=0, weight=100,
        text="阿飞刚坐下，就把披风往伤口上又拉了一截：‘小问题，飞碟落地蹭了点漆。’\n\n药箱被推到他面前。儿飞派几个人谁也没接话，视线齐齐落在那块已经洇红的布上。\n\n阿飞停了一下，小声补充：‘……可能不止底漆。’\n\n有人终于把水递过来，动作很轻，语气一点也不轻：‘飞爹，嘴我们都检查过了，没坏。现在能不能让我们看看别的地方？’\n\n本次战后在册儿飞派已因担忧心情 -0.5；阅读不会再次扣除。",
        choices=["行，今天听你们的。披风帮我拿着。","先帮我挡一下，包扎时叫出声怪没面子。"],
        outcomes=["阿飞松开披风，终于没再说‘我自己来’。旁边的人接过去，抖了抖上面的土，叠好放在干燥的地方。\n\n药碰到伤口时，他还是吸了一大口气。递水的人没笑，只把杯子又向前送了一点。", "临时屏风支起来以后，里面立刻传出一声压得不太成功的惨叫。\n\n外头有人故意把水盆碰得叮当响，另一个人很配合：‘什么动静？没听见。’\n\n阿飞缓过那口气，隔着布帘小声说了句谢谢。这次没有人学他。"] },
    recover = { title="好消息，扩音器修好了", days=0, weight=100,
        text="营地刚亮，熟悉的声音就从车边传来：‘绳子谁系的？这么慢，太阳都要下山了！’\n\n有人抬头看了看刚升起的太阳，又看了看已经能叉腰挑毛病的阿飞，忍不住笑起来。\n\n‘修好了。’\n\n‘哪儿？’\n\n‘最费人耳朵的那一块。’\n\n阿飞听见了，张嘴准备训两句，却发现那几张前几天一直绷着的脸，总算松了下来。",
        choices=["都听清了吧？飞爹今天正常营业。（原担忧者心情 +0.25）","先吃饭，今天不拿嗓门催你们。（原担忧者心情 +0.25）"],
        outcomes=["阿飞宣布完，顺手提起一件行李，没再急着把整辆车都包到自己身上。\n\n旁边的人替他托住另一头：‘正常营业可以，别刚开门就把招牌砸了。’\n\n这回他笑着骂了一句，众人也终于放心地笑出了声。", "大家先是一愣，接着有人赶紧把碗端来，生怕团长反悔。\n\n阿飞吃了两口，还是没忍住：‘那个绳结——’\n\n对面立刻替他把碗添满。阿飞看着满满一碗饭，忽然觉得，今天少说两句也不亏。"] },
    reply = { title="今日点评：不方便点评", days=0, weight=30,
        text="路边还是那张桌子，还是那块‘分文不取’的牌子。这次胜战的消息比你们先到，主讲的人已经把另一块小牌翻了出来：今日不谈胜负，只谈过程。\n\n战报递到他手边，他又翻了一块：过程尚待考证。\n\n队里有人盯着桌底，终于忍不住问：‘你到底带了多少块牌？’\n\n对方下意识用脚挡住一个麻袋。",
        choices=["把战报放这儿，请他连背面也读读。（原被影响者心情 +0.25）","别耽误人家换牌子，咱们走。（原被影响者心情 +0.25）"],
        outcomes=["战报被稳稳压在桌上，对方挑了半天，终于指出一个字写得不好。\n\n‘这个认。’你们回答得痛快，转身就走。\n\n走出老远，还有人念叨：‘上次被他说得全队都不好，今天只剩一个字。进步挺大。’", "车队经过时，对方连着换了三块牌，最后一块举反了。\n\n谁也没再停下来纠正他。队尾的人回头看了一眼，笑得差点踩进车辙：‘他今天唯一没准备好的，就是咱们不接话。’"] },
    grip = { title="这配件怎么占两个手", days=0, weight=40,
        text="包裹拆开，先露出一匹马，再露出马脚下的蛤蟆，最后才轮到那根长得很有分量的握把。\n\n阿飞捧着它看了半天：‘这东西往哪儿装？’\n\n抹茶核对收据：‘掌柜说，往手上装。’\n\n‘哪只手？’\n\n‘两只。他还说稳定性特别好，挨过一下的人，基本都不再晃了。’\n\n铁匠把试甲架往院中一推，自己先往旁边挪了两步。",
        choices=["给它起个正经用法：垂直，开甲。","问掌柜，握把都这样，本体得多大？"],
        outcomes=["试敲声不算清脆，试甲架上的铁皮却很诚实地瘪了进去。铁匠看了一眼，决定不争论它到底算什么。\n\n阿飞郑重地把握把收好。抹茶在收据背面写下备注：名称按配件登记，维修按事故处理。", "掌柜想了一会儿，指向窗外一座废弃的攻城器。\n\n阿飞顺着看过去，抹茶已经把他拽回来：‘看可以，别问能不能分期。’\n\n最后大家达成一致：它叫握把不妨碍它是双手锤，花的钱也不会因此只算配件价。"] },
    gift = { title="心意到了，行囊还没到", days=0, weight=50,
        text="后勤把那份暂存的补给又搬了出来，旁边摆着上次没装下它的行囊。\n\n‘当时谁说再挤挤的？’\n\n没人承认。\n\n‘口粮能挤，药瓶也能挤。挤完以后，这两样就得用勺子一起吃。’\n\n你们互相看了看。这一次，腾个正经空位似乎更能表达对援助的尊重。",
        choices=["空位留好了，别让口粮替咱们受挤。","再替我们收一天，先把那堆破烂理完。"],
        outcomes=["补给总算稳稳当当地装进了行囊。后勤把待领那一行划掉，特地晃了晃药包：完好的。\n\n有人提议今晚先吃口粮，立刻被提醒：那是安排晚饭，不是又一种腾空间的办法。", "后勤把补给收回去，在纸上加了一笔：心意仍在，空间仍欠。\n\n你们答应明天再来。他点点头，又把装着补给的箱子锁好了，显然很了解这支队伍看见空位时的反应。"] }
};
A.ideaAlive <- function(a) { return a != null && a.isAlive() && !a.isDying(); };
A.ideaChildren <- function() {
    local list=[];
    foreach(a in this.roster()) if(this.ideaAlive(a) && ["keke","xiaogui","yuchujiu"].find(this.characterId(a)) != null) list.push(a);
    return list;
};
A.ideaFlag <- function(a,k,fallback=0) { return a.getFlags().has("afeix_idea_"+k)?a.getFlags().get("afeix_idea_"+k):fallback; };
A.ideaMark <- function(a,k,v) { a.getFlags().set("afeix_idea_"+k,v); };
A.ideaMood <- function(list, delta, reason) {
    foreach(a in list) if(this.ideaAlive(a)) {
        if(delta<0)a.worsenMood(-delta,reason); else a.improveMood(delta,reason);
    }
};
A.ideaSafe <- function() {
    if(!this.isOrigin() || ::Tactical.isActive() || ::World.State==null || ::World.State.getCombatStartTime()!=0) return false;
    local player=::World.State.getPlayer(); if(player==null)return false;
    foreach(e in ::World.getAllEntitiesAtPos(player.getPos(),400.0))
        if(e!=null&&e.isAlive()&&!e.isAlliedWithPlayer()&&"getTroops" in e&&e.getTroops().len()>0)return false;
    return true;
};
A.ideaGiftFits <- function(kind) {
    local n=kind=="bao"?4:3, assets=::World.Assets;
    local cap=::Const.Difficulty.MaxResources[assets.m.EconomicDifficulty].Medicine+assets.m.MedicineMaxAdditional;
    return assets.getStash().getNumberOfEmptySlots()>0 && assets.m.Medicine+n<=cap;
};
A.ideaGiveGift <- function(kind) {
    if(!this.ideaGiftFits(kind))return false;
    local assets=::World.Assets, stash=assets.getStash(), old=assets.m.Medicine, item=null;
    try {
        item=::new(kind=="bao"?"scripts/items/supplies/bread_item":"scripts/items/supplies/cured_rations_item");
        item.setAmount(25.0);
        if(stash.add(item)==null)return false;
        assets.addMedicine(kind=="bao"?4:3);
        if(assets.m.Medicine!=old+(kind=="bao"?4:3))throw "medicine capacity changed";
    } catch(error) {
        if(item!=null)stash.remove(item);
        assets.setMedicine(old);return false;
    }
    this.ideaMood(kind=="bao"?this.roster():this.ideaChildren(),0.25,kind=="bao"?"保飞派的后勤援助":"儿飞派送来饭与药");
    if(kind=="er")this.set("ideas_er_gift",true);
    this.refreshAssets();return true;
};
A.ideaEligible <- function(key) {
    if(!this.ideaSafe())return false;
    local now=this.worldNow(), afei=this.findCharacter("afei"), safe=this.canManage();
    if(key=="hurt")return safe&&this.get("ideas_hurt_notice",false);
    if(key=="recover")return safe&&this.get("ideas_hurt_open",false)&&this.ideaAlive(afei)&&afei.getHitpoints()>=afei.getHitpointsMax()*0.9&&now>=this.get("ideas_hurt_at")+this.daysInSeconds(0.5);
    if(key=="grip")return safe&&this.ideaAlive(afei)&&this.get("ideas_grip_bought",false)&&!this.get("ideas_grip_seen",false);
    if(key=="gift")return safe&&this.get("ideas_gift","")!=""&&this.ideaGiftFits(this.get("ideas_gift",""))&&now>=this.get("ideas_gift_retry");
    if(now<this.get("ideas_next")||now<this.get("ideas_cd_"+key)||::World.getTime().Days<3)return false;
    if(key in this.IdeaScenes && "random" in this.IdeaScenes[key])return this.randomIdeaEligible(key);
    if(key=="reply")return safe&&this.get("ideas_dao_reply",false)&&now<=this.get("ideas_dao_reply_until");
    if(key=="dao")return !safe&&this.roster().len()>=3&&this.isWorldPartyMoving();
    if(key=="bao"||key=="er")return this.get("ideas_gift","")==""&&(key=="bao"||safe&&this.ideaAlive(afei));
    if(key=="cao")return safe&&this.ideaAlive(afei)&&afei.getHitpoints()>10&&this.get("ideas_cao_until")<=now;
    return false;
};
A.chooseIdea <- function() {
    foreach(key in ["hurt","recover","gift","grip"])if(this.ideaEligible(key))return key;
    if("nextChronicle" in this) { local c=this.nextChronicle();if(c!="")return c; }
    local total=0, choices=[];
    foreach(key in ["dao","bao","er","cao","reply"])if(this.ideaEligible(key)){total+=this.IdeaScenes[key].weight;choices.push(key);}
    foreach(key in this.RandomIdeaOrder)if(this.ideaEligible(key)){total+=this.IdeaScenes[key].weight;choices.push(key);}
    if(total==0)return "";
    local roll=::Math.rand(1,total);
    foreach(key in choices){roll-=this.IdeaScenes[key].weight;if(roll<=0)return key;}
    return "";
};
A.hasIdea <- function() {
    foreach(key,d in this.IdeaScenes)if(this.ideaEligible(key))return true;
    return "nextChronicle" in this&&this.nextChronicle()!="";
};
A.resolveIdea <- function(key,choice,token) {
    if(!this.ideaSafe() || token!=this.get("ideas_active_token") || this.get("ideas_done_token")==token)return this.result(false,"这次事件已处理，或此刻不适合交谈。");
    if(!(key in this.IdeaScenes))return "resolveChronicle" in this?this.resolveChronicle(key,choice,token):this.result(false,"这段故事暂时不能继续。");
    local d=this.IdeaScenes[key];if(choice<0||choice>=d.choices.len())return this.result(false,"没有这个选项。");
    // Native events pause movement and camping. Revalidate resources and actors,
    // not the scheduler's moving/camping predicate, when the choice is committed.
    if((key=="cao"||key=="er"||key=="recover")&&!this.ideaAlive(this.findCharacter("afei")))return this.result(false,"阿飞此刻不在队中。");
    local now=this.worldNow(), text=d.outcomes[choice], afei=this.findCharacter("afei");
    if("random" in d) {
        local r=this.resolveRandomIdea(key,choice);
        if(!r.ok)return r;
    } else if(key=="dao") {
        this.ideaMood(this.roster(),choice==0?-0.5:-0.75,"路上遇见倒飞派");
        this.set("ideas_dao_token",token);this.set("ideas_dao_wait",true);this.set("ideas_dao_reply",false);
        foreach(a in this.roster())if(this.ideaAlive(a))this.ideaMark(a,"dao",token);
    } else if(key=="bao"||key=="er") {
        if(choice==0) {
            if(!this.ideaGiveGift(key)){this.set("ideas_gift",key);text="后勤把礼物抬到行囊边，量了量，又原样抬了回去：‘心意收到了，空间没收到。’\n\n整份食物和药品已替你留好；腾出行囊空位与医疗储备容量后，在安全地点领取。本次尚未获得补给或心情奖励。";}
        }
    } else if(key=="cao") {
        if(choice==0) {
            if(afei.getHitpoints()<=10)return this.result(false,"阿飞伤得太重，先替他包扎，或用干净布压住。");
            this.set("ideas_cao_serial",token);this.set("ideas_cao_until",now+this.daysInSeconds(1));
            foreach(a in this.roster())if(this.ideaAlive(a))this.ideaMark(a,"cao_ticket",token);
        } else if(choice==1) {
            if(::World.Assets.getMedicine()<2)return this.result(false,"药品不足；可以选择用干净布压住。");
            ::World.Assets.addMedicine(-2);this.ideaMood([afei],0.25,"伙伴帮忙包扎");
        }
    } else if(key=="hurt") {this.set("ideas_hurt_notice",false);}
    else if(key=="recover") {
        local list=[],ticket=this.get("ideas_hurt_token");
        foreach(a in this.ideaChildren())if(this.ideaFlag(a,"hurt")==ticket)list.push(a);
        this.ideaMood(list,0.25,"飞碟重新起飞");this.set("ideas_hurt_open",false);this.set("ideas_hurt_notice",false);
    } else if(key=="reply") {
        local list=[],ticket=this.get("ideas_dao_token");
        foreach(a in this.roster())if(this.ideaFlag(a,"dao")==ticket)list.push(a);
        this.ideaMood(list,0.25,"拿战报回应倒飞派");this.set("ideas_dao_reply",false);
    } else if(key=="grip") {this.set("ideas_grip_seen",true);}
    else if(key=="gift") {
        if(choice==0) {if(!this.ideaGiveGift(this.get("ideas_gift","")))return this.result(false,"后勤量了量空位，摇头：‘就差一点也叫装不下。’整份补给仍替你留着，本次未领取。");this.set("ideas_gift","");}
        else {this.set("ideas_gift_retry",now+this.daysInSeconds(1));}
    }
    this.set("ideas_done_token",token);this.set("ideas_cd_"+key,now+this.daysInSeconds(d.days));
    this.set("ideas_next",now+this.daysInSeconds(1.5));this.refreshAssets();
    return this.result(true,text);
};
A.ideaScreen <- function(event,id) {
    local key=event.m.Idea, d=key in this.IdeaScenes?this.IdeaScenes[key]:("chronicleScene" in this?this.chronicleScene(key):null);
    local s={ID=id,Text="",Image="",List=[],Characters=[],Options=[],function start(e){}};
    if(id=="result"||d==null) {
        s.Text=event.m.Outcome; s.Options.push(this.ledgerOption("继续上路",function(e){return 0;}));return s;
    }
    s.Text=(key=="liu"||key=="liu_reply"?"[img]gfx/ui/events/afeix_liu_qingsong.png[/img]":"[img]gfx/ui/events/event_80.png[/img]")+d.text;
    foreach(i,label in d.choices) s.Options.push(this.ideaOption(key,i,label));
    if(!(key in this.IdeaScenes))s.Options.push(this.ledgerOption("稍后再说，继续上路。",function(e){return 0;}));
    return s;
};
A.ideaOption <- function(key,index,label) {
    return this.ledgerOption(label,function(e){local r=::AfeixExpedition.resolveIdea(key,index,e.m.Token);e.m.Outcome=r.text;return r.ok?"result":"retry";});
};
