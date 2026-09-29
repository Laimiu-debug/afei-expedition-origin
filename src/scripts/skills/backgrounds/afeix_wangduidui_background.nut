// Generated; retain native attributes, event eligibility and save layout.
this.afeix_wangduidui_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_wangduidui";
        ::AfeixExpedition.configureCharacterBackground(this, "wangduidui");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "wangduidui");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
