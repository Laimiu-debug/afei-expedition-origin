// check_gameplay.py extracts this native base from the installed game.
dofile(".cache/afei-art/native-contract-fixture/contract.nut");
local count=0;
function expect(value,message) { if(!value) throw "FAIL "+message; }
local check=function(value,message){expect(value,message);count++;};
function deepCopy(value) {
    if(typeof value=="array") {local r=[];foreach(v in value)r.push(deepCopy(v));return r;}
    if(typeof value=="table") {local r={};foreach(k,v in value)r[k]<-deepCopy(v);return r;}
    return value;
}
function tags() {return {
    data={},function set(k,v){this.data[k]<-v;},function has(k){return k in this.data;},
    function get(k){return k in this.data?this.data[k]:0;},
    function onSerialize(out){out.writeAny(deepCopy(this.data));},
    function onDeserialize(input,merge){this.data=deepCopy(input.readAny());}
};}
::Math <- {function rand(a,b){return a;},function max(a,b){return a>b?a:b;},function min(a,b){return a<b?a:b;}};
local now=0.0, serial=100;
::Time <- {function getVirtualTimeF(){return now;}};
::WeakTableRef <- function(o){return o;};
::logError <- function(s){throw s;};
::Const <- {FactionType={Settlement=1,OrientalCityState=2},World={TerrainTypeNavCost=[],Assets={
    ReputationOnContractSuccess=1,RelationCivilianContractSuccess=1,ReputationOnContractCancel=-1,RelationContractCancel=-1,RelationContractCancelAdvance=-1
}}};
local money=0,reputation=0,relation=0,origin=true,at=null,entered=null,hud=null,shows=0,active=null,offers=[],events=false;
local towns=[];
local faction={function getID(){return 7;},function getRandomCharacter(){return {function getID(){return 70;}};},
    function getSettlements(){return towns;},function addPlayerRelation(amount,why){relation+=amount;}};
