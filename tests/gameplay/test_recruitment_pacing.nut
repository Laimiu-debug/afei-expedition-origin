// Integrated production gates, queue, random draws and native hiring. No game UI.
dofile("tests/gameplay/recruitment_pacing_fixture.nut");
local F=::PacingFixture,A=F.A;
::drawValue<-100;::drawCalls<-0;
::Math.rand=function(a,b){::drawCalls++;return ::drawValue;};
expect(A.RecruitRegularOfferCount==3&&A.RecruitOfferCount==5,"three regular slots plus two independent visitor slots");
local early=[["shuaizi",2],["bottle",3],["xiaoyueya",4],["yuchujiu",5],["lili",6],["xiaoyubeike",8],["wangduidui",10]];
foreach(pair in early)expect(A.EncounterRequirements[pair[0]].days==pair[1],"approved early date "+pair[0]);
expect(A.EncounterRequirements.yanzi.days==12&&A.EncounterRequirements.manyuemei.days==26,"blue team spans12to26");
expect(A.EncounterRequirements.keke.days==28&&A.EncounterRequirements.yaoyaoya.days==54,"DFW spans28to54");

// A modest, explicitly stated progress curve meets every early gate. Money and
// travel are fixture inputs, not a claim that every live campaign can afford all.
F.reset();local hired={};
for(local day=1;day<=10;day++){
 F.advance(day);
 F.progress(day>=10?4:(day>=8?3:(day>=5?2:(day>=3?1:0))),day>=8?2:(day>=3?1:0),day>=6?3:(day>=2?2:1),day>=10?3:(day>=3?2:1));
 F.query();
 foreach(pair in early)if(A.recruitOfferSlot(pair[0])>=0){expect(F.hireKey(pair[0])==0,"native early hire "+pair[0]);hired[pair[0]]<-day;}
}
foreach(pair in early)expect(pair[0]in hired&&hired[pair[0]]==pair[1],"early member on planned day "+pair[0]);
expect(F.player.getSize()==10&&::World.Assets.money==100000-3860,"all ten black team members with unchanged3860 base budget");

// Passed-over people cannot bury first introductions in a growing FIFO backlog.
F.reset();F.progress(99,99,99,11);local firstSeen={};
for(local day=1;day<=60;day++){
 F.advance(day);F.query();
 for(local i=0;i<3;i++){local key=A.getRecruitSlot(i).key;if(key!=""&&!(key in firstSeen))firstSeen[key]<-day;}
}
foreach(pair in early)expect(pair[0]in firstSeen&&firstSeen[pair[0]]<=10,"even skipping offers sees all black team byday10 "+pair[0]);
foreach(key in A.CharacterOrder)if(!A.Characters[key].isCaptain&&!A.isRandomRecruit(key))
 expect(key in firstSeen&&firstSeen[key]<=A.EncounterRequirements[key].days+4,"unseen member served within one regular offer cycle "+key);
expect(firstSeen.yaoyaoya<=58,"late member no longer buried untilday84");

// One global draw per eligible day, even across towns and serialized flag reload.
F.reset();::drawValue=26;::drawCalls=0;F.query();
expect(::drawCalls==1&&A.recruitOfferSlot("xiaogui")<0,"turtle day1 is eligible;26 fails25percent");
F.query();F.hire.setRosterID(2);F.hire.queryHireInformation();
expect(::drawCalls==1,"same-day reopening and moving towns do not reroll");
local saved=clone ::World.Flags.values;::World.Flags.values=clone saved;
dofile("src/scripts/mods/afeix/recruitment.nut");A.configureRecruitment(A.BalanceV26.recruitment);A.restoreHireCandidate();F.query();
expect(::drawCalls==1&&A.get("random_recruit_xiaogui_misses")==1,"saved failed draw and misses survive module/load restore");
F.advance(2);::drawValue=25;F.query();
expect(A.recruitOfferSlot("xiaogui")==4&&::drawCalls==2,"25 succeeds; turtle uses only its own slot");
local turtle=A.candidateInRoster(F.townRosters[1],"xiaogui"),expiry=A.getRecruitSlot(4).expires;
expect(turtle.m.Level==1&&turtle.getHiringCost()==870,"early turtle priced at actual level1");
F.hire.setRosterID(2);F.hire.queryHireInformation();
expect(A.candidateInRoster(F.townRosters[2],"xiaogui")==turtle&&A.getRecruitSlot(4).expires==expiry,"random offer moves same actor and keeps two-day expiry");
F.advance(4);::drawValue=100;F.query();
expect(A.recruitOfferSlot("xiaogui")<0&&A.get("random_recruit_xiaogui_misses")==1,"missed visitor expires and returns to daily lottery");
expect(A.nextQueuedRecruit()!= "xiaogui","visitor never enters ordinary queue after expiry");

// The fifth eligible draw is a guarantee, independently for each person; days
// without a eligible-town check do not retroactively generate draw attempts.
F.reset();::drawValue=100;::drawCalls=0;
foreach(day in [1,10,20,30]){F.advance(day);F.query();expect(A.recruitOfferSlot("xiaogui")<0,"one failed attempt per checked day");}
F.advance(40);F.query();
expect(A.recruitOfferSlot("xiaogui")==4&&::drawCalls==4,"fifth eligible attempt guarantees turtle without extra RNG");
F.advance(42);F.query();expect(A.recruitOfferSlot("xiaogui")<0&&A.get("random_recruit_xiaogui_misses")==1,"successful display resets guarantee for later returns");

