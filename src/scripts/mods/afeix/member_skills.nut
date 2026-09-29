// First migration batch. All combat state belongs to skills, never campaign flags.
local A = ::AfeixExpedition;
A.MemberSkills <- {
    bottle = ["bottle_breakthrough", "finals_moment"],
    yuchujiu = ["dog_bark", "loyalty"],
    xiaoyubeike = ["nicotine", "only_man"],
    yaoyaoya = ["breach_strike", "lvbu_weapon"],
    damou = ["borrow_strike", "together_lift"],
    laocai = ["steady_hand", "blue_form"],
    dae = ["guard_nest", "goose_bully"],
    keke = ["pokemon", "breathe_easy"],
    xiaogui = ["turtle_shell", "turtle_bond"]
};
A.MemberSkillDefs <- {
    bottle_breakthrough = { name="瓶队突破", active=true, ap=4, fatigue=18, cd=2, range=1, target="weapon", shield=false,
        text="以单手近战武器的普通单体招式攻击，命中 +10；攻击后近战防御 -5，直到自己下次回合开始。命中或落空都会进入冷却。" },
    finals_moment = { name="决赛时刻", active=false,
        text="从第 5 轮起，近战武器攻击伤害 +10%，每次近战武器技能额外消耗 3 疲劳。" },
    dog_bark = { name="狗叫", active=true, ap=3, fatigue=12, cd=2, range=3, target="enemy", shield=false,
        text="干扰 3 格内可见的人类或绿皮，使其近战命中 -8，直到目标下次回合结束。不影响亡灵、野兽及免疫恐惧的敌人。同名效果不叠加。" },
    loyalty = { name="忠诚", active=false,
        text="与可行动的阿飞相距不超过 2 格时，决心 +10。阿飞未出战或失去行动能力时，依次由王大谋、午夜抹抹茶代任。" },
    nicotine = { name="尼古丁", active=true, ap=2, fatigue=0, cd=0, range=0, target="self", shield=false,
        text="每战一次，立即消除 15 点累积疲劳；随后两次自己回合开始时，疲劳恢复量各减少 5。疲劳为零时不能使用。此技能不回复生命。" },
    only_man = { name="唯一的男人", active=false,
        text="与至少一名可行动、未持盾的己方队员相邻时，被攻击时近战防御 +6。不随队员数量叠加。" },
    breach_strike = { name="破口一击", active=true, ap=6, fatigue=24, cd=2, range=1, target="weapon", shield=false,
        text="以双手近战武器的普通单体招式攻击，命中 -5、护甲伤害 +20%。沿用武器自身射程和特殊伤害。当前版本不附带击退。" },
    lvbu_weapon = { name="奶团吕布", active=false,
        text="使用双手近战武器时，近战武器攻击的护甲伤害 +10%。包括双手斧、剑、锤和长柄；不赋予额外射程。" },
    borrow_strike = { name="大哥借我", active=true, ap=3, fatigue=12, cd=3, range=1, target="ally", shield=true,
        text="持盾与一名相邻队员互相掩护：双方近战防御各 +5，分别持续至自己下次回合开始。护卫类临时近防只取最高值。" },
    together_lift = { name="一起抬", active=false,
        text="持盾且 2 格内有至少两名其他可行动队员时，决心 +8，近战武器攻击的护甲伤害 +10%。" },
    steady_hand = { name="稳一手", active=true, ap=4, fatigue=18, cd=3, range=0, target="self", shield=true,
        text="持盾鼓励自己与当前相邻的可行动队员：近战防御 +6、决心 +6，分别持续至受益者下次回合开始。护卫类临时加成只取最高值。" },
    blue_form = { name="蓝旗布阵", active=false,
        text="第一轮开始时，自己与当时相邻的可行动队员先攻 +12，仅持续第一轮，不影响后续援军。重复布阵不叠加。" },
    guard_nest = { name="守窝", active=true, ap=3, fatigue=15, cd=2, range=0, target="self", shield=true,
        text="持盾守住原位，自己与使用时相邻的队员远程防御 +6，直到大鹅下次回合开始。离开原位、失去盾牌或行动能力时失效；队友离开相邻位置时不受益。" },
    goose_bully = { name="鹅势欺人", active=false,
        text="至少与一名敌人相邻，且相邻的其他可行动队员数不少于相邻敌人数时，决心 +5、近战武器命中 +5。" },
    pokemon = { name="保可梦", active=true, ap=4, fatigue=16, cd=3, range=1, target="ally", shield=true,
        text="持盾照应一名相邻队员：近战防御 +4、远程防御 +8，持续到其第二次回合结束。双方须保持相邻且可可可行动并持盾。护卫类临时加成只取最高值。" },
    breathe_easy = { name="松口气", active=false,
        text="可可持盾时，相邻的可行动队员躲过敌方单体武器攻击，可可消除 4 疲劳。每轮最多一次，每战最多消除 20。" },
    turtle_shell = { name="缩壳", active=true, ap=3, fatigue=14, cd=2, range=0, target="self", shield=true,
        text="持盾缩入防线，受到的伤害减少 20%，直到自己下次回合开始。期间不能使用武器技能；移动、失盾或失去行动能力会解除保护。" },
    turtle_bond = { name="飞爹后援", active=false,
        text="持盾且与可行动的阿飞相距不超过 3 格时，决心 +8，每回合疲劳恢复量 +2。阿飞在预备队时无效。" }
};
A.memberRound <- function() { return ::Time.getRound(); };
A.memberReady <- function(a) {
    return a != null && a.isAlive() && !a.isDying() && a.isPlacedOnMap()
        && a.getCurrentProperties().IsAbleToUseSkills && !a.getSkills().hasSkill("effects.stunned")
        && !a.getSkills().hasSkill("effects.sleeping") && !a.getSkills().hasSkill("effects.charmed")
        && a.getMoraleState() != ::Const.MoraleState.Fleeing;
};
A.memberPlayer <- function(a) { return this.memberReady(a) && a.getFaction() == ::Const.Faction.Player && a.isPlayerControlled(); };
A.memberShield <- function(a) {
    local item = a.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
    return item != null && item.isItemType(::Const.Items.ItemType.Shield);
};
A.memberWeapon <- function(a, twoHanded) {
    local w = a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    return w != null && w.isItemType(::Const.Items.ItemType.MeleeWeapon)
        && w.isItemType(twoHanded ? ::Const.Items.ItemType.TwoHanded : ::Const.Items.ItemType.OneHanded);
};
A.memberAllies <- function(a, radius) {
    local result = [];
    foreach (b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
        if (b != a && this.memberPlayer(b) && b.isAlliedWith(a) && a.getTile().getDistanceTo(b.getTile()) <= radius) result.push(b);
    return result;
};
A.memberCaptain <- function() {
    foreach (key in ["afei", "damou", "mocha"]) foreach (b in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
        if (this.memberPlayer(b) && this.characterId(b) == key) return b;
    return null;
};
A.memberMentalTarget <- function(a) {
    if (!this.memberReady(a) || a.getCurrentProperties().IsImmuneToFearAndPanic) return false;
    if (::isKindOf(a, "human")) return true;
    foreach (key in ["OrcYoung", "OrcWarrior", "OrcBerserker", "OrcWarlord", "GoblinFighter", "GoblinAmbusher", "GoblinLeader", "GoblinShaman"])
        if (key in ::Const.EntityType && a.getType() == ::Const.EntityType[key]) return true;
    return false;
};
A.memberMeleeSkill <- function(s) { return s != null && s.isAttack() && !s.isRanged() && s.m.IsWeaponSkill; };
// Only audited, synchronous, single-target vanilla attacks can be delegated.
A.MemberBasicAttacks <- ["actives.thrust", "actives.stab", "actives.slash", "actives.cleave", "actives.chop", "actives.bash", "actives.pound", "actives.strike", "actives.flail", "actives.hammer", "actives.crush_armor", "actives.prong", "actives.impale", "actives.hook", "actives.smite", "actives.split_man", "actives.overhead_strike", "actives.cudgel"];
A.memberBasicAttack <- function(a, twoHanded) {
    if (!this.memberWeapon(a, twoHanded)) return null;
    local weapon = a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    foreach (s in a.getSkills().m.Skills)
        if (this.MemberBasicAttacks.find(s.getID()) != null && this.memberMeleeSkill(s) && s.getItem() == weapon && s.isUsable()) return s;
    return null;
};
A.syncMemberSkills <- function(bro) {
    if (!this.isOrigin() || bro == null) return;
    local key = this.characterId(bro);
    if (key == null || !(key in this.MemberSkills)) return;
    foreach (name in this.MemberSkills[key]) {
        local d=this.MemberSkillDefs[name],active = d.active;
        local id = (active ? "actives." : "trait.") + "afeix_member_" + name;
        if("catalogLearned" in this&&!this.catalogLearned(bro,name)){
            if(bro.getSkills().hasSkill(id))bro.getSkills().removeAllByID(id);
            continue;
        }
        if (!bro.getSkills().hasSkill(id)) {
            local extra="extended" in d&&d.extended;
            local skill = ::new("scripts/skills/" + (active ? (extra?"actives/afeix_catalog_active":"actives/afeix_member_active") : (extra?"traits/afeix_catalog_passive":"traits/afeix_member_passive")));
            skill.configure(name);
            bro.getSkills().add(skill);
        }
    }
};
A.memberEffect <- function(target, kind, source = null, turns = 1) {
    local id = "effects.afeix_member_" + kind;
    // Same-kind effects refresh rather than stack. No current skill has multiple owners.
    local effect = target.getSkills().getSkillByID(id);
    if (effect == null) { effect = ::new("scripts/skills/effects/afeix_member_effect"); effect.configure(kind, source, turns); target.getSkills().add(effect); }
    else { effect.configure(kind, source, turns); target.getSkills().update(); }
    return effect;
};
A.RefreshingMemberAuras <- false;
A.refreshMemberAura <- function(actor) {
    if (this.RefreshingMemberAuras || !this.isOrigin() || !::Tactical.isActive() || actor == null || !actor.isAlive()) return;
    local key = this.characterId(actor);
    if (key == null || !(key in this.MemberSkills)) return;
    this.RefreshingMemberAuras = true;
    try { actor.getSkills().update(); }
    catch (error) { this.RefreshingMemberAuras = false; throw error; }
    this.RefreshingMemberAuras = false;
};
