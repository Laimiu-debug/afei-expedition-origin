// Personal story choices use ordinary campaign flags and never recreate actors.
local A=::AfeixExpedition;
A.blueStoryEligible <- function(key, checkPlace=true) {
    if(!(key in this.BlueStories) || !this.ideaSafe() || !this.ideaAlive(this.findCharacter("afei")))return false;
    local d=this.BlueStories[key],bro=this.findCharacter(d.owner);
    if(!this.ideaAlive(bro) || this.get("dead_"+d.owner,false) || this.get("departed_"+d.owner,false)
        || this.get("chronicle_done_"+key,false) || !this.get("growth_done_"+d.owner,false)
        || bro.getLevel()<d.level || this.personalBattles(bro)<d.battles)return false;
    if(checkPlace && (!this.canManage() || (d.place=="town" && this.currentTown()==null)))return false;
    if(d.previous!="") {
        if(!this.get("chronicle_done_"+d.previous,false)
            || this.get("ideas_wins")<this.get("blue_story_wins_"+d.previous)+d.winsAfterPrevious
            || this.worldNow()<this.get("blue_story_time_"+d.previous)+this.daysInSeconds(2))return false;
    }
    return true;
};
A.nextBlueStory <- function() {
    foreach(key in this.BlueStoryOrder)if(this.blueStoryEligible(key))return key;
    return "";
};
A.blueStoryScene <- function(key) {
    local d=clone this.BlueStories[key];
    if(d.previous!="") {
        local choice=this.get("chronicle_choice_"+d.previous,-1);
        if(this.get("chronicle_done_"+d.previous,false) && choice>=0 && choice<d.priorText.len())
            d.text+="\n\n"+d.priorText[choice];
    }
    return d;
};
A.resolveBlueStory <- function(key,choice,token) {
    if(typeof choice!="integer" || choice<0 || choice>1 || token!=this.get("ideas_active_token")
        || this.get("ideas_done_token")==token || !this.blueStoryEligible(key,false))
        return this.result(false,"这段经历尚未到来、已经记下，或当事人此刻不在队中。");
    local d=this.BlueStories[key],bro=this.findCharacter(d.owner);
    this.ideaMood([bro],0.25,d.title);
    this.set("chronicle_done_"+key,true);this.set("chronicle_choice_"+key,choice);
    this.set("blue_story_wins_"+key,this.get("ideas_wins"));this.set("blue_story_time_"+key,this.worldNow());
    this.set("ideas_done_token",token);this.set("ideas_chronicle_next",this.worldNow()+this.daysInSeconds(2));
    this.refreshAssets();return this.result(true,d.outcomes[choice]);
};
A.blueEndingChoices <- function() {
    local out={};
    foreach(owner,d in this.BlueEpilogues) {
        local choice=this.get("chronicle_choice_"+d.final,-1);
        if(this.get("chronicle_done_"+d.final,false) && choice>=0 && choice<2)out[owner]<-choice;
    }
    return out;
};
A.blueEndingText <- function(snapshot,key) {
    if(!(key in this.BlueEpilogues) || !("blueChoices" in snapshot) || !(key in snapshot.blueChoices)
        || !snapshot.retired || snapshot.living==0 || snapshot.states[key]!="alive")return null;
    local choice=snapshot.blueChoices[key];
    if(typeof choice!="integer" || choice<0 || choice>1)return null;
    return this.BlueEpilogues[key].choices[choice][snapshot.renown>=3000 || snapshot.crises>0 ? "good" : "lean"];
};
