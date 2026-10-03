local D = ::AfeixExpedition.Douyu;
D.RocketFlightMS <- 750;
D.RocketHeight <- 300.0;
D.RocketFlights <- [];
D.spawnRocket <- function(tile) {
    if(!tile.IsVisibleForPlayer) return;
    local lifetime = this.RocketFlightMS / 1000.0;
    local stage = {
        LifeTimeMin = lifetime, LifeTimeMax = lifetime,
        ColorMin = ::createColor("ffffffff"), ColorMax = ::createColor("ffffffff"),
        ScaleMin = 1.0, ScaleMax = 1.0, RotationMin = 0, RotationMax = 0,
        VelocityMin = this.RocketHeight / lifetime, VelocityMax = this.RocketHeight / lifetime,
        DirectionMin = ::createVec(0, -1), DirectionMax = ::createVec(0, -1),
        SpawnOffsetMin = ::createVec(0, this.RocketHeight), SpawnOffsetMax = ::createVec(0, this.RocketHeight),
        ForceMin = ::createVec(0, 0), ForceMax = ::createVec(0, 0)
    };
    // One nose-down rocket. Positive particle Y is above the battlefield;
    // fixed downward velocity puts the nose at ground level at 750 ms.
    ::Tactical.spawnParticleEffect(false, ["afeix_douyu_rocket_falling"], tile, 0, 1, 1, 1000, [stage], ::createVec(0, 0));
};
D.beginRocketFlight <- function(actor, tiles) {
    local s = this.state(actor);
    if(s.RocketFlight != null || tiles.len() == 0) return false;
    local tag = { ActorID = actor.getID(), Scene = ::Tactical.State, Tiles = tiles, Cancelled = false, Launched = false };
    s.RocketFlight = tag;
    this.RocketFlights.push(tag);
    try {
        if(tiles[0].IsVisibleForPlayer) {
            ::Tactical.CameraDirector.addMoveToTileEvent(0, tiles[0], -1, function(tag) {
                ::AfeixExpedition.Douyu.launchRocket(tag);
            }, tag);
        } else this.launchRocket(tag);
    } catch(error) { this.abandonRocketFlight(tag); throw error; }
    return true;
};
D.validRocketFlight <- function(tag) {
    if(tag.Cancelled || ::Tactical.State != tag.Scene || !::Tactical.isActive()
        || (::AfeixExpedition.isDreamCombat() && ::AfeixExpedition.DreamSession.ending)) return false;
    local actor = ::Tactical.getEntityByID(tag.ActorID);
    return this.alive(actor) && actor.getSkills().hasSkill("effects.afeix_douyu_core") && this.state(actor).RocketFlight == tag;
};
D.launchRocket <- function(tag) {
    if(!this.validRocketFlight(tag)) { this.abandonRocketFlight(tag); return false; }
    if(tag.Launched) return false;
    tag.Launched = true;
    try {
        this.spawnRocket(tag.Tiles[0]);
        this.log("超级火箭正从高处落向红圈中心！");
        ::Time.scheduleEvent(::TimeUnit.Virtual, this.RocketFlightMS, function(tag) {
            ::AfeixExpedition.Douyu.landRocket(tag);
        }, tag);
    } catch(error) { this.abandonRocketFlight(tag); throw error; }
    return true;
};
D.forgetRocketFlight <- function(tag) {
    local index = this.RocketFlights.find(tag);
    if(index != null) this.RocketFlights.remove(index);
};
D.cancelRocketFlight <- function(actor) {
    local s = this.state(actor), tag = s.RocketFlight;
    if(tag == null) return;
    tag.Cancelled = true;
    s.RocketFlight = null;
    this.forgetRocketFlight(tag);
    this.clearWarning(actor);
    this.removeMark(actor);
};
D.abandonRocketFlight <- function(tag) {
    tag.Cancelled = true;
    // Never resolve an old actor ID against a new battlefield.
    if(tag.Scene == ::Tactical.State) {
        local actor = ::Tactical.getEntityByID(tag.ActorID);
        if(actor != null && actor.getSkills().hasSkill("effects.afeix_douyu_core") && this.state(actor).RocketFlight == tag)
            this.cancelRocketFlight(actor);
    }
    this.forgetRocketFlight(tag);
};
D.cancelRocketFlights <- function(scene) {
    foreach(tag in clone this.RocketFlights) if(tag.Scene == scene) {
        this.abandonRocketFlight(tag);
    }
};
D.hasRocketFlight <- function(scene) {
    foreach(tag in this.RocketFlights) if(!tag.Cancelled && tag.Scene == scene) return true;
    return false;
};
D.landRocket <- function(tag) {
    if(!this.validRocketFlight(tag) || !tag.Launched) {
        this.abandonRocketFlight(tag);
        return false;
    }
    local actor = ::Tactical.getEntityByID(tag.ActorID);
    local s = this.state(actor);
    // Consume before callbacks: native hit reactions can end combat or kill
    // the boss. A late/repeated callback cannot resolve the same shot twice.
    tag.Cancelled = true;
    s.RocketFlight = null;
    this.forgetRocketFlight(tag);
    this.clearWarning(actor);
    if(tag.Tiles[0].IsVisibleForPlayer) ::Tactical.getCamera().quake(::createVec(0, -1), 4.0, 0.12, 0.25);
    local hitIDs = this.resolveArea(actor, tag.Tiles, "rocket");
    if(this.alive(actor)) this.resolveMark(actor, hitIDs);
    return true;
};
