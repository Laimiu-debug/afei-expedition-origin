// Generated; retain native attributes, event eligibility and save layout.
this.afeix_naigai_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_naigai";
        ::AfeixExpedition.configureCharacterBackground(this, "naigai");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "naigai");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
