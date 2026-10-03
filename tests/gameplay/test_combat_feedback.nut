// Real native skill.use and sprite-overlay dispatch; rendering itself is mocked.
dofile("tests/gameplay/member_skill_fixture.nut");
local A=::AfeixExpedition;
::checks <- 0;
function check(ok,label){if(!ok)throw "FAIL feedback: "+label;::checks++;}
foreach(key,d in A.MemberSkillDefs) if(d.active) {
    local skill=::new("scripts/skills/actives/afeix_member_active");skill.configure(key);
    check(skill.m.SoundOnUse.len()>0&&skill.m.Overlay!="",key+" has both sound and animation");
    check(skill.m.Icon=="skills/afeix_member_"+key+".png",key+" retains custom button art");
}
foreach(key,d in A.CatalogEffects){
    local skill=::new("scripts/skills/effects/afeix_catalog_effect");skill.configure(key);
    check(skill.m.IconMini.find(".png")==null&&skill.m.IconMini.find("_mini")!=null,key+" uses a native mini brush");
    check(A.MemberSkillDefs[key].active||skill.m.Overlay=="",key+" passive updates stay quiet");
}
foreach(path in ["afeix_wawa_effect","afeix_haoqi_effect","afeix_feidie_effect","afeix_feidie_guard_effect","afeix_cao_courage","afeix_turtle_awakening","afeix_douyu_core_effect","afeix_douyu_mark_effect","afeix_douyu_pressure_effect"]){
    local skill=::new("scripts/skills/effects/"+path);
    check(skill.m.IconMini.find(".png")==null&&skill.m.IconMini.find("_mini")!=null,path+" uses a native mini brush");
}
// Capture native sound/overlay calls, then verify paid use and rejected use.
::feedbackTrace <- {sounds=[],sprites=[],logs=[],particles=[]};
::Const.UI <- {getColorizedEntityName=function(a){return a.getName();}};
::Const.Tactical.Settings <- {SkillOverlayOffsetX=0,SkillOverlayOffsetY=105,SkillOverlayScale=0.75,
    SkillOverlayStayDuration=500,SkillOverlayFadeDuration=900};
::createColor <- function(color){return color;};
::Sound.play=function(sound,...){::feedbackTrace.sounds.push(sound);};
::Tactical.spawnSpriteEffect <- function(brush,...){::feedbackTrace.sprites.push(brush);};
::Tactical.EventLog <- {log=function(text){::feedbackTrace.logs.push(text);}};
useLegacySkillFixture();fresh();
local user=makeActor("xiaoyubeike");user.isHiddenToPlayer<-function(){return false;};
A.syncMemberSkills(user);
local puff=active(user,"nicotine");
puff.spawnOverlay=::skill.spawnOverlay;
user.fatigue=30;
check(puff.use(user.tile),"fatigue recovery successfully uses native action");
check(::feedbackTrace.sounds.len()==1&&::feedbackTrace.sprites.len()==1&&::feedbackTrace.logs.len()==1,"one sound, animated overlay and explicit success log");
check(user.ap==9-puff.getActionPointCost(),"feedback does not charge action points twice");
local oldAP=user.ap,oldFatigue=user.fatigue;
check(!puff.use(user.tile),"second once-per-battle use rejected");
check(::feedbackTrace.sounds.len()==1&&::feedbackTrace.sprites.len()==1&&::feedbackTrace.logs.len()==1&&user.ap==oldAP&&user.fatigue==oldFatigue,"rejected use emits no feedback and spends nothing");
user.tile.IsVisibleForPlayer=false;A.logCustomSkill(puff,user);
check(::feedbackTrace.logs.len()==1,"hidden actors do not leak action logs");
user.tile.IsVisibleForPlayer=true;
::Const.Tactical.SmokeParticles <- [{Brushes=["ash_light_01"],Delay=0,Quantity=50,LifeTimeQuantity=0,SpawnRate=9,Stages=[]}];
::Tactical.spawnParticleEffect <- function(dummy,brushes,tile,delay,quantity,lifetime,rate,stages){::feedbackTrace.particles.push(quantity);};
A.feedbackParticles(user.tile,"SmokeParticles",0.15);
check(::feedbackTrace.particles.len()==1&&::feedbackTrace.particles[0]==7,"puff smoke is a small finite burst");
user.tile.IsVisibleForPlayer=false;A.feedbackParticles(user.tile,"SmokeParticles",0.15);
check(::feedbackTrace.particles.len()==1,"hidden tiles do not emit particles");
print("TESTS_PASSED="+::checks+"\n");
