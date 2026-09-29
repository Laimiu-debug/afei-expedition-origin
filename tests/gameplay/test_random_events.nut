// Exercise real preload, scheduler, option closures and native resource methods.
// Only world/roster state, event base and engine presentation are substituted.
::include <- function(path){dofile("src/"+path+".nut");};
::mods_registerMod <- function(...){};::mods_queue <- function(...){};
dofile("src/scripts/!mods_preload/mod_afeix_expedition.nut");
::Math <- {min=function(a,b){return a<b?a:b;},max=function(a,b){return a>b?a:b;},
    minf=function(a,b){return a<b?a:b;},maxf=function(a,b){return a>b?a:b;},
    floor=function(v){return ::floor(v);},rand=function(a,b){return a;}};
::Const <- {MoodState={Neutral=2},Difficulty={MaxResources=[{Medicine=100,ArmorParts=100}]},
    Sound={MoneyTransaction=["silent"],Volume={Inventory=0}}};
dofile(".cache/afei-art/native-contract-fixture/asset_manager.nut");
::Sound <- {play=function(...){}};
::randomTest <- {now=1000000,day=10,flags={},actors=[],safe=true,moving=false,town={},
    origin=true,tactical=false,combat=0,threats=[]};
::Tactical <- {isActive=function(){return ::randomTest.tactical;}};
local assets=clone ::asset_manager;assets.setdelegate(getroottable());assets.m=clone ::asset_manager.m;
assets.m.EconomicDifficulty=0;
assets.getStash=function(){return {getNumberOfEmptySlots=function(){return 10;}};};
::World <- {Assets=assets,State={getCombatStartTime=function(){return ::randomTest.combat;},
    getPlayer=function(){return {getPos=function(){return {};},m={Destination=::randomTest.moving?{}:null}};}},
    getAllEntitiesAtPos=function(p,r){return ::randomTest.threats;},getTime=function(){return {Days=::randomTest.day};}};
local A=::AfeixExpedition,n=0;
local expect=function(v,label){++n;if(!v)throw "FAIL random events: "+label;};
A.isOrigin=function(){return ::randomTest.origin;};A.worldNow=function(){return ::randomTest.now;};
A.daysInSeconds=function(d){return d*86400;};A.canManage=function(){return ::randomTest.safe;};
A.currentTown=function(){return ::randomTest.town;};A.refreshAssets=function(){};
A.roster=function(){return ::randomTest.actors;};A.characterId=function(a){return a.key;};
A.findCharacter=function(key){foreach(a in this.roster())if(a.key==key)return a;return null;};
A.get=function(k,fallback=0){return k in ::randomTest.flags?::randomTest.flags[k]:fallback;};
A.set=function(k,v){::randomTest.flags[k]<-v;return v;};A.nextChronicle=function(){return "";};
::inherit <- function(path,object){
    if(path!="scripts/events/event")throw "Unexpected base";
    object.m.Score<-0;object.m.ID<-"";object.m.Title<-"";object.m.Cooldown<-0;return object;
};
dofile("src/scripts/events/events/afeix_factions_event.nut");
function randomActor(key){return {key=key,alive=true,dying=false,mood=0.0,
    isAlive=function(){return this.alive;},isDying=function(){return this.dying;},
    getHitpoints=function(){return 100;},getHitpointsMax=function(){return 100;},
    improveMood=function(v,r){this.mood+=v;},worsenMood=function(v,r){this.mood-=v;}};}
function randomReset(){
    local s=::randomTest,A=::AfeixExpedition;s.flags={};s.actors=[];s.now=1000000;s.day=10;
    s.origin=true;s.tactical=false;s.combat=0;s.threats=[];s.safe=true;s.moving=false;s.town={};
    foreach(key in A.CharacterOrder)s.actors.push(randomActor(key));s.actors.push(randomActor("ordinary"));
    local m=::World.Assets.m;m.Money=100;m.ArmorParts=10.5;m.Medicine=10.5;m.Score=0;
    m.ArmorPartsMaxAdditional=0;m.MedicineMaxAdditional=0;
}
function randomPrepare(key){
    local A=::AfeixExpedition,d=A.IdeaScenes[key].random;
    ::randomTest.safe=d.place!="road";::randomTest.moving=!::randomTest.safe;
    ::randomTest.town=d.place=="town"?{}:null;
    foreach(k,s in A.IdeaScenes)A.set("ideas_cd_"+k,k==key?0:2000000);
    local e=clone ::afeix_factions_event;e.m=clone ::afeix_factions_event.m;e.create();e.onUpdateScore();e.onPrepare();return e;
}
function randomPause(){::randomTest.safe=false;::randomTest.moving=false;::randomTest.town=null;}

