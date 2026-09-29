local A = ::AfeixExpedition;
A.IdeaScenes <- {
    dao = { title="路边有台，张嘴就来", days=7, weight=10,
        text="路边几个人把木箱垒成高台，连战报都没看，就宣布今天又是飞队的问题。阿飞刚想解释，对方已经把明天的批评也念了。抹茶算了算：再听下去，这段路就得按观众席收费。",
        choices=["走了，路比他们的嘴长。（全队心情 -0.5）","来，给他们讲清楚。（全队心情 -0.75）"] },
    bao = { title="保飞派的后勤部", days=6, weight=12,
        text="小推车上挂着‘保飞后勤，概不赊账’。阿飞刚摸钱袋，对方把面包和药包往前一推：‘说的是别人。你们先吃，剩下的事打赢再说。’",
        choices=["收下，药包交给后勤。（面包 25、药品 4，全队心情 +0.25）","心意到了，留给更缺的人。"] },
    er = { title="飞爹，饭还热着", days=6, weight=12,
        text="营地外有人一连喊了三声‘飞爹’。阿飞还没摆好姿势，一篮饭已经塞到手里：‘先吃，别又说手抖是战术。’药包压在篮底，字条上写着：挨打了记得用。",
        choices=["都分一分，别只盯着我。（口粮 25、药品 3，儿飞派心情 +0.25）","今天够了，留着下次见。"] },
    cao = { title="气氛到这儿了", days=10, weight=8,
        text="曹飞派几句话下去，前排握紧了盾，后排擦亮了箭，连抹茶都想把算盘当暗器。阿飞拍案而起：‘这把必须拿下！’喝彩声中，他才发现掌心正在渗血。\n\n热血可保留 24 小时。阿飞下次实际出战时，本次在册且同场出战的队员决心 +20，持续两个自己的回合；阿飞同时流血，每回合 5 点、两次。待命者不在战场受益，资格随该战一并消耗。",
        choices=["这股劲留到下一仗！（全队鼓舞，阿飞流血）","先包扎，今晚到此为止。（药品 -2，阿飞心情 +0.25）","散了散了，用干净布压住。（不获得状态）"] },
    hurt = { title="飞碟漏油了？", days=0, weight=100,
        text="阿飞刚想把伤口藏到披风后，药箱已经放在脚边。有人小声问：‘飞碟是不是漏油了？’没人接这个笑话。平常最响的那声飞爹，今晚听起来有点闷。\n\n本次战后在册儿飞派已因担忧而心情 -0.5；查看这段记录不会再次扣除。",
        choices=["伤是真的，人也真回来了。","今晚先歇着，明天再逞强。"] },
    recover = { title="飞碟重新起飞", days=0, weight=100,
        text="阿飞又开始嫌大家收拾得慢。儿飞派几个人对视一眼，这回没人嫌他声音大：‘行，听这个动静，应该修好了。’",
        choices=["走了，今天让你们看看。（当时担忧且仍在队者心情 +0.25）","先吃饭，满血也不能空肚子。（同样恢复心情）"] },
    reply = { title="战报可以先放一放", days=0, weight=30,
        text="高台上的人又来了，这次看见战报，先把木箱翻了个面。阿飞正要站上去开口，抹茶已经把箱子搬走：‘该赶路了。要讲话，路上讲。’",
        choices=["赢了就走，下一场还得打。（当时被怼者心情 +0.25）","记下来，下次还拿战报说话。（同样恢复心情）"] },
    grip = { title="这握把怎么要用两只手", days=0, weight=40,
        text="包裹打开，众人先看到马，再看到蛤蟆，最后看到抬不动包裹的人。抹茶反复核对收据：‘写的是握把。可这个重量，账上至少得算半匹马。’",
        choices=["装不上弩？那就装在双手上。","请铁匠演示，别让阿飞拍桌子。"] },
    gift = { title="还没领走的心意", days=0, weight=50,
        text="后勤把那份没装下的食物与药品又拿了出来。这回腾出一个行囊空位，也给医疗储备留些地方。",
        choices=["现在领取整份补给。","继续替我们留着。"] }
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
    if(key=="reply")return safe&&this.get("ideas_dao_reply",false)&&now<=this.get("ideas_dao_reply_until");
    if(key=="dao")return !safe&&this.roster().len()>=3&&::World.State.getPlayer().isMoving();
    if(key=="bao"||key=="er")return this.get("ideas_gift","")==""&&(key=="bao"||safe&&this.ideaAlive(afei));
    if(key=="cao")return safe&&this.ideaAlive(afei)&&afei.getHitpoints()>10&&this.get("ideas_cao_until")<=now;
    return false;
};
A.chooseIdea <- function() {
    foreach(key in ["hurt","recover","gift","grip"])if(this.ideaEligible(key))return key;
    if("nextChronicle" in this) { local c=this.nextChronicle();if(c!="")return c; }
    local total=0, choices=[];
    foreach(key in ["dao","bao","er","cao","reply"])if(this.ideaEligible(key)){total+=this.IdeaScenes[key].weight;choices.push(key);}
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
    local now=this.worldNow(), text="", afei=this.findCharacter("afei");
    if(key=="dao") {
        this.ideaMood(this.roster(),choice==0?-0.5:-0.75,"路上遇见倒飞派");
        this.set("ideas_dao_token",token);this.set("ideas_dao_wait",true);this.set("ideas_dao_reply",false);
        foreach(a in this.roster())if(this.ideaAlive(a))this.ideaMark(a,"dao",token);
        text=choice==0?"马车走远了，声音还跟了一段。大家把脚下的石子踢得格外响。":"阿飞讲了半天，对面只记下一句：他急了。回到队伍时，连坐骑都不太想听复盘。";
    } else if(key=="bao"||key=="er") {
        if(choice==0) {
            if(this.ideaGiveGift(key))text="饭与药都收妥了。口号还没喊完，饭已经开始分了。";
            else {this.set("ideas_gift",key);text="行囊或医疗储备装不下，整份礼物已替你留好；腾出空间后可在安全地点领取。";}
        } else text="心意记下了，对方带着补给继续往前。";
    } else if(key=="cao") {
        if(choice==0) {
            if(afei.getHitpoints()<=10)return this.result(false,"阿飞伤得太重，先替他包扎，或用干净布压住。");
            this.set("ideas_cao_serial",token);this.set("ideas_cao_until",now+this.daysInSeconds(1));
            foreach(a in this.roster())if(this.ideaAlive(a))this.ideaMark(a,"cao_ticket",token);
            text="热血已留到下一仗，有效 24 小时。决心归全队，纱布归阿飞；须阿飞亲自出战才能启用。";
        } else if(choice==1) {
            if(::World.Assets.getMedicine()<2)return this.result(false,"药品不足；可以选择用干净布压住。");
            ::World.Assets.addMedicine(-2);this.ideaMood([afei],0.25,"伙伴帮忙包扎");text="掌声换成了撕绷带的声音。阿飞最好先把手放下。";
        } else text="众人把桌子扶正。气氛散得很快，毕竟谁都不想借出自己的手。";
    } else if(key=="hurt") {this.set("ideas_hurt_notice",false);text="阿飞把伤口让出来，药箱终于打开。今晚先把人照顾好。";}
    else if(key=="recover") {
        local list=[],ticket=this.get("ideas_hurt_token");
        foreach(a in this.ideaChildren())if(this.ideaFlag(a,"hurt")==ticket)list.push(a);
        this.ideaMood(list,0.25,"飞碟重新起飞");this.set("ideas_hurt_open",false);this.set("ideas_hurt_notice",false);text="熟悉的声音回来了，大家终于松了口气。";
    } else if(key=="reply") {
        local list=[],ticket=this.get("ideas_dao_token");
        foreach(a in this.roster())if(this.ideaFlag(a,"dao")==ticket)list.push(a);
        this.ideaMood(list,0.25,"拿战报回应倒飞派");this.set("ideas_dao_reply",false);text="战报留下了，队伍继续往前。";
    } else if(key=="grip") {this.set("ideas_grip_seen",true);text="掌柜说是握把，铁匠说是双手锤。你说都行，价格能不能按握把算？";}
    else if(key=="gift") {
        if(choice==0) {if(!this.ideaGiveGift(this.get("ideas_gift","")))return this.result(false,"整份补给还装不下，本次未领取。");this.set("ideas_gift","");text="补给已经装好，待领取记录也划掉了。";}
        else {this.set("ideas_gift_retry",now+this.daysInSeconds(1));text="后勤把礼物收好，明天再问。";}
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
