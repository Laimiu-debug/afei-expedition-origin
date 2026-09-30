// Production migration and mastery behavior, including negative/boundary cases.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::egChecks<-0;
function expect(ok,text){if(!ok)throw "endgame: "+text;::egChecks++;}
function eq(a,b,text){expect(::abs(a-b)<0.00001,text+" actual="+a+" expected="+b);}
dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");
foreach(key,p in A.BalanceV26.people){
 fresh();local a=makeActor(key);a.flags.set("afeix_balance_v26",true);
 a.flags.set("afeix_training_choice","saved choice");a.hp=29;
 foreach(i,field in A.BalanceFields)a.baseProps[field]<-p.endgame_previous_attrs[i]+13;
 A.syncEndgameBalance(a);
 foreach(i,field in A.BalanceFields)eq(a.baseProps[field],p.attrs[i]+13,key+" preserves earned points "+field);
 A.syncEndgameBalance(a);
 foreach(i,field in A.BalanceFields)eq(a.baseProps[field],p.attrs[i]+13,key+" repeated sync "+field);
 eq(a.hp,29,key+" no healing");
 expect(a.flags.get("afeix_training_choice")=="saved choice",key+" keeps selection");
}
// Metadata restoration clamps reduced maximum health after skills rebuild.
local featureSync=A.syncCharacterFeatures, backgroundSync=A.syncCharacterBackground;
A.syncCharacterFeatures=function(bro){this.syncEndgameBalance(bro);};
A.syncCharacterBackground=function(bro){};
foreach(health in [29,79]){
 fresh();local a=makeActor("yangmiemie"),p=A.BalanceV26.people.yangmiemie;
 foreach(i,field in A.BalanceFields)a.baseProps[field]<-p.endgame_previous_attrs[i]+13;
 a.hp=health;a.flags.set("afeix_balance_v18",true);a.flags.set("afeix_balance_v26",true);
 a.getBackground<-function(){return {m={}};};
 a.getHitpointsMax=function(){return this.props.Hitpoints;};
 a.setHitpoints<-function(n){this.hp=n;};
 A.restoreCharacterMetadata(a);eq(a.hp,health>75?75:health,"lower max clamps without healing");
 A.restoreCharacterMetadata(a);eq(a.hp,health>75?75:health,"repeated metadata sync preserves hp");
}
A.syncCharacterFeatures=featureSync;A.syncCharacterBackground=backgroundSync;
function learned(owner,key,level=11,pos=0){local a=makeActor(owner,pos);a.level=level;a.flags.set("afeix_training_choice",key);A.syncMemberSkills(a);A.catalogMemory(a,true);return a;}
foreach(key in ["half_step","lvbu_weapon","pang_breath","bell_lead","breathe_easy","next_path"]){
 fresh();local a=learned(A.MemberSkillDefs[key].owner,key);a.fatigue=20;A.balanceAfterTurnStart(a);
 eq(a.fatigue,20,key+" no generic mastery recovery");
}
fresh();local a=learned("suwa","half_step"),enemy=makeActor("enemy",1,2),s=equip(a);a.props.Initiative=120;enemy.props.Initiative=100;
eq(A.catalogBoost(a,s,enemy),7,"mastery uses actual initiative");a.level=7;eq(A.catalogBoost(a,s,enemy),5,"level7 unchanged");
a.level=11;a.props.Initiative=100;eq(A.catalogBoost(a,s,enemy),0,"equal initiative gives no accuracy");
a.props.Initiative=120;A.catalogSet(a,"attempt_serial",1);A.catalogAttackResult(a,s,enemy,false);eq(A.catalogBoost(a,s,enemy),0,"miss consumes first attack benefit");
fresh();a=learned("yaoyaoya","lvbu_weapon");enemy=makeActor("enemy",1,2);s=equip(a,true);
local p=a.skills.buildPropertiesForUse(s,enemy);eq(p.DamageArmorMult,1.12,"doublehand mastery armor");eq(p.MeleeDamageMult,1.0,"no hp damage boost");
a.level=7;p=a.skills.buildPropertiesForUse(s,enemy);eq(p.DamageArmorMult,1.10,"level7 armor unchanged");
a.level=11;s=equip(a,false);p=a.skills.buildPropertiesForUse(s,enemy);eq(p.DamageArmorMult,1.0,"singlehand cannot use mastery");
fresh();a=learned("xiaopangxu","pang_breath");enemy=makeActor("enemy",1,2);s=equip(enemy);a.fatigue=20;
A.catalogReceived(a,enemy,s,false);eq(a.fatigue,20,"miss earns no recovery");
A.catalogReceived(a,enemy,s,true);eq(a.fatigue,16,"mastery on hit recovers4");A.catalogReceived(a,enemy,s,true);eq(a.fatigue,16,"one recovery per round");
::state.round++;a.level=7;A.catalogReceived(a,enemy,s,true);eq(a.fatigue,13,"base recovers3");
fresh();a=learned("yangmiemie","bell_lead");local ally=makeActor("ally",1);ally.fatigue=20;a.fatigue=10;
A.catalogTurnEnd(a);eq(ally.fatigue,16,"mastery aids ally4");eq(a.fatigue,10,"does not also aid self");A.catalogTurnEnd(a);eq(ally.fatigue,16,"once per round");
fresh();a=learned("keke","breathe_easy");equip(a,false,true);a.fatigue=30;
local skill=passive(a,"breathe_easy");skill.onProtectedMiss();eq(a.fatigue,25,"mastery protected miss5");skill.onProtectedMiss();eq(a.fatigue,25,"protected miss once per round");
for(local round=2;round<=6;round++){::state.round=round;skill.onProtectedMiss();}
eq(a.fatigue,10,"protected miss total capped20");
print("TESTS_PASSED="+::egChecks+"\n");
