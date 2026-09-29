// Generated; retain native attributes, event eligibility and save layout.
this.afeix_xiaogui_background <- this.inherit("scripts/skills/backgrounds/daytaler_background", {
    m = {},
    function create() {
        this.daytaler_background.create();
        this.m.ID = "background.afeix_xiaogui";
        ::AfeixExpedition.configureCharacterBackground(this, "xiaogui");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "xiaogui");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
