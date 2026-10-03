// Run the real origin spawn search with a deterministic map/navigation boundary.
// Count expensive path queries and retain failure/fallback behavior.
::checks <- 0;
function check(value, message) { if (!value) throw "FAIL " + message; ::checks++; }
::Math <- { min = function(a,b) { return a < b ? a : b; }, max = function(a,b) { return a > b ? a : b; } };
::Const <- { World = { Settings = { SizeX = 100, SizeY = 100 }, TerrainType = { Ocean = 0, Shore = 1 }, TerrainTypeNavCost_Flat = [] } };
::TimeUnit <- { Real = 0 };
::Time <- { scheduleEvent = function(...) {} };
::spawnState <- { towns = [], calls = 0, blocked = false, rejectFirst = false, flags = {}, spawned = null, dreamStarts = 0, runtimeResets = 0 };
function tile(x,y) {
    return { SquareCoords = { X=x, Y=y }, Coords = { X=x, Y=y }, Type = 2, IsOccupied = false,
        getDistanceTo = function(other) { return ::Math.max(abs(this.Coords.X-other.Coords.X),abs(this.Coords.Y-other.Coords.Y)); } };
}
function town(id,x,y,allied=true,military=false,isolated=false) {
    return { id=id, center=tile(x,y), allied=allied, military=military, isolated=isolated,
        isMilitary=function(){return this.military;}, isIsolatedFromRoads=function(){return this.isolated;},
        isAlliedWithPlayer=function(){return this.allied;}, getTile=function(){return this.center;},
        getID=function(){return this.id;}, getNameOnly=function(){return "town"+this.id;} };
}
::AfeixExpedition <- {
    resetDreamRuntime=function(){::spawnState.runtimeResets++;},
    set=function(k,v){::spawnState.flags[k]<-v;},
    initializeDreamOpening=function(){
        check(::World.State.m.Player!=null,"dream queues only after the real world party exists");
        ::spawnState.dreamStarts++;
    }
};
::World <- {
    State = { m = { Player = null } },
    Assets = { updateLook = function(value) {} },
    EntityManager = { getSettlements = function(){return ::spawnState.towns;} },
    isValidTileSquare = function(x,y){return true;}, getTileSquare=function(x,y){return tile(x,y);},
    getNavigator = function(){return {
        createSettings=function(){return {ActionPointCosts=null};},
        findPath=function(from,to,settings,unused){
            ::spawnState.calls++;
            check(from.Type!=0&&from.Type!=1&&!from.IsOccupied&&from.getDistanceTo(to)>1,"safe free land outside settlement");
            local blocked=::spawnState.blocked||(::spawnState.rejectFirst&&to.Coords.X==20);
            return { empty=blocked, isEmpty=function(){return this.empty;},getSize=function(){return 3;} };
        }
    };},
    spawnEntity=function(path,x,y){::spawnState.spawned=tile(x,y);return {getPos=function(){return {};}};},
    getCamera=function(){return {setPos=function(pos){}};}
};
::inherit <- function(path,data){data.setdelegate(getroottable());return data;};
dofile("src/scripts/scenarios/world/afeix_expedition_scenario.nut");
local scenario=::afeix_expedition_scenario;
::spawnState.towns=[town(1,20,20)];
scenario.onSpawnPlayer();
check(::spawnState.calls==1,"open terrain needs only one path query");
check(::spawnState.spawned.getDistanceTo(::spawnState.towns[0].center)==2,"closest valid tile tried first");
check(::spawnState.flags.home_id==1,"starting town preserved");
::spawnState.calls=0;::spawnState.rejectFirst=true;
::spawnState.towns=[town(1,20,20),town(2,50,50)];
scenario.onSpawnPlayer();
check(::spawnState.calls>1&&::spawnState.calls<=82,"unreachable town has bounded fallback search");
check(::spawnState.flags.home_id==2,"fallback reaches second friendly town");
::spawnState.calls=0;::spawnState.rejectFirst=false;
::spawnState.towns=[town(1,20,20,false),town(2,30,30,true,true),town(3,40,40,true,false,true),town(4,50,50)];
scenario.onSpawnPlayer();
check(::spawnState.calls==1&&::spawnState.flags.home_id==4,"hostile military and isolated settlements skipped");
::spawnState.calls=0;::spawnState.blocked=true;
local failed=false;
try {scenario.onSpawnPlayer();} catch(error){failed=error.find("no reachable free starting tile")!=null;}
check(failed&&::spawnState.calls<=81,"no reachable tile gives bounded explicit failure");
check(::spawnState.dreamStarts==3,"failed spawn never queues a dream");
check(::spawnState.runtimeResets==4,"every new world clears previous campaign runtime before spawning");
print("TESTS_PASSED="+::checks+"\n");
