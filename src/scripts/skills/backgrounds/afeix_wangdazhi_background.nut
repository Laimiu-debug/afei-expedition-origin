// Generated; retain native attributes, event eligibility and save layout.
this.afeix_wangdazhi_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_wangdazhi";
        ::AfeixExpedition.configureCharacterBackground(this, "wangdazhi");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "wangdazhi");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
