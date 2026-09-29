// Generated; retain native attributes, event eligibility and save layout.
this.afeix_bottle_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_bottle";
        ::AfeixExpedition.configureCharacterBackground(this, "bottle");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "bottle");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
