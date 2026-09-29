// Generated; retain native attributes, event eligibility and save layout.
this.afeix_yuchujiu_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_yuchujiu";
        ::AfeixExpedition.configureCharacterBackground(this, "yuchujiu");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "yuchujiu");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
