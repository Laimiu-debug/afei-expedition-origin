// Native human playback and actor resource loading, with engine services stubbed.
local checks = 0;
function expect(value, message) { if (!value) throw "FAIL " + message; checks++; }
::Const <- { Bodies = { AllMale = [] }, HumanSounds = [{ Volume = 1.25 }],
    Sound = { ActorEvent = { DamageReceived = 0, Death = 1, NoDamageReceived = 2, COUNT = 3 } } };
::inherit <- function(path, child) { return child; };
::Math <- { rand = function(low, high) { return low; } };
::played <- [];
::resources <- [];
::Sound <- { play = function(sound, volume, pos, pitch) { ::played.push([sound, volume, pos, pitch]); } };
::Tactical <- { addResource = function(path) { ::resources.push(path); } };
dofile("native/human.nut");
dofile("native/voice_resources.nut");
::origin <- true;
::AfeixExpedition <- { Version = 54,
    isOrigin = function() { return ::origin; },
    characterId = function(actor) { return actor.key; } };
::registered <- [];
::queued <- null;
::hooks <- [];
::logs <- [];
::mods_registerMod <- function(id, version, name) { ::registered.push([id, version, name]); };
::mods_queue <- function(id, dependencies, callback) {
    expect(id == "mod_afeix_dlc_afei_voice", "independent Mod ID");
    expect(dependencies == "mod_afeix_expedition(>=36), >mod_afeix_expedition", "required main mod and load order");
    ::queued = callback;
};
::include <- function(path) { dofile("src/" + path + ".nut"); };
::logInfo <- function(message) { ::logs.push(message); };
::mods_hookExactClass <- function(path, callback) {
    expect(path == "entity/tactical/player", "hook only the player class");
    ::hooks.push(callback);
};
::mods_getMember <- function(object, key) {
    while (!(key in object)) object = object[object.SuperName];
    return object[key];
};

dofile("src/scripts/!mods_preload/mod_afeix_dlc_afei_voice.nut");
expect(::registered.len() == 1 && ::registered[0][1] == 3, "separate registration and version");
::queued();
local configured = ::AfeixVoiceDLC.HurtSounds;
if (configured.len() == 0) {
    expect(::hooks.len() == 0 && ::logs.len() == 1, "missing clips keep native behavior without hooks");
    dofile("src/scripts/mods/afeix_dlc_afei_voice/hooks.nut");
}
expect(::hooks.len() == 1, "one independent hook");
::queued();
expect(::hooks.len() == 1, "repeated initialization does not duplicate playback");
::AfeixVoiceDLC.HurtSounds = ["sounds/afeix_dlc_afei_voice/test_01.wav", "sounds/afeix_dlc_afei_voice/test_02.wav"];
local nativeHuman = { playSound = ::human.playSound, SuperName = "actor",
    actor = { loadResources = ::nativeVoiceResources.loadResources } };
local playerClass = { SuperName = "human", human = nativeHuman };
::hooks[0](playerClass);
expect(!("playSound" in nativeHuman.actor) && nativeHuman.playSound == ::human.playSound,
    "shared human/actor parents untouched by inherited-member overrides");
function player(key) {
    local actor = { key = key, name = "阿飞", m = { VoiceSet = 0, SoundPitch = 0.95,
        Sound = [["native_hurt"], ["native_death"], ["native_armor_grunt"]],
        Skills = { addResources = function() { ::resources.push("native_skill"); } } },
        getPos = function() { return "tile"; }, hasSprite = function(name) { return false; } };
    actor.playSound <- playerClass.playSound;
    actor.loadResources <- playerClass.loadResources;
    actor.setdelegate(getroottable());
    return actor;
}
local afei = player("afei");
afei.name = "renamed captain";
afei.loadResources();
expect(::resources.len() == 6 && ::resources[0] == "native_hurt" && ::resources[3] == "native_skill",
    "native sound and skill resources retained");
expect(::resources[4] == ::AfeixVoiceDLC.HurtSounds[0] && ::resources[5] == ::AfeixVoiceDLC.HurtSounds[1],
    "all custom clips preloaded for Afei");
afei.playSound(0, 0.5, 0.95);
expect(::played.len() == 1 && ::played[0][0] == ::AfeixVoiceDLC.HurtSounds[0], "Afei identity survives rename and emits one custom sound");
expect(::played[0][1] == 0.5 && ::played[0][2] == "tile" && ::played[0][3] == 1.0,
    "incoming settings/damage volume and position retained, voice pitch preserved");
expect(afei.m.Sound[0][0] == "native_hurt" && afei.m.SoundPitch == 0.95, "no mutation of native voice arrays or pitch");
afei.playSound(0, 0.5);
expect(::played[1][0] != ::played[0][0], "adjacent hits use different clips");
afei.playSound(1, 0.5, 0.95);
expect(::played[2][0] == "native_death" && ::played[2][1] == 0.625 && ::played[2][3] == 0.95, "death uses native human playback");
afei.playSound(2, 0.5, 0.95);
expect(::played[3][0] == "native_armor_grunt", "armor-only grunt uses native human playback");
local other = player("xiaogui");
other.playSound(0, 0.5, 0.9);
expect(::played[4][0] == "native_hurt" && ::played[4][1] == 0.625 && ::played[4][3] == 0.9, "another character named Afei keeps native voice");
::resources.clear(); other.loadResources();
expect(::resources.len() == 4, "other characters do not preload custom sounds");
::origin = false;
afei.playSound(0, 0.5);
expect(::played[5][0] == "native_hurt", "other origins keep native voice");
::resources.clear(); afei.loadResources();
expect(::resources.len() == 4, "other origins preload only native resources");
::origin = true;
::AfeixVoiceDLC.HurtSounds = ["single_clip"];
afei.playSound(0, 0.5); afei.playSound(0, 0.5);
expect(::played[6][0] == "single_clip" && ::played[7][0] == "single_clip", "single clip never loops waiting for a different sound");
::AfeixVoiceDLC.HurtSounds = [];
afei.playSound(0, 0.5);
expect(::played[8][0] == "native_hurt", "empty configuration falls back to native even after hook registration");
::resources.clear(); afei.loadResources();
expect(::resources.len() == 4, "empty configuration leaves native resource loading intact");
expect(!("onSerialize" in playerClass) && !("onDeserialize" in playerClass), "no saved-class or serialization changes");
local restored = player("afei");
expect(!("afeixVoiceLastHurt" in restored.m), "new/restored actors need no saved DLC state");
print("TESTS_PASSED=" + checks + "\n");