// Song is unavailable before day16 and needs6 battles,2 paid jobs,4 towns,level3.
F.reset();F.progress(99,99,99,11);A.set("ever_xiaogui",true);::drawValue=35;::drawCalls=0;
F.advance(15);F.query();expect(::drawCalls==0&&A.recruitOfferSlot("songnuanyang")<0,"no Song lottery onday15");
F.advance(16);F.query();expect(::drawCalls==1&&A.recruitOfferSlot("songnuanyang")==3,"Song35percent succeeds onday16");
expect(A.candidateInRoster(F.townRosters[1],"songnuanyang").m.Level==5,"late experienced company can catch up random visitor tolevel5");
F.reset();F.progress(6,2,4,3);A.set("ever_xiaogui",true);F.advance(16);::drawValue=36;::drawCalls=0;F.query();
expect(::drawCalls==1&&A.recruitOfferSlot("songnuanyang")<0,"Song36 fails35percent");
foreach(day in [17,18,19]){F.advance(day);F.query();}
F.advance(20);F.query();expect(A.recruitOfferSlot("songnuanyang")==3,"Song fifth eligible attempt guaranteed");
local song=A.candidateInRoster(F.townRosters[1],"songnuanyang");
expect(song.m.Level==1&&song.getHiringCost()==1000,"minimum-gate Song costs actuallevel1 price");

// Affordability and roster checks do not consume a random member's identity.
::World.Assets.money=0;expect(F.hireKey("songnuanyang")==1&&!A.get("ever_songnuanyang",false),"unaffordable visitor persists");
::World.Assets.money=100000;while(F.player.getSize()<40)F.player.add(brother());
expect(F.hireKey("songnuanyang")==2&&!A.get("ever_songnuanyang",false),"full roster keeps visitor available");
while(F.player.getSize()>3)F.player.actors.pop();
expect(F.hireKey("songnuanyang")==0&&A.get("ever_songnuanyang",false),"visitor hires once through native payment");
F.player.remove(song);A.set("dead_songnuanyang",true);
F.advance(60);F.query();expect(A.recruitOfferSlot("songnuanyang")<0,"dead hired visitor never respawns");
F.reset();A.set("departed_xiaogui",true);F.query();expect(A.recruitOfferSlot("xiaogui")<0,"permanent departure also blocks random regeneration");

// Successful rolls survive constructor failure, and no level reroll on return.
F.reset();::drawValue=1;::drawCalls=0;F.failItems(true);F.query();
expect(::drawCalls==1&&A.recruitOfferSlot("xiaogui")<0,"failed visitor construction leaves cached successful roll");
F.failItems(false);F.query();expect(::drawCalls==1&&A.recruitOfferSlot("xiaogui")==4,"same-day retry uses the successful saved roll");
local frozen=A.candidateInRoster(F.townRosters[1],"xiaogui").m.Level;
F.progress(99,99,99,11);F.advance(3);F.query();
expect(A.candidateInRoster(F.townRosters[1],"xiaogui").m.Level==frozen,"expired visitor keeps first-generated level");

// Older saves may already show Song in an ordinary slot. Keep that exact actor
// until its original deadline; then transfer future appearances to the visitor lane.
F.reset();F.advance(10);F.progress(99,99,99,11);A.set("ever_xiaogui",true);
local legacy=A.createHireCandidate("songnuanyang",F.townRosters[1]);
A.set("met_songnuanyang",true);A.set("native_recruit_songnuanyang",true);A.set("recruit_slots_v1",true);
A.saveRecruitSlot(0,{key="songnuanyang",town=1,expires=12*600,ready=0});
::drawValue=1;F.query();expect(A.recruitOfferSlot("songnuanyang")==0&&A.getRecruitSlot(3).key=="","old active visitor preserved without duplicate");
expect(A.candidateInRoster(F.townRosters[1],"songnuanyang")==legacy,"legacy actor preserved");
F.advance(13);F.query();expect(A.recruitOfferSlot("songnuanyang")==3&&A.getRecruitSlot(0).key!="songnuanyang","old qualified visitor migrates to lottery lane at expiry");

// Hostile/military towns must neither show nor consume random attempts.
F.reset();::drawCalls=0;F.towns[1].friendly=false;F.query();F.towns[1].friendly=true;F.towns[1].military=true;F.query();
expect(::drawCalls==0&&!A.get("random_recruit_eligible_xiaogui",false),"ineligible settlements do not draw or reveal visitors");

F.reset();F.advance(35);F.progress(99,99,99,11);::drawValue=1;F.query();
expect(F.townRosters[1].getSize()==5,"three regular candidates and both visitors can coexist");
local allOffers=clone F.townRosters[1].actors;
A.withProtectedCandidates(F.towns[1],function(force){F.townRosters[1].actors=[];},true);
foreach(b in allOffers)expect(F.townRosters[1].actors.find(b)!=null,"native refresh protects every regular and random actor");

// The optional DLC still uses the ordinary lane and its original day35 gates.
dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");
F.reset();F.progress(14,5,6,5);::drawValue=1;
foreach(key in A.CharacterOrder)if(!A.Characters[key].isCaptain&&!A.isRandomRecruit(key)&&key!="xiwen")A.set("departed_"+key,true);
F.advance(34);F.query();expect(A.recruitOfferSlot("xiwen")<0,"DLC still unavailable onday34");
F.advance(35);F.query();expect(A.recruitOfferSlot("xiwen")>=0&&A.recruitOfferSlot("xiwen")<3,"DLC uses normal slots onday35");
expect(A.RecruitOfferCount==5&&A.candidateInRoster(F.townRosters[1],"xiwen").getHiringCost()==590,"DLC preserves visitor slots and590 quote");
expect(F.hireKey("xiwen")==0&&A.findCharacter("xiwen")!=null,"DLC native hiring works alongside random visitors");
print("TESTS_PASSED="+::pacingChecks+"\n");
