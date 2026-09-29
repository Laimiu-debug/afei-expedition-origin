// Generated; retain native attributes, event eligibility and save layout.
this.afeix_tongzhu_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_tongzhu";
        ::AfeixExpedition.configureCharacterBackground(this, "tongzhu");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "tongzhu");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
