dofile("tests/gameplay/member_skill_fixture.nut");
dofile("src/scripts/mods/afeix/douyu_overlay.nut");
local n = 0;
local check = function(ok, label) { if (!ok) throw "FAIL Douyu overlay: " + label; ++n; };
::createVec <- function(x, y) { return {X=x, Y=y}; };
::createColor <- function(value) { return value; };
::Settings <- { settings={ShowOverlayStats=true}, getTempGameplaySettings=function(){return this.settings;} };
::Tactical.State <- {tile=null,getLastTileHovered=function(){return this.tile;}};
local a = {
    m={AfeixBarSprites=[], AfeixBarIcons=[], ContentID=7, IsUsingCustomRendering=false},
    sprites={}, offsets={}, alive=true, dying=false, placed=true, hidden=false, hover=false,
    addSprite=function(id){local s={Alpha=255,Visible=true,Scale=1.0,Color=null,brush="",setBrush=function(v){this.brush=v;}};this.sprites[id]<-s;return s;},
    getSprite=function(id){return this.sprites[id];},
    setSpriteOffset=function(id,v){this.offsets[id]<-v;},
    setRenderCallbackEnabled=function(v){this.render<-v;},
    updateOverlay=function(){::AfeixExpedition.DouyuOverlay.values(this,1.0,0.5,1.0);::AfeixExpedition.DouyuOverlay.icons(this,["status_effect_34_mini"]);},
    isAlive=function(){return this.alive;},isDying=function(){return this.dying;},
    isPlacedOnMap=function(){return this.placed;},isHiddenToPlayer=function(){return this.hidden;},
    isDiscovered=function(){return !this.hidden;},getID=function(){return 42;}
};
local O=::AfeixExpedition.DouyuOverlay;
O.init(a);
check(a.render && a.m.IsUsingCustomRendering,"native animation callback retained");
check(a.sprites.len()==6,"native frames, three bars, one circular icon");
check(a.getSprite("afeix_bar_body").brush=="entityoverlay_bar_12","actual half armor");
check(a.getSprite("afeix_bar_hp").brush=="entityoverlay_bar_24","actual full HP");
check(a.offsets.afeix_bar_top.Y==O.Height && O.Height>=150,"frame lifted above full size bust");
check(a.offsets.afeix_bar_icon_0.Y>O.Height,"round icon above bars");
foreach(v in [0.0,0.01,0.5,1.0,2.0,-1.0]) {
    O.values(a,v,v,v);
    foreach(name in ["head","body","hp"]) check(a.getSprite("afeix_bar_"+name).Alpha==(v>0?255:0),"zero bar leaves no sliver");
}
O.icons(a,["status_effect_34_mini","status_effect_74_mini"]);
check(a.m.AfeixBarIcons.len()==2,"new debuff icon added");
check(a.offsets.afeix_bar_icon_0.X==-10 && a.offsets.afeix_bar_icon_1.X==10,"icons centered");
O.icons(a,[]);
check(a.getSprite("afeix_bar_icon_0").Alpha==0 && a.getSprite("afeix_bar_icon_1").Alpha==0,"removed statuses hidden");
::Settings.settings.ShowOverlayStats=false;O.visibility(a);
check(!a.getSprite("afeix_bar_top").Visible,"stats toggle hides bar");
::Tactical.State.tile={IsOccupiedByActor=true,getEntity=function(){return {getID=function(){return 42;}};}};
O.visibility(a);check(a.getSprite("afeix_bar_top").Visible,"hover reveals bar");
foreach(flag in ["hidden","dying"]) {a[flag]=true;O.visibility(a);check(!a.getSprite("afeix_bar_top").Visible,"fog/death hides bar");a[flag]=false;}
a.placed=false;O.visibility(a);check(!a.getSprite("afeix_bar_top").Visible,"unplaced actor hides bar");a.placed=true;
local image=O.image(a);
foreach(id in a.m.AfeixBarSprites) check(image.find(id)!=null,"bar excluded from portrait");
foreach(id in a.m.AfeixBarIcons) check(image.find(id)!=null,"icon excluded from portrait");
a.hidden=true;check(O.image(a)=="ui/images/undiscovered_opponent.png","discovery portrait preserved");
print("TESTS_PASSED="+n+"\n");
