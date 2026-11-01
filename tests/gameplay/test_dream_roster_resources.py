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
                "brown_coat_of_plates_armor": (300, -36, 3, 9, -8), "named_metal_bull_helmet": (300, -22, 1, 4, -4),
                "named_noble_mail_armor": (160, -15, 3, 9, -8), "blue_studded_mail_armor": (140, -16, 3, 9, -8),
                "named_plated_fur_armor": (130, -14, 3, 9, -8), "green_coat_of_plates_armor": (320, -42, 3, 9, -8),
                "leopard_armor": (290, -35, 3, 9, -8), "wolf_helmet": (140, -8, 1, 4, -4),
                "heraldic_mail_helmet": (280, -19, 1, 4, -4), "golden_feathers_helmet": (240, -16, 1, 4, -4)}
    outfits = set()
    for p in data["people"].values():
        outfit = tuple(i["path"] for i in p["equipment"] if "/armor/" in i["path"] or "/helmets/" in i["path"])
        expect(len(outfit) == 2 and outfit not in outfits, p["name"] + " has a distinct native armor and helmet pair")
        outfits.add(outfit)
        fatigue = -sum(i["stats"]["StaminaModifier"] for i in p["equipment"] if "/armor/" in i["path"] or "/helmets/" in i["path"])
        expect(p["heavy"] or fatigue <= 15, p["name"] + " preserves full Nimble protection")
        for item in p["equipment"]:
            kind = item["path"].split("/")[-1]
            if "/armor/" not in item["path"] and "/helmets/" not in item["path"]:
                continue
            expect(kind in baseline, kind + " native baseline audited")
            armor, fatigue, low, high, cap = baseline[kind]
            stats = item["stats"]
            expect(stats["ConditionMax"] in {armor * n // 100 for n in range(110, 126)}, kind + " native armor roll")
            expect(stats["StaminaModifier"] in {min(cap, fatigue + n) for n in range(low, high + 1)}, kind + " native fatigue roll")
    expected = [p["key"] for p in sources["people"] if p["group"] == "刀一黑队"]
    ecig = "scripts/items/accessory/afeix_ecig_item"
    expect(sum(i["path"] == ecig for i in data["people"]["afei"]["equipment"]) == 1, "dream Afei equips exactly one ecig")
    expect(all(i["path"] != ecig for key, p in data["people"].items() if key != "afei" for i in p["equipment"] + p["bag"]), "dream ecig only belongs to Afei")
    expect(data["order"] == expected, "the entire current ten-person black team, no extra member")
    print(f"TESTS_PASSED={checks}")


if __name__ == "__main__":
    main()
