dofile("tests/gameplay/douyu_combat_fixture.nut");
local D=::AfeixExpedition.Douyu;
reset();local b=boss(), t=actor("tank",1);turn(b);
check(b.props.IsImmuneToStun&&b.props.IsImmuneToRoot&&b.props.IsImmuneToRotation,"large boss control resistance");
check(b.props.IsImmuneToFearAndPanic,"origin mental targeting has an explicit boss immunity slot");
check(!("IsImmuneToBleeding" in b.props)||!b.props.IsImmuneToBleeding,"does not disable bleeding builds");
check(special(b,"mark").use(t.tile),"native mark usable");eq(b.ap,0,"telegraph consumes turn");
eq(::state.attacks.len(),0,"mark does no immediate damage");
check(t.skills.hasSkill("effects.afeix_douyu_mark"),"target has readable warning");
turn(b);eq(::state.attacks.len(),1,"mark resolves next boss turn");eq(::state.attacks[0].kind,"actives.afeix_douyu_mark","correct delayed attack");
check(!t.skills.hasSkill("effects.afeix_douyu_mark"),"mark removed after attack");
D.startTurn(b);eq(::state.attacks.len(),1,"resumed turn cannot repeat hit");
reset();b=boss();t=actor("ranged",3);turn(b);special(b,"mark").use(t.tile);t.pos=4;turn(b);
eq(::state.attacks.len(),0,"range four evades marked bite");
reset();b=boss();t=actor("swapped",3);local rescuer=actor("rescuer",1);turn(b);special(b,"mark").use(t.tile);
t.pos=1;rescuer.pos=3;turn(b);eq(::state.attacks.len(),1,"swap inside range does not remove mark or prevent bite");
eq(::state.attacks[0].target,t.id,"mark follows original actor after swap");
reset();b=boss();t=actor("fallen",2);turn(b);special(b,"mark").use(t.tile);t.alive=false;turn(b);
eq(::state.attacks.len(),0,"dead mark safely ignored");
reset();b=boss();t=actor("front",2);local flank=actor("flank",3);t.neighbors=[flank];turn(b);
check(special(b,"rocket").use(t.tile),"native rocket affordable and targets terrain");
eq(b.ap,0,"rocket uses nine AP");eq(::state.attacks.len(),0,"no immediate rocket damage");
check(t.tile.Properties.IsMarkedForImpact&&flank.tile.Properties.IsMarkedForImpact,"all affected tiles visibly marked");
turn(b);eq(::state.attacks.len(),2,"rocket hits occupants of fixed target tiles");
check(!t.tile.Properties.IsMarkedForImpact&&!flank.tile.Properties.IsMarkedForImpact,"impact clears warning tiles");
check(b.props.DamageReceivedTotalMult>1.34&&b.props.DamageReceivedTotalMult<1.36,"impact opens damage window");
check(!special(b,"mark").isUsable()&&!special(b,"rocket").isUsable(),"no special during exposed turn");
turn(b);eq(b.props.DamageReceivedTotalMult,1.0,"damage window expires at next own turn");
reset();b=boss();t=actor("evader",2);turn(b);special(b,"rocket").use(t.tile);t.tile.IsOccupiedByActor=false;
turn(b);eq(::state.attacks.len(),0,"empty marked tile is safe after moving");
reset();b=boss();t=actor("reflector",2);flank=actor("second",3);t.neighbors=[flank];turn(b);
b.hp=2400;turn(b);special(b,"rocket").use(t.tile);
special(b,"rocket").attackEntity=function(user,target,diversion=true) {
    ::state.attacks.push({target=target.id}); user.alive=false;user.placed=false;
    user.skills.getSkillByID("effects.afeix_douyu_core").onDeath(0);return true;
};
turn(b);eq(::state.attacks.len(),1,"source death during first impact stops remaining attacks");
check(!t.skills.hasSkill("effects.afeix_douyu_mark")&&!flank.tile.Properties.IsMarkedForImpact,"source death clears combo and remaining warning tiles");
reset();b=boss();t=actor("archer",4);turn(b);special(b,"rocket").use(t.tile);
D.interrupt(b,t,399,300);check(D.state(b).Charging,"699 damage insufficient");
D.interrupt(b,t,1,0);check(!D.state(b).Charging,"700 combined actual damage interrupts");
eq(D.state(b).BlastTiles.len(),0,"interrupt clears queued blast");
check(!t.tile.Properties.IsMarkedForImpact,"interrupt clears danger flag");
turn(b);eq(::state.attacks.len(),0,"interrupted blast never fires");
check(!special(b,"rocket").isUsable()&&!special(b,"barrage").isUsable()&&!special(b,"mark").isUsable(),"interruption reserves next own turn for melee");
eq(b.props.DamageReceivedTotalMult,1.0,"interruption vulnerability still expires on next own turn");
local recoveryAdjacent=actor("recoveryAdjacent",1);
check(special(b,"bite").use(recoveryAdjacent.tile),"melee remains usable during interrupted-special recovery");
eq(b.ap,5,"recovery bite spends normal AP");
check(special(b,"bite").use(recoveryAdjacent.tile),"native AP allows second recovery bite");
eq(b.ap,1,"recovery attacks do not grant extra AP");
turn(b);check(special(b,"mark").isUsable(),"special recovery expires after one melee turn");
reset();b=boss();t=actor("fighter",1);local ally=actor("bossAlly",2,2);turn(b);special(b,"rocket").use(t.tile);
D.interrupt(b,ally,1000,1000);check(D.state(b).Charging,"allied damage cannot interrupt");
D.interrupt(b,t,700,0);check(!D.state(b).Charging,"melee damage interrupts equally");
reset();b=boss();t=actor("target",2);turn(b);b.hp=2400;turn(b);
check(D.state(b).ComboPending&&D.state(b).Phase2,"half health unlocks one combo");
eq(b.props.DamageTotalMult,1.2,"half health increases attack damage without extra actions");
check(special(b,"rocket").use(t.tile),"combo rocket usable through cooldown");
check(D.state(b).Charging&&D.state(b).MarkID==t.id,"combo preannounces blast and mark");
turn(b);eq(::state.attacks.len(),1,"combo never double hits same actor");
check(!D.state(b).ComboPending&&!t.skills.hasSkill("effects.afeix_douyu_mark"),"combo and warning consumed");
turn(b);check(!D.state(b).ComboPending,"combo cannot repeatedly trigger at low health");
reset();b=boss();t=actor("comboEvader",2);turn(b);b.hp=2399;turn(b);special(b,"rocket").use(t.tile);
t.tile.IsOccupiedByActor=false;t.pos=4;turn(b);eq(::state.attacks.len(),0,"combo fully countered by movement");
reset();b=boss();t=actor("comboMarked",2);turn(b);b.hp=2399;turn(b);special(b,"rocket").use(t.tile);
D.interrupt(b,t,0,700);check(!t.skills.hasSkill("effects.afeix_douyu_mark")&&D.state(b).MarkID==0,"interrupt also cancels combo mark");
reset();b=boss();t=actor("barrageTarget",2);local f1=actor("friend1",3),f2=actor("friend2",4),f3=actor("friend3",5);t.neighbors=[f1,f2,f3];turn(b);
check(special(b,"barrage").use(t.tile),"barrage has working native skill");
eq(::state.attacks.len(),0,"barrage has no unannounced immediate damage");
check(D.state(b).Charging&&t.tile.Properties.IsMarkedForImpact,"barrage leaves a visible ground warning");
turn(b);eq(::state.attacks.len(),3,"delayed barrage affects maximum three enemies");
eq(t.moraleChecks,1,"pressure has one mental morale check");eq(t.fatigue,10,"pressure adds finite fatigue");
eq(t.props.MeleeSkillMult,0.9,"pressure applies one ten percent penalty");
D.pressure(t);eq(t.fatigue,10,"pressure cannot stack fatigue");eq(t.moraleChecks,1,"pressure cannot stack morale checks");
t.skills.getSkillByID("effects.afeix_douyu_pressure").onTurnEnd();t.skills.update();eq(t.props.MeleeSkillMult,1.0,"pressure expires after actor turn");
check(!special(b,"barrage").isUsable(),"barrage retains its cooldown after impact");
reset();b=boss();t=actor("barrageEvader",2);turn(b);special(b,"barrage").use(t.tile);
t.tile.IsOccupiedByActor=false;turn(b);eq(::state.attacks.len(),0,"movement avoids delayed barrage");
eq(t.fatigue,0,"avoided barrage also avoids fatigue pressure");
reset();b=boss();t=actor("adjacent",1);turn(b);check(special(b,"bite").use(t.tile),"native melee bite connected");
eq(::state.attacks[0].min,110,"bite damage follows native properties hook");eq(b.ap,5,"native four AP bite cost");
eq(b.fatigue,12,"native bite fatigue cost");
check(!special(b,"bite").use(actor("distant",3).tile),"bite respects native melee range");
// Production custom AI: evaluation does not attack; camera and execute do.
::definitions["scripts/ai/tactical/behavior"] <- {m={IsFirstExecuted=false,SoundOnUse=[],ID=0,Order=0},create=function(){},
    spawnOverlay=function(...){},spawnAttackEffect=function(...){},
    getAgent=function(){return this.m.Agent;},getProperties=function(){return this.m.Agent.props;},
    queryTargetsInMeleeRange=function(min,max,level){local ret=[];foreach(a in ::state.actors)
        if(a.faction!=this.m.Agent.actor.faction&&a.pos>=min&&a.pos<=max)ret.push(a);return ret;}};
