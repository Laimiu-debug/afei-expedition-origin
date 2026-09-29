this.afeix_personal_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create() {
        this.character_trait.create();
        this.m.ID = "trait.afeix_personal";
        this.m.Name = "伙伴的这一程";
        this.m.Icon = "ui/traits/trait_icon_37.png"; this.m.IconMini = this.m.Icon;
        this.m.Description = "个人成长与共同走过的路，记录在黑旗名册中。";
        this.m.Titles = [];
        this.m.Excluded = [];
    },
    function getName() {
        if (!("AfeixExpedition" in getroottable())) return this.m.Name;
        local A = ::AfeixExpedition, actor = this.getContainer() == null ? null : this.getContainer().getActor();
        if (!A.isOrigin() || actor == null) return this.m.Name;
        local key = A.characterId(actor);
        if (typeof key != "string") return this.m.Name;
        if (key in A.MemberGrowth && A.get("growth_done_" + key, false)) {
            local index = A.get("growth_choice_" + key, -1);
            if (index >= 0 && index < 2) return A.MemberGrowth[key].choices[index].traitName;
        }
        return key in A.Characters ? "同行起点 · " + A.Characters[key].name : this.m.Name;
    },
    function getDescription() {
        if (!("AfeixExpedition" in getroottable())) return this.m.Description;
        local A = ::AfeixExpedition, actor = this.getContainer() == null ? null : this.getContainer().getActor();
        if (!A.isOrigin() || actor == null) return this.m.Description;
        local key = A.characterId(actor);
        if (typeof key != "string") return this.m.Description;
        if (!(key in A.MemberGrowth)) return this.m.Description;
        if (!("growthKnown" in A) || !A.growthKnown(key)) return "还在一起上路的日子里，慢慢认识彼此。";
        local text = A.MemberGrowth[key].title + "\n" + A.growthRequirementText(key);
        if (key == "afei" && A.get("bicycle_reward_granted", false))
            text += A.get("bicycle_choice", -1) == 0 ? "\n旧车留在营边，这一程仍被记得。" : "\n旧车留在身后，下一段路继续走。";
        return text;
    },
    function getTooltip() {
        local tooltip = [
            { id = 1, type = "title", text = this.getName() },
            { id = 2, type = "description", text = this.getDescription() }
        ];
        if ("AfeixExpedition" in getroottable() && this.getContainer() != null) {
            local A = ::AfeixExpedition, actor = this.getContainer().getActor();
            tooltip.push({ id = 10, type = "text", icon = "ui/icons/bravery.png", text = A.personalBonusText(A.personalBonuses(actor)) });
        }
        return tooltip;
    },
    function onUpdate(properties) {
        if (!("AfeixExpedition" in getroottable()) || this.getContainer() == null) return;
        local A = ::AfeixExpedition;
        foreach (field, amount in A.personalBonuses(this.getContainer().getActor()))
            if (field in properties) properties[field] += amount;
    }
});
