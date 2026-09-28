// Actual native wardog/unleash definitions, with only engine services stubbed.
local checks=0;
function expect(value,message){if(!value)throw "FAIL "+message;checks++;}
::inherit <- function(path,child){return child;};
::Math <- {function rand(a,b){return a;}};
::Const <- {Strings={WardogNames=["Native"]},ItemSlot={Accessory=5},Faction={PlayerAnimals=7}};
::World <- {function getTime(){return {IsDaytime=true};}};
dofile("native/wardog_item.nut");
local native = ::wardog_item;
dofile("src/scripts/items/accessory/afeix_regen_item.nut");
local custom = ::afeix_regen_item;
function makeDog() {
    local dog=clone native; dog.m=clone native.m;
    foreach(key,value in {Variant=0,Icon="",ID="",Name="",Description="",SlotType=0,IsDroppedAsLoot=false,ShowOnCharacter=true,IsChangeableInBattle=true,Value=0}) dog.m[key] <- value;
    foreach(key,value in custom) if(key!="m")dog[key]<-value;
    dog.setdelegate(getroottable());
    dog.wardog_item <- native;
    dog.accessory <- {function create(){},function onSerialize(out){out.writeString("native-accessory");},function onDeserialize(input){expect(input.readString()=="native-accessory","base save payload retained");}};
    dog.getVariant <- function(){return this.m.Variant;};
    // Base dispatch binds the native method to the child, as engine inherit does.
    dog.wardog_item = { create=native.create.bindenv(dog) };
    dog.create(); return dog;
}
local dog=makeDog();
expect(dog.m.ID=="accessory.afeix_regen" && dog.getName()=="里根","custom item identity");
expect(dog.getScript()=="scripts/entity/tactical/wardog","native dog entity and AI retained");
expect(dog.m.SlotType==5 && dog.m.IsDroppedAsLoot && !dog.m.IsChangeableInBattle,"native accessory rules retained");
expect(!dog.isUnleashed() && dog.getDescription().find("阵亡")!=null,"companion starts leashed with honest description");
local stream={values=[],pos=0,function writeString(s){this.values.push(s);},function readString(){return this.values[this.pos++];}};
dog.onSerialize(stream); local restored=makeDog();restored.m.Name="wrong";restored.onDeserialize(stream);
expect(restored.getName()=="里根" && stream.pos==2,"native serialization restores pet name and payload");
dofile("native/unleash_wardog.nut");
local skill=::unleash_wardog;skill.setdelegate(getroottable());skill.m.Item <- restored;skill.m.IsHidden <- false;
local spawned=null;
::Tactical <- {function spawnEntity(path,x,y){
    expect(path=="scripts/entity/tactical/wardog" && x==1 && y==2,"native release spawn location");
    spawned={name="",item=null,faction=0,variant=0,function setName(v){this.name=v;},function setItem(v){this.item=v;},function setFaction(v){this.faction=v;},function setVariant(v){this.variant=v;}};
    return spawned;
}};
skill.getContainer <- function(){return {function hasSkill(id){return false;}};};
expect(skill.onUse(null,{Coords={X=1,Y=2}}),"native release succeeds");
expect(spawned.name=="里根" && spawned.item==restored && spawned.faction==7,"released dog keeps name and player faction");
expect(restored.isUnleashed() && restored.getName()=="里根的项圈","equipped collar preserves identity");
expect(restored.getDescription().find("已经进入战场")!=null,"unleashed description");
skill.skill <- {function isUsable(){return true;}};
expect(!skill.isUsable(),"cannot release a second copy in battle");
restored.onCombatFinished();
expect(!restored.isUnleashed() && restored.getName()=="里根" && skill.isUsable(),"native combat return restores companion");
print("TESTS_PASSED="+checks+"\n");