randomReset();expect(A.RandomIdeaOrder.len()==10,"ten new scenes loaded through production entry point");
foreach(key in A.RandomIdeaOrder){
    local d=A.IdeaScenes[key];
    expect(d.choices.len()==3&&d.outcomes.len()==3&&d.effects.len()==3,"complete dialogue "+key);
    foreach(member in d.random.members)expect(member in A.Characters,"real actor prerequisite "+key);
    for(local choice=0;choice<3;++choice){
        randomReset();local e=randomPrepare(key);
        expect(e.m.Score==35&&e.m.Idea==key&&e.onDetermineStartScreen()=="opening","native event selects "+key);
        local opening=e.getScreen("opening");expect(opening.Options.len()==3,"three visible choices "+key);
        randomPause();local selected=opening.Options[choice];
        expect(selected.getResult(e)=="result"&&e.m.Outcome==d.outcomes[choice],"independent ending after native pause "+key);
        expect(e.getScreen("result").Options.len()==1,"result exits safely "+key);
        local money=assets.m.Money,parts=assets.m.ArmorParts,medicine=assets.m.Medicine,mood=A.findCharacter("afei").mood;
        expect(selected.getResult(e)=="retry"&&assets.m.Money==money&&assets.m.ArmorParts==parts&&assets.m.Medicine==medicine&&A.findCharacter("afei").mood==mood,"duplicate option cannot reapply "+key);
        expect(A.get("ideas_cd_"+key)==::randomTest.now+A.daysInSeconds(d.days)&&A.get("ideas_next")==::randomTest.now+A.daysInSeconds(1.5),"shared and individual cooldown "+key);
        expect(e.getScreen("retry").Options.len()==4,"retry has room for safe exit "+key);
    }
    randomReset();randomPrepare(key);::randomTest.day=2;expect(!A.ideaEligible(key),"no first two day scene "+key);
    ::randomTest.day=3;expect(A.ideaEligible(key),"third day eligible "+key);
    ::randomTest.origin=false;expect(!A.ideaEligible(key),"other origin excluded "+key);::randomTest.origin=true;
    ::randomTest.tactical=true;expect(!A.ideaEligible(key),"tactical excluded "+key);::randomTest.tactical=false;
    ::randomTest.combat=1;expect(!A.ideaEligible(key),"combat transition excluded "+key);::randomTest.combat=0;
    ::randomTest.threats=[{isAlive=function(){return true;},isAlliedWithPlayer=function(){return false;},getTroops=function(){return [1];}}];
    expect(!A.ideaEligible(key),"nearby hostiles excluded "+key);::randomTest.threats=[];
    foreach(member in d.random.members){
        local a=A.findCharacter(member);a.alive=false;expect(!A.ideaEligible(key),"dead speaker excluded "+member);a.alive=true;
        a.dying=true;expect(!A.ideaEligible(key),"dying speaker excluded "+member);a.dying=false;
    }
    ::randomTest.actors=[];expect(!A.ideaEligible(key),"insufficient roster excluded "+key);
}

randomReset();randomPrepare("xiaoning_map");::randomTest.moving=false;expect(!A.ideaEligible("xiaoning_map"),"road scene needs movement");
::randomTest.safe=true;expect(!A.ideaEligible("xiaoning_map"),"road scene excluded at camp");
randomReset();randomPrepare("mocha_receipt");::randomTest.town=null;expect(!A.ideaEligible("mocha_receipt"),"refund requires town");
randomReset();randomPrepare("er_blanket");randomPause();expect(!A.ideaEligible("er_blanket"),"camp scene excluded on open road");
randomReset();randomPrepare("bao_spares");randomPause();expect(!A.ideaEligible("bao_spares"),"either scene excludes unsafe stationary party");
::randomTest.moving=true;expect(A.ideaEligible("bao_spares"),"either scene allows travel");

randomReset();local e=randomPrepare("xiaoyueya_salvage");local opening=e.getScreen("opening");assets.m.Money=19;
expect(opening.Options[1].getResult(e)=="retry"&&assets.m.ArmorParts==10.5&&assets.m.Money==19,"unaffordable exchange changes nothing");
expect(A.get("ideas_done_token")==0&&A.get("ideas_next")==0,"failed choice retains token and cooldown");
assets.m.Money=20;assets.m.ArmorParts=95.5;
expect(opening.Options[1].getResult(e)=="retry"&&assets.m.Money==20&&assets.m.ArmorParts==95.5,"fractional full tools reject before payment");
assets.m.ArmorPartsMaxAdditional=10;
expect(opening.Options[1].getResult(e)=="result"&&assets.m.Money==0&&assets.m.ArmorParts==100.5,"exact payment and expanded cap preserve fractions");

