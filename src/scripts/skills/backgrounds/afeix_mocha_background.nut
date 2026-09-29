// Generated; retain native attributes, event eligibility and save layout.
this.afeix_mocha_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_mocha";
        ::AfeixExpedition.configureCharacterBackground(this, "mocha");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "mocha");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
