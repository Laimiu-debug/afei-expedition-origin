local A=::AfeiExpedition;
// The same road notes decide growth and tell the player what is still missing.
// n=1 with no unit is a one-time deed; alternatives need only one path.
A.GrowthRoads <- {
 C01=[{key="_level",n=7,text="本事磨到第七级"},{key="win_count",n=8,unit="场",text="亲自打赢的仗"},{key="_jiahao",n=6,unit="人",text="见证成长的伙伴"}],
 C02=[{key="sign_witness",n=3,unit="人",text="亲眼签下的伙伴"},{key="contracts",n=4,unit="份",text="在队结清的契约"},{key="reviews",n=2,unit="次",text="营地复盘"}],
 C03=[{key="win_count",n=5,unit="场",text="亲自打赢的仗"},{either=[{key="steal_hire",n=3,unit="人",text="替黑旗谈成的伙伴"},{key="growth_witness",n=6,unit="人",text="见证成长的伙伴"}]}],
 C04=[{key="ball_wins",n=5,unit="场",text="接上队友先手的胜仗"},{key="ball_partners",n=3,unit="人",text="接过先手的不同伙伴"}],
 C05=[{key="win_count",n=6,unit="场",text="亲自打赢的仗"},{key="spotlight_wins",n=3,unit="场",text="聚光叠到两层的胜仗"}],
 C06=[{key="swap_win_partners",n=3,unit="人",text="换位护住的不同伙伴"}],
 C07=[{key="rope_train",n=2,unit="次",text="相隔三日的绳阵训练"},{key="biantai_wins_after_training",n=3,unit="场",text="训后使出变态的胜仗"}],
 C08=[{either=[{key="cover_wins",n=5,unit="场",text="顶上去实际拦截的胜仗"},{key="win_count",n=10,unit="场",text="亲自打赢的仗"}]}],
 C09=[{key="drum_gate_wins",n=5,unit="场",text="打鼓或守门的胜仗"},{key="drum_two_wins",n=2,unit="场",text="让两名伙伴听鼓恢复的胜仗"}],
 C10=[{key="afei_order_wins",n=4,unit="场",text="接到阿飞号令的胜仗"},{key="relay_wins",n=2,unit="场",text="真正传过令的胜仗"},{key="afei_rest_proxy_wins",n=1,unit="场",text="阿飞休整时代理打赢的仗"}],
 C12=[{either=[{key="escort_contracts",n=3,unit="份",text="在队完成的护送"},{key="_other_contracts",n=6,unit="份",text="在队完成的其他契约"}]},{key="withdraw_wins",n=2,unit="场",text="伙伴用撤步脱身的胜仗"}],
 C13=[{key="goose_wins",n=5,unit="场",text="鹅势欺人起效的胜仗"},{key="goose_charge_wins",n=3,unit="场",text="用过嘎嘎冲的胜仗"}],
 C14=[{key="_m06",n=1,text="备用钥匙那件事了结"},{either=[{key="net_wins_after_key",n=3,unit="场",text="钥匙交出后解网的胜仗"},{key="wins_after_key",n=8,unit="场",text="钥匙交出后的胜仗"}]}],
 C15=[{either=[{key="escort_contracts",n=2,unit="份",text="在队完成的护送"},{key="_other_contracts",n=4,unit="份",text="在队完成的其他契约"}]},{key="halfstep_wins",n=5,unit="场",text="抢半步起效的胜仗"}],
 C16=[{either=[{key="escort_contracts",n=3,unit="份",text="在队完成的护送"},{key="_other_contracts",n=6,unit="份",text="在队完成的其他契约"}]},{key="return_win_partners",n=2,unit="人",text="胜仗中一起走回头路的不同伙伴"}],
 C17=[{key="win_count",n=6,unit="场",text="亲自打赢的仗"},{key="pokemon_attacked_partners",n=3,unit="人",text="守望时受敌人攻击的不同伙伴"}],
 C18=[{key="understand_wins",n=3,unit="场",text="看懂攒到两层的胜仗"},{key="bear_used",n=1,text="在战场上用过小熊出击"},{key="cup_used",n=1,text="在战场上用过敲杯为号"}],
 C19=[{key="taunt_wins",n=3,unit="场",text="挑衅引来敌人出手的胜仗"},{key="taunt_comeback_wins",n=2,unit="场",text="接着投掷返场的胜仗"}],
 C20=[{key="long_wins",n=6,unit="场",text="熬过四轮的胜仗"}],
 C21=[{key="dance_recipients",n=8,unit="人次",text="真正跟上大王舞的伙伴"},{key="curtain_wins",n=3,unit="场",text="谢幕让位的胜仗"}],
 C22=[{key="moon_cake",n=4,unit="次",text="月饼准备"},{key="win_count",n=6,unit="场",text="亲自打赢的仗"}],
 C23=[{key="sprint_wins",n=6,unit="场",text="用短坡冲刺的胜仗"}],
 C25=[{key="qin_wins",n=6,unit="场",text="触发秦国的神的胜仗"}],
 C26=[{key="win_count",n=6,unit="场",text="亲自打赢的仗"},{key="curtain_leave_wins",n=3,unit="场",text="撑幕布时送走伙伴的胜仗"}],
 C27=[{key="win_count",n=6,unit="场",text="亲自打赢的仗"},{key="look_flag",n=6,unit="次",text="行动后回看旗子"}],
 C28=[{key="bell_wins",n=6,unit="场",text="铃铛带路起效的胜仗"}],
 C29=[{key="baton_attacks",n=8,unit="次",text="接棒伙伴真正出手"},{key="win_count",n=6,unit="场",text="亲自打赢的仗"}],
 C30=[{key="door_success",n=8,unit="次",text="门前卡位成功推动"},{key="win_count",n=6,unit="场",text="亲自打赢的仗"}],
 C31=[{key="contracts",n=8,unit="份",text="在队结清的契约"}],
 C32=[{key="proxy_wins",n=3,unit="场",text="担任代理打赢的仗"},{key="proxy_steady_wins",n=2,unit="场",text="代理时用稳一手的胜仗"},{key="reviews",n=2,unit="次",text="营地复盘"}],
 C33=[{key="win_count",n=5,unit="场",text="亲自打赢的仗"},{key="pang_guard_wins",n=3,unit="场",text="举盾护住受攻击伙伴的胜仗"}],
 C34=[{key="win_count",n=5,unit="场",text="亲自打赢的仗"},{key="berry_follow_wins",n=3,unit="场",text="伙伴跟射红线记号的胜仗"}]
};
A.growthValue <- function(b,key) {
    if(key=="_level")return b.getLevel();
    if(key=="_jiahao")return this.getJiahaoCount();
    if(key=="_other_contracts")return ::Math.max(0,this.g(b,"contracts")-this.g(b,"escort_contracts"));
    if(key=="_m06")return this.w("m06_done")?1:0;
    local v=this.g(b,key);return v==true?1:(v==false?0:v);
};
A.growthStepDone <- function(b,step) {
    if("either" in step) {foreach(path in step.either)if(this.growthStepDone(b,path))return true;return false;}
    return this.growthValue(b,step.key)>=step.n;
};
A.growthCond <- function(id,b) {
    if(!(id in this.GrowthRoads) || b.getLevel()<(id=="C01"?7:5))return false;
    foreach(step in this.GrowthRoads[id])if(!this.growthStepDone(b,step))return false;
    return true;
};
A.growthStepText <- function(b,step) {
    if("either" in step) {
        local roads=[];foreach(path in step.either)roads.push(this.growthStepText(b,path));
        return "两条路走通一条便够："+roads[0]+"；或"+roads[1];
    }
    local left=step.n-this.growthValue(b,step.key);
    if(left<=0)return "";
    if(!( "unit" in step))return "还没有"+step.text;
    return step.text+"还差"+left+step.unit;
};
A.growthProgress <- function(b) {
    local id=this.cid(b),d=this.Characters[id],raw=d.growth_text,colon=raw.find("："),title=colon==null?"这段路":raw.slice(4,colon);
    if(this.grown(b))return "黑旗边注·"+title+"\n这段路已经走完，名字留在旗上。";
    local notes=[];
    if(id!="C01" && b.getLevel()<5)notes.push("本事还要磨到第五级");
    foreach(step in this.GrowthRoads[id])if(!this.growthStepDone(b,step))notes.push(this.growthStepText(b,step));
    local line="黑旗边注·"+title+"\n";
    if(notes.len()==0)line+="该走的路都走过了。找个安全地方，让"+d.name+"把话讲完。";
    else {line+="还欠下这些经历：";foreach(i,n in notes)line+=(i==0?"":"；")+n;line+="。";}
    if(this.g(b,"camped"))line+="\n此人还在驻营，回访要等归队。";
    return line;
};
A.settleGrowth <- function(id) {
    local b=this.named(id);if(b==null || this.w("growth_done_"+id) || !this.growthCond(id,b) || !this.safe() || this.g(b,"camped"))return false;
    if(id=="C18")this.spendHours(2);
    this.sw("growth_done_"+id,true);
    if(id=="C01")b.getBaseProperties().Hitpoints+=8;
    if(id=="C19")b.getBaseProperties().Bravery+=8;
    this.bumpCohesion(3);
    foreach(other in this.roster()) if(other.getID()!=b.getID() && !this.g(other,"camped")) this.unique(other,"growth_witness",id);
    local captain=this.named("C01");
    if(id!="C01" && captain!=null && !this.w("jiahao_seen_"+id) && this.getJiahaoCount()<16 && !this.w("captain_dead")) {
        this.sw("jiahao_seen_"+id,true);this.inc("jiahao_count");captain.getBaseProperties().Bravery+=4;captain.getBaseProperties().Stamina+=2;captain.getSkills().update();
    }
    b.getSkills().update();this.tryAwakenAfei();return true;
};
A.tryAwakenAfei <- function() {local b=this.named("C01");if(b==null || this.w("awakened") || b.getLevel()<11 || this.getJiahaoCount()<16 || !this.w("m08_done"))return false;this.sw("awakened",true);this.installSkills(b,"C01");return true;};
A.settleBattle <- function(victory,realBattle) {
    if(this.w("battle_settled")==this.battleKey() || !this.w("battle_running"))return;
    this.sw("battle_settled",this.battleKey());this.sw("battle_running",false);
    local dead=this.w("battle_deaths");
    if(realBattle) { if(victory) {this.bumpCohesion(3+(dead==0?1:0),true);if(dead)this.bumpCohesion(-::Math.min(20,dead*10));}
        else this.bumpCohesion(-::Math.min(20,5+dead*10)); }
    foreach(b in this.roster()) {
        if(!victory || !realBattle || !this.battleG(b,"deployed") || this.g(b,"camped") || !b.isAlive() || this.battleG(b,"died"))continue;
        this.bump(b,"win_count");
        if(this.w("m06_done") && this.battleG(b,"key_ready"))this.bump(b,"wins_after_key");
        local keys={ball="ball_wins",biantai="biantai_wins",cover="cover_wins",drum_gate="drum_gate_wins",afei_order="afei_order_wins",relay="relay_wins",withdraw="withdraw_wins",goose="goose_wins",halfstep="halfstep_wins",taunt="taunt_wins",curtain="curtain_wins",sprint="sprint_wins",qin="qin_wins",curtain_leave="curtain_leave_wins",bell="bell_wins",pang_guard="pang_guard_wins",berry_follow="berry_follow_wins"};
        foreach(k,counter in keys)if(this.battleG(b,k))this.bump(b,counter);
        if(this.battleG(b,"biantai") && this.battleG(b,"rope_ready"))this.bump(b,"biantai_wins_after_training");
        if(this.battleG(b,"spotlight_peak")>=2)this.bump(b,"spotlight_wins");
        if(this.battleG(b,"understand_peak")>=2)this.bump(b,"understand_wins");
        if(this.battleG(b,"drum_recipients")>=2)this.bump(b,"drum_two_wins");
        if(this.battleG(b,"net_freed") && this.battleG(b,"key_ready"))this.bump(b,"net_wins_after_key");
        if(this.battleG(b,"taunt") && this.battleG(b,"comeback_throw"))this.bump(b,"taunt_comeback_wins");
        if(this.battleG(b,"goose") && this.battleG(b,"charge"))this.bump(b,"goose_charge_wins");
        if(this.battleG(b,"turns")>=4)this.bump(b,"long_wins");
        foreach(k in ["swap","return"]) { local tid=this.battleG(b,k+"_partner"); if(tid)this.unique(b,k+"_win_partners",tid); }
        if(this.id(b)==this.w("battle_proxy")) {this.bump(b,"proxy_wins");if(this.battleG(b,"steady"))this.bump(b,"proxy_steady_wins");if(this.w("battle_afei_rest"))this.bump(b,"afei_rest_proxy_wins");}
    }
    if(victory && this.w("m07_target_killed") && !this.w("m07_done")) { this.sw("m07_done",true);::World.Assets.addMoney(800);this.bumpCohesion(6);this.sw("m07_medal",true);local stash=::World.Assets.getStash();if(stash.getNumberOfEmptySlots()==0)stash.resize(stash.getCapacity()+1);stash.add(::new("scripts/items/misc/afei_frost_medal_item")); }
};
