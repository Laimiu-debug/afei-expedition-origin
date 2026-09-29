// Generated; retain native attributes, event eligibility and save layout.
this.afeix_afei_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_afei";
        ::AfeixExpedition.configureCharacterBackground(this, "afei");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "afei");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
