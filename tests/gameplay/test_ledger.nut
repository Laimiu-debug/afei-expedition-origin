local checks = 0;
function check(ok, message) { if (!ok) throw "FAIL " + message; }
local expect = function(ok, message) { checks++; check(ok, message); };
::Math <- { function min(a, b) { return a < b ? a : b; } };
::AfeixExpedition <- {
    Brothers = [], Deployed = [1, 2, 3], Applied = 0, Manage = true, Origin = true, CombatMax = 10,
    RecruitState = {}, Characters = {}, CharacterOrder = [], Chapters = [], Progress = 1,
    RetiredCharacters = {},
    EncounterCalls = [], HireCalls = [], Discounts = {}, EncounterFail = false, Known = {}, Tavern = true, TavernTown = 0,
    function roster() { return this.Brothers; },
    function deployedIds() { return clone this.Deployed; },
    function canManage() { return this.Manage; },
    function isOrigin() { return this.Origin; },
    function characterStatus(key) { return key in this.Known ? this.RecruitState[key] : "locked"; },
    function isCharacterKnown(key) { return key in this.Known; },
    function knownMembers() { local result=[];foreach(key in this.CharacterOrder)if(this.isCharacterKnown(key))result.push(key);return result; },
    function isAtTavern() { return this.Tavern; },
    function prepareTavernMeeting() { return "tavern"; },
    function nextDiscovery(inTavern = false) { return null; },
    function hasStoryRecords() { return false; },
    function storyPageNumber(text) { try { return text.tointeger(); } catch(e) { return 0; } },
    function progressCount() { return this.Progress; },
    function isChapterUnlocked(id) { return this.Progress >= this.Chapters[id - 1].required; },
    function chapterSummary() { return "旅途进度 " + this.Progress + "；五章逐步开启"; },
    function recruitHint(key) { return "相遇与邀请条件：" + key + "，本章要求 " + this.Chapters[this.Characters[key].chapter - 1].required; },
    function recruitPrice(key) { return this.Characters[key].hireCost - this.Discounts[key]; },
    function questSummary() { return "送信目的地与报酬"; },
    function startDelivery() { return { ok = true, text = "已领取" }; },
    function finishDelivery() { return { ok = false, text = "尚未到达收信地" }; },
    function cancelDelivery() { return { ok = true, text = "已放弃" }; },
    function recruit(key) { this.HireCalls.push(key); return { ok = false, text = "资金不足，没有扣款：" + key }; },
    function resolveEncounter(key, index) {
        if (this.EncounterFail) return { ok = false, text = "地点或资金不符合：" + key };
        if (this.characterStatus(key) != "encounter") return { ok = false, text = "相遇不可重复" };
        this.EncounterCalls.push([key, index]);
        this.Discounts[key] = this.Characters[key].encounterChoices[index].hireDiscount;
        this.RecruitState[key] = "available";
        return { ok = true, text = "相遇结果：" + key + ":" + index };
    },
    function applyFormation(ids) {
        this.Applied++;
        if (!this.Manage || ids.len() < 1 || ids.len() > 10) return { ok = false, text = "人数或地点不符合" };
        this.Deployed = clone ids;
        return { ok = true, text = "已安排" };
    }
};
local A = ::AfeixExpedition;
local thresholds = [1, 3, 6, 9];
for (local i = 0; i < 4; i++) A.Chapters.push({ id = i + 1, name = "旅途篇章" + (i + 1), required = thresholds[i] });
local fixtureChapters = [["afei", "damou", "mocha", "bottle", "shuaizi", "lili", "xiaoyueya", "yuchujiu", "xiaoyubeike", "wangduidui"], ["laocai", "yanzi", "tiantong", "xiaoning", "xiaopangxu", "dae", "manyuemei", "xiaohani"], ["keke", "yuxiang", "tongzhu", "meiya", "wanshe", "tutu", "naigai", "xiaojie", "bula", "suwa", "qianhan", "wangdazhi", "yaoyaoya", "yangmiemie"], ["songnuanyang", "xiaogui"]];
foreach (chapterIndex, keys in fixtureChapters) foreach (key in keys) {
    local i = A.CharacterOrder.len();
    A.CharacterOrder.push(key);
    A.Characters[key] <- {
        name = "队员" + i, hireCost = 200 + i * 10, wage = 9, description = "队员档案" + i, role = "起步定位" + i,
        chapter = chapterIndex + 1, isCaptain = i < 3,
        encounterTitle = "相遇标题" + i, encounterText = "独立相遇场景" + i,
        encounterChoices = [
            { label = "亲自帮忙" + i, outcome = "帮忙之后", cost = 0, hireDiscount = 10 },
            { label = "付费添置" + i, outcome = "添置之后", cost = 20, hireDiscount = 35 }
        ]
    };
    A.RecruitState[key] <- i < 3 ? "recruited" : "encounter";
    A.Discounts[key] <- 0;
    A.Brothers.push({ ID = i + 1, function getID() { return this.ID; }, function getNameOnly() { return "成员" + this.ID; }, function getLevel() { return 1; } });
}
foreach(key in ["afei","damou","mocha"])A.Known[key] <- true;
A.Characters.shuaizi.hireCost = 200;
A.Characters.bottle.hireCost = 220;
A.RecruitState.shuaizi = "available";
A.RecruitState.bottle = "locked";
dofile("src/scripts/mods/afeix/ledger.nut");
// Mirrors native event.fire/setScreen ordering, without depending on game assets.
::inherit <- function(path, data) {
    foreach (key, value in { ID = "", Title = "", Cooldown = 0.0, IsSpecial = false, Score = 0 })
        if (!(key in data.m)) data.m[key] <- value;
    data.fire <- function() { this.onPrepare(); this.setScreen(this.getScreen(this.onDetermineStartScreen())); };
    data.setScreen <- function(screen) { this.m.ActiveScreen <- clone screen; this.m.ActiveScreen.start(this); this.m.ActiveScreen.Text = this.buildText(this.m.ActiveScreen.Text); };
    data.clear <- function() { this.onClear(); };
    return data;
};
dofile("src/scripts/events/events/afeix_ledger_event.nut");
local e = ::afeix_ledger_event;
e.create();
e.fire();
expect(e.m.ID == "event.afeix_ledger" && e.m.IsSpecial, "manual special event identity");
expect(e.m.ActiveScreen.ID == "home", "native fire resolves overridden home screen");
expect(e.m.ActiveScreen.Options.len() == 4, "home has four reachable actions");
expect(e.m.ActiveScreen.Text.find("event_80.png") != null, "native illustration reference");
expect(e.m.ActiveScreen.Text.find("%") == null, "no unprepared interpolation variables");
expect(e.m.ActiveScreen.Options[2].getResult(e) == "formation:0", "formation entry");
expect(e.m.Selected.len() == 3 && A.Applied == 0, "draft selection does not apply");
local first = A.ledgerPage(e, "formation:0");
first.Options[0].getResult(e);
expect(e.m.Selected.find(1) == null && e.m.Selected.find(2) != null, "first row binds first ID");
first.Options[1].getResult(e);
expect(e.m.Selected.find(2) == null && e.m.Selected.find(3) != null, "second row binds distinct ID");
expect(A.Deployed.len() == 3 && A.Applied == 0, "toggling leaves live formation intact");
for (local offset = 0; offset < A.Brothers.len(); offset += 4) {
    local page = A.ledgerPage(e, "formation:" + offset);
    local rows = ::Math.min(4, A.Brothers.len() - offset);
    expect(page.Options.len() == rows + 2 && page.Options.len() <= 6, "member rows plus navigation at " + offset);
    expect(page.Options[rows + 1].getResult(e) == "formation_review", "review always reachable at " + offset);
    expect(page.Options[rows].getResult(e) == "formation:" + (offset + 4 >= A.Brothers.len() ? 0 : offset + 4), "pagination wraps correctly");
}
e.m.Selected = [];
for (local i = 1; i <= 10; i++) A.ledgerToggle(e, i);
A.ledgerToggle(e, 11);
expect(e.m.Selected.len() == 10 && e.m.Selected.find(11) == null, "eleventh selection rejected");
expect(e.m.Notice != "", "over-limit rejection explains reason");
A.CombatMax = 3;
e.m.Selected = [1, 2, 3];
A.ledgerToggle(e, 4);
expect(e.m.Selected.len() == 3 && e.m.Notice.find("3") != null, "draft cap comes from CombatMax");
A.CombatMax = 10;
local review = A.ledgerPage(e, "formation_review");
review.Options[2].getResult(e);
expect(A.Applied == 0 && A.Deployed.len() == 3 && e.m.Selected.len() == 0, "cancel never applies draft");
review = A.ledgerPage(e, "formation_review");
expect(review.Options[0].getResult(e) == "formation_review", "zero-person confirmation fails in place");
expect(e.m.Notice == "人数或地点不符合" && A.Deployed.len() == 3, "formation failure is shown without loss");
e.m.Selected = [1, 4];
review = A.ledgerPage(e, "formation_review");
expect(review.Options[0].getResult(e) == "home", "valid confirmation returns home");
expect(A.Deployed.len() == 2 && A.Deployed.find(4) != null && e.m.Selected.len() == 0, "only confirmation applies and clears draft");
local page = A.ledgerPage(e, "recruits");
expect(page.Options.len()==4,"fresh ledger lists only three known captains and return");
expect(page.Text.find("章")==null && page.Text.find("{")==null && page.Text.find("}")==null,"no chapters or raw braces");
foreach(key in A.CharacterOrder) {
    if(A.Characters[key].isCaptain)continue;
    local hidden=A.ledgerPage(e,"recruit:"+key);
    expect(hidden.Text.find(A.Characters[key].description)==null,"direct unknown profile cannot leak prose "+key);
    expect(A.ledgerPage(e,"encounter:"+key).Text.find(A.Characters[key].encounterText)==null,"direct unknown encounter cannot leak prose "+key);
    A.Known[key] <- true; A.RecruitState[key]="encounter";
}
for(local offset=0;offset<A.CharacterOrder.len();offset+=4) {
    local members=A.ledgerPage(e,"recruits:"+offset), count=::Math.min(4,A.CharacterOrder.len()-offset);
    expect(members.Options.len()<=6,"known member pagination fits");
    for(local i=0;i<count;i++)expect(members.Options[i].getResult(e)=="recruit:"+A.CharacterOrder[offset+i],"row captures distinct known member");
}
foreach(key in A.CharacterOrder)if(!A.Characters[key].isCaptain) {
    foreach(tavern in [false,true]) {
        A.Tavern=tavern;
        expect(A.ledgerPage(e,"recruit:"+key).Options.len()==2,"profile has navigation only "+key);
        expect(A.ledgerPage(e,"encounter:"+key).Options.len()==1,"legacy encounter cannot bypass hiring queue "+key);
        A.RecruitState[key]="available";
        expect(A.ledgerPage(e,"recruit:"+key).Options.len()==2,"available person still uses native hire UI "+key);
    }
}
expect(A.HireCalls.len()==0 && A.EncounterCalls.len()==0,"ledger never hires or charges an encounter fee");
// The paid service has a direct inn entry without exceeding native's six
// buttons, even when every known visitor is available on several pages.
A.treatmentLedgerPage <- function(event,page){return null;};
local visitors=[];
foreach(key in A.CharacterOrder)if(A.characterStatus(key)=="available")visitors.push(key);
for(local offset=0;offset<visitors.len();offset+=3) {
    local inn=A.ledgerPage(e,"tavern:"+offset),rows=::Math.min(3,visitors.len()-offset);
    expect(inn.Options.len()==rows+3&&inn.Options.len()<=6,"tavern visitors plus service, next and exit fit native buttons");
    for(local i=0;i<rows;i++)expect(inn.Options[i].getResult(e)=="recruit:"+visitors[offset+i],"tavern visitor pagination preserves order");
    expect(inn.Options[rows].getResult(e)=="tavern:"+(offset+rows>=visitors.len()?0:offset+rows),"tavern pagination wraps without skipping visitors");
    expect(inn.Options[rows+1].getResult(e)=="treatment","tavern has a direct treatment entry on every page");
    expect(inn.Options[rows+2].getResult(e)==0,"tavern exit remains reachable");
}
page = A.ledgerPage(e, "quest");
expect(page.Options.len() == 1, "ledger quest page is read-only");
expect(page.Options[0].getResult(e) == "home", "quest record returns to home");
expect(A.ledgerPage(e,"quest_cancel").Options.len() == 1, "old cancel route cannot mutate native contract");

