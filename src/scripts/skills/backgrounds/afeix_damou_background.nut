// Generated; retain native attributes, event eligibility and save layout.
this.afeix_damou_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_damou";
        ::AfeixExpedition.configureCharacterBackground(this, "damou");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "damou");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
