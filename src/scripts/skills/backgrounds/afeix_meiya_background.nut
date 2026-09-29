// Generated; retain native attributes, event eligibility and save layout.
this.afeix_meiya_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_meiya";
        ::AfeixExpedition.configureCharacterBackground(this, "meiya");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "meiya");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
