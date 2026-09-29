// Native fillStash + inherited callback dispatch, including the shared base.
local checks=0,origin=true,allied=true,roll=5,rolls=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::Const <- {};::Math <- {rand=function(a,b){rolls++;return roll;}};
::World <- {Retinue={hasFollower=function(id){return false;}}};
::AfeixExpedition <- {isOrigin=function(){return origin;}};
dofile("src/scripts/mods/afeix/ideas_core.nut");
dofile(".cache/afei-art/native-contract-fixture/building.nut");
local hooks={};
::mods_hookNewObject <- function(...){};::mods_hookExactClass <- function(...){};
::mods_hookBaseClass <- function(path,cb){hooks[path]<-cb;};
::mods_getMember <- function(o,k){while(!(k in o))o=o[o.SuperName];return o[k];};
::mods_override <- function(o,k,v){while(!(k in o))o=o[o.SuperName];o[k]=v;};
dofile("src/scripts/mods/afeix/ideas_hooks.nut");
// Native building has no inherit() of its own; it must not require ExactClass.
check("entity/world/settlements/buildings/building" in hooks,"base hook covers bare building inheritance");
::inherit <- function(path,body){
    local raw=clone body;raw.building<-::building;raw.SuperName<-"building";
    hooks["entity/world/settlements/buildings/building"](raw);
    local obj=clone ::building;obj.m=clone ::building.m;
    foreach(k,v in body){if(k=="m"){foreach(n,x in v)obj.m[n]<-x;}else obj[k]<-v;}
    obj.setdelegate(getroottable());return obj;
};
dofile(".cache/afei-art/native-contract-fixture/weaponsmith_building.nut");
dofile(".cache/afei-art/native-contract-fixture/marketplace_building.nut");
::new <- function(path){check(path=="scripts/items/weapons/afeix_laoma_grip","correct unique weapon factory");return {
    price=0,sold=true,getID=function(){return ::AfeixExpedition.GripID;},setPriceMult=function(p){this.price=p;},setSold=function(v){this.sold=v;}};};
local settlement={isAlliedWithPlayer=function(){return allied;},getModifiers=function(){return {
    RarityMult=1,FoodRarityMult=1,MedicalRarityMult=1,MineralRarityMult=1,BuildingRarityMult=1};}};
foreach(pair in [[::weaponsmith_building,"building.weaponsmith"],[::marketplace_building,"building.marketplace"]]){
    local shop=pair[0];shop.m.ID=pair[1];shop.m.Settlement=settlement;
    local stash={items=[],getItems=function(){return this.items;},add=function(i){this.items.push(i);return this.items.len()-1;},
        clear=function(){this.items=[];},sort=function(){}};shop.m.Stash=stash;
    roll=5;rolls=0;shop.fillStash([],stash,shop.getPriceMult());
    check(stash.items.len()==1&&rolls==1,"one five-percent roll through native fill: "+pair[1]);
    check(stash.items[0].price==shop.getPriceMult(),"normal store price multiplier");
    local item=stash.items[0];shop.onAfterFillStash(stash);shop.onSettlementEntered();
    check(stash.items.len()==1&&stash.items[0]==item&&rolls==1&&!item.sold,"re-entry and retained inventory do not roll again");
    roll=6;shop.fillStash([],stash,shop.getPriceMult());check(stash.items.len()==0,"six misses natural restock");
    roll=1;allied=false;rolls=0;shop.fillStash([],stash,shop.getPriceMult());
    check(stash.items.len()==0&&rolls==0,"hostile store excluded");allied=true;
    origin=false;shop.fillStash([],stash,shop.getPriceMult());check(stash.items.len()==0&&rolls==0,"other origin excluded");origin=true;
    shop.m.ID="building.armorsmith";shop.fillStash([],stash,shop.getPriceMult());check(rolls==0,"shared parent does not stock unrelated shops");
}
print("TESTS_PASSED="+checks+"\n");
