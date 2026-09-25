"""Normalize every art PNG in src/gfx to game spec, and generate placeholder art if a slot is empty.

- gfx/ui/events/afei_*.png  -> 220x220 RGBA PNG (event illustrations)
- gfx/skills/afei_*.png     -> 56x56   RGBA PNG (skill icons)

Whatever an external generator produced (JPEG-ish PNG, 1024x1024, palette),
it is converted here, so dropping files in always works. Empty slots can be
filled with simple placeholders (--placeholders) to verify the whole chain
in-game before real art arrives.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
EVENTS = SRC / "gfx/ui/events"
SKILLS = SRC / "gfx/skills"
SIZES = {"event": 220, "skill": 56}

FONT_CANDIDATES = [
    Path("C:/Windows/Fonts/msyh.ttc"),
    Path("C:/Windows/Fonts/simhei.ttf"),
    Path("C:/Windows/Fonts/arial.ttf"),
]


def _font(size: int) -> ImageFont.FreeTypeFont | None:
    for p in FONT_CANDIDATES:
        if p.exists():
            try:
                return ImageFont.truetype(str(p), size)
            except OSError:
                continue
    return None


def normalize(path: Path, size: int) -> str:
    img = Image.open(path)
    if img.mode != "RGBA":
        img = img.convert("RGBA")
    if img.size != (size, size):
        img = img.resize((size, size), Image.LANCZOS)
    before = path.stat().st_size
    img.save(path, "PNG")
    return f"{path.name}: {img.size} ok ({before}B)"


def placeholder(path: Path, size: int, label: str, tint: tuple) -> None:
    img = Image.new("RGBA", (size, size), (24, 20, 16, 255))
    d = ImageDraw.Draw(img)
    d.ellipse((size * 0.08, size * 0.08, size * 0.92, size * 0.92), outline=(176, 141, 87, 255), width=max(2, size // 28))
    d.ellipse((size * 0.16, size * 0.16, size * 0.84, size * 0.84), fill=(43, 35, 27, 255), outline=(96, 78, 52, 255), width=max(1, size // 56))
    f = _font(int(size * (0.34 if len(label) > 2 else 0.42)))
    if f is not None:
        box = d.textbbox((0, 0), label, font=f)
        d.text(((size - box[2] + box[0]) / 2, (size - box[3] + box[1]) / 2), label, font=f, fill=tint + (255,))
    img.save(path, "PNG")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--placeholders", action="store_true", help="fill every known art slot with a placeholder")
    ap.add_argument("--only", default="", help="only these name stems, comma separated")
    args = ap.parse_args()

    doc = json.loads((ROOT / "data/document-v0.6.2.json").read_text(encoding="utf-8"))
    known_events = [f"C{cid[1:]}" if cid.startswith("C") else cid for cid in doc] + ["scene_welcome", "scene_farewell"]
    known_skills = [s["id"] for c in doc.values() for s in c["skills"]]
    only = {s.strip() for s in args.only.split(",") if s.strip()} if args.only else None

    made, fixed = [], []
    for slot in known_events:
        if only and slot not in only:
            continue
        p = EVENTS / f"afei_{slot}.png"
        if not p.exists() and args.placeholders:
            label = doc.get("C" + slot[1:], {}).get("name", {"scene_welcome": "启", "scene_farewell": "别"}.get(slot, "?")) if slot.startswith("C") else {"scene_welcome": "启", "scene_farewell": "别"}[slot]
            tint = (196, 158, 98) if slot.startswith("C") else (150, 170, 150)
            placeholder(p, SIZES["event"], str(label)[:2], tint)
            made.append(p.name)
    for slot in known_skills:
        if only and slot not in only:
            continue
        p = SKILLS / f"afei_{slot}.png"
        if not p.exists() and args.placeholders:
            placeholder(p, SIZES["skill"], "*", (196, 158, 98))
            made.append(p.name)

    for folder, size in ((EVENTS, SIZES["event"]), (SKILLS, SIZES["skill"])):
        for p in sorted(folder.glob("afei_*.png")):
            fixed.append(normalize(p, size))

    print(f"placeholders created: {len(made)}")
    print(f"normalized: {len(fixed)}")
    for line in fixed[:5]:
        print(" ", line)
    return 0


if __name__ == "__main__":
    sys.exit(main())
