// An ending-only water tableau. Real time keeps it moving even when the
// battle menu paused virtual time; no timers retain actors after scene exit.
local A = ::AfeixExpedition;
A.DreamTideSequence <- 0;
A.DreamTideSweepSeconds <- 2.4;
A.DreamTideDirection <- "right-to-left";
A.DreamTideFallStep <- 0.10;
A.DreamTideFadeAt <- 3.4;
A.DreamTideDuration <- 4.6;
A.dreamTideUI <- function(state, method, data) {
    local screen = state.m.TacticalScreen;
    if(screen == null || screen.m.JSHandle == null) return false;
    screen.m.JSHandle.asyncCall(method, data);
    return true;
};
A.clearDreamTide <- function() {
    if(!this.isDreamCombat() || !("tide" in this.DreamSession) || this.DreamSession.tide == null) return;
    local tide = this.DreamSession.tide;
    this.dreamTideUI(tide.State, "afeixStopDreamTide", { Token = tide.Token });
    this.DreamSession.tide = null;
};
A.startDreamTide <- function(state) {
    local s = this.DreamSession;
    if(s == null || !s.ending || !s.collapseStarted || s.tide != null) return false;
    local actors = [];
    // Familiar captains stay under the flag to the end of the tableau.
    for(local i = s.actors.len() - 1; i >= 0; --i) actors.push(s.actors[i]);
    local now = ::Time.getRealTimeF();
    local tide = { State = state, Scene = ::Tactical.State, Token = ++this.DreamTideSequence,
        StartedAt = now, Actors = actors, NextActor = 0, LastFrameAt = -1.0 };
    s.tide = tide;
    s.exitAt = now + this.DreamTideDuration;
    local video = ::Settings.getVideoMode();
    this.dreamTideUI(state, "afeixStartDreamTide", { Token = tide.Token, SweepSeconds = this.DreamTideSweepSeconds, Direction = this.DreamTideDirection,
        FadeAt = this.DreamTideFadeAt, Duration = this.DreamTideDuration,
        ViewportWidth = video.Width, ViewportHeight = video.Height });
    ::Tactical.EventLog.log(this.DreamTideDirection == "left-to-right" ? "黑潮从左往右扫过来，把黑旗底下十个人全卷了进去……" : "黑潮从右往左扫过来，把黑旗底下十个人全卷了进去……");
    return true;
};
A.updateDreamTideAnimation <- function(state) {
    local s = this.DreamSession;
    if(s == null || !s.ending || !s.collapseStarted || s.tide == null || s.exitStarted) return false;
    local tide = s.tide;
    if(tide.State != state || tide.Scene != ::Tactical.State) return false;
    local elapsed = ::Time.getRealTimeF() - tide.StartedAt;
    if(elapsed < 0.0) elapsed = 0.0;
    // Bound UI traffic to 30 fps. Send the final black frame before exit.
    if(elapsed - tide.LastFrameAt >= 1.0 / 30.0 || elapsed >= this.DreamTideDuration) {
        tide.LastFrameAt = elapsed;
        local video = ::Settings.getVideoMode();
        this.dreamTideUI(state, "afeixDreamTideFrame", { Token = tide.Token, Elapsed = elapsed,
            ViewportWidth = video.Width, ViewportHeight = video.Height });
    }
    while(tide.NextActor < tide.Actors.len()
        && elapsed >= this.DreamTideSweepSeconds + tide.NextActor * this.DreamTideFallStep) {
        local actor = tide.Actors[tide.NextActor++];
        if(actor.getFlags().get("afeix_dream_actor") == true && actor.isAlive() && !actor.isDying() && actor.isPlacedOnMap())
            actor.kill(null, null, ::Const.FatalityType.None);
    }
    if(elapsed >= this.DreamTideDuration) {
        s.exitStarted = true;
        state.exitTactical();
    }
    return true;
};
