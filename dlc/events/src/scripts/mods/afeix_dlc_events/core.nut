local D = ::AfeixEventsDLC;
D.Checking <- {};
D.ConditionFaults <- {};
D.get <- function(key, fallback = 0) { return ::AfeixExpedition.get("dlc_events_" + key, fallback); };
D.set <- function(key, value) { return ::AfeixExpedition.set("dlc_events_" + key, value); };
D.now <- function() { return ::AfeixExpedition.worldNow(); };
D.days <- function(value) { return ::AfeixExpedition.daysInSeconds(value); };
D.register <- function(scene) {
    foreach (field in ["id", "place", "title", "text", "choices"])
        if (!(field in scene)) throw "Events DLC scene missing " + field;
    if (typeof scene.id != "string" || scene.id.len() == 0 || scene.id.len() > 48)
        throw "Events DLC requires a stable, short scene ID.";
    foreach (c in scene.id) if (!((c >= 97 && c <= 122) || (c >= 48 && c <= 57) || c == 95))
        throw "Events DLC scene ID must use lowercase letters, digits and underscores.";
    if (scene.id in this.Scenes) throw "Duplicate Events DLC scene: " + scene.id;
    if (scene.place != "road" && scene.place != "tavern" && scene.place != "either")
        throw "Events DLC place must be road, tavern or either.";
    foreach (field in ["title", "text"]) if (typeof scene[field] != "string" || scene[field].len() == 0)
        throw "Events DLC requires nonempty " + field;
    if (typeof scene.choices != "array" || scene.choices.len() == 0 || scene.choices.len() > 4)
        throw "Events DLC requires one to four choices.";
    foreach (choice in scene.choices) {
        foreach (field in ["text", "outcome"]) if (!(field in choice) || typeof choice[field] != "string" || choice[field].len() == 0)
            throw "Events DLC choice missing " + field;
        foreach (field in ["canChoose", "apply"]) if (field in choice && typeof choice[field] != "function")
            throw "Events DLC choice callback must be a function: " + field;
    }
    local defaults = { weight = 5, cooldownDays = 8.0, minDay = 3, members = [], once = false };
    foreach (key, value in defaults) if (!(key in scene)) scene[key] <- value;
    if (typeof scene.weight != "integer" || scene.weight <= 0 || scene.weight > 100
        || (typeof scene.cooldownDays != "integer" && typeof scene.cooldownDays != "float") || scene.cooldownDays <= 0
        || typeof scene.minDay != "integer" || scene.minDay < 1 || typeof scene.members != "array" || typeof scene.once != "bool")
        throw "Invalid Events DLC scene timing, weight or prerequisites.";
    foreach (key in scene.members) if (typeof key != "string" || !(key in ::AfeixExpedition.Characters))
        throw "Unknown Events DLC required member: " + key;
    if ("condition" in scene && typeof scene.condition != "function") throw "Events DLC condition must be a function.";
    this.Scenes[scene.id] <- scene;
    this.Order.push(scene.id);
};
D.worldReady <- function() {
    local A = ::AfeixExpedition;
    if (!A.ideaSafe() || (("State" in ::Tactical) && ::Tactical.State != null)) return false;
    if (("LoadingScreen" in getroottable()) && ::LoadingScreen != null
        && (::LoadingScreen.isVisible() || ::LoadingScreen.isAnimating())) return false;
    return true;
};
D.membersPresent <- function(scene) {
    foreach (key in scene.members) {
        local actor = ::AfeixExpedition.findCharacter(key);
        if (actor == null || !actor.isAlive() || actor.isDying()) return false;
    }
    return true;
};
D.conditionEligible <- function(scene) {
    if (scene.id in this.ConditionFaults) return false;
    if (scene.id in this.Checking) {
        this.ConditionFaults[scene.id] <- true;
        ::logError("[Afei Events DLC] Recursive eligibility blocked: " + scene.id);
        return false;
    }
    if (!("condition" in scene)) return true;
    this.Checking[scene.id] <- true;
    try {
        local result = scene.condition();
        if (typeof result != "bool") throw "condition must return a bool";
        delete this.Checking[scene.id];
        return result && !(scene.id in this.ConditionFaults);
    } catch (error) {
        delete this.Checking[scene.id];
        // Session-only quarantine: avoid repeatedly crashing the native event
        // generator; corrected code can be checked again after restarting.
        this.ConditionFaults[scene.id] <- true;
        ::logError("[Afei Events DLC] Eligibility disabled for " + scene.id + ": " + error);
        return false;
    }
};
D.eligible <- function(id, place) {
    if (!(id in this.Scenes) || !this.worldReady()) return false;
    local s = this.Scenes[id];
    if (s.place != "either" && s.place != place) return false;
    if (::World.getTime().Days < s.minDay || this.now() < this.get("next")
        || this.now() < this.get("cooldown_" + id) || (s.once && this.get("done_" + id, false))) return false;
    if (!this.membersPresent(s) || !this.conditionEligible(s)) return false;
    if (place == "road") return ::AfeixExpedition.isWorldPartyMoving() && !::World.Assets.isCamping()
        && !::World.State.getMenuStack().hasBacksteps();
    return place == "tavern" && this.tavernVisible(0);
};
D.pool <- function(place) {
    local ids = [];
    foreach (id in this.Order) if (this.eligible(id, place)) ids.push(id);
    return ids;
};
D.choose <- function(ids) {
    local total = 0;
    foreach (id in ids) total += this.Scenes[id].weight;
    if (total == 0) return "";
    local roll = ::Math.rand(1, total);
    foreach (id in ids) { roll -= this.Scenes[id].weight; if (roll <= 0) return id; }
    return "";
};
D.tavernVisible <- function(townID) {
    if (!this.worldReady() || ::World.Events == null || ::World.Events.hasActiveEvent()) return false;
    local state = ::World.State, screen = state.m.WorldTownScreen, town = ::AfeixExpedition.currentTown();
    return town != null && (townID == 0 || town.getID() == townID) && screen != null && screen.isVisible()
        && !screen.isAnimating() && screen.m.LastActiveModule == screen.getTavernDialogModule()
        && !state.isInCharacterScreen() && state.m.EventScreen != null
        && !state.m.EventScreen.isVisible() && !state.m.EventScreen.isAnimating() && ::World.Events.m.Thread == null;
};
D.tryTavern <- function(townID) {
    if (!this.tavernVisible(townID) || this.now() < this.get("tavern_attempt_until")) return false;
    local ids = this.pool("tavern");
    if (ids.len() == 0) return false;
    local event = ::World.Events.getEvent(this.EventID);
    if (event == null) return false;
    this.set("tavern_attempt_until", this.now() + this.days(this.TavernAttemptDays));
    if (::Math.rand(1, 100) > this.TavernChance) return false;
    event.m.Pending <- this.choose(ids);
    local manager = ::World.Events;
    try {
        manager.m.ActiveEvent = event;
        manager.m.IsEventShown = true;
        event.fire();
        ::World.State.showEventScreenFromTown(event);
        // Native showEventScreenFromTown returns void. Inspect the actual screen.
        if (!::World.State.m.EventScreen.isVisible() && !::World.State.m.EventScreen.isAnimating())
            throw "Town event screen did not open.";
        // The base meeting would normally record this visit in onPrepare.
        // A DLC hit must retain that exploration progress too.
        ::AfeixExpedition.visitTavern(::AfeixExpedition.currentTown());
        this.markShown(event);
        return true;
    } catch (error) {
        event.clear();
        manager.m.ActiveEvent = null;
        manager.m.IsEventShown = false;
        ::logError("[Afei Events DLC] Could not open tavern encounter: " + error);
        return false;
    }
};
D.markShown <- function(event) {
    if (!(event.m.Scene in this.Scenes) || event.m.Shown) return;
    event.m.Shown = true;
    local s = this.Scenes[event.m.Scene];
    this.set("next", this.now() + this.days(this.SharedCooldownDays));
    this.set("cooldown_" + s.id, this.now() + this.days(s.cooldownDays));
};
D.resolve <- function(event, index) {
    if (!this.worldReady() || event.m.Resolved || event.m.Resolving || event.m.Token != this.get("active_token")
        || ::World.Events.m.ActiveEvent != event || !(event.m.Scene in this.Scenes))
        return { ok = false, text = "这次相遇已经结束，或此刻无法继续。" };
    local s = this.Scenes[event.m.Scene];
    if (index < 0 || index >= s.choices.len() || !this.membersPresent(s))
        return { ok = false, text = "当事人已不在队中，或选项无效。" };
    local option = s.choices[index];
    // Authors validate all costs before applying any changes; this lock prevents
    // reentrant/double input. Arbitrary authored effects are not auto-rolled back.
    event.m.Resolving = true;
    try {
        if ("canChoose" in option && !option.canChoose(event)) {
            event.m.Resolving = false;
            return { ok = false, text = "当前不满足这个选项的条件，请改选或结束谈话。" };
        }
        if ("apply" in option) option.apply(event);
    }
    catch (error) {
        event.m.Resolving = false; event.m.Resolved = true;
        ::logError("[Afei Events DLC] Scene " + s.id + " failed during settlement: " + error);
        return { ok = false, text = "这次事件的结果未能完整处理，请结束谈话。本次不会再次执行该选项。" };
    }
    event.m.Resolving = false;
    event.m.Resolved = true;
    this.set("done_" + s.id, true);
    this.set("done_token", event.m.Token);
    ::AfeixExpedition.refreshAssets();
    return { ok = true, text = option.outcome };
};
D.screen <- function(event, id) {
    local s = { ID = id, Text = event.m.Outcome, Image = "", List = [], Characters = [], Options = [], function start(e) {} };
    if (id == "result" || !(event.m.Scene in this.Scenes)) {
        s.Options.push({ Text = "继续旅程", function getResult(e) { return 0; } });
        return s;
    }
    local scene = this.Scenes[event.m.Scene];
    s.Text = (id == "retry" ? event.m.Outcome + "\n\n" : "") + "[img]gfx/ui/events/event_80.png[/img]" + scene.text;
    foreach (i, option in scene.choices) s.Options.push({ Text = option.text, Index = i,
        function getResult(e) { local r = ::AfeixEventsDLC.resolve(e, this.Index); e.m.Outcome = r.text; return r.ok || e.m.Resolved ? "result" : "retry"; } });
    s.Options.push({ Text = "结束谈话", function getResult(e) { return 0; } });
    return s;
};
