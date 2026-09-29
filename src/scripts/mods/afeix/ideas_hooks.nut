::mods_hookNewObject("items/item_container",function(o){
    local equip=o.equip,deserialize=o.onDeserialize;
    o.m.AfeixLoading <- false;
    o.onDeserialize=function(input){this.m.AfeixLoading=true;try{deserialize.bindenv(this)(input);}catch(e){this.m.AfeixLoading=false;throw e;}this.m.AfeixLoading=false;};
    o.equip=function(item){local A=::AfeixExpedition;
        if(!this.m.AfeixLoading&&!A.IdeasRestoringHelmet&&item!=null&&item.getSlotType()==::Const.ItemSlot.Head&&A.isTurtle(this.getActor()))return false;
        return equip.bindenv(this)(item);
    };
});
// building is a bare table. Legacy Hooks sees its children via BaseClass.
// Resolve inherited callbacks on their defining table and wrap each once.
local stashWrappers={};
::mods_hookBaseClass("entity/world/settlements/buildings/building",function(o){
    local old=::mods_getMember(o,"onAfterFillStash");
    if(old in stashWrappers)return;
    local wrapped=function(stash){local r=old.bindenv(this)(stash);::AfeixExpedition.gripRestock(this,stash);return r;};
    stashWrappers[wrapped]<-true;
    ::mods_override(o,"onAfterFillStash",wrapped);
});
::mods_hookNewObject("events/event_manager",function(o){
    local update=o.update;
    o.update=function(){
        // A failed event generator otherwise throws on every world frame,
        // preventing the immediately following native Ambitions.update call.
        // Do not clear a live selection or an active/shown event.
        if(::AfeixExpedition.isOrigin()&&this.m.Thread!=null&&this.m.Thread.getstatus()=="dead")this.m.Thread=null;
        return update.bindenv(this)();
    };
});
::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_shop_dialog_module",function(o){
    local old=o.onSwapItem;
    o.onSwapItem=function(data){
        local A=::AfeixExpedition,item=null,shop=null,money=0;
        if(A.isOrigin()&&data!=null&&data.len()>=4&&data[1]=="world-town-screen-shop-dialog-module.shop"&&data[3]!=data[1]) {
            shop=this.m.Shop.getStash();local entry=shop.getItemAtIndex(data[0]);item=entry==null?null:entry.item;money=::World.Assets.getMoney();
        }
        local r=old.bindenv(this)(data);
        if(item!=null&&item.getID()==A.GripID&&::World.Assets.getMoney()<money&&shop.getItems().find(item)==null)A.set("ideas_grip_bought",true);
        return r;
    };
});
::mods_hookExactClass("entity/tactical/actor",function(o){
    local turn=o.onTurnStart,damage=o.onDamageReceived,otherDeath=o.onOtherActorDeath;
    o.onTurnStart=function(){::AfeixExpedition.ideaBattleTurn();::AfeixExpedition.tryTurtleAwakening();return turn.bindenv(this)();};
    o.onOtherActorDeath=function(killer,victim,skill){
        local result=otherDeath.bindenv(this)(killer,victim,skill);
        ::AfeixExpedition.tryTurtleAwakening();
        return result;
    };
    o.onDamageReceived=function(attacker,skill,info){
        local A=::AfeixExpedition,track=A.isOrigin()&&::Tactical.isActive()&&A.characterId(this)=="afei",hp=track?this.getHitpoints():0;
        local r=damage.bindenv(this)(attacker,skill,info);
        if(track&&this.getHitpoints()<hp)A.set("ideas_afei_hurt",true);
        return r;
    };
});
::mods_hookExactClass("states/world_state",function(o){
    local end=o.onCombatFinished;
    o.onCombatFinished=function(){local r=end.bindenv(this)();::AfeixExpedition.finishIdeasBattle();return r;};
});
::mods_hookNewObject("states/world/asset_manager",function(o){
    local update=o.update;
    o.update=function(worldState){local r=update.bindenv(this)(worldState),A=::AfeixExpedition;
        if(A.isOrigin()&&!::Tactical.isActive()){local turtle=A.findCharacter("xiaogui");if(turtle!=null)A.syncIdeasCharacter(turtle);}
        return r;
    };
});
