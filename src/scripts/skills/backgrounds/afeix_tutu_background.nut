// Generated; retain native attributes, event eligibility and save layout.
this.afeix_tutu_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_tutu";
        ::AfeixExpedition.configureCharacterBackground(this, "tutu");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "tutu");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
