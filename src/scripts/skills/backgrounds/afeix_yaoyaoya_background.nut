// Generated; retain native attributes, event eligibility and save layout.
this.afeix_yaoyaoya_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_yaoyaoya";
        ::AfeixExpedition.configureCharacterBackground(this, "yaoyaoya");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "yaoyaoya");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
