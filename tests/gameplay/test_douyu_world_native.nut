// Execute shipped native location/world_entity/entity_manager/Common and their
// real serialization, ordinary location combat collection and world settlement.
// C++ map navigation, rendering, World.spawnLocation and file IO are explicit
// offline boundaries; these checks do not claim live-engine acceptance.
::checks <- 0;
function check(ok, text) { if (!ok) throw "FAIL Douyu world native: " + text; ++::checks; }
::state <- { origin=true, dream=false, ready=true, clock=5000.0, nextID=100, spawned=0,
    mapReads=0, paths=0, unreachable=false, blockedNorth=false, failedSpawn=false, discovered=0, finished=0,
    settled=0, consumed=0, saves=[], focus=null, fog=0, entities={}, tiles=[] };
::Math <- { min=function(a,b){return a<b?a:b;}, max=function(a,b){return a>b?a:b;}, minf=function(a,b){return a<b?a:b;},
    rand=function(...){return 321;}, seedRandom=function(...){} };
::Time <- { getVirtualTimeF=function(){return ::state.clock;}, setVirtualTime=function(t){::state.clock=t;},
    getRealTime=function(){return 123;},getRealTimeF=function(){return 123.0;} };
::Const <- { Combat={MiasmaTimeout=1,FireTimeout=1,SmokeTimeout=1}, Faction={Player=1,Beasts=8},FactionType={Beasts=4},
    UI={Cursor={Hand=0}},World={Settings={Vision=500},LocationType={}, AI={VisionDebugMode=false,VisualizeNameOfLocations=true},
        DetailType={Road=1,Shore=16,Footprints=256}, TerrainType={Impassable=0,Ocean=1,Plains=2,Swamp=3,Mountains=9,Urban=10,Shore=13},
        TerrainTypeNavCost_Flat=[0,0,1],TerrainTypeVisibilityMult=array(20,1.0),TerrainScript=array(20,""),
        CombatSettings={CombatPlayerDistance=200}, TerrainTacticalTemplate=["tactical.plains"],SpeedSettings={NormalMult=1}},
    Sound={Volume={Ambience=1,AmbienceInTactical=1,AmbienceTerrain=1,AmbienceOutsideSettlement=1},AmbienceMinDelay=0,AmbienceMinDelayAtNight=0,AmbienceOutsideDelay=0},
    Factions={PermanentHostileColor=0,HostileColor=0,NeutralColor=0},Music={BattleTracks={[8]=["beasts"]}},
    Tactical={LocationTemplate={Template=[null,null],ForceLineBattle=false,Fortification=0,OwnedByFaction=0,ShiftX=6,ShiftY=0},
        FortificationType={None=0},DeploymentType={Line=1},CombatResult={EnemyDestroyed=1,EnemyRetreated=2},
        CombatInfo={getClone=function(){return {Entities=[],Players=[],Parties=[],AllyBanners=[],EnemyBanners=[],
            InCombatAlready=false,IsAttackingLocation=false,CombatID="",LocationTemplate=null,TerrainTemplate=null,Tile=null,
            PlayerDeploymentType=0,EnemyDeploymentType=0,IsFleeingProhibited=false,Music=[],IsUsingSetPlayers=false};}}},DLC={Wildmen=false} };
::Const.World.Spawn <- { Unit={ID=1,Variant=0,Strength=0,Row=0,Name="",Script="",Party=null,Faction=0},Troops={Unhold={ID=1,Variant=0,Strength=100,Row=0,Script="scripts/entity/tactical/enemies/unhold"}} };
::inherit <- function(path, object) { object.setdelegate(getroottable()); return object; };
::createVec <- function(x,y){return {X=x,Y=y};};
::logError <- function(...){}; ::logWarning <- function(...){}; ::logDebug <- function(...){};
::Tactical <- {State=null,isActive=function(){return false;},isVisible=function(){return false;}};
::Sound <- {stopAmbience=function(){},setAmbience=function(...){}};
::Stash <- {setLocked=function(v){}};
::Settings <- {getGameplaySettings=function(){return {RestoreEquipment=false};}};
::IO <- {scriptHashByFilename=function(path){return path=="scripts/entity/tactical/enemies/afeix_douyu"?9001:0;},
    scriptFilenameByHash=function(hash){return hash==9001?"scripts/entity/tactical/enemies/afeix_douyu":"";} };
