// A single, beatable boss. Every warning survives until its next own turn;
// callbacks retain IDs and tiles, never a dead actor reference or a timer.
::AfeixExpedition.Douyu <- {
    // Fixed endgame target: 10-12 level-11, equipped members. No scaling,
    // regeneration or repeated unavoidable damage to erase player progress.
    Stats = {Hitpoints=4800,ActionPoints=9,Stamina=400,FatigueRecoveryRate=30,Initiative=60,
        MeleeSkill=110,RangedSkill=85,MeleeDefense=22,RangedDefense=14,Bravery=120,
        Armor=[600.0,450.0],DamageRegularMin=110,DamageRegularMax=135,DamageArmorMult=1.1},
    Attacks = {
        bite = { Min=110, Max=135, Armor=1.1, Direct=0.25 },
        mark = { Min=110, Max=135, Armor=1.2, Direct=0.3 },
        barrage = { Min=45, Max=65, Armor=0.9, Direct=0.15 },
        rocket = { Min=125, Max=155, Armor=1.2, Direct=0.3 }
    },
    InterruptThreshold = 700,
    Phase2DamageMult = 1.2,
    function state(_actor) { return _actor.getSkills().getSkillByID("effects.afeix_douyu_core").m; },
    function alive(_actor) { return _actor != null && _actor.isAlive() && !_actor.isDying() && _actor.isPlacedOnMap(); },
    function log(_text) { ::Tactical.EventLog.log(_text); },
    function isDream() {
        local p = ::Tactical.State.getStrategicProperties();
        return p != null && "CombatID" in p && p.CombatID == "afeix_dream_douyu";
    },
    function area(_tile) {
        local result = [_tile];
        for(local i = 0; i < 6; ++i) if(_tile.hasNextTile(i)) result.push(_tile.getNextTile(i));
        return result;
    },
    function clearWarning(_actor) {
        local s = this.state(_actor);
        foreach(tile in s.BlastTiles) {
            tile.clear(::Const.Tactical.DetailFlag.SpecialOverlay);
            tile.Properties.IsMarkedForImpact = false;
        }
        s.BlastTiles = [];
    },
    function beginArea(_actor, _tile, _kind) {
        local s = this.state(_actor);
        s.Charging = true; s.ChargeKind = _kind; s.ChargeTurn = s.Turn; s.InterruptDamage = 0;
        s.BlastTiles = this.area(_tile);
        foreach(tile in s.BlastTiles) {
            tile.Properties.IsMarkedForImpact = true;
            tile.spawnDetail("mortar_target_02", ::Const.Tactical.DetailFlag.SpecialOverlay, false, true);
        }
    },
    function removeMark(_actor) {
        local s = this.state(_actor), target = ::Tactical.getEntityByID(s.MarkID);
        if(this.alive(target)) target.getSkills().removeByID("effects.afeix_douyu_mark");
        s.MarkID = 0;
    },
    function expose(_actor) {
        local s = this.state(_actor);
        s.ExposedUntil = s.Turn + 1;
        this.log("斗鱼的礼炮熄灭，露出破绽！直到它的下次回合，受到的伤害提高 35%。");
        _actor.getSkills().update();
    },
    function interrupt(_actor, _attacker, _hp, _armor) {
        local s = this.state(_actor);
        if(!s.Charging || !this.alive(_attacker) || _actor.isAlliedWith(_attacker)) return;
        s.InterruptDamage += ::Math.max(0, _hp) + ::Math.max(0, _armor);
        if(s.InterruptDamage < this.InterruptThreshold) return;
        s.Charging = false;
        // The next own turn uses native melee instead of charging again.
        // Otherwise sustained focus fire can cancel every action forever.
        s.SpecialRecoveryUntil = s.Turn + 2;
        this.clearWarning(_actor);
        this.removeMark(_actor);
        this.expose(_actor);
        this.log((s.ChargeKind == "rocket" ? "超级火箭" : "弹幕洪流") + "被打断！近战或远程造成的 " + this.InterruptThreshold + " 点实际生命与护甲伤害打断了蓄力。斗鱼下回合改用撕咬，随后才重新使用礼炮。");
    },
    function pressure(_target) {
        if(!this.alive(_target)) return;
        local skills = _target.getSkills();
        // No refresh and no stacking: repeated attacks never prolong control.
        if(skills.hasSkill("effects.afeix_douyu_pressure")) return;
        skills.add(::new("scripts/skills/effects/afeix_douyu_pressure_effect"));
        _target.setFatigue(::Math.min(_target.getFatigueMax(), _target.getFatigue() + 10));
        if(_target.getMoraleState() != ::Const.MoraleState.Ignore)
            _target.checkMorale(-1, 10, ::Const.MoraleCheckType.MentalAttack);
    },
    function canSpecial(_actor, _kind) {
        local s = this.state(_actor);
        if(s.SpecialTurn == s.Turn || s.Charging || s.MarkID != 0 || s.Turn < s.ExposedUntil || s.Turn < s.SpecialRecoveryUntil) return false;
        if(_kind == "rocket") return s.ComboPending || s.Turn >= s.NextRocket;
        if(_kind == "mark") return s.Turn >= s.NextMark;
        return s.Turn >= s.NextBarrage;
    },
    function startTurn(_actor) {
        if(!this.alive(_actor)) return;
        local s = this.state(_actor), round = ::Time.getRound();
        if(s.LastRound == round) return;
        s.LastRound = round; ++s.Turn;
        if(!s.Phase2 && _actor.getHitpoints() <= _actor.getHitpointsMax() / 2) {
            s.Phase2 = true; s.ComboPending = true;
            this.log("斗鱼沉入黑水，又举起礼炮。半血后攻击伤害提高 20%，满屏开播即将开始——危险区与点名都留有一回合的应对时间！");
        }
        local hitIDs = [];
        if(s.Charging && s.ChargeTurn < s.Turn) {
            // Snapshot first: a kill can change turn-sequence and skill containers.
            local tiles = clone s.BlastTiles;
            s.Charging = false;
            this.clearWarning(_actor);
            local attack = _actor.getSkills().getSkillByID("actives.afeix_douyu_" + s.ChargeKind), count = 0;
            foreach(tile in tiles) {
                // Native on-hit reactions may kill and unplace the attacker.
                if(!this.alive(_actor)) return;
                if(!tile.IsOccupiedByActor) continue;
                local target = tile.getEntity();
                if(!this.alive(target) || _actor.isAlliedWith(target)) continue;
                hitIDs.push(target.getID());
                attack.attackEntity(_actor, target, false);
                if(!this.alive(_actor)) return;
                if(s.ChargeKind == "barrage") {
                    this.pressure(target);
                    if(++count >= 3) break;
                }
            }
            if(s.ChargeKind == "rocket") {
                this.log("超级火箭砸向预告的七格。离开危险区的队员避开了轰炸。");
                this.expose(_actor);
            }
            else this.log("弹幕洪流袭向预告区域！离开红圈或提前散开可以减少波及人数，旗手能安定受压的队员。");
        }
        if(s.MarkID != 0 && s.MarkTurn < s.Turn) {
            local markID = s.MarkID, target = ::Tactical.getEntityByID(markID);
            this.removeMark(_actor);
            if(hitIDs.find(markID) != null) this.log("被点名的目标已经承受火箭重击，斗鱼不再追加重复扑咬。");
            else if(this.alive(target) && !_actor.isAlliedWith(target)
                && _actor.getTile().getDistanceTo(target.getTile()) <= 3
                && ::Math.abs(_actor.getTile().Level - target.getTile().Level) <= 2) {
                _actor.getSkills().getSkillByID("actives.afeix_douyu_mark").attackEntity(_actor, target, false);
                this.log("斗鱼扑咬被点名的队员！盾牌与防御仍可挡下攻击。");
            }
            else this.log("斗鱼的点名扑咬取消：目标已脱离三格追击范围，或已离开战场。");
        }
    },
    function beginMark(_actor, _target) {
        local s = this.state(_actor);
        s.MarkID = _target.getID(); s.MarkTurn = s.Turn;
        if(!_target.getSkills().hasSkill("effects.afeix_douyu_mark"))
            _target.getSkills().add(::new("scripts/skills/effects/afeix_douyu_mark_effect"));
        this.log("开播点名：" + _target.getName() + "！斗鱼下次回合会扑咬三格内的该队员。标记跟随队员；走位或换位须将其带到四格外才能避开，留在三格内可用盾墙防御。");
    }
};
