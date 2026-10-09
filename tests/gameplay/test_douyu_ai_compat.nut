// Real native agent registration and selection, including unhold population.
// MSU 1.9.0's ID stack contract is isolated below; no third-party source ships
// in the gameplay package. Engine movement and visuals remain isolated.
dofile("tests/gameplay/douyu_combat_fixture.nut");
local nativeRoot=".cache/afei-art/native-contract-fixture/";
::Const.AI.Agent <- {Intentions={},Orders={},ID={Unhold=1},ConsiderBehaviorsCutoff=0.1};
::Const.AI.VerboseMode <- false;
::Const.AI.Properties <- {BehaviorMult=[]};
::Const.AI.Behavior.ID.COUNT <- 12;
::Const.AI.Behavior.ID.Flee <- 5; ::Const.AI.Behavior.ID.Retreat <- 6;
::Const.AI.Behavior.ID.LineBreaker <- 7; ::Const.AI.Behavior.ID.Charge <- 8;
::Const.AI.Behavior.ID.Swing <- 9;
dofile(nativeRoot+"behavior.nut");
::behavior.spawnOverlay <- function(...){};
::behavior.spawnAttackEffect <- function(...){};
::behavior.m.SoundOnUse <- []; ::behavior.m.MinTargets <- 0;
::behavior.m.PossibleSkills <- [];
::definitions["scripts/ai/tactical/behavior"] <- ::behavior;
foreach(spec in [["ai_idle",0],["ai_attack_default",1],["ai_engage_melee",3],
    ["ai_break_free",4],["ai_flee",5],["ai_retreat",6],["ai_line_breaker",7],
    ["ai_charge",8],["ai_attack_swing",9]]) {
    local id=spec[1];
    ::definitions["scripts/ai/tactical/behaviors/"+spec[0]] <- ::inherit("scripts/ai/tactical/behavior", {
        create=function(){this.m.ID=id;this.m.Order=id;},
        onEvaluate=function(entity){return this.m.ID==0?1:0;}
    });
}
::definitions["scripts/entity/tactical/actor"] <- {m={Sound=[[],[],[]],SoundOnUse=[],Type=0,Name="",MoraleState=0,BloodType=0,XP=0,
    BloodSplatterOffset=null,DecapitateSplatterOffset=null,ConfidentMoraleBrush="",SoundPitch=1.0,SoundVolumeOverall=1.0,AIAgent=null},
    spawnOverlay=function(...){},spawnAttackEffect=function(...){},create=function(){},onInit=function(){},
    onDeath=function(...){},onFactionChanged=function(){}};
::Const.EntityType.Unhold <- 25; ::Const.BloodType <- {Red=1};
::Const.Sound <- {ActorEvent={Death=0,DamageReceived=1,Idle=2}};
loadDefinition("scripts/mods/afeix/douyu_ai");