dofile(".cache/afei-art/douyu-world-native/tag_collection.nut");
dofile(".cache/afei-art/douyu-world-native/weak_table_ref.nut");
dofile(".cache/afei-art/douyu-world-native/stash_container.nut");
dofile(".cache/afei-art/douyu-world-native/world_locations.nut");
dofile(".cache/afei-art/douyu-world-native/world_entity_common.nut");
dofile(".cache/afei-art/douyu-world-native/world_entity.nut");
dofile(".cache/afei-art/douyu-world-native/location.nut");
dofile(".cache/afei-art/douyu-world-native/entity_manager.nut");
dofile(".cache/afei-art/douyu-world-native/world_state.nut");
dofile("src/scripts/entity/world/locations/afeix_douyu_location.nut");
::new <- function(path) {
    local source=path=="scripts/tools/tag_collection"?::tag_collection:path=="scripts/items/stash_container"?::stash_container:null;
    if(source==null)throw "Unexpected native constructor " + path;
    local object=clone source;object.m=clone source.m;object.setdelegate(getroottable());
    if("create" in object)object.create();return object;
};
::campaignFlags <- ::new("scripts/tools/tag_collection");
::AfeixExpedition <- {isOrigin=function(){return ::state.origin;},isDreamCombat=function(){return ::state.dream;},
    dreamWorldReady=function(){return ::state.ready&&!::state.dream;},
    get=function(k,f=0){return ::campaignFlags.has(k)?::campaignFlags.get(k):f;},set=function(k,v){::campaignFlags.set(k,v);return v;},
    roster=function(){return [];},findCharacter=function(key){return null;},route=function(){return "normal";},syncCharacterFeatures=function(a){},
    DreamSession=null,FinalDouyuResult=null,DreamOpeningQueued=false,DreamLaunchRequest=null,
    finishFinalDouyu=function(){return false;},updateDreamWorld=function(){}};
dofile("src/scripts/mods/afeix/dream_flow.nut");
// Keep this test's C++ UI readiness boundary; resetDreamRuntime itself stays
// the production implementation and is never stubbed.
::AfeixExpedition.dreamWorldReady = function(){return ::state.ready&&!this.isDreamCombat();};
dofile("src/scripts/mods/afeix/douyu_world.nut");
::worldHook <- null;
::mods_hookExactClass <- function(path,callback){if(path=="states/world_state")::worldHook=callback;};
::mods_hookNewObject <- function(path,callback){};
dofile("src/scripts/mods/afeix/dream_hooks.nut");

