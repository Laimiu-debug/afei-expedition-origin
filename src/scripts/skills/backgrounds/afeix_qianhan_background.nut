// Generated; retain native attributes, event eligibility and save layout.
this.afeix_qianhan_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_qianhan";
        ::AfeixExpedition.configureCharacterBackground(this, "qianhan");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "qianhan");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
