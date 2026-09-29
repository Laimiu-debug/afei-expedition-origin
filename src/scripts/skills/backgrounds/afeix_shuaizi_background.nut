// Generated; retain native attributes, event eligibility and save layout.
this.afeix_shuaizi_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_shuaizi";
        ::AfeixExpedition.configureCharacterBackground(this, "shuaizi");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "shuaizi");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
