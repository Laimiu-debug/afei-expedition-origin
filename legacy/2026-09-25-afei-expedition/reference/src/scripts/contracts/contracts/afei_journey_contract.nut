this.afei_journey_contract <- this.inherit("scripts/contracts/contracts/escort_caravan_contract", {
 m={},
 function create() {this.escort_caravan_contract.create();this.m.Type="contract.afei_escort";this.m.Name="黑旗护送";this.m.DifficultyMult=1.0;this.m.TimeOut=0;},
 function start() {this.m.IsStarted=true;this.setScreen("Overview");},
 function onImportIntro() {},
 function createStates() {
   this.m.States.push({ID="Running",function start() {this.World.State.setEscortedEntity(this.Contract.m.Caravan);this.Contract.m.BulletpointsObjectives=["护送至 "+this.Contract.m.Destination.getNameOnly()];},
   function update() {
     local c=this.Contract;if(c.m.Flags.get("AfeiFinished"))return;
     if(c.m.Caravan==null || c.m.Caravan.isNull() || !c.m.Caravan.isAlive() || c.m.Caravan.getTroops().len()==0 || this.Flags.get("IsFleeing")) {c.setScreen("Failure");this.World.Contracts.showActiveContract();return;}
     this.World.State.setEscortedEntity(c.m.Caravan);this.World.State.setCampingAllowed(false);this.World.State.getPlayer().setPos(c.m.Caravan.getPos());this.World.State.getPlayer().setVisible(false);this.World.Assets.setUseProvisions(false);this.World.getCamera().moveTo(this.World.State.getPlayer());
     if(c.isPlayerAt(c.m.Destination)) {c.setScreen("Success");this.World.Contracts.showActiveContract();return;}
     if(!this.Flags.get("IsEnoughCombat") && c.spawnEnemies())this.Flags.set("IsEnoughCombat",true);
   },
   function onRetreatedFromCombat(id) {this.Flags.set("IsFleeing",true);}
   });
 },
 function createScreens() {
   this.m.Screens.push({ID="Overview",Title="黑旗护送",Text="车队正沿约定路线前进，报酬与风险按普通护送结算。",Image="",List=[],Options=[{Text="继续护送",function getResult(){return 0;}
}],function start(){}
});
   this.m.Screens.push({ID="Success",Title="平安到站",Text="人和货都已抵达。匿名护卫在此交岗，正式伙伴的邀请继续保留。",Image="",List=[],Options=[{Text="领取约定报酬",function getResult(){local c=this.Contract;if(!c.m.Flags.get("AfeiFinished")){c.m.Flags.set("AfeiFinished",true);this.World.Assets.addMoney(c.m.Payment.getOnCompletion());this.World.Contracts.finishActiveContract(false);}
return 0;}
}],function start(){}
});
   this.m.Screens.push({ID="Failure",Title="重新整备",Text="这次护送没有完成。按普通契约结算损失，对应邀请七日后可以重接。",Image="",List=[],Options=[{Text="记录结果",function getResult(){local c=this.Contract;if(!c.m.Flags.get("AfeiFinished")){c.m.Flags.set("AfeiFinished",true);c.cancel();this.World.Contracts.finishActiveContract(true);}
return 0;}
}],function start(){}
});
 },
 function onClear() {this.escort_caravan_contract.onClear();if(this.m.Caravan!=null && !this.m.Caravan.isNull() && this.m.Caravan.isAlive())this.m.Caravan.die();}
});
