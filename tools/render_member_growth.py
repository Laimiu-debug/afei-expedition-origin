"""Validate authored growth stories and render their data block into Squirrel.

Run from any directory. --check is read-only and fails on schema or generated drift.
Only the marked MemberGrowth block is generated; runtime logic stays hand authored.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data/member-growth.json"
STORIES = ROOT / "data/character-stories.json"
TARGET = ROOT / "src/scripts/mods/afeix/story_progress.nut"
FIELDS = {"Hitpoints", "Stamina", "Bravery", "Initiative", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense"}
START = "// BEGIN GENERATED MEMBER GROWTH"
END = "// END GENERATED MEMBER GROWTH"


def squirrel(value, depth=0):
    pad = "    " * depth
    if value is None:
        return "null"
    if isinstance(value, str):
        return json.dumps(value, ensure_ascii=False)
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, list):
        return "[\n" + ",\n".join(pad + "    " + squirrel(x, depth + 1) for x in value) + "\n" + pad + "]"
    if isinstance(value, dict):
        assert all(re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", key) for key in value)
        return "{\n" + ",\n".join(pad + "    " + key + " = " + squirrel(item, depth + 1) for key, item in value.items()) + "\n" + pad + "}"
    raise TypeError(type(value))


def validate(data):
    stories = json.loads(STORIES.read_text(encoding="utf-8"))["characters"]
    assert data["schema"] == 1
    assert data["requirements"] == {"level": 3, "battles": 3}
    records = data["characters"]
    assert [(x["key"], x["name"]) for x in records] == [(x["key"], x["name"]) for x in stories]
    assert len(records) == 34 and len({x["key"] for x in records}) == 34
    assert len({x["scene"] for x in records}) == 34
    for record in records:
        assert record["title"] and record["scene"]
        assert len(record["choices"]) == 2
        for option in record["choices"]:
            assert option["label"] and option["outcome"] and option["traitName"]
            assert option["bonuses"] and set(option["bonuses"]) <= FIELDS
            assert all(type(n) is int and 1 <= n <= 6 for n in option["bonuses"].values())
        assert record["choices"][0]["bonuses"] != record["choices"][1]["bonuses"]
    return records


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = json.loads(DATA.read_text(encoding="utf-8"))
    records = validate(data)
    table = {record["key"]: {key: record[key] for key in ["title", "scene", "choices"]} for record in records}
    generated = START + "\nA.MemberGrowth <- " + squirrel(table) + ";\n" + END
    current = TARGET.read_text(encoding="utf-8")
    pattern = re.compile(re.escape(START) + r".*?" + re.escape(END), re.S)
    assert len(pattern.findall(current)) == 1, "Expected one generated block"
    result = pattern.sub(lambda _: generated, current)
    if args.check:
        assert result == current, "Member growth Squirrel data is out of date"
    else:
        TARGET.write_text(result, encoding="utf-8", newline="\n")
    print("MEMBER_GROWTH_DATA_PASSED=34")


if __name__ == "__main__":
    main()
