dofile("tests/gameplay/member_skill_fixture.nut");
::checks <- 0;
function check(v,label){if(!v)throw "FAIL "+label;::checks++;}
function eq(a,b,label){check(a==b,label+" expected="+b+" actual="+a);}
local A=::AfeixExpedition;
::baseHooks <- {};::objectHooks <- {};
::mods_hookBaseClass <- function(k,f){::baseHooks[k]<-f;};
::mods_hookNewObject <- function(k,f){::objectHooks[k]<-f;};
::mods_getMember <- function(o,k){return o[k];};::mods_override <- function(o,k,v){o[k]=v;};
dofile("src/scripts/mods/afeix/member_catalog_economy_hooks.nut");
::Const.ItemSlot.Bag<-2;::Const.ItemSlot.None<-3;
::Const.Items.ItemType.None<-0;::Const.Items.ItemType.TradeGood<-32;::Const.Items.Property<-{None=0};::Const.Items.ItemFilter<-{All=0};
::Const.UI<-{ItemOwner={Shop=1},Error={NotEnoughMoney=10,NotEnoughStashSpace=11}};
::Const.World<-{Assets={BaseSellPrice=0.2}};
::day <- 10;
::World <- {getTime=function(){return {Days=::day};},Assets={money=1000,tools=20.0,
    getMoney=function(){return this.money;},addMoney=function(n){this.money+=n;},addArmorParts=function(n){this.tools+=n;}}};
A.findCharacter=function(k){foreach(a in ::state.actors)if(a.key==k)return a;return null;};
A.enforceFormation=function(){};A.updateRecruitEligibility=function(){};A.ensureStoryItems=function(){};
dofile(".cache/afei-art/native-contract-fixture/item.nut");
function goods(id,food=false,value=100){
    local o=clone ::item;o.m=clone ::item.m;o.setdelegate(getroottable());o.m.ID=id;o.m.Value=value;
    o.m.ItemType=food?::Const.Items.ItemType.Food:0;::baseHooks["items/item"](o);return o;
}
function recruit(k){local a=makeActor(k);::state.flags["growth_done_"+k]<-true;::AfeixExpedition.syncMemberSkills(a);return a;}
fresh();::state.tactical=false;local moon=recruit("xiaoyueya"),bula=recruit("bula"),mocha=recruit("mocha"),damou=recruit("damou");
local food=goods("food.bread",true),tools=goods("supplies.armor_parts"),medicine=goods("supplies.medicine"),ammo=goods("supplies.ammo");
for(local i=0;i<4;i++)eq(food.getBuyPrice(),85,"preview food discount");
check(!("trade_supermarket_day" in ::state.flags),"preview does not spend offer");
eq(tools.getBuyPrice(),95,"tool discount");eq(medicine.getBuyPrice(),95,"medicine discount");eq(ammo.getBuyPrice(),95,"ammo discount");
eq(food.getSellPrice(),20,"sale price unchanged");eq(goods("food.feast",true,1000).getBuyPrice(),970,"food max thirty");
eq(goods("supplies.ammo",false,1000).getBuyPrice(),970,"supply max thirty");
eq(goods("weapons.axe",false,100).getBuyPrice(),100,"other items unchanged");
::state.origin=false;eq(food.getBuyPrice(),100,"other origin no discount");::state.origin=true;

// Actual native shop transaction, with storage and UI boundaries replaced.
::definitions["scripts/ui/screens/ui_module"] <- {m={},create=function(){}};
dofile(".cache/afei-art/native-contract-fixture/town_shop_dialog_module.nut");
function stash(){return {items=[],capacity=10,
    getItems=function(){return this.items;},getItemAtIndex=function(i){return i<0||i>=this.capacity?null:{item=i<this.items.len()?this.items[i]:null};},
    hasEmptySlot=function(){return this.items.len()<this.capacity;},add=function(v){this.items.push(v);},
    removeByIndex=function(i){return this.items.remove(i);},insert=function(v,i){this.items.push(v);},
    getNumberOfFilledSlots=function(){return this.items.len();},getCapacity=function(){return this.capacity;}};}
