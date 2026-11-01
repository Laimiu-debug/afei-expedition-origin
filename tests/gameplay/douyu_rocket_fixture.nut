// Explicit engine-event queues: combat tests can drain them, timing tests can
// hold the camera or landing callback to probe cancellation and hit ordering.
::rocketFixture <- {now=0,cameras=[],timers=[],particles=[],impacts=[],quakes=0};
::TimeUnit <- {Virtual=1,Real=2};
::createColor <- function(value){return value;};
if (!("State" in ::Tactical)) ::Tactical.State <- {};
::Time.scheduleEvent <- function(unit,delay,callback,tag){
    ::rocketFixture.timers.push({unit=unit,due=::rocketFixture.now+delay,callback=callback,tag=tag});
};
::Tactical.CameraDirector <- {addMoveToTileEvent=function(delay,tile,speed,callback,tag){
    ::rocketFixture.cameras.push({tile=tile,callback=callback,tag=tag});
}};
::Tactical.spawnParticleEffect <- function(world,brushes,tile,delay,quantity,total,rate,stages,offset=null){
    ::rocketFixture.particles.push({brushes=brushes,tile=tile,quantity=quantity,total=total,stages=stages,at=::rocketFixture.now});
};
::Tactical.getCamera <- function(){return {quake=function(...){::rocketFixture.quakes++;}};};
::AfeixExpedition.feedbackParticles=function(tile,name,scale){::rocketFixture.impacts.push({tile=tile,kind=name,at=::rocketFixture.now});};
::AfeixExpedition.feedbackImpactSound=function(tile){::rocketFixture.impacts.push({tile=tile,kind="sound",at=::rocketFixture.now});};
function focusRocket(){
    while(::rocketFixture.cameras.len()>0){local e=::rocketFixture.cameras.remove(0);e.callback(e.tag);}
}
function advanceRocket(ms){
    ::rocketFixture.now+=ms;
    local again=true;
    while(again){again=false;
        foreach(i,e in ::rocketFixture.timers)if(e.due<=::rocketFixture.now){
            ::rocketFixture.timers.remove(i);e.callback(e.tag);again=true;break;
        }
    }
}
function finishRocket(){focusRocket();advanceRocket(::AfeixExpedition.Douyu.RocketFlightMS);}
function resetRocketFixture(){
    ::AfeixExpedition.Douyu.cancelRocketFlights(::Tactical.State);
    ::rocketFixture.now=0;::rocketFixture.cameras=[];::rocketFixture.timers=[];
    ::rocketFixture.particles=[];::rocketFixture.impacts=[];::rocketFixture.quakes=0;
}
