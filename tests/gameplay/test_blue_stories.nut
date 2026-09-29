// Real preload, event choice dispatch, personal battle counters and ending hooks.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition,n=0,serial=0;
local check=function(v,label){++n;if(!v)throw "FAIL blue stories: "+label;};
::blueTest <- {now=100000,safe=true,town={},start=0,enemies=[],renown=100,crises=0};
::World <- {State={getCombatStartTime=function(){return ::blueTest.start;},
    getPlayer=function(){return {getPos=function(){return {};}};}},
    getAllEntitiesAtPos=function(p,r){return ::blueTest.enemies;},getTime=function(){return {Days=30};},
    Assets={getBusinessReputation=function(){return ::blueTest.renown;},getName=function(){return "black flag";}},
    Statistics={getFlags=function(){return {get=function(k){return ::blueTest.crises;}};}}};
A.worldNow=function(){return ::blueTest.now;};A.daysInSeconds=function(d){return 86400*d;};
A.canManage=function(){return ::blueTest.safe;};A.currentTown=function(){return ::blueTest.town;};
A.refreshAssets=function(){};
A.roster=function(){return ::state.actors;};
A.findCharacter=function(k){foreach(a in this.roster())if(a.key==k)return a;return null;};
local actor=function(key){local a=makeActor(key);a.level=7;a.stats<-{Battles=8};a.mood<-0.0;
    a.getLifetimeStats<-function(){return this.stats;};a.improveMood<-function(v,r){this.mood+=v;};return a;};
local reset=function(){fresh();::state.tactical=false;::blueTest.now=100000;::blueTest.safe=true;
    ::blueTest.town={};::blueTest.start=0;::blueTest.enemies=[];::blueTest.renown=100;::blueTest.crises=0;};
