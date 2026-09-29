local A = ::AfeixExpedition;
A.deployedIds <- function() {
    local ids = [];
    foreach (bro in this.roster()) {
        local place = bro.getPlaceInFormation();
        if (place >= 0 && place < 18) ids.push(bro.getID());
    }
    return ids;
};

// Pure planning: an invalid selection never changes a brother's current position.
A.planFormation <- function(brothers, selected = null) {
    local byId = {}, chosen = [], seen = {}, used = {}, plan = [];
    foreach (bro in brothers) byId[bro.getID()] <- bro;
    if (selected != null) {
        if (selected.len() < 1 || selected.len() > this.CombatMax)
            return { ok = false, text = "请选择 1 到 " + this.CombatMax + " 名出战成员。", plan = [] };
        foreach (id in selected) {
            if (!(id in byId)) return { ok = false, text = "名单已变化，请重新打开编队。", plan = [] };
            if (id in seen) return { ok = false, text = "同一成员不能重复占位。", plan = [] };
            seen[id] <- true; chosen.push(byId[id]);
        }
    } else {
        // Keep explicit reserves in reserve. Only genuinely unplaced new recruits fill gaps.
        local ordered = clone brothers;
        ordered.sort(function(a, b) { return a.getPlaceInFormation() <=> b.getPlaceInFormation(); });
        foreach (bro in ordered) {
            local p = bro.getPlaceInFormation();
            if (p >= 0 && p < 18 && chosen.len() < this.CombatMax) {
                chosen.push(bro); seen[bro.getID()] <- true;
            }
        }
        foreach (bro in brothers) {
            if (bro.getPlaceInFormation() == 255 && chosen.len() < this.CombatMax && !(bro.getID() in seen)) {
                chosen.push(bro); seen[bro.getID()] <- true;
            }
        }
        if (chosen.len() == 0 && brothers.len() > 0) {
            chosen.push(brothers[0]); seen[brothers[0].getID()] <- true;
        }
    }
    local pending = [];
    foreach (bro in chosen) {
        local p = bro.getPlaceInFormation();
        if (p >= 0 && p < 18 && !(p in used)) {
            plan.push({ bro = bro, place = p }); used[p] <- true;
        } else pending.push(bro);
    }
    local order = [3, 4, 5, 2, 6, 12, 13, 14, 11, 15, 1, 7, 10, 16, 0, 8, 9, 17];
    foreach (bro in pending) {
        foreach (p in order) if (!(p in used)) { plan.push({ bro = bro, place = p }); used[p] <- true; break; }
    }
    // A compact reserve sequence can exceed native slot 26; the UI adapter adds those slots.
    local reserve = 18;
    foreach (bro in brothers) if (!(bro.getID() in seen)) plan.push({ bro = bro, place = reserve++ });
    return { ok = true, text = "出战 " + chosen.len() + " 人，其余成员待命。", plan = plan };
};
A.enforceFormation <- function() {
    if (!this.isOrigin()) return;
    local result = this.planFormation(this.roster());
    foreach (entry in result.plan) entry.bro.setPlaceInFormation(entry.place);
};
A.applyFormation <- function(selected) {
    if (!this.canManage()) return this.result(false, "请在友好城镇附近或安全扎营时调整编队。");
    local result = this.planFormation(this.roster(), selected);
    if (!result.ok) return this.result(false, result.text);
    foreach (entry in result.plan) entry.bro.setPlaceInFormation(entry.place);
    return this.result(true, result.text);
};
A.formation <- function() {
    this.enforceFormation();
    local ret = [];
    ret.resize(::Math.max(27, 18 + this.roster().len()), null);
    foreach (bro in this.roster()) ret[bro.getPlaceInFormation()] = bro;
    return ret;
};
