// Real native actor renderer; engine sprites and campaign storage are fixtures.
local checks=0,origin=true,tactical=false,combatStart=0,roster=[],flags={};
local check=function(ok,label){if(!ok)throw "FAIL helmet: "+label;checks++;};
::Const <- {BloodType={None=0},MoraleState={Steady=0,Confident=1},DefaultMovementAPCost=[],DefaultMovementFatigueCost=[],
    MoraleCheckType={Default=0},FatalityType={None=0},
    Movement={LevelDifferenceActionPointCost=0,LevelDifferenceFatigueCost=0},Tactical={MovementType={Default=0}},ShakeCharacterLayers=[]};
::createColor <- function(v){return v;};::createVec <- function(x,y){return {X=x,Y=y};};
::inherit <- function(path,body){return body;};
dofile(".cache/afei-art/native-contract-fixture/actor.nut");
::World <- {Flags={has=function(k){return k in flags;},get=function(k){return flags[k];},set=function(k,v){flags[k]<-v;}},
    State={getPlayer=function(){return {};},getCombatStartTime=function(){return combatStart;}}};
::Tactical <- {isActive=function(){return tactical;}};
::AfeixExpedition <- {};
dofile("src/scripts/mods/afeix/core.nut");
local A=::AfeixExpedition;
A.isOrigin=function(){return origin;};A.roster=function(){return roster;};
local hooks={};
::mods_hookExactClass <- function(path,callback){hooks[path]<-callback;};
::mods_getMember <- function(o,k){while(!(k in o))o=o[o.SuperName];return o[k];};
::mods_override <- function(o,k,v){while(!(k in o))o=o[o.SuperName];o[k]=v;};
dofile("src/scripts/mods/afeix/company_appearance_hooks.nut");
local makeBrother=function() {
    local sprites={};
    foreach (layer in ["head","hair","beard","beard_top","helmet","helmet_damage","body","armor","permanent_injury_1"])
        sprites[layer]<-{Visible=true,brush="native_"+layer,Color="white",setBrush=function(v){this.brush=v;}};
    local appearance={HideHead=true,HideHair=true,HideBeard=true,HideBody=false,Helmet="full_helm",HelmetDamage="damaged_helm",HelmetColor="grey",Armor="coat",ArmorColor="brown"};
    local helmet={Condition=290,StaminaModifier=-20},items={helmet=helmet,getAppearance=function(){return appearance;}};
    local native={onAppearanceChanged=::actor.onAppearanceChanged.bindenv({prototype=true})};
    local bro={SuperName="actor",actor=native,m={IsAlive=true,IsDying=false,IsHidingHelmet=false},sprites=sprites,
        dirty=0,getItems=function(){return items;},hasSprite=function(k){return k in sprites;},getSprite=function(k){return sprites[k];},
        setDirty=function(v){if(v)this.dirty++;},
        onDeserialize=function(input){this.m.IsHidingHelmet=false;return 42;},
        onCombatFinished=function(){this.m.IsHidingHelmet=false;return 43;}};
    hooks["entity/tactical/player"](bro);
    check(!("onAppearanceChanged" in bro)&&native.onAppearanceChanged!=::actor.onAppearanceChanged,"override remains on native definition table");
    bro.onAppearanceChanged<-::mods_getMember(bro,"onAppearanceChanged");
    return bro;
};
local first=makeBrother(),ordinary=makeBrother(),outsider=makeBrother();roster=[first,ordinary];
first.onAppearanceChanged(first.getItems().getAppearance());
check(first.sprites.helmet.Visible&&!first.sprites.head.Visible,"unconfigured closed helmet keeps native appearance");
local item=first.getItems().helmet,app=first.getItems().getAppearance(),before=clone app;
check(A.toggleCompanyHelmets().ok&&flags.afeix_hide_helmets,"toggle saves global preference");
foreach(bro in roster)check(bro.m.IsHidingHelmet&&!bro.sprites.helmet.Visible&&!bro.sprites.helmet_damage.Visible&&bro.sprites.head.Visible,"hidden intact damaged and closed helmet reveals head");
check(first.sprites.armor.Visible&&first.sprites.armor.brush=="coat","body armor unchanged");
check(first.getItems().helmet==item&&item.Condition==290&&item.StaminaModifier==-20,"same equipped helmet and properties retained");
foreach(k,v in before)check(app[k]==v,"item appearance data unchanged: "+k);
first.onAppearanceChanged(app,false);
check(!first.sprites.helmet.Visible&&first.sprites.head.Visible,"equipment renderer retains hidden state");
app.Helmet="new_helm";app.HelmetDamage="new_helm_damage";first.onAppearanceChanged(app);
check(!first.sprites.helmet.Visible,"new equipment remains hidden");
check(A.toggleCompanyHelmets().ok&&!first.m.IsHidingHelmet&&first.sprites.helmet.Visible&&first.sprites.helmet.brush=="new_helm"&&!first.sprites.head.Visible,"show restores current equipped helmet, not stale snapshot");
app.Helmet="";app.HelmetDamage="";app.HideHead=false;app.HideHair=false;app.HideBeard=false;
first.onAppearanceChanged(app);
A.toggleCompanyHelmets();A.toggleCompanyHelmets();
check(!first.sprites.helmet.Visible&&!first.sprites.helmet_damage.Visible&&first.sprites.head.Visible,"no helmet never creates phantom artwork");
A.toggleCompanyHelmets();
local recruit=makeBrother();
recruit.onAppearanceChanged(recruit.getItems().getAppearance());
check(recruit.sprites.helmet.Visible,"unhired candidate stays native");
local hire={onHireRosterEntry=function(id){roster.push(recruit);return {Result=0};}};
hooks["ui/screens/world/modules/world_town_screen/town_hire_dialog_module"](hire);
check(hire.onHireRosterEntry(1).Result==0&&!recruit.sprites.helmet.Visible,"new hire inherits preference after transfer");
check(recruit.onDeserialize(null)==42&&!recruit.sprites.helmet.Visible,"actor reload retains native return and preference");
check(recruit.onCombatFinished()==43&&!recruit.sprites.helmet.Visible,"combat end restores preference");
local world={onDeserialize=function(input){foreach(bro in roster)bro.m.IsHidingHelmet=false;return 44;}};
hooks["states/world_state"](world);
local saved=clone flags;flags={};
check(!A.get("hide_helmets",false),"new campaign starts with native display");flags=clone saved;
check(world.onDeserialize(null)==44&&recruit.m.IsHidingHelmet,"world load restores setting after campaign flags");
outsider.onAppearanceChanged(outsider.getItems().getAppearance());
check(!outsider.m.IsHidingHelmet&&outsider.sprites.helmet.Visible,"enemy ally and recruit outside company unaffected");
first.m.IsAlive=false;first.m.IsHidingHelmet=false;
A.syncCompanyHelmets();check(!first.m.IsHidingHelmet,"dead member renderer is untouched");first.m.IsAlive=true;
tactical=true;check(!A.toggleCompanyHelmets().ok&&A.get("hide_helmets",false),"combat disallows menu toggle");
tactical=false;combatStart=1;check(!A.toggleCompanyHelmets().ok,"combat transition disallows toggle");
combatStart=0;origin=false;ordinary.m.IsHidingHelmet=false;ordinary.onAppearanceChanged(ordinary.getItems().getAppearance());
check(ordinary.sprites.helmet.Visible&&!A.toggleCompanyHelmets().ok,"other origin retains native appearance");origin=true;
::Math <- {min=function(a,b){return a<b?a:b;}};::mods_hookNewObject <- function(path,cb){};
dofile("src/scripts/mods/afeix/ledger.nut");dofile("src/scripts/mods/afeix/banner_hooks.nut");
A.trainingLedgerPage<-function(e,p){return null;};
local event={m={Notice=""}},page=A.ledgerPage(event,"company");
check(page.Options.len()==4&&page.Options[2].Text=="显示全队头盔","company menu contains correct current action");
check(page.Options[2].getResult(event)=="company"&&!A.get("hide_helmets",false)&&event.m.Notice!="","menu performs toggle and explains result");
check(A.ledgerPage(event,"company").Options[2].Text=="隐藏全队头盔","menu offers reverse action");
print("TESTS_PASSED="+checks+"\n");
