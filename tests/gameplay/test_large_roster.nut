// Capacity regression: real core/formation code, fake world and persistent
// brothers. This verifies logic and U8 bounds, not an engine save/load or UI run.
local passed = 0;
local check = function(value, message) {
    if (!value) throw "FAIL " + message;
    passed++;
};
local members = [], origin = true, safe = true;
::Math <- { function max(a, b) { return a > b ? a : b; } };
::World <- {
    Assets = { function getOrigin() { return {
        function getID() { return origin ? "scenario.afeix_expedition" : "scenario.other"; }
    }; } },
    function getPlayerRoster() { return { function getAll() { return members; } }; }
};
::AfeixExpedition <- { CombatMax = 12, RosterMax = 40 };
dofile("src/scripts/mods/afeix/core.nut");
dofile("src/scripts/mods/afeix/formation.nut");
local A = ::AfeixExpedition;
A.canManage = function() { return safe && this.isOrigin(); };
local makeBrother = function(id, position) { return {
    id = id, place = position, xp = 700 + id, hp = 20 + id,
    injuries = ["saved_injury_" + id], equipment = { weapon = "saved_weapon_" + id },
    function getID() { return this.id; },
    function getPlaceInFormation() { return this.place; },
    function setPlaceInFormation(value) { this.place = value; }
}; };
local snapshot = function() {
    local result = {};
    foreach (bro in members) result[bro.id] <- {
        bro = bro, place = bro.place, xp = bro.xp, hp = bro.hp,
        injuries = bro.injuries, equipment = bro.equipment
    };
    return result;
};
local verifyCompany = function(before, count, context) {
    local seenIds = {}, seenPositions = {}, active = 0;
    check(members.len() == before.len(), context + " company size preserved");
    foreach (bro in members) {
        check(!(bro.id in seenIds) && bro.id in before, context + " identities unique");
        seenIds[bro.id] <- true;
        check(!(bro.place in seenPositions), context + " positions unique");
        seenPositions[bro.place] <- true;
        // Native player serializes PlaceInFormation with writeU8/readU8;
        // 255 remains reserved for an as-yet-unplaced recruit.
        check(bro.place >= 0 && bro.place < 255, context + " valid U8 position");
        if (bro.place < 18) active++;
        local old = before[bro.id];
        check(bro == old.bro && bro.xp == old.xp && bro.hp == old.hp
            && bro.injuries == old.injuries && bro.injuries[0] == "saved_injury_" + bro.id
            && bro.equipment == old.equipment && bro.equipment.weapon == "saved_weapon_" + bro.id,
            context + " experience injuries and equipment unchanged");
    }
    check(active == count, context + " exact active count");
    local board = A.formation(), found = {};
    check(board.len() == 18 + members.len(), context + " enlarged board length");
    foreach (position, bro in board) if (bro != null) {
        check(!(bro.id in found) && bro.place == position && bro == before[bro.id].bro,
            context + " board preserves entity identity and position");
        found[bro.id] <- true;
    }
    check(found.len() == members.len(), context + " board contains every member");
};
try {
    foreach (size in [35, 40]) {
        for (local count = 1; count <= 12; count++) {
            members = [];
            for (local i = 0; i < size; i++) members.push(makeBrother(i + 1, 255));
            local before = snapshot(), selected = [];
            // Select from the end to exercise the names which were outside the
            // old 20-person company limit, including the final ordinary hire.
            for (local i = 0; i < count; i++) selected.push(size - i);
            local context = size + " members / " + count + " deployed";
            check(A.applyFormation(selected).ok, context + " valid selection accepted");
            local actual = A.deployedIds();
            check(actual.len() == count, context + " deployed ID count");
            foreach (id in selected) check(actual.find(id) != null, context + " chosen ID deployed");
            verifyCompany(before, count, context);
            if (size == 40 && count == 1) {
                local maxPosition = 0;
                foreach (bro in members) if (bro.place > maxPosition) maxPosition = bro.place;
                check(maxPosition == 56 && A.formation().len() == 58, "forty members use last occupied slot 56 within 58-slot UI");
            }
            local stable = snapshot();
            A.enforceFormation(); A.formation();
            foreach (bro in members) check(bro.place == stable[bro.id].place, context + " refresh preserves exact position");
            foreach (invalid in [[], [size, size], [99999], [1,2,3,4,5,6,7,8,9,10,11,12,13]]) {
                check(!A.applyFormation(invalid).ok, context + " invalid selection rejected");
                foreach (bro in members) check(bro.place == stable[bro.id].place, context + " invalid selection leaves company unchanged");
            }
            safe = false;
            check(!A.applyFormation([1]).ok, context + " unsafe formation changes rejected");
            safe = true;
            origin = false;
            A.enforceFormation();
            check(!A.applyFormation([1]).ok, context + " other origin cannot change formation");
            foreach (bro in members) check(bro.place == stable[bro.id].place, context + " other origin leaves positions unchanged");
            origin = true;
        }
    }
    // Raising the limit must preserve a previously saved smaller selection and
    // explicit standby members. New standby members use valid reserve positions.
    foreach (oldActiveCount in [1, 5, 10]) {
        members = [];
        for (local i = 0; i < 20; i++) members.push(makeBrother(i + 1, 255));
        local selected = [];
        for (local i = 0; i < oldActiveCount; i++) selected.push(i + 1);
        A.applyFormation(selected);
        local old = snapshot();
        for (local i = 20; i < 40; i++) members.push(makeBrother(i + 1, 18 + i - oldActiveCount));
        local all = snapshot();
        A.enforceFormation();
        verifyCompany(all, oldActiveCount, "old twenty extended to forty");
        foreach (id, state in old) check(state.bro.place == state.place, "old selected and standby positions preserved");
    }
    // Existing explicit reserves stay benched even when new unplaced recruits
    // fill remaining vacancies; a higher capacity does not redeploy veterans.
    members = [];
    for (local i = 0; i < 20; i++) members.push(makeBrother(i + 1, 255));
    A.applyFormation([1]);
    local old = snapshot();
    for (local i = 20; i < 40; i++) members.push(makeBrother(i + 1, 255));
    local all = snapshot();
    A.enforceFormation();
    verifyCompany(all, 12, "old twenty with twenty new unplaced hires");
    check(members[0].place == old[1].place, "old selected veteran keeps original battle position");
    for (local i = 1; i < 20; i++) check(members[i].place >= 18, "old standby veteran is not automatically redeployed");
    print("ALL_LARGE_ROSTER_CHECKS_PASS\nTESTS_PASSED=" + passed + "\n");
} catch (error) {
    print(error + "\n");
    if ("exit" in getroottable()) exit(1);
    throw error;
}
