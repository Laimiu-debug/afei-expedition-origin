local A = ::AfeixExpedition;
A.WorldPortraitBrush <- "afeix_world_afei";
A.syncWorldPartyArt <- function() {
    if (!this.isOrigin() || ::World.State == null) return false;
    local party = ::World.State.getPlayer();
    if (party == null || !party.hasSprite("body")) return false;
    // Keep the native camp silhouette even if a renown event refreshes Look
    // while camping. Flag visibility, fire and lighting stay native.
    if (::World.Assets.isCamping()) {
        party.getSprite("body").setBrush("world_player_camp_01");
        return true;
    }
    if (!::doesBrushExist(this.WorldPortraitBrush)) return false;
    party.getSprite("body").setBrush(this.WorldPortraitBrush);
    // Enable the native party movement's direction mirroring. No movement
    // callback, speed, path or banner property is replaced.
    party.setMirrored(true);
    return true;
};
