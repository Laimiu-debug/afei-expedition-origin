this.afeix_discovery_event <- this.inherit("scripts/events/event", {
    m = { Notice = "", Selected = [], FormationPage = 0, Page = "home" },
    function create() {
        this.m.ID = "event.afeix_discovery";
        this.m.Title = "歇脚时";
        this.m.Cooldown = 60.0;
    },
    function onUpdateScore() {
        this.m.Score = ::AfeixExpedition.nextDiscovery() != null ? 100 : 0;
    },
    function onPrepare() {
        local A = ::AfeixExpedition, page = A.nextDiscovery();
        this.m.Page = page != null && A.revealDiscovery(page) ? page : "home";
        this.m.Notice = ""; this.m.Selected = []; this.m.FormationPage = 0;
    },
    function onDetermineStartScreen() { return this.m.Page; },
    function getScreen(id) { return ::AfeixExpedition.ledgerPage(this, id); },
    function buildText(text) { return text; },
    function onClear() { this.m.Page = "home"; this.m.Notice = ""; this.m.Selected = []; },
    function onPrepareVariables(vars) {}
});
