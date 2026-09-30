this.afeix_dlc_events_event <- this.inherit("scripts/events/event", {
    m = { Scene = "", Pending = "", Token = 0, Outcome = "", Resolved = false, Resolving = false, Shown = false },
    function create() { this.m.ID = "event.afeix_dlc_events"; this.m.Title = "旅途与酒馆"; this.m.Cooldown = 0.0; },
    function onUpdateScore() {
        // Tavern scenes never enter the world pool. Travel uses native timing.
        this.m.Score = 0;
        if (!("AfeixEventsDLC" in getroottable())) return;
        foreach (id in ::AfeixEventsDLC.pool("road")) this.m.Score += ::AfeixEventsDLC.Scenes[id].weight;
        // Keep this expansion below native urgent/news/special-event thresholds.
        this.m.Score = ::Math.min(100, this.m.Score);
    },
    function onPrepare() {
        local D = ::AfeixEventsDLC;
        this.m.Scene = this.m.Pending != "" ? this.m.Pending : D.choose(D.pool("road"));
        this.m.Pending = "";
        this.m.Resolved = false; this.m.Resolving = false; this.m.Shown = false;
        this.m.Outcome = "这次没有新的消息。";
        this.m.Token = D.get("serial") + 1;
        D.set("serial", this.m.Token); D.set("active_token", this.m.Token);
        if (this.m.Scene in D.Scenes) this.m.Title = D.Scenes[this.m.Scene].title;
    },
    function onDetermineStartScreen() { return this.m.Scene == "" ? "result" : "opening"; },
    function getScreen(id) { return ::AfeixEventsDLC.screen(this, id); },
    function buildText(text) { return text; },
    function onPrepareVariables(vars) {},
    function onClear() {
        this.m.Scene = ""; this.m.Pending = ""; this.m.Token = 0; this.m.Outcome = "";
        this.m.Resolved = false; this.m.Resolving = false; this.m.Shown = false;
    }
});
