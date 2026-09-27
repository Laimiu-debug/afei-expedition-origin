this.afeix_member_passive <- this.inherit("scripts/skills/skill", {
    m = { Key="", FormationDone=false, RecoveryRound=-1, Recovered=0 },
    function create() {
        this.m.ID = "trait.afeix_member_pending";
        this.m.Type = this.Const.SkillType.Trait;
        this.m.IsActive = false; this.m.IsStacking = false; this.m.IsSerialized = true;
    },
    function configure(key) {
        this.m.Key = key; this.m.ID = "trait.afeix_member_" + key;
        local d = ::AfeixExpedition.MemberSkillDefs[key];
        this.m.Name = d.name; this.m.Description = d.text;
        this.m.Icon = "skills/afeix_member_" + key + ".png";
    },
    function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; },
    function enabled() { return ::AfeixExpedition.isOrigin() && ::Tactical.isActive() && ::AfeixExpedition.memberPlayer(this.getContainer().getActor()); },
    function gooseReady() {
        local A = ::AfeixExpedition, a = this.getContainer().getActor(), n = 0;
        for (local i=0; i<6; ++i) if (a.getTile().hasNextTile(i)) {
            local tile = a.getTile().getNextTile(i);
            if (tile.IsOccupiedByActor && tile.getEntity().isAlive() && !tile.getEntity().isDying() && !a.isAlliedWith(tile.getEntity())) ++n;
        }
        return n > 0 && A.memberAllies(a, 1).len() >= n;
    },
    function onUpdate(p) {
        if (!this.enabled()) return;
        local A = ::AfeixExpedition, a = this.getContainer().getActor(), key = this.m.Key;
        if (key == "loyalty") {
            local c = A.memberCaptain();
            if (c != null && c != a && a.getTile().getDistanceTo(c.getTile()) <= 2) p.Bravery += 10;
        } else if (key == "together_lift" && A.memberShield(a) && A.memberAllies(a, 2).len() >= 2) p.Bravery += 8;
        else if (key == "goose_bully" && this.gooseReady()) p.Bravery += 5;
        else if (key == "turtle_bond" && A.memberShield(a)) {
            foreach (b in A.memberAllies(a, 3)) if (A.characterId(b) == "afei") { p.Bravery += 8; p.FatigueRecoveryRate += 2; break; }
        } else if (key == "finals_moment" && A.memberRound() >= 5) {
            foreach (s in a.getSkills().m.Skills) if (A.memberMeleeSkill(s)) p.SkillCostAdjustments.push({ ID=s.getID(), FatigueAdjust=3 });
        }
    },
    function onAnySkillUsed(s, target, p) {
        local A = ::AfeixExpedition;
        if (!this.enabled() || !A.memberMeleeSkill(s)) return;
        local a = this.getContainer().getActor(), key = this.m.Key;
        if (key == "finals_moment" && A.memberRound() >= 5) p.MeleeDamageMult *= 1.1;
        else if (key == "lvbu_weapon" && A.memberWeapon(a, true)) p.DamageArmorMult *= 1.1;
        else if (key == "together_lift" && A.memberShield(a) && A.memberAllies(a, 2).len() >= 2) p.DamageArmorMult *= 1.1;
        else if (key == "goose_bully" && this.gooseReady()) p.MeleeSkill += 5;
    },
    function onBeingAttacked(attacker, skill, p) {
        if (this.m.Key != "only_man" || !this.enabled()) return;
        local A = ::AfeixExpedition;
        foreach (b in A.memberAllies(this.getContainer().getActor(), 1)) if (!A.memberShield(b)) { p.MeleeDefense += 6; break; }
    },
    function onProtectedMiss() {
        local A = ::AfeixExpedition;
        if (!this.enabled() || this.m.Key != "breathe_easy" || this.m.RecoveryRound == A.memberRound() || this.m.Recovered >= 20) return;
        local a = this.getContainer().getActor(), amount = ::Math.min(4, ::Math.min(a.getFatigue(), 20 - this.m.Recovered));
        if (amount <= 0) return;
        this.m.RecoveryRound = A.memberRound(); this.m.Recovered += amount;
        a.setFatigue(a.getFatigue() - amount); a.getSkills().update();
    },
    function onNewRound() {
        local A = ::AfeixExpedition;
        if (this.m.Key != "blue_form" || this.m.FormationDone || !this.enabled() || A.memberRound() != 1) return;
        this.m.FormationDone = true;
        local a = this.getContainer().getActor(); A.memberEffect(a, "blue_form");
        foreach (b in A.memberAllies(a, 1)) A.memberEffect(b, "blue_form");
    },
    function reset() { this.m.FormationDone = false; this.m.RecoveryRound = -1; this.m.Recovered = 0; },
    function onCombatStarted() { this.reset(); },
    function onCombatFinished() { this.reset(); },
    function onSerialize(out) { this.skill.onSerialize(out); out.writeString(this.m.Key); out.writeBool(this.m.FormationDone); out.writeI32(this.m.RecoveryRound); out.writeI32(this.m.Recovered); },
    function onDeserialize(input) { this.skill.onDeserialize(input); this.configure(input.readString()); this.m.FormationDone = input.readBool(); this.m.RecoveryRound = input.readI32(); this.m.Recovered = input.readI32(); }
});
