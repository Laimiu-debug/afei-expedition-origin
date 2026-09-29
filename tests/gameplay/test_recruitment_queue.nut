// Production queue behavior with real native hiring; engine rendering is external.
dofile("tests/gameplay/recruitment_pacing_fixture.nut");
local F=::PacingFixture,A=F.A;
expect(A.RecruitOfferDays==4&&A.RecruitReturnOfferDays==2,"first meeting four days, repeat two days");
expect(A.RecruitReturnPriorityDays==6&&A.RecruitNewBurst==2,"aged returns protected after two new introductions");

// Late progress can unlock several stages at once, independent of source order.
F.reset();F.advance(60);F.progress(99,99,99,11);F.query();
foreach(i,key in ["shuaizi","bottle","xiaoyueya"]){
 expect(A.getRecruitSlot(i).key==key,"same-batch unlocks follow scheduled dates "+key);
 expect(A.getRecruitSlot(i).expires==63*600,"first introduction retains four full days");
}
expect(A.get("recruit_order_yanzi")<A.get("recruit_order_laocai"),"day12 precedes day14 within same batch");
local existing=A.get("recruit_order_shuaizi");
F.query();expect(A.get("recruit_order_shuaizi")==existing,"reopening does not reorder pending identities");
// An already saved queue retains its relative order on upgrade.
F.reset();F.advance(60);F.progress(99,99,99,11);
A.set("recruit_order_lili",1);A.set("recruit_order_bottle",2);A.set("recruit_queue_serial",2);
F.query();expect(A.getRecruitSlot(0).key=="lili"&&A.getRecruitSlot(1).key=="bottle","legacy queue order survives new date sorting");
local migratedAt=A.get("recruit_queued_at_lili",-1);
F.advance(61);F.query();expect(migratedAt==59*600&&A.get("recruit_queued_at_lili")==migratedAt,"legacy wait time initialized only once");

// One available member stays hireable; revisits do not extend its offer timer.
F.reset();F.advance(2);F.progress(0,0,2,1);F.query();
expect(A.recruitOfferSlot("shuaizi")==0&&A.getRecruitSlot(0).expires==5*600,"single first-time offer lasts until day6");
F.advance(6);F.query();local repeat=A.candidateInRoster(F.townRosters[1],"shuaizi");
local quote=repeat.getHiringCost(),repeatUntil=A.getRecruitSlot(0).expires;
expect(repeatUntil==7*600,"single available return is shown immediately for two days");
F.hire.setRosterID(2);F.hire.queryHireInformation();
expect(A.candidateInRoster(F.townRosters[2],"shuaizi")==repeat&&A.getRecruitSlot(0).expires==repeatUntil,"moving towns keeps returning actor and deadline");
local saved=clone ::World.Flags.values;::World.Flags.values=clone saved;
dofile("src/scripts/mods/afeix/recruitment.nut");A.configureRecruitment(A.BalanceV26.recruitment);A.restoreHireCandidate();
F.query();expect(A.candidateInRoster(F.townRosters[1],"shuaizi")==repeat&&A.getRecruitSlot(0).expires==repeatUntil,"reload preserves returning actor and deadline");
F.advance(7.999);F.query();expect(A.candidateInRoster(F.townRosters[1],"shuaizi")==repeat,"return stays until exact expiry");
F.advance(8);F.progress(99,99,99,11);F.query();
expect(A.recruitOfferSlot("shuaizi")<0&&A.recruitOfferSlot("bottle")>=0,"return releases room for unseen eligible people at boundary");
expect(A.get("recruit_queued_at_shuaizi")==repeatUntil,"return waiting begins at real expiry");
// Do not shrink offers already visible in an older save, even known returns.
F.reset();F.advance(10);F.progress(0,0,2,1);
A.set("recruit_slots_v1",true);A.set("met_shuaizi",true);A.set("native_recruit_shuaizi",true);
local legacy=A.createHireCandidate("shuaizi",F.townRosters[1]);
A.saveRecruitSlot(0,{key="shuaizi",town=1,expires=13*600,ready=0});
F.query();expect(A.candidateInRoster(F.townRosters[1],"shuaizi")==legacy&&A.getRecruitSlot(0).expires==13*600,"active legacy four-day return is not shortened");

