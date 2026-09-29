// Generated; retain native attributes, event eligibility and save layout.
this.afeix_yuxiang_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_yuxiang";
        ::AfeixExpedition.configureCharacterBackground(this, "yuxiang");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "yuxiang");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
