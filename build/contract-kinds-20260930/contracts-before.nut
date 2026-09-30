// Observe real positive payments while native contract callbacks execute.
// The context is runtime-only; receipts and terminal state use World.Flags.
local A = ::AfeixExpedition;
A.PaymentContext <- null;
A.isCourierContract <- function(kind) { return kind == "contract.afeix_letter" || kind == "contract.deliver_item"; };
A.noteContractType <- function(contract) {
    if (this.isOrigin() && "getType" in contract)
        this.set("contract_type_" + contract.getID(), contract.getType());
};

A.withPaymentContext <- function(id, callback, args) {
    local previous = this.PaymentContext;
    this.PaymentContext = id;
    local result = null;
    try { result = callback.bindenv(args[0]).acall(args); }
    catch (error) { this.PaymentContext = previous; throw error; }
    this.PaymentContext = previous;
    return result;
};

A.wrapContractCallback <- function(callback) {
    return function(...) {
        local A = ::AfeixExpedition, args = [this];
        args.extend(vargv);
        A.noteContractType(this);
        return A.withPaymentContext(A.isOrigin() ? this.getID() : null, callback, args);
    };
};

A.wrapNonContractCallback <- function(callback) {
    return function(...) {
        local A = ::AfeixExpedition, args = [this];
        args.extend(vargv);
        // A synchronously opened event must not inherit a contract's money tag.
        return A.withPaymentContext(null, callback, args);
    };
};

A.tryRecordPaidContract <- function(id) {
    if (!this.isOrigin() || id == null || this.get("contract_terminal_" + id, 0) != 1) return false;
    local received = this.get("contract_received_" + id, 0);
    if (received <= 0) return false;
    local recorded = this.recordContract(id, false, received);
    if ("settleCircle" in this) this.settleCircle(id);
    return recorded;
};

A.noteContractIncome <- function(id, amount) {
    if (!this.isOrigin() || id == null || amount <= 0) return false;
    this.set("contract_received_" + id, this.get("contract_received_" + id, 0) + amount);
    // A screen can call finishActiveContract before it adds the final reward.
    return this.tryRecordPaidContract(id);
};

A.finishContractPayment <- function(id, cancelled) {
    if (!this.isOrigin() || id == null) return false;
    // 0=pending, 1=success, 2=cancelled. Terminal states cannot be replayed into
    // another result; recordContract supplies the persistent completion guard.
    if (this.get("contract_terminal_" + id, 0) == 0) {
        if ("lockCircleRate" in this) this.lockCircleRate(id, cancelled);
        this.set("contract_terminal_" + id, cancelled ? 2 : 1);
    }
    return this.tryRecordPaidContract(id);
};
