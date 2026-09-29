// Character flags persist the choice independently of story choices and combat memory.
local A = ::AfeixExpedition;
A.trainingChoice <- function(a) {
    // Native roster/skill-container actors may be WeakTableRef instances. They
    // forward getFlags/getLevel through _get; `in` cannot see those methods.
    if (a == null) return "";
    local f = a.getFlags();
    return f.has("afeix_training_choice") ? f.get("afeix_training_choice") : "";
};
A.trainingRank <- function(a, key) {
    if (!this.isOrigin() || a == null || !(key in this.MemberSkillDefs)) return 0;
    local owner = this.characterId(a);
    if (!(owner in this.MemberSkills) || this.MemberSkills[owner].find(key) == null
        || a.getLevel() < 7 || this.trainingChoice(a) != key) return 0;
    return a.getLevel() >= 11 ? 2 : 1;
};
A.trainingUpgradeText <- function(key) {
    if ("mastery" in this.MemberSkillDefs[key]) return this.MemberSkillDefs[key].mastery;
    if (key == "nicotine") return "11 级精通：立即恢复的疲劳由 15 增至 18；透支和每战一次的限制不变。";
    if (this.MemberSkillDefs[key].active) return "11 级精通：本技能的基础疲劳消耗降低 15%（向下取整，至少减少 1）；行动点、冷却和次数限制不变。";
    return "11 级精通：保留原有效果，额外使自身每回合疲劳恢复量 +1。";
};
A.trainingDescription <- function(a, key) {
    return this.MemberSkillDefs[key].text + "\n\n" + this.trainingUpgradeText(key)
        + (this.trainingRank(a, key) >= 2 ? "\n已精通。" : "\n当前为基础效果。");
};
A.trainingFatigue <- function(a, key) {
    local n = this.MemberSkillDefs[key].fatigue;
    return this.trainingRank(a, key) < 2 ? n : ::Math.max(0, n - ::Math.max(1, ::Math.floor(n * 0.15).tointeger()));
};
A.chooseTraining <- function(owner, key) {
    if (!this.canManage()) return this.result(false, "请到友好城镇附近或安全营地研习。");
    local a = this.findCharacter(owner);
    if (a == null || !a.isAlive() || a.isDying() || !(owner in this.MemberSkills)
        || this.MemberSkills[owner].find(key) == null) return this.result(false, "这位伙伴不在队中，或所选技能不属于此人。");
    if (a.getLevel() < 7) return this.result(false, "达到 7 级后才能选择专属技能。");
    if (this.trainingChoice(a) != "") return this.result(false, "已经确定了研习方向，不能再选第二项。");
    a.getFlags().set("afeix_training_choice", key);
    try { this.syncMemberSkills(a); a.getSkills().update(); }
    catch (error) { a.getFlags().set("afeix_training_choice", ""); this.syncMemberSkills(a); throw error; }
    return this.result(true, a.getName() + "学会了「" + this.MemberSkillDefs[key].name + "」。"
        + (a.getLevel() >= 11 ? "已直接达到精通。" : "达到 11 级后会自动精通。"));
};
A.trainingLedgerPage <- function(event, page) {
    local parts = split(page, ":"), kind = parts[0];
    if (["training", "train", "train_preview"].find(kind) == null) return null;
    local screen = { ID=page, Text="", Image="", List=[], Characters=[], Options=[], function start(event) {} };
    if (kind == "training") {
        local members = [];
        foreach (a in this.roster()) if (a.isAlive() && !a.isDying() && this.characterId(a) in this.MemberSkills) members.push(a);
        local w = this.ledgerWindow(members.len(), parts.len() > 1 ? this.storyPageNumber(parts[1]) : 0);
        screen.Text = "研习专属技能\n\n伙伴达到 7 级后，从自己的三个方向中选择一项；11 级自动精通所选技能。研习不消耗原版技能点，选定后不能改选。";
        for (local i=0; i<w.count; ++i) {
            local a=members[w.offset+i], choice=this.trainingChoice(a);
            local label=a.getName()+" · "+a.getLevel()+"级 · "+(choice!=""&&choice in this.MemberSkillDefs?this.MemberSkillDefs[choice].name:(a.getLevel()>=7?"待选择":"尚未到7级"));
            screen.Options.push(this.ledgerNav(label,"train:"+this.characterId(a)));
        }
        if (w.more) screen.Options.push(this.ledgerNav(w.next==0?"回到第一页":"下一页","training:"+w.next));
        screen.Options.push(this.ledgerNav("返回名册","home"));
        return screen;
    }
    local owner=parts.len()>1?parts[1]:"", a=this.findCharacter(owner);
    if (a==null || !(owner in this.MemberSkills)) {
        screen.Text="这位伙伴目前不在队中。";
    } else if (kind=="train_preview" && parts.len()>2 && this.MemberSkills[owner].find(parts[2])!=null) {
        local key=parts[2];
        screen.Text=a.getName()+" · "+this.MemberSkillDefs[key].name+"\n\n"+this.MemberSkillDefs[key].text+"\n\n"+this.trainingUpgradeText(key)+"\n\n确定后，其余两个方向不再学习。";
        screen.Options.push(this.ledgerAction("确定研习这项技能", function(){return ::AfeixExpedition.chooseTraining(owner,key);}, "train:"+owner));
        screen.Options.push(this.ledgerNav("再考虑一下","train:"+owner));
        return screen;
    } else {
        local choice=this.trainingChoice(a);
        screen.Text=a.getName()+" · 专属研习\n\n";
        if (choice!="" && choice in this.MemberSkillDefs) screen.Text+=this.MemberSkillDefs[choice].name+"\n"+this.trainingDescription(a,choice);
        else if (a.getLevel()<7) screen.Text+="先积累实战经验，达到 7 级后再决定自己的专长。";
        else {
            screen.Text+="从以下三个方向中选择一项。先查看具体效果，再确认决定。";
            foreach (key in this.MemberSkills[owner]) screen.Options.push(this.ledgerNav(("book_title" in this.MemberSkillDefs[key]?"《"+this.MemberSkillDefs[key].book_title+"》 · ":"")+this.MemberSkillDefs[key].name,"train_preview:"+owner+":"+key));
        }
    }
    screen.Options.push(this.ledgerNav("返回研习名册","training"));
    return screen;
};
