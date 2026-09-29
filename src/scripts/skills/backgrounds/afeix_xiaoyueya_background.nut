// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaoyueya_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiaoyueya";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoyueya");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaoyueya");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