randomReset();e=randomPrepare("bao_spares");assets.m.Medicine=98.5;
expect(e.getScreen("opening").Options[1].getResult(e)=="retry"&&assets.m.Medicine==98.5,"medicine capacity rejects partial gift");
expect(e.getScreen("retry").Options[0].getResult(e)=="result"&&assets.m.ArmorParts==14.5&&assets.m.Medicine==98.5,"retry can select alternate complete gift");
randomReset();e=randomPrepare("bao_spares");assets.m.Medicine=98;
expect(e.getScreen("opening").Options[1].getResult(e)=="result"&&assets.m.Medicine==100,"medicine exact capacity fits");

randomReset();e=randomPrepare("xiaoyueya_salvage");local originalAdd=assets.addArmorParts;
assets.addArmorParts=function(n){this.m.ArmorParts+=1;throw "Simulated mod hook failure";};
expect(e.getScreen("opening").Options[1].getResult(e)=="retry"&&assets.m.ArmorParts==10.5&&assets.m.Money==100,"partial mutation rolled back without charge");
assets.addArmorParts=originalAdd;
expect(e.getScreen("retry").Options[1].getResult(e)=="result"&&assets.m.ArmorParts==15.5&&assets.m.Money==80,"retry exchange succeeds once");
randomReset();e=randomPrepare("xiaoyueya_salvage");assets.addArmorParts=function(n){this.m.ArmorParts+=1;};
expect(e.getScreen("opening").Options[1].getResult(e)=="retry"&&assets.m.ArmorParts==10.5&&assets.m.Money==100,"silent clamp rolls back");assets.addArmorParts=originalAdd;

randomReset();e=randomPrepare("cao_chorus");A.findCharacter("keke").alive=false;A.findCharacter("xiaogui").dying=true;
expect(e.getScreen("opening").Options[1].getResult(e)=="result"&&assets.m.Money==75,"tea paid once");
expect(A.findCharacter("ordinary").mood==0.5&&A.findCharacter("mocha").mood==0.5&&A.findCharacter("keke").mood==0&&A.findCharacter("xiaogui").mood==0,"whole living roster including ordinary reserves receives mood");
expect(A.get("ideas_cao_until")==0&&A.get("ideas_cao_serial")==0,"chorus does not arm combat bleeding");
randomReset();e=randomPrepare("xiaogui_board");e.getScreen("opening").Options[0].getResult(e);
expect(A.findCharacter("xiaogui").mood==0.5&&A.findCharacter("afei").mood==-0.25&&A.findCharacter("ordinary").mood==0,"opposed personal outcomes stay personal");
randomReset();e=randomPrepare("mocha_receipt");e.getScreen("opening").Options[0].getResult(e);
expect(assets.m.Money==135&&assets.m.Score==0.35,"refund uses native money method");

randomReset();e=randomPrepare("xiaoning_map");::randomTest.actors.remove(::randomTest.actors.find(A.findCharacter("laocai")));
expect(e.getScreen("opening").Options[1].getResult(e)=="retry"&&assets.m.Money==100&&A.get("ideas_next")==0,"speaker leaving between opening and choice cancels without charge");
expect(e.getScreen("retry").Options[3].getResult(e)==0,"missing speaker still permits exit");
randomReset();e=randomPrepare("mocha_receipt");local oldToken=e.m.Token;randomPrepare("mocha_receipt");
expect(!A.resolveIdea("mocha_receipt",0,oldToken).ok&&assets.m.Money==100,"stale event token rejected");
expect(!A.resolveIdea("mocha_receipt",-1,A.get("ideas_active_token")).ok&&!A.resolveIdea("mocha_receipt",3,A.get("ideas_active_token")).ok,"invalid options cannot settle");

randomReset();randomPrepare("er_blanket");A.set("ideas_hurt_notice",true);expect(A.chooseIdea()=="hurt","injury notice keeps priority over expanded random pool");
A.set("ideas_hurt_notice",false);A.nextChronicle=function(){return "liu";};expect(A.chooseIdea()=="liu","character chronicle keeps priority");A.nextChronicle=function(){return "";};
randomReset();e=randomPrepare("er_blanket");e.getScreen("opening").Options[2].getResult(e);
::randomTest.now+=A.daysInSeconds(1.5);A.set("ideas_cd_bao_spares",0);
expect(A.ideaEligible("bao_spares")&&!A.ideaEligible("er_blanket"),"shared expiry allows other scenes but keeps own cooldown");
::randomTest.now+=A.daysInSeconds(6.5);expect(A.ideaEligible("er_blanket"),"individual cooldown expires at eight days");
print("TESTS_PASSED="+n+"\n");
