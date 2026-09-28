this.afeix_xiwen_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiwen";
        ::AfeixExpedition.configureCharacterBackground(this, "xiwen");
    },
    function buildDescription(final = false) { ::AfeixExpedition.configureCharacterBackground(this, "xiwen"); },
    function onBuildDescription() { return this.m.RawDescription; }
});
