local A = ::AfeixExpedition;
A.PromotionActivePaths <- {
    toad = "scripts/skills/actives/afeix_wawa",
    jiahao = "scripts/skills/actives/afeix_haoqi",
    feidie = "scripts/skills/actives/afeix_feidie"
};
A.PromotionActiveIDs <- { toad = "actives.afeix_wawa", jiahao = "actives.afeix_haoqi", feidie = "actives.afeix_feidie" };
A.PromotionSkillIDs <- ["actives.afeix_wawa", "actives.afeix_haoqi", "actives.afeix_feidie", "trait.afeix_promotion"];

A.route <- function() {
    local value = this.get("afei_route", "normal");
    return value == "toad" || value == "jiahao" || value == "feidie" ? value : "normal";
};
A.routeName <- function(value) {
    local names = { normal = "正常形态", toad = "蛤蟆人", jiahao = "嘉豪", feidie = "飞碟" };
    return value in names ? names[value] : "未知路线";
};
A.circleRate <- function() {
    local value = this.route();
    return value == "jiahao" ? 0.15 : (value == "feidie" ? 0.10 : 0.0);
};
A.promotionBattles <- function(bro) { return bro.getLifetimeStats().Battles; };
A.promotionCost <- function(target) {
    if (target == "feidie" && !this.get("promotion_seen_feidie", false)) return 0;
    return this.route() == "normal" ? 0 : 1500;
};
A.promotionCheck <- function(target) {
    if (!this.isOrigin()) return this.result(false, "这份成长记录属于阿飞远征团。");
    if (target != "toad" && target != "jiahao" && target != "feidie") return this.result(false, "请选择蛤蟆人、嘉豪或飞碟路线。");
    local bro = this.findCharacter("afei");
    if (bro == null || !bro.isAlive()) return this.result(false, "阿飞不在队伍中，无法办理转职。");
    if (target == this.route()) return this.result(false, "阿飞已经走在这条路上。");
    if (target == "feidie" && !this.rootsUnlocked()) return this.result(false, "六根的开篇尚未全部触发，飞碟路线仍未开放。");
    local cost = this.promotionCost(target);
    if (cost > 0) {
        if (bro.getLevel() < 9 || this.progressCount() < 12)
            return this.result(false, "重修需要阿飞达到 9 级，并累计完成 12 份履约。");
    } else if (target != "feidie") {
        if (bro.getLevel() < 5 || this.promotionBattles(bro) < 3 || !this.get("growth_done_afei", false))
            return this.result(false, "首次转职需要阿飞达到 5 级、亲自参加 3 场战斗，并完成自己的成长选择。");
    }
    if (::World.Assets.getMoney() < cost) return this.result(false, "重修需要 " + cost + " 克朗，目前资金不足。");
    return this.result(true, cost == 0 ? "本次转职免费。" : "本次重修花费 " + cost + " 克朗。");
};
A.syncPromotion <- function(bro, prepared = null) {
    if (!this.isOrigin() || bro == null || this.characterId(bro) != "afei") return;
    local skills = bro.getSkills(), route = this.route();
    foreach (key, id in this.PromotionActiveIDs) {
        if (key != route) skills.removeAllByID(id);
        else if (!skills.hasSkill(id)) skills.add(prepared != null && id in prepared ? prepared[id] : ::new(this.PromotionActivePaths[key]));
    }
    if (route == "normal") skills.removeAllByID("trait.afeix_promotion");
    else if (!skills.hasSkill("trait.afeix_promotion")) skills.add(prepared != null && "trait.afeix_promotion" in prepared ? prepared["trait.afeix_promotion"] : ::new("scripts/skills/traits/afeix_promotion_trait"));
    // Keep the retained active instance: its serialized per-battle use must survive loading.
    skills.update();
    if ("syncCharacterArt" in this) this.syncCharacterArt(bro);
    if (route != "normal" && "applyTalentProfile" in this) this.applyTalentProfile(bro, this.PromotionTalents);
};
A.promote <- function(target) {
    if (!this.canManage() || this.currentTown() == null) return this.result(false, "请到安全的友好城镇附近办理转职或重修。");
    local check = this.promotionCheck(target);
    if (!check.ok) return check;
    local bro = this.findCharacter("afei"), previous = this.route(), cost = this.promotionCost(target);
    local previousBody = this.get("feidie_base_route", "normal"), previousSeen = this.get("promotion_seen_feidie", false);
    local skills = bro.getSkills(), previousSkills = [], prepared = {};
    local previousTalents = "captureTalentState" in this ? this.captureTalentState(bro) : null;
    foreach (id in this.PromotionSkillIDs) {
        local skill = skills.getSkillByID(id);
        if (skill != null) previousSkills.push(skill);
    }
    // Construct before changing the route. Reuse the old instances if a later
    // add/update/appearance failure occurs, including their combat-use records.
    try {
        local id = this.PromotionActiveIDs[target];
        if (!skills.hasSkill(id)) prepared[id] <- ::new(this.PromotionActivePaths[target]);
        if (!skills.hasSkill("trait.afeix_promotion")) prepared["trait.afeix_promotion"] <- ::new("scripts/skills/traits/afeix_promotion_trait");
    } catch (error) {
        ::logError("[AfeixExpedition] Promotion construction failed: " + error);
        return this.result(false, "转职能力暂时无法载入，原路线与克朗均已保留。");
    }
    try {
        if (target == "feidie") {
            this.set("feidie_base_route", previous);
            this.set("promotion_seen_feidie", true);
        }
        this.set("afei_route", target);
        this.syncPromotion(bro, prepared);
    } catch (error) {
        this.set("afei_route", previous);
        this.set("feidie_base_route", previousBody);
        this.set("promotion_seen_feidie", previousSeen);
        if (previousTalents != null) this.restoreTalentState(bro, previousTalents);
        foreach (id in this.PromotionSkillIDs) skills.removeAllByID(id);
        foreach (skill in previousSkills) {
            skill.m.IsGarbage = false;
            skills.add(skill);
        }
        skills.update();
        try { if ("syncCharacterArt" in this) this.syncCharacterArt(bro); } catch (artError) {}
        ::logError("[AfeixExpedition] Promotion rolled back: " + error);
        return this.result(false, "转职未能完成，原路线与克朗均已保留。");
    }
    if (cost > 0) ::World.Assets.addMoney(-cost);
    this.refreshAssets();
    return this.result(true, "阿飞选择了" + this.routeName(target) + "路线。" + (cost > 0 ? "重修花费 " + cost + " 克朗。" : "本次转职免费。") + "近战命中、近战防御与决心各为三星。已有加点、等级、装备与伤势继续保留。");
};

// Only the player's own living characters are eligible; allied auxiliaries,
// neutral actors, enemies, pets, and charmed player actors receive no benefit.
A.promotionUser <- function(actor, expectedRoute) {
    return this.isOrigin() && ::Tactical.isActive() && actor != null && actor.isAlive()
        && actor.isPlacedOnMap()
        && actor.getFaction() == ::Const.Faction.Player && actor.isPlayerControlled()
        && this.characterId(actor) == "afei" && this.route() == expectedRoute;
};
A.promotionTargets <- function(user, radius) {
    local result = [];
    foreach (actor in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) {
        if (actor == null || !actor.isAlive() || !actor.isPlacedOnMap() || !actor.isPlayerControlled()
            || actor.getFaction() != ::Const.Faction.Player) continue;
        if (user.getTile().getDistanceTo(actor.getTile()) <= radius) result.push(actor);
    }
    return result;
};
A.promotionEffect <- function(actor, path, id) {
    if (!actor.getSkills().hasSkill(id)) actor.getSkills().add(::new(path));
};
