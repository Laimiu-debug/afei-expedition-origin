"""Cross-check dream references and valid named armor rolls against game archives."""
from pathlib import Path
from zipfile import ZipFile
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]


def main():
    subprocess.run([sys.executable, str(ROOT / "tools/render_dream_roster.py"), "--check"], cwd=ROOT, check=True)
    data = json.loads((ROOT / "data/dream-roster.json").read_text(encoding="utf-8"))
    sources = json.loads((ROOT / "docs/design/balance-v2/proposal.json").read_text(encoding="utf-8"))
    index = set()
    for archive in Path("F:/SteamLibrary/steamapps/common/Battle Brothers/data").glob("data_*.dat"):
        with ZipFile(archive) as z:
            index.update(z.namelist())
    if not index:
        raise RuntimeError("Native game archives are required to verify dream equipment references")
    checks = 0

    def expect(ok, description):
        nonlocal checks
        if not ok:
            raise AssertionError(description)
        checks += 1

    for key in data["order"]:
        p = data["people"][key]
        for perk in p["perks"]:
            expect("scripts/skills/perks/perk_" + perk + ".cnut" in index, key + " native perk " + perk)
        for item in p["equipment"] + p["bag"]:
            path = item["path"]
            expect(path + ".cnut" in index or (ROOT / "src" / (path + ".nut")).is_file(), key + " item " + path)
            if "/armor/" in path or "/helmets/" in path or "/shields/" in path or "/weapons/" in path:
                expect("/named/" in path or path.endswith("afeix_dream_warbanner"), key + " combat equipment is named")
            if item["stats"]:
                expect(item["stats"]["Condition"] == item["stats"]["ConditionMax"] > 0, key + " armor pristine and bounded")
        expect("nimble" in p["perks"] if not p["heavy"] else "battle_forged" in p["perks"], key + " defense perk matches armor")
        expect(not ("nimble" in p["perks"] and "battle_forged" in p["perks"]), key + " mutually exclusive armor build")
        if "duelist" in p["perks"]:
            expect(all("/shields/" not in item["path"] for item in p["equipment"]), key + " Duelist has empty offhand")
        expect(len(p["bag"]) <= (4 if "bags_and_belts" in p["perks"] else 2), key + " native bag capacity")
    # Native named ranges independently read from audited base item creation:
    # black_leather: 115 armor/-12 fatigue; norse: 125/-6;
    # brown_coat: 300/-36; metal_bull: 300/-22.
    baseline = {"black_leather_armor": (115, -12, 3, 9, -8), "norse_helmet": (125, -6, 1, 4, -4),
                "brown_coat_of_plates_armor": (300, -36, 3, 9, -8), "named_metal_bull_helmet": (300, -22, 1, 4, -4)}
    for p in data["people"].values():
        for item in p["equipment"]:
            kind = item["path"].split("/")[-1]
            if kind not in baseline:
                continue
            armor, fatigue, low, high, cap = baseline[kind]
            stats = item["stats"]
            expect(stats["ConditionMax"] in {armor * n // 100 for n in range(110, 126)}, kind + " native armor roll")
            expect(stats["StaminaModifier"] in {min(cap, fatigue + n) for n in range(low, high + 1)}, kind + " native fatigue roll")
    expected = [p["key"] for p in sources["people"] if p["group"] == "刀一黑队"]
    expect(data["order"] == expected, "the entire current ten-person black team, no extra member")
    print(f"TESTS_PASSED={checks}")


if __name__ == "__main__":
    main()
