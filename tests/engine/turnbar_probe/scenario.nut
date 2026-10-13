this.scenario_afeix_ghost_probe <- this.inherit("scripts/scenarios/tactical/scenario_template", {
    m={AfeixGhostProbe=true,NextTick=0.0,Ticks=0,Started=0.0,LastID=0,Done=false},
    function generate(){
        this.createStash();local map=this.MapGen.get("tactical.combat_basics");
        this.Tactical.resizeScene(map.getMinX(),map.getMinY());map.fill({X=0,Y=0,W=map.getMinX(),H=map.getMinY()},null);
        for(local x=9;x<=22;x++)for(local y=8;y<=23;y++){local t=this.Tactical.getTileSquare(x,y);t.removeObject();t.Level=0;}
        this.Stash.clear();this.Stash.resize(63);this.Stash.setLocked(true);
        for(local i=0;i<12;i++){
            local x=12+i%3,y=11+i/3;
            local b=this.Tactical.spawnEntity("scripts/entity/tactical/player",x,y-x/2);
            this.World.getPlayerRoster().add(b);b.setFaction(this.Const.Faction.Player);b.setScenarioValues();b.setName("GHOST PROBE "+i);
            b.getItems().clear();b.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
            local p=b.getBaseProperties();p.Hitpoints=1000;p.Stamina=500;p.Bravery=0;p.Initiative=20+i;p.MeleeDefense=100;
            b.getSkills().update();b.setHitpoints(1000);
        }
        for(local i=0;i<3;i++){
            local x=15,y=11+i;
            local g=this.Tactical.spawnEntity("scripts/entity/tactical/enemies/ghost",x,y-x/2);
            g.setFaction(this.Const.Faction.Undead);g.getBaseProperties().Initiative=200+i;g.getSkills().update();
        }
        this.m.Started=this.Time.getRealTimeF();
        ::logInfo("AFEIX_GHOST_PROBE READY native ghosts and twelve low-resolve players; automatic turn progression");
    },
    function tick(){
        if(this.m.Done)return;
        local now=this.Time.getRealTimeF();if(now<this.m.NextTick)return;this.m.NextTick=now+0.5;++this.m.Ticks;
        local bar=this.Tactical.TurnSequenceBar,actor=bar.getActiveEntity();
        if(this.m.Ticks%4==0){
            local state=this.Tactical.State;
            ::logInfo("AFEIX_GHOST_PROBE STATE t="+(now-this.m.Started)+" locked="+bar.m.IsLocked+" current="+bar.m.CurrentEntities.len()+" active="+(actor==null?0:actor.getID())+" paused="+state.m.IsGamePaused+" aiPaused="+state.m.IsAIPaused+" round="+bar.m.CurrentRound);
        }
        if(actor!=null&&!bar.m.IsLocked&&actor.isPlayerControlled()&&!actor.isDying()&&actor.getMoraleState()!=this.Const.MoraleState.Fleeing){
            ::logInfo("AFEIX_GHOST_PROBE END_PLAYER id="+actor.getID()+" morale="+actor.getMoraleState());
            bar.onNextTurnButtonPressed();
        }
        if(now-this.m.Started>45){this.m.Done=true;::logInfo("AFEIX_GHOST_PROBE COMPLETE");}
    }
});
