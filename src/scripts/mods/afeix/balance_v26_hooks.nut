// The native hire dialog calls this both for preview and actual payment. Keep
// level/equipment fixed but re-evaluate the limited service discount at checkout.
::mods_hookExactClass("entity/tactical/player",function(o){
    local prior=o.getHiringCost;
    o.getHiringCost=function(){
        local A=::AfeixExpedition,f=this.getFlags(),key=A.characterId(this);
        if(A.isOrigin()&&key in A.Characters&&f.has("afeix_candidate")&&f.get("afeix_candidate")){
            if(f.has("afeix_v26_new_offer"))this.m.HiringCost=A.recruitPrice(key);
            else if(f.has("afeix_v26_quote"))this.m.HiringCost=f.get("afeix_v26_quote");
        }
        return prior.bindenv(this)();
    };
});
