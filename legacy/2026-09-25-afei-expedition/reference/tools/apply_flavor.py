"""Merge flavor-v0.6.2.json into document data, then regenerate definitions and backgrounds."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
DOC = json.loads((ROOT / "data/document-v0.6.2.json").read_text(encoding="utf-8"))
FLAVOR = json.loads((ROOT / "data/flavor-v0.6.2.json").read_text(encoding="utf-8"))
EQ = json.loads((ROOT / "data/equipment.json").read_text(encoding="utf-8"))

missing = [cid for cid in DOC if cid not in FLAVOR]
extra = [cid for cid in FLAVOR if cid not in DOC]
if missing or extra:
    raise SystemExit(f"flavor mismatch missing={missing} extra={extra}")

for cid, d in DOC.items():
    f = FLAVOR[cid]
    skill_ids = {s["id"] for s in d["skills"]}
    flavor_ids = set(f["skills"])
    if skill_ids != flavor_ids:
        raise SystemExit(f"{cid} skill mismatch {skill_ids ^ flavor_ids}")
    d["title"] = f["title"]
    d["blurb"] = f["blurb"]
    # 名册/背景描述不走原版变量替换（buildText 直通），%name% 在生成时烘焙成固定名字；
    # GoodEnding/BadEnding 保留 %name%，由原版结局屏替换。
    d["story"] = f["story"].replace("%name%", d["name"])
    d["good_ending"] = f.get("good_ending", "把名字留在下一封信里。")
    d["bad_ending"] = f.get("bad_ending", "黑旗名册留下了这一行。")
    for s in d["skills"]:
        sf = f["skills"][s["id"]]
        s["flavor"] = sf["flavor"]
        s["effects"] = sf["effects"]
        # Keep full rules in text for ledger "详细规则" if needed; UI uses flavor.
        if "text" not in s or not s["text"]:
            s["text"] = sf["flavor"]

(ROOT / "data/document-v0.6.2.json").write_text(
    json.dumps(DOC, ensure_ascii=False, indent=2), encoding="utf-8"
)


def q(s):
    return json.dumps(s, ensure_ascii=False)


def sq(v):
    if isinstance(v, dict):
        return "{" + ",".join("[" + sq(k) + "]=" + sq(x) for k, x in v.items()) + "}"
    if isinstance(v, list):
        return "[" + ",".join(map(sq, v)) + "]"
    return json.dumps(v, ensure_ascii=False)


world = {"steal_bro", "supermarket", "scout_path", "one_more_night", "moon_cake", "budget_share"}
specs = {
    "wawa_call": (4, 16, "self", 0, 0, 0),
    "toad_escape": (3, 10, "empty", 1, 0, 1),
    "full_circle": (4, 30, "self", 0, 0, 1),
    "abacus_mark": (3, 10, "enemy", 4, 2, 0),
    "shadow_captain": (4, 15, "ally", 4, 0, 0),
    "borrow_strike": (2, 8, "ally", 3, 3, 0),
    "bottle_breakthrough": (4, 18, "enemy", 1, 2, 0),
    "unselectable": (4, 20, "self", 0, 0, 1),
    "dog_bark": (3, 12, "enemy", 3, 2, 0),
    "guard_swap": (3, 15, "ally", 1, 0, 1),
    "nicotine": (2, 0, "self", 0, 0, 1),
    "cover_up": (4, 20, "ally", 1, 3, 0),
    "drum": (4, 16, "self", 0, 0, 0),
    "guard_gate": (3, 12, "self", 0, 2, 0),
    "prince_order": (4, 15, "self", 0, 0, 0),
    "dui_sentence": (3, 10, "ally", 3, 2, 0),
    "steady_hand": (4, 18, "ally", 4, 0, 0),
    "catch_rear": (4, 18, "enemy", 4, 3, 0),
    "gaga_charge": (6, 22, "empty", 1, 3, 0),
    "guard_nest": (3, 15, "self", 0, 2, 0),
    "lock_wagon": (4, 15, "empty", 1, 0, 2),
    "spare_key": (3, 10, "ally_self", 1, 2, 0),
    "foot_point": (4, 12, "empty", 2, 2, 0),
    "hard_brake": (3, 14, "self", 0, 3, 0),
    "return_road": (4, 18, "ally", 1, 0, 1),
    "pokemon": (4, 16, "ally", 4, 3, 0),
    "bear_strike": (3, 12, "enemy", 3, 2, 2),
    "cup_signal": (4, 15, "ally", 3, 0, 0),
    "mouth_strong": (2, 8, "enemy", 1, 3, 0),
    "shrink_cover": (4, 18, "self", 0, 3, 0),
    "long_watch": (4, 18, "self", 0, 2, 0),
    "king_dance": (4, 16, "empty", 1, 2, 0),
    "curtain_yield": (2, 8, "empty", 1, 1, 0),
    "guard_self": (4, 16, "self", 0, 2, 0),
    "short_sprint": (3, 14, "empty", 2, 3, 0),
    "snake_trial": (4, 16, "enemy", 1, 0, 0),
    "hold_curtain": (4, 18, "self", 0, 2, 0),
    "breach_strike": (6, 24, "enemy", 2, 2, 0),
    "line_detour": (3, 12, "empty", 1, 2, 0),
    "catch_baton": (2, 10, "ally", 2, 1, 0),
    "door_block": (4, 15, "enemy", 1, 2, 0),
    "pang_share": (3, 12, "ally", 1, 2, 0),
    "berry_mark": (3, 10, "enemy", 4, 2, 0),
}
orders = {"wawa_call", "shadow_captain", "drum", "prince_order", "steady_hand", "cup_signal", "full_circle"}
weapons = {"bottle_breakthrough", "catch_rear", "gaga_charge", "snake_trial", "breach_strike"}

skills = {}
for cid, d in DOC.items():
    for a in d["skills"]:
        s = dict(a)
        sid = s["id"]
        s.update(
            owner=cid,
            active=sid in specs,
            world=sid in world,
            order=sid in orders,
            weapon=sid in weapons,
        )
        s.update(dict(zip(["ap", "fatigue", "target", "range", "cooldown", "limit"], specs.get(sid, (0, 0, "self", 0, 0, 0)))))
        # UI primary description is flavor
        s["description"] = s.get("flavor") or s.get("text", "")
        skills[sid] = s
        (SRC / f"scripts/skills/actives/afei_{sid}.nut").write_text(
            f'this.afei_{sid} <- this.inherit("scripts/skills/afei_skill", {{ function create() {{ this.configure("{sid}"); }} }});\n',
            encoding="utf-8",
        )

art_events = sorted(p.stem[5:] for p in (SRC / "gfx/ui/events").glob("afei_*.png"))
art_skills = sorted(p.stem[5:] for p in (SRC / "gfx/skills").glob("afei_*.png"))
(SRC / "scripts/mods/afei/definitions.nut").write_text(
    "// Generated document definitions with flavor.\n::AfeiExpedition.Characters <- "
    + sq(DOC)
    + ";\n::AfeiExpedition.SkillDefs <- "
    + sq(skills)
    + ";\n::AfeiExpedition.Art <- "
    + sq({"events": {e: True for e in art_events}, "skills": {s: True for s in art_skills}})
    + ";\n",
    encoding="utf-8",
)
print(f"art manifest: {len(art_events)} event images, {len(art_skills)} skill icons")

for cid, d in DOC.items():
    bg = d["background"]
    path = SRC / "scripts/skills/backgrounds" / f"{bg}.nut"
    old = path.read_text(encoding="utf-8") if path.exists() else ""
    # The roster has exactly three men. Keep this rule explicit so regenerating
    # backgrounds can never turn the women back into vanilla male bodies.
    faces = "AllMale" if cid in {"C01", "C02", "C03"} else "AllFemale"
    equip = EQ.get(cid, {"equipped": [], "bag": []})
    lines = "\n".join(f'        items.equip(this.new("scripts/items/{item}"));' for item in equip.get("equipped", []))
    if equip.get("bag"):
        lines += "\n" + "\n".join(f'        items.addToBag(this.new("scripts/items/{item}"));' for item in equip["bag"])
    display = d["name"] + " · " + d.get("title", "黑旗伙伴")
    path.write_text(
        f'''this.{bg} <- this.inherit("scripts/skills/backgrounds/character_background", {{
 m={{}},
 function create() {{
   this.character_background.create();
   this.m.ID="background.{bg.removesuffix("_background")}";
   this.m.Name={q(display)};
   this.m.Icon="ui/backgrounds/background_15.png";
   this.m.BackgroundDescription={q(d["blurb"])};
   this.m.GoodEnding={q(d["good_ending"])};
   this.m.BadEnding={q(d["bad_ending"])};
   this.m.HiringCost=0;this.m.DailyCost={d["wage"]};this.m.DailyCostMult=1.0;this.m.Excluded=[];
   this.m.Faces=this.Const.Faces.{faces};this.m.Hairs=this.Const.Hair.{faces};this.m.HairColors=this.Const.HairColors.All;this.m.Beards=this.Const.Beards.All;this.m.Bodies=this.Const.Bodies.{"Female" if faces == "AllFemale" else "Muscular"};
 }},
 function onBuildDescription() {{ return {q(d["story"])}; }},
 function onChangeAttributes() {{ return {{Hitpoints=[0,0],Stamina=[0,0],Bravery=[0,0],Initiative=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0]}}; }},
 function onAddEquipment() {{ local items=this.getContainer().getActor().getItems();
{lines}
 }}
}});
''',
        encoding="utf-8",
    )

print(f"Applied flavor to {len(DOC)} characters / {len(skills)} skills")
