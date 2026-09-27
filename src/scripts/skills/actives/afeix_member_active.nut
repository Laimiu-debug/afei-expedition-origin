this.afeix_member_active <- this.inherit("scripts/skills/skill", {
    m = { Key = "", ReadyRound = 0, Used = false, Turns = 0, ExecutingNative = null },
    function create() {
        this.m.ID = "actives.afeix_member_pending";
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.Any;
        this.m.IsSerialized = true;
        this.m.IsActive = true;
        this.m.IsStacking = false;
        this.m.IsIgnoredAsAOO = true; // Special actions must never replace free disengagement/riposte attacks.
    },
    function configure(key) {
        local d = ::AfeixExpedition.MemberSkillDefs[key];
        this.m.Key = key;
        this.m.ID = "actives.afeix_member_" + key;
        this.m.Name = d.name; this.m.Description = d.text;
        this.m.Icon = "skills/afeix_member_" + key + ".png";
        this.m.IconDisabled = this.m.Icon;
        this.m.ActionPointCost = d.ap; this.m.FatigueCost = d.fatigue;
        this.m.IsTargeted = d.target != "self";
        this.m.IsAttack = d.target == "weapon";
        this.m.IsWeaponSkill = this.m.IsAttack;
        this.m.MinRange = this.m.IsTargeted ? 1 : 0;
        this.m.MaxRange = d.range;
    },
    function nativeAttack() { return ::AfeixExpedition.memberBasicAttack(this.getContainer().getActor(), this.m.Key == "breach_strike"); },
    function onAfterUpdate(properties) {
        if (this.m.Key == "" || !this.m.IsAttack) return;
        local s = this.nativeAttack();
        this.m.MinRange = s == null ? 1 : s.m.MinRange;
        this.m.MaxRange = s == null ? 1 : s.getMaxRange();
        this.m.FatigueCostMult = s == null ? 1.0 : s.m.FatigueCostMult;
    },
    function getMaxRange() {
        if (!this.m.IsAttack || this.getContainer() == null) return this.m.MaxRange;
        local s = this.nativeAttack();
        return s == null ? 1 : s.getMaxRange();
    },
    function nativePreview(method, args) {
        local s = this.nativeAttack(), previous = this.m.ExecutingNative;
        this.m.ExecutingNative = s;
        local result = null;
        try { local call = [s]; call.extend(args); result = s[method].acall(call); }
        catch (error) { this.m.ExecutingNative = previous; throw error; }
        this.m.ExecutingNative = previous;
        return result;
    },
    function getHitchance(target) {
        return this.m.IsAttack && this.nativeAttack() != null ? this.nativePreview("getHitchance", [target]) : this.skill.getHitchance(target);
    },
    function getExpectedDamage(target) {
        return this.m.IsAttack && this.nativeAttack() != null ? this.nativePreview("getExpectedDamage", [target]) : this.skill.getExpectedDamage(target);
    },
    function isUsable() {
        local A = ::AfeixExpedition;
        if (this.m.Key == "" || !A.isOrigin() || !::Tactical.isActive() || !this.skill.isUsable()) return false;
        local actor = this.getContainer().getActor(), d = A.MemberSkillDefs[this.m.Key];
        if (!A.memberPlayer(actor) || A.memberRound() < this.m.ReadyRound || (this.m.Key == "nicotine" && (this.m.Used || actor.getFatigue() <= 0))) return false;
        if (d.shield && !A.memberShield(actor)) return false;
        return !this.m.IsAttack || this.nativeAttack() != null;
    },
    function onVerifyTarget(origin, tile) {
        local A = ::AfeixExpedition, actor = this.getContainer().getActor(), d = A.MemberSkillDefs[this.m.Key];
        if (d.target == "self") return true;
        if (tile == null || !tile.IsOccupiedByActor || !tile.IsVisibleForEntity) return false;
        local target = tile.getEntity();
        if (d.target == "ally") return target != actor && A.memberPlayer(target) && actor.isAlliedWith(target);
        if (!target.isAlive() || target.isDying() || actor.isAlliedWith(target)) return false;
        if (d.target == "weapon") {
            local s = this.nativeAttack();
            return s != null && s.isInRange(tile, origin) && s.onVerifyTarget(origin, tile);
        }
        return A.memberMentalTarget(target) && ::Math.abs(tile.Level - origin.Level) <= 4;
    },
    function getTooltip() {
        local tip = this.getDefaultUtilityTooltip(), A = ::AfeixExpedition, d = A.MemberSkillDefs[this.m.Key];
        local remaining = ::Tactical.isActive() ? ::Math.max(0, this.m.ReadyRound - A.memberRound()) : 0;
        tip.push({ id=20, type="text", icon="ui/icons/special.png", text=d.cd > 0 ? "冷却 " + d.cd + " 轮（第 R 轮使用，第 R+" + d.cd + " 轮可再用）。" : "每场战斗一次。" });
        local spent=this.m.Used&&(this.m.Key=="nicotine"||("once" in d&&d.once));
        if (remaining > 0 || spent) tip.push({ id=21, type="text", icon="ui/icons/special.png", text=spent ? "本场已经使用。" : "还需等待 " + remaining + " 轮。" });
        if (this.m.IsAttack && this.nativeAttack() != null) foreach (entry in this.nativePreview("getTooltip", [])) if (entry.id >= 4) {
            local copy = clone entry; copy.id += 100; tip.push(copy);
        }
        return tip;
    },
    function onUse(user, tile) {
        // Native use has already paid AP/fatigue. Recheck eligibility, never affordability.
        if (user != this.getContainer().getActor() || !this.isUsable() || !this.onVerifyTarget(user.getTile(), tile)) return false;
        local A = ::AfeixExpedition, key = this.m.Key, d = A.MemberSkillDefs[key];
        this.m.ReadyRound = A.memberRound() + d.cd;
        this.m.Used = true;
        if (d.target == "weapon") {
            local s = this.nativeAttack();
            this.m.ExecutingNative = s;
            try { s.useForFree(tile); }
            catch (error) { this.m.ExecutingNative = null; throw error; }
            this.m.ExecutingNative = null;
            if (key == "bottle_breakthrough" && user.isAlive() && !user.isDying()) A.memberEffect(user, "breakthrough_exposed");
            // A native miss returns false, but is still a completed, paid attack.
        } else if (key == "nicotine") {
            user.setFatigue(::Math.max(0, user.getFatigue() - 15));
            A.memberEffect(user, "nicotine_debt", null, 2);
        } else if (key == "dog_bark") A.memberEffect(tile.getEntity(), "dog_bark");
        else if (key == "borrow_strike") {
            A.memberEffect(user, key); A.memberEffect(tile.getEntity(), key);
        } else if (key == "pokemon") A.memberEffect(tile.getEntity(), key, user, 2);
        else if (key == "turtle_shell") A.memberEffect(user, key, user);
        else {
            A.memberEffect(user, key, key == "guard_nest" ? user : null);
            foreach (ally in A.memberAllies(user, 1)) A.memberEffect(ally, key, key == "guard_nest" ? user : null);
        }
        user.getSkills().update();
        return true;
    },
    function onAnySkillUsed(s, target, properties) {
        if (s != this.m.ExecutingNative || s == null) return;
        if (this.m.Key == "bottle_breakthrough") properties.MeleeSkill += 10;
        else { properties.MeleeSkill -= 5; properties.DamageArmorMult *= 1.2; }
    },
    function onTurnStart() { ++this.m.Turns; },
    function reset() { this.m.ReadyRound = 0; this.m.Used = false; this.m.Turns = 0; this.m.ExecutingNative = null; },
    function onCombatStarted() { this.reset(); },
    function onCombatFinished() { this.reset(); },
    function onSerialize(out) {
        this.skill.onSerialize(out); out.writeString(this.m.Key); out.writeI32(this.m.ReadyRound); out.writeBool(this.m.Used); out.writeI32(this.m.Turns);
    },
    function onDeserialize(input) {
        this.skill.onDeserialize(input); this.configure(input.readString()); this.m.ReadyRound = input.readI32(); this.m.Used = input.readBool(); this.m.Turns = input.readI32(); this.m.ExecutingNative = null;
    }
});