function mergeMethods(target, source) { foreach(k,v in source) if(k!="m")target[k]<-v; }
function nativeMethod(fn, child) { return function(...) { local args=[child];args.extend(vargv);return fn.acall(args); }; }
function facade(source, child) { local parent={};foreach(k,v in source)if(typeof v=="function")parent[k]<-nativeMethod(v,child);parent.setdelegate(child);return parent; }
function engineLocation(tile, restored=false) {
    local object={};mergeMethods(object,::world_entity);mergeMethods(object,::location);mergeMethods(object,::afeix_douyu_location);
    object.m<-clone ::world_entity.m;foreach(k,v in ::location.m)object.m[k]<-v;
    object.m.Troops=[];object.m.Inventory=[];object.setdelegate(getroottable());
    local locationBase={};mergeMethods(locationBase,::world_entity);mergeMethods(locationBase,::location);
    object.world_entity<-facade(::world_entity,object);object.location<-facade(locationBase,object);
    object.id<-++::state.nextID;object.tile<-tile;object.sprites<-{};object.labels<-{};object.faction<-8;object.discovered<-false;
    object.getID<-function(){return this.id;};object.getTile<-function(){return this.tile;};object.getPos<-function(){return this.tile.Pos;};
    object.getFaction<-function(){return this.faction;};object.setFactionEx<-function(f){this.faction=f;};object.isPlayerControlled<-function(){return false;};
    object.isAlliedWithPlayer<-function(){return false;};object.isHiddenToPlayer<-function(){return !this.discovered;};object.isDiscovered<-function(){return this.discovered;};
    object.setDiscovered<-function(v){if(v&&!this.discovered){this.discovered=true;this.onDiscovered();++::state.discovered;}};
    object.addSprite<-function(name){local s={Visible=false,setBrush=function(b){this.brush<-b;}};this.sprites[name]<-s;return s;};
    object.getSprite<-function(name){return this.sprites[name];};object.hasSprite<-function(name){return name in this.sprites;};
    object.addLabel<-function(name){local l={Visible=false,Text="",Color=0};this.labels[name]<-l;return l;};
    object.hasLabel<-function(name){return name in this.labels;};object.getLabel<-function(name){return this.labels[name];};
    object.setSpriteScaling<-function(...){};object.setSpriteOffset<-function(...){};object.setVisibility<-function(...){};
    object.setRenderedTop<-function(...){};object.setVisibleInFogOfWar<-function(...){};
    object.fadeAndDie<-function(){this.onFinish();++::state.finished;};
    object.create();object.onInit();object.onAfterInit();
    ::state.entities[object.id]<-object;return object;
}
function memoryStream() {
    local stream={data=[],index=0,getMetaData=function(){return {getVersion=function(){return 65;}};}};
    foreach(kind in ["String","U8","U16","U32","F32","I8","I32","Bool"]) {
        stream["write"+kind]<-function(v){this.data.push({kind=kind,value=v});};
        stream["read"+kind]<-function(){local v=this.data[this.index++];check(v.kind==kind,"native serializer roundtrips " + kind);return v.value;};
    }
    return stream;
}
function resetWorld(preserveRuntime=false) {
    local s=::state,A=::AfeixExpedition;
    s.origin=true;s.dream=false;s.ready=true;s.spawned=0;s.mapReads=0;s.paths=0;s.unreachable=false;s.blockedNorth=false;s.failedSpawn=false;
    s.finished=0;s.discovered=0;s.settled=0;s.consumed=0;s.saves=[];s.focus=null;s.fog=0;s.entities={};s.tiles=[];
    ::campaignFlags=::new("scripts/tools/tag_collection");if(!preserveRuntime)A.resetDreamRuntime();
    for(local x=0;x<60;++x){local column=[];for(local y=0;y<50;++y){
        local tile={IsOccupied=false,HasRoad=false,Type=x<=1?1:(x<5&&y>30?3:2),TacticalType=0,
            Coords={X=x,Y=y},SquareCoords={X=x,Y=y},Pos={X=x,Y=y},
            getDistanceTo=function(t){return ::Math.max(abs(this.Coords.X-t.Coords.X),abs(this.Coords.Y-t.Coords.Y));},
            clearAllBut=function(...) {},hasNextTile=function(d){return d<4&&this.Coords.X>0&&this.Coords.Y>0&&this.Coords.X<59&&this.Coords.Y<49;},
            getNextTile=function(d){local x=this.Coords.X,y=this.Coords.Y;if(d==0){x--;}else if(d==1){x++;}else if(d==2){y--;}else {y++;}return ::state.tiles[x][y];}};
        column.push(tile);
    }s.tiles.push(column);}
    local manager=clone ::entity_manager;manager.m=clone ::entity_manager.m;manager.m.Locations=[];manager.m.Settlements=[];manager.setdelegate(getroottable());
    manager.m.Settlements.push({getName=function(){return "北境镇";},getTile=function(){return ::state.tiles[20][12];}});
    local flags=::new("scripts/tools/tag_collection"),player={tile=s.tiles[20][12],getTile=function(){return this.tile;},getPos=function(){return this.tile.Pos;},
        getID=function(){return 1;},isAlive=function(){return true;},isPlayerControlled=function(){return true;},getFaction=function(){return 1;},
        setDestination=function(v){},setPath=function(v){},updateStrength=function(){},onCombatFinished=function(){::state.settled++;}};
    local faction={getID=function(){return 8;},getCombatMusic=function(){return ["beasts"];},isPlayerRelationPermanent=function(){return true;},removeSettlement=function(l){}};
    ::World <- {State=null,EntityManager=manager,Statistics={getFlags=function(){return flags;}},
        FactionManager={getFactionOfType=function(t){return faction;},getFaction=function(id){return faction;},isAlliedWithPlayer=function(id){return id==1;},
            isAllied=function(a,b){return a==b;},onCombatFinished=function(){}},
        Assets={isIronman=function(){return true;},getOrigin=function(){return {onCombatFinished=function(){return true;}};},consumeItems=function(){::state.consumed++;},
            refillAmmo=function(){},updateAchievements=function(){},checkAmbitionItems=function(){}},
        Events={hasActiveEvent=function(){return false;},updateBattleTime=function(){}},Ambitions={resetTime=function(){},onLocationDiscovered=function(l){}},
        Retinue={hasFollower=function(id){return false;}},Combat={abortCombatWithParty=function(p){}},
        getMapSize=function(){return {X=60,Y=50};},getTileSquare=function(x,y){::state.mapReads++;return ::state.tiles[x][y];},
        getTile=function(p){return ::state.tiles[p.X][p.Y];},worldToTile=function(p){return p;},
        getAllEntitiesAtPos=function(p,r){local entities=[::World.State.getPlayer()];foreach(l in ::World.EntityManager.getLocations())if(l.isAlive()&&l.getTile().getDistanceTo(::World.State.getPlayer().getTile())<=1)entities.push(l);return entities;},
        getEntityByID=function(id){return id in ::state.entities?::state.entities[id]:null;},
        getNavigator=function(){return {createSettings=function(){return {ActionPointCosts=null};},findPath=function(a,b,settings,flags){::state.paths++;local denied=::state.unreachable||(::state.blockedNorth&&a.SquareCoords.X<5&&a.SquareCoords.Y>30);return {isEmpty=function(){return denied;}};}};},
        getTime=function(){return {Days=1,IsDaytime=true};},uncoverFogOfWar=function(p,r){::state.fog++;},
        getCamera=function(){return {setPos=function(p){::state.focus=p;}};},
        getPlayerRoster=function(){return {getSize=function(){return 3;},getAll=function(){return [::World.State.getPlayer()];}};},
        spawnLocation=function(path,coords){++::state.spawned;if(::state.failedSpawn)throw "engine spawn failure";
            if(path=="scripts/entity/world/locations/battlefield_location")return {setSize=function(n){}};
            check(path=="scripts/entity/world/locations/afeix_douyu_location","custom native location path");return engineLocation(::state.tiles[coords.X][coords.Y]);}
    };
    local w=clone ::world_state;w.m=clone ::world_state.m;w.m.Player=player;w.m.PartiesInCombat=[];w.m.IsGamePaused=true;w.m.IsGameAutoPaused=false;
    w.m.MenuStack={hasBacksteps=function(){return false;},isAllowingCancel=function(){return true;}};w.setdelegate(getroottable());
    w.getSurroundingAmbienceSounds=function(){return [];};w.getSurroundingLocationSounds=function(){return [];};w.updateTopbarAssets=function(){};
    w.stunPartiesNearPlayer=function(){};w.setWorldmapMusic=function(v){};w.show<-function(){};w.setAutoPause=function(v){};w.setPause=function(v){};
    w.autosave=function(){::state.saves.push(::AfeixExpedition.get("douyu_final_defeated",false));};
    w.showCombatDialog=function(...){::state.combatDialog<-true;};
    ::worldHook(w);
    ::World.State=w;
}

