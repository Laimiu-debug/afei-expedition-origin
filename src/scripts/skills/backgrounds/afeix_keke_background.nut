// Generated; retain native attributes, event eligibility and save layout.
this.afeix_keke_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_keke";
        ::AfeixExpedition.configureCharacterBackground(this, "keke");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "keke");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
