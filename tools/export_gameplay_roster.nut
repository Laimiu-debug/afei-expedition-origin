// Load the real entry point without executing queued engine hooks. Export only
// data: no game process, save, installation or asset generation is involved.
::include <- function(path) { dofile("src/" + path + ".nut"); };
::mods_registerMod <- function(id,version,name) {};
::mods_queue <- function(id,dependencies,callback) {};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");

function quoteJson(value) {
    local result = "\"";
    for (local i=0; i<value.len(); i++) {
        local c = value.slice(i,i+1);
        if (c=="\"") result += "\\\"";
        else if (c=="\\") result += "\\\\";
        else if (c=="\n") result += "\\n";
        else if (c=="\r") result += "\\r";
        else if (c=="\t") result += "\\t";
        else result += c;
    }
    return result + "\"";
}
function json(value) {
    local kind=typeof value;
    if(kind=="null")return "null";
    if(kind=="string")return quoteJson(value);
    if(kind=="integer" || kind=="float")return value.tostring();
    if(kind=="bool")return value ? "true" : "false";
    local result=kind=="array" ? "[" : "{", first=true;
    foreach(key,item in value) {
        if(!first)result+=",";
        first=false;
        if(kind=="table")result+=quoteJson(key)+":";
        result+=json(item);
    }
    return result+(kind=="array" ? "]" : "}");
}
local A=::AfeixExpedition, characters=[];
foreach(key in A.CharacterOrder) {
    local data=clone A.Characters[key]; data.key <- key;
    data.baseBackground <- data.background;
    data.background = A.characterBackgroundPath(key);
    data.backgroundName <- A.CharacterBackgrounds[key].name;
    data.backgroundDescription <- A.CharacterBackgrounds[key].description;
    characters.push(data);
}
print("ROSTER_JSON_BEGIN\n"+json({version=A.Version,schema=A.Schema,rosterMax=A.RosterMax,combatMax=A.CombatMax,chapters=A.Chapters,encounterRequirements=A.EncounterRequirements,characters=characters,promotionTalents=A.PromotionTalents,memberSkills=A.MemberSkills,memberSkillDefs=A.MemberSkillDefs,ideaScenes=A.IdeaScenes,chronicles=A.Chronicles})+"\nROSTER_JSON_END\n");
