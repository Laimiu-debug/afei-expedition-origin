// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaoning_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_xiaoning";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoning");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoning");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
