// Generated; retain native attributes, event eligibility and save layout.
this.afeix_yangmiemie_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_yangmiemie";
        ::AfeixExpedition.configureCharacterBackground(this, "yangmiemie");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "yangmiemie");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
