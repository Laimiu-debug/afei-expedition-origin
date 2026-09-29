// Character definitions live in characters.nut; these functions preserve saved identities.
local A = ::AfeixExpedition;
A.characterId <- function(_bro)
{
    if (_bro == null || !_bro.getFlags().has("afeix_character")) return "";
    local key = _bro.getFlags().get("afeix_character");
    return typeof key == "string" && (key in this.Characters || key in this.RetiredCharacters) ? key : "";
};

A.findCharacter <- function(_key)
{
    if (!(_key in this.Characters) && !(_key in this.RetiredCharacters)) return null;
    foreach (bro in this.roster()) if (this.characterId(bro) == _key) return bro;
    return null;
};

A.characterStatus <- function(_key)
{
    if (!(_key in this.Characters)) return "locked";
    if (this.findCharacter(_key) != null) return "recruited";
    if (this.get("dead_" + _key, false)) return "dead";
    if (this.get("departed_" + _key, false) || this.get("ever_" + _key, false)) return "departed";
    if (this.get("native_recruit_" + _key, false))
        return "recruitOfferSlot" in this && this.recruitOfferSlot(_key) >= 0 ? "available" : "waiting";
    if (this.isRecruitUnlocked(_key)) return "available";
    return !this.Characters[_key].isCaptain && this.isCharacterKnown(_key) ? "encounter" : "locked";
};

