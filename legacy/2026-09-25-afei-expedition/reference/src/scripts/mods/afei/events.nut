local A = ::AfeiExpedition;

A.RecruitDrills <- {
 C04={hours=2,food=0,text="两人配合试训",choices=["让大谋顶住靶架接应", "由匿名试训伙伴接应"]},
 C05={hours=2,food=0,text="安全靶场射击",choices=["按照她的节奏打完靶场", "请她逐步说明站位"]},
 C06={hours=2,food=0,text="重新画好行军路线",choices=["先听她把路线讲完", "从最容易走错的路口重画"]},
 C07={hours=2,food=3,text="绳阵投掷试训",choices=["换一个靶子再投", "演示绳阵接应"]},
 C09={hours=2,food=0,text="门前支援演练",choices=["按鼓点守住入口", "先听清下一拍"]},
 C10={hours=2,food=0,text="传令演练",choices=["把整句命令传完", "让伙伴复述接到的意思"]},
 C15={hours=4,food=0,text="路线勘察",choices=["边走边记路标", "走完后复述路线"]},
 C17={hours=2,food=6,text="一起吃完这顿饭",choices=["把每个人的来意听完", "先让她认清自己的伙伴"]},
 C19={hours=2,food=0,text="安全对抗练习",choices=["先练嘴上挑衅", "先练盾后的退让"]},
 C20={hours=2,food=0,text="交还旧名册并演练换岗",choices=["核对旧名册后交岗", "从最晚的那班岗练起"]},
 C22={hours=2,food=4,text="清点物资与盾阵练习",choices=["先分食物再练盾阵", "先清点最后一份口粮"]},
 C23={hours=1,food=0,text="分段训练",choices=["完成这一段（练习、休息、再练习各一小时）"]},
 C25={hours=3,food=0,text="讲明规矩并试招",choices=["先约定招式的边界", "试过以后逐招复盘"]},
 C26={hours=2,food=0,text="修好木板并清点幕布道具",choices=["从破损木板开始", "照清单逐件核对"]},
 C28={hours=2,food=0,text="路线试走与归还路牌",choices=["沿稳妥路线慢慢走", "试走快路后讲清风险"]},
 C29={hours=3,food=0,text="三人接棒演练",choices=["按自己的名字登记后完成三次交接", "当场重做交接，直到三人接稳"]},
 C33={hours=2,food=3,text="守车与换盾试训",choices=["让她守住车尾，再换一人从侧路靠近", "卸完粮再练一次并肩举盾"]},
 C34={hours=2,food=0,text="驿路红线试射",choices=["等前排站稳，再沿记号试射", "换个射手，看她的记号是否讲得清楚"]}
};
A.MainNames <- ["三个队长先上路", "第一次把话说完", "黑旗上的十个位置", "蓝旗同行", "小熊出击", "我不上这个当", "北境白影", "再集合一次", "给后来的人留一张床"];
A.mainAvailable <- function(n) {
 if(this.w("m0"+n+"_done"))return false;
 local c=this.getPaidContracts();
 switch(n) {
 case 1:return true;
 case 2:return c>=4 && this.roster().len()>=5;
 case 3:return this.day()>=20 && this.countNamedInRoster()>=8;
 case 4:return this.day()>=25 && c>=8;
 case 5:return this.day()>=40 && c>=10;
 case 6:local b=this.named("C14",true);return b!=null && this.now()-this.g(b,"joined_at")>=this.hours(72);
 case 7:local count=0,total=0;foreach(b in this.roster())if(!this.g(b,"camped") && b.getHitpoints()>0 && !b.getSkills().hasSkill("effects.concussion")) {count++;total+=b.getLevel();}
return this.day()>=75 && count>=8 && total.tofloat()/count>=7;
 case 8:return this.day()>=90 && c>=24 && this.countNamedEverRecruited()>=8 && this.w("cohesion_peak")>=60;
 case 9:return this.day()>=45 && c>=14;
 }
 return false;
};
A.drill <- function(id,choice) {
 if(!this.safe() || !this.eligible(id) || this.w("recruit_ready_"+id) || !(id in this.RecruitDrills))return false;
 local d=this.RecruitDrills[id];if(choice<0 || choice>=d.choices.len() || !this.pay(0,d.food))return false;
 this.spendHours(d.hours);this.inc("drill_"+id);this.sw("drill_choice_"+id,choice);
 local steps=id=="C19"?2:(id=="C23"?3:1);
 if(this.w("drill_"+id)>=steps)this.sw("recruit_ready_"+id,true);
 return true;
};
A.specialRecruit <- function(id,choice=0) {
 if(!this.safe() || !this.eligible(id) || this.w("recruit_ready_"+id))return false;
 switch(id) {
 case "C32":if(!this.review())return false;break;
 case "C14":this.spendHours(2);break;
 case "C18":break;
 case "C30":if(choice==0) {if(!this.pay(90))return false;}
else this.spendHours(3);break;
 case "C31":if(choice==0) {if(!this.pay(80))return false;}
else this.spendHours(3);break;
 default:return false;
 }
 this.sw("recruit_ready_"+id,true);return true;
};
A.mainAction <- function(n,choice=0) {
 if(!this.safe() || !this.mainAvailable(n))return false;
 switch(n) {
 case 1:return this.startDelivery("m01",180);
 case 2:if(choice==0) {if(!this.pay(0,6))return false;this.spendHours(3);}
this.bumpCohesion(choice==0?6:3);break;
 case 3:break;
 case 4:return this.startEscort("m04");
 case 5:
   if(this.w("bear_demos")<2) {this.inc("bear_demos");return true;}
   this.bumpCohesion(choice==0?4:2);break;
 case 6:
   if(!this.w("key_resolved")) {
     if(choice==0) {this.spendHours(2);this.bumpCohesion(2);}
else if(!this.pay(60))return false;
     this.sw("key_resolved",this.now());this.sw("key_contracts",this.getPaidContracts());return true;
   }
   if(this.now()<this.w("key_resolved")+this.hours(168) || this.getPaidContracts()<=this.w("key_contracts"))return false;
   break;
 case 7:return this.spawnFrost();
 case 8:
   if(!this.w("journey_m08_supply_done"))return this.startDelivery("m08_supply",this.deliveryReward());
   if(!this.w("journey_m08_escort_done"))return this.startEscort("m08_escort");
   this.bumpCohesion(6);break;
 case 9:
   local town=this.town();if(town==null || !this.pay(300,12,6))return false;
   this.spendHours(6);this.sw("camp_enabled",true);this.sw("camp_home_id",town.getID());this.sw("camp_home_name",town.getNameOnly());this.sw("rent_time",this.now());
   ::World.Assets.m.BrothersMax=39;this.bumpCohesion(4);break;
 }
 this.sw("m0"+n+"_done",true);if(n==8)this.tryAwakenAfei();return true;
};
A.refreshMilestones <- function() {
 if(this.w("m03_done") && !this.w("full_black_flag")) {local all=true;for(local i=1;i<=10;i++)if(!this.w("ever_"+format("C%02d",i)))all=false;if(all)this.sw("full_black_flag",true);}
 if(this.eligible("C16") && this.w("escort_contracts")>this.w("tutu_escort_baseline",this.w("escort_contracts")))this.sw("recruit_ready_C16",true);
 if(this.eligible("C16") && !this.w("tutu_invited")) {this.sw("tutu_invited",true);this.sw("tutu_escort_baseline",this.w("escort_contracts"));}
 this.tryAwakenAfei();
};
A.letters <- function() {
 local text=this.w("captain_dead")?"残旗回信。阿飞已经不能再签名，我们仍把每个人的名字留下。":"再集合一次。送到的补给与平安抵达的人，都是这面旗留下的回信。";
 local living="",dead="",grown="";
 foreach(id,d in this.Characters) {if(this.named(id)!=null)living+=d.name+"、";if(this.w("dead_"+id))dead+=d.name+"、";if(this.w("growth_done_"+id))grown+=d.name+"、";}
 text+="\n\n现任伙伴："+(living==""?"由普通佣兵接续队伍":living)+"\n旧信纪念："+(dead==""?"这一页尚未写下逝者":dead)+"\n已经完成的成长："+(grown==""?"还有故事等下一次回访":grown);
 text+="\n\n"+(this.w("m07_done")?"北境白影已倒下，纪念章随信收好。":"北境传闻仍在，不妨留待下一次远行。");
 local signer=this.named("C01");if(signer==null)signer=this.named("C02");if(signer==null)signer=this.named("C03");if(signer==null)signer=this.named(this.w("selected_proxy",""));
 text+="\n落款："+(signer!=null?signer.getNameOnly():(this.roster().len()>0?this.roster()[0].getNameOnly():"驿站书记"))+"。\n\n名册与未完成的邀请继续保留。";
 return text;
};
A.option <- function(label,fn) {return {Text=label,Action=fn,function getResult(e) {return this.Action(e);}
};};
A.nav <- function(label,id) {return this.option(label,function(e) {return id;});};
// 事件底栏只有 1–6 行。第 7 个按钮会把底栏塌成一行，返回键画在外面，点不到。
A.stripPrefix <- function(text,prefix) {
 if(text.len()>=prefix.len() && text.slice(0,prefix.len())==prefix)return text.slice(prefix.len());
 return text;
};
A.pageWindow <- function(total,offset,slots) {
 if(total<=0)return {offset=0,count=0,more=false,next=0};
 if(offset<0 || offset>=total)offset=0;
 local count=slots;if(offset+count>total)count=total-offset;
 local more=total>slots;local nextOff=offset+slots;if(nextOff>=total)nextOff=0;
 return {offset=offset,count=count,more=more,next=nextOff};
};
A.seal <- function(s) {
 if(s.Options.len()==0)s.Options.push(this.option("合上",function(e){return 0;}));
 if(s.Options.len()>6) {local close=s.Options[s.Options.len()-1];while(s.Options.len()>5)s.Options.remove(5);s.Options.push(close);}
 if(s.Text.find("[img]")==0) s.Text+="}";
 return s;
};
A.perform <- function(label,fn,back) {return this.option(label,function(e) {local ok=fn();if(ok)::AfeiExpedition.refreshReadyCandidates();e.m.Notice=ok?"这件事已经办妥。若邀请准备完成，对方会出现在相识酒馆的招募栏。":"眼下还办不了。先确认地点、同行者、物资和时间。";return back;});};
A.subName <- function(text,name) {
 local needle="%name%";
 local idx=text.find(needle);
 while(idx!=null) {
   text=text.slice(0,idx)+name+text.slice(idx+needle.len());
   idx=text.find(needle);
 }
 return text;
};
// 对话立绘：src/gfx/ui/events/afei_<id>.png 存在时返回 [img] 头，否则空串（用 %terrainImage% 兜底）
A.eventArt <- function(id) {
 if(!("Art" in this) || !("events" in this.Art) || !(id in this.Art.events)) return "";
 return "[img]gfx/ui/events/afei_"+id+".png[/img]{";
};
// 主线旗标 → 游戏内名称（避免向玩家显示 M04Done 这类设计编号）
A.MainFlagNames <- {M04Done="蓝旗同行", M05Done="小熊出击"};
// 招募步骤的正文与选项：名册页与上门对话共用
A.recruitStep <- function(e,id,back) {
 local A=::AfeiExpedition,d=this.Characters[id],text="",options=[];
 if(!this.isKnown(id))text+="名册上还没有这个名字。也许该去酒馆听听消息。";
 else if(!this.eligible(id))text+="这段缘分还没走到能同行的时候。";
 else if(this.w("recruit_ready_"+id)) {local place=this.w("candidate_town_name_"+id,"最初相遇的城镇");text+="该做的事已经做完。"+d.name+"正在"+place+"的酒馆等正式签约；打开当地招募栏即可看见。费用："+this.hireCost(id)+"克朗。";}
 else if(id in this.RecruitDrills) {
   local d2=this.RecruitDrills[id];
   text+=d2.text+"；本步 "+d2.hours+"小时、"+d2.food+"食物。已完成步骤 "+this.w("drill_"+id)+"。\n结果按练习完成确定，不靠随机掷点。";
   foreach(i,label in d2.choices) {local choice=i;options.push(this.perform(label,function(){return A.drill(id,choice);},back));}
 }
 else if(["C08","C12","C21"].find(id)!=null) {text+="前往邻镇实际交付"+(id=="C12"?"信件":"货物")+"，没有强制期限。到达后在此确认交付。";options.push(this.perform("领取路线 / 确认交付",function(){return A.deliveryStep(id,id=="C12"?0:A.deliveryReward());},back));text+="\n"+this.journeyDescription(id);}
 else if(id=="C13") {text+="沿线寻回补给箱，可先侦察后取回；不必强行战斗。";options.push(this.perform("领取位置 / 到场侦察并取回",function(){return A.deliveryStep(id,0,true);},back));text+="\n"+this.journeyDescription(id);}
 else if(id=="C27") {text+="让空车在真实短途护送中通过路线，途中可保持阵形或稳步向前。";options.push(this.perform("保持阵形，出发试车",function(){return A.startEscort(id);},back));options.push(this.perform("稳步向前，出发试车",function(){return A.startEscort(id);},back));}
 else if(id=="C16")text+="下一份正常护送实际结清后，涂涂的邀请会准备好。";
 else {local labels={C32="做一次普通复盘（80克朗、6食物、3小时，72小时冷却）",C14="检查货车两小时",C18="回应童猪的正式邀请",C30="支付90克朗旧租金",C31="代还80克朗账款"};options.push(this.perform(labels[id],function(){return A.specialRecruit(id,0);},back));if(id=="C30" || id=="C31")options.push(this.perform(id=="C30"?"用三小时搬好货物":"用三小时找清错账",function(){return A.specialRecruit(id,1);},back));}
 return {text=text,options=options};
};
// 主线某步的可执行选项：名册页与对话共用
A.mainStep <- function(e,n,back) {
 local A=::AfeiExpedition,options=[];
 if(this.mainAvailable(n)) {
   if(n==2) {options.push(this.perform("一起复盘：6食物、3小时，磨合＋6",function(){return A.mainAction(n,0);},back));options.push(this.perform("先休息：磨合＋3",function(){return A.mainAction(n,1);},back));}
   else if(n==5 && this.w("bear_demos")>=2) {options.push(this.perform("先敲杯，再举熊",function(){return A.mainAction(n,0);},back));options.push(this.perform("先举熊，再敲杯；听完解释重新学会",function(){return A.mainAction(n,1);},back));options.push(this.perform("直接询问规则",function(){return A.mainAction(n,2);},back));}
   else if(n==6 && !this.w("key_resolved")) {options.push(this.perform("一起检查：2小时，磨合＋2",function(){return A.mainAction(n,0);},back));options.push(this.perform("请锁匠：60克朗",function(){return A.mainAction(n,1);},back));}
   else if(n==1 && this.w("journey_m01_active"))options.push(this.perform("在目的城镇交付账本",function(){return A.deliveryStep("m01",180);},back));
   else if(n==1)options.push(this.perform(this.town()==null?"先进入友好城镇，再领送账":"领取送账：邻镇，180克朗",function(){return A.startDelivery("m01",180);},back));
   else if(n==8 && this.w("journey_m08_supply_active"))options.push(this.perform("在目的城镇交付补给",function(){return A.deliveryStep("m08_supply",A.deliveryReward());},back));
   else options.push(this.perform(n==5?"观看一次示范（已看"+this.w("bear_demos")+"次）":(n==9?"在当前友好城镇承租：300克朗、12食物、6工具、6小时":"推进这件事"),function(){return A.mainAction(n,0);},back));
 }
 return options;
};
A.bookPage <- function(e,page) {
 local A=::AfeiExpedition,s={ID=page,Text="",Image="",List=[],Characters=[],Options=[],function start(e) {}
};
 local p=split(page,":"),kind=p[0];
 if(kind=="home") {
   s.Text="黑旗名册\n\n磨合 "+this.w("cohesion",25)+" / 100；已结清有报酬契约 "+this.getPaidContracts()+"。\n常备 "+this.activeCount()+" / 20；驻营 "+(this.roster().len()-this.activeCount())+" / "+(this.w("camp_enabled")?19:0)+"；每战上场最多12人。\n代理："+(this.w("selected_proxy","") in this.Characters?this.Characters[this.w("selected_proxy")].name:"尚未指定")+"。\n\n"+e.m.Notice;
   foreach(entry in [["人物、招募与成长","people:0"],["主线与委托进度","main:0"],["营地与战前准备","camp"],["经营与路线消息","business"]])s.Options.push(this.nav(entry[0],entry[1]));
   if(this.w("m08_done"))s.Options.push(this.nav("再读一次回信","letters"));
   s.Options.push(this.option("合上名册，继续上路",function(e){return 0;}));
 }
else if(kind=="people") {
    local ids=this.knownIds(),offset=p.len()>1?p[1].tointeger():0;
   local win=this.pageWindow(ids.len(),offset,4);
    s.Text="黑旗只记已经相识的人。新的名字要在路上满足线索后，到酒馆里遇见；办完对方的事，才会进入当地招募栏。";
   for(local i=0;i<win.count;i++) {local id=ids[win.offset+i],d=this.Characters[id],b=this.named(id);local status=b!=null?(this.grown(b)?"成长已完成":"在队"):(this.w("ever_"+id)?"已离队 / 纪念":(this.eligible(id)?"邀请已开放":"等待条件"));s.Options.push(this.nav(d.name+" · "+status,"person:"+id));}
   if(win.more)s.Options.push(this.nav("下一页","people:"+win.next));s.Options.push(this.nav("返回","home"));
 }
else if(kind=="person") {
   local id=p[1],d=this.Characters[id],b=this.named(id);
   s.Text=this.eventArt(id)+d.name+(("title" in d)?" · "+d.title:"")+"\n\n";
   if("blurb" in d && d.blurb!="")s.Text+=d.blurb+"\n\n";
   s.Text+="随身："+this.stripPrefix(this.stripPrefix(d.equipment_text,"初始装备："),"初始装备:")+"\n\n专属本事：";
   foreach(i,skill in d.skills) s.Text+=(i==0?"":"、")+skill.name;
   s.Text+="。\n";
    if(b!=null || this.w("ever_"+id))s.Options.push(this.nav("查看专属技能与详细规则","personskills:"+id+":0"));
    else s.Text+="\n本事还没真正见过，名册暂不下结论。";
   if(b!=null) {s.Text+="\n"+this.growthProgress(b);if(!this.grown(b) && this.growthCond(id,b) && !this.g(b,"camped") && this.safe())s.Options.push(this.perform("在营地听完这段故事",function(){return A.settleGrowth(id);},page));if(id!="C01")s.Options.push(this.perform("指定为下一场代理（须在出战阵列）",function(){return A.setProxy(id);},page));}
   else if(!this.w("ever_"+id)) {
      s.Text+="\n你们在酒馆碰过面，但这份同行约还没说定。";
      if(this.eligible(id)) {s.Options.push(this.nav("继续这次邀请","recruit:"+id));s.Options.push(this.perform("请大谋替这次引荐说两句（2小时）",function(){return A.quote(id);},page));}
   }
else s.Text+="\n此身份已经加入过，旧信保留，不再生成替身。";
   s.Options.push(this.nav("返回名册","people:0"));
 }
else if(kind=="personskills") {
   local id=p[1],d=this.Characters[id],index=p[2].tointeger(),skill=d.skills[index];
   s.Text=d.name+" · "+skill.name+"\n\n"+(("flavor" in skill)?skill.flavor+"\n\n":"")+skill.text;
   if(index>0)s.Options.push(this.nav("上一项技能","personskills:"+id+":"+(index-1)));
   if(index+1<d.skills.len())s.Options.push(this.nav("下一项技能","personskills:"+id+":"+(index+1)));
   s.Options.push(this.nav("返回人物页","person:"+id));
}
else if(kind=="recruit") {
   local id=p[1],d=this.Characters[id];s.Text=d.name+"的邀请\n\n"+e.m.Notice+"\n\n";
   local step=this.recruitStep(e,id,page);
   s.Text+=step.text;
   foreach(o in step.options)s.Options.push(o);
   s.Options.push(this.nav("暂缓并返回人物页","person:"+id));
 }
else if(kind=="main") {
   local offset=p.len()>1?p[1].tointeger():0;local win=this.pageWindow(9,offset,4);
   s.Text="队伍自己的事不会封锁自由契约与之后的招募。\n\n";
   for(local i=0;i<win.count;i++) {local n=win.offset+i+1;s.Options.push(this.nav(this.MainNames[n-1]+(this.w("m0"+n+"_done")?"（已完成）":""),"mainitem:"+n));}
   if(win.more)s.Options.push(this.nav("下一页","main:"+win.next));
   s.Options.push(this.nav("返回","home"));
 }
else if(kind=="mainitem") {
   local n=p[1].tointeger();s.Text=this.MainNames[n-1]+"\n\n"+this.mainDescription(n)+"\n\n"+e.m.Notice;
   foreach(o in this.mainStep(e,n,page))s.Options.push(o);
   if(n==8 && this.w("m08_done"))s.Options.push(this.nav("阅读回信","letters"));s.Options.push(this.nav("暂缓并返回","main:0"));
 }
else if(kind=="letters") {s.Text=this.letters();s.Options.push(this.nav("返回","home"));}
 else if(kind=="camp") {
   s.Text="营地与战前准备。普通复盘、训练与饮食均实际扣除物资和时间。驻营成员保留原人物与装备；返回营地城镇方可批量轮换。\n据点："+this.w("camp_home_name","尚未承租")+"。\n\n"+e.m.Notice;
   s.Options.push(this.perform("普通复盘：80克朗、6食物、3小时",function(){return A.review();},page));s.Options.push(this.perform("月牙绳阵训练：3食物、2小时",function(){return A.ropeTrain();},page));
   s.Options.push(this.nav("开伙、守夜与分账","campfare"));
   s.Options.push(this.option("常备 / 驻营轮换（回据点，4小时）",function(e) {
     e.m.Selected=[];e.m.PickMode="roster";e.m.PickBack="camp";
     foreach(b in A.roster()) if(!A.g(b,"camped")) e.m.Selected.push(b.getID());
     return "pick:0";
   }));
   s.Options.push(this.nav("返回","home"));
 }
else if(kind=="campfare") {
   s.Text="开伙、守夜与分账。点选名单后再确认，确认前不扣费。\n\n"+e.m.Notice;
   local fare=[["月饼准备（6食物、2小时，最多3人）","moon_cake"],["再留一晚（6食物、4小时，最多2人）","one_more_night"],["提前分好粮钱","budget"]];
   foreach(entry in fare) {
     local mode=entry[1];local label=entry[0];
     s.Options.push(this.option(label,function(e) {
       e.m.Selected=[];e.m.PickMode=mode;e.m.PickBack="campfare";return "pick:0";
     }));
   }
   s.Options.push(this.nav("返回","camp"));
 }
else if(kind=="pick") {
   local offset=p[1].tointeger(),brothers=this.roster();local win=this.pageWindow(brothers.len(),offset,3);
   local stay="pick:"+win.offset;
   s.Text="选择受益人 / 常备名单，点击可切换。确认前不扣费。\n已选 "+e.m.Selected.len()+"人；"+e.m.Notice;
   for(local i=0;i<win.count;i++) {local b=brothers[win.offset+i],id=b.getID();s.Options.push(this.option((e.m.Selected.find(id)!=null?"[已选] ":"")+b.getNameOnly(),function(e){local index=e.m.Selected.find(id);if(index==null)e.m.Selected.push(id);else e.m.Selected.remove(index);return stay;}));}
   if(win.more)s.Options.push(this.nav("下一页","pick:"+win.next));
   s.Options.push(this.option("确认名单并执行",function(e){local actors=[];foreach(b in A.roster())if(e.m.Selected.find(b.getID())!=null)actors.push(b);local ok=e.m.PickMode=="roster"?A.assignCamp(e.m.Selected):(e.m.PickMode=="budget"?A.budgetPrepare(actors):A.campAbility(e.m.PickMode,actors));e.m.Notice=ok?"名单已确认并生效。":"条件或人数不符合，未执行。";local back=("PickBack" in e.m && e.m.PickBack!="")?e.m.PickBack:"camp";return ok?back:stay;}));
   s.Options.push(this.nav("取消本次选择",("PickBack" in e.m && e.m.PickBack!="")?e.m.PickBack:"camp"));
 }
else if(kind=="business") {
   s.Text="经营与路线消息\n\n"+this.w("scout_report","还没有查明的护送路线消息。")+"\n\n超市优惠：先在这里预定，再购买商店中的一笔食物；取消不消耗次数。\n抹茶余料："+this.w("scrap_charges")+" / 3（工具实际消耗累计 "+this.w("scrap_progress")+" / 7）。\n\n"+e.m.Notice;
   s.Options.push(this.perform("月牙：预定今天一笔食物优惠",function(){if(A.named("C07",true)==null || A.w("shopping_day",-1)==A.day())return false;A.sw("shopping_armed",true);return true;},page));
   s.Options.push(this.perform("小虎：调查当前护送路线（2小时）",function(){return A.scoutPath();},page));s.Options.push(this.nav("返回","home"));
 }
 return this.seal(s);
};
A.mainDescription <- function(n) {
 local descriptions=[
 "把账本送到相邻友好城镇，180克朗，只结算一次。可以同时执行普通契约。\n"+this.journeyDescription("m01"),
 "四份有报酬契约、名册至少五人后的第一次安全复盘。选择休息也可继续故事。",
 "第20日、在队八名命名伙伴后整编。只由实际成员发言；十名黑队伙伴都曾入队后补齐旗面纪念。代理与成长记录已在各个人物页开放。",
 "第25日、八份契约后，在友好城镇启动普通强度联合护送，两名匿名蓝旗护卫同行；成功开放小宁、小虎、大鹅，并为小胖留下线索。失败七日后重接。",
 "第40日、十份契约后的营地来访。先看两次木熊与杯子的示范，再回答；所有分支都开放童猪邀请。示范：杯子先响，木熊随后举起。",
 "小杰入队三日后检查货车；处理完至少七日且再结清一份有报酬契约，才交出备用钥匙。\n已处理："+(this.w("key_resolved")?"是":"否"),
 "第75日，至少八名可出战佣兵平均达到7级，可追踪北境白影。一只冰霜巨兽，至多两只普通巨兽；可以侦察离开。奖励800克朗、磨合＋6、纪念章各一次。",
 "第90日、24份有报酬契约、累计八名伙伴、磨合曾达到60。分别送达补给与护送滞留者，中途可以整备。\n补给："+(this.w("journey_m08_supply_done")?"完成":this.journeyDescription("m08_supply"))+"\n护送："+(this.w("journey_m08_escort_done")?"完成":"待完成"),
 "第45日、14份契约后的旧驿站租约。正式建立后总名册39、常备20、驻营19；每战仍最多12人。驻营每人日薪为正常薪资35%向上取整，至少2克朗；有人驻营时另付每日30租金。驻营吃饭、治疗，不能远程获得经验、被动或成长。"
 ];return descriptions[n-1];
};

