// Execute the installed native barber module through the production hook.
// Sprites/portraits are engine substitutes; no graphical renderer is asserted.
local checks=0;
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
::actors <- {};
function actor(id,custom=false) {
    local sprites={};
    foreach(layer in ["body","head","hair","beard","beard_top","tattoo_body","tattoo_head"])
        sprites[layer]<-{Name="native_"+layer,Visible=true,HasBrush=true,
            getBrush=function(){return {Name=this.Name};},setBrush=function(name){this.Name=name;this.HasBrush=true;},resetBrush=function(){this.HasBrush=false;}};
    return {id=id,custom=custom,art=true,sprites=sprites,
        getID=function(){return this.id;},getName=function(){return "test";},getImagePath=function(){return "portrait-"+this.id;},
        getImageOffsetX=function(){return 0;},getImageOffsetY=function(){return 0;},
        getBackground=function(){return {getIconColored=function(){return "icon";},getDescription=function(){return "story";}};},
        getSprite=function(k){return this.sprites[k];},hasSprite=function(k){return k in this.sprites;},setDirty=function(v){},
        copySpritesFrom=function(source,layers){foreach(k in layers){this.sprites[k]=clone source.sprites[k];this.sprites[k].Visible=true;}}
    };
}
local named=actor(1,true),ordinary=actor(2);::actors[1]<-named;::actors[2]<-ordinary;
local roster={all=[],clear=function(){this.all=[];},getAll=function(){return this.all;},
    create=function(path){local temp=actor(99);this.all.push(temp);return temp;}};
::World <- {getTemporaryRoster=function(){return roster;},getPlayerRoster=function(){return {getAll=function(){return [named,ordinary];}};}};
::Tactical <- {getEntityByID=function(id){return id in ::actors?::actors[id]:null;}};
::Const <- {Faces={Barber=["native_head","changed_head"]},Sound={Barber=["snip"]}};
::Sound <- {play=function(...) {}};::Math <- {rand=function(a,b){return a;}};
::String <- {contains=function(s,part){return s.find(part)!=null;}};
::inherit <- function(path,data){return data;};
::AfeixExpedition <- {
    enabled=true,Art={HiddenLayers=["hair","beard","beard_top","tattoo_body","tattoo_head"]},
    isArtCharacter=function(bro){return this.enabled&&bro.custom;},hasPortraitArt=function(bro){return bro.art;},
    syncCharacterArt=function(bro){bro.sprites.body.Name="custom_body";bro.sprites.head.Name="custom_head";foreach(k in this.Art.HiddenLayers)bro.sprites[k].Visible=false;}
};
dofile(".cache/afei-art/native-contract-fixture/town_barber_dialog_module.nut");
local barber=::town_barber_dialog_module;barber.setdelegate(getroottable());
barber.m.Parent <- {closed=false,queryAssetsInformation=function(){return {};},onModuleClosed=function(){this.closed=true;}};
::mods_hookExactClass <- function(path,cb){cb(barber);};
dofile("src/scripts/mods/afeix/barber_hooks.nut");
local data=barber.queryRosterInformation();
check(data.Roster[0].AfeixPortraitLocked&&!data.Roster[1].AfeixPortraitLocked,"only named custom art is locked");
check(barber.onEntrySelected(1)=="portrait-99","native temporary preview is used");
local temp=roster.all[0];check(!temp.custom,"native temporary human has no character identity");
foreach(k in ::AfeixExpedition.Art.HiddenLayers)check(!temp.sprites[k].Visible,"native layer hidden in preview: "+k);
foreach(layer in ["color","head","hair","beard","body","tattoo"])foreach(change in [-1,1]) {
    check(barber.onUpdateAppearance([1,layer,change])=="portrait-99","arrow safely returns locked preview");
    check(temp.sprites.head.Name=="custom_head"&&temp.sprites.body.Name=="custom_body","arrow cannot replace custom layers");
}
temp.sprites.head.Name="malicious_native_head";temp.sprites.hair.Visible=true;
check(barber.onChangeAppearance(1)=="portrait-1"&&named.sprites.head.Name=="custom_head"&&!named.sprites.hair.Visible,"accept cannot corrupt real portrait");
barber.onEntrySelected(2);barber.onUpdateAppearance([2,"head",1]);barber.onChangeAppearance(2);
check(ordinary.sprites.head.Name=="changed_head","ordinary barber edits remain native");
named.art=false;check(!barber.queryRosterInformation().Roster[0].AfeixPortraitLocked,"missing custom art uses native fallback");
named.art=true;::AfeixExpedition.enabled=false;
check(!barber.queryRosterInformation().Roster[0].AfeixPortraitLocked,"other origin stays unlocked");
barber.onLeaveButtonPressed();check(roster.all.len()==0&&barber.m.Parent.closed,"native leave cleans temporary roster");
print("TESTS_PASSED="+checks+"\n");