reset();b=boss();t=actor("AI target",2);turn(b);
local ai=::new("scripts/mods/afeix/douyu_ai");
ai.m.Agent <- {actor=b,props={BehaviorMult=[1.0,1.0,1.0]},actions=0,cameras=0,
    adjustCameraToTarget=function(tile){this.cameras++;},declareAction=function(){this.actions++;},declareEvaluationDelay=function(v){}};
check(ai.onEvaluate(b)>1000,"AI chooses special before movement");
eq(ai.m.Skill.getID(),"actives.afeix_douyu_rocket","first turn AI chooses rocket");eq(b.ap,9,"AI evaluation spends no AP");
ai.m.IsFirstExecuted=true;check(!ai.onExecute(b),"native-style camera adjustment yields first execute");
eq(b.ap,9,"camera stage spends no AP");check(ai.onExecute(b),"second execute uses skill and completes behavior");
eq(b.ap,0,"AI executes actual native costs");eq(ai.m.Agent.actions,1,"AI declares action delay");
check(D.state(b).Charging,"AI leaves working delayed attack");eq(ai.onEvaluate(b),0,"AI cannot loop specials at zero AP");
turn(b);eq(ai.onEvaluate(b),0,"AI respects post-rocket exposure");turn(b);
check(ai.onEvaluate(b)>1000,"AI resumes after exposed turn");
check(ai.m.Skill.getID()!="actives.afeix_douyu_rocket","AI rotates specials through rocket cooldown");
// Production enemy create registers its own attack and native movement AI.
::definitions["scripts/entity/tactical/actor"] <- {m={Sound=[[],[],[]],SoundOnUse=[],Type=0,Name="",MoraleState=0,BloodType=0,XP=0,BloodSplatterOffset=null,
    DecapitateSplatterOffset=null,ConfidentMoraleBrush="",SoundPitch=1.0,SoundVolumeOverall=1.0,AIAgent=null},
    spawnOverlay=function(...){},spawnAttackEffect=function(...){},
    create=function(){},onInit=function(){},onDeath=function(...){},onFactionChanged=function(){}};
