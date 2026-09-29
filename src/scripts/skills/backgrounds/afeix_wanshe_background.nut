// Generated; retain native attributes, event eligibility and save layout.
this.afeix_wanshe_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_wanshe";
        ::AfeixExpedition.configureCharacterBackground(this, "wanshe");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "wanshe");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
