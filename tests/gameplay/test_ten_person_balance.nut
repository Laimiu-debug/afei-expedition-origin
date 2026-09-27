// Actual installed vanilla strength and contract scaling. This is not a battle simulation.
::inherit <- function(path,members){return members;};
::Math <- {maxf=function(a,b){return a>b?a:b;},minf=function(a,b){return a<b?a:b;},pow=function(a,b){return ::pow(a,b);}};
::Const <- {Difficulty={EnemyMult=[0.85,1.0,1.15]}};
::roster <- [];::origin <- true;
::AfeixExpedition <- {CombatMax=10,RosterMax=40,isOrigin=function(){return ::origin;},enforceFormation=function(){}};
::World <- {Assets={m={BrothersMax=20,BrothersMaxInCombat=12,BrothersScaleMax=12},getBrothersScaleMax=function(){return this.m.BrothersScaleMax;},getBrothersScaleMin=function(){return 3;},getCombatDifficulty=function(){return 1;},updateFormation=function(...) {},getFormation=function(){return [];},addMoney=function(n){}},getPlayerRoster=function(){return {getAll=function(){return clone ::roster;}};}};
::mods_hookExactClass <- function(...){};::mods_hookBaseClass <- function(...){};
::mods_hookNewObject <- function(path,fn){if(path=="states/world/asset_manager")fn(::World.Assets);};
dofile("src/scripts/mods/afeix/hooks.nut");
dofile(".cache/afei-art/native-contract-fixture/player_party.nut");
dofile(".cache/afei-art/native-contract-fixture/contract.nut");
::party <- clone ::player_party;::party.m=clone ::party.m;::party.m.Strength<-0.0;::party.setdelegate(getroottable());
::World.State <- {getPlayer=function(){return ::party;}};
local c=clone ::contract;c.setdelegate(getroottable());
local checks=0;
function bro(level){return {level=level,getLevel=function(){return this.level;}};}
local check=function(ok,label){if(!ok)throw "FAIL "+label;checks++;};
foreach(n in [1,3,6,10,12,34,40])foreach(level in [1,5,11]){
    ::roster=[];for(local i=0;i<n;i++)::roster.push(bro(level));
    ::World.Assets.m.BrothersScaleMax=12;::party.updateStrength();local old=::party.getStrength(),oldContract=c.getScaledDifficultyMult();
    ::World.Assets.updateFormation();::party.updateStrength();local now=::party.getStrength();
    local counted=n<10?n:10,expected=counted*(10+(level-1)*2)+(n<3?(3-n)*10:0);
    check(now==expected,"native ten-person strength "+n+" lv "+level);
    check(n<=10?now==old:now<old,"no opening buff and no eleventh seat");
    check(c.getScaledDifficultyMult()<=oldContract,"native difficulty not increased");
    print("BALANCE "+n+" members level "+level+": "+old+" -> "+now+"; contract "+oldContract+" -> "+c.getScaledDifficultyMult()+"\n");
}
::roster=[];for(local i=0;i<10;i++)::roster.push(bro(11));::party.updateStrength();local veteran=::party.getStrength();
for(local i=0;i<24;i++)::roster.push(bro(1));::party.updateStrength();check(::party.getStrength()==veteran,"collecting low-level reserves no added strength");
::roster.reverse();::party.updateStrength();check(::party.getStrength()==veteran,"reordering reserves cannot lower strength");
::World.Assets.m.BrothersScaleMax=12;::World.Assets.updateFormation();check(::World.Assets.m.BrothersScaleMax==10,"old save migration");
::origin=false;::World.Assets.m.BrothersScaleMax=12;::World.Assets.updateFormation();check(::World.Assets.m.BrothersScaleMax==12,"other origins unchanged");
print("TESTS_PASSED="+checks+"\n");