resetWorld();local A=::AfeixExpedition;
check(A.ensureDouyuWorldLocation(),"new campaign creates a reachable legendary site");
local site=A.findDouyuWorldLocation(),tile=site.getTile();
check(::state.paths>0&&::state.paths<=48&&::state.mapReads<=4096,"placement search and native navigator calls bounded");
check(site.isLocationType(::Const.World.LocationType.Unique)&&tile.IsOccupied,"native legendary location occupies its tile");
check(site.getTroops().len()==1&&site.getTroops()[0].Script=="scripts/entity/tactical/enemies/afeix_douyu","fixed real boss troop");
check(site.getSprite("body").brush=="world_kraken_stones","native legendary landmark brush");
local reads=::state.mapReads,paths=::state.paths;
for(local n=0;n<100;++n)A.updateDouyuWorld();
check(::state.spawned==1&&::state.mapReads==reads&&::state.paths==paths,"world frames do not rescan or recreate the site");
A.DouyuWorldChecked=false;A.DouyuWorldLocationID=0;
check(A.ensureDouyuWorldLocation()&&::state.spawned==1,"old-save load reuses an existing live site");
check(A.queueDouyuMapFocus(),"F8 can queue location intel");A.updateDouyuWorld();
check(::state.discovered==1&&::state.focus==tile.Pos&&::state.fog==1,"F8 reveals and points to the real map location");
check(::World.State.m.CombatProperties==null,"F8 does not start combat remotely");
A.queueDouyuMapFocus();A.updateDouyuWorld();check(::state.discovered==1,"repeated map intel does not rediscover location");

