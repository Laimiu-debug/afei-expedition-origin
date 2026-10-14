// Compose the real company builder, installed wardrobe hooks, and native
// event input/screen cloning. Engine drawing is outside this regression.
local checks=0,history=true,hidden=true;
local check=function(ok,label){if(!ok)throw "FAIL company ledger: "+label;++checks;};
::Math <- {min=function(a,b){return a<b?a:b;}};
::Const <- {};
::mods_hookNewObject <- function(...){};
::mods_hookExactClass <- function(...){};
::doesBrushExist <- function(name){return true;};
local flags={};
::World <- {Flags={has=function(key){return key in flags;},get=function(key){return flags[key];},set=function(key,value){flags[key]<-value;}}};
::AfeixExpedition <- {
    CombatMax=12,isOrigin=function(){return true;},canManage=function(){return true;},
    roster=function(){return [];},deployedIds=function(){return [];},
    get=function(key,fallback=0){return key=="hide_helmets"?hidden:fallback;},
    hasStoryRecords=function(){return history;},hasIdeaRecords=function(){return false;},
    ensureCompanyHelmetDefault=function(){},
    toggleCompanyHelmets=function(){hidden=!hidden;return {ok=true,text="helmets toggled"};},
    trainingLedgerPage=function(event,page){return null;},treatmentLedgerPage=function(event,page){return null;},
    dreamPage=function(event,page){return null;},
    storyPageNumber=function(text){try{return text.tointeger();}catch(e){return 0;}},
    isPortraitBrush=function(name){return false;},characterPortraitBrush=function(bro){return null;},
    syncWorldPartyArt=function(){return true;}
};
dofile("src/scripts/mods/afeix/ledger.nut");
dofile("src/scripts/mods/afeix/banner_hooks.nut");
dofile(".cache/afei-art/native-contract-fixture/event.nut");
::inherit <- function(path,child){
    local parentDefinition=::event,result=clone parentDefinition;
    foreach(key,value in child)result[key]<-value;
    result.m=clone parentDefinition.m;foreach(key,value in child.m)result.m[key]<-value;
    result.event<-parentDefinition;return result;
};
dofile("src/scripts/events/events/afeix_ledger_event.nut");
local A=::AfeixExpedition,e=::afeix_ledger_event;e.create();
local originalBanner=A.bannerLedgerPage;
check(e.getScreen("company").Options.len()==6,"complete main-package company page retains six options");
check(e.getScreen("home").Options[3].getResult(e)=="company","F8 home exposes company affairs");
dofile(".cache/afei-art/native-contract-fixture/installed_skins_content.nut");
if(!::AFEIX_InstalledSkinsDLC){print("TESTS_PASSED="+checks+"\n");return;}
dofile(".cache/afei-art/native-contract-fixture/installed_skins_hooks.nut");
local wardrobe=::AfeixSkinsDLC.Page+":0";
local expected=["training","treatment","banners"];
e.setScreen(e.getScreen("home"));
check(e.processInput(3)&&e.m.ActiveScreen.ID=="company","native event button enters the company page with wardrobe installed");
local first=e.m.ActiveScreen;
check(first.Options.len()==6,"first page reserves next and return buttons");
for(local i=0;i<3;++i)check(first.Options[i].getResult(e)==expected[i],"first page keeps service destination "+expected[i]);
check(first.Options[5].getResult(e)=="home","first page retains the return-to-ledger footer");
local savedHidden=hidden;
check(e.processInput(3)&&hidden!=savedHidden&&e.m.ActiveScreen.ID=="company","helmet action works and rebuilds a bounded company page");
check(e.processInput(4)&&e.m.ActiveScreen.ID=="company:4","native next-page callback reaches the remaining company features");
local second=e.m.ActiveScreen;
check(second.Options.len()==4&&second.Options.len()<=6,"second page fits all remaining features and both navigation actions");
check(second.Options[0].getResult(e)=="growth"&&second.Options[1].getResult(e)==wardrobe,"history and installed wardrobe remain reachable");
check(second.Options[2].getResult(e)=="company:0"&&second.Options[3].getResult(e)=="home","second page can return to the first page or home");
check(e.processInput(1)&&e.m.ActiveScreen.ID==wardrobe&&e.m.ActiveScreen.Options.len()==6,"native button opens the installed wardrobe's real screen");
check(e.processInput(5)&&e.m.ActiveScreen.ID=="company","wardrobe returns to the repaired company menu");
e.setScreen(e.getScreen("company:4"));
check(e.processInput(2)&&e.m.ActiveScreen.ID=="company:0","native first-page callback returns without losing the DLC option");
foreach(offset in ["-4","999","oops"]){
    local screen=e.getScreen("company:"+offset);
    check(screen.Options.len()<=6&&screen.Options[0].getResult(e)=="training","stale or invalid page offset safely uses the first features");
}
history=false;
check(e.getScreen("company").Options.len()==6,"without history the complete main and wardrobe menu stays on one page");
history=true;A.bannerLedgerPage=originalBanner;
check(e.getScreen("company").Options.len()==6,"removing wardrobe keeps the original single-page menu");
check(flags.len()==0,"menu construction and navigation never buy attributes or change wardrobe save flags");
print("TESTS_PASSED="+checks+"\n");