// ---------- 伙伴对话（团员主动找上门的模式） ----------
// 每屏保持短文本与少量选项，符合游戏事件对话框的尺寸。
A.TalkIntro <- [
 "抹茶把一本旧账推到桌子中间：「先把这本账送到邻镇，一百八十克朗，路上不必打仗。」",
 "一次配合失误后，营里吵了起来。阿飞还想喊，抹茶按住他：先听每个人把话说完。",
 "黑旗上已经写满八个名字。大谋把旗面抻平：「把每个人的位置定下来吧。」",
 "驿站送来一封盖着蓝旗火漆的信：他们想请黑旗同行护送一程。",
 "童猪背着木熊来到营地，把一只杯子倒扣在箱子上，也不先说话。",
 "小杰把货车的钥匙全都挂在自己腰上，走起来叮当作响。",
 "北边来的皮货商压低声音：「雪线上有道白影，赏金猎人去了就没回来。」",
 "旧营地的求助信送到了：有人没跟上队伍，缺过冬的补给。",
 "驿站的墙上贴着一张旧租约，床位的数量比这队人还多。"
];
A.talkPage <- function(e,page) {
 local A=::AfeiExpedition,s={ID=page,Text="",Image="",List=[],Characters=[],Options=[],function start(e) {}
};
 local p=split(page,":");local kind=p.len()>1?p[1]:"welcome";
 if(kind=="welcome") {
   s.Text=this.eventArt("scene_welcome")+"烟港的酒馆里，三个名字落在同一张名册上：阿飞签了团长，抹茶和大谋各写了一个副队长。\n\n旗面很大，名册只有三行。往后的每个名字，都得去路上听、去帮、再问一句要不要同行。\n\n（世界地图按 F8 随时翻开黑旗名册；伙伴的事，他们会自己来找你。）";
   s.Options.push(this.option("上路",function(e){return 0;}));
 }
 else if(kind=="main") {
   local n=p[2].tointeger();
    s.Text=this.TalkIntro[n-1]+"\n\n阿飞看了看身边的人。黑旗没有催他们立刻回答，只等一句愿不愿意把这件事一起做完。\n\n"+e.m.Notice;
   foreach(o in this.mainStep(e,n,page))s.Options.push(o);
   s.Options.push(this.option("先放着，以后再说",function(e){return 0;}));
 }
 else if(kind=="recruit") {
   local id=p[2],d=this.Characters[id];
    s.Text=this.eventArt(id)+this.talkRecruitIntro(id)+"\n\n酒馆里很吵，他把真正想说的话压得很低。\n\n"+e.m.Notice+"\n";
   local step=this.recruitStep(e,id,page);
   s.Text+=step.text;
   foreach(o in step.options)s.Options.push(o);
   s.Options.push(this.option("先记在名册上，改日再谈",function(e){return 0;}));
 }
 else if(kind=="growth") {
   local id=p[2],d=this.Characters[id],b=this.named(id);
   local portrait=b!=null?b.getImagePath():null;
   s.start=function(e) {if(portrait!=null)this.Characters.push(portrait);};
   if(b!=null && this.grown(b)) {
     s.Text=this.eventArt(id)+d.name+"把话讲完了。"+(("good_ending" in d)?this.subName(d.good_ending,d.name):"名字留在旗上。")+"\n\n"+this.growthProgress(b);
     s.Options.push(this.option("好",function(e){return 0;}));
   }
   else if(b!=null) {
     s.Text=this.eventArt(id)+d.name+"在营地找你，想把这阵子的事讲给你听。\n\n"+this.growthProgress(b);
     if(this.growthCond(id,b) && !this.g(b,"camped") && this.safe())s.Options.push(this.perform("坐下来，听完这段故事",function(){return A.settleGrowth(id);},page));
     s.Options.push(this.option("现在没空，以后再聊",function(e){return 0;}));
   }
   else {s.Text="这件事稍后再说。";s.Options.push(this.option("好",function(e){return 0;}));}
 }
 return this.seal(s);
};
A.talkRecruitIntro <- function(id) {
 local d=this.Characters[id];
 local openers={
  C04="瓶队把盾背好，站在车边等答复。",
  C05="散场后的舞台上还亮着一盏灯，李李坐在那把高背椅上等你们。",C06="余九把最后一个人送上船。她说只是顺路，手里的名册却还翻在黑旗那一页。",
  C07="月牙把摊位托给旧相识，背着满满一束投枪赶来。",C08="小鱼把盾立在栈桥外侧，替黑旗守了一下午。",
  C09="帅子抱着腰鼓，在门口来回踱步。",C10="怼怼举着传令牌，一个问题问了三遍。",
  C32="小宁摊开留着空白的队形图。",C33="小胖把粮车的绳索系紧，仍站在车尾。",C34="蔓越莓在车板上画下一条红线，等前排开口。",C12="小虎把送完的信袋重新系好，问下一程往哪边走。",
  C13="大鹅把一口贴着黑旗封条的箱子扛到营门口。",C14="小杰把车检查了两遍，钥匙挂满腰间。",
  C15="苏袜踩着还没磨热的鞋底，先一步到了岔口。",C16="涂涂把告别的路线折好，收进怀里。",
  C17="可可把两只拿反的行李换回来，笑着报上名字。",C18="童猪把木熊放在桌上，杯口朝下。",
  C19="奶盖举着盾站上台，嘴上一步不让。",C20="余想把旧岗册交还，班已经交接完。",
  C21="美伢在空场地上把两把椅子摆成出口。",C22="陈知含把一块缺角的月饼掰成三份。",
  C23="千涵把003号木牌擦亮，站在旗杆旁。",C25="玩蛇把木桩上的旧痕旁又添了一条蛇。",
  C26="芷芷把两只木箱横着摆开，让人分两列走。",C27="瑶瑶牙把长柄斧放到地图上，先问撤回的位置。",
  C28="羊咩咩的车轴旁挂着铃铛，弯道后稳稳停住。",C29="一凹瑶把木牌放回桌上，想换一种玩法。",
  C30="罗一可把巷口最碍事的桶转开，露出整条街。",C31="bula翻开公用钱袋，先问明天粮钱几何。"
 };
 local line=(id in openers)?openers[id]:("有人循着黑旗的名声找来。");
  return line+"\n\n“先别急着写名字。”"+d.name+"看了一眼黑旗，“看看你们怎么做事，再谈同行。”";
};
