// Production item/skill definitions and migration/story integration; fake engine inventory.
local checks=0;function check(ok,message){if(!ok)throw "FAIL "+message;}
local expect=function(ok,message){checks++;check(ok,message);};
::Const <- {ItemSlot={None=-1,Accessory=4,Bag=5},Items={ItemType={Accessory=1,Misc=2}},SkillType={Active=1},SkillOrder={Any=1},
    UI={function getColorizedEntityName(b){return b.key;}},Sound={Volume={Inventory=1}}};
::Math <- {function min(a,b){return a<b?a:b;}};
local round=1,tactical=true,origin=true,failCreate=false,failAdd=false,failRemove=false,failTrait=false;
::Time <- {function getRound(){return round;}};
::Tactical <- {function isActive(){return tactical;},EventLog={function log(text){}}};
::logError <- function(text){print(text+"\n");};
function flags(){return {v={},function has(k){return k in this.v;},function get(k){return k in this.v?this.v[k]:0;},function set(k,v){this.v[k]<-v;}};}
::inherit <- function(path,child){return child;};
dofile("src/scripts/items/misc/afeix_bicycle_item.nut");
dofile("src/scripts/items/accessory/afeix_ecig_item.nut");
dofile("src/scripts/items/accessories/xiwen_round_mirror.nut");
dofile("src/scripts/skills/actives/afeix_ecig_puff.nut");
function makeSkill(){
    local s=clone ::afeix_ecig_puff;s.m={};s.setdelegate(getroottable());
    foreach(k in ["ID","Name","Description","Icon","IconMini","IconDisabled","Overlay","SoundOnUse","Type","Order","IsSerialized","IsActive","IsTargeted","IsStacking","IsAttack","IsVisibleTileNeeded","ActionPointCost","FatigueCost","MinRange","MaxRange"])s.m[k]<-null;
    s.owner <- null;s.skill <- {function isUsable(){return true;}};
    s.getContainer <- function(){local owner=this.owner;return {function getActor(){return owner;}};};
    s.create();return s;
}
function makeItem(path){
    if(failCreate)throw "injected constructor error";
    local obj=clone (path.find("mirror")!=null?::xiwen_round_mirror:(path.find("bicycle") != null ? ::afeix_bicycle_item : ::afeix_ecig_item));
    obj.setdelegate(getroottable());obj.m={};obj.owner <- null;
    foreach(k in ["ID","Name","Description","Icon","IconLarge","SlotType","ItemType","IsAllowedInBag","IsSellable","IsDroppedAsLoot","Value","AddGenericSkill","ShowOnCharacter"])obj.m[k]<-null;
    obj.item <- {function create(){}};obj.accessory <- {function create(){},function onEquip(){},function onUpdateProperties(p){}};
    obj.getContainer<-function(){return this.owner==null?null:this.owner.inv;};
    if(!("onEquip" in obj))obj.onEquip<-function(){};
    obj.getID <- function(){return this.m.ID;};obj.getName <- function(){return this.m.Name;};
    obj.getDescription <- function(){return this.m.Description;};obj.getIcon <- function(){return this.m.Icon;};
    obj.addSkill <- function(s){s.owner=this.owner;this.owner.skills.push(s);};
    obj.create();return obj;
}
::new <- function(path){return path.find("scripts/skills/")==0?makeSkill():makeItem(path);};
function actor(key){
    local f=flags(),bro={key=key,hp=30,hpmax=60,alive=true,skills=[],inv=null};
    bro.getFlags <- function(){return f;};bro.getLevel <- function(){return 8;};bro.isAlive <- function(){return this.alive;};
    bro.getHitpoints <- function(){return this.hp;};bro.getHitpointsMax <- function(){return this.hpmax;};bro.setHitpoints <- function(n){this.hp=n;};
    bro.setDirty <- function(v){};bro.getItems <- function(){return this.inv;};
    bro.inv={owner=bro,accessory=null,getActor=function(){return this.owner;},
        function getAllItems(){return this.accessory==null?[]:[this.accessory];},function getItemAtSlot(slot){return this.accessory;},
        function equip(item){if(this.accessory!=null)return false;this.accessory=item;item.owner=this.owner;item.onEquip();return true;},
        function unequip(){this.accessory=null;this.owner.skills=[];}
    };return bro;
}
local brothers=[],stash={items=[],capacity=3,
    function getItems(){return this.items;},function getNumberOfEmptySlots(){return this.capacity-this.items.len();},
    function add(item){if(failAdd||this.items.len()>=this.capacity)return null;this.items.push(item);return this.items.len()-1;},
    function remove(item){local i=this.items.find(item);if(i!=null)this.items.remove(i);if(failRemove)throw "failure after remove";return item;}
};
::World <- {Flags=flags(),Assets={function getStash(){return stash;}},function getPlayerRoster(){return {function getAll(){return brothers;}};}};
::AfeixExpedition <- {};
dofile("src/scripts/mods/afeix/core.nut");dofile("src/scripts/mods/afeix/keepsakes.nut");
local A=::AfeixExpedition;A.isOrigin=function(){return origin;};
A.findCharacter <- function(key){foreach(b in brothers)if(b.key==key)return b;return null;};
A.characterId <- function(b){return b.key;};
A.catalogGet<-function(a,k,fallback=0){return a.getFlags().has("combat_"+k)?a.getFlags().get("combat_"+k):fallback;};
A.catalogSet<-function(a,k,v){a.getFlags().set("combat_"+k,v);};
local reset=function(){brothers=[actor("afei")];stash.items=[];stash.capacity=3;::World.Flags.v={};round=1;origin=true;tactical=true;failCreate=false;failAdd=false;failRemove=false;failTrait=false;};
reset();A.ensureStoryItems();local afei=brothers[0],ecig=afei.inv.accessory;
expect(ecig!=null && ecig.getID()=="accessory.afeix_ecig" && afei.skills.len()==1,"new campaign equips a real ecig and gives one skill");
expect(stash.items.len()==0 && !A.get("item_issued_bicycle",false),"bicycle not revealed before Bottle joins");
A.ensureStoryItems();expect(afei.inv.accessory==ecig && afei.skills.len()==1,"repeated migration cannot duplicate item or skill");
brothers.push(actor("bottle"));A.ensureStoryItems();local bike=stash.items[0];
expect(bike.getID()=="misc.afeix_bicycle" && !bike.m.IsSellable && bike.m.SlotType==-1 && !bike.m.IsAllowedInBag,"bicycle is a real stash-only unsellable keepsake");
A.ensureStoryItems();expect(stash.items.len()==1 && stash.items[0]==bike,"same bicycle object retained");
local s=afei.skills[0];expect(s.isUsable() && s.m.ActionPointCost==4 && s.m.FatigueCost==10,"wounded Afei can puff at intended native cost");
expect(s.onUse(afei,null) && afei.hp==45 && ecig==afei.inv.accessory,"puff heals fifteen without consumption");
expect(!s.isUsable() && !s.onUse(afei,null) && afei.hp==45,"same-round replay is rejected");
afei.inv.unequip();afei.inv.equip(ecig);s=afei.skills[0];
expect(!s.isUsable(),"re-equipping a new skill cannot reset actor cooldown");
round+=2;expect(s.onUse(afei,null) && afei.hp==60,"next round heals only missing life");
round++;expect(!s.isUsable(),"full life cannot waste a puff");
afei.hp=20;tactical=false;expect(!s.isUsable(),"no world map healing");tactical=true;
origin=false;expect(!s.isUsable(),"no use in another origin");origin=true;
local stranger=brothers[1];afei.inv.unequip();stranger.inv.equip(ecig);stranger.hp=10;
expect(!stranger.skills[0].isUsable() && !stranger.skills[0].onUse(stranger,null),"only Afei can use the equipped item");
stranger.inv.unequip();afei.inv.equip(ecig);s=afei.skills[0];afei.hp=30;round=2;
expect(!s.isUsable(),"round stamp survives taking item away and returning it");
A.resetEcigRound(afei);A.catalogSet(afei,"ecig_uses",0);A.catalogSet(afei,"ecig_ready",0);expect(s.isUsable(),"combat-start hook resets previous-battle cooldown");
afei.alive=false;expect(!s.isUsable(),"dead actor cannot heal");afei.alive=true;
expect(!s.onUse(stranger,null),"caller cannot heal a different actor");
// Full inventories defer the grant. Existing equipment is not replaced.
reset();afei=brothers[0];local ordinary={function getID(){return "accessory.ordinary";}};afei.inv.accessory=ordinary;stash.capacity=0;
A.ensureStoryItems();expect(!A.get("item_issued_ecig",false) && afei.inv.accessory==ordinary,"full stash and occupied slot do not consume entitlement");
stash.capacity=1;A.ensureStoryItems();expect(stash.items.len()==1 && A.get("item_issued_ecig",false) && afei.inv.accessory==ordinary,"old-save gift goes to stash without replacing equipment");
brothers.push(actor("bottle"));A.ensureStoryItems();expect(!A.get("item_issued_bicycle",false),"full stash defers bicycle");
stash.capacity=2;A.ensureStoryItems();expect(stash.items.len()==2 && A.get("item_issued_bicycle",false),"freeing space allows the deferred bicycle");
stash.items=[];A.ensureStoryItems();expect(stash.items.len()==0,"manual disposal is not an infinite item source");
reset();failCreate=true;A.ensureStoryItems();expect(!A.get("item_issued_ecig",false),"failed creation leaves entitlement pending");
failCreate=false;A.ensureStoryItems();expect(A.get("item_issued_ecig",false),"creation retry succeeds once");
reset();A.set("bicycle_state",4);A.set("bicycle_choice",1);brothers.push(actor("bottle"));A.ensureStoryItems();
expect(A.findKeepsake("misc.afeix_bicycle")==null && A.get("item_issued_bicycle",false),"upgrade never restores a bicycle already discarded in old story");
// Run actual memory choice code with physical item removal and rollback.
dofile("src/scripts/mods/afeix/story_progress.nut");
A.canManage=function(){return true;};A.syncPersonalGrowth=function(b){if(failTrait)throw "trait failure";};
reset();brothers.push(actor("bottle"));A.ensureStoryItems();bike=A.findKeepsake("misc.afeix_bicycle");A.set("bicycle_state",3);
expect(A.resolveBicycleMemory(0).ok && A.findKeepsake("misc.afeix_bicycle")==bike,"keep-memory choice retains the actual bicycle");
expect(!A.resolveBicycleMemory(1).ok && A.findKeepsake("misc.afeix_bicycle")==bike,"reward cannot be replayed to destroy a kept bicycle");
reset();brothers.push(actor("bottle"));A.ensureStoryItems();bike=A.findKeepsake("misc.afeix_bicycle");A.set("bicycle_state",3);failTrait=true;
expect(!A.resolveBicycleMemory(1).ok && A.findKeepsake("misc.afeix_bicycle")==bike && A.get("bicycle_state")==3,"trait failure leaves physical item and choice intact");
failTrait=false;failRemove=true;expect(!A.resolveBicycleMemory(1).ok && A.findKeepsake("misc.afeix_bicycle")==bike && !A.get("bicycle_reward_granted",false),"post-removal callback failure restores same item and rolls back choice");
failRemove=false;expect(A.resolveBicycleMemory(1).ok && A.findKeepsake("misc.afeix_bicycle")==null && A.get("bicycle_state")==4,"discard choice removes real item only after successful trait update");
A.ensureStoryItems();expect(A.findKeepsake("misc.afeix_bicycle")==null,"reload/update cannot resurrect discarded bicycle");
reset();origin=false;A.ensureStoryItems();expect(brothers[0].inv.accessory==null && stash.items.len()==0,"other origins get no keepsakes");
reset();local xiwen=actor("xiwen"),mirror=makeItem("scripts/items/accessories/xiwen_round_mirror");xiwen.inv.equip(mirror);
expect(mirror.m.Value==0&&!mirror.m.IsSellable&&mirror.m.AddGenericSkill==false,"mirror no price or duplicate active skill");
local props={Bravery=21};mirror.onUpdateProperties(props);expect(props.Bravery==41,"Xiwen round mirror supplies20 resolve");
for(local i=0;i<3;i++){props={Bravery=21};mirror.onUpdateProperties(props);expect(props.Bravery==41,"mirror repeated rebuild never stacks");}
xiwen.inv.unequip();props={Bravery=21};mirror.onUpdateProperties(props);expect(props.Bravery==21,"bag or unequipped mirror has no bonus");
local other=actor("afei");other.inv.equip(mirror);props={Bravery=21};mirror.onUpdateProperties(props);expect(props.Bravery==21,"transferred mirror is owner locked");
other.inv.unequip();xiwen.inv.equip(mirror);props={Bravery=24};mirror.onUpdateProperties(props);expect(props.Bravery==44,"growth and mirror stay separate");
origin=false;props={Bravery=21};mirror.onUpdateProperties(props);expect(props.Bravery==21,"mirror inert in another origin");
print("TESTS_PASSED="+checks+"\n");
