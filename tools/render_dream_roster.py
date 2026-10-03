"""Freeze ten native level-11 builds for the dream; no campaign data is modified.

The normal ten level-ups spend 30 selections. Gifted contributes its separate
three unstarred native maximum rolls, already spent in this exhibition roster.
Run --check to verify data and generated definitions without rewriting them.
"""
from pathlib import Path
import argparse
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs/design/balance-v2/proposal.json"
DATA = ROOT / "data/dream-roster.json"
RUNTIME = ROOT / "src/scripts/mods/afeix/dream_roster.nut"
BEGIN = "// BEGIN GENERATED DREAM ROSTER\n"
END = "// END GENERATED DREAM ROSTER\n"
ORDER = ["afei", "damou", "mocha", "bottle", "shuaizi", "lili", "xiaoyueya", "yuchujiu", "xiaoyubeike", "wangduidui"]


def item(path, name, **stats):
    return {"path": "scripts/items/" + path, "name": name, "stats": stats}


def named_weapon(kind, name):
    return item("weapons/named/named_" + kind, name)


def armor(name, heavy):
    # All values lie within the native named armor/helmet randomization ranges.
    if heavy:
        return [item("armor/named/brown_coat_of_plates_armor", name + "·守阵甲", Condition=360, ConditionMax=360, StaminaModifier=-27),
                item("helmets/named/named_metal_bull_helmet", name + "·铁角盔", Condition=360, ConditionMax=360, StaminaModifier=-18)]
    return [item("armor/named/black_leather_armor", name + "·夜行衣", Condition=138, ConditionMax=138, StaminaModifier=-8),
            item("helmets/named/norse_helmet", name + "·行旅盔", Condition=150, ConditionMax=150, StaminaModifier=-5)]


FRONT = ["colossus", "gifted", "fast_adaption", "mastery_sword", "rotation", "underdog", "nimble", "berserk", "killing_frenzy", "duelist"]
TANK = ["colossus", "gifted", "shield_expert", "taunt", "rotation", "steel_brow", "underdog", "battle_forged", "indomitable", "recover"]
RANGED = ["colossus", "gifted", "quick_hands", "mastery_crossbow", "bullseye", "footwork", "nimble", "berserk", "killing_frenzy", "overwhelm"]
CONFIG = {
    "afei": dict(place=4, heavy=False, perks=FRONT, gifted=[0, 4, 6], training="", route="feidie", weapon="sword", weapon_name="黑旗·归途", bag=[]),
    "damou": dict(place=3, heavy=True, perks=TANK, gifted=[0, 1, 6], training="borrow_strike", weapon="spear", weapon_name="大谋·守夜", shield=True, bag=[]),
    "mocha": dict(place=12, heavy=False, perks=RANGED, gifted=[0, 1, 5], training="abacus_mark", weapon="crossbow", weapon_name="抹茶·算无遗箭", ammo="bolts", bag=[named_weapon("dagger", "抹茶·备用零件")]),
    "bottle": dict(place=5, heavy=False, perks=FRONT, gifted=[0, 4, 6], training="bottle_breakthrough", weapon="sword", weapon_name="瓶队·决赛之刃", bag=[named_weapon("dagger", "瓶队·后手")]),
    "shuaizi": dict(place=2, heavy=True, perks=TANK, gifted=[0, 1, 6], training="drum", weapon="mace", weapon_name="帅仔·定音锤", shield=True, bag=[]),
    "lili": dict(place=13, heavy=False, perks=["mastery_bow" if p == "mastery_crossbow" else p for p in RANGED], gifted=[0, 1, 5], training="chaoju", weapon="warbow", weapon_name="李李·风中远声", ammo="arrows", bag=[named_weapon("dagger", "李李·脱困")]),
    "xiaoyueya": dict(place=15, heavy=False, perks=["colossus", "gifted", "quick_hands", "mastery_throwing", "bags_and_belts", "footwork", "nimble", "berserk", "killing_frenzy", "duelist"], gifted=[0, 5, 6], training="supermarket", weapon="javelin", weapon_name="小月牙·超市飞签", bag=[named_weapon("javelin", "小月牙·备用飞签"), named_weapon("throwing_axe", "小月牙·拆货斧"), named_weapon("dagger", "小月牙·开箱刀")]),
    "yuchujiu": dict(place=6, heavy=False, perks=["colossus", "gifted", "dodge", "relentless", "mastery_sword", "underdog", "nimble", "berserk", "killing_frenzy", "duelist"], gifted=[0, 4, 6], training="guard_swap", weapon="sword", weapon_name="初九·叫停之刃", bag=[named_weapon("dagger", "初九·归队")]),
    "xiaoyubeike": dict(place=7, heavy=True, perks=["colossus", "gifted", "pathfinder", "mastery_axe", "steel_brow", "underdog", "battle_forged", "brawny", "quick_hands", "fortified_mind"], gifted=[0, 1, 6], training="nicotine", weapon="greataxe", weapon_name="小鱼·踏浪巨斧", bag=[named_weapon("dagger", "小鱼·余力")]),
    "wangduidui": dict(place=14, heavy=False, perks=["colossus", "rally_the_troops", "gifted", "fortified_mind", "mastery_polearm", "rotation", "nimble", "fearsome", "recover", "bags_and_belts"], gifted=[0, 1, 2], training="dui_sentence", weapon="banner", weapon_name="黑旗·梦中誓言", bag=[named_weapon("battle_whip", "怼怼·传令鞭"), item("tools/reinforced_throwing_net", "怼怼·救场网")]),
}


