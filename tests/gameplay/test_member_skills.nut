dofile("tests/gameplay/member_skill_fixture.nut");
useLegacySkillFixture();
// Expected acall failures are asserted below; the suite still requires its final marker.
// Keep failure diagnostics visible.
local A=::AfeixExpedition, count=0;
A.syncIdeasCharacter=function(bro){}; // This suite isolates the existing member-skill migration.
local expect=function(v,label){++count;if(!v)throw "FAIL member skills: "+label;};
// Old actors and new candidates use the same real feature hook. No gear/stats rewrites.
foreach(key,keys in A.MemberSkills) {
    if(["bottle","yuchujiu","xiaoyubeike","yaoyaoya","damou","laocai","dae","keke","xiaogui"].find(key)==null)continue;
    fresh();local a=makeActor(key);::state.tactical=false;
    A.syncCharacterFeatures(a);local first=a.skills.m.Skills[0],baseProps=a.baseProps;
    A.syncCharacterFeatures(a);A.syncCharacterFeatures(a);
    expect(a.skills.m.Skills.len()==2 && a.skills.m.Skills[0]==first && a.baseProps==baseProps,"idempotent migration "+key);
    expect(!active(a,keys[0]).isUsable(),"no combat action on world map "+key);
    foreach(s in a.skills.m.Skills){
        local restored=roundtrip(s,s.isActive()?"scripts/skills/actives/afeix_member_active":"scripts/skills/traits/afeix_member_passive");
        expect(restored.getID()==s.getID() && restored.getDescription()==s.getDescription(),"same class restores distinct member skill "+s.getID());
    }
}
fresh();local plain=makeActor(null);A.syncMemberSkills(plain);expect(plain.skills.m.Skills.len()==0,"ordinary mercenary untouched");
plain.key="bottle";::state.origin=false;A.syncMemberSkills(plain);expect(plain.skills.m.Skills.len()==0,"other origins untouched");
fresh();local b=makeActor("bottle"), enemy=makeActor("enemy",1,2),native=equip(b);A.syncMemberSkills(b);
local attack=active(b,"bottle_breakthrough");
expect(attack.isIgnoredAsAOO(),"special attack cannot be automatically spent as an opportunity attack");
// Preview uses the same native attack modifiers without spending or marking use.
native.getHitchance=function(t){return this.getContainer().buildPropertiesForUse(this,t).MeleeSkill;};
expect(attack.getHitchance(enemy)==70&&attack.m.ExecutingNative==null&&!attack.m.Used&&b.ap==9,"attack preview includes native modifier without spending");
native.getHitchance=function(t){throw "preview failure";};
seterrorhandler(function(error) {}); // Only this expected native acall failure.
try {attack.getHitchance(enemy);} catch(error){}
seterrorhandler(function(error) {print("FAIL "+error+"\n");});
expect(attack.m.ExecutingNative==null&&!attack.m.Used,"failed tooltip cannot leak attack context");
enemy.pos=2;expect(!attack.use(enemy.tile)&&b.ap==9&&b.fatigue==0&&b.weapon.uses==0,"out of weapon range cannot charge");
enemy.pos=1;enemy.tile.IsVisibleForEntity=false;expect(!attack.use(enemy.tile)&&b.ap==9,"hidden target cannot charge");enemy.tile.IsVisibleForEntity=true;
expect(attack.use(enemy.tile)&&b.ap==5&&b.fatigue==18&&b.weapon.uses==1,"native payment exactly once including item");
expect(::state.attacks.len()==1&&::state.attacks[0].p.MeleeSkill==70&&::state.attacks[0].p.DamageAgainstMult[1]==2.0,"native chop head bonus and custom accuracy preserved");
expect(b.props.MeleeDefense==5&&attack.m.ExecutingNative==null,"attack downside and context cleanup");
expect(!attack.use(enemy.tile)&&b.ap==5,"same-round cooldown");::state.round=2;b.ap=9;b.skills.update();expect(!attack.isUsable(),"cooldown second round");
event(b,"onTurnStart");expect(b.props.MeleeDefense==10,"downside expires at next own turn");
::state.round=3;::state.hit=false;expect(attack.use(enemy.tile)&&b.ap==5&&b.weapon.uses==2&&attack.m.ReadyRound==5,"miss consumes one native attack and cooldown");
local restored=roundtrip(attack,"scripts/skills/actives/afeix_member_active");expect(restored.m.ReadyRound==5&&restored.m.Used,"cooldown survives serialization");
::state.round=5;b.ap=9;b.fatigue=0;b.skills.update();expect(attack.getFatigueCost()==21&&native.getFatigueCost()==16,"finals extra fatigue participates in native affordability");
expect(attack.use(enemy.tile)&&b.fatigue==21,"finals wrapper charges surcharge once");expect(abs(::state.attacks.top().p.MeleeDamageMult-1.1)<0.001,"finals boosts actual delegated attack");
event(b,"onCombatFinished");expect(attack.m.ReadyRound==0&&!attack.m.Used&&effect(b,"breakthrough_exposed")==null,"battle cleanup");
fresh();local y=makeActor("yaoyaoya"),target=makeActor("enemy",1,2),axe=equip(y,true);A.syncMemberSkills(y);local breach=active(y,"breach_strike");
expect(breach.isUsable()&&breach.use(target.tile)&&y.ap==3&&y.fatigue==20&&y.weapon.uses==1,"starting two-handed axe usable and charged once");
expect(::state.attacks[0].p.MeleeSkill==60&&abs(::state.attacks[0].p.DamageArmorMult-1.485)<0.001,"breach penalty and controlled armor multipliers");
expect(target.received.len()==1&&target.received[0].DamageArmor>20,"native split-man secondary body-part hit preserved");
event(y,"onCombatFinished");y.ap=9;y.fatigue=0;target.pos=2;expect(!breach.use(target.tile)&&y.ap==9,"two-handed axe not granted polearm reach");
axe.m.MinRange=2;axe.m.MaxRange=2;y.skills.update();expect(breach.use(target.tile),"delegated native two-tile range honored");
fresh();local j=makeActor("yuchujiu"),e=makeActor("enemy",3,2);A.syncMemberSkills(j);local bark=active(j,"dog_bark");
e.human=false;expect(!bark.use(e.tile)&&j.ap==9,"beast immunity no payment");e.type=10;expect(bark.use(e.tile)&&e.props.MeleeSkill==52,"greenskin valid target");
A.memberEffect(e,"dog_bark");expect(e.props.MeleeSkill==52,"same debuff refresh not stack");event(e,"onTurnStart");expect(e.props.MeleeSkill==52,"bark survives target turn start");event(e,"onTurnEnd");expect(e.props.MeleeSkill==60,"bark expires target turn end");
event(j,"onCombatFinished");j.ap=9;e.baseProps.IsImmuneToFearAndPanic=true;e.skills.update();expect(!bark.use(e.tile)&&j.ap==9,"fear immunity honored");
local captain=makeActor("afei",1);j.skills.update();expect(j.props.Bravery==60,"loyalty active captain");captain.placed=false;local proxy=makeActor("damou",1);j.skills.update();expect(j.props.Bravery==60,"deployed proxy fallback");proxy.morale=0;j.skills.update();expect(j.props.Bravery==50,"fleeing proxy invalid");
fresh();local fish=makeActor("xiaoyubeike"),ally=makeActor("ally",1);equip(fish);A.syncMemberSkills(fish);local nicotine=active(fish,"nicotine");
expect(!nicotine.use(fish.tile)&&fish.ap==9,"no zero-fatigue use");fish.fatigue=30;expect(nicotine.use(fish.tile)&&fish.fatigue==15&&fish.ap==7,"nicotine recovers fifteen for two AP");
expect(fish.props.FatigueRecoveryRate==10&&!nicotine.isUsable(),"debt and once-per-battle gate");
// Vanilla actor recovers fatigue before dispatching onTurnStart.
fish.fatigue=50;fish.fatigue-=fish.props.FatigueRecoveryRate;event(fish,"onTurnStart");expect(fish.fatigue==40&&fish.props.FatigueRecoveryRate==10,"first reduced recovery");
fish.fatigue-=fish.props.FatigueRecoveryRate;event(fish,"onTurnStart");expect(fish.fatigue==30&&fish.props.FatigueRecoveryRate==15,"second reduced recovery then debt expires");
expect(fish.skills.defense(ally,null).MeleeDefense==15,"unshielded neighbor defense");equip(ally,false,true);expect(fish.skills.defense(ally,null).MeleeDefense==10,"shielded ally does not qualify");
fresh();local d=makeActor("damou"),l=makeActor("laocai",0),k=makeActor("keke",0),goose=makeActor("dae",0),friend=makeActor("friend",1),foe=makeActor("enemy",2,2);
foreach(a in [d,l,k,goose]){equip(a,false,true);A.syncMemberSkills(a);}
expect(active(d,"borrow_strike").use(friend.tile),"damou protects adjacent ally");
expect(active(l,"steady_hand").use(l.tile),"laocai group command");expect(active(k,"pokemon").use(friend.tile),"keke protects ally");
expect(active(goose,"guard_nest").use(goose.tile),"goose anchors shield");
local defense=friend.skills.defense(foe,null);expect(defense.MeleeDefense==15&&defense.RangedDefense==16&&friend.props.Bravery==50,"guard values use max per property, no stacking");
event(friend,"onTurnStart");expect(friend.skills.defense(foe,null).MeleeDefense==14,"short commands expire independently of pokemon");
event(friend,"onTurnEnd");expect(effect(friend,"pokemon")==null,"pokemon expires at next target end");
local enemyAttack=equip(foe),cover=effect(friend,"pokemon");k.fatigue=40;
A.catalogReceived(friend,foe,enemyAttack,false);A.catalogReceived(friend,foe,enemyAttack,false);expect(k.fatigue==36,"protected dodge recovers once a round");
for(local r=2;r<=7;++r){::state.round=r;A.catalogReceived(friend,foe,enemyAttack,false);}expect(k.fatigue==20&&passive(k,"breathe_easy").m.Recovered==20,"battle recovery cap twenty");
restored=roundtrip(passive(k,"breathe_easy"),"scripts/skills/traits/afeix_member_passive");expect(restored.m.Recovered==20&&restored.m.RecoveryRound==5,"passive cap persists");
event(friend,"onTurnEnd");expect(effect(friend,"pokemon")==null,"pokemon expires at second target end");
event(goose,"onTurnStart");expect(friend.skills.defense(foe,null).RangedDefense==8,"goose buff ends on source turn even if target has not acted");
::state.round=1;event(l,"onNewRound");expect(l.props.Initiative==112&&friend.props.Initiative==100,"first-round formation snapshot");
local late=makeActor("late",1);event(l,"onNewRound");expect(late.props.Initiative==100,"late arrival not given opening formation");
::state.round=2;event(l,"onNewRound");event(friend,"onNewRound");expect(l.props.Initiative==100&&friend.props.Initiative==100,"opening initiative expires after first round");
fresh();local turtle=makeActor("xiaogui"),afei=makeActor("afei",2),bad=makeActor("enemy",1,2);equip(turtle,false,true);A.syncMemberSkills(turtle);
expect(turtle.props.Bravery==58&&turtle.props.FatigueRecoveryRate==15,"turtle Afei bond");afei.placed=false;turtle.skills.update();expect(turtle.props.Bravery==50,"reserve Afei gives no bond");
expect(active(turtle,"turtle_shell").use(turtle.tile)&&!turtle.props.IsAbleToUseWeaponSkills,"shell disables weapon attacks");
expect(abs(turtle.skills.damage(bad,equip(bad)).DamageReceivedTotalMult-0.8)<0.001,"shell reduces received damage");
turtle.tile.ID+=20;event(turtle,"onMovementFinished");expect(turtle.props.IsAbleToUseWeaponSkills&&turtle.skills.damage(bad,null).DamageReceivedTotalMult==1.0,"movement ends shell");
// All temporary kinds survive a write/read with source and duration intact.
foreach(kind in ["dog_bark","nicotine_debt","breakthrough_exposed","borrow_strike","steady_hand","blue_form","pokemon","turtle_shell"]){
    local fx=A.memberEffect(turtle,kind,kind=="pokemon"||kind=="turtle_shell"?turtle:null,2);
    restored=roundtrip(fx,"scripts/skills/effects/afeix_member_effect");
    expect(restored.getID()==fx.getID()&&restored.m.Source==fx.m.Source&&restored.m.Turns==2,"effect roundtrip "+kind);
}
event(turtle,"onCombatFinished");foreach(s in turtle.skills.m.Skills)expect(!s.m.IsRemovedAfterBattle,"no effect left between battles");
// Role conditions and live equipment changes, rather than unconditional bonuses.
fresh();local shieldman=makeActor("damou"),f1=makeActor("f1",1),f2=makeActor("f2",2),evil=makeActor("enemy",1,2),swing=equip(shieldman,false,true);
A.syncMemberSkills(shieldman);
expect(shieldman.props.Bravery==58&&shieldman.skills.buildPropertiesForUse(swing,evil).DamageArmorMult>1.09,"two companions enable together lift");
f2.placed=false;shieldman.skills.update();expect(shieldman.props.Bravery==50&&shieldman.skills.buildPropertiesForUse(swing,evil).DamageArmorMult==1.0,"reserves do not enable together lift");
shieldman.shield=null;expect(!active(shieldman,"borrow_strike").use(f1.tile)&&shieldman.ap==9,"shield skill rejects unshielded user before payment");
fresh();local g=makeActor("dae"),ga=makeActor("friend",1),ge=makeActor("enemy",-1,2),gs=equip(g,false,true);g.neighbors=[ga,ge];A.syncMemberSkills(g);
expect(g.props.Bravery==55&&g.skills.buildPropertiesForUse(gs,ge).MeleeSkill==65,"goose coordinated frontline");
ga.morale=0;g.skills.update();expect(g.props.Bravery==50&&g.skills.buildPropertiesForUse(gs,ge).MeleeSkill==60,"fleeing ally not counted");ga.morale=4;
expect(active(g,"guard_nest").use(g.tile)&&ga.skills.defense(ge,gs).RangedDefense==16,"guard nest adjacent defense");
local guardRestored=roundtrip(effect(ga,"guard_nest"),"scripts/skills/effects/afeix_member_effect");expect(guardRestored.m.SourceTurn==effect(ga,"guard_nest").m.SourceTurn&&guardRestored.m.SourceTile==g.tile.ID,"guard anchor save state");
ga.pos=3;expect(ga.skills.defense(ge,gs).RangedDefense==8,"leaving nest range loses buff");ga.pos=1;
g.shield=null;g.skills.update();expect(ga.skills.defense(ge,gs).RangedDefense==8,"losing source shield cancels nest");g.shield={isItemType=function(n){return n==1;}};g.skills.update();expect(ga.skills.defense(ge,gs).RangedDefense==8,"re-equipping cannot revive cancelled nest");
// Run the actual hook callbacks with live-instance binding. Properties must refresh
// before a morale check or the native start-of-turn recovery, not one turn later.
::memberActorHook <- null;
::mods_hookExactClass <- function(path,callback){::memberActorHook=callback;};
dofile("src/scripts/mods/afeix/member_skill_hooks.nut");
local methods={getBravery=function(){return this.props.Bravery;},onTurnStart=function(){this.fatigue-=this.props.FatigueRecoveryRate;event(this,"onTurnStart");return "native-start";},
    onMovementFinish=function(tile){event(this,"onMovementFinished");return "native-movement";}};
