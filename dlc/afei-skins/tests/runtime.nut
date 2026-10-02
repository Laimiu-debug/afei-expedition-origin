// Appended inside the unmodified base appearance fixture's try scope.
// Its native-dispatch actor, sprites and death callbacks exercise the real helpers.
{
    currentOrigin = true;
    ::Math <- {min=function(a,b){return a<b?a:b;},max=function(a,b){return a>b?a:b;}};
    // Restore the base art callback after its final company-helmet test.
    dofile("src/scripts/mods/afeix/art_hooks.nut");
    dofile("src/scripts/mods/afeix/world_art.nut");
    dofile("src/scripts/mods/afeix/ledger.nut");
    dofile("src/scripts/mods/afeix/story_ledger.nut");
    ::mods_hookNewObject <- function(path, callback) {};
    dofile("src/scripts/mods/afeix/banner_hooks.nut");
    A.trainingLedgerPage <- function(event,page){return null;};
    A.treatmentLedgerPage <- function(event,page){return null;};
    local saved = {}, writes = 0, fighting = false, combatStart = 0, camping = false;
    local party = {body={brush="native_world",setBrush=function(v){this.brush=v;}},
        hasSprite=function(v){return v=="body";},getSprite=function(v){return this.body;},
        setMirrored=function(v){this.mirrored<-v;}};
    local state = {onDeserialize=function(input){return "world_loaded";},
        getPlayer=function(){return party;},getCombatStartTime=function(){return combatStart;}};
    ::World = {Flags={has=function(k){return k in saved;},get=function(k){return saved[k];},
        set=function(k,v){saved[k]<-v;writes++;}},State=state,Assets={isCamping=function(){return camping;}}};
    ::Tactical.isActive = function(){return fighting;};
    local roster = [];
    A.roster = function(){return roster;};
    local nativeGet = A.get;
    A.get = function(k, fallback=0){return fallback;};
    local beforeCharacter = A.characterPortraitBrush, beforeLedger = A.ledgerPage, beforeBanner = A.bannerLedgerPage;
    dofile("dlc/afei-skins/src/scripts/mods/afeix_dlc_afei_skins/content.nut");
    dofile("dlc/afei-skins/src/scripts/mods/afeix_dlc_afei_skins/hooks.nut");
    local D = ::AfeixSkinsDLC;
    foreach (style in D.Styles) if (style.brush != null) {
        foreach (suffix in ["", "_head", "_dead", "_corpse_head", "_world",
            "_corpse_head_bloodied", "_corpse_head_injured_01", "_corpse_head_injured_02"])
            ::artAvailableBrushes[style.brush+suffix] <- true;
    }
    ::artAvailableBrushes.afeix_world_afei <- true;
    local afei = makeBrother("afei"), other = makeBrother("keke");
    roster = [afei, other];
    afei.onInit(); other.onInit();
    check(writes==0 && D.selected().key=="native", "install leaves existing campaigns unchanged");
    local items = afei.getItems(), initialStats = [afei.m.XP,afei.m.Level,afei.m.Hitpoints,items.armorPoints];
    local reached = [], page = D.Page+":0", event = {m={Notice=""}};
    for (local i=0;i<3;i++) {
        local screen=A.ledgerPage(event,page);
        check(screen.Options.len()<=6, "DLC pagination fits six native buttons");
        check(screen.Text.find("event_80.png")==null && screen.Text.find("按 Esc")!=null,
            "DLC has one own preview and inherits base Escape hint");
        local count=i<2?3:1;
        for(local j=0;j<count;j++) {
            local option=screen.Options[j];
            check(option.getResult(event)==page, "click stays on current skin page");
            reached.push(D.selected().key);
        }
        page=screen.Options[count].getResult(event);
    }
    local cg=A.ledgerPage(event,D.Page+":cg");
    check(cg.Text.find("afeix_dlc_skins_huxueer_defeat.png")!=null && cg.Text.find("event_80.png")==null,
        "gallery displays only its own CG");
    check(cg.Options.len()==2 && cg.Options[0].getResult(event)==D.Page+":6", "gallery returns to last skin page");
    check(reached.len()==7 && page==D.Page+":0", "all skins and original reached through UI pagination");
    local invalidPage=A.ledgerPage(event,D.Page+":999");
    check(invalidPage.Options.len()==6, "invalid offset safely returns first page");
    local company=A.ledgerPage(event,"company"), entryCount=0;
    check(company.Options.len()==6, "company retains its five original options plus DLC");
    foreach(option in company.Options) if(option.Text=="阿飞外观")entryCount++;
    check(entryCount==1 && company.Options.top().getResult(event)=="home", "company entry unique and back action preserved");
    check(A.ledgerPage(event,"unknown").Options.len()==1, "unrelated ledger page still uses base fallback");
    foreach(style in D.Styles) {
        check(D.choose(style.key).ok, "style selectable: "+style.key);
        local brush=style.brush==null?"afeix_p04_afei_normal":style.brush;
        check(afei.sprites.body.brush==brush && afei.sprites.head.brush==brush+"_head", "body/head update immediately: "+style.key);
        check(other.sprites.body.brush=="afeix_p04_keke", "other member unchanged: "+style.key);
        check(party.body.brush==(style.brush==null?"afeix_world_afei":brush+"_world"), "map avatar follows selected skin: "+style.key);
        foreach(route in ["normal","toad","jiahao","feidie"]) {
            currentRoute=route; A.syncCharacterArt(afei);
            check(afei.sprites.body.brush==brush, "profession does not override chosen cosmetic: "+route);
        }
        afei.onSerialize({}); afei.onDeserialize({});
        check(afei.sprites.body.brush==brush && D.selected().key==style.key, "native save/load retains skin: "+style.key);
        check(afei.m.XP==initialStats[0] && afei.m.Level==initialStats[1] && afei.m.Hitpoints==initialStats[2]
            && items.armorPoints==initialStats[3] && items==afei.getItems(), "cosmetic preserves gameplay/equipment: "+style.key);
        afei.itemState.getAppearance().HideHead=true; afei.m.IsHidingHelmet=false;A.syncCharacterArt(afei);
        check(!afei.sprites.head.Visible && afei.sprites.armor.Visible,"closed helmet and armor preserved: "+style.key);
        afei.m.IsHidingHelmet=true;A.syncCharacterArt(afei);
        check(afei.sprites.head.Visible,"hidden helmet reveals custom head: "+style.key);
        afei.itemState.getAppearance().HideHead=false;afei.m.IsHidingHelmet=false;
        if(style.brush==null)continue;
        local victim=makeBrother("afei"),tile=makeTile(); victim.onInit();
        check(victim.onDeath(null,null,tile,::Const.FatalityType.None)=="death_result", "native death returns normally: "+style.key);
        check(tile.Properties.get("Corpse").Custom.Body==brush, "corpse preserves skin identity: "+style.key);
        check(casualties.top().sprites.head.brush==brush+"_corpse_head_injured_02", "casualty uses wounded prone head: "+style.key);
        local resurrected=makeBrother("afei",true);
        check(resurrected.onResurrected(tile.Properties.get("Corpse"))=="revived_result", "resurrection preserves native return");
        D.choose("native");A.syncCharacterArt(resurrected);
        check(resurrected.sprites.body.brush==brush && resurrected.loadedItems==victim.getItems(), "raised corpse retains its death skin and gear");
        D.choose(style.key);
        local decap=makeBrother("afei"),decapTile=makeTile();decap.onInit();
        decap.itemState.getAppearance().HelmetCorpse="";
        decap.sprites.hair.resetBrush();decap.sprites.beard.resetBrush();
        check(decap.onDeath(null,null,decapTile,::Const.FatalityType.Decapitated)=="death_result"
            && decap.flyingHeads.len()>0, "helmetless decapitation retains native safe head effect: "+style.key);
    }
    check(!D.choose("bad-key").ok,"unknown choice rejected");
    local choice=D.selected().key,writeCount=writes;
    fighting=true;check(!D.choose("native").ok && writes==writeCount,"combat cannot change skin");fighting=false;
    combatStart=1;check(!D.choose("native").ok && writes==writeCount,"combat transition cannot change skin");combatStart=0;
    currentOrigin=false;check(!D.choose("native").ok && A.characterPortraitBrush(afei)==null,"other origins unchanged");currentOrigin=true;
    roster=[other];check(!D.choose("native").ok && writes==writeCount,"absent Afei cannot change preference");roster=[afei,other];
    afei.m.IsAlive=false;check(!D.choose("native").ok,"dead Afei cannot change preference");afei.m.IsAlive=true;
    D.choose("captain");
    ::artAvailableBrushes.afeix_dlc_skins_captain_head=false;
    check(D.selected().key=="native" && A.characterPortraitBrush(afei)=="afeix_p04_afei_normal", "incomplete art falls back to original");
    check(!D.choose("captain").ok,"incomplete art cannot be selected");
    ::artAvailableBrushes.afeix_dlc_skins_captain_head=true;
    saved[D.Flag]="obsolete";check(D.selected().key=="native","unknown saved skin falls back");
    saved[D.Flag]="huxueer";
    callbacks["states/world_state"](state);
    afei.sprites.body.brush="native_body";
    check(state.onDeserialize({})=="world_loaded" && afei.sprites.body.brush=="afeix_dlc_skins_huxueer", "world load reapplies after campaign flags restore");
    camping=true;A.syncWorldPartyArt();
    check(party.body.brush=="world_player_camp_01", "camp retains native tent");camping=false;A.syncWorldPartyArt();
    check(party.body.brush=="afeix_dlc_skins_huxueer_world", "breaking camp restores selected map skin");
    local oldWorld=::World;::World=null;
    check(D.selected().key=="native","early-loading null world safe");::World=oldWorld;
    // Simulate removal: untouched base helpers ignore the DLC preference.
    check(beforeCharacter.bindenv(A)(afei)=="afeix_p04_afei_normal", "base ignores optional preference after removal");
    check(beforeBanner.bindenv(A)(event,"company").Options.len()==5,"removal restores native company menu");
    print("DLC_SKINS_RUNTIME_CHECKS_PASS\n");
}
