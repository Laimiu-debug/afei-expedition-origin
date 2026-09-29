"""Render the current approved portraits without repainting character artwork."""
from __future__ import annotations

import hashlib
import json
import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[3]
OUT = Path(__file__).resolve().parent
W, H = 3600, 4500
FONT_DIR = Path("C:/Windows/Fonts")
INK = (239, 225, 199)
MUTED = (170, 156, 132)
GOLD = (190, 151, 91)
GROUPS = [
    ("刀一黑队", 10, (197, 184, 158)),
    ("刀二蓝队", 8, (125, 169, 186)),
    ("0.5DFW猪团", 14, (209, 149, 125)),
    ("旅途来客", 2, (157, 183, 145)),
]


def font(size: int, kind: str = "regular") -> ImageFont.FreeTypeFont:
    names = {"regular": "msyh.ttc", "bold": "msyhbd.ttc", "serif": "simsun.ttc", "latin": "bahnschrift.ttf"}
    return ImageFont.truetype(str(FONT_DIR / names[kind]), size)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def center(draw, xy, text, size, color=INK, kind="regular"):
    selected = font(size, kind)
    bounds = draw.textbbox((0, 0), text, font=selected)
    x = xy[0] - (bounds[2] - bounds[0]) / 2 - bounds[0]
    y = xy[1] - (bounds[3] - bounds[1]) / 2 - bounds[1]
    draw.text((round(x), round(y)), text, font=selected, fill=color)


def tracked(draw, xy, text, size, spacing, color=MUTED):
    selected = font(size, "latin")
    widths = [draw.textlength(c, font=selected) for c in text]
    x = xy[0] - (sum(widths) + spacing * (len(text) - 1)) / 2
    for char, width in zip(text, widths):
        draw.text((x, xy[1]), char, font=selected, fill=color)
        x += width + spacing


def diamond(draw, x, y, radius, color):
    draw.polygon([(x, y-radius), (x+radius, y), (x, y+radius), (x-radius, y)], fill=color)


