// Native random-event proximity checks must not block this manual reference UI.
// Keep real canManage/applyFormation so reading does not permit unsafe mutations.
::AfeixExpedition <- {CombatMax=10,RosterMax=40,TavernTown=0};
::Tactical <- {Active=false,State=null,isActive=function(){return this.Active;}};
::LoadingScreen <- {visible=false,animating=false,isVisible=function(){return this.visible;},isAnimating=function(){return this.animating;}};
::origin <- true;::hostiles <- true;::camping <- true;::fired <- 0;::shown <- 0;::cleared <- 0;::worldAllows <- true;
::logInfo <- function(...){};
::Time <- {getVirtualTimeF=function(){return 1000.0;}};
::bro <- {place=3,getID=function(){return 1;},getPlaceInFormation=function(){return this.place;},setPlaceInFormation=function(v){this.place=v;}};
::World <- {
    Assets={getOrigin=function(){return {getID=function(){return ::origin?"scenario.afeix_expedition":"scenario.other";}};},isCamping=function(){return ::camping;}},
    EntityManager={getSettlements=function(){return [];}},
    getPlayerRoster=function(){return {getAll=function(){return [::bro];}};},
    getAllEntitiesAtPos=function(pos,radius){return ::hostiles?[{isAlliedWithPlayer=function(){return false;},isAlive=function(){return true;},getTroops=function(){return [1];}}]:[];},
    State={combatStart=0,player={getPos=function(){return {};},getTile=function(){return {}; }},
        m={MenuStack={back=false,hasBacksteps=function(){return this.back;}},
           EventScreen={visible=false,animating=false,isVisible=function(){return this.visible;},isAnimating=function(){return this.animating;}},
           WorldTownScreen={isVisible=function(){return false;}}},
        getPlayer=function(){return this.player;},getCombatStartTime=function(){return this.combatStart;},
        isInCharacterScreen=function(){return false;},
        getMenuStack=function(){return this.m.MenuStack;},isCampingAllowed=function(){return true;},
        showEventScreen=function(event){::shown++;return ::worldAllows;}}
};
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/formation.nut");
dofile("src/scripts/mods/afeix/ledger.nut");
dofile(".cache/afei-art/native-contract-fixture/event_manager.nut");
::World.Events <- clone ::event_manager;::World.Events.m=clone ::World.Events.m;::World.Events.setdelegate(getroottable());
local event={m={AutoPage="home"},getID=function(){return "event.afeix_ledger";},fire=function(){::fired++;},clear=function(){::cleared++;}};
::World.Events.m.Events=[event];
local A=::AfeixExpedition,E=::World.Events,S=::World.State,checks=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
check(!E.canFireEvent(true,true),"native reproduction: nearby hostile blocks random event");
check(!A.canManage(),"nearby hostile blocks management even while camping");
check(A.openLedger()&&::fired==1&&::shown==1,"manual ledger opens through native fire near enemy");
check(!A.applyFormation([1]).ok&&::bro.place==3,"reading cannot unlock unsafe formation changes");
check(!A.openLedger()&&::fired==1,"repeat F8 cannot stack active event");
E.m.ActiveEvent=null;::worldAllows=false;
check(!A.openLedger()&&E.m.ActiveEvent==null&&::cleared==1,"native failed show clears event");
::worldAllows=true;
foreach(pair in [[::LoadingScreen,"visible"],[::LoadingScreen,"animating"],[S.m.EventScreen,"visible"],[S.m.EventScreen,"animating"],[S.m.MenuStack,"back"],[::Tactical,"Active"]]){
    pair[0][pair[1]]=true;local before=::fired;
    check(!A.openLedger()&&::fired==before,"blocked transition "+pair[1]);pair[0][pair[1]]=false;
}
::Tactical.State={};check(!A.openLedger(),"tactical lifecycle blocks ledger");::Tactical.State=null;
S.combatStart=100;check(!A.openLedger(),"pending combat blocks ledger");S.combatStart=0;
local player=S.player;S.player=null;check(!A.openLedger(),"no player blocks ledger");S.player=player;
::origin=false;check(!A.openLedger(),"other origin unchanged");::origin=true;
E.m.Events=[];check(!A.openLedger(),"missing event safely rejected");E.m.Events=[event];
::hostiles=false;
check(E.canFireEvent(true,true)&&A.canManage(),"safe camp still permits management");
check(A.openLedger(),"safe camp ledger opens after prior rejection");
check(A.applyFormation([1]).ok,"safe camp formation remains available");
print("TESTS_PASSED="+checks+"\n");
