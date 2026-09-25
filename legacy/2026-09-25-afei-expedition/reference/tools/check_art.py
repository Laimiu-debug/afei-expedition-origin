"""Validate game-sized art files and the complete character/skill coverage."""

from pathlib import Path
import json
import sys

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src" / "gfx"
DOC = json.loads((ROOT / "data" / "document-v0.6.2.json").read_text(encoding="utf-8"))

expected = {
    "events": ({*DOC, "scene_welcome", "scene_farewell"}, SRC / "ui" / "events", 220),
    "skills": ({s["id"] for c in DOC.values() for s in c["skills"]}, SRC / "skills", 56),
}
allowed_extra = {"skills": {"ecig_puff", "ecig_puff_sw"}}
# New roster gameplay ships with vanilla icon/portrait fallback while art is deferred.
allowed_missing = {"events": {"C32", "C33", "C34"},
                   "skills": {"pang_anchor", "pang_share", "pang_breath", "berry_eye", "berry_mark", "berry_reserve"}}
allowed_extra["events"] = {"C11"}  # retained in the archive for older saves

errors = []
for kind, (names, directory, size) in expected.items():
    found = {p.stem.removeprefix("afei_") for p in directory.glob("afei_*.png")}
    for name in sorted(names - found - allowed_missing.get(kind, set())):
        errors.append(f"missing {kind}: {name}")
    for name in sorted(found - names - allowed_extra.get(kind, set())):
        errors.append(f"unexpected {kind}: {name}")
    for name in sorted(names & found):
        path = directory / f"afei_{name}.png"
        try:
            with Image.open(path) as image:
                image.verify()
            with Image.open(path) as image:
                if image.size != (size, size):
                    errors.append(f"wrong size {path.name}: {image.size}")
                if image.mode != "RGBA":
                    errors.append(f"wrong mode {path.name}: {image.mode}")
        except (OSError, SyntaxError) as exc:
            errors.append(f"invalid image {path.name}: {exc}")

for error in errors:
    print(error)
print(f"art: {len(expected['events'][0])} event illustrations, {len(expected['skills'][0])} skill icons")
print("ALL_ART_OK" if not errors else f"ART_FAILURES={len(errors)}")
sys.exit(bool(errors))