local choose=function(key,choice){A.set("ideas_active_token",++serial);return A.resolveIdea(key,choice,serial);};
try {
    check(A.BlueStoryOrder.len()==4,"four events loaded by production preload");
    foreach(pair in [["xiaohani","luoyike_cache","luoyike_home"],["yanzi","yanzi_signatures","yanzi_own_name"]]) {
        local owner=pair[0],first=pair[1],last=pair[2];
        reset();local afei=actor("afei"),bro=actor(owner),other=actor("keke");
        check(!A.blueStoryEligible(first),"growth must be completed: "+owner);
        A.set("growth_done_"+owner,true);bro.level=3;
        check(!A.blueStoryEligible(first),"level four required");bro.level=4;bro.stats.Battles=4;
        A.set("ideas_wins",100);check(!A.blueStoryEligible(first),"company victories do not replace personal battles");
        bro.stats.Battles=5;check(A.blueStoryEligible(first)&&A.nextChronicle()==first,"first scene selected when ready");
        A.set("ideas_chronicle_next",::blueTest.now+1);check(A.nextChronicle()=="","shared story cooldown enforced");A.set("ideas_chronicle_next",0);
        ::blueTest.safe=false;check(!A.blueStoryEligible(first),"no scheduler event on unsafe travel");::blueTest.safe=true;
        ::blueTest.town=null;check(A.blueStoryEligible(first)==(owner=="xiaohani"),"town requirement differs per scene");::blueTest.town={};
        ::state.origin=false;check(!A.blueStoryEligible(first),"other origins excluded");::state.origin=true;
        ::state.tactical=true;check(!A.blueStoryEligible(first),"combat excluded");::state.tactical=false;
        ::blueTest.start=1;check(!A.blueStoryEligible(first),"combat transition excluded");::blueTest.start=0;
        ::blueTest.enemies=[{isAlive=function(){return true;},isAlliedWithPlayer=function(){return false;},getTroops=function(){return [1];}}];
        check(!A.blueStoryEligible(first),"nearby enemies excluded");::blueTest.enemies=[];
        afei.alive=false;check(!A.blueStoryEligible(first),"Afei must survive");afei.alive=true;
        bro.dying=true;check(!A.blueStoryEligible(first),"dying owner excluded");bro.dying=false;
        foreach(prefix in ["dead_","departed_"]){A.set(prefix+owner,true);check(!A.blueStoryEligible(first),"absent owner not recreated");A.set(prefix+owner,false);}
        ::state.actors.remove(1);check(!A.blueStoryEligible(first),"missing owner excluded");::state.actors.push(bro);
        A.set("ideas_active_token",++serial);
        foreach(c in [-1,2,0.5,"0"])check(!A.resolveIdea(first,c,serial).ok&&bro.mood==0,"invalid choice has no side effects");
        check(!A.resolveIdea(first,0,serial+1).ok,"stale event token rejected");
        local event={m={Idea=first,Token=serial,Outcome=""}},screen=A.ideaScreen(event,"opening");
        check(screen.Options.len()==3&&screen.Text.find(A.BlueStories[first].text)!=null,"both choices and defer action in event UI");
        check(screen.Options[2].getResult(event)==0&&!A.get("chronicle_done_"+first,false),"defer keeps story pending");
        ::blueTest.safe=false;::blueTest.town=null;
        check(screen.Options[0].getResult(event)=="result","native event pause does not reject an already-open event");
        check(event.m.Outcome==A.BlueStories[first].outcomes[0]&&bro.mood==0.25&&afei.mood==0&&other.mood==0,"outcome and mood belong only to owner");
        check(!A.resolveIdea(first,1,serial).ok&&bro.mood==0.25,"duplicate callback cannot change choice or grant mood");
        ::blueTest.safe=true;::blueTest.town={};bro.level=7;bro.stats.Battles=8;
        check(!A.blueStoryEligible(last),"second scene cannot immediately follow first");
        A.set("ideas_wins",102);check(!A.blueStoryEligible(last),"two wins still need two days");
        ::blueTest.now+=172800;A.set("ideas_wins",101);check(!A.blueStoryEligible(last),"two days still need two wins");
        A.set("ideas_wins",102);check(A.blueStoryEligible(last),"second scene opens after full gates");
        bro.level=6;check(!A.blueStoryEligible(last),"second scene level gate");bro.level=7;
        bro.stats.Battles=7;check(!A.blueStoryEligible(last),"second scene personal battle gate");bro.stats.Battles=8;
        check(A.chronicleScene(last).text.find(A.BlueStories[last].priorText[0])!=null,"first choice carried into second scene");
        check(choose(last,1).ok&&A.blueEndingChoices()[owner]==1,"final branch persisted");
        local oldMood=bro.mood,saved=clone ::state.flags;
        ::state.flags={};dofile("src/scripts/mods/afeix/blue_story_data.nut");dofile("src/scripts/mods/afeix/blue_stories.nut");::state.flags=saved;
        check(!A.blueStoryEligible(first)&&!A.blueStoryEligible(last)&&A.blueEndingChoices()[owner]==1,"reload retains completion and choices");
        local page=A.ideasLedgerPage({m={Notice=""}},"ideas_read:"+last);
        check(page.Text.find(A.BlueStories[last].outcomes[1])!=null&&page.Text.find(A.BlueStories[last].priorText[0])!=null&&page.Options.len()==1&&bro.mood==oldMood,"history retains branch and is read-only");
        local snap=A.endingSnapshot(true),ep=A.BlueEpilogues[owner].choices[1];
        check(A.companyEndingText(snap).find(ep.lean)!=null,"living retired owner gets selected modest ending");
        A.set("chronicle_choice_"+last,0);check(A.blueEndingText(snap,owner)==ep.lean,"snapshot detached from later campaign changes");
        snap.renown=3000;check(A.blueEndingText(snap,owner)==ep.good,"renown selects prosperous variant");
        snap.renown=100;snap.crises=1;check(A.blueEndingText(snap,owner)==ep.good,"crisis victory selects prosperous variant");
        snap.retired=false;check(A.blueEndingText(snap,owner)==null,"defeat does not fabricate peaceful retirement");snap.retired=true;
        snap.living=0;check(A.blueEndingText(snap,owner)==null,"wiped company cannot use retirement");snap.living=3;
        foreach(s in ["dead","departed","unknown"]){snap.states[owner]=s;check(A.blueEndingText(snap,owner)==null,"state remains authoritative: "+s);}
        snap.states[owner]="alive";snap.blueChoices[owner]=3;check(A.blueEndingText(snap,owner)==null,"invalid persisted choice uses normal ending");
        delete snap.blueChoices;check(A.blueEndingText(snap,owner)==null,"old snapshot without new flags remains valid");
        foreach(initial in [0,1])foreach(finalChoice in [0,1]) {
            reset();actor("afei");bro=actor(owner);A.set("growth_done_"+owner,true);
            check(choose(first,initial).ok,"first branches complete");::blueTest.now+=172800;A.set("ideas_wins",2);
            check(A.chronicleScene(last).text.find(A.BlueStories[last].priorText[initial])!=null,"each prior choice echoed");
            check(choose(last,finalChoice).ok&&A.blueEndingChoices()[owner]==finalChoice,"all four paths complete");
            check(A.companyEndingText(A.endingSnapshot(true)).find(A.BlueEpilogues[owner].choices[finalChoice].lean)!=null,"all paths reach chosen ending");
        }
    }
    reset();actor("afei");actor("xiaohani");actor("yanzi");
    check(A.blueEndingChoices().len()==0,"old save with no story flags uses base endings");
    foreach(owner in ["xiaohani","yanzi"])A.set("growth_done_"+owner,true);
    choose("luoyike_cache",1);check(!A.get("chronicle_done_yanzi_signatures",false),"one member does not complete the other's arc");
    ::blueTest.now+=172800;check(A.nextChronicle()=="yanzi_signatures","other member can start while first waits for wins");
    print("BLUE_PERSONAL_STORIES_PASS\nTESTS_PASSED="+n+"\n");
} catch(error){print(error+"\n");throw error;}
