local D = ::AfeixEventsDLC;
D.nearEnemyCamp <- function() {
    local player = ::World.State.getPlayer();
    if (player == null || ::AfeixExpedition.currentTown() != null) return false;
    foreach (camp in ::World.EntityManager.getLocations()) {
        if (camp == null || !camp.isAlive() || !camp.isLocation() || camp.isAlliedWithPlayer()
            || camp.getTroops().len() == 0) continue;
        if (player.getTile().getDistanceTo(camp.getTile()) <= 8) return true;
    }
    return false;
};
D.onDeliveryJourney <- function() {
    if (::AfeixExpedition.currentTown() != null) return false;
    local kind = ::AfeixExpedition.contractType(::World.Contracts.getActiveContract());
    // "灵车" is the caravan-escort contract; courier includes the main Mod letter.
    return kind == "contract.deliver_item" || kind == "contract.afeix_letter"
        || kind == "contract.escort_caravan";
};
D.changeMood <- function(actors, delta, reason, cost = 0) {
    local assets = ::World.Assets, money = assets.getMoney(), snapshots = [];
    if (money < cost) throw "Not enough crowns for this choice.";
    foreach (actor in actors) if (actor != null && actor.isAlive() && !actor.isDying()) {
        local changes = [];
        foreach (change in actor.m.MoodChanges) changes.push(clone change);
        snapshots.push({ actor = actor, mood = actor.m.Mood, changes = changes });
    }
    try {
        if (cost != 0) {
            assets.addMoney(-cost);
            if (assets.getMoney() != money - cost) throw "Unexpected crown settlement.";
        }
        foreach (entry in snapshots) {
            if (delta < 0) entry.actor.worsenMood(-delta, reason);
            else entry.actor.improveMood(delta, reason);
        }
    } catch (error) {
        // Restore balances directly; a positive addMoney refund would count as income.
        assets.setMoney(money);
        foreach (entry in snapshots) {
            entry.actor.m.Mood = entry.mood;
            entry.actor.m.MoodChanges = entry.changes;
        }
        throw error;
    }
};
