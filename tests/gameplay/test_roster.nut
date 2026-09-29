// Run from repository root with the Squirrel 3 VM. No game files are modified.
// Real core/quest/roster code runs against a small fake world; this is not an
// in-engine test of inventory serialization, combat or background appearance.
::Const <- {
    Attributes = { COUNT=8, Hitpoints=0, Fatigue=1, Bravery=2, Initiative=3, MeleeSkill=4, RangedSkill=5, MeleeDefense=6, RangedDefense=7 },
    LevelXP = [0], XP = { MaxLevelWithPerkpoints=11 }
};
::Time <- { getVirtualTimeF=function() { return 1.0; } };
::logError <- function(_text) {};
::testState <- { origin=true, tactical=false, combatStart=0, town=true, allied=true, camping=false, threats=[], failItem=false, serial=0, formationCalls=0 };
getroottable()["new"] <- function(_path) {
    if (::testState.failItem) throw "injected item construction failure";
    return { path=_path };
};

function makeFlags() {
    return {
        values={},
        has=function(k) { return k in this.values; },
        get=function(k) { return this.values[k]; },
        set=function(k,v) { this.values[k] <- v; }
    };
}
function makeBrother() {
    local flags=makeFlags();
    local properties={ Hitpoints=0, Stamina=0, Bravery=0, Initiative=0, MeleeSkill=0, RangedSkill=0, MeleeDefense=0, RangedDefense=0 };
    local talents=[];
    local background={ m={ RawDescription="", DailyCost=0, DailyCostMult=1.0 }, rendered="", buildDescription=function(final){this.rendered=this.m.RawDescription;} };
    local items={
        equipped=[], bag=[],
        clear=function() { this.equipped=[]; this.bag=[]; },
        equip=function(item) { this.equipped.push(item); },
        addToBag=function(item) { this.bag.push(item); }
    };
    return {
        id=++::testState.serial, m={ Level=1, XP=0, LevelUps=0, PerkPoints=0, PerkPointsSpent=0, HireTime=0 }, name="", title="", place=255, hitpoints=0,
        getID=function() { return this.id; },
        getFlags=function() { return flags; },
        getBaseProperties=function() { return properties; },
        getTalents=function() { return talents; },
        getBackground=function() { return background; },
        getItems=function() { return items; },
        getSkills=function() { return {update=function(){}}; },
        getHitpointsMax=function() { return properties.Hitpoints; },
        getHitpoints=function() { return this.hitpoints; },
        getPlaceInFormation=function() { return this.place; },
        setHitpoints=function(n) { this.hitpoints=n; },
        fillAttributeLevelUpValues=function(n) {},
        setStartValuesEx=function(backgrounds, traits) {this.m.Level=2;this.m.PerkPoints=1;this.m.LevelUps=1;},
        setName=function(n) { this.name=n; },
        getName=function() { return this.name; },
        setTitle=function(n) { this.title=n; },
        setPlaceInFormation=function(n) { this.place=n; }
    };
}
::testRoster <- {
    brothers=[],
    create=function(path) { local bro=makeBrother(); this.brothers.push(bro); return bro; },
    remove=function(bro) { this.brothers.remove(this.brothers.find(bro)); },
    getAll=function() { return this.brothers; }
};
::testTown <- {
    isAlive=function() { return true; }, isMilitary=function() { return false; },
    isAlliedWithPlayer=function() { return ::testState.allied; },
    getTile=function() { return {getDistanceTo=function(tile){return 1;}}; }
};
::Tactical <- { isActive=function() { return ::testState.tactical; } };
::World <- {
    Flags=makeFlags(),
    getPlayerRoster=function() { return ::testRoster; },
    getAllEntitiesAtPos=function(pos,radius) { return ::testState.threats; },
    EntityManager={ getSettlements=function() { return ::testState.town ? [::testTown] : []; } },
    State={
        getPlayer=function() { return {getTile=function(){return {};},getPos=function(){return {};}}; },
        getCombatStartTime=function() { return ::testState.combatStart; },
        isCampingAllowed=function() { return true; }, updateTopbarAssets=function() {}
    },
    Assets={
        money=1000,
        getOrigin=function() { return {getID=function(){return ::testState.origin ? "scenario.afeix_expedition" : "scenario.early_access";}}; },
        getMoney=function() { return this.money; }, addMoney=function(n) { this.money+=n; },
        isCamping=function() { return ::testState.camping; }, updateFormation=function() {}
    }
};
::AfeixExpedition <- { RosterMax=40, CombatMax=12, Schema=2 };
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/characters.nut");
dofile("src/scripts/mods/afeix/quests.nut");
dofile("src/scripts/mods/afeix/roster.nut");
dofile("src/scripts/mods/afeix/encounters.nut");
::AfeixExpedition.enforceFormation <- function() { ::testState.formationCalls++; };
::AfeixExpedition.PaymentContext <- null;
// Simulate vanilla's ordering: backgrounds exist before the saved origin is
// restored by the world loader. Execute the real late-load hook around it.
::World.State.onKeyInput <- function(key) { return false; };
::World.State.onDeserialize <- function(savedOrigin) {
    foreach(bro in ::testRoster.brothers) {
        bro.getBackground().m.DailyCost=99;
        bro.getBackground().m.RawDescription="native background text";
    }
    ::testState.origin=savedOrigin;
    return "native-world-loaded";
};
::World.Assets.updateFormation = function() { ::testState.formationCalls++; };
::mods_hookExactClass <- function(path,callback) {
    if(path=="states/world_state") callback(::World.State);
};
::mods_hookNewObject <- function(path,callback) {};
::mods_hookBaseClass <- function(path,callback) {};
dofile("src/scripts/mods/afeix/hooks.nut");
::rosterTestsPassed <- 0;