def squirrel(value):
    if isinstance(value, dict):
        return "{" + ",".join("[" + json.dumps(k, ensure_ascii=False) + "]=" + squirrel(v) for k, v in value.items()) + "}"
    if isinstance(value, list):
        return "[" + ",".join(squirrel(v) for v in value) + "]"
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    return json.dumps(value, ensure_ascii=False)


def build_data():
    source = json.loads(SOURCE.read_text(encoding="utf-8"))
    profiles = {p["key"]: p for p in source["people"]}
    fields = source["fields"]
    people = {}
    for key in ORDER:
        p, config = profiles[key], CONFIG[key]
        remaining = list(p["allocation"])
        assert sum(remaining) == 30 and max(remaining) <= 10
        rows, totals, picked = [], [0] * 8, [0] * 8
        for level in range(10):
            indices = sorted(range(8), key=lambda i: (-remaining[i], i))[:3]
            assert all(remaining[i] > 0 for i in indices)
            gains = []
            for i in indices:
                star = p["stars"].get(fields[i], 0)
                low = source["growth_roll_min"][i] + (2 if star == 3 else star)
                high = source["growth_roll_max"][i] + (1 if star == 3 else 0)
                gain = (low + high + (picked[i] % 2)) // 2
                gains.append(gain)
                totals[i] += gain
                picked[i] += 1
                remaining[i] -= 1
            rows.append({"fields": indices, "gains": gains})
        assert remaining == [0] * 8
        gifted = [source["growth_roll_max"][i] if i in config["gifted"] else 0 for i in range(8)]
        base = [p["attrs"][i] - p["trait_delta"][i] + totals[i] + p["growth_bonus"][i] + gifted[i] for i in range(8)]
        equipment = [named_weapon(config["weapon"], config["weapon_name"]) if config["weapon"] != "banner" else item("weapons/afeix_dream_warbanner", config["weapon_name"])]
        if config.get("shield"):
            equipment.append(item("shields/named/named_golden_round_shield", p["name"] + "·不退之盾"))
        if config.get("ammo"):
            equipment.append(item("ammo/quiver_of_" + config["ammo"], ""))
        equipment.extend(armor(p["name"], config["heavy"]))
        people[key] = dict(name=p["name"], role=p["role"], place=config["place"], level=11,
            stars=p["stars"], starting_attrs=p["attrs"], trait_delta=p["trait_delta"], allocation=p["allocation"],
            level_rows=rows, growth_gain=totals, personal_choice=p["growth_pick"], personal_bonus=p["growth_bonus"],
            gifted_fields=config["gifted"], gifted_bonus=gifted, base_attrs=base,
            fixed_traits=p["fixed_traits"], perks=config["perks"], training=config["training"],
            route=config.get("route", "normal"), equipment=equipment, bag=config["bag"],
            level_bonus=p["level_bonus_per_level"], heavy=config["heavy"])
        assert len(set(config["perks"])) == 10
        assert config["training"] == "" or config["training"] in p["skills"]
    return dict(schema=1, level=11, order=ORDER, fields=fields, people=people,
        accounting="Ten native level-ups, 30 selections; Gifted separately spends 3 unstarred maximum rolls. Starting values include fixed traits; base_attrs subtract their delta once. Personal choice is a frozen dream example. Promotion and level bonuses remain native skills. Named weapons, armor, helmets and shields use native art; ammunition and utility tools keep their native type.",
        source="docs/design/balance-v2/proposal.json")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = build_data()
    serialized = json.dumps(data, ensure_ascii=False, indent=2) + "\n"
    generated = BEGIN + "A.DreamRoster <- " + squirrel(data) + ";\n" + END
    runtime = RUNTIME.read_text(encoding="utf-8")
    start, stop = runtime.index(BEGIN), runtime.index(END) + len(END)
    next_runtime = runtime[:start] + generated + runtime[stop:]
    if args.check:
        if DATA.read_text(encoding="utf-8") != serialized or runtime != next_runtime:
            raise SystemExit("Dream roster definitions are stale; run tools/render_dream_roster.py")
    else:
        DATA.write_text(serialized, encoding="utf-8")
        RUNTIME.write_text(next_runtime, encoding="utf-8")
    print("Dream roster: ten level-11 builds; 300 native selections plus 30 Gifted selections verified")


if __name__ == "__main__":
    main()
