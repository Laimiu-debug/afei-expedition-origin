local A=::AfeixExpedition;
A.catalogWorldHas <- function(key){
    if(!this.isOrigin())return false;
    local d=this.MemberSkillDefs[key],bro=this.findCharacter(d.owner);
    return bro!=null&&bro.isAlive()&&this.catalogHas(bro,key);
};
A.catalogDay <- function(){return ::World.getTime().Days;};
A.catalogTradeOffer <- function(item,price){
    local result={key="",price=price};
    if(!this.isOrigin()||item==null||price<=0)return result;
    if(item.isItemType(::Const.Items.ItemType.Food)&&this.catalogWorldHas("supermarket")&&this.get("trade_supermarket_day",-1)!=this.catalogDay())result={key="supermarket",price=::Math.ceil(price-::Math.min(30,price*0.15)).tointeger()};
    if(["supplies.armor_parts","supplies.medicine","supplies.ammo"].find(item.getID())!=null&&this.catalogWorldHas("purse_clear")&&this.get("trade_purse_clear_day",-1)!=this.catalogDay())result={key="purse_clear",price=::Math.ceil(price-::Math.min(30,price*0.05)).tointeger()};
    return result;
};
A.catalogRecruitDiscount <- function(price){
    return price>0&&this.catalogWorldHas("steal_bro")&&this.catalogDay()>=this.get("steal_bro_day",-100)+7 ? ::Math.min(200,price-::Math.ceil(price*0.8)).tointeger() : 0;
};
local originalRecruitPrice=A.recruitPrice;
A.recruitPrice=function(key){local price=originalRecruitPrice.bindenv(this)(key);return price-this.catalogRecruitDiscount(price);};
local originalHired=A.onNativeHired;
A.onNativeHired=function(bro){
    local key=this.characterId(bro),before=key!=""&&this.isOrigin()?this.get("ever_"+key,false):true;
    local discounted=key!=""&&key in this.Characters&&this.catalogRecruitDiscount("BalanceV26" in this&&key in this.BalanceV26.people?::Math.max(0,this.BalanceV26.people[key].service_fee-this.get("hire_discount_"+key,0)):originalRecruitPrice.bindenv(this)(key))>0;
    local result=originalHired.bindenv(this)(bro);
    if(!before&&discounted&&this.findCharacter(key)==bro&&this.get("ever_"+key,false))this.set("steal_bro_day",this.catalogDay());
    return result;
};
A.catalogRepairSpent <- function(spent){
    if(spent<=0||!this.catalogWorldHas("scrap_parts"))return 0;
    if(this.get("scrap_day",-1)!=this.catalogDay()){this.set("scrap_day",this.catalogDay());this.set("scrap_refunds",0);}
    local total=this.get("scrap_spent",0.0)+spent,refund=::Math.min(3-this.get("scrap_refunds"),::Math.floor(total/7)).tointeger();
    this.set("scrap_spent",total-::Math.floor(total/7)*7);this.set("scrap_refunds",this.get("scrap_refunds")+refund);
    if(refund>0)::World.Assets.addArmorParts(refund);
    return refund;
};
