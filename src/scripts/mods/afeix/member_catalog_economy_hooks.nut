local priceWrappers={};
::mods_hookBaseClass("items/item",function(o){
    local previous=::mods_getMember(o,"getBuyPrice");if(previous in priceWrappers)return;
    local replacement=function(){
        local price=previous.bindenv(this)(),A=::AfeixExpedition;
        if(!A.isOrigin()||::Tactical.isActive()||this.m.IsSold||this.m.IsBought)return price;
        local offer=A.catalogTradeOffer(this,price);
        return ::Math.max(this.getSellPrice(),offer.price);
    };
    priceWrappers[replacement]<-true;::mods_override(o,"getBuyPrice",replacement);
});
::mods_hookNewObject("ui/screens/world/modules/world_town_screen/town_shop_dialog_module",function(o){
    local previous=o.onSwapItem;
    o.onSwapItem=function(data){
        local A=::AfeixExpedition;
        if(!A.isOrigin()||data==null||data.len()<4||data[1]!="world-town-screen-shop-dialog-module.shop"||data[3]==data[1])return previous.bindenv(this)(data);
        local shop=this.m.Shop.getStash(),entry=shop.getItemAtIndex(data[0]),item=entry==null?null:entry.item;
        if(item==null)return previous.bindenv(this)(data);
        // Identify the applicable daily offer independently of price preview calls.
        local offer=A.catalogTradeOffer(item,100),money=::World.Assets.getMoney();
        local result=previous.bindenv(this)(data);
        if(offer.key!=""&&::World.Assets.getMoney()<money&&shop.getItems().find(item)==null){
            A.set("trade_"+offer.key+"_day",A.catalogDay());
            if(result!=null&&"Shop" in result){
                result.Shop=[];this.UIDataHelper.convertItemsToUIData(shop.getItems(),result.Shop,this.Const.UI.ItemOwner.Shop);
            }
        }
        return result;
    };
});
::mods_hookNewObject("states/world/asset_manager",function(o){
    local previous=o.update;
    o.update=function(worldState){
        local before=this.m.ArmorParts,result=previous.bindenv(this)(worldState);
        ::AfeixExpedition.catalogRepairSpent(::Math.maxf(0,before-this.m.ArmorParts));return result;
    };
});
