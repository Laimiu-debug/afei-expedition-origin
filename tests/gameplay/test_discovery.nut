local checks = 0;
function check(value, message) { if (!value) throw "FAIL " + message; }
local expect = function(value, message) { checks++; check(value, message); };
::include <- function(path) { dofile("src/" + path + ".nut"); };
::mods_registerMod <- function(...) {};
::mods_queue <- function(...) {};
::Math <- { function max(a,b) { return a>b?a:b; }, function min(a,b) { return a<b?a:b; }, function rand(a,b) { return a; } };
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
local A=::AfeixExpedition, flags={}, brothers=[], safe=true, origin=true, day=1;
local tavern={}, town={ function getID(){return 51;}, function getNameOnly(){return "Test Inn";}, function isAlive(){return true;}, function isAlliedWithPlayer(){return true;} };
::World <- {
    Assets={function getMoney(){return 2000;}},
    Flags={ function has(k){return k in flags;},function get(k){return flags[k];},function set(k,v){flags[k]<-v;} },
    State={m={WorldTownScreen={m={LastActiveModule=tavern},function getTavernDialogModule(){return tavern;},function isVisible(){return true;}}}},
    function getTime(){return {Days=day};}
};
A.isOrigin=function(){return origin;}; A.canManage=function(){return safe&&origin;}; A.currentTown=function(){return town;};
A.roster=function(){return brothers;}; A.deployedIds=function(){return [1,2,3];};
local makeBro=function(key){return {
    level=1,battles=0,
    function getFlags(){return {function has(k){return k=="afeix_character";},function get(k){return key;}};},
    function getLevel(){return this.level;},function getLifetimeStats(){return {Battles=this.battles};},function isAlive(){return true;}
};};
foreach(key in ["afei","damou","mocha"]){brothers.push(makeBro(key));A.set("ever_"+key,true);}
local event={m={Notice="",Selected=[],FormationPage=0}};
local freshHome=A.ledgerPage(event,"home"), freshMembers=A.ledgerPage(event,"recruits");
expect(freshHome.Options.len()==5 && freshMembers.Options.len()==4,"basic controls, training and three captains on fresh start");
foreach(page in ["home","quest","recruits","growth","roots:0","promotion","promotion:feidie","bicycle","bicycle_release_confirm"]){
    local screen=A.ledgerPage(event,page), text=screen.Text;
    foreach(option in screen.Options)text+=option.Text;
    foreach(secret in ["六根","飞碟","自行车","刀一","刀二","九月联动","{"]) expect(text.find(secret)==null,"no secret leaked by "+page);
}
foreach(key in A.CharacterOrder)if(!A.Characters[key].isCaptain){
    expect(!A.isCharacterKnown(key)&&A.characterStatus(key)=="locked","unmet member hidden "+key);
    expect(A.ledgerPage(event,"recruit:"+key).Text.find(A.Characters[key].name)==null,"direct profile sealed "+key);
    expect(A.ledgerPage(event,"encounter:"+key).Text.find(A.Characters[key].encounterTitle)==null,"direct encounter sealed "+key);
}
expect(A.EncounterRequirements.len()==31,"all 31 recruits have independent conditions");
foreach(key,requirement in A.EncounterRequirements){
    local metrics={days=999,jobs=99,types=9,battles=99,level=11,towns=99,companions=34};
    expect(A.canMeetCharacter(key,metrics),"reachable condition "+key);
    foreach(field,threshold in requirement){
        local low=clone metrics;low[field]=threshold-1;
        expect(!A.canMeetCharacter(key,low),"real boundary "+key+"/"+field);
    }
    expect(!A.isCharacterKnown(key),"eligibility checks do not discover "+key);
}
A.TavernTown=51;
// Early progression uses the production V2 override, not discovery.nut's legacy
// fallback requirements. Bottle becomes available at the first paid outing;
// Lili waits for the second stage without requiring Bottle to be hired.
local firstTrip={days=3,jobs=1,battles=1,towns=2,level=2,types=1,companions=3};
expect(A.canMeetCharacter("bottle",firstTrip),"day3 ordinary progress unlocks Bottle");
expect(!A.canMeetCharacter("lili",firstTrip),"Lili waits for day6 exploration");
local beforeBottle=clone firstTrip;beforeBottle.days=2;
expect(!A.canMeetCharacter("bottle",beforeBottle),"Bottle waits until day3");
foreach(field in ["jobs","battles","towns","level"]){
    local incomplete=clone firstTrip;incomplete[field]--;
    expect(!A.canMeetCharacter("bottle",incomplete),"Bottle date cannot bypass "+field);
}
local secondTrip={days=6,jobs=1,battles=2,towns=3,level=2,types=1,companions=3};
expect(A.canMeetCharacter("lili",secondTrip),"day6 attainable progress unlocks Lili without extra members or contract types");
local beforeLili=clone secondTrip;beforeLili.days=5;
expect(!A.canMeetCharacter("lili",beforeLili),"Lili waits until day6 even after other milestones");
foreach(field in ["jobs","battles","towns","level"]){
    local incomplete=clone secondTrip;incomplete[field]--;
    expect(!A.canMeetCharacter("lili",incomplete),"Lili date cannot bypass "+field);
}
expect(A.prepareTavernMeeting()=="tavern" && A.get("tavern_towns")==1,"initial inn visit records location but no free recruit");
A.set("paid_contracts",1);
expect(A.prepareTavernMeeting()=="tavern" && !A.isCharacterKnown("bottle"),"tavern does not bypass native hiring queue");
A.set("paid_contracts",9);brothers[0].level=7;brothers[0].battles=9;
local before=A.knownMembers().len();A.prepareTavernMeeting();
expect(A.knownMembers().len()==before,"same town/day cannot reroll more members");
day++;A.prepareTavernMeeting();expect(A.knownMembers().len()==before,"waiting in tavern cannot generate people");
expect(A.get("tavern_towns")==1,"repeated visits do not inflate explored towns");
A.TavernTown=0;before=A.knownMembers().len();
expect(A.prepareTavernMeeting()=="home"&&A.knownMembers().len()==before,"F8 outside tavern cannot discover members");
A.set("met_bottle",true);A.set("encounter_done_bottle",true);
expect(A.isRecruitUnlocked("bottle"),"durable invitation uses completed encounter");
A.set("dead_bottle",true);expect(A.characterStatus("bottle")=="dead"&&!A.canMeetCharacter("bottle"),"deceased identity never reappears");
flags.clear();foreach(key in ["afei","damou","mocha"])A.set("ever_"+key,true);
expect(!A.growthKnown("afei") && A.ledgerPage(event,"member_growth:afei").Text.find(A.MemberGrowth.afei.scene)==null,"eligible but untriggered growth sealed");
expect(A.nextDiscovery()=="member_growth:afei","actual experience schedules growth scene");
expect(A.revealDiscovery("member_growth:afei")&&A.growthKnown("afei"),"showing scene records discovery");
A.set("growth_done_afei",true);
expect(A.nextDiscovery()=="promotion"&&!A.promotionKnown(),"promotion eligible only after growth without preview leak");
A.revealDiscovery("promotion");
expect(A.promotionKnown()&&!A.feidieKnown(),"ordinary discovery does not reveal hidden route");
expect(A.ledgerPage(event,"promotion").Text.find("六根")==null,"ordinary promotion does not describe hidden unlocks");
foreach(route in ["promotion:toad","promotion:jiahao"]) {
    expect(A.ledgerPage(event,route).Text.find("六根")==null,"ordinary route does not leak hidden root records");
}
expect(A.ledgerPage(event,"promotion:feidie").Text.find("飞碟")==null,"hidden route direct page sealed");
A.set("paid_contracts",3);
expect(A.nextDiscovery()==null && A.nextDiscovery(true)=="roots:er_xiaoyuan","first contact needs tavern context");
A.revealDiscovery("roots:er_xiaoyuan");
expect(A.knownRoots().len()==1&&!A.feidieKnown(),"one letter reveals only its author");
local letters=A.ledgerPage(event,"roots:0");expect(letters.Options.len()==2&&letters.Text.find("/ 6")==null,"letter list does not leak total checklist");
A.set("paid_contracts",9);foreach(key in ["keke","xiaogui","yuchujiu"])A.set("ever_"+key,true);
foreach(id in A.RootOrder)A.revealDiscovery("roots:"+id);
expect(A.rootsUnlocked()&&!A.feidieKnown(),"six independent openings qualify, then await their own reveal");
expect(!A.revealDiscovery("promotion:feidie"),"roots alone cannot reveal hidden promotion");
brothers[0].level=9;brothers[0].battles=11;
expect(!A.revealDiscovery("promotion:feidie"),"hidden reveal needs twelve personal battles");
brothers[0].battles=12;A.set("growth_done_afei",false);
expect(!A.revealDiscovery("promotion:feidie"),"hidden reveal needs personal growth");A.set("growth_done_afei",true);
expect(A.nextDiscovery()=="promotion:feidie"&&A.revealDiscovery("promotion:feidie")&&A.feidieKnown(),"hidden route discovered after actual openings");
safe=false;expect(A.nextDiscovery()==null&&!A.revealDiscovery("bicycle"),"unsafe state cannot trigger stories");safe=true;
origin=false;expect(!A.canMeetCharacter("lili")&&A.nextDiscovery()==null,"other origins unaffected");origin=true;
// Real tavern hook: original drinks UI opens first; stale callbacks cannot open a meeting.
local hook=null, nativeClicks=0, scheduled=null, opens=0;
::mods_hookExactClass <- function(path,callback){if(path=="entity/world/settlements/buildings/tavern_building")hook=callback;};
::mods_hookNewObject <- function(...){};::mods_hookBaseClass <- function(...){};
::TimeUnit <- {Real=0};::Time <- {function scheduleEvent(unit,delay,callback,tag){scheduled={callback=callback,tag=tag};}};
dofile("src/scripts/mods/afeix/hooks.nut");
local building={function onClicked(screen){nativeClicks++;return 72;},function getSettlement(){return town;}};
hook(building);A.openLedger=function(page,id){opens++;return true;};
expect(building.onClicked({})==72&&nativeClicks==1&&scheduled!=null,"native tavern retained before deferred meeting");
scheduled.callback(scheduled.tag);expect(opens==1,"valid tavern callback opens discovery ledger");
::World.State.m.WorldTownScreen.m.LastActiveModule=null;
scheduled.callback(scheduled.tag);expect(opens==1,"leaving tavern cancels deferred meeting");
origin=false;scheduled=null;building.onClicked({});expect(nativeClicks==2&&scheduled==null,"other origin tavern not intercepted");
print("TESTS_PASSED="+checks+"\n");