::Stash <- stash();local inventory=stash();inventory.add(food);inventory.add(goods("food.other",true));inventory.add(tools);
local shop=clone ::town_shop_dialog_module;shop.m=clone shop.m;shop.setdelegate(getroottable());
shop.m.Shop={stash=inventory,getStash=function(){return this.stash;},isRepairOffered=function(){return false;}};
shop.m.Parent<-{queryAssetsInformation=function(){return {};}};
shop.UIDataHelper<-{convertItemsToUIData=function(items,result,owner){foreach(i in items)result.push(i.getBuyPrice());},convertStashToUIData=function(...) {return [];}};
shop.logError<-function(...){};
::objectHooks["ui/screens/world/modules/world_town_screen/town_shop_dialog_module"](shop);
local transaction=[0,"world-town-screen-shop-dialog-module.shop",null,"world-town-screen-shop-dialog-module.stash"];
::World.Assets.money=80;eq(shop.onSwapItem(transaction).Result,10,"unaffordable native buy");check(!("trade_supermarket_day" in ::state.flags),"unaffordable preserves offer");
::World.Assets.money=1000;::Stash.capacity=0;eq(shop.onSwapItem(transaction).Result,11,"full stash native buy");check(!("trade_supermarket_day" in ::state.flags),"full stash preserves offer");
::Stash.capacity=10;local result=shop.onSwapItem(transaction);eq(result.Result,0,"native buy succeeds");eq(::World.Assets.money,915,"actual discounted payment");
eq(A.get("trade_supermarket_day"),10,"offer committed");eq(result.Shop[0],100,"UI refreshed after daily offer");eq(food.getSellPrice(),20,"bought food no money exploit");
result=shop.onSwapItem(transaction);eq(::World.Assets.money,815,"second food full price");
result=shop.onSwapItem(transaction);eq(::World.Assets.money,720,"separate supply daily offer");eq(A.get("trade_purse_clear_day"),10,"supply committed");
::day=11;eq(food.getBuyPrice(),85,"new day food reset");eq(tools.getBuyPrice(),95,"new day supply reset");

// Repair accounting handles native fractional tool consumption and daily cap.
eq(A.catalogRepairSpent(3.5),0,"partial repairs");eq(A.catalogRepairSpent(3.5),1,"seven actual tools");eq(::World.Assets.tools,21.0,"refund added");
eq(A.catalogRepairSpent(21.0),2,"daily cap three");eq(A.catalogRepairSpent(7.0),0,"daily cap excludes additional");
::day=12;eq(A.catalogRepairSpent(7.0),1,"next day refund");eq(A.catalogRepairSpent(0.0),0,"no spend no refund");
local manager={m={ArmorParts=15.0},update=function(s){this.m.ArmorParts-=s;}};
::objectHooks["states/world/asset_manager"](manager);
local before=::World.Assets.tools;manager.update(7.0);eq(::World.Assets.tools,before+1,"asset update hooks actual spend");
manager.update(-7.0);eq(::World.Assets.tools,before+1,"replenishment no refund");

// Hire quote is reusable; only successful newly hired theme member commits it.
eq(A.catalogRecruitDiscount(1000),200,"hire cap");eq(A.catalogRecruitDiscount(100),20,"hire percent");
local candidate=makeActor("xiaojie");candidate.getFlags<-function(){return {set=function(k,v){}};};
local quoted=A.recruitPrice("xiaojie");check(quoted<A.Characters.xiaojie.hireCost,"hire quote cheaper");
check(!("steal_bro_day" in ::state.flags),"quote not spent");A.onNativeHired(candidate);eq(A.get("steal_bro_day"),12,"successful hire commits");
eq(A.catalogRecruitDiscount(100),0,"seven day gate");::day=18;eq(A.catalogRecruitDiscount(100),0,"day six blocked");
::day=19;eq(A.catalogRecruitDiscount(100),20,"day seven resets");A.onNativeHired(candidate);eq(A.get("steal_bro_day"),12,"repeat callback cannot spend again");
::state.flags.growth_done_damou=false;eq(A.catalogRecruitDiscount(100),0,"growth gated hire perk");
print("TESTS_PASSED="+::checks+"\n");
