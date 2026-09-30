this.afeix_ledger_event <- this.inherit("scripts/events/event", {
    m = { Notice = "", Selected = [], FormationPage = 0, AutoPage = "home", TreatmentOffer = null },
    function create() {
        this.m.ID = "event.afeix_ledger";
        this.m.Title = "黑旗名册";
        this.m.Cooldown = 0.0;
        this.m.IsSpecial = true;
    },
    function onUpdateScore() {
        // F8 opens this event explicitly; it is never a random world event.
        this.m.Score = 0;
    },
    function onPrepare() {
        this.m.TreatmentOffer = null;
        this.m.Notice = "";
        this.m.Selected = [];
        this.m.FormationPage = 0;
        if (this.m.AutoPage == "tavern") this.m.AutoPage = ::AfeixExpedition.prepareTavernMeeting();
    },
    function onDetermineStartScreen() { return this.m.AutoPage; },
    function getScreen(id) { return ::AfeixExpedition.ledgerPage(this, id); },
    function buildText(text) { return text; },
    function onClear() {
        this.m.TreatmentOffer = null;
        this.m.Notice = "";
        this.m.Selected = [];
        this.m.FormationPage = 0;
        this.m.AutoPage = "home";
    },
    function onPrepareVariables(vars) {}
});
