// Generated; retain native attributes, event eligibility and save layout.
this.afeix_bula_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_bula";
        ::AfeixExpedition.configureCharacterBackground(this, "bula");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "bula");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
