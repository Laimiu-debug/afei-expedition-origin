local V = ::AfeixVoiceDLC;
V.isAfei <- function(actor) {
    return this.HurtSounds.len() > 0 && ::AfeixExpedition.isOrigin()
        && ::AfeixExpedition.characterId(actor) == "afei";
};

::mods_hookExactClass("entity/tactical/player", function(o) {
    // These are inherited members. Add overrides to player itself, so the
    // shared human/actor parents and all enemies retain their native methods.
    local nativePlaySound = ::mods_getMember(o, "playSound");
    o.playSound <- function(kind, volume, pitch = 1.0) {
        local voice = ::AfeixVoiceDLC;
        if (kind != this.Const.Sound.ActorEvent.DamageReceived || !voice.isAfei(this))
            return nativePlaySound.bindenv(this)(kind, volume, pitch);
        local last = "afeixVoiceLastHurt" in this.m ? this.m.afeixVoiceLastHurt : "";
        local choices = [];
        foreach (sound in voice.HurtSounds)
            if (voice.HurtSounds.len() == 1 || sound != last) choices.push(sound);
        local sound = choices[this.Math.rand(0, choices.len() - 1)];
        // Retain native damage/settings volume; preserve the speaker's pitch.
        this.Sound.play(sound, volume * voice.VolumeMult, this.getPos(), 1.0);
        this.m.afeixVoiceLastHurt <- sound;
    };
    local nativeLoadResources = ::mods_getMember(o, "loadResources");
    o.loadResources <- function() {
        local result = nativeLoadResources.bindenv(this)();
        if (::AfeixVoiceDLC.isAfei(this))
            foreach (sound in ::AfeixVoiceDLC.HurtSounds) this.Tactical.addResource(sound);
        return result;
    };
});
