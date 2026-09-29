::mods_hookExactClass("scenarios/world/afeix_expedition_scenario", function(o) {
    local create = o.create;
    o.create = function() {
        create.bindenv(this)();
        this.m.Description += "[p][color=#bcad8c]里根同行：[/color]阿飞的狗里根从启程起便跟在身边。若阿飞已戴着电子烟等饰品，里根会放在队伍仓库。战前给一名队员装备里根，战斗中即可释放战犬；希文可在沿途城镇结识并招募。[/p]";
    };
    local onSpawnAssets = o.onSpawnAssets;
    o.onSpawnAssets = function() {
        local result = onSpawnAssets.bindenv(this)();
        if (!::AfeixExpedition.giveStartingRegen() && !::AfeixExpedition.get("dlc_regen_granted", false))
            ::logError("[Afei Xiwen/Regen DLC] Starting pet was not delivered; check Afei and free stash space.");
        return result;
    };
});
