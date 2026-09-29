::mods_hookExactClass("scenarios/world/afeix_expedition_scenario", function(o) {
    local create = o.create;
    o.create = function() {
        create.bindenv(this)();
        this.m.Description += "[p][color=#bcad8c]里根儿同行：[/color]黑旗才刚展开，战犬里根儿已经叼着绳头等在阿飞脚边。路上的风雨有人一起扛，营火旁也总多一条摇晃的尾巴。希文可在沿途城镇结识并招募。[/p]";
    };
    local onSpawnAssets = o.onSpawnAssets;
    o.onSpawnAssets = function() {
        local result = onSpawnAssets.bindenv(this)();
        if (!::AfeixExpedition.giveStartingRegen() && !::AfeixExpedition.get("dlc_regen_granted", false))
            ::logError("[Afei Xiwen/Regen DLC] Starting pet was not delivered; check Afei and free stash space.");
        return result;
    };
});
