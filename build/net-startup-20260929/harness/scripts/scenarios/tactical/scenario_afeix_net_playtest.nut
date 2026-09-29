this.scenario_afeix_net_playtest <- this.inherit("scripts/scenarios/tactical/scenario_template", {
    m={AfeixNetTest=true,Thrower=null,Victim=null,Enemy=null,Stage=0},
    function generate(){
        ::AfeixExpedition.NetTestFlags={};
        this.createStash();local map=this.MapGen.get("tactical.combat_basics");
        this.Tactical.resizeScene(map.getMinX(),map.getMinY());map.fill({X=0,Y=0,W=map.getMinX(),H=map.getMinY()},null);
        for(local x=10;x<=20;x++)for(local y=10;y<=20;y++){local t=this.Tactical.getTileSquare(x,y);t.removeObject();t.Level=0;}
        this.Stash.clear();this.Stash.resize(63);this.Stash.setLocked(true);
        this.m.Thrower=this.ally("afei",12,14,1000,200);
        this.m.Victim=this.ally("damou",14,14,1,100);
        this.ally("mocha",12,18,1000,90);
        local e=this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider",15,14-15/2);
        e.setFaction(this.Const.Faction.Bandits);e.setName("NETTED HEADSHOT TEST ENEMY");e.getItems().clear();
        e.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
        local p=e.getBaseProperties();p.Hitpoints=1000;p.Stamina=500;p.MeleeSkill=200;p.Bravery=150;p.Initiative=1;
        p.HitChance[this.Const.BodyPart.Head]=100;p.HitChance[this.Const.BodyPart.Body]=0;
        e.getSkills().update();e.setHitpoints(e.getHitpointsMax());this.m.Enemy=e;
        this.m.Thrower.getItems().equip(this.new("scripts/items/tools/throwing_net"));
        this.Tactical.CameraDirector.addMoveToTileEvent(0,this.m.Victim.getTile(),0,null,null,0,0);
        ::logInfo("AFEIX_NET_TEST READY F7; thrower="+this.m.Thrower.getID()+" victim="+this.m.Victim.getID()+" enemy="+e.getID());
    },
    function ally(key,x,y,hp,initiative){
        local b=this.Tactical.spawnEntity("scripts/entity/tactical/player",x,y-x/2);
        this.World.getPlayerRoster().add(b);b.setFaction(this.Const.Faction.Player);b.setScenarioValues();b.setName("TEST "+key);
        b.getItems().clear();b.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
        b.getFlags().set("afeix_character",key);
        local p=b.getBaseProperties();p.Hitpoints=hp;p.Stamina=500;p.Bravery=150;p.Initiative=initiative;p.MeleeDefense=0;
        b.getSkills().update();b.setHitpoints(hp);::AfeixExpedition.syncCharacterArt(b);return b;
    },
    function runTest(nativeVictim=false){
        if(nativeVictim){::AfeixExpedition.suspendCharacterArt(this.m.Victim);this.m.Victim.getFlags().set("afeix_character", "native_control");::logInfo("AFEIX_NET_TEST NATIVE_CONTROL");}
        if(this.m.Stage!=0)return;this.m.Stage=1;
        local e=this.m.Enemy,u=this.m.Thrower;
        ::logInfo("AFEIX_NET_TEST THROW_BEGIN");u.setActionPoints(9);u.setFatigue(0);
        local r=u.getSkills().getSkillByID("actives.throw_net").use(e.getTile());
        ::logInfo("AFEIX_NET_TEST THROW_END result="+r+" rooted="+e.getCurrentProperties().IsRooted);
        this.Time.scheduleEvent(this.TimeUnit.Virtual,1000,function(s){s.failedEscape();},this);
    },
    function failedEscape(){
        local e=this.m.Enemy;e.setActionPoints(9);e.setFatigue(0);
        local skill=e.getSkills().getSkillByID("actives.break_free");skill.setSkillBonus(0);
        ::logInfo("AFEIX_NET_TEST ESCAPE_BEGIN");local result=skill.use(e.getTile());
        ::logInfo("AFEIX_NET_TEST ESCAPE_END result="+result+" rooted="+e.getCurrentProperties().IsRooted);
        this.Time.scheduleEvent(this.TimeUnit.Virtual,1000,function(s){s.headshot();},this);
    },
    function headshot(){
        local e=this.m.Enemy,v=this.m.Victim;e.setActionPoints(9);e.setFatigue(0);
        local s=e.getSkills().getSkillByID("actives.slash");s.m.ChanceDecapitate=100;
        ::logInfo("AFEIX_NET_TEST ATTACK_BEGIN rooted="+e.getCurrentProperties().IsRooted+" victim_hp="+v.getHitpoints());
        local result=s.use(v.getTile());
        ::logInfo("AFEIX_NET_TEST ATTACK_END result="+result+" victim_alive="+v.isAlive());
        this.Time.scheduleEvent(this.TimeUnit.Virtual,1500,function(s){
            ::logInfo("AFEIX_NET_TEST POST_ATTACK alive="+s.m.Victim.isAlive()+" dying="+s.m.Victim.isDying()+" combat_active="+::Tactical.isActive());
            ::Tactical.TurnSequenceBar.onNextTurnButtonPressed();
            ::logInfo("AFEIX_NET_TEST NEXT_TURN_REQUESTED");
        },this);
    }
});
