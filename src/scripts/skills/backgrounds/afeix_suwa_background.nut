// Generated; retain native attributes, event eligibility and save layout.
this.afeix_suwa_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_suwa";
        ::AfeixExpedition.configureCharacterBackground(this, "suwa");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "suwa");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
