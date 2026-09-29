// Native WeakTableRef forwards method calls through _get, but not the `in` operator.
// Exercise the real event buttons with the same actor references used by the game.
dofile("tests/gameplay/member_skill_fixture.nut");
dofile(".cache/afei-art/native-contract-fixture/weak_table_ref.nut");
dofile(".cache/afei-art/native-contract-fixture/event.nut");
::definitions["scripts/events/event"] <- ::event;
::Time.getVirtualTimeF <- function(){return 1000.0;};
local A=::AfeixExpedition,checks=0;
local check=function(ok,label){if(!ok)throw "FAIL native training: "+label;checks++;};
A.canManage=function(){return this.isOrigin()&&!::state.tactical;};
A.roster=function(){local r=[];foreach(a in ::state.actors)r.push(::WeakTableRef(a));return r;};
A.findCharacter=function(key){foreach(a in this.roster())if(this.characterId(a)==key)return a;return null;};
foreach(owner,keys in A.MemberSkills)foreach(key in keys){
    fresh();::state.tactical=false;local actor=makeActor(owner);actor.level=7;
    actor.skills.getActor=function(){return ::WeakTableRef(this.actor);};
    local ref=A.findCharacter(owner),d=A.MemberSkillDefs[key];
    check(!("getFlags" in ref)&&!("getLevel" in ref)&&ref.getLevel()==7,key+" native reference behavior");
    local ledger=clone loadDefinition("scripts/events/events/afeix_ledger_event");
    ledger.m=clone ledger.m;ledger.setdelegate(getroottable());ledger.create();
    ledger.m.AutoPage="training";ledger.fire();
    check(ledger.m.ActiveScreen.Options[0].Text.find("待选择")!=null,key+" starts unchosen");
    check(ledger.processInput(0)&&ledger.m.ActiveScreen.ID=="train:"+owner,key+" correct member button");
    check(ledger.processInput(keys.find(key))&&ledger.m.ActiveScreen.ID=="train_preview:"+owner+":"+key,key+" correct preview");
    check(A.trainingChoice(ref)=="",key+" preview does not choose");
    check(ledger.processInput(0)&&actor.getFlags().get("afeix_training_choice")==key,key+" confirmation persists flag");
    check(A.trainingChoice(ref)==key,key+" chosen flag readable through native reference");
    check(A.trainingRank(ref,key)==1&&A.catalogHas(ref,key),key+" learned skill enabled");
    check(ledger.m.ActiveScreen.Text.find(d.name)!=null&&ledger.m.ActiveScreen.Options.len()==1,key+" selected detail page");
    ledger.processInput(0);
    check(ledger.m.ActiveScreen.Options[0].Text.find(d.name)!=null&&ledger.m.ActiveScreen.Options[0].Text.find("待选择")==null,key+" list refreshes after confirmation");
    check(!A.chooseTraining(owner,keys[(keys.find(key)+1)%3]).ok,key+" cannot overwrite saved choice");
    actor.level=11;::state.tactical=true;actor.skills.update();
    check(A.trainingRank(ref,key)==2,key+" mastery through native skill-container actor");
    local skill=actor.skills.getSkillByID((d.active?"actives.":"trait.")+"afeix_member_"+key);
    check(skill.getDescription().find("已精通")!=null,key+" mastery tooltip");
    if(d.active)check(skill.m.FatigueCost==A.trainingFatigue(ref,key),key+" mastery fatigue");
    // Existing saved choices are sufficient to restore skills previously removed by a bad read.
    actor.skills.removeAllByID(skill.getID());A.syncMemberSkills(ref);A.syncMemberSkills(ref);
    check(A.catalogHas(ref,key)&&actor.skills.m.Skills.len()==1,key+" saved choice restores exactly one skill");
    ::state.tactical=false;ledger.clear();ledger.m.AutoPage="training";ledger.fire();
    check(ledger.m.ActiveScreen.Options[0].Text.find(d.name)!=null,key+" reopen retains selected skill");
    ::state.origin=false;check(A.trainingRank(ref,key)==0,key+" other origin inert");
}
print("TESTS_PASSED="+checks+"\n");
