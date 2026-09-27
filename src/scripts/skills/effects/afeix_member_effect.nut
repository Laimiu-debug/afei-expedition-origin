this.afeix_member_effect <- this.inherit("scripts/skills/skill", {
    m = { Kind="", Turns=1, Source=0, SourceTile=0, SourceTurn=0 },
    function create() {
        this.m.ID = "effects.afeix_member_pending";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false; this.m.IsStacking = false;
        this.m.IsSerialized = true; this.m.IsRemovedAfterBattle = true;
    },
    function configure(kind, source = null, turns = 1) {
        local A = ::AfeixExpedition;
        this.m.Kind = kind; this.m.Turns = turns;
        this.m.ID = "effects.afeix_member_" + kind;
        local icon = kind;
        if (kind == "nicotine_debt") { this.m.Name = "透支的气息"; this.m.Description = "随后两次自己回合开始时，疲劳恢复量各减少 5。"; icon = "nicotine"; }
        else if (kind == "breakthrough_exposed") { this.m.Name = "突破后的空门"; this.m.Description = "近战防御 -5，直到自己下次回合开始。"; icon = "bottle_breakthrough"; }
        else { this.m.Name = A.MemberSkillDefs[kind].name; this.m.Description = A.MemberSkillDefs[kind].text; }
        this.m.Icon = "skills/afeix_member_" + icon + ".png";
        this.m.Source = source == null ? 0 : source.getID();
        this.m.SourceTile = source == null ? 0 : source.getTile().ID;
        this.m.SourceTurn = 0;
        if (kind == "guard_nest" && source != null) this.m.SourceTurn = source.getSkills().getSkillByID("actives.afeix_member_guard_nest").m.Turns;
    },
    function source() { return this.m.Source == 0 ? null : ::Tactical.getEntityByID(this.m.Source); },
    function valid() {
        local A = ::AfeixExpedition;
        if (!A.isOrigin() || !::Tactical.isActive() || this.m.Turns <= 0) return false;
        if (this.m.Kind == "blue_form") return A.memberRound() == 1;
        if (["guard_nest", "pokemon", "turtle_shell"].find(this.m.Kind) == null) return true;
        local s = this.source(), target = this.getContainer().getActor();
        if (!A.memberPlayer(s) || !A.memberShield(s) || !target.isPlacedOnMap() || !target.isAlliedWith(s) || target.getTile().getDistanceTo(s.getTile()) > 1) return false;
        if (this.m.Kind == "pokemon") return true;
        if (s.getTile().ID != this.m.SourceTile) return false;
        if (this.m.Kind == "guard_nest") {
            local active = s.getSkills().getSkillByID("actives.afeix_member_guard_nest");
            local anchor = s.getSkills().getSkillByID(this.m.ID);
            if (anchor == null || anchor.m.Turns <= 0) return false;
            return active != null && active.m.Turns == this.m.SourceTurn;
        }
        return true;
    },
    function isHidden() { return !this.valid(); },
    function getTooltip() { return [{ id=1, type="title", text=this.getName() }, { id=2, type="description", text=this.getDescription() }]; },
    function bonus(field) {
        if (this.m.Kind == "borrow_strike") return field == "MeleeDefense" ? 5 : 0;
        if (this.m.Kind == "steady_hand") return field == "MeleeDefense" || field == "Bravery" ? 6 : 0;
        if (this.m.Kind == "guard_nest") return field == "RangedDefense" ? 6 : 0;
        if (this.m.Kind == "pokemon") return field == "MeleeDefense" ? 4 : (field == "RangedDefense" ? 8 : 0);
        return 0;
    },
    function applyGuard(properties, fields) {
        // One winning effect per property. Repeated casters cannot add the maximum twice.
        local actor = this.getContainer().getActor();
        foreach (field in fields) {
            local best = null, amount = 0;
            foreach (kind in ["borrow_strike", "steady_hand", "guard_nest", "pokemon"]) {
                local e = actor.getSkills().getSkillByID("effects.afeix_member_" + kind);
                if (e != null && e.valid() && e.bonus(field) > amount) { best = e; amount = e.bonus(field); }
            }
            if (best == this) properties[field] += amount;
        }
    },
    function onUpdate(properties) {
        if (!this.valid()) {
            if (::Tactical.isActive() && this.getContainer() != null && this.m.Source == this.getContainer().getActor().getID()
                && (this.m.Kind == "turtle_shell" || this.m.Kind == "guard_nest")) this.m.Turns = 0;
            return;
        }
        local kind = this.m.Kind;
        if (kind == "nicotine_debt") properties.FatigueRecoveryRate = ::Math.max(0, properties.FatigueRecoveryRate - 5);
        else if (kind == "dog_bark") properties.MeleeSkill -= 8;
        else if (kind == "breakthrough_exposed") properties.MeleeDefense -= 5;
        else if (kind == "blue_form") properties.Initiative += 12;
        else if (kind == "turtle_shell") properties.IsAbleToUseWeaponSkills = false;
        else this.applyGuard(properties, ["Bravery"]);
    },
    function onBeingAttacked(attacker, skill, properties) {
        if (!this.valid()) return;
        this.applyGuard(properties, ["MeleeDefense", "RangedDefense"]);
    },
    function onBeforeDamageReceived(attacker, skill, hitInfo, properties) {
        if (this.m.Kind == "turtle_shell" && this.valid()) properties.DamageReceivedTotalMult *= 0.8;
    },
    function onMissed(attacker, skill) {
        if (this.m.Kind != "pokemon" || !this.valid() || attacker == null || skill == null || !skill.isAttack() || !skill.m.IsWeaponSkill || attacker.isAlliedWith(this.getContainer().getActor())) return;
        local source = this.source(), passive = source.getSkills().getSkillByID("trait.afeix_member_breathe_easy");
        if (passive != null) passive.onProtectedMiss();
    },
    function onTurnStart() {
        if (["nicotine_debt", "breakthrough_exposed", "borrow_strike", "steady_hand", "turtle_shell"].find(this.m.Kind) != null && --this.m.Turns <= 0) this.removeSelf();
    },
    function onTurnEnd() { if ((this.m.Kind == "dog_bark" || this.m.Kind == "pokemon") && --this.m.Turns <= 0) this.removeSelf(); },
    function onMovementFinished() {
        if ((this.m.Kind == "turtle_shell" || this.m.Kind == "guard_nest") && this.m.Source == this.getContainer().getActor().getID()) this.removeSelf();
    },
    function onNewRound() { if (!this.valid()) this.removeSelf(); },
    function onSerialize(out) {
        this.skill.onSerialize(out); out.writeString(this.m.Kind); out.writeI32(this.m.Turns); out.writeI32(this.m.Source); out.writeI32(this.m.SourceTile); out.writeI32(this.m.SourceTurn);
    },
    function onDeserialize(input) {
        this.skill.onDeserialize(input); this.configure(input.readString()); this.m.Turns = input.readI32(); this.m.Source = input.readI32(); this.m.SourceTile = input.readI32(); this.m.SourceTurn = input.readI32();
    }
});
