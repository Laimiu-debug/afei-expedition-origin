// Generated; retain native attributes, event eligibility and save layout.
this.afeix_manyuemei_background <- this.inherit("scripts/skills/backgrounds/poacher_background", {
    m = {},
    function create() {
        this.poacher_background.create();
        this.m.ID = "background.afeix_manyuemei";
        ::AfeixExpedition.configureCharacterBackground(this, "manyuemei");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "manyuemei");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
