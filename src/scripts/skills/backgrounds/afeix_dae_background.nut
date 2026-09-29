// Generated; retain native attributes, event eligibility and save layout.
this.afeix_dae_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_dae";
        ::AfeixExpedition.configureCharacterBackground(this, "dae");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "dae");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