::memberActorHook(methods);
fresh();local j2=makeActor("yuchujiu"),af=makeActor("afei",1);A.syncMemberSkills(j2);expect(j2.props.Bravery==60,"initial captain proximity");
af.pos=5;expect(methods.getBravery.bindenv(j2)()==50,"morale calculation immediately drops departed captain bonus");
af.pos=1;expect(methods.onMovementFinish.bindenv(af)(af.tile)=="native-movement"&&j2.props.Bravery==60,"captain movement refreshes nearby members and preserves native callback");
local t2=makeActor("xiaogui",2);equip(t2,false,true);A.syncMemberSkills(t2);t2.fatigue=50;af.placed=false;
expect(methods.onTurnStart.bindenv(t2)()=="native-start"&&t2.fatigue==35,"turn-start recovery uses current deployed captain state");
::state.origin=false;af.placed=true;j2.props.Bravery=44;expect(methods.getBravery.bindenv(j2)()==44,"hook leaves other origins native");
// Dead, stunned, controlled and charmed actors cannot issue support orders.
fresh();local ko=makeActor("keke"),friend2=makeActor("friend",1);equip(ko,false,true);A.syncMemberSkills(ko);
foreach(field in ["alive","controlled","placed"]){ko[field]=false;expect(!active(ko,"pokemon").use(friend2.tile)&&ko.ap==9,"invalid support owner "+field);ko[field]=true;}
ko.baseProps.IsAbleToUseSkills=false;ko.skills.update();expect(!active(ko,"pokemon").use(friend2.tile)&&ko.ap==9,"incapacitated owner");
print("TESTS_PASSED="+count+"\n");
