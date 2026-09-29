// Execute the native budget setup and the production origin together.
::Const <- {MoodState={Neutral=0},World={Assets={NewCampaignEquipment=[]}}};
::Math <- {max=function(a,b){return a>b?a:b;},rand=function(){return 123;}};
::inherit <- function(path,members){return members;};
::removeFromBeginningOfText <- function(prefix,text){return text;};
::created <- [];::items <- [];::storyItems <- 0;
::AfeixExpedition <- {Schema=8,RosterMax=40,CombatMax=12,set=function(...) {},
    makeCharacter=function(key,slot){::created.push({key=key,slot=slot});return {};},
    ensureStoryItems=function(){::storyItems++;},enforceFormation=function(){}};
::new <- function(path){return {amount=0,setAmount=function(n){this.amount=n;}};};
::World <- {FactionManager={getGreaterEvil=function(){return {Type=0};}},
    getPlayerRoster=function(){return {getAll=function(){return [];}};}};
dofile(".cache/afei-art/native-contract-fixture/asset_manager.nut");
dofile("src/scripts/scenarios/world/afeix_expedition_scenario.nut");
local origin=clone ::afeix_expedition_scenario;origin.setdelegate(getroottable());
local assets=clone ::asset_manager;assets.m=clone assets.m;assets.setdelegate(getroottable());
assets.m.Stash={clear=function(){::items=[];},add=function(item){::items.push(item);},remove=function(item){}};
assets.getFoodItems=function(){return [];};assets.updateFood=function(){};assets.updateFormation=function(){};
::World.Assets <- assets;
local settings={Name="Budget test",Banner="banner_01",Difficulty=1,EconomicDifficulty=1,
    Ironman=false,PermanentDestruction=false,StartingScenario=origin,ExplorationMode=false,
    Seed="test",GreaterEvil=0,BudgetDifficulty=0};
local checks=0;local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
local expected=[[2250,60,22,50],[1800,30,15,25],[1350,15,7,12]];
foreach(budget,values in expected){
    ::created=[];::storyItems=0;settings.BudgetDifficulty=budget;
    assets.setCampaignSettings(settings);
    check(assets.m.Money==values[0],"native selected money "+budget);
    check(assets.m.ArmorParts==values[1],"native selected tools "+budget);
    check(assets.m.Medicine==values[2],"native selected medicine "+budget);
    check(assets.m.Ammo==values[3],"native selected ammo "+budget);
    check(::created.len()==3&&::created[0].key=="afei"&&::created[1].key=="damou"&&::created[2].key=="mocha","three captains");
    check(::created[0].slot==3&&::created[1].slot==4&&::created[2].slot==12,"opening formation");
    check(::items.len()==2&&::items[0].amount+::items[1].amount==50,"opening food unchanged");
    check(::storyItems==1,"starting keepsake once");
    local saved=[assets.m.Money,assets.m.ArmorParts,assets.m.Medicine,assets.m.Ammo];
    origin.onInit();
    check(assets.m.Money==saved[0]&&assets.m.ArmorParts==saved[1]&&assets.m.Medicine==saved[2]&&assets.m.Ammo==saved[3],"origin init cannot regrant or rescale supplies");
}
print("TESTS_PASSED="+checks+"\n");
