// Generated; retain native attributes, event eligibility and save layout.
this.afeix_laocai_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_laocai";
        ::AfeixExpedition.configureCharacterBackground(this, "laocai");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "laocai");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
