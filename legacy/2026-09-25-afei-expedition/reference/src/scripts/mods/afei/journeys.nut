local A=::AfeiExpedition;
A.neighbor <- function(home) {
 if(home==null)return null;local best=null,distance=100000;
 foreach(t in ::World.EntityManager.getSettlements()) {
   if(t.getID()==home.getID() || t.isMilitary() || !t.isAlliedWithPlayer() || !home.isConnectedToByRoads(t))continue;
   local n=home.getTile().getDistanceTo(t.getTile());if(n<distance) {best=t;distance=n;}
 }
 return best;
};
A.deliveryReward <- function() {return 200+::Math.min(300,this.getPaidContracts()*5);};
A.completePaid <- function(key,escort=false) {
 if(this.w("paid_once_"+key))return false;this.sw("paid_once_"+key,true);this.inc("paid_contracts");this.bumpCohesion(2,true);
 foreach(b in this.roster())if(!this.g(b,"camped")) {this.bump(b,"contracts");if(escort)this.bump(b,"escort_contracts");}
 if(escort) {this.inc("escort_contracts");if(this.eligible("C16"))this.sw("recruit_ready_C16",true);}
 return true;
};
A.startDelivery <- function(key,reward,cache=false) {
 if(!this.safe() || this.w("journey_"+key+"_done") || this.w("journey_"+key+"_active") || this.now()<this.w("journey_"+key+"_retry"))return false;
 local town=this.town(),destination=this.neighbor(town);if(destination==null)return false;
 this.sw("journey_"+key+"_destination",destination.getID());this.sw("journey_"+key+"_name",destination.getNameOnly());this.sw("journey_"+key+"_reward",reward);this.sw("journey_"+key+"_active",true);
 if(cache) {
   local origin=destination.getTile(),chosen=null;
   for(local i=0;i<6;i++)if(origin.hasNextTile(i)) {local t=origin.getNextTile(i);if(!t.IsOccupied && t.Type!=::Const.World.TerrainType.Ocean && t.Type!=::Const.World.TerrainType.Shore) {chosen=t;break;}
}
   if(chosen==null) {this.sw("journey_"+key+"_active",false);return false;}
   this.sw("journey_"+key+"_x",chosen.SquareCoords.X);this.sw("journey_"+key+"_y",chosen.SquareCoords.Y);::World.uncoverFogOfWar(chosen.Pos,200.0);
 }
 return true;
};
A.deliveryStep <- function(key,reward,cache=false) {
 if(this.w("journey_"+key+"_done"))return false;
 if(!this.w("journey_"+key+"_active"))return this.startDelivery(key,reward,cache);
 local dest=::World.getEntityByID(this.w("journey_"+key+"_destination"));if(dest==null || !dest.isAlive()) {this.failJourney(key);return false;}
 if(cache) {
   local tile=::World.getTileSquare(this.w("journey_"+key+"_x"),this.w("journey_"+key+"_y"));if(::World.State.getPlayer().getTile().getDistanceTo(tile)>1 || !this.safe())return false;
   this.spendHours(2);
 }
else {local town=this.town();if(town==null || town.getID()!=dest.getID())return false;}
 this.sw("journey_"+key+"_active",false);this.sw("journey_"+key+"_done",true);
 local amount=this.w("journey_"+key+"_reward");if(amount>0) {::World.Assets.addMoney(amount);this.completePaid("delivery_"+key);}
 if(key=="m01")this.sw("m01_done",true);else if(key in this.Characters)this.sw("recruit_ready_"+key,true);
 return true;
};
A.failJourney <- function(key) {this.sw("journey_"+key+"_active",false);this.sw("journey_"+key+"_retry",this.now()+this.hours(168));};
A.journeyDescription <- function(key) {
 if(this.w("journey_"+key+"_done"))return "已经交付。";
 if(this.now()<this.w("journey_"+key+"_retry"))return "失败后整备中，七日后可重新领取。";
 if(!this.w("journey_"+key+"_active"))return "尚未领取路线；在友好城镇领取。";
 local text="目的地："+this.w("journey_"+key+"_name","");if(key=="C13")text+="附近补给箱（地图格 "+this.w("journey_"+key+"_x")+", "+this.w("journey_"+key+"_y")+"），到场安全扎营后确认侦察。";
 return text;
};
A.startEscort <- function(key) {
 if(!this.safe() || ::World.Contracts.getActiveContract()!=null || this.w("journey_"+key+"_done") || this.w("journey_"+key+"_active") || this.now()<this.w("journey_"+key+"_retry"))return false;
 local town=this.town(),destination=this.neighbor(town);if(destination==null)return false;
 local faction=town.getFactionOfType(::Const.FactionType.Settlement);if(faction==null)faction=town.getFactionOfType(::Const.FactionType.OrientalCityState);if(faction==null)return false;
 local c=::new("scripts/contracts/contracts/afei_journey_contract");c.setFaction(faction.getID());c.setEmployerID(faction.getRandomCharacter().getID());c.setHome(town);c.setOrigin(town);c.m.Destination=::WeakTableRef(destination);
 c.m.Flags.set("AfeiJourney",key);c.m.Flags.set("Distance",c.getDistanceOnRoads(town.getTile(),destination.getTile()));c.m.Flags.set("HeadsCollected",0);c.m.Payment.Pool=this.deliveryReward();c.m.Payment.Completion=1.0;
 c.m.Name=key=="m04"?"蓝旗联合护送":(key=="C27"?"空车试走":"护送滞留者");c.m.TimeOut=0;c.m.DifficultyMult=1.0;c.m.IsNegotiated=true;
 ::World.Contracts.addContract(c);c.m.IsStarted=true;::World.Contracts.setActiveContract(c);c.spawnCaravan();
 if(key=="m04") {local party=c.m.Caravan;party.getTroops().clear();for(local i=0;i<2;i++)::Const.World.Common.addTroop(party,{Type=::Const.World.Spawn.Troops.CaravanGuard,Num=1},true);}
 c.setState("Running");this.sw("journey_"+key+"_active",true);this.sw("journey_"+key+"_name",destination.getNameOnly());return true;
};
A.escortResult <- function(c,success) {
 local key=c.m.Flags.get("AfeiJourney");if(key==null)return;
 if(!success) {this.failJourney(key);return;}
 this.sw("journey_"+key+"_active",false);this.sw("journey_"+key+"_done",true);
 if(key=="m04" && !this.w("m04_done")) {this.sw("m04_done",true);this.bumpCohesion(4);}
 if(key in this.Characters)this.sw("recruit_ready_"+key,true);
};
A.scoutPath <- function() {
 local b=this.named("C12",true),c=::World.Contracts.getActiveContract();if(b==null || c==null || c.getType().find("escort")==null || this.now()<this.g(b,"scout_until") || !("Destination" in c.m) || c.m.Destination==null)return false;
 local to=c.m.Destination.getTile(),from=::World.State.getPlayer().getTile(),report=null,tag="";
 foreach(entity in ::World.getAllEntitiesAtPos(from.Pos,1500.0)) {
   if(entity==null || !entity.isAlive() || entity.isAlliedWithPlayer() || !("getTroops" in entity) || entity.getTroops().len()==0)continue;
   tag="scout_"+c.getID()+"_"+entity.getID();if(this.w(tag))continue;
   local tile=entity.getTile();if(from.getDistanceTo(tile)+tile.getDistanceTo(to)>from.getDistanceTo(to)+8)continue;
   report=entity.getName()+"最近出现于地图格 "+tile.SquareCoords.X+", "+tile.SquareCoords.Y;::World.uncoverFogOfWar(tile.Pos,150.0);break;
 }
 if(report==null) {
   local settings=::World.getNavigator().createSettings();settings.ActionPointCosts=::Const.World.TerrainTypeNavCost_Flat;local path=::World.getNavigator().findPath(from,to,settings,0);
   if(!path.isEmpty())while(!path.isEmpty()) {local tile=::World.getTile(path.getCurrent());path.pop();if(tile.HasRoad)continue;tag="scout_"+c.getID()+"_terrain_"+tile.ID;if(this.w(tag))continue;report="路线有一段离开道路，地图格 "+tile.SquareCoords.X+", "+tile.SquareCoords.Y;break;}
 }
 if(report==null)return false;
 this.spendHours(2);this.sw(tag,true);this.s(b,"scout_until",this.now()+this.hours(168));this.sw("scout_report","第"+this.day()+"日查明："+report+"。记录位置不随敌人后续移动而更新。");return true;
};
A.spawnFrost <- function() {
 if(this.w("m07_location")) {local old=::World.getEntityByID(this.w("m07_location"));if(old!=null && old.isAlive())return false;}
 local from=::World.State.getPlayer().getTile(),chosen=null,best=-100000;
 foreach(town in ::World.EntityManager.getSettlements()) {local tile=town.getTile();for(local i=0;i<6;i++)if(tile.hasNextTile(i)) {local t=tile.getNextTile(i);if(t.IsOccupied || t.Type==::Const.World.TerrainType.Ocean || t.Type==::Const.World.TerrainType.Shore)continue;local score=t.SquareCoords.Y-from.getDistanceTo(t)*0.25;if(t.Type==::Const.World.TerrainType.Snow || t.Type==::Const.World.TerrainType.Tundra)score+=1000;if(score>best) {chosen=t;best=score;}
}
}
 if(chosen==null)return false;local location=::World.spawnLocation("scripts/entity/world/locations/afei_frost_shadow_location",chosen.Coords);location.setFaction(::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());location.onSpawned();location.setDiscovered(true);location.setAttackable(true);location.getSprite("selection").Visible=true;::World.uncoverFogOfWar(chosen.Pos,400.0);this.sw("m07_location",location.getID());return true;
};
