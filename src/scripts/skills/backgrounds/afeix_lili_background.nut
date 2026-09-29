// Generated; retain native attributes, event eligibility and save layout.
this.afeix_lili_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_lili";
        ::AfeixExpedition.configureCharacterBackground(this, "lili");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "lili");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