function makeTown(id,route){return {
    alive=true,friendly=true,selection={Visible=false},
    function getID(){return id;},function isNull(){return false;},function getNameOnly(){return "Town"+id;},
    function isAlive(){return this.alive;},function isAlliedWithPlayer(){return this.friendly;},function isMilitary(){return false;},
    function isConnectedToByRoads(other){return true;},function getFactionOfType(t){return faction;},
    function getSprite(key){return this.selection;},function getTile(){return {ID=id,Pos={},route=route};}
};}
local home=makeTown(1,0),target=makeTown(2,15);towns=[home,target];entered=home;at=home;
::World <- {
    Flags=tags(),
    Assets={function addMoney(n){money+=n;if(::AfeixExpedition.PaymentContext!=null)::AfeixExpedition.noteContractIncome(::AfeixExpedition.PaymentContext,n);},
        function addBusinessReputation(n){reputation+=n;}},
    State={function getCurrentTown(){return entered;}},
    Events={function hasActiveEvent(){return events;}},
    EntityManager={function getSettlements(){return towns;}},
    FactionManager={function getFaction(id){return faction;}},
    function getEntityByID(id){foreach(t in towns)if(t.getID()==id)return t;return null;},
    function getTime(){return {Days=1,SecondsPerDay=600};},
    function uncoverFogOfWar(pos,radius){},
    function getNavigator(){return {
        function createSettings(){return {ActionPointCosts=null,RoadOnly=false,RoadMult=1.0};},
        function findPath(a,b,settings,unused){expect(settings.RoadOnly,"road-only navigation");return {
            function isEmpty(){return b.route<=0;},function getSize(){return b.route;}
        };}
    };},
    Contracts={
        function getActiveContract(){return active;},function getOpenContracts(){return offers;},
        function addContract(c){c.m.ID=++serial;offers.push(c);},
        function setActiveContract(c){if(active!=null)return;active=c;c.setActive(true);local i=offers.find(c);if(i!=null)offers.remove(i);this.updateActiveContract();},
        function updateActiveContract(){if(active!=null)hud=active.getUIBulletpoints();},
        function showActiveContract(){shows++;},
        function finishActiveContract(cancelled=false){local c=active;c.clear();active=null;hud=null;::AfeixExpedition.finishContractPayment(c.getID(),cancelled);},
        function removeContract(c){local i=offers.find(c);if(i!=null)offers.remove(i);}
    }
};
::Tactical <- {function getEntityByID(id){return id==70?{}:null;}};
::AfeixExpedition <- {Schema=6};
dofile("src/scripts/mods/afeix/core.nut");dofile("src/scripts/mods/afeix/quests.nut");dofile("src/scripts/mods/afeix/contracts.nut");
local A=::AfeixExpedition;A.isOrigin=function(){return origin;};
::inherit <- function(path,child){return child;};
dofile("src/scripts/contracts/contracts/afeix_letter_contract.nut");
::new <- function(path){
    if(path=="scripts/tools/tag_collection")return tags();
    expect(path=="scripts/contracts/contracts/afeix_letter_contract","known native class path");
    local c=deepCopy(::contract);c.setdelegate(getroottable());
    foreach(k,v in ::afeix_letter_contract)if(k!="m")c[k]<-v;
    c.contract <- {};foreach(k,v in ::contract)if(typeof v=="function")c.contract[k]<-v.bindenv(c);
    // Native geometry and template expansion need the engine; dispatch and IO do not.
    c.isPlayerAt=function(t){return at!=null&&t!=null&&at.getID()==t.getID();};
    c.buildText=function(text){return text;};
    c.create();return c;
};
A.ensureTownLetter(home);check(offers.len()==1,"town entry adds a native offer");
local c=offers[0];
A.ensureTownLetter(home);check(offers.len()==1,"repeated entry cannot duplicate offer");
A.ensureTownLetter(target);check(offers.len()==1,"another town cannot add a second global letter offer");
check(c.isValid()&&c.getHome()==home&&c.getOrigin()==home,"native validation and settlement association");
c.start();check(c.getActiveScreen().ID=="Task","native start opens offer screen");
check(!c.processInput(1)&&active==null&&money==0,"considering offer pays nothing");
check(!c.processInput(0)&&active==c&&c.m.ActiveScreen==null,"acceptance follows native input and clears modal");
check(hud[0].items[0].text.find("Town2")!=null&&hud[1].items[0].text.find("180")!=null,"native HUD receives destination and reward");
check(target.selection.Visible,"accepted destination marked on world map");
A.ensureTownLetter(target);check(offers.len()==0,"active native job blocks second acceptance");
c.update();check(shows==0&&!c.deliverLetter()&&money==0,"wrong town cannot trigger delivery");
// Native serialization must restore the actual Running state and its flags.
local io={data=[],index=0,function writeAny(v){this.data.push(v);},function readAny(){return this.data[this.index++];}};
foreach(kind in ["I32","U8","U16","U32","F32","Bool","String"]){io["write"+kind]<-io.writeAny;io["read"+kind]<-io.readAny;}
c.onSerialize(io);local restored=::new("scripts/contracts/contracts/afeix_letter_contract");restored.onDeserialize(io);active=restored;
check(io.index==io.data.len()&&restored.getActiveState().ID=="Running","real native base serialization roundtrip");
check(restored.destination()==target&&!restored.m.Flags.get("Paid"),"destination and unpaid state survive reload");
check(restored.m.Flags.get("SupplyCharged"),"accepted supply charge survives native serialization");
at=target;events=true;restored.update();check(shows==0,"another event blocks delivery popup");events=false;
restored.update();check(shows==1&&restored.getActiveScreen().ID=="Success","arrival automatically opens delivery");
restored.update();check(shows==1,"open delivery is not repeatedly shown");
local callback=A.wrapContractCallback(restored.processInput);callback.bindenv(restored)(0);
check(money==180&&active==null&&!target.selection.Visible&&hud==null,"delivery pays and clears native tracker and marker");
check(A.progressCount()==0&&A.get("paid_contracts")==0&&A.get("courier_completed")==1&&A.get("qualified_contracts")==0,"letter pays once but cannot farm recruitment credit");
check(!restored.deliverLetter()&&money==180,"paid reward cannot be replayed");
check(!A.letterSupplyReady(target,home),"reverse city pair has the same cooldown");
now=600*30;A.ensureTownLetter(home);
check(offers.len()==0,"waiting alone cannot replenish letter supply");
A.set("contract_type_900","contract.destroy_bandit_camp");A.recordContract(900,false,500);
check(A.get("qualified_contracts")==1&&A.get("qualified_types")==1,"non-courier work replenishes supply and diversity");
at=home;entered=home;A.ensureTownLetter(home);c=offers[0];c.start();c.processInput(0);target.friendly=false;
c.update();check(c.getActiveScreen().ID=="Unavailable","hostile recipient ends objective safely");
callback=A.wrapContractCallback(c.processInput);callback.bindenv(c)(0);
check(money==180&&active==null&&A.progressCount()==1,"unavailable letter pays nothing and grants no completion");
target.friendly=true;A.ensureTownLetter(home);check(offers.len()==0,"failed letter cannot be immediately replaced");
now+=600*8;A.set("contract_type_901","contract.destroy_bandit_camp");A.recordContract(901,false,500);
A.ensureTownLetter(home);c=offers[0];c.start();c.processInput(0);c.cancel();::World.Contracts.finishActiveContract(true);
check(money==180&&A.progressCount()==2&&relation==0&&reputation==0,"voluntary cancellation follows native penalty, no reward");
origin=false;A.ensureTownLetter(home);check(offers.len()==0,"other origins get no added offers");
origin=true;now=600*60;A.set("qualified_contracts",3);A.consumeLetterSupply(home,target);A.set("qualified_contracts",4);
now+=600*2-1;check(!A.letterSupplyReady(target),"global supply blocks before two days");
now++;check(A.letterSupplyReady(target)&&!A.letterSupplyReady(home),"global cooldown expires but sender cooldown remains");
now+=600*3;check(A.letterSupplyReady(home)&&!A.letterSupplyReady(target,home),"sender expires at five days but reverse pair stays blocked");
now+=600*2;check(A.letterSupplyReady(home,target)&&A.letterSupplyReady(target,home),"seven-day pair cooldown expires in both directions");
// Compatibility retires old unaccepted letters but not an active letter or vanilla jobs.
A.set("letter_supply_migrated",false);
local obsolete=::new("scripts/contracts/contracts/afeix_letter_contract");::World.Contracts.addContract(obsolete);
local vanilla={function getType(){return "contract.escort_caravan";}};offers.push(vanilla);
A.migrateProgress();check(offers.len()==1&&offers[0]==vanilla,"migration preserves ordinary open contracts only");
A.migrateProgress();check(offers.len()==1,"migration is one-shot and idempotent");
print("TESTS_PASSED="+count+"\n");
