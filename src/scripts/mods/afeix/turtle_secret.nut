local A = ::AfeixExpedition;
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
                else if (key == "xiaogui") turtle = actor;
            }
        } else ++enemies;
    }
    if (allies != 2 || enemies == 0 || afei == null || turtle == null) return false;
    if (this.catalogGet(turtle, "turtle_awakened") != 0) return false;
    local skills = turtle.getSkills();
    if (skills.hasSkill("effects.afeix_turtle_awakening")) return false;
    this.catalogSet(turtle, "turtle_awakened", 1);
    local effect = ::new("scripts/skills/effects/afeix_turtle_awakening");
    effect.m.NormalHitpointsMax = turtle.getHitpointsMax();
    skills.add(effect);
    skills.update();
    turtle.setHitpoints(turtle.getHitpointsMax());
    turtle.setFatigue(0);
    turtle.setMoraleState(::Const.MoraleState.Confident);
    turtle.setDirty(true);
    ::Tactical.EventLog.log("壳上的旧纹路像深水一样亮了一瞬。小龟把脚钉进泥里：飞爹，这一步，跟我走。");
    return true;
};
