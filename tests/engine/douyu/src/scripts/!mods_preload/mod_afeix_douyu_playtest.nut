// Optional development harness. Never included in the main package.
::mods_registerMod("mod_afeix_douyu_playtest", 2, "AFEIX Douyu Engine Test");
::mods_queue("mod_afeix_douyu_playtest", "mod_afeix_expedition, >mod_afeix_dlc_xiwen_regen", function() {
    local A = ::AfeixExpedition;
    A.DouyuTestBefore <- "";
    A.DouyuTestSkip <- false;
    A.DouyuTestTrial <- null;
    ::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function(o) {
        local evaluate = o.onEvaluate;
        o.onEvaluate = function(actor) {
            local score = evaluate.bindenv(this)(actor);
            if (::AfeixExpedition.DouyuTestTrial != null && actor.getSkills().hasSkill("effects.afeix_douyu_core")) {
                local s = ::AfeixExpedition.Douyu.state(actor), p = actor.getCurrentProperties();
                ::logInfo("AFEIX_DOUYU_TEST BITE_EVALUATE round=" + ::Time.getRound() + " turn=" + s.Turn
                    + " ap=" + actor.getActionPoints() + " fatigue=" + actor.getFatigue() + "/" + actor.getFatigueMax()
                    + " score=" + score + " multiplier=" + this.getProperties().BehaviorMult[this.m.ID]
                    + " able=" + p.IsAbleToUseSkills + " melee=" + p.getMeleeSkill()
                    + " targets=" + this.queryTargetsInMeleeRange(1, 1, 1).len());
            }
            return score;
        };
    });
    foreach (kind in ["bite", "mark", "barrage", "rocket"]) {
        ::mods_hookExactClass("skills/actives/afeix_douyu_" + kind + "_skill", function(o) {
            local use = o.onUse;
            o.onUse = function(actor, tile) {
                if (::AfeixExpedition.DouyuTestTrial != null) {
                    local target = tile.IsOccupiedByActor ? tile.getEntity() : null;
                    local details = target == null ? "" : " target_def=" + target.getCurrentProperties().getMeleeDefense()
                        + " hit_chance=" + this.getHitchance(target);
                    ::logInfo("AFEIX_DOUYU_TEST BOSS_USE round=" + ::Time.getRound() + " skill=" + this.getID() + details);
                }
                return use.bindenv(this)(actor, tile);
            };
        });
    }
    A.douyuTestPartyHealth <- function() {
        local hp = 0, maxHP = 0, armor = 0;
        foreach (actor in this.DreamSession.actors) {
            maxHP += actor.getHitpointsMax();
            if (!actor.isAlive() || actor.isDying()) continue;
            hp += actor.getHitpoints();
            armor += actor.getCurrentProperties().Armor[0] + actor.getCurrentProperties().Armor[1];
        }
        return " party_hp=" + hp + "/" + maxHP + " party_armor=" + armor;
    };
    A.douyuTestSnapshot <- function() {
        local result = "";
        foreach (b in ::World.getPlayerRoster().getAll()) {
            result += b.getID() + ":" + b.getLevel() + ":" + b.getXP() + ":" + b.getHitpoints() + ":" + b.getFatigue() + ";";
            foreach (item in b.getItems().getAllItems()) result += item.getID() + ":" + item.getCondition() + ",";
        }
        foreach (key in ["Money", "ArmorParts", "Medicine", "Ammo"]) result += ";" + ::World.Assets.m[key];
        return result;
    };
    ::mods_hookExactClass("states/world_state", function(o) {
        local key = o.onKeyInput, finish = o.onCombatFinished;
        o.onKeyInput = function(k) {
            if (k.getState() == 0 && k.getKey() == 76 && ::AfeixExpedition.isOrigin() && !::AfeixExpedition.isDreamCombat()) {
                local A = ::AfeixExpedition;
                if (::World.Events.hasActiveEvent()) ::World.Events.processInput(-1);
                if (!A.dreamWorldReady()) return true;
                A.DouyuTestBefore = A.douyuTestSnapshot(); A.DouyuTestSkip = false; A.DouyuTestTrial = null;
                A.set("dream_status", "pending"); A.set("dream_stage", 3);
                A.set("dream_wake_pending", false); A.set("dream_departure_pending", false);
                A.queueDreamCombat();
                ::logInfo("AFEIX_DOUYU_TEST BOSS_STAGE_REQUESTED");
                return true;
            }
            return key.bindenv(this)(k);
        };
        o.onCombatFinished = function() {
            local A = ::AfeixExpedition, dream = A.isDreamCombat();
            local r = finish.bindenv(this)();
            if (dream && A.DouyuTestBefore != "") {
                ::logInfo("AFEIX_DOUYU_TEST REALITY_RESTORED=" + (A.douyuTestSnapshot() == A.DouyuTestBefore)
                    + " roster=" + ::World.getPlayerRoster().getSize() + " status=" + A.dreamStatus());
                A.DouyuTestBefore = ""; A.DouyuTestSkip = false; A.DouyuTestTrial = null;
            }
            return r;
        };
    });
    ::mods_hookExactClass("states/tactical_state", function(o) {
        local key = o.onKeyInput, update = o.onUpdate, ended = o.onBattleEnded;
        o.onBattleEnded = function() {
            local A = ::AfeixExpedition;
            if (A.isDreamCombat() && A.DouyuTestTrial != null && !A.DreamSession.ending) {
                local survivors = 0;
                foreach (actor in A.DreamSession.actors) if (actor.isAlive() && !actor.isDying()) ++survivors;
                ::logInfo("AFEIX_DOUYU_TEST TRIAL_RESULT result=" + ::Tactical.Entities.getCombatResult()
                    + " survivors=" + survivors + " round=" + ::Time.getRound() + A.douyuTestPartyHealth());
            }
            return ended.bindenv(this)();
        };
        o.onKeyInput = function(k) {
            local A = ::AfeixExpedition;
            if (k.getState() == 0 && A.isDreamCombat() && A.DreamSession.stage == 3 && !A.DreamSession.ending) {
                if (k.getKey() == 82) {
                    local current = ::Tactical.TurnSequenceBar.getCurrentEntities();
                    if (current.len() > 1) {
                        local actor = current[1], start = current[1].onTurnStart;
                        actor.onTurnStart = function() {
                            start.bindenv(this)();
                            if (this.isAlive() && this.isPlacedOnMap()) {
                                ::logInfo("AFEIX_DOUYU_TEST FORCED_TURN_START_DEATH");
                                this.kill(null, null, ::Const.FatalityType.None);
                            }
                        };
                        ::logInfo("AFEIX_DOUYU_TEST TURN_START_DEATH_ARMED");
                    }
                    return true;
                }
                if (k.getKey() == 77) {
                    // Force only the outcome, exercising native boss death and
                    // the production victory-to-scripted-defeat boundary.
                    foreach (group in ::Tactical.Entities.getAllInstances()) foreach (actor in clone group)
                        if (actor.isAlive() && actor.isPlacedOnMap() && actor.getSkills().hasSkill("effects.afeix_douyu_core")) {
                            ::logInfo("AFEIX_DOUYU_TEST FORCED_BOSS_DEATH hp=" + actor.getHitpointsMax()
                                + " armor=" + actor.getCurrentProperties().Armor[0] + "/" + actor.getCurrentProperties().Armor[1]);
                            actor.kill(null, null, ::Const.FatalityType.None);
                        }
                    return true;
                }
                if (k.getKey() == 79) {
                    A.DouyuTestSkip = !A.DouyuTestSkip;
                    ::logInfo("AFEIX_DOUYU_TEST NATIVE_TURN_SKIP=" + A.DouyuTestSkip);
                    return true;
                }
                if (k.getKey() == 80) {
                    // Complete combat with production boss stats/AI and the
                    // actual ten level-11 builds. Only the dream timer is
                    // disabled. Native agents use real AP/fatigue/hit rolls,
                    // movement, armor and death; no combat values are reset.
                    A.DreamSession.stage = 2; A.DouyuTestSkip = false;
                    A.DouyuTestTrial = { LastRound = -1 };
                    foreach (actor in A.DreamSession.actors) {
                        local agent = ::new("scripts/ai/tactical/agents/charmed_player_agent");
                        agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_recover"));
                        agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_shieldwall"));
                        agent.finalizeBehaviors(); agent.setActor(actor);
                        actor.setAIAgent(agent); actor.m.IsControlledByPlayer = false;
                        // The first actor may already have begun its turn
                        // before the agents are replaced. Initialize only the
                        // new agent, preserving the actor's spent AP/fatigue.
                        if (actor.isTurnStarted()) agent.onTurnStarted();
                    }
                    ::logInfo("AFEIX_DOUYU_TEST FULL_NATIVE_TRIAL ten=11-level legendary; timer disabled; native AI both sides");
                    return true;
                }
            }
            return key.bindenv(this)(k);
        };
        o.onUpdate = function() {
            local A = ::AfeixExpedition;
            if (A.isDreamCombat() && A.DouyuTestTrial != null && !A.DreamSession.ending && !this.isInLoadingScreen()) {
                local round = ::Time.getRound();
                if (A.DouyuTestTrial.LastRound != round) {
                    A.DouyuTestTrial.LastRound = round;
                    local survivors = 0, hp = 0;
                    foreach (actor in A.DreamSession.actors) if (actor.isAlive() && !actor.isDying()) ++survivors;
                    foreach (group in ::Tactical.Entities.getAllInstances()) foreach (actor in group)
                        if (actor.isAlive() && actor.getSkills().hasSkill("effects.afeix_douyu_core")) hp = actor.getHitpoints();
                    ::logInfo("AFEIX_DOUYU_TEST TRIAL_ROUND round=" + round + " survivors=" + survivors + " boss_hp=" + hp + A.douyuTestPartyHealth());
                    if (round >= 30) { A.requestDreamWake("test-timeout"); ::logInfo("AFEIX_DOUYU_TEST TRIAL_TIMEOUT"); }
                }
            }
            if (A.isDreamCombat() && !A.DreamSession.ending && A.DouyuTestSkip && !this.isInLoadingScreen()
                && !this.isPaused() && !this.isInputLocked()) {
                local actor = ::Tactical.TurnSequenceBar.getActiveEntity();
                if (actor != null && actor.isAlive() && actor.isPlayerControlled())
                    ::Tactical.TurnSequenceBar.onNextTurnButtonPressed();
            }
            return update.bindenv(this)();
        };
    });
    ::logInfo("AFEIX_DOUYU_TEST READY F6=jump to dream boss; F7=force native boss death; F9=skip turns; F10=full native trial");
});