function require(condition,name) {
    if (!condition) throw "FAIL " + name;
    ::rosterTestsPassed++;
    print("PASS " + name + "\n");
}
function reset() {
    ::testRoster.brothers=[]; ::World.Flags.values={}; ::World.Assets.money=1000;
    ::testState.origin=true; ::testState.tactical=false; ::testState.combatStart=0;
    ::testState.town=true; ::testState.allied=true; ::testState.camping=false;
    ::testState.threats=[]; ::testState.failItem=false; ::testState.formationCalls=0;
}
function unlock() { local A=::AfeixExpedition; A.set("delivery_state",2); foreach(key in ["bottle","shuaizi"]) { A.set("met_"+key,true);A.set("encounter_done_"+key,true); } }
function runRosterChecks() {
    local A=::AfeixExpedition;
    A.isCharacterKnown <- function(key) { return key in this.Characters && (this.findCharacter(key)!=null || this.get("met_"+key,false) || this.get("ever_"+key,false) || this.get("encounter_done_"+key,false)); };
    A.isAtTavern <- function() { return this.canManage() && this.currentTown()!=null; };
    reset();
    require(!A.recruit("shuaizi").ok && ::testRoster.brothers.len()==0 && ::World.Assets.money==1000,"quest_locked_no_creation_or_payment");
    reset(); unlock(); ::World.Assets.money=199;
    require(!A.recruit("shuaizi").ok && ::testRoster.brothers.len()==0 && ::World.Assets.money==199,"insufficient_money_no_creation");
    reset(); unlock(); for(local i=0;i<A.RosterMax;i++) ::testRoster.brothers.push(makeBrother());
    require(!A.recruit("shuaizi").ok && ::testRoster.brothers.len()==40 && ::World.Assets.money==1000,"full_roster_no_creation_or_payment");
    reset(); unlock(); ::testState.tactical=true;
    require(!A.recruit("bottle").ok && ::testRoster.brothers.len()==0,"combat_blocks_recruitment");
    reset(); unlock(); ::testState.combatStart=1;
    require(!A.recruit("bottle").ok && ::testRoster.brothers.len()==0,"pending_battle_blocks_recruitment");
    reset(); unlock(); ::testState.town=false; ::testState.camping=true;
    require(A.canManage() && !A.recruit("bottle").ok && ::testRoster.brothers.len()==0,"camp_management_does_not_allow_town_recruitment");
    reset(); unlock(); ::testState.allied=false;
    require(!A.recruit("bottle").ok && ::testRoster.brothers.len()==0,"hostile_town_blocks_recruitment");
    reset(); unlock(); ::testState.origin=false;
    require(!A.recruit("bottle").ok && ::testRoster.brothers.len()==0,"other_origins_untouched");
    reset(); unlock();
    require(A.recruit("shuaizi").ok && ::World.Assets.money==800 && ::testRoster.brothers.len()==1,"successful_delivery_unlocked_recruit");
    require(A.characterStatus("shuaizi")=="recruited" && ::World.Flags.get("afeix_ever_shuaizi"),"persistent_unique_character_identity");
    require(::testState.formationCalls>0,"recruit_requests_formation_assignment");
    require(!A.recruit("shuaizi").ok && ::World.Assets.money==800 && ::testRoster.brothers.len()==1,"duplicate_click_does_not_charge_or_clone");
    local bro=A.findCharacter("shuaizi"), items=bro.getItems(); bro.m.XP=777;
    require(A.makeCharacter("shuaizi")==bro && bro.m.XP==777 && bro.getItems()==items,"existing_entity_preserves_experience_and_inventory");
    ::testRoster.remove(bro); A.set("dead_shuaizi",true);
    require(A.characterStatus("shuaizi")=="dead" && !A.recruit("shuaizi").ok && ::testRoster.brothers.len()==0,"dead_character_never_respawns");
    reset(); unlock(); A.set("paid_contracts",1);
    require(A.recruit("bottle").ok && ::World.Assets.money==780,"paid_contract_backup_unlocks_bottle");
    ::testRoster.brothers=[];
    require(A.characterStatus("bottle")=="departed" && !A.recruit("bottle").ok,"dismissed_character_never_respawns");
    reset(); unlock(); ::testState.failItem=true;
    require(!A.recruit("bottle").ok && ::testRoster.brothers.len()==0 && ::World.Assets.money==1000 && !A.get("ever_bottle",false),"failed_creation_rolls_back_without_charge");
    reset();
    local afei=A.makeCharacter("afei",3), damou=A.makeCharacter("damou",4), mocha=A.makeCharacter("mocha",12);
    require(::testRoster.brothers.len()==3 && afei.place==3 && damou.place==4 && mocha.place==12,"only_three_captains_start");
    require(damou.getBaseProperties().MeleeSkill>afei.getBaseProperties().MeleeSkill && damou.getBaseProperties().MeleeDefense>afei.getBaseProperties().MeleeDefense,"damou_starts_stronger_than_afei");
    require(A.characterStatus("shuaizi")=="locked" && A.characterStatus("bottle")=="locked","female_recruits_are_not_initial_captains");

    local ordinary=makeBrother(); ::testRoster.brothers.push(ordinary);
    afei.m.XP=777; afei.m.Level=4; afei.hitpoints=23; afei.place=18;
    afei.getBackground().m.DailyCostMult=0.75;
    local originalItems=afei.getItems(), beforeFormation=::testState.formationCalls;
    ::testState.origin=false; A.PaymentContext=123;
    require(::World.State.onDeserialize(true)=="native-world-loaded","world_load_preserves_native_return");
    require(afei.getBackground().m.DailyCost==8 && damou.getBackground().m.DailyCost==15 && mocha.getBackground().m.DailyCost==10,"late_load_restores_named_base_wages_after_origin_available");
    require(afei.getBackground().m.RawDescription==A.Characters.afei.description && afei.getBackground().rendered==A.Characters.afei.description,"late_load_refreshes_visible_description");
    require(afei.getBackground().m.DailyCostMult==0.75,"saved_wage_discount_is_preserved");
    require(afei.m.XP==777 && afei.m.Level==4 && afei.hitpoints==23 && afei.place==18 && afei.getItems()==originalItems,"metadata_restore_preserves_progress_damage_reserve_and_equipment");
    require(ordinary.getBackground().m.DailyCost==99 && ordinary.getBackground().m.RawDescription=="native background text","ordinary_mercenary_metadata_untouched");
    require(::testState.formationCalls==beforeFormation+1 && A.PaymentContext==null,"late_load_normalizes_formation_and_clears_transient_contract_context");
    beforeFormation=::testState.formationCalls;
    ::World.State.onDeserialize(false);
    require(afei.getBackground().m.DailyCost==99 && ::testState.formationCalls==beforeFormation,"loading_another_origin_does_not_apply_named_metadata_or_formation");
    // Run the entire staged roster against actual data and actual recruitment
    // functions. UI has its own tests; this checks money and saved state here.
    reset();
    require(A.CharacterOrder.len()==34 && A.Characters.len()==34,"exactly_thirty_four_unique_theme_characters");
    require(A.CharacterOrder.find("yanzi")!=null && A.Characters.yanzi.name=="眼子" && A.Characters.yanzi.aliases.find("刘佳俊")!=null,"yanzi_returns_with_confirmed_name_and_alias");
    local secondChapterCount=0;
    foreach(key in A.CharacterOrder) if(A.Characters[key].chapter==2) secondChapterCount++;
    require(secondChapterCount==8,"second_chapter_has_eight_active_members");
    foreach(key in ["afei","damou","mocha"]) A.makeCharacter(key);
    local hired=3;
    foreach(chapter in A.Chapters) {
        A.set("paid_contracts",chapter.required);
        ::World.Assets.money=100000;
        foreach(key in A.CharacterOrder) {
            local data=A.Characters[key];
            if(data.isCaptain || data.chapter!=chapter.id)continue;
            require(A.characterStatus(key)=="locked","unmet_name_stays_hidden_"+key);
            A.set("met_"+key,true);
            require(A.characterStatus(key)=="encounter","tavern_meeting_reveals_"+key);
            if(A.characterStatus(key)=="encounter") {
                local before=::World.Assets.money;
                require(!A.recruit(key).ok && ::World.Assets.money==before,"cannot_skip_personal_encounter_"+key);
                local chosen=hired%2, choice=data.encounterChoices[chosen];
                require(A.resolveEncounter(key,chosen).ok && ::World.Assets.money==before-choice.cost,"encounter_charges_exactly_once_"+key);
                require(A.get("encounter_choice_"+key)==chosen && A.get("encounter_done_"+key,false),"choice_is_durable_"+key);
                require(A.recruitPrice(key)==data.hireCost-choice.hireDiscount,"quoted_discount_matches_choice_"+key);
                before=::World.Assets.money;
                require(!A.resolveEncounter(key,1-chosen).ok && ::World.Assets.money==before,"cannot_replay_or_switch_resolved_choice_"+key);
                dofile("src/scripts/mods/afeix/encounters.nut");
                require(A.characterStatus(key)=="available" && A.recruitPrice(key)==data.hireCost-choice.hireDiscount,"reloading_logic_keeps_invitation_and_discount_"+key);
            }
            local price=A.recruitPrice(key), before=::World.Assets.money;
            require(A.recruit(key).ok && ::World.Assets.money==before-price,"each_person_can_be_hired_"+key);
            hired++;
            local member=A.findCharacter(key);
            require(member!=null && member.name==data.name && member.getFlags().get("afeix_character")==key,"correct_entity_identity_"+key);
            require(member.getItems().equipped.len()==data.equipment.len() && member.getItems().bag.len()==data.bag.len(),"individual_loadout_applied_"+key);
            require(!A.recruit(key).ok && ::World.Assets.money==before-price && ::testRoster.brothers.len()==hired,"repeat_invitation_neither_clones_nor_charges_"+key);
        }
    }
    require(hired==34 && ::testRoster.brothers.len()==34,"all_named_members_can_coexist");
    // Ordinary hires can fill the six remaining places without erasing names.
    for(local i=0;i<6;i++)::testRoster.brothers.push(makeBrother());
    require(::testRoster.brothers.len()==A.RosterMax,"forty_roster_places_include_ordinary_mercenaries");

    // Failure cases keep the new per-person invitation state and money intact.
    reset(); A.set("paid_contracts",12);
    local key="yangmiemie", choices=A.Characters[key].encounterChoices; A.set("met_"+key,true);
    local paidChoice=choices[0].cost>0 ? 0 : 1;
    ::World.Assets.money=choices[paidChoice].cost-1;
    local beforeMoney=::World.Assets.money;
    require(!A.resolveEncounter(key,paidChoice).ok && ::World.Assets.money==beforeMoney && !A.get("encounter_done_"+key,false),"insufficient_encounter_money_keeps_story_pending");
    ::World.Assets.money=10000;
    require(!A.resolveEncounter(key,-1).ok && !A.resolveEncounter(key,2).ok && !A.resolveEncounter(key,"1").ok,"invalid_story_options_are_atomic_rejection");
    require(!A.resolveEncounter("afei",0).ok && !A.resolveEncounter("missing",0).ok,"captain_or_unknown_has_no_recruitable_encounter");
    ::testState.tactical=true;
    require(!A.resolveEncounter(key,0).ok,"battle_blocks_story_mutation"); ::testState.tactical=false;
    ::testState.town=false; ::testState.camping=true;
    require(!A.resolveEncounter(key,0).ok,"camp_does_not_substitute_for_town_meeting"); ::testState.town=true;
    ::testState.origin=false;
    require(!A.resolveEncounter(key,0).ok,"other_origin_cannot_resolve_story"); ::testState.origin=true;
    A.set("met_"+key,false);
    require(!A.resolveEncounter(key,0).ok && A.characterStatus(key)=="locked","must_meet_before_conversation"); A.set("met_"+key,true);
    require(A.resolveEncounter(key,paidChoice).ok,"unlocked_story_remains_available_after_failures");
    local discountPrice=A.recruitPrice(key);
    ::World.Assets.money=discountPrice-1;
    require(!A.recruit(key).ok && A.characterStatus(key)=="available" && A.recruitPrice(key)==discountPrice,"insufficient_hire_money_keeps_resolved_discount");
    ::World.Assets.money=10000; ::testState.failItem=true;
    require(!A.recruit(key).ok && ::World.Assets.money==10000 && ::testRoster.brothers.len()==0 && A.characterStatus(key)=="available","failed_equipment_creation_preserves_invitation_without_charge");
    ::testState.failItem=false;
    for(local i=0;i<A.RosterMax;i++)::testRoster.brothers.push(makeBrother());
    require(!A.recruit(key).ok && ::World.Assets.money==10000 && A.recruitPrice(key)==discountPrice,"full_roster_keeps_discount_and_money");
    ::testRoster.brothers.pop();
    require(A.recruit(key).ok && ::World.Assets.money==10000-discountPrice,"freeing_one_place_allows_pending_hire");
    local lost=A.findCharacter(key); ::testRoster.remove(lost); A.set("dead_"+key,true);
    require(A.characterStatus(key)=="dead" && !A.resolveEncounter(key,0).ok && !A.recruit(key).ok,"new_member_death_does_not_reopen_story_or_duplicate");

    // Upgrade v0.1: existing actors and first invitations survive even if no new
    // chapter count/encounter flags exist. No forced rehire or stat reset.
    reset(); A.set("delivery_state",2);
    local oldBottle=A.makeCharacter("bottle"), oldItems=oldBottle.getItems();
    oldBottle.m.XP=1234; oldBottle.m.Level=5; oldBottle.hitpoints=17;
    oldBottle.getBackground().m.DailyCostMult=0.8;
    A.migrateProgress();
    require(A.progressCount()==1 && A.characterStatus("bottle")=="recruited" && A.characterStatus("shuaizi")=="locked","upgrade_preserves_members_without_revealing_unmet_names");
    require(A.findCharacter("bottle")==oldBottle && oldBottle.m.XP==1234 && oldBottle.m.Level==5 && oldBottle.hitpoints==17 && oldBottle.getItems()==oldItems && oldBottle.getBackground().m.DailyCostMult==0.8,"progress_migration_does_not_recreate_or_reset_existing_actor");
    require(A.characterStatus("lili")=="locked" && A.characterStatus("laocai")=="locked","old_work_count_does_not_discover_whole_groups");

    // Returning a retired member preserves the real saved actor and equipment.
    reset(); A.set("paid_contracts",12);
    require(!("yanzi" in A.RetiredCharacters) && A.Characters.yanzi.wage==12,"restored_member_keeps_original_yanzi_base_wage");
    local retired=::testRoster.create("scripts/entity/tactical/player");
    retired.getFlags().set("afeix_character","yanzi");
    retired.getFlags().set("afeix_schema",2);
    retired.setName("眼子（旧存档改名）"); retired.setTitle("原有头衔");
    retired.m.Level=9; retired.m.XP=4321; retired.m.LevelUps=2; retired.m.HireTime=27.0;
    retired.hitpoints=19; retired.place=32;
    retired.getBaseProperties().Hitpoints=71;
    retired.getBaseProperties().MeleeSkill=73;
    retired.getTalents().resize(8,1);
    retired.getBackground().m.DailyCostMult=0.75;
    local savedWeapon={path="saved_sword"}, savedBag={path="saved_polearm"};
    retired.getItems().equip(savedWeapon); retired.getItems().addToBag(savedBag);
    A.set("ever_yanzi",true); A.set("encounter_done_yanzi",true); A.set("hire_discount_yanzi",90);
    local retiredItems=retired.getItems(), retiredId=retired.getID(), retiredMoney=::World.Assets.money;
    require(A.characterId(retired)=="yanzi" && A.findCharacter("yanzi")==retired,"retired_actor_remains_findable_by_persistent_identity");
    ::testState.origin=false;
    require(::World.State.onDeserialize(true)=="native-world-loaded","retired_actor_uses_the_normal_late_load_path");
    require(::testRoster.brothers.len()==1 && A.findCharacter("yanzi")==retired && retired.getID()==retiredId,"loading_retired_actor_preserves_same_entity_without_a_clone");
    require(retired.getBackground().m.DailyCost==12 && retired.getBackground().m.DailyCostMult==0.75,"retired_wage_restores_base_without_resetting_saved_multiplier");
    require(retired.getBackground().m.RawDescription==A.Characters.yanzi.description && retired.getBackground().rendered==A.Characters.yanzi.description,"returning_member_receives_current_description");
    require(retired.name=="眼子（旧存档改名）" && retired.title=="原有头衔" && retired.m.Level==9 && retired.m.XP==4321 && retired.m.LevelUps==2 && retired.m.HireTime==27.0,"retired_actor_preserves_name_title_and_growth");
    require(retired.hitpoints==19 && retired.place==32 && retired.getBaseProperties().Hitpoints==71 && retired.getBaseProperties().MeleeSkill==73 && retired.getTalents()[0]==1,"retired_actor_preserves_health_reserve_slot_attributes_and_talents");
    require(retired.getItems()==retiredItems && retiredItems.equipped.len()==1 && retiredItems.equipped[0]==savedWeapon && retiredItems.bag.len()==1 && retiredItems.bag[0]==savedBag,"retired_actor_preserves_equipped_and_bag_item_objects");
    require(A.characterStatus("yanzi")=="recruited","returning_actor_is_recognized_as_recruited");
    require(A.makeCharacter("yanzi")==retired && !A.recruit("yanzi").ok && !A.resolveEncounter("yanzi",0).ok && ::World.Assets.money==retiredMoney && ::testRoster.brothers.len()==1,"returning_member_neither_duplicated_nor_charged");
    retired.setName("眼子");::World.State.onDeserialize(true);
    require(retired.name=="眼子" && retired.getBaseProperties().Hitpoints==71,"old_default_name_updates_without_resetting_stats");
    ::testRoster.remove(retired); A.set("dead_yanzi",true);
    require(A.findCharacter("yanzi")==null && A.makeCharacter("yanzi")==null && !A.recruit("yanzi").ok,"retired_deceased_actor_is_not_recreated");
    ::World.Flags.values={};
    A.set("departed_yanzi",true);
    require(A.characterStatus("yanzi")=="departed" && A.makeCharacter("yanzi")==null,"returning_member_does_not_revive_a_departed_actor");
    ::World.Flags.values={};
    require(A.characterStatus("yanzi")=="locked" && !A.recruit("yanzi").ok && !A.resolveEncounter("yanzi",0).ok,"new_campaign_still_requires_discovery_before_recruitment");
    ::testRoster.brothers=[];::World.Flags.values={};::testState.origin=true;
    local corrected=A.makeCharacter("xiaohani");
    require(corrected.name=="罗一可","blue_team_slot_recruits_luoyike");
    corrected.setName("小哈尼");corrected.m.Level=7;corrected.m.XP=1234;
    A.set("growth_xiaohani",1);
    ::World.State.onDeserialize(true);
    require(corrected.name=="罗一可" && A.findCharacter("xiaohani")==corrected,"old_default_name_corrected_on_world_load_without_replacing_actor");
    require(corrected.m.Level==7 && corrected.m.XP==1234 && A.get("growth_xiaohani",0)==1,"roster_correction_preserves_progress");
    corrected.setName("自定义伙伴名");
    ::World.State.onDeserialize(true);
    require(corrected.name=="自定义伙伴名","roster_correction_preserves_player_chosen_name");
    ::testRoster.brothers=[];::World.Flags.values={};
    local balanced=A.makeCharacter("damou");
    require(balanced.m.Level==1 && balanced.m.PerkPoints==0 && balanced.m.PerkPointsSpent==0 && balanced.m.LevelUps==0,"background_level_two_cannot_leave_a_free_perk");
    local bp=balanced.getBaseProperties();
    require(bp.MeleeSkill==55 && bp.MeleeDefense==4 && bp.Hitpoints==55,"new_damou_reduced_start");
    A.restoreCharacterMetadata(balanced);require(bp.MeleeSkill==55,"new_damou_not_deducted_twice");
    delete balanced.getFlags().values.afeix_damou_balance_v17;
    delete balanced.getFlags().values.afeix_balance_v18;
    bp.Hitpoints=72;bp.Stamina=112;bp.Bravery=55;bp.Initiative=110;bp.MeleeSkill=76;bp.RangedSkill=39;bp.MeleeDefense=18;bp.RangedDefense=7;
    balanced.m.Level=5;balanced.m.XP=500;balanced.m.PerkPoints=2;balanced.m.PerkPointsSpent=3;
    balanced.hitpoints=72;
    A.restoreCharacterMetadata(balanced);A.restoreCharacterMetadata(balanced);
    require(bp.Hitpoints==65 && bp.Stamina==102 && bp.Bravery==47 && bp.Initiative==102 && bp.MeleeSkill==65 && bp.RangedSkill==35 && bp.MeleeDefense==12 && bp.RangedDefense==4,"legacy_damou_crosses_both_balance_revisions_once");
    require(balanced.hitpoints==65,"reduced_max_health_clamps_current_health");
    require(balanced.m.Level==5 && balanced.m.XP==500 && balanced.m.PerkPoints==2 && balanced.m.PerkPointsSpent==3,"legacy_growth_and_spent_perks_preserved");
    // v0.17 saves and new v0.18 hires, including a persisted town candidate.
    local fields=["Hitpoints","Stamina","Bravery","Initiative","MeleeSkill","RangedSkill","MeleeDefense","RangedDefense"];
    local earned=[9,12,6,8,18,7,10,5];
    foreach(key in A.CharacterOrder) {
        reset();local b=A.makeCharacter(key), p=b.getBaseProperties(), d=A.Characters[key];
        A.restoreCharacterMetadata(b);
        foreach(i,field in fields)require(p[field]==d.attrs[i],"new_hire_keeps_new_base_"+key+"_"+field);
        delete b.getFlags().values.afeix_balance_v18;
        local baseline=key in A.CharacterBasesV17 ? A.CharacterBasesV17[key] : d.attrs;
        foreach(i,field in fields)p[field]=baseline[i]+earned[i];
        b.hitpoints=19;b.m.Level=8;b.m.XP=2345;b.m.PerkPoints=2;b.m.PerkPointsSpent=5;
        if(key=="songnuanyang")b.getFlags().set("afeix_candidate",true);
        local items=b.getItems(),talents=b.getTalents();
        A.restoreCharacterMetadata(b);A.restoreCharacterMetadata(b);
        foreach(i,field in fields)require(p[field]==d.attrs[i]+earned[i],"earned_attributes_preserved_after_repeated_load_"+key+"_"+field);
        require(b.hitpoints==19&&b.m.Level==8&&b.m.XP==2345&&b.m.PerkPoints==2&&b.m.PerkPointsSpent==5&&b.getItems()==items&&b.getTalents()==talents,"migration_preserves_progress_and_never_heals_"+key);
        require(b.getFlags().get("afeix_balance_v18"),"migration_marked_"+key);
    }
    print("ALL_ROSTER_BEHAVIOR_CHECKS_PASS\n");
    print("TESTS_PASSED=" + ::rosterTestsPassed + "\n");
}
try { runRosterChecks(); }
catch(error) { print(error+"\n"); if("exit" in getroottable()) exit(1); throw error; }