// Native location/world entity script hash and tag/stash persistence roundtrip.
local output=memoryStream();site.onSerialize(output);
site.onFinish();delete ::state.entities[site.getID()];
local loaded=engineLocation(tile,true);loaded.onDeserialize(output);
A.DouyuWorldChecked=false;A.DouyuWorldLocationID=0;
check(A.ensureDouyuWorldLocation()&&A.findDouyuWorldLocation()==loaded&&::state.spawned==1,"native restored location is reused without duplicating it");
check(loaded.getTroops().len()==1&&loaded.getTroops()[0].Script=="scripts/entity/tactical/enemies/afeix_douyu","native save stores the custom troop script hash");
check(loaded.getTroops()[0].Party.getID()==loaded.getID(),"native load restores the troop owner reference");
::World.State.getPlayer().tile=tile;
check(::World.State.enterLocation(loaded)&&::state.combatDialog,"native world arrival opens ordinary challenge dialog");
local props=::World.State.getLocalCombatProperties(tile.Pos);
check(props.CombatID=="afeix_douyu_final"&&props.IsAttackingLocation&&props.Parties[0]==loaded,"native location combat keeps party ownership and final ID");
check(props.TerrainTemplate=="tactical.swamp"&&props.PlayerDeploymentType==1&&!props.IsUsingSetPlayers&&!props.IsFleeingProhibited,"real location uses ordinary free formation and retreat rules");
loaded.onCombatWon();::World.State.onCombatFinished();
check(loaded.isAlive()&&loaded.getTroops().len()==1&&!A.get("douyu_final_defeated",false),"native enemy victory and player retreat preserve the boss for a retry");
check(::state.settled==1&&::state.consumed==1,"native campaign actor settlement and consumable use remain enabled");
local loot=[];loaded.onDropLootForPlayer(loot);check(loot.len()==0,"location does not create extra boss rewards");
::World.State.getLocalCombatProperties(tile.Pos);
loaded.removeTroop(loaded.getTroops()[0]); // Exact native actor.kill owner operation.
A.set("douyu_loot_dropped",true);::World.State.onCombatFinished();
check(!loaded.isAlive()&&!tile.IsOccupied&&::World.EntityManager.getLocations().len()==0,"native real defeat destroys the location and releases its map tile");
check(A.get("douyu_final_defeated")&&A.get("douyu_final_notice")&&::state.saves.top(),"victory state is included in native Ironman settlement save");
A.DouyuWorldChecked=false;A.DouyuWorldLocationID=0;
check(!A.ensureDouyuWorldLocation()&&::state.spawned==2,"completed save cannot recreate slain location or its loot");
local savedFlags=memoryStream();::campaignFlags.onSerialize(savedFlags);
::campaignFlags=::new("scripts/tools/tag_collection");::campaignFlags.onDeserialize(savedFlags);
A.DouyuWorldChecked=false;A.DouyuWorldLocationID=0;
check(A.get("douyu_loot_dropped")&&A.get("douyu_final_defeated")&&!A.ensureDouyuWorldLocation(),"native persistent loot/victory flags prevent regeneration after load");

