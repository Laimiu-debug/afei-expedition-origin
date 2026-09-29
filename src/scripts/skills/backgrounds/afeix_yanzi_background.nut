// Generated; retain native attributes, event eligibility and save layout.
this.afeix_yanzi_background <- this.inherit("scripts/skills/backgrounds/militia_background", {
    m = {},
    function create() {
        this.militia_background.create();
        this.m.ID = "background.afeix_yanzi";
        ::AfeixExpedition.configureCharacterBackground(this, "yanzi");
    },
    function buildDescription(final = false) {
        ::AfeixExpedition.configureCharacterBackground(this, "yanzi");
    },
    function onBuildDescription() { return this.m.RawDescription; }
});