function prepareAgent(msu) {
    dofile(".cache/afei-art/native-contract-fixture/agent.nut");
    ::agent.spawnOverlay <- function(...){}; ::agent.spawnAttackEffect <- function(...){};
    ::agent.m.SoundOnUse <- []; ::agent.m.MSU_BehaviorStacks <- {};
    if(msu) {
        // Contract verified against the upstream 1.9.0 agent hook:
        // https://github.com/MSUTeam/MSU/blob/1.9.0/msu/hooks/ai/tactical/agent.nut
        local add=::agent.addBehavior, remove=::agent.removeBehavior;
        ::agent.addBehavior=function(behavior) {
            local id=behavior.getID();
            if(id in this.m.MSU_BehaviorStacks) {this.m.MSU_BehaviorStacks[id]++;return;}
            this.m.MSU_BehaviorStacks[id] <- 1;
            return add.call(this,behavior);
        };
        ::agent.removeBehavior=function(id) {
            if(id in this.m.MSU_BehaviorStacks)delete this.m.MSU_BehaviorStacks[id];
            return remove.call(this,id);
        };
    }
    ::definitions["scripts/ai/tactical/agent"] <- ::agent;
    dofile(".cache/afei-art/native-contract-fixture/unhold_agent.nut");
    ::unhold_agent.create=function() {
        // Mirror the game's per-instance collection ownership. Keep the native
        // agent.create and unhold.onAddBehaviors, omitting unrelated scoring.
        this.m.Behaviors=[]; this.m.SortedBehaviors=[]; this.m.MSU_BehaviorStacks={};
        this.agent.create();
    };
    ::definitions["scripts/ai/tactical/agents/unhold_agent"] <- ::unhold_agent;
}
function selectBehavior(agent,entity) {
    foreach(behavior in agent.m.Behaviors)behavior.m.Score=behavior.onEvaluate(entity);
    agent.sortBehaviors();
    return agent.pickBehavior();
}
foreach(msu in [false,true]) {
    prepareAgent(msu);
    // The old clear/add sequence must actually reproduce the missing idle;
    // otherwise this fixture would silently stop covering the reported bug.
    local old=::new("scripts/ai/tactical/agents/unhold_agent");
    old.clearBehaviors();old.addBehavior(::new("scripts/ai/tactical/behaviors/ai_idle"));
    check((old.getBehavior(0)==null)==msu,"fixture reproduces MSU clear/add registration mismatch");
    foreach(combat in ["afeix_dream_douyu","afeix_douyu_final"]) {
        reset(); ::combatID=combat;
        local enemy=::new("scripts/entity/tactical/enemies/afeix_douyu"),a=enemy.m.AIAgent;
        eq(a.m.Behaviors.len(),5,"production boss keeps all five behaviors MSU="+msu+" "+combat);
        eq(a.m.SortedBehaviors.len(),5,"native sorted selection list is complete");
        foreach(id in [0,1,2,3,4]) {
            local behavior=a.getBehavior(id);
            check(behavior!=null,"idle, bite, specials, movement and break-free are present "+id);
            check(behavior.getAgent()==a,"native addBehavior binds each behavior to this agent");
            if(msu)eq(a.m.MSU_BehaviorStacks[id],1,"MSU registry has exactly one live registration "+id);
        }
        if(msu)eq(a.m.MSU_BehaviorStacks.len(),5,"removed unhold behavior IDs do not remain registered");
        eq(a.getBehavior(1).m.PossibleSkills[0],"actives.afeix_douyu_bite","bite still uses production skill");
        local b=boss(),target=actor("target",99);turn(b);a.setActor(b);
        local specialAI=a.getBehavior(2);
        specialAI.queryTargetsInMeleeRange=function(min,max,level) {
            local result=[];foreach(entity in ::state.actors)
                if(entity.faction!=this.getAgent().getActor().faction && entity.pos>=min && entity.pos<=max)result.push(entity);
            return result;
        };
        local selected=selectBehavior(a,b);
        check(selected!=null && selected.getID()==0,"distant target keeps native idle fallback");
        selected.onBeforeExecute(b);
        check(selected.execute(b),"native idle lifecycle ends unavailable-action turn");
        target.pos=2;
        selected=selectBehavior(a,b);
        check(selected!=null && selected.getID()==2,"available target selects production special AI");
        selected.onBeforeExecute(b);
        a.adjustCameraToTarget=function(tile){};a.declareAction=function(){};a.declareEvaluationDelay=function(delay){};
        selected.m.IsFirstExecuted=true;
        check(!selected.execute(b),"camera stage yields before skill use");
        check(selected.execute(b),"special executes through native behavior lifecycle");
        eq(b.ap,0,"rocket consumes ordinary action points");
        selected=selectBehavior(a,b);
        check(selected!=null && selected.getID()==0,"spent AP and charging cannot strand AI without idle");
        selected.onBeforeExecute(b);
        check(selected.execute(b),"turn can finish after spending AP");
    }
}
print("TESTS_PASSED="+::checks+"\n");
