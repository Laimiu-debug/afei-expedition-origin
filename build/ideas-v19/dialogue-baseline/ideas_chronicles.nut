// These are authored fictional scenes. NPC contacts do not create roster actors.
local A=::AfeixExpedition;
A.Chronicles <- {
    liu={title="传奇儿飞派：刘青松",text="酒馆有人把一包药放在阿飞面前，没等他开口，就先喊了一声飞爹。阿飞整了整领口：‘知道我的厉害了？’\n\n刘青松指着刚送进来的盾：‘知道。也知道这块板今天替你挨了多少下。’旁边的人笑出了声，他却认真把药推近了些：‘夸你是盼你好，不是盼你再拿脸接一锤。’\n\n临走前，他说自己还要赶另一条路，给黑旗留下两种补给，让阿飞挑一份。",choices=["听劝，收下 4 药品。","先把盾修好，收下 6 工具。"]},
    liu_reply={title="这次先讲挨打的地方",text="又一次在酒馆碰见刘青松，阿飞把战报摊开，先圈出差点断开的那一段阵线。刘青松看了看他：‘今天怎么不先讲最后那一下？’\n\n阿飞把笔递过去：‘那一下大家都看见了。这一段，你帮我看看。’\n\n刘青松笑了：‘行，飞爹这回算是听进去了。’",choices=["先听完，再讲赢得漂亮的部分。（全队心情 +0.25）","叫大家都来，这份战报一起看。（同样恢复心情）"]},
    er_xiaoyuan={title="问题纸上的新一行",text="小原寄回那张写满问题的纸，最下方多了一行：‘上次你说肯听，这次听见了什么？’阿飞想写一段漂亮话，最后只记了一个队友纠正他的决定。抹茶看过，把多余的墨水收走了。",choices=["承认这一句，确实是他提醒得对。","下一次开口前，再等别人说完。"]},
    er_haman={title="旗大也要认账",text="哈曼的来信很短：‘说过做不到的事，后来有没有补上解释？’阿飞翻出旧契约，没有把失败那行划掉，反而添了一页说明。旗还挂得很高，这次下面压住它的是说清楚的话。",choices=["把没做到的也写进回信。","把补救的办法写具体。"]},
    er_sige={title="第四张凳子终于坐了人",text="营火边又摆了四张凳子。阿飞正准备坐上最中间那张，忽然想起四哥的话，把凳子向旁边让了让：‘今天先听你们说。’抹茶没客气，第一句就是明天的饭钱。",choices=["饭钱也算正经话，先听。","把空位再往火边挪一点。"]},
    er_keke={title="自己人也能说不",text="阿飞重新翻到可可那张便笺。纸角已经磨软，‘拿不准’三个字仍很清楚。他在旁边添了一句：自己人也可以说不。写完以后，反倒觉得这面旗比昨天更稳了一点。",choices=["问愿不愿意，再谈能不能。","把拒绝也当成一句认真回答。"]},
    er_xiaogui={title="战报背面也能写",text="小龟那张画着圆脑袋的战报被翻到了背面。阿飞没有补上更多夸奖，只留了两行空白：当时看见了什么，下一次准备怎么选。纸上的小龟还是很圆，留给答案的地方却宽了。",choices=["先看判断，再看最后赢没赢。","失手那段也值得写下来。"]},
    er_yuchujiu={title="叫停以后，还有下一步",text="阿飞把初九那张写着‘停’的纸条展开，又沿旧折痕收好。以前他只记得那一声很响，现在想起来，后面其实还跟着一句：看清楚了，我们再一起走。",choices=["停一下，是为了好好往前。","听清风险，再把旗举起来。"]},
    route_toad={title="这一下打完，记得回头",text="阿飞把锤上沾的泥刮掉，正在讲自己怎么打开缺口。大谋把后排留下的脚印指给他看：‘你冲出去以后，他们是这样跟上的。’阿飞数了数，终于把战报里那个我改成了我们。",choices=["能打进去，也要带人出来。","下回先把跟进的信号讲好。"]},
    route_jiahao={title="这回让他站在旗前",text="有人来问最后那一击是谁打的。阿飞已经把领口整好，话到嘴边，却侧身把真正出手的伙伴让到了旗前。抹茶小声提醒他：再往旁边站一点，别把人挡了。",choices=["今天这个名字，写他的。","我站旁边，也看得见黑旗。"]},
    route_feidie={title="飞爹也得落地吃饭",text="一场战斗下来，飞爹这称呼叫得比军号还响。阿飞还想再站高一点讲两句，饭碗已经递到了手里。他端着碗坐下，发现大家想问的并不是什么大道理：下一段路，准备怎么一起走。",choices=["先吃饭，再把路线讲清楚。","叫飞爹可以，意见也得照说。"]},
    bottle_daily={title="先把车链装回去",text="旧车链又松了。阿飞讲了一路带人的道理，小酒瓶只把沾油的布递给他：‘挺好，先带我把这边扶住。’他扶住车架，她把链条扣回去，两个人总算同时安静了一会儿。",choices=["这边我扶着，你慢慢来。（两人心情 +0.25）","道理晚点讲，先试试能不能转。（同样效果）"]},
    bottle_after={title="铃声留在走过的路上",text="车铃的声音又在阿飞脑子里响了一下。他抬起头，路还长，同行的人正等着出发。那段告别没有被重写，下一步也不用等谁回来替他决定。",choices=["把记得的记好，把眼前的人带好。（阿飞心情 +0.25）","收好名册，继续向前。（同样效果）"]}
};
A.chronicleScene <- function(key){return key in this.Chronicles?this.Chronicles[key]:null;};
A.nextChronicle <- function(){
    if(!this.ideaSafe()||!this.canManage()||!this.ideaAlive(this.findCharacter("afei"))||this.worldNow()<this.get("ideas_chronicle_next"))return "";
    local town=this.currentTown(),wins=this.get("ideas_wins");
    if(town!=null&&!this.get("chronicle_done_liu",false)&&(this.get("ideas_er_gift",false)||this.progressCount()>=6))return "liu";
    if(town!=null&&this.get("chronicle_done_liu",false)&&!this.get("chronicle_done_liu_reply",false)&&wins>=this.get("ideas_liu_wins")+3)return "liu_reply";
    if(wins>=1)foreach(id in this.RootOrder)if(this.get("root_done_"+id,false)&&!this.get("chronicle_done_"+id,false))return id;
    local route="route_"+this.route();
    if(wins>=2&&route in this.Chronicles&&!this.get("chronicle_done_"+route,false))return route;
    if(this.get("growth_done_bottle",false)&&this.ideaAlive(this.findCharacter("bottle"))&&wins>=2&&!this.get("chronicle_done_bottle_daily",false))return "bottle_daily";
    if(this.get("bicycle_state")==4&&!this.get("chronicle_done_bottle_after",false))return "bottle_after";
    return "";
};
A.resolveChronicle <- function(key,choice,token){
    if(!(key in this.Chronicles)||choice<0||choice>1||this.get("chronicle_done_"+key,false)||!this.ideaAlive(this.findCharacter("afei")))return this.result(false,"这段故事已记录，或当事人此刻不在队。 ");
    local ending="这段话已经写进黑旗名册。";
    if(key=="liu") {
        local reward=choice==0?{kind="medicine",amount=4}:{kind="tools",amount=6};
        try{this.grantStoryReward(reward);}catch(e){return this.result(false,"公共储备装不下整份补给；腾出容量后可再来会面。");}
        this.set("ideas_liu_wins",this.get("ideas_wins"));ending="刘青松把补给推过来：‘下次少用一点，就是好消息。’获得 "+this.storyRewardText(reward)+"。他继续自己的旅途。";
    } else if(key=="liu_reply")this.ideaMood(this.roster(),0.25,"刘青松陪黑旗复盘");
    else if(key=="bottle_daily"){
        local b=this.findCharacter("bottle");if(!this.ideaAlive(b))return this.result(false,"小酒瓶此刻不在队中。");
        this.ideaMood([this.findCharacter("afei"),b],0.25,"一起修好车链");
    } else this.ideaMood([this.findCharacter("afei")],0.25,"把走过的路记在心里");
    this.set("chronicle_done_"+key,true);this.set("chronicle_choice_"+key,choice);
    this.set("ideas_done_token",token);this.set("ideas_chronicle_next",this.worldNow()+this.daysInSeconds(2));this.refreshAssets();
    return this.result(true,ending);
};
A.hasIdeaRecords <- function(){
    if(this.get("ideas_gift","")!=""||this.get("ideas_cao_until")>0||this.get("ideas_hurt_open",false))return true;
    foreach(key,d in this.Chronicles)if(this.get("chronicle_done_"+key,false))return true;
    return false;
};
A.ideasLedgerPage <- function(event,page){
    local parts=split(page,":"),kind=parts[0];if(kind!="ideas"&&kind!="ideas_read"&&kind!="journey_index")return null;
    local s=this.storyScreen(page);
    if(kind=="journey_index"){
        s.Text="旅途旧事\n\n记在纸上的人和路，也值得偶尔翻一翻。";
        if(this.hasStoryRecords())s.Options.push(this.ledgerNav("伙伴成长与旧事","growth"));
        if(this.hasIdeaRecords())s.Options.push(this.ledgerNav("路上的消息与相遇","ideas"));
        s.Options.push(this.ledgerNav("返回名册","home"));return s;
    }
    if(kind=="ideas_read"&&parts.len()>1&&parts[1] in this.Chronicles&&this.get("chronicle_done_"+parts[1],false)) {
        local key=parts[1],d=this.Chronicles[key];s.Text=d.title+"\n\n"+d.text+"\n\n当时选择："+d.choices[this.get("chronicle_choice_"+key)]+"\n此为旧事记录，重读不再结算。";
    } else {
        s.Text="路上的消息\n\n这里保存已经走过的相遇与回信。";
        local pending=this.get("ideas_gift","");
        if(pending!=""){
            s.Text+="\n还有一份"+(pending=="bao"?"保飞派":"儿飞派")+"补给待领取。";
            s.Options.push(this.ledgerAction("领取留下的补给",function(){local A=::AfeixExpedition,k=A.get("ideas_gift","");if(!A.canManage()||k==""||!A.ideaGiveGift(k))return A.result(false,"请在安全地点，腾出一个行囊空位及足够医疗储备容量。");A.set("ideas_gift","");return A.result(true,"整份补给已领取。");},"ideas"));
        }
        if(this.get("ideas_cao_until")>this.worldNow())s.Text+="\n曹飞派的热血尚在：阿飞亲自出战时启用。";
        if(this.get("ideas_hurt_open",false))s.Text+="\n儿飞派还在等飞爹养好伤。";
        local known=[];foreach(key,d in this.Chronicles)if(this.get("chronicle_done_"+key,false))known.push(key);
        known.sort();local offset=parts.len()>1?this.storyPageNumber(parts[1]):0;
        if(offset<0||offset>=known.len())offset=0;
        local n=::Math.min(3,known.len()-offset),window={offset=offset,count=n,more=known.len()>3,next=offset+n>=known.len()?0:offset+n};
        for(local i=window.offset;i<window.offset+window.count;++i)s.Options.push(this.ledgerNav(this.Chronicles[known[i]].title,"ideas_read:"+known[i]));
        if(window.more)s.Options.push(this.ledgerNav("翻到另一页","ideas:"+window.next));
    }
    s.Options.push(this.ledgerNav("返回名册","home"));return s;
};
