// Execute from repository root. Real hooks and accounting modules run against
// fake native dispatchers; no game, installation or persistent save is touched.
// Squirrel's acall reports an error before a surrounding catch handles it.
// Expected fault injection is silent here; the outer catch still prints the
// failure and exits, and only a complete run emits TESTS_PASSED.
seterrorhandler(function(error) {});
::contractTestState <- { origin=true, failFinish=false, keepActive=false, finishIncome=0, moneyFactor=1.0 };
::World <- {
    Flags={ values={}, has=function(k){return k in this.values;}, get=function(k){return this.values[k];}, set=function(k,v){this.values[k]<-v;} },
    State={},
    Assets={
        m={Money=0},
        getOrigin=function(){return {getID=function(){return ::contractTestState.origin ? "scenario.afeix_expedition" : "scenario.early_access";}};},
        getMoney=function(){return this.m.Money;},
        addMoney=function(amount){this.m.Money += amount > 0 ? amount * ::contractTestState.moneyFactor : amount; return "native-money";},
        updateFormation=function(considerMax=false){}, getFormation=function(){return [];}
    }
};
::AfeixExpedition <- {};
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/quests.nut");
dofile("src/scripts/mods/afeix/contracts.nut");
::testContractManager <- {
    m={Active=null},
    finishActiveContract=function(cancelled=false){
        if(this.m.Active==null)return "no-active";
        if(::contractTestState.failFinish)throw "injected finish failure";
        if(::contractTestState.finishIncome>0)::World.Assets.addMoney(::contractTestState.finishIncome);
        if(!::contractTestState.keepActive)this.m.Active=null;
        return "native-finish";
    }
};
::testContractBase <- {
    getID=function(){return this.id;},
    getPayment=function(){throw "advertised payment must never be consulted";},
    dispatch=function(method,args){
        if(!(method in this.actions))return "native-callback";
        local callArgs=[this];callArgs.extend(args);
        return this.actions[method].acall(callArgs);
    },
    processInput=function(option){return this.dispatch("processInput",[option]);},
    setScreen=function(screen,restart=true){return this.dispatch("setScreen",[screen,restart]);},
    setState=function(state){return this.dispatch("setState",[state]);},
    update=function(){return this.dispatch("update",[]);},
    onActorKilled=function(actor,killer,combat){return this.dispatch("onActorKilled",[actor,killer,combat]);},
    onActorRetreated=function(actor,combat){return this.dispatch("onActorRetreated",[actor,combat]);},
    onRetreatedFromCombat=function(combat){return this.dispatch("onRetreatedFromCombat",[combat]);},
    onCombatVictory=function(combat){return this.dispatch("onCombatVictory",[combat]);},
    onPartyDestroyed=function(party){return this.dispatch("onPartyDestroyed",[party]);},
    onLocationDestroyed=function(location){return this.dispatch("onLocationDestroyed",[location]);}
};
::testEventBase <- {
    fire=function(){return this.setScreen("Start");},
    processInput=function(option){return this.action();},
    setScreen=function(screen){return this.action();},
    update=function(){return this.action();},
    action=function(){return "event-noop";}
};
// Apply the production hook callbacks to fake native tables. Unrelated hooks
// are deliberately not executed; roster/formation have their own fixtures.
::mods_hookExactClass <- function(path,callback){};
::mods_getMember <- function(object, key) {
    while (!(key in object)) object = object[object.SuperName];
    return object[key];
};
::mods_override <- function(object, key, value) {
    while (!(key in object)) object = object[object.SuperName];
    object[key] = value;
};
::mods_hookBaseClass <- function(path,callback){
    if(path=="contracts/contract")callback(::testContractBase);
    else if(path=="events/event")callback(::testEventBase);
};
::mods_hookNewObject <- function(path,callback){
    if(path=="contracts/contract_manager")callback(::testContractManager);
    else if(path=="states/world/asset_manager")callback(::World.Assets);
};
dofile("src/scripts/mods/afeix/hooks.nut");

