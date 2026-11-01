// Helpers do not register stories. Keep authored content in this DLC only.
foreach (part in ["story_helpers", "mocha_river_song", "damou_benz"])
    ::include("scripts/mods/afeix_dlc_events/" + part);
