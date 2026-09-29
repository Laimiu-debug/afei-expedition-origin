// Fill only the title left empty after native background and trait generation.
::mods_hookExactClass("entity/tactical/player", function(o) {
    local setStartValuesEx = o.setStartValuesEx;
    o.setStartValuesEx = function(backgrounds, addTraits = true) {
        local result = setStartValuesEx.bindenv(this)(backgrounds, addTraits);
        if (!::AfeixExpedition.isOrigin() || this.getTitle() != "") return result;
        // Named expedition members (including optional DLC) receive authored titles.
        if (this.getBackground().getID().find("background.afeix_") == 0) return result;
        local titles = ["保飞派", "倒飞派", "儿飞派", "曹飞派"];
        this.setTitle(titles[::Math.rand(0, titles.len() - 1)]);
        return result;
    };
});