::Const.EntityType.Unhold <- 25;::Const.BloodType <- {Red=1};
::Const.Sound <- {ActorEvent={Death=0,DamageReceived=1,Idle=2}};
::definitions["scripts/ai/tactical/agents/unhold_agent"] <- {m={Behaviors=[],SoundOnUse=[]},spawnOverlay=function(...){},spawnAttackEffect=function(...){},create=function(){this.m.Behaviors=[];},
    clearBehaviors=function(){this.m.Behaviors=[];},addBehavior=function(b){this.m.Behaviors.push(b);},
    finalizeBehaviors=function(){},setActor=function(a){this.m.Actor<-a;}};
foreach(path in ["ai_idle","ai_engage_melee","ai_break_free","ai_attack_default"])
    ::definitions["scripts/ai/tactical/behaviors/"+path] <- {m={PossibleSkills=[],SoundOnUse=[]},spawnOverlay=function(...){},spawnAttackEffect=function(...){},create=function(){}};
local enemy=::new("scripts/entity/tactical/enemies/afeix_douyu");
eq(enemy.m.AIAgent.m.Behaviors.len(),5,"enemy registers complete five behavior set");
eq(enemy.m.AIAgent.m.Behaviors[3].m.PossibleSkills[0],"actives.afeix_douyu_bite","native default AI points at own bite");
eq(enemy.m.AIAgent.m.Behaviors[4].m.ID,::Const.AI.Behavior.ID.AttackSpecial,"enemy registers custom special AI");
::combatID="afeix_dream_douyu";check(D.isDream(),"dream CombatID recognized");
::combatID="afeix_douyu_final";check(!D.isDream(),"real final combat distinct from dream");
eq(D.Stats.Hitpoints,4800,"fixed endgame health budget");
eq(D.Stats.Armor[0],600.0,"finite body armor");
check(D.Stats.MeleeDefense<40&&D.Stats.RangedDefense<40,"ordinary level-eleven attacks retain a viable hit chance");
print("TESTS_PASSED="+::checks+"\n");