e.onClear();
expect(e.m.Selected.len() == 0 && e.m.Notice == "" && e.m.AutoPage == "home", "closing drops UI-only state");

::Tactical <- { Active = false, State = null, function isActive() { return this.Active; } };
::LoadingScreen <- { Visible = false, function isVisible() { return this.Visible; }, function isAnimating() { return false; } };
::World <- {
    State = {
        m = {
            EventScreen = { Visible = false, function isVisible() { return this.Visible; }, function isAnimating() { return false; } },
            MenuStack = { Back = false, function hasBacksteps() { return this.Back; }, function isAllowingCancel() { return true; } },
            WorldTownScreen = { Visible = false, function isVisible() { return this.Visible; }, function isAnimating() { return false; },
                function getTavernDialogModule() { return { function isAnimating() { return false; } }; },
                function getTown() { return { function getID() { return 51; }, function isAlive() { return true; }, function isAlliedWithPlayer() { return true; } }; } }
        },
        TownOpens = 0,
        function getPlayer() { return {}; },
        function getCombatStartTime() { return 0; },
        function isInCharacterScreen() { return false; },
        function showEventScreenFromTown(event) { this.TownOpens++; }
    },
    Events = {
        m = { ActiveEvent = null, IsEventShown = false },
        Allow = true, Fires = 0,
        function hasActiveEvent() { return this.m.ActiveEvent != null; },
        function getEvent(id) { return id == "event.afeix_ledger" ? ::afeix_ledger_event : null; },
        function canFireEvent(a, b) { return this.Allow; },
        function fire(id, update) { this.Fires++; return true; }
    }
};
expect(A.openLedger() && ::World.Events.Fires == 1, "world map uses native event manager fire");
::World.Events.Allow = false;
expect(A.openLedger() && ::World.Events.Fires == 2, "manual reading ignores random-event proximity gate");
::World.Events.Allow = true;
::LoadingScreen.Visible = true;
expect(!A.openLedger(), "loading screen blocks ledger");
::LoadingScreen.Visible = false;
::Tactical.Active = true;
expect(!A.openLedger(), "battle blocks ledger");
::Tactical.Active = false;
::World.State.m.MenuStack.Back = true;
expect(!A.openLedger(), "other menus block town bypass");
::World.State.m.WorldTownScreen.Visible = true;
expect(A.openLedger() && ::World.State.TownOpens == 1 && ::World.Events.m.IsEventShown, "safe town uses town event path");
expect(!A.openLedger(), "active event blocks repeat F8");
print("TESTS_PASSED=" + checks + "\n");
