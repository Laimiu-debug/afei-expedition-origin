// Generated; retain native attributes, event eligibility and save layout.
this.afeix_songnuanyang_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_songnuanyang";
        ::AfeixExpedition.configureCharacterBackground(this, "songnuanyang");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "songnuanyang");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
