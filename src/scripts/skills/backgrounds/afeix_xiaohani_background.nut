// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaohani_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiaohani";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaohani");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaohani");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
