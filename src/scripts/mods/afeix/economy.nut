// A completed contract is one sponsorship account, even when native rewards
// arrive in multiple payments. The rate is frozen at successful settlement.
local A = ::AfeixExpedition;
A.CircleContractCap <- 120;
A.noteCircleVictory <- function(id) {
    if (!this.isOrigin() || id == null || this.get("contract_terminal_" + id, 0) != 0) return;
    this.set("circle_victory_" + id, true);
};
A.lockCircleRate <- function(id, cancelled) {
    if (!this.isOrigin() || id == null || this.get("circle_rate_" + id, -1.0) >= 0) return;
    local rate = 0.0;
    if (!cancelled && this.get("circle_victory_" + id, false) && "circleRate" in this) {
        local afei = this.findCharacter("afei");
        if (afei != null && afei.isAlive()) rate = this.circleRate();
    }
    this.set("circle_rate_" + id, rate);
};
A.settleCircle <- function(id) {
    if (!this.isOrigin() || id == null || this.get("contract_terminal_" + id, 0) != 1) return 0;
    // Old v0.2 receipts have no rate snapshot and do not gain retroactive money.
    local rate = this.get("circle_rate_" + id, 0.0);
    if (rate <= 0.0) return 0;
    local received = this.get("contract_received_" + id, 0);
    local target = ::Math.min(rate>=0.08?120:80, ::Math.floor(received * rate).tointeger());
    local paid = this.get("circle_paid_" + id, 0);
    if (target <= paid) return 0;
    local day=::World.getTime().Days.tointeger(), used=0;
    for(local d=day-6;d<=day;d++)used+=this.get("v26_circle_day_"+d,0);
    local delta=::Math.min(target-paid,::Math.max(0,(rate>=0.08?360:240)-used));
    if(delta<=0){this.set("circle_paid_"+id,target);return 0;}
    local dayPaid=this.get("v26_circle_day_"+day,0);
    this.set("v26_circle_day_"+day,dayPaid+delta);
    // Commit the entitlement before calling the native wallet. Sponsorship is
    // not another contract receipt and cannot sponsor itself recursively.
    this.set("circle_paid_" + id, target);
    local before = ::World.Assets.getMoney();
    try {
        this.withPaymentContext(null, function(amount) { ::World.Assets.addMoney(amount); }, [this, delta]);
    } catch (error) {
        this.set("circle_paid_" + id, paid);
        this.set("v26_circle_day_"+day,dayPaid);
        throw error;
    }
    local actual = ::Math.max(0, ::World.Assets.getMoney() - before);
    this.set("circle_total", this.get("circle_total", 0) + actual);
    this.set("circle_last", actual);
    return actual;
};
A.circleSummary <- function() {
    return "全力圈累计赞助 " + this.get("circle_total", 0) + " 克朗。契约期间有胜战记录，且成功结算时阿飞以当前路线在队，才按实际收到的报酬取得赞助；嘉豪每份≤120、滚动7日≤360；飞碟每份≤80、滚动7日≤240克朗。分次到款补足差额，旧契约与重修不重复领奖。";
};