resetWorld();A.DreamSession={flags={}};check(!A.ensureDouyuWorldLocation()&&::state.spawned==0,"dream combat cannot create a real location");
resetWorld();::state.origin=false;A.updateDouyuWorld();check(::state.spawned==0,"other origins receive no location");
resetWorld();A.set("old_save_story_done",true);A.updateDouyuWorld();
check(::state.spawned==1&&A.get("old_save_story_done"),"old save without a location gets exactly one site without changing its story state");
resetWorld();::state.blockedNorth=true;
check(A.ensureDouyuWorldLocation()&&::state.paths>16&&::state.paths<=48,"unreachable preferred northern sites fall back across the candidate ranking");
resetWorld();::state.unreachable=true;check(!A.ensureDouyuWorldLocation()&&::state.paths<=48,"unreachable map search is bounded");
reads=::state.mapReads;paths=::state.paths;for(local n=0;n<20;++n)A.updateDouyuWorld();
check(::state.mapReads==reads&&::state.paths==paths,"failed placement is not retried every world frame");
resetWorld();::state.failedSpawn=true;check(!A.ensureDouyuWorldLocation()&&::World.EntityManager.getLocations().len()==0,"engine spawn failure leaves no registered site");
resetWorld();A.ensureDouyuWorldLocation();local primary=A.findDouyuWorldLocation();
local duplicate=engineLocation(::state.tiles[35][35]);duplicate.onSpawned();A.DouyuWorldChecked=false;
check(A.ensureDouyuWorldLocation()&&primary.isAlive()&&!duplicate.isAlive()&&::World.EntityManager.getLocations().len()==1,"loaded accidental duplicate is removed through native lifecycle");

// A second new campaign in one process never reloads the module and never
// invokes world.onDeserialize. Exercise the actual shared reset helper.
A.set("persistent_story",7);local sameFlags=::campaignFlags;
A.DreamSession={flags={persistent_story=99}};A.DreamLaunchRequest={kind="dream",stage=3};A.DreamOpeningQueued=true;
A.FinalDouyuResult=true;A.DouyuMapFocusQueued=true;
A.resetDreamRuntime();
check(::campaignFlags==sameFlags&&A.get("persistent_story")==7&&primary.isAlive(),"runtime reset preserves persistent flags and existing native actors");
check(A.DreamSession==null&&A.DreamLaunchRequest==null&&!A.DreamOpeningQueued&&A.FinalDouyuResult==null,"new-world reset clears all temporary battle references and requests");
check(!A.DouyuWorldChecked&&A.DouyuWorldLocationID==0&&!A.DouyuMapFocusQueued,"new-world reset clears all location runtime state");
A.ensureDouyuWorldLocation();local previousID=A.DouyuWorldLocationID;
resetWorld(true);
check(A.DouyuWorldChecked&&A.DouyuWorldLocationID==previousID,"fixture preserves prior module state across a fresh native world");
A.resetDreamRuntime();A.updateDouyuWorld();
check(::state.spawned==1&&A.DouyuWorldLocationID!=previousID&&A.findDouyuWorldLocation()!=null,"same-process second new campaign creates its own unique legendary site");
print("TESTS_PASSED="+::checks+"\n");
