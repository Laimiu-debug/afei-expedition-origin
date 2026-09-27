// Native contract lifecycle supplies town offers, HUD objectives and save data.
this.afeix_letter_contract <- this.inherit("scripts/contracts/contract", {
    m = {},
    function create() {
        this.contract.create();
        this.m.Type = "contract.afeix_letter";
        this.m.Name = "沿途送信";
        this.m.DifficultyMult = 0.75;
        this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 3.0;
    },
    function setup(destination, distance) {
        this.m.Flags.set("TargetID", destination.getID());
        this.m.Flags.set("TargetName", destination.getNameOnly());
        this.m.Flags.set("RoadTiles", distance);
        local reward = ::Math.min(450, ::Math.max(180, 120 + distance * 3));
        this.m.Flags.set("Reward", reward);
        this.m.Flags.set("Paid", false);
        this.m.BulletpointsObjectives = ["将信送到" + destination.getNameOnly()];
        this.m.BulletpointsPayment = ["交付后获得 " + reward + " 克朗"];
    },
    function onImportIntro() {},
    function destination() { return this.World.getEntityByID(this.m.Flags.get("TargetID")); },
    function canDeliver() {
        local target = this.destination();
        return this.isActive() && !this.m.Flags.get("Paid") && this.onIsValid()
            && this.isPlayerAt(target);
    },
    function acceptLetter() {
        if (this.World.Contracts.getActiveContract() != null || !this.isValid()) return false;
        local town = this.World.State.getCurrentTown();
        if (town == null || town.getID() != this.m.Home.getID()) return false;
        if (!::AfeixExpedition.letterSupplyReady(this.m.Home, this.destination())) return false;
        ::AfeixExpedition.consumeLetterSupply(this.m.Home, this.destination());
        this.m.Flags.set("SupplyCharged", true);
        this.m.IsNegotiated = true;
        this.World.Contracts.setActiveContract(this);
        this.setState("Running");
        this.World.uncoverFogOfWar(this.destination().getTile().Pos, 200.0);
        return true;
    },
    function deliverLetter() {
        if (!this.canDeliver()) return false;
        this.m.Flags.set("Paid", true);
        // The shared receipt adapter counts this native contract exactly once.
        this.World.Assets.addMoney(this.m.Flags.get("Reward"));
        this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
        this.World.FactionManager.getFaction(this.getFaction()).addPlayerRelation(
            this.Const.World.Assets.RelationCivilianContractSuccess, "送达信件");
        this.World.Contracts.finishActiveContract();
        return true;
    },
    function createStates() {
        this.m.States.push({ ID = "Offer", function start() { this.Contract.setScreen("Task"); } });
        this.m.States.push({
            ID = "Running",
            function start() {
                local target = this.Contract.destination();
                if (target != null && target.isAlive()) target.getSprite("selection").Visible = true;
            },
            function update() {
                if (this.Contract.m.ActiveScreen != null || this.World.Events.hasActiveEvent()) return;
                if (!this.Contract.onIsValid()) {
                    this.Contract.setScreen("Unavailable");
                    this.World.Contracts.showActiveContract();
                } else if (this.Contract.canDeliver()) {
                    this.Contract.setScreen("Success");
                    this.World.Contracts.showActiveContract();
                }
            }
        });
    },
    function createScreens() {
        this.m.Screens.push({
            ID = "Task", Title = "沿途送信", Image = "", List = [], ShowObjectives = true,
            Text = "[img]gfx/ui/events/event_112.png[/img]书记官把封好的信推过桌面。\n\n“替我送到%letter_target%，交到那里的收信人手里，%letter_reward% 克朗当面结清。地址和报酬都写在这里，看看是否顺路。”\n\n你看了一眼地址，把这趟差事和接下来的行程对了对。",
            Options = [
                { Text = "接下这份差事。", function getResult() { return this.Contract.acceptLetter() ? 0 : "Unavailable"; } },
                { Text = "容我考虑一下。", function getResult() { return 0; } }
            ]
        });
        this.m.Screens.push({
            ID = "Success", Title = "信已送到", Image = "", List = [],
            Text = "[img]gfx/ui/events/event_80.png[/img]%letter_target%的收信人核对了封口，将一袋钱放到桌上。\n\n“路上辛苦。这是说好的 %letter_reward% 克朗。”",
            Options = [{ Text = "交出信件，收下报酬。", function getResult() { return this.Contract.deliverLetter() ? 0 : "Unavailable"; } }]
        });
        this.m.Screens.push({
            ID = "Unavailable", Title = "差事有变", Image = "", List = [],
            Text = "[img]gfx/ui/events/event_80.png[/img]这份信眼下已无法照约定交付。双方撤回委托，不结算报酬，也不追究违约。",
            Options = [{ Text = "收起委托，继续上路。", function getResult() {
                if (this.Contract.isActive()) this.World.Contracts.finishActiveContract(true);
                else this.World.Contracts.removeContract(this.Contract);
                return 0;
            } }]
        });
    },
    function onPrepareVariables(vars) {
        vars.push(["letter_target", this.m.Flags.get("TargetName")]);
        vars.push(["letter_reward", this.m.Flags.get("Reward")]);
    },
    function onIsValid() {
        local target = this.destination();
        return target != null && target.isAlive() && target.isAlliedWithPlayer();
    },
    function onIsTileUsed(tile) {
        local target = this.destination();
        return target != null && target.isAlive() && tile.ID == target.getTile().ID;
    },
    function onClear() {
        local target = this.destination();
        if (this.isActive() && target != null && target.isAlive()) target.getSprite("selection").Visible = false;
    }
});
