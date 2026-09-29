// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaojie_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiaojie";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaojie");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaojie");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
