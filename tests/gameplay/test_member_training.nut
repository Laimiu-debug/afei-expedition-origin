// Real production gating, unlike the explicitly legacy multi-skill effect fixtures.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::checks<-0;
function check(ok,label){if(!ok)throw "FAIL training: "+label;::checks++;}
function eq(a,b,label){check(a==b,label+" expected="+b+" actual="+a);}
A.canManage=function(){return !::state.tactical;};
A.findCharacter=function(k){foreach(a in ::state.actors)if(a.key==k)return a;return null;};
A.roster=function(){return ::state.actors;};
function learnedCount(a){local n=0;foreach(s in a.skills.m.Skills)if(s.getID().find(".afeix_member_")!=null)n++;return n;}
foreach(owner,keys in A.MemberSkills)foreach(key in keys){
    fresh();::state.tactical=false;
    local a=makeActor(owner);a.level=6;
    ::state.flags["growth_done_"+owner]<-true;A.syncMemberSkills(a);
    eq(learnedCount(a),0,key+" no skill before 7, even with story done");
    check(!A.chooseTraining(owner,key).ok,key+" rejects premature choice");
    a.level=7;check(A.chooseTraining(owner,key).ok,key+" selectable at 7");
    eq(learnedCount(a),1,key+" exactly one");
    foreach(other in keys){eq(A.catalogLearned(a,other),other==key,key+" mutual exclusion");check(!A.chooseTraining(owner,other).ok,key+" repeat/switch rejected");}
    eq(A.trainingRank(a,key),1,key+" initial rank");
    local d=A.MemberSkillDefs[key],s=a.skills.getSkillByID((d.active?"actives.":"trait.")+"afeix_member_"+key);
    check(s.getIcon()!=""&&s.getIconMini()!="",key+" full and mini icons");
    if(d.active)eq(s.m.FatigueCost,d.fatigue,key+" base fatigue");
    a.level=10;a.skills.update();eq(A.trainingRank(a,key),1,key+" rank at 10");
    a.level=11;::state.tactical=true;a.skills.update();eq(A.trainingRank(a,key),2,key+" auto rank at 11");
    if(d.active)eq(s.m.FatigueCost,::Math.max(0,d.fatigue-::Math.max(1,::Math.floor(d.fatigue*0.15).tointeger())),key+" upgraded cost");
    else {a.level=10;a.skills.update();local before=a.props.FatigueRecoveryRate;a.level=11;a.skills.update();eq(a.props.FatigueRecoveryRate,before,key+" mastery keeps native recovery separate");a.fatigue=20;local expected="specialized_mastery" in d&&d.specialized_mastery?20:19;A.balanceAfterTurnStart(a);eq(a.fatigue,expected,key+" mastery uses shared recovery budget");A.balanceAfterTurnStart(a);eq(a.fatigue,expected,key+" once per round");}
    for(local i=0;i<3;i++){A.syncMemberSkills(a);a.skills.update();}
    eq(learnedCount(a),1,key+" no extra skill or stacking at 11");
    local path="scripts/skills/"+(d.active?("extended" in d?"actives/afeix_catalog_active":"actives/afeix_member_active"):("extended" in d?"traits/afeix_catalog_passive":"traits/afeix_member_passive"));
    local saved=roundtrip(s,path);a.skills.removeAllByID(s.getID());a.skills.add(saved);A.syncMemberSkills(a);
    eq(A.trainingRank(a,key),2,key+" saved choice restores mastery");eq(learnedCount(a),1,key+" loaded one skill");
    ::state.tactical=false;local page=A.trainingLedgerPage({m={}},"train:"+owner);check(page.Options.len()<=6&&page.Text.find(d.name)!=null,key+" selected UI");
    ::state.origin=false;eq(A.trainingRank(a,key),0,key+" other origin inert");
}
// Legacy saves have no explicit choice: remove all previously granted options.
foreach(owner,keys in A.MemberSkills){
    fresh();local a=makeActor(owner);a.level=11;
    foreach(key in keys){local d=A.MemberSkillDefs[key],s=::new("scripts/skills/"+(d.active?("extended" in d?"actives/afeix_catalog_active":"actives/afeix_member_active"):("extended" in d?"traits/afeix_catalog_passive":"traits/afeix_member_passive")));s.configure(key);a.skills.add(s);}
    eq(learnedCount(a),3,owner+" legacy fixture");A.syncMemberSkills(a);A.syncMemberSkills(a);eq(learnedCount(a),0,owner+" legacy awaits deliberate choice");
    ::state.tactical=false;check(A.chooseTraining(owner,keys[2]).ok,owner+" third option requires no story");eq(A.trainingRank(a,keys[2]),2,owner+" late choice immediately mastered");
}
fresh();::state.tactical=false;local a=makeActor("tongzhu");a.level=7;
check(A.chooseTraining("tongzhu","bear_strike").ok,"standalone bear learned");::state.tactical=true;local enemy=makeActor("enemy",1,2);
check(active(a,"bear_strike").use(enemy.tile),"bear works with zero insight and no know_rules");
fresh();::state.tactical=false;a=makeActor("tongzhu");a.level=7;A.chooseTraining("tongzhu","cup_signal");::state.tactical=true;
check(active(a,"cup_signal").use(a.tile),"cup works independently");
fresh();::state.tactical=false;a=makeActor("xiaoyubeike");a.level=11;A.chooseTraining(a.key,"nicotine");::state.tactical=true;a.fatigue=40;
check(active(a,"nicotine").use(a.tile),"mastered nicotine");eq(a.fatigue,22,"nicotine improvement");check(!active(a,"nicotine").isUsable(),"mastery retains once per battle");
fresh();::state.tactical=false;a=makeActor("keke");a.level=7;A.chooseTraining(a.key,"breathe_easy");::state.tactical=true;equip(a,false,true);a.fatigue=20;
local ally=makeActor("ally",1),foe=makeActor("enemy",2,2),weapon=equip(foe);A.catalogReceived(ally,foe,weapon,false);eq(a.fatigue,16,"keke passive without pokemon");
A.catalogReceived(ally,foe,weapon,false);eq(a.fatigue,16,"keke passive round cap");
::state.round++;a.shield=null;A.catalogReceived(ally,foe,weapon,false);eq(a.fatigue,16,"keke shield required");
fresh();::state.tactical=false;a=makeActor("afei");a.level=11;A.syncMemberSkills(a);check(!A.chooseTraining("afei","nicotine").ok,"afei keeps independent promotion");eq(learnedCount(a),0,"afei no companion choices");
fresh();::state.tactical=false;a=makeActor("bottle");a.level=7;
local preview=A.trainingLedgerPage({m={}},"train_preview:bottle:bottle_breakthrough");eq(A.trainingChoice(a),"","preview does not select");eq(preview.Options.len(),2,"confirm and cancel");
::state.tactical=true;check(!A.chooseTraining("bottle","bottle_breakthrough").ok,"no learning in battle");
::state.tactical=false;check(!A.chooseTraining("bottle","loyalty").ok,"other member skill rejected");
foreach(owner,keys in A.MemberSkills){local b=makeActor(owner);b.level=7;}
for(local n=0;n<A.CharacterOrder.len();n+=4){local page=A.trainingLedgerPage({m={}},"training:"+n);check(page.Options.len()<=6,"native six-option limit");}
print("TESTS_PASSED="+::checks+"\n");