// Vanilla serializes the wage multiplier, but recreates base wages and prose
// from the original background. Restore only those definitions after world load.
A.restoreCharacterMetadata <- function(_bro)
{
    if (!this.isOrigin()) return;
    local key = this.characterId(_bro);
    if (key == "") return;
    local data = key in this.Characters ? this.Characters[key] : this.RetiredCharacters[key];
    // Keep the saved slot/skill/portrait keys when correcting the blue-team roster.
    // Only replace the old default name; player-chosen names remain intact.
    if (key == "xiaohani" && "getName" in _bro && _bro.getName() == "小哈尼")
        _bro.setName(data.name);
    if (key == "yanzi" && "getName" in _bro && _bro.getName() == "眼子")
        _bro.setName(data.name);
    local background = _bro.getBackground();
    if ("syncCharacterBackground" in this && key in this.Characters) this.syncCharacterBackground(_bro);
    else {
        background.m.DailyCost = data.wage;
        background.m.RawDescription = data.description;
        background.buildDescription(true);
    }
    local rebalanced = false;
    // Subtract only the old starting advantage once; retain all earned level-ups.
    if (key == "damou" && !_bro.getFlags().has("afeix_damou_balance_v17") && !_bro.getFlags().has("afeix_balance_v18")) {
        local fields=["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
        local old=[62,106,49,105,66,37,10,5], p=_bro.getBaseProperties();
        foreach(i,field in fields) p[field] += this.CharacterBasesV17.damou[i]-old[i];
        _bro.getFlags().set("afeix_damou_balance_v17",true);
        rebalanced = true;
    }
    // Apply only the change in starting values, including town candidates. Earned
    // upgrades, story bonuses and promotion bonuses stay on the existing actor.
    if (key in this.Characters && !_bro.getFlags().has("afeix_balance_v18")) {
        local fields=["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
        // Reactivated members absent from v0.17 retain their saved attributes.
        if (key in this.CharacterBasesV17) {
            local old=this.CharacterBasesV17[key], p=_bro.getBaseProperties();
            foreach(i,field in fields) p[field] += ("BalanceV26" in this && key in this.BalanceV26.people ? this.BalanceV26.people[key].old_attrs[i] : data.attrs[i])-old[i];
            rebalanced = true;
        }
        _bro.getFlags().set("afeix_balance_v18",true);
    }
    if("BalanceV26" in this && key in this.BalanceV26.people && !_bro.getFlags().has("afeix_balance_v26"))rebalanced=true;
    if ("syncCharacterFeatures" in this) this.syncCharacterFeatures(_bro);
    // Existing offers keep their legacy quote throughout their remaining lifetime.
    local flags=_bro.getFlags();
    if("BalanceV26" in this && key in this.BalanceV26.people && flags.has("afeix_candidate") && flags.get("afeix_candidate") && !flags.has("afeix_v26_quote")) {
        local oldPrice=::Math.max(0,this.BalanceV26.people[key].old_hire_cost-this.get("hire_discount_"+key,0));
        flags.set("afeix_v26_quote",oldPrice-this.catalogRecruitDiscount(oldPrice));
        _bro.m.HiringCost<-flags.get("afeix_v26_quote");
    }
    if(flags.has("afeix_candidate")&&flags.get("afeix_candidate")&&flags.has("afeix_v26_quote"))
        _bro.m.HiringCost<-flags.has("afeix_v26_new_offer")?this.recruitPrice(key):flags.get("afeix_v26_quote");
    _bro.getSkills().update();
    // Clamp only excess current health, after native traits/perks rebuild the real cap.
    if (rebalanced && "getHitpoints" in _bro && _bro.getHitpoints()>_bro.getHitpointsMax())
        _bro.setHitpoints(_bro.getHitpointsMax());
};

A.makeCharacter <- function(_key, _place = 255, _hireRoster = null)
{
    if (!this.isOrigin() || !(_key in this.Characters)) return null;
    local existing = this.findCharacter(_key);
    if (existing != null) return existing;
    // Losing a named character never creates a new copy of the same person.
    if (this.get("ever_" + _key, false) || this.get("dead_" + _key, false) || this.get("departed_" + _key, false)) return null;
    if (_hireRoster == null && this.roster().len() >= this.RosterMax) return null;
    local data = this.Characters[_key];
    local roster = _hireRoster == null ? ::World.getPlayerRoster() : _hireRoster;
    local bro = null;
    try
    {
        bro = roster.create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["characterBackgroundPath" in this ? this.characterBackgroundPath(_key) : data.background], false);
        bro.getItems().clear();
        bro.setName(data.name);
        bro.setTitle(data.title);
        bro.getFlags().set("afeix_character", _key);
        bro.getFlags().set("afeix_schema", this.Schema);
        bro.getBackground().m.RawDescription = data.description;
        bro.getBackground().buildDescription(true);
        bro.getBackground().m.DailyCost = data.wage;
        bro.getBackground().m.DailyCostMult = 1.0;
        if ("syncCharacterBackground" in this) this.syncCharacterBackground(bro);
        local properties = bro.getBaseProperties();
        local fields = ["Hitpoints", "Stamina", "Bravery", "Initiative", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense"];
        foreach (index, field in fields) properties[field] = data.attrs[index];
        local talents = bro.getTalents();
        talents.resize(::Const.Attributes.COUNT, 0);
        foreach (index, value in talents) talents[index] = 0;
        // Base properties use Stamina; the level-up/talent enum calls it Fatigue.
        foreach (field, stars in data.stars) talents[::Const.Attributes[field == "Stamina" ? "Fatigue" : field]] = stars;
        bro.m.Level = 1;
        bro.m.XP = ::Const.LevelXP[0];
        bro.m.LevelUps = 0;
        // Native backgrounds may roll level 2 before our explicit level-1 setup.
        bro.m.PerkPoints = 0;
        bro.m.PerkPointsSpent = 0;
        if (_key == "damou") bro.getFlags().set("afeix_damou_balance_v17",true);
        bro.getFlags().set("afeix_balance_v18",true);
        if ("balanceTraits" in this) this.balanceTraits(bro,true);
        if ("balanceCatchup" in this) this.balanceCatchup(bro,_key);
        bro.m.HireTime = ::Time.getVirtualTimeF();
        bro.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
        foreach (path in data.equipment) bro.getItems().equip(::new("scripts/items/" + path));
        foreach (path in data.bag) bro.getItems().addToBag(::new("scripts/items/" + path));
        if ("syncCharacterFeatures" in this) this.syncCharacterFeatures(bro);
        bro.getSkills().update();
        bro.setHitpoints(bro.getHitpointsMax());
        bro.setPlaceInFormation(_place);
        if (_hireRoster == null) {
            if ("enforceFormation" in this) this.enforceFormation();
            else ::World.Assets.updateFormation();
        } else {
            bro.getFlags().set("afeix_candidate", true);
            bro.m.HiringCost <- this.recruitPrice(_key);
            bro.getFlags().set("afeix_v26_quote",bro.m.HiringCost);
            bro.getFlags().set("afeix_v26_new_offer",true);
        }
    }
    catch (error)
    {
        // An incomplete creation must not consume money or leave a duplicate.
        if (bro != null) roster.remove(bro);
        throw error;
    }
    if (_hireRoster == null) this.set("ever_" + _key, true);
    return bro;
};

A.recruit <- function(_key)
{
    if (!this.isOrigin() || !(_key in this.Characters)) return this.result(false, "这不是当前起源可招募的人物。");
    if (this.get("native_recruit_" + _key, false)) return this.result(false, "请在城镇招募界面雇佣这位伙伴。");
    if (!this.isAtTavern()) return this.result(false, "请到酒馆与对方当面谈谈。");
    local town = this.currentTown();
    if (town == null || !town.isAlliedWithPlayer()) return this.result(false, "请先到友好城镇再办理招募。");
    local state = this.characterStatus(_key);
    if (state == "recruited") return this.result(false, "这位队员已经在队伍中，不能重复雇用。");
    if (state == "dead") return this.result(false, "这位队员已经阵亡，不能再次招募。");
    if (state == "departed") return this.result(false, "这位队员已经离队，这个试玩流程不会重新生成她或他。");
    if (state != "available" || this.Characters[_key].isCaptain) return this.result(false, this.recruitHint(_key));
    if (this.roster().len() >= this.RosterMax) return this.result(false, "名册已满（" + this.RosterMax + " 人）。没有扣款，请先腾出位置。");
    local data = this.Characters[_key];
    local price = this.recruitPrice(_key);
    if (::World.Assets.getMoney() < price) return this.result(false, "需要 " + price + " 克朗招募费；当前资金不足，没有扣款。");
    local bro = null;
    try { bro = this.makeCharacter(_key); }
    catch (error)
    {
        ::logError("[AfeixExpedition] Recruit " + _key + " failed: " + error);
        return this.result(false, "人物创建未完成，没有扣款。请查看游戏日志。");
    }
    if (bro == null) return this.result(false, "当前无法创建这位队员，没有扣款。");
    ::World.Assets.addMoney(-price);
    if ("enforceFormation" in this) this.enforceFormation();
    this.refreshAssets();
    return this.result(true, data.name + "加入远征团，支付 " + price + " 克朗。可在编队页安排上场或待命。");
};