def main():
    manifest_path = ROOT / "art/runtime/portraits-v05/manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8-sig"))
    people = manifest["characters"]
    assert len(people) == 34
    assert len({p["key"] for p in people}) == 34
    assert people[0]["key"] == "afei"
    assert all(p["key"] not in ("chenzhihan", "liu_qingsong") for p in people)
    roster = json.loads((ROOT / "data/character-stories.json").read_text(encoding="utf-8"))["characters"]
    assert [(p["key"], p["name"]) for p in people] == [(p["key"], p["name"]) for p in roster]

    # Warm ink and restrained paper grain. All portrait pixels keep their colors.
    bg = Image.new("RGB", (W, H))
    draw = ImageDraw.Draw(bg)
    for y in range(H):
        glow = math.exp(-((y - 390) / 1050) ** 2)
        color = (round(24+10*glow), round(26+8*glow), round(23+4*glow))
        draw.line((0, y, W, y), fill=color)
    rng = random.Random(928)
    for _ in range(64000):
        x, y = rng.randrange(W), rng.randrange(H)
        c = bg.getpixel((x, y))
        n = rng.choice([-3, -2, 2, 3])
        draw.point((x, y), fill=tuple(max(0, v+n) for v in c))
    canvas = bg.convert("RGBA")
    draw = ImageDraw.Draw(canvas)

    # Double hairline frame and small printer's ornaments.
    draw.rectangle((54, 54, W-55, H-55), outline=(91, 78, 56), width=2)
    draw.rectangle((70, 70, W-71, H-71), outline=(56, 53, 43), width=2)
    for x in (54, W-55):
        for y in (54, H-55):
            diamond(draw, x, y, 11, GOLD)

    tracked(draw, (W/2, 121), "BATTLE BROTHERS  /  ORIGIN MOD", 34, 6, GOLD)
    center(draw, (W/2, 298), "阿 飞 起 源", 166, INK, "serif")
    center(draw, (W/2, 454), "全 员 人 物 立 绘", 46)
    for xa, xb in ((286, 1400), (2200, 3314)):
        draw.line((xa, 454, xb, 454), fill=(99, 81, 55), width=2)
    diamond(draw, 1380, 454, 7, GOLD)
    diamond(draw, 2220, 454, 7, GOLD)

    legend_positions = [585, 1380, 2250, 3090]
    for (name, count, color), x in zip(GROUPS, legend_positions):
        label = f"{name}  /  {count:02d}"
        f = font(37)
        width = draw.textlength(label, font=f)
        diamond(draw, x-width/2-36, 574, 7, color)
        center(draw, (x, 574), label, 37, color)

    records = []
    group_map = []
    for group_name, count, color in GROUPS:
        group_map.extend([(group_name, color)] * count)
    for i, (person, (group_name, accent)) in enumerate(zip(people, group_map)):
        row, col = divmod(i, 6)
        row_count = min(6, len(people) - row*6)
        # Center the final four portraits rather than leave empty placeholders.
        x = (W - (row_count*540 + (row_count-1)*20))//2 + col*560
        y = 684 + row*557
        cx = x + 270
        variant = next(v for v in person["forms"] if v["form"] in ("normal", "default"))
        assert variant["approved_for_export"] is True
        source = ROOT / variant["source"]
        source_hash = sha(source)
        assert source_hash == variant["source_sha256"], source
        portrait = Image.open(source).convert("RGBA")
        if variant.get("source_box"):
            portrait = portrait.crop(tuple(variant["source_box"]))
        bbox = portrait.getchannel("A").point(lambda a: 255 if a >= 20 else 0).getbbox()
        assert bbox is not None
        portrait = portrait.crop(bbox)
        portrait.thumbnail((436, 404), Image.Resampling.LANCZOS)

        # Low-contrast oval mount keeps dark hair readable without altering it.
        draw.ellipse((cx-218, y+33, cx+218, y+424), fill=(37, 39, 33), outline=(57, 56, 44), width=2)
        draw.arc((cx-230, y+21, cx+230, y+436), 201, 337, fill=(78, 70, 51), width=2)
        image_xy = (round(cx-portrait.width/2), y+422-portrait.height)
        canvas.alpha_composite(portrait, image_xy)
        draw = ImageDraw.Draw(canvas)
        draw.text((x+33, y+18), f"{i+1:02d}", font=font(24, "latin"), fill=(132, 120, 100))
        size = 48
        while draw.textlength(person["name"], font=font(size, "bold")) > 475:
            size -= 1
        center(draw, (cx, y+473), person["name"], size, INK, "bold")
        center(draw, (cx, y+524), group_name, 27, accent)
        draw.line((cx-32, y+553, cx+32, y+553), fill=accent, width=2)
        records.append({
            "index": i+1, "key": person["key"], "name": person["name"],
            "group": group_name, "form": variant["form"],
            "source": variant["source"], "sha256": source_hash,
            "portrait_bounds": [*image_xy, image_xy[0]+portrait.width, image_xy[1]+portrait.height],
        })

    footer_y = 4144
    draw.line((315, footer_y, W-315, footer_y), fill=(98, 79, 53), width=2)
    diamond(draw, W//2, footer_y, 9, GOLD)
    center(draw, (W/2, 4243), "34 位伙伴，共赴远征", 54, INK, "serif")
    center(draw, (W/2, 4335), "《战场兄弟》阿飞主题 MOD", 32, MUTED)

    # User requested the existing artwork: no model generation or repainting.
    final = canvas.convert("RGB")
    final.save(OUT / "afei-all-34-characters.png", dpi=(300, 300), optimize=True)
    final.save(OUT / "afei-all-34-characters.jpg", quality=95, subsampling=0, dpi=(300, 300))
    preview = final.copy()
    preview.thumbnail((1200, 1500), Image.Resampling.LANCZOS)
    preview.save(OUT / "preview.jpg", quality=92, subsampling=0)
    report = {
        "size": [W, H], "character_count": len(records), "date": "2026-09-28",
        "method": "Deterministic layout from current approved source portraits; proportional resizing only; no repainting.",
        "groups": [{"name": name, "count": count} for name, count, color in GROUPS],
        "manifest_sha256": sha(manifest_path), "characters": records,
    }
    assert len([p for p in records if p["key"] == "afei"]) == 1
    assert all(p["portrait_bounds"][3] < 4030 for p in records)
    for record in records:
        assert sha(ROOT / record["source"]) == record["sha256"]
    (OUT / "sources.json").write_text(json.dumps(report, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    print(json.dumps({"size": [W, H], "characters": len(records), "output": str(OUT)}, ensure_ascii=True))


if __name__ == "__main__":
    main()
