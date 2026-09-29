// Generated; retain native attributes, event eligibility and save layout.
this.afeix_tiantong_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_tiantong";
        ::AfeixExpedition.configureCharacterBackground(this, "tiantong");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "tiantong");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
