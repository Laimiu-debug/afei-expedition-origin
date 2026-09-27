this.afeix_promotion_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_promotion";
        this.m.Name = "阿飞的路";
        this.m.Icon = "skills/afeix_quanqian.png";
        this.m.IsSerialized = true;
    },
    function getName() { return "阿飞的路 · " + ::AfeixExpedition.routeName(::AfeixExpedition.route()); },
    function getDescription() {
        local route = ::AfeixExpedition.route();
        if (route == "toad") return "蛤蟆人：近战命中 +8，近战与远程防御 +5，伤害提高 10%。哇哇叫强化自己，靠亲自打出缺口帮助伙伴。";
        local text = route == "jiahao" ? "嘉豪：决心 +10，以豪气冲天鼓舞伙伴。" : "飞碟：近战命中 +5，近战与远程防御 +3，决心 +5，兼顾个人作战与伙伴鼓舞。";
        return text + "\n全力圈：成功完成有战斗胜利记录的付费契约，按累计实收款取得 " + (route == "jiahao" ? "15%" : "10%") + " 额外报酬，每份契约最多 300 克朗。阿飞需活着在队；送信、出售与取消契约没有此项收入。";
    },
    function onUpdate(properties) {
        local A = ::AfeixExpedition;
        if (!A.isOrigin() || A.characterId(this.getContainer().getActor()) != "afei") return;
        local route = A.route();
        if (route == "toad") {
            properties.MeleeSkill += 8;
            properties.MeleeDefense += 5;
            properties.RangedDefense += 5;
            properties.DamageTotalMult *= 1.10;
        } else if (route == "jiahao") properties.Bravery += 10;
        else if (route == "feidie") {
            properties.MeleeSkill += 5;
            properties.MeleeDefense += 3;
            properties.RangedDefense += 3;
            properties.Bravery += 5;
        }
    }
});
