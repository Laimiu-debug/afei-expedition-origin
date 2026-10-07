local A = ::AfeixExpedition;
A.characterBackgroundPath <- function(key) { return "afeix_" + key + "_background"; };
A.configureCharacterBackground <- function(background, key, converted = false) {
    local data = this.Characters[key], story = this.CharacterBackgrounds[key];
    background.m.Name = story.name + (converted ? "（已皈依）" : "");
    background.m.BackgroundDescription = story.description;
    background.m.RawDescription = story.description + "\n\n" + data.description;
    if (converted) {
        local text = "后来，" + data.name + "皈依了达库尔。夜里祷告时念的已经是另一套词，可第二天集合，照样站在原来的位置上。";
        background.m.BackgroundDescription += "\n\n" + text;
        background.m.RawDescription += "\n\n" + text;
    }
    background.m.Description = background.m.RawDescription;
    background.m.DailyCost = data.wage;
};
A.syncCharacterBackground <- function(bro) {
    if (!this.isOrigin()) return false;
    local key = this.characterId(bro);
    if (!(key in this.CharacterBackgrounds)) return false;
    local background = bro.getBackground();
    if (background == null) return false;
    local data = this.Characters[key], id = background.getID();
    local nativeID = "background." + data.background.slice(0, data.background.len() - 11);
    if (id == nativeID) {
        // Do not rebuild starting values, equipment, traits, talents or levels.
        local replacement = ::new("scripts/skills/backgrounds/" + this.characterBackgroundPath(key));
        replacement.m.IsNew = false;
        replacement.m.Level = background.m.Level;
        replacement.m.DailyCostMult = background.m.DailyCostMult;
        bro.getSkills().removeByID(id);
        bro.getSkills().add(replacement);
        background = replacement;
        id = background.getID();
    }
    if (id != "background.afeix_" + key && id != "background.converted_cultist") return false;
    this.configureCharacterBackground(background, key, id == "background.converted_cultist");
    return true;
};
