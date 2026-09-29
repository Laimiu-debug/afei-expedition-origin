// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaopangxu_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_xiaopangxu";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaopangxu");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaopangxu");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
