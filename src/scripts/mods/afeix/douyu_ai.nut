// Native behavior lifecycle, camera and AI delays; no out-of-turn skill.use.
this.douyu_ai <- this.inherit("scripts/ai/tactical/behavior", {
    m = { TargetTile = null, Skill = null },
    function create() {
        this.m.ID = this.Const.AI.Behavior.ID.AttackSpecial;
        this.m.Order = this.Const.AI.Behavior.Order.AttackSpecial;
        this.behavior.create();
    },
    function onEvaluate(_entity) {
        this.m.TargetTile = null; this.m.Skill = null;
        local d = ::AfeixExpedition.Douyu, s = d.state(_entity);
        if(!_entity.getCurrentProperties().IsAbleToUseSkills || s.SpecialTurn == s.Turn
            || s.Charging || s.MarkID != 0 || s.Turn < s.ExposedUntil || s.Turn < s.SpecialRecoveryUntil) return 0;
        // Rotate specials rather than choosing the same highest-scored skill forever.
        local order = s.ComboPending || s.Turn % 4 == 1 ? ["rocket", "mark", "barrage"]
            : (s.Turn % 4 == 2 ? ["barrage", "mark", "rocket"] : ["mark", "barrage", "rocket"]);
        foreach(kind in order) {
            local skill = _entity.getSkills().getSkillByID("actives.afeix_douyu_" + kind);
            if(skill == null || !skill.isUsable() || !skill.isAffordable()) continue;
            local targets = this.queryTargetsInMeleeRange(skill.getMinRange(), skill.getMaxRange(), skill.getMaxLevelDifference());
            local best = null, bestScore = -1;
            foreach(target in targets) {
                if(!d.alive(target) || !skill.isUsableOn(target.getTile())) continue;
                local score = 10 - _entity.getTile().getDistanceTo(target.getTile());
                if(kind != "mark") foreach(tile in d.area(target.getTile()))
                    if(tile.IsOccupiedByActor && !_entity.isAlliedWith(tile.getEntity())) score += 10;
                if(score > bestScore) { best = target; bestScore = score; }
            }
            if(best == null) continue;
            this.m.Skill = skill; this.m.TargetTile = best.getTile();
            return 5000.0 * this.getProperties().BehaviorMult[this.m.ID];
        }
        return 0;
    },
    function onExecute(_entity) {
        if(this.m.IsFirstExecuted) {
            this.getAgent().adjustCameraToTarget(this.m.TargetTile); this.m.IsFirstExecuted = false; return false;
        }
        if(this.m.Skill != null && this.m.TargetTile != null && _entity.isAlive()) {
            this.m.Skill.use(this.m.TargetTile);
            this.getAgent().declareAction(); this.getAgent().declareEvaluationDelay(350);
        }
        this.m.Skill = null; this.m.TargetTile = null;
        return true;
    }
});
