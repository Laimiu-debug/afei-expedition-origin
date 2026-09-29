this.afeix_promotion_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_promotion";
        this.m.Name = "阿飞的路";
        this.m.Icon = "skills/afeix_quanqian.png"; this.m.IconMini = this.m.Icon;
        this.m.IsSerialized = true;
    },
    function getName() { return "阿飞的路 · " + ::AfeixExpedition.routeName(::AfeixExpedition.route()); },
    function getDescription() {
        local route = ::AfeixExpedition.route();
        if (route == "toad") return "蛤蟆人：近战命中+6，近战与远程防御+3。哇哇叫强化自己，靠亲自打出缺口帮助伙伴。";
        local text = route == "jiahao" ? "嘉豪：决心 +10，以豪气冲天鼓舞伙伴。" : "飞碟：近战命中+3，近战与远程防御+2，决心 +5，兼顾个人作战与伙伴鼓舞。";
        return text + "\n全力圈：成功完成有战斗胜利记录的付费契约，按累计实收款取得 " + (route == "jiahao" ? "8%" : "5%") + " 额外报酬，嘉豪每份最多120、每7日360；飞碟每份最多80、每7日240克朗。阿飞需活着在队；送信、出售与取消契约没有此项收入。";
    },
    function onUpdate(properties) {
        local A = ::AfeixExpedition;
        if (!A.isOrigin() || A.characterId(this.getContainer().getActor()) != "afei") return;
        local route = A.route();
        // Permanent route attributes do not consume the temporary hit budget.
        if (route in A.BalanceV26.routes)
            foreach (i, value in A.BalanceV26.routes[route].growth)
                properties[A.BalanceFields[i]] += value;
    }
});