::contractChecksPassed <- 0;
function require(condition,name){
    if(!condition)throw "FAIL "+name;
    ::contractChecksPassed++;
    print("PASS "+name+"\n");
}
function reset(){
    ::World.Flags.values={};::World.Assets.m.Money=0;
    ::AfeixExpedition.PaymentContext=null;
    ::testContractManager.m.Active=null;
    ::contractTestState.origin=true;::contractTestState.failFinish=false;
    ::contractTestState.keepActive=false;::contractTestState.finishIncome=0;
    ::contractTestState.moneyFactor=1.0;
}
function contract(id){
    local c={id=id,actions={}};c.setdelegate(::testContractBase);
    ::testContractManager.m.Active=c;
    return c;
}
function payAndFinish(c,amount){
    c.actions.processInput <- function(option){
        ::World.Assets.addMoney(amount);
        return ::testContractManager.finishActiveContract(false);
    };
    return c.processInput(0);
}
function runContractChecks(){
    local A=::AfeixExpedition;
    local campaignWorld = ::World;
    delete ::World;
    require(!A.isOrigin(),"missing_world_is_not_the_afeix_origin");
    ::World <- null;
    require(!A.isOrigin(),"null_world_during_teardown_is_not_the_afeix_origin");
    ::World = {};
    require(!A.isOrigin(),"standalone_tactical_world_without_assets_is_safe");
    ::World.Assets <- null;
    require(!A.isOrigin(),"uninitialized_campaign_assets_are_safe");
    ::World.Assets = {getOrigin=function(){return null;}};
    require(!A.isOrigin(),"assets_without_a_selected_origin_are_safe");
    ::World = campaignWorld;
    require(A.isOrigin(),"loaded_afeix_campaign_still_matches_the_origin");
    local boundReceiver = { value = "correct-instance" };
    local boundCallback = function() { return this.value; }.bindenv({ value = "wrong-prototype" });
    require(A.withPaymentContext(null,boundCallback,[boundReceiver]) == "correct-instance",
        "native_bound_callback_is_rebound_to_actual_instance");
    reset();local c=contract(101);
    require(payAndFinish(c,75)=="native-finish" && A.get("paid_contracts")==1,"successful_actual_payment_unlocks_and_preserves_return");
    require(A.get("contract_received_101")==75 && A.get("contract_done_101",false),"receipt_records_actual_amount_and_deduplicates_id");
    require(A.PaymentContext==null,"successful_callback_clears_runtime_context");
    ::testContractManager.finishActiveContract(false);
    ::testContractManager.m.Active=c;::testContractManager.finishActiveContract(false);
    require(A.get("paid_contracts")==1,"duplicate_finish_does_not_count_twice");

    reset();c=contract(102);
    c.actions.processInput <- function(option){::World.Assets.addMoney(40);};c.processInput(0);
    require(A.get("contract_received_102")==40 && A.get("paid_contracts")==0,"advance_is_persisted_without_early_unlock");
    ::testContractManager.finishActiveContract(true);
    require(A.get("contract_terminal_102")==2 && A.get("paid_contracts")==0,"advance_followed_by_cancel_does_not_unlock");
    ::testContractManager.m.Active=c;::testContractManager.finishActiveContract(false);
    require(A.get("paid_contracts")==0,"cancelled_terminal_state_cannot_be_replayed_as_success");

    reset();c=contract(103);::testContractManager.finishActiveContract(false);
    require(A.get("paid_contracts")==0 && A.get("contract_received_103")==0,"advertised_count_maximum_without_real_payment_is_ignored");
    ::World.Assets.addMoney(500);
    require(A.get("paid_contracts")==0 && A.get("contract_received_103")==0,"ordinary_sale_after_finish_is_not_contract_income");

    reset();c=contract(104);
    c.actions.processInput <- function(option){::testContractManager.finishActiveContract(false);::World.Assets.addMoney(90);};
    c.processInput(0);
    require(A.get("paid_contracts")==1 && A.get("contract_received_104")==90,"finish_before_final_payment_is_supported");

    reset();c=contract(105);::contractTestState.moneyFactor=0.5;payAndFinish(c,100);
    require(A.get("contract_received_105")==50,"actual_money_delta_beats_requested_amount");
    reset();c=contract(106);::contractTestState.moneyFactor=0;payAndFinish(c,100);
    require(A.get("paid_contracts")==0 && A.get("contract_received_106")==0,"no_positive_balance_change_does_not_unlock");

    reset();c=contract(107);
    c.actions.processInput <- function(option){::World.Assets.addMoney(-30);::World.Assets.addMoney(0);::testContractManager.finishActiveContract(false);};c.processInput(0);
    require(A.get("paid_contracts")==0 && A.get("contract_received_107")==0,"negative_and_zero_transactions_are_not_receipts");

    reset();c=contract(108);
    c.actions.setScreen <- function(screen,restart){if(!restart)throw "default argument changed";::World.Assets.addMoney(20);return screen;};
    require(c.setScreen("Paid")=="Paid" && A.get("contract_received_108")==20,"set_screen_start_preserves_default_arguments_and_context");
    c.actions.setState <- function(state){::World.Assets.addMoney(10);};c.setState("Paid");
    c.actions.update <- function(){::World.Assets.addMoney(5);};c.update();
    c.actions.onCombatVictory <- function(combat){::World.Assets.addMoney(7);};c.onCombatVictory(8);
    ::testContractManager.finishActiveContract(false);
    require(A.get("contract_received_108")==42 && A.get("paid_contracts")==1,"state_update_and_combat_callbacks_capture_actual_payments");

    reset();c=contract(109);
    local event=clone ::testEventBase;
    event.action=function(){::World.Assets.addMoney(500);return "event-reward";};
    c.actions.processInput <- function(option){event.fire();::World.Assets.addMoney(60);::testContractManager.finishActiveContract(false);};c.processInput(0);
    require(::World.Assets.getMoney()==560 && A.get("contract_received_109")==60,"synchronous_event_reward_cannot_leak_into_contract_receipt");
    require(A.PaymentContext==null,"event_context_restores_contract_then_outer_context");

    reset();c=contract(110);A.PaymentContext=919;
    c.actions.processInput <- function(option){throw "injected callback failure";};
    local threw=false;try{c.processInput(0);}catch(error){threw=true;}
    require(threw && A.PaymentContext==919,"exception_restores_nested_previous_context");
    A.PaymentContext=null;::World.Assets.addMoney(100);
    require(A.get("contract_received_110")==0,"exception_does_not_tag_later_external_payment");

    reset();c=contract(111);
    c.actions.processInput <- function(option){::World.Assets.addMoney(25);};c.processInput(0);
    ::contractTestState.failFinish=true;threw=false;
    try{::testContractManager.finishActiveContract(false);}catch(error){threw=true;}
    require(threw && A.PaymentContext==null && A.get("contract_terminal_111")==0 && A.get("paid_contracts")==0,"failed_native_finish_is_not_success_and_restores_context");

    reset();c=contract(112);::contractTestState.keepActive=true;payAndFinish(c,20);
    require(A.get("paid_contracts")==0 && A.get("contract_terminal_112")==0,"native_manager_must_actually_close_contract");

    reset();c=contract(113);::contractTestState.finishIncome=35;
    ::testContractManager.finishActiveContract(false);
    require(A.get("paid_contracts")==1 && A.get("contract_received_113")==35,"payment_inside_native_finish_is_captured");

    reset();c=contract(114);
    c.actions.processInput <- function(option){::World.Assets.addMoney(45);};c.processInput(0);
    // Reinitializing only the runtime module simulates a fresh process retaining
    // serialized World.Flags; context never enters the persistent flag table.
    A.PaymentContext=888;dofile("src/scripts/mods/afeix/contracts.nut");
    require(A.PaymentContext==null && A.get("contract_received_114")==45,"reload_retains_receipt_but_discards_runtime_context");
    ::testContractManager.finishActiveContract(false);
    require(A.get("paid_contracts")==1,"pre_save_advance_and_post_load_success_count_once");

    reset();c=contract(115);::contractTestState.origin=false;payAndFinish(c,70);
    require(::World.Assets.getMoney()==70 && A.get("paid_contracts")==0 && A.get("contract_received_115")==0,"other_origins_keep_native_payment_without_afeix_flags");

    // New sponsorship code runs through the same production payment hooks.
    ::Math <- { min=function(a,b){return a<b?a:b;}, max=function(a,b){return a>b?a:b;}, floor=function(v){return ::floor(v);} };
    ::circleTest <- { rate=0.15, present=true, alive=true };
    A.circleRate <- function(){return ::circleTest.rate;};
    A.findCharacter <- function(key){return ::circleTest.present ? {isAlive=function(){return ::circleTest.alive;}} : null;};
    dofile("src/scripts/mods/afeix/economy.nut");
    reset();c=contract(201);c.onCombatVictory(7);payAndFinish(c,1000);
    require(::World.Assets.getMoney()==1150 && A.get("circle_paid_201")==150,"won_paid_contract_awards_fifteen_percent");
    require(A.get("contract_received_201")==1000 && A.get("circle_total")==150 && A.PaymentContext==null,"sponsorship_never_sponsors_itself_or_leaks_context");
    A.tryRecordPaidContract(201);A.finishContractPayment(201,false);
    require(::World.Assets.getMoney()==1150 && A.get("paid_contracts")==1,"reopening_and_replaying_completion_cannot_duplicate_income");
    ::circleTest.rate=0.10;A.tryRecordPaidContract(201);
    require(::World.Assets.getMoney()==1150 && A.get("circle_rate_201")==0.15,"retraining_does_not_reprice_settled_sponsorship");

    reset();::circleTest.rate=0.15;c=contract(202);c.onCombatVictory(8);
    c.actions.processInput<-function(option){::World.Assets.addMoney(100);};c.processInput(0);
    require(::World.Assets.getMoney()==100 && A.get("circle_paid_202")==0,"advance_without_completion_has_no_sponsorship");
    ::testContractManager.finishActiveContract(false);
    c.actions.processInput=function(option){::World.Assets.addMoney(300);};c.processInput(0);
    require(::World.Assets.getMoney()==460 && A.get("contract_received_202")==400 && A.get("circle_paid_202")==60,"split_final_reward_adds_only_the_unpaid_difference");
    dofile("src/scripts/mods/afeix/economy.nut");A.tryRecordPaidContract(202);
    require(::World.Assets.getMoney()==460,"reload_retains_paid_entitlement");

    reset();c=contract(203);c.onCombatVictory(9);payAndFinish(c,10000);
    require(::World.Assets.getMoney()==10300 && A.get("circle_paid_203")==300,"per_contract_cap_limits_large_rewards");
    c.actions.processInput=function(option){::World.Assets.addMoney(1000);};c.processInput(0);
    require(::World.Assets.getMoney()==11300 && A.get("circle_paid_203")==300,"extra_payment_does_not_reset_contract_cap");

    reset();::circleTest.rate=0.10;c=contract(204);c.onCombatVictory(10);payAndFinish(c,555);
    require(::World.Assets.getMoney()==610 && A.get("circle_paid_204")==55,"feidie_rate_rounds_down_to_whole_crowns");
    reset();::circleTest.rate=0.15;c=contract(205);payAndFinish(c,1000);
    require(::World.Assets.getMoney()==1000 && A.get("circle_rate_205")==0,"peaceful_contract_has_no_battle_sponsorship");
    c.onCombatVictory(11);A.tryRecordPaidContract(205);
    require(::World.Assets.getMoney()==1000,"post_completion_victory_cannot_reopen_eligibility");

    reset();c=contract(206);c.onCombatVictory(12);
    c.actions.processInput<-function(option){::World.Assets.addMoney(200);::testContractManager.finishActiveContract(true);};c.processInput(0);
    require(::World.Assets.getMoney()==200 && A.get("circle_paid_206")==0 && A.get("paid_contracts")==0,"cancelled_contract_never_gains_sponsorship");
    reset();c=contract(207);c.onCombatVictory(13);::circleTest.rate=0.0;::testContractManager.finishActiveContract(false);
    ::circleTest.rate=0.15;c.actions.processInput<-function(option){::World.Assets.addMoney(1000);};c.processInput(0);
    require(::World.Assets.getMoney()==1000 && A.get("circle_rate_207")==0.0,"late_payment_cannot_gain_new_route_after_completion");

    reset();::circleTest.alive=false;c=contract(208);c.onCombatVictory(14);payAndFinish(c,1000);
    require(::World.Assets.getMoney()==1000,"fallen_afei_cannot_sign_new_sponsorship");
    ::circleTest.alive=true;::circleTest.present=false;reset();c=contract(209);c.onCombatVictory(15);payAndFinish(c,1000);
    require(::World.Assets.getMoney()==1000,"absent_afei_cannot_sign_new_sponsorship");
    ::circleTest.present=true;
    reset();A.set("contract_terminal_210",1);A.set("contract_received_210",1000);A.set("contract_done_210",true);A.tryRecordPaidContract(210);
    require(::World.Assets.getMoney()==0,"old_version_completed_contracts_are_not_retroactive_rewards");
    reset();c=contract(211);::contractTestState.origin=false;c.onCombatVictory(16);payAndFinish(c,1000);
    require(::World.Assets.getMoney()==1000 && !A.get("circle_victory_211",false),"other_origins_do_not_gain_sponsorship_or_victory_flags");
    reset();
    foreach (kind in ["contract.afeix_letter","contract.deliver_item"]) {
        c=contract(kind=="contract.afeix_letter"?301:302);
        c.getType <- function(){return kind;};
        payAndFinish(c,180);
    }
    require(A.get("qualified_contracts")==0 && A.get("qualified_types")==0 && A.get("courier_completed")==2,"both_native_and_mod_couriers_are_excluded_from_unlocks");
    c=contract(303);c.getType <- function(){return "contract.destroy_bandit_camp";};payAndFinish(c,500);
    c=contract(304);c.getType <- function(){return "contract.destroy_bandit_camp";};payAndFinish(c,500);
    c=contract(305);c.getType <- function(){return "contract.escort_caravan";};payAndFinish(c,500);
    require(A.get("qualified_contracts")==3 && A.get("qualified_types")==2,"qualified_count_and_distinct_types_have_separate_accounting");
    A.tryRecordPaidContract(305);require(A.get("qualified_contracts")==3 && A.get("qualified_types")==2,"repeated_completion_cannot_inflate_either_unlock_metric");
    print("TESTS_PASSED="+::contractChecksPassed+"\n");
}
try{runContractChecks();}
catch(error){print(error+"\n");if("exit" in getroottable())exit(1);throw error;}
