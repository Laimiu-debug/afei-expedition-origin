// Exercise installed native updateLook/setCamping plus Legacy Hooks dispatch.
local passed=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;passed++;};
local origin=true,available=true,party=null;
local registry={instance={},exact={}};
::mods_hookNewObject <- function(path,cb){if(!(path in registry.instance))registry.instance[path]<-[];registry.instance[path].push(cb);};
::mods_hookExactClass <- function(path,cb){if(!(path in registry.exact))registry.exact[path]<-[];registry.exact[path].push(cb);};
local makeObject=function(path,object,inherited=false){
    if(inherited && path in registry.exact)foreach(cb in registry.exact[path])cb(object);
    if(path in registry.instance)foreach(cb in registry.instance[path])cb(object);
    object.setdelegate(getroottable());return object;
};
::Const <- {MoodState={Neutral=3}};
::inherit <- function(path,object){return object;};
dofile(".cache/afei-art/native-contract-fixture/asset_manager.nut");
dofile(".cache/afei-art/native-contract-fixture/player_party.nut");
::AfeixExpedition <- {function isOrigin(){return origin;}};
::doesBrushExist <- function(name){return name!="afeix_world_afei"||available;};
dofile("src/scripts/mods/afeix/world_art.nut");
dofile("src/scripts/mods/afeix/world_art_hooks.nut");
local sprite=function(name){return {brush=name,Visible=true,flipped=false,Scale=1.0,
    function setBrush(name){this.brush=name;},function getBrush(){return {Name=this.brush};}};};
local sprites={body=sprite("figure_player_01"),["base"]=sprite("world_base_01"),banner=sprite("banner_15"),
    lighting=sprite("world_player_camp_01_fire"),zoom_banner=sprite("banner_15")};
sprites.lighting.Visible=false;
party={m={IsMirrored=false,BaseMovementSpeed=105,Destination={X=4,Y=8}},sprites=sprites,
    function hasSprite(name){return name in this.sprites;},function getSprite(name){return this.sprites[name];},
    function setMirrored(v){this.m.IsMirrored=v;},setCamping=::player_party.setCamping};
party.setdelegate(getroottable());
local bare=clone ::asset_manager;bare.m=clone ::asset_manager.m;
bare.updateLook=bare.updateLook.bindenv({prototypeOnly=true});
local assets=makeObject("states/world/asset_manager",bare);
::World <- {Assets=assets,State={function getPlayer(){return party;}}};
local A=::AfeixExpedition;
try {
    check("states/world/asset_manager" in registry.instance && !("states/world/asset_manager" in registry.exact),"bare manager hooks actual NewObject entry point");
    assets.updateLook(1);
    check(sprites.body.brush==A.WorldPortraitBrush && assets.m.Look==1,"origin spawn updateLook displays Afei");
    local destination=party.m.Destination;
    foreach(tier in [1,2,9,10,20]){
        sprites.body.flipped=true;
        assets.updateLook(tier);
        check(sprites.body.brush==A.WorldPortraitBrush && assets.m.Look==tier,"native look bookkeeping plus custom brush tier "+tier);
        check(sprites.body.flipped && sprites.body.Scale==1.0 && party.m.IsMirrored,"native direction state and scale preserved");
    }
    check(party.m.Destination==destination && party.m.BaseMovementSpeed==105 && sprites.banner.brush=="banner_15" && sprites.zoom_banner.brush=="banner_15" && sprites["base"].brush=="world_base_01","path speed base and selected banner untouched");
    for(local i=0;i<3;i++){
        assets.setCamping(true);
        check(sprites.body.brush=="world_player_camp_01" && !sprites.banner.Visible && sprites.lighting.Visible,"native camp lighting and banner "+i);
        assets.updateLook(3);
        check(sprites.body.brush=="world_player_camp_01" && !sprites.banner.Visible,"look refresh during camp cannot replace tents");
        assets.setCamping(false);
        check(sprites.body.brush==A.WorldPortraitBrush && sprites.banner.Visible && !sprites.lighting.Visible,"breaking camp returns to Afei "+i);
    }
    available=false;assets.updateLook(4);
    check(sprites.body.brush=="figure_player_04","missing custom brush falls back to native tier");
    available=true;origin=false;assets.updateLook(2);
    check(sprites.body.brush=="figure_player_02","other origin remains native");
    local loaded=false;
    local state=makeObject("states/world_state",{function onDeserialize(input){
        loaded=true;origin=input.origin;assets.m.IsCamping=input.camp;
        party.getSprite("body").setBrush(input.camp?"world_player_camp_01":"figure_player_03");
        return "native-loaded";
    }},true);
    check(state.onDeserialize({origin=true,camp=false})=="native-loaded" && loaded && sprites.body.brush==A.WorldPortraitBrush,"existing campaign applies after origin restoration");
    check(state.onDeserialize({origin=true,camp=true})=="native-loaded" && sprites.body.brush=="world_player_camp_01","camped saved game stays camped");
    check(state.onDeserialize({origin=false,camp=false})=="native-loaded" && sprites.body.brush=="figure_player_03","switching from Afei to another campaign cannot leak brush");
    origin=true;local originalParty=party;party=null;check(!A.syncWorldPartyArt(),"missing player during world setup is safe");party=originalParty;
    local savedState=::World.State;::World.State=null;check(!A.syncWorldPartyArt(),"missing world state is safe");::World.State=savedState;
    // Regression: the campaign-ending provider is the same bare native table.
    dofile("src/scripts/mods/afeix/ending_hooks.nut");
    A.endingSnapshot <- function(retired){return {retired=retired};};
    A.companyEndingText <- function(snapshot){return "afei-ending";};
    local endingAsset=clone ::asset_manager;endingAsset.m=clone ::asset_manager.m;
    endingAsset.getGameFinishData=function(retired){return {Text="native",Score="100",Image="native-image"};};
    endingAsset=makeObject("states/world/asset_manager",endingAsset);
    check(endingAsset.getGameFinishData(true).Text=="afei-ending","ending hook actually runs for bare asset-manager instances");
    origin=false;check(endingAsset.getGameFinishData(true).Text=="native","ending hook preserves other origins through actual registration");
    print("ALL_WORLD_ART_CHECKS_PASS\nTESTS_PASSED="+passed+"\n");
}catch(error){print(error+"\n");throw error;}
