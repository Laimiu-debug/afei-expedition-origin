this.afeix_dream_event <- this.inherit("scripts/events/event", {
    m = { Page = "opening", StoryReview = false },
    function create() {
        this.m.ID = "event.afeix_dream";
        this.m.Title = "三人同梦";
        this.m.Cooldown = 0.0;
        this.m.IsSpecial = true;
    },
    function onUpdateScore() { this.m.Score = 0; },
    function onDetermineStartScreen() { return this.m.Page; },
    function processInput(option) {
        if (option < 0) {
            ::AfeixExpedition.dismissDreamStory();
            return false;
        }
        return this.event.processInput.bindenv(this)(option);
    },
    function getScreen(id) { local screen = ::AfeixExpedition.dreamPage(this, id); if (screen != null) this.m.Title = screen.Title; return screen; },
    function buildText(text) { return text; },
    function onPrepareVariables(vars) {},
    function onClear() { this.m.Page = "opening"; this.m.StoryReview = false; }
});
