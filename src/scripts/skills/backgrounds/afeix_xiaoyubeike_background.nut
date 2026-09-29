// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaoyubeike_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiaoyubeike";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoyubeike");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoyubeike");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