// Aged returns cannot starve behind a long series of new unlocks.
F.reset();A.set("met_shuaizi",true);A.set("native_recruit_shuaizi",true);A.queueRecruit("shuaizi");
A.set("met_bottle",true);A.set("native_recruit_bottle",true);A.queueRecruit("bottle");
F.advance(60);F.progress(99,99,99,11);F.query();
expect(A.getRecruitSlot(0).key=="xiaoyueya"&&A.getRecruitSlot(1).key=="yuchujiu"&&A.getRecruitSlot(2).key=="shuaizi","two fresh faces then oldest aged return");
expect(A.getRecruitSlot(2).expires==61*600&&A.get("recruit_new_streak")==0,"return uses two-day window and resets successful-new streak");
expect(A.get("recruit_queued_at_bottle")==0,"another aged return retains its original wait");
F.advance(62);F.query();expect(A.getRecruitSlot(2).key=="lili","next vacancy resumes new introductions");
local streak=A.get("recruit_new_streak");
for(local i=0;i<5;i++)A.nextQueuedRecruit();
expect(A.get("recruit_new_streak")==streak,"queue lookups cannot consume fairness turns");
saved=clone ::World.Flags.values;::World.Flags.values=clone saved;
dofile("src/scripts/mods/afeix/recruitment.nut");A.configureRecruitment(A.BalanceV26.recruitment);
expect(A.get("recruit_new_streak")==streak&&A.get("recruit_queued_at_bottle")==0,"fairness counter and original wait persist across reload");
F.advance(64);F.query();
expect(A.recruitOfferSlot("bottle")>=0,"second aged return served after next two successful introductions");
expect(A.candidateInRoster(F.townRosters[1],"bottle").getHiringCost()>0,"return still requires native payment");
// Priority begins after six complete waiting days, not six menu openings.
F.reset();A.set("met_shuaizi",true);A.queueRecruit("shuaizi");A.set("recruit_new_streak",2);
F.advance(6.999);F.progress(99,99,99,11);A.updateRecruitEligibility();
expect(A.nextQueuedRecruit()=="bottle","just before six-day waiting boundary new person leads");
F.advance(7);expect(A.nextQueuedRecruit()=="shuaizi","six-day boundary promotes aged return");
// A long absence counts waiting from expiry, but does not shorten current offers.
F.reset();F.advance(2);F.progress(0,0,2,1);F.query();F.advance(20);F.progress(99,99,99,11);F.query();
expect(A.get("recruit_queued_at_shuaizi")==5*600,"long absence uses actual expired deadline as return age");
expect(A.recruitOfferSlot("shuaizi")>=0,"long-waiting former offer receives protected return");

// A single broken actor cannot block later identities or the independent guests.
F.reset();F.advance(60);F.progress(99,99,99,11);
local originalMake=A.makeCharacter,attempts={};
A.makeCharacter=function(key,place=255,roster=null){
 attempts[key]<-(key in attempts?attempts[key]:0)+1;
 if(key=="shuaizi")throw "fixture: only this character fails";
 return originalMake(key,place,roster);
};
local originalRand=::Math.rand;::Math.rand=function(a,b){return 1;};F.query();
expect(attempts.shuaizi==1&&A.recruitOfferSlot("shuaizi")<0,"failed identity attempted once in this query");
foreach(key in ["bottle","xiaoyueya","yuchujiu"])expect(A.recruitOfferSlot(key)>=0,"another healthy regular fills vacancy "+key);
expect(A.recruitOfferSlot("songnuanyang")==3&&A.recruitOfferSlot("xiaogui")==4,"regular failure does not block either visitor");
expect(F.townRosters[1].getSize()==5&&!A.isCharacterKnown("shuaizi"),"failed member leaves neither orphan nor revealed identity");
local retainedOrder=A.get("recruit_order_shuaizi"),retainedTime=A.get("recruit_queued_at_shuaizi");
A.makeCharacter=originalMake;::Math.rand=originalRand;
expect(F.hireKey("bottle")==0,"healthy candidate still hires through native dialog");
F.query();expect(A.recruitOfferSlot("shuaizi")<0,"failure recovery does not bypass hired slot cooldown");
F.advance(61);F.query();
expect(A.recruitOfferSlot("shuaizi")==0&&A.get("recruit_order_shuaizi")==retainedOrder&&A.get("recruit_queued_at_shuaizi")==retainedTime,"repaired member retains queue priority for next vacancy");
expect(A.getRecruitSlot(0).expires==64*600,"failed creation does not consume first four-day window");

F.reset();F.advance(60);F.progress(99,99,99,11);A.set("recruit_new_streak",1);attempts={};
A.makeCharacter=function(key,place=255,roster=null){attempts[key]<-(key in attempts?attempts[key]:0)+1;throw "fixture: all fail";};
F.query();local tried=0;
foreach(key,count in attempts)if(!A.isRandomRecruit(key)){tried++;expect(count==1,"failed ordinary identity tried at most once per query "+key);}
expect(tried==29&&F.townRosters[1].getSize()==0&&A.get("recruit_new_streak")==1,"all failures terminate and consume no fairness turns");
A.makeCharacter=originalMake;F.query();
expect(A.recruitOfferSlot("shuaizi")==0&&A.recruitOfferSlot("bottle")==1&&A.recruitOfferSlot("xiaoyueya")==2,"all-failure recovery preserves original order");

