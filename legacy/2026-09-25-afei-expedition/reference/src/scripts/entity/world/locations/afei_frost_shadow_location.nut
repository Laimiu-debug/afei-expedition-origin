this.afei_frost_shadow_location <- this.inherit("scripts/entity/world/locations/bandit_camp_location", {
 function create() {this.bandit_camp_location.create();this.m.TypeID="location.afei_frost_shadow";this.m.Name="北境白影巢穴";this.m.IsDespawningDefenders=false;this.m.CombatLocation.Fortification=this.Const.Tactical.FortificationType.None;this.m.CombatLocation.Template[0]=null;},
 function getDescription() {return "白色巨兽留下的脚印通向这里。可以侦察后离开，再带准备充分的队伍回来。";},
 function onSpawned() {this.location.onSpawned();this.m.Name="北境白影巢穴";this.createDefenders();},
 function createDefenders() {
   if(this.getFlags().get("afei_fixed_roster"))return;this.getFlags().set("afei_fixed_roster",true);this.m.Troops.clear();
   local target=clone this.Const.World.Spawn.Troops.UnholdFrost;target.Script="scripts/entity/tactical/enemies/afei_frost_unhold";this.Const.World.Common.addTroop(this,{Type=target});
   local levels=0,n=0;foreach(b in ::AfeiExpedition.roster())if(!::AfeiExpedition.g(b,"camped")){levels+=b.getLevel();n++;}
   local guards=n>0 && levels.tofloat()/n>=10?2:1;for(local i=0;i<guards;i++)this.Const.World.Common.addTroop(this,{Type=this.Const.World.Spawn.Troops.Unhold});
 },
 function onDropLootForPlayer(loot) {this.location.onDropLootForPlayer(loot);}
});