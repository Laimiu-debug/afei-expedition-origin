local A = ::AfeixExpedition;
A.TurtleAwakeningCooldown <- 5;
A.turtleFlag <- function(actor, key, fallback = 0) {
    local flags = actor.getFlags(), name = "afeix_turtle_" + key;
    return flags.has(name) ? flags.get(name) : fallback;
};
A.setTurtleFlag <- function(actor, key, value) { actor.getFlags().set("afeix_turtle_" + key, value); };
A.turtleAwakeningText <- function(count) {
    local scenes = [
        "壳上的旧纹第一次亮起，像深水里的星。小龟挡在阿飞前面，连她自己也吃了一惊：飞爹，站我后面！玄武血脉在这一刻苏醒。",
        "熟悉的暗光再次沿着龟壳展开。小龟这回没有惊慌，她稳稳踩住泥地：飞爹，我认得这股力量了。这一步，跟我走。",
        "小龟摸了摸壳上的旧纹，深水般的光一层层涌出。她把盾抬稳：上次守住的路，这次也能守住。",
        "壳纹又亮了。小龟没有急着冲出去，她先给阿飞留出落脚的位置：别慌，我还站着。",
        "小龟长长吐出一口气，旧纹中的暗光重新连成一片。她望向前面的敌人：飞爹，这回换你看我打完。"
    ];
    local index = count <= 2 ? count - 1 : 2 + (count - 3) % 3;
    return scenes[index] + "\n\n第 " + count + " 次觉醒。本场战斗：生命上限 +400、疲劳上限 +120、决心 +100、近攻 +60、远攻 +40、近防和远防各 +100、近战伤害 ×1.5、每回合疲劳恢复 +10，先攻最多 20。立即回满生命、清空疲劳，士气变为自信。\n\n战后强化消失，生命不超过原上限。此后她须完成 " + this.TurtleAwakeningCooldown + " 场未觉醒的参战胜利才能再次触发；待命和撤退不计。";
};
// Actor flags survive combat-memory removal and ordinary save/load.
A.finishTurtleBattle <- function() {
    if (!this.isOrigin()) return;
    local stats = ::World.Statistics.getFlags(), id = stats.getAsInt("LastCombatID");
    foreach (actor in this.roster()) {
        if (this.characterId(actor) != "xiaogui" || this.turtleFlag(actor, "participated", -1) != id
            || this.turtleFlag(actor, "finished", -1) == id) continue;
        this.setTurtleFlag(actor, "finished", id);
        this.setTurtleFlag(actor, "notice", 0);
        if (stats.getAsInt("LastCombatResult") == 1 && this.turtleFlag(actor, "awakened_battle", -1) != id)
            this.setTurtleFlag(actor, "cooldown", ::Math.max(0, this.turtleFlag(actor, "cooldown") - 1));
    }
};
// Display from the state update, outside actor damage/death callbacks. Retain
// the pending notice if another native modal is open, including across saves.
A.showTurtleAwakeningNotice <- function(state) {
    // Native generic dialog does not pause tactical AI. Keep the pause until
    // its close animation and menu entry finish, including escape/cancel.
    if ("AfeixTurtleNoticePaused" in state.m && state.m.AfeixTurtleNoticePaused
        && !state.DialogScreen.isVisible() && !state.DialogScreen.isAnimating() && !state.m.MenuStack.hasBacksteps()) {
        state.setPause(state.m.AfeixTurtlePreviousPause);
        state.m.IsAIPaused = state.m.AfeixTurtlePreviousAIPause;
        state.m.AfeixTurtleNoticePaused = false;
    }
    if (!this.isOrigin() || !::Tactical.isActive() || state.isBattleEnded() || state.isInLoadingScreen()
        || state.m.MenuStack.hasBacksteps()) return false;
    foreach (screen in [state.DialogScreen, state.m.TacticalDialogScreen, state.m.CharacterScreen,
        state.m.TacticalMenuScreen, state.m.TacticalCombatResultScreen])
        if (screen.isVisible() || screen.isAnimating()) return false;
    foreach (faction in ::Tactical.Entities.getAllInstances()) foreach (actor in faction) {
        if (actor == null || this.characterId(actor) != "xiaogui") continue;
        local count = this.turtleFlag(actor, "notice");
        if (count <= 0) continue;
        state.m.AfeixTurtlePreviousPause <- state.isPaused();
        state.m.AfeixTurtlePreviousAIPause <- state.m.IsAIPaused;
        state.m.AfeixTurtleNoticePaused <- true;
        state.setPause(true);
        state.showDialogPopup("玄武血脉 · 第 " + count + " 次觉醒", this.turtleAwakeningText(count), null, null);
        this.setTurtleFlag(actor, "notice", 0);
        return true;
    }
    return false;
};
A.tryTurtleAwakening <- function() {
    if (!this.isOrigin() || !::Tactical.isActive()) return false;
    local afei = null, turtle = null, allies = 0, enemies = 0;
    // Count every living allied actor on the map, including allied NPCs and dogs.
    // Reserves, corpses, dying actors and those who have left the map do not count.
    foreach (faction in ::Tactical.Entities.getAllInstances()) foreach (actor in faction) {
        if (actor == null || !actor.isAlive() || actor.isDying() || !actor.isPlacedOnMap()) continue;
        if (actor.isAlliedWithPlayer()) {
            ++allies;
            if (actor.getFaction() == ::Const.Faction.Player) {
                local key = this.characterId(actor);
                if (key == "afei") afei = actor;
                else if (key == "xiaogui") {
                    turtle = actor;
                    this.setTurtleFlag(turtle, "participated", ::World.Statistics.getFlags().getAsInt("LastCombatID") + 1);
                }
            }
        } else ++enemies;
    }
    if (allies != 2 || enemies == 0 || afei == null || turtle == null) return false;
    if (this.catalogGet(turtle, "turtle_awakened") != 0) return false;
    if (this.turtleFlag(turtle, "cooldown") > 0) return false;
    local skills = turtle.getSkills();
    if (skills.hasSkill("effects.afeix_turtle_awakening")) return false;
    this.catalogSet(turtle, "turtle_awakened", 1);
    local count = this.turtleFlag(turtle, "count") + 1;
    this.setTurtleFlag(turtle, "count", count);
    this.setTurtleFlag(turtle, "cooldown", this.TurtleAwakeningCooldown);
    this.setTurtleFlag(turtle, "awakened_battle", this.turtleFlag(turtle, "participated"));
    this.setTurtleFlag(turtle, "notice", count);
    local effect = ::new("scripts/skills/effects/afeix_turtle_awakening");
    effect.m.NormalHitpointsMax = turtle.getHitpointsMax();
    skills.add(effect);
    skills.update();
    turtle.setHitpoints(turtle.getHitpointsMax());
    turtle.setFatigue(0);
    turtle.setMoraleState(::Const.MoraleState.Confident);
    turtle.setDirty(true);
    ::Tactical.EventLog.log("玄武血脉第 " + count + " 次觉醒：小龟的属性临时强化，战后消失；再次觉醒需完成 " + this.TurtleAwakeningCooldown + " 场未觉醒的参战胜利。");
    return true;
};