// No-purchase campaign: first meetings stay prompt; all 29 regular members keep
// returning instead of waiting through thirty four-day first-meeting windows.
F.reset();F.progress(99,99,99,11);local first={},last={},maxFirstDelay=0,maxRepeatGap=0,maxLateRepeatGap=0;
local shown=0,activeBefore={};
for(local day=1;day<=160;day++){
 F.advance(day);F.query();local activeNow={};
 for(local i=0;i<3;i++){
  local key=A.getRecruitSlot(i).key;if(key=="")continue;
  activeNow[key]<-true;
  if(key in activeBefore)continue;
  shown++;
  if(!(key in first)){first[key]<-day;maxFirstDelay=::Math.max(maxFirstDelay,day-A.EncounterRequirements[key].days);}
  if(key in last){
   local gap=day-last[key];maxRepeatGap=::Math.max(maxRepeatGap,gap);
   if(last[key]>=60)maxLateRepeatGap=::Math.max(maxLateRepeatGap,gap);
  }
  last[key]<-day;
 }
 activeBefore=activeNow;
}
expect(first.len()==29,"all regular identities introduced without purchases");
foreach(key in ["shuaizi","bottle","xiaoyueya","yuchujiu","lili","xiaoyubeike","wangduidui"])
 expect(first[key]<=10,"skipping early offers still meets black team by day10 "+key);
expect(maxFirstDelay<=4,"first introductions remain within four days of qualification in daily-visit simulation");
foreach(key,day in last)expect(day>130,"every regular member keeps returning late game "+key);
expect(maxRepeatGap<=30&&maxLateRepeatGap<=20,"unbought roster returns within30 days during unlocks and20 once settled");
print("QUEUE_SIMULATION first_delay="+maxFirstDelay+" repeat_gap="+maxRepeatGap+" late_repeat_gap="+maxLateRepeatGap+" appearances="+shown+"\n");

// DLC registration appends Xiwen to CharacterOrder. It must still participate
// in the same date ordering, new-face priority and aged-return protection.
dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");
expect(A.CharacterOrder[A.CharacterOrder.len()-1]=="xiwen","DLC registers at end of source order");
F.reset();F.advance(36);F.progress(99,99,99,11);
foreach(key in A.CharacterOrder)
 if(!A.Characters[key].isCaptain&&!A.isRandomRecruit(key)&&["meiya","xiwen","wanshe"].find(key)==null)A.set("departed_"+key,true);
F.query();
foreach(i,key in ["meiya","xiwen","wanshe"])expect(A.getRecruitSlot(i).key==key,"DLC day35 sits between day34 and day36 "+key);
expect(A.getRecruitSlot(1).expires==39*600,"DLC first appearance receives same full four days");
expect(A.candidateInRoster(F.townRosters[1],"xiwen").getHiringCost()==590,"DLC retains original590 quote");
F.advance(40);F.query();expect(A.getRecruitSlot(A.recruitOfferSlot("xiwen")).expires==41*600,"DLC repeat uses same two-day window");

F.reset();F.advance(35);F.progress(14,5,6,5);
foreach(key in A.CharacterOrder)
 if(!A.Characters[key].isCaptain&&!A.isRandomRecruit(key)&&["xiwen","shuaizi","bottle","xiaoyueya"].find(key)==null)A.set("departed_"+key,true);
foreach(key in ["shuaizi","bottle","xiaoyueya"]){A.set("met_"+key,true);A.set("native_recruit_"+key,true);A.queueRecruit(key);}
F.query();expect(A.getRecruitSlot(0).key=="xiwen","unseen DLC member leads recent ordinary returns");
expect(F.hireKey("xiwen")==0&&A.findCharacter("xiwen")!=null,"DLC keeps native paid hiring with shared priorities");
F.advance(60);F.query();expect(A.recruitOfferSlot("xiwen")<0,"DLC does not requeue after successful hire");

F.reset();A.set("met_xiwen",true);A.set("native_recruit_xiwen",true);A.queueRecruit("xiwen");
F.advance(60);F.progress(99,99,99,11);
foreach(key in A.CharacterOrder)
 if(!A.Characters[key].isCaptain&&!A.isRandomRecruit(key)&&["meiya","wanshe","tutu","xiwen"].find(key)==null)A.set("departed_"+key,true);
F.query();
expect(A.getRecruitSlot(0).key=="meiya"&&A.getRecruitSlot(1).key=="wanshe"&&A.getRecruitSlot(2).key=="xiwen","aged DLC return protected after two ordinary new faces");
expect(A.getRecruitSlot(2).expires==61*600&&A.get("recruit_new_streak")==0,"DLC return resets common fairness counter and lasts two days");
expect(A.RecruitOfferCount==5&&A.RecruitRegularOfferCount==3&&!A.isRandomRecruit("xiwen"),"DLC uses regular slots without competing for visitors");
print("TESTS_PASSED="+::pacingChecks+"\n");
