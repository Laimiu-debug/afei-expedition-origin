"""Export custom busts as complementary body/head layers without repainting.

Alpha-bound cropping, uniform resizing, placement and reviewed neck contours are used.
The _dead brush keeps the complete resized portrait with a centred anchor;
The corpse-head alias preserves current head pixels with a separate runtime pivot.
"""
from __future__ import annotations

import argparse
import hashlib
import html
import json
import re
from pathlib import Path
import shutil
import tempfile
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFont

from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "art/runtime/portraits-v05"
MANIFEST = BASE / "manifest.json"
ATLAS = "afeix_portraits_v04"
BBRUSHER = ROOT / ".cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe"
# Brush IDs and atlas filename remain stable for existing saves; source revision is v05.
ALLOWED_SOURCE_ROOTS = (ROOT / "art/character-concepts", ROOT / "art/runtime/portraits-v04/sources", BASE / "sources")
LIVE_RECT = {"left": -57, "right": 57, "top": -51, "bottom": 91,
             "width": 114, "height": 142, "offsetY": 35}
DEAD_RECT = {"left": -57, "right": 57, "top": -71, "bottom": 71,
             "width": 114, "height": 142, "offsetX": 0, "offsetY": 0}


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save_json(path: Path, data: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def source_path(value: str) -> Path:
    path = (ROOT / value).resolve()
    if Path(value).is_absolute() or not any(path.is_relative_to(root.resolve()) for root in ALLOWED_SOURCE_ROOTS):
        raise ValueError(f"Only reviewed custom-source directories are allowed: {value}")
    if path.suffix.lower() != ".png" or not path.is_file():
        raise FileNotFoundError(f"Custom portrait source is missing or not PNG: {value}")
    return path


def read_manifest(path: Path = MANIFEST) -> tuple[dict, list[dict], list[dict]]:
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    if data.get("schema_version") != 1 or data.get("atlas_name") != ATLAS:
        raise ValueError("Expected schema_version 1 and atlas_name " + ATLAS)
    roster = json.loads((ROOT / "data/character-stories.json").read_text(encoding="utf-8"))["characters"]
    people = data.get("characters", [])
    if [(p.get("key"), p.get("name")) for p in people] != [(p["key"], p["name"]) for p in roster]:
        raise ValueError("Portrait manifest must match all current character keys, names and ordering")
    if len(people) != 34:
        raise ValueError("Expected the current 34-person roster")
    expected_geometry = {"live": LIVE_RECT, "dead": DEAD_RECT, "size": [114, 142], "fit": [88, 100],
                         "alpha_threshold": 20, "align": "bottom_center"}
    if data.get("geometry") != expected_geometry:
        raise ValueError("Manifest geometry changed without updating the runtime anchor contract")
    ready, missing = [], []
    seen = set()
    for person in people:
        key = person["key"]
        expected_forms = ["normal", "toad", "jiahao"] if key == "afei" else ["default"]
        if [v.get("form") for v in person.get("forms", [])] != expected_forms:
            raise ValueError(f"{key}: expected forms {expected_forms}")
        for variant in person["forms"]:
            brush = "afeix_p04_" + key + ("_" + variant["form"] if key == "afei" else "")
            if variant.get("brush") != brush or brush in seen:
                raise ValueError(f"Invalid or duplicate brush {variant.get('brush')}")
            seen.add(brush)
            record = {**variant, "key": key, "name": person["name"]}
            if not variant.get("source") or variant.get("approved_for_export") is not True:
                missing.append({"key": key, "form": variant["form"], "brush": brush,
                                "reason": "source missing" if not variant.get("source") else "awaiting visual review"})
                continue
            if variant.get("source_kind") not in ("generated_custom", "legacy_custom"):
                raise ValueError(f"{brush}: source_kind must explicitly identify custom art")
            source = source_path(variant["source"])
            if variant.get("source_sha256") != sha(source):
                raise ValueError(f"{brush}: reviewed source fingerprint missing or changed; re-review before export")
            validate_neck_contour(record)
            ready.append(record)
    if len(seen) != 36:
        raise ValueError("Expected 36 visual forms: 33 partners and three Afei routes")
    return data, ready, missing


def validate_neck_contour(entry: dict) -> list[list[int]]:
    """Coordinates are in the final 114x142 sprite, not the source photograph."""
    points = entry.get("head_seam")
    if (not isinstance(points, list) or len(points) < 4
            or any(not isinstance(p, list) or len(p) != 2
                   or any(type(v) is not int for v in p) for p in points)
            or points[0][0] != 0 or points[-1][0] != 114
            or any(not 100 <= y <= 132 for x, y in points)
            or any(a[0] >= b[0] for a, b in zip(points, points[1:]))):
        raise ValueError(f"{entry['brush']}: missing/invalid reviewed head_seam")
    guard = entry.get("neck_guard")
    if (not isinstance(guard, list) or len(guard) != 2
            or any(type(v) is not int for v in guard)
            or not (0 <= guard[0] < 114 and 103 <= guard[1] < 132)):
        raise ValueError(f"{entry['brush']}: neck_guard must protect a point below the retired chin cut")
    return points


def partition_at_neck(full: Image.Image, entry: dict) -> tuple[Image.Image, Image.Image]:
    points = validate_neck_contour(entry)
    body, head = full.copy(), full.copy()
    # Keep every original pixel exactly once. The curved collar/neck boundary
    # belongs below the complete jaw, rather than across every face at y=102.
    for (x0, y0), (x1, y1) in zip(points, points[1:]):
        for x in range(x0, x1):
            y = round(y0 + (y1 - y0) * (x - x0) / (x1 - x0))
            head.paste((0, 0, 0, 0), (x, y, x + 1, 142))
            body.paste((0, 0, 0, 0), (x, 0, x + 1, y))
    guard = tuple(entry['neck_guard'])
    if full.getpixel(guard)[3] < 200 or head.getpixel(guard) != full.getpixel(guard):
        raise ValueError(f"{entry['brush']}: reviewed neck pixel was lost or guard is outside the portrait")
    if Image.alpha_composite(body, head).tobytes() != full.tobytes():
        raise ValueError(f"{entry['brush']}: head/body reconstruction differs from complete source")
    return body, head


def export_portrait(entry: dict, destination: Path) -> tuple[list[dict], dict]:
    source = source_path(entry["source"])
    with Image.open(source) as original:
        if original.mode != "RGBA":
            raise ValueError(f"{entry['brush']}: RGBA source required, found {original.mode}")
        image = original.copy()
    original_size = list(image.size)
    alpha = image.getchannel("A")
    if alpha.getextrema() != (0, 255):
        raise ValueError(f"{entry['brush']}: source must contain transparent and opaque pixels")
    source_box = entry.get("source_box")
    if source_box is not None:
        if (not isinstance(source_box, list) or len(source_box) != 4
                or any(type(v) is not int for v in source_box)
                or not (0 <= source_box[0] < source_box[2] <= image.width
                        and 0 <= source_box[1] < source_box[3] <= image.height)):
            raise ValueError(f"{entry['brush']}: invalid reviewed source_box")
        image = image.crop(source_box)
    bbox = image.getchannel("A").point(lambda value: 255 if value >= 20 else 0).getbbox()
    if bbox is None:
        raise ValueError(f"{entry['brush']}: source contains no visible character")
    crop = image.crop(bbox)
    scale = min(88 / crop.width, 100 / crop.height)
    size = (max(1, min(88, round(crop.width * scale))), max(1, min(100, round(crop.height * scale))))
    resized = crop.resize(size, Image.Resampling.LANCZOS)
    placement = ((114 - size[0]) // 2, 142 - size[1])
    live = Image.new("RGBA", (114, 142))
    live.alpha_composite(resized, placement)
    destination.mkdir(parents=True, exist_ok=True)
    output = destination / f"{entry['brush']}.png"
    dead = destination / f"{entry['brush']}_dead.png"
    # Split along a reviewed contour below each jaw, keeping its neck on the
    # head layer above armor. Helmets and weapon layers keep their native order.
    live.save(dead)
    live, head = partition_at_neck(live, entry)
    live.save(output)
    head_output = destination / f"{entry['brush']}_head.png"
    head.save(head_output)
    # Same reviewed pixels, anatomical neck pivot for the runtime corpse head. This is
    # an atlas alias, not a repainted or pre-rotated portrait.
    corpse_head = destination / f"{entry['brush']}_corpse_head.png"
    shutil.copyfile(head_output, corpse_head)
    cx, cy = entry['neck_guard']
    corpse_geometry = {'left': -cx, 'right': 114-cx, 'top': cy-142, 'bottom': cy,
                       'width': 114, 'height': 142, 'offsetX': 0, 'offsetY': 0}
    attrs = []
    for suffix, geometry in (("", LIVE_RECT), ("_head", LIVE_RECT), ("_dead", DEAD_RECT), ("_corpse_head", corpse_geometry)):
        identity = entry["brush"] + suffix
        attrs.append({"id": identity, "img": "sprites\\" + identity + ".png",
                      **{k: str(v) for k, v in geometry.items()}})
    report = {
        "key": entry["key"], "name": entry["name"], "form": entry["form"], "brush": entry["brush"],
        "source": entry["source"], "source_kind": entry["source_kind"], "source_sha256": sha(source),
        "source_size": original_size, "source_box": source_box, "alpha_crop_box": list(bbox),
        "alpha_threshold": 20, "resized_size": list(size), "uniform_scale": scale, "placement": list(placement),
        "output_size": [114, 142], "alpha_extrema": list(live.getchannel("A").getextrema()),
        "live_png_sha256": sha(output), "head_png_sha256": sha(head_output), "dead_png_sha256": sha(dead),
        "corpse_head_png_sha256": sha(corpse_head), "corpse_head_geometry": corpse_geometry,
        "corpse_neck_anchor": [cx, cy],
        "partition": "reviewed_neck_contour", "head_seam": entry['head_seam'],
        "neck_guard": entry['neck_guard'], "split_reconstructs_complete_portrait": True,
        "dead_mode": "native_equipped_body_with_pivoted_custom_head", "metadata": attrs,
        "review_note": entry.get("review_note", ""),
    }
    return attrs, report


def make_afei_review() -> dict:
    return {'toad_appearance': 'normal human alias', 'feidie_decoration': 'removed',
            'promotion_gameplay': 'unchanged', 'in_game_tested': False}


def make_review(records: list[dict]) -> dict:
    """Diagnostic composition only: labels and backgrounds never enter the atlas."""
    rows = (len(records) + 5) // 6
    font_path = Path("C:/Windows/Fonts/msyh.ttc")
    font = ImageFont.truetype(str(font_path), 12) if font_path.exists() else ImageFont.load_default()
    sheet = Image.new("RGB", (160 * 6, max(1, rows) * 190), (58, 55, 48))
    draw = ImageDraw.Draw(sheet)
    for i, record in enumerate(records):
        x, y = i % 6 * 160, i // 6 * 190
        with Image.open(BASE / "sprites" / f"{record['brush']}_dead.png") as portrait:
            sheet.paste(portrait, (x + 23, y + 22), portrait)
        draw.text((x + 6, y + 2), record["name"] + (" · " + record["form"] if record["key"] == "afei" else ""), fill="white", font=font)
        draw.text((x + 6, y + 169), record["key"], fill=(215, 204, 185), font=font)
    (BASE / "build").mkdir(parents=True, exist_ok=True)
    sheet.save(BASE / "build/contact-sheet-1x.png")
    sheet.resize((sheet.width * 2, sheet.height * 2), Image.Resampling.NEAREST).save(BASE / "build/contact-sheet-2x.png")
    cards = []
    for record in records:
        key = html.escape(record["brush"] + "_dead")
        label = html.escape(record["name"] + " / " + record["form"])
        note = html.escape(record["review_note"])
        cards.append(f'<article><h2>{label}</h2><div class="samples"><div class="stage"><img src="../sprites/{key}.png" alt="{label}"></div><div class="stage light"><img src="../sprites/{key}.png" alt="{label}"></div></div><code>{key}</code><p>{note}</p></article>')
    document = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>34 人专属胸像检查</title>
<style>body{background:#201e19;color:#eee5d2;font:15px/1.55 system-ui,"Microsoft YaHei",sans-serif;margin:24px}h1{font-size:24px}h2{font-size:16px;margin:0 0 10px}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(270px,1fr));gap:16px}article{background:#302b24;padding:14px;border:1px solid #665642;border-radius:7px}.samples{display:flex;gap:12px}.stage{width:114px;height:142px;background:#454137;flex-shrink:0}.stage.light{background:#d2c5ae}.stage img{width:114px;height:142px}.large .samples{height:290px}.large .stage{transform:scale(2);transform-origin:left top;margin-right:114px}.large .samples .light{display:none}code{font-size:11px;overflow-wrap:anywhere}p{color:#c6b89d}.note{max-width:950px}button{padding:7px 12px;margin-bottom:18px}</style>
<h1>整体胸像 · 原尺寸技术检查</h1><p class="note">所有人物使用同一 114×142 槽，内容最多 88×100、底部对齐。浅深背景检查透明边缘；切换 2× 仅放大显示。此页展示兼容胸像；v0.21 战死改用原版躯干与装备，叠加独立支点的专属头部。没有重绘闭眼表情。格式验收不能代替画风、装备显示、尸体及存读档的实机验收。</p><button onclick="document.body.classList.toggle('large')">切换 1× / 2×</button><div class="grid">''' + "\n".join(cards) + "</div></html>\n"
    (BASE / "build/index.html").write_text(document, encoding="utf-8")
    output = {"html": "build/index.html", "contact_1x": "build/contact-sheet-1x.png", "contact_2x": "build/contact-sheet-2x.png"}
    if all((BASE / 'sprites' / f'afeix_p04_afei_{form}.png').is_file() for form in ('normal', 'toad', 'jiahao')):
        output['afei_forms'] = make_afei_review()
    return output


def copy_changed(source, destination):
    # Windows image previews may memory-map existing sprites. Identical output
    # needs no overwrite; changed artwork still uses the normal checked copy.
    if Path(destination).is_file() and Path(source).read_bytes() == Path(destination).read_bytes():
        return str(destination)
    return shutil.copy2(source, destination)


def build_art(*, require_complete: bool = True, publish_to_src: bool = True,
              bbrusher: Path = BBRUSHER) -> tuple[list[Path], dict]:
    manifest, ready, missing = read_manifest()
    if missing and require_complete:
        raise ValueError("Portrait sources are not complete/reviewed: " + ", ".join(v["brush"] for v in missing))
    if missing and publish_to_src:
        raise ValueError("A partial review atlas must never be published to src")
    if not ready:
        raise ValueError("No reviewed custom portraits available for export")
    cache = ROOT / ".cache/afei-art"
    cache.mkdir(parents=True, exist_ok=True)
    records, attrs = [], []
    with tempfile.TemporaryDirectory(prefix="portraits-v04-", dir=cache) as temporary:
        stage = Path(temporary)
        (stage / "build").mkdir()
        pack_input = stage / "pack-input"
        for entry in ready:
            meta, record = export_portrait(entry, stage / "sprites")
            attrs.extend(meta)
            records.append(record)
        shutil.copytree(stage / "sprites", pack_input / "sprites")
        roundtrip = pack_and_verify(stage, ATLAS, pack_input, attrs, bbrusher.resolve())
        roundtrip.pop("roundtrip_directory", None)
        roundtrip["temporary_files_retained"] = False
        # Only after every source and the atlas roundtrip pass, expose review outputs.
        for folder in ("sprites", "package/brushes", "package/gfx"):
            shutil.copytree(stage / folder, BASE / folder, dirs_exist_ok=True, copy_function=copy_changed)
    published = []
    if publish_to_src:
        for relative in (f"brushes/{ATLAS}.brush", f"gfx/{ATLAS}.png"):
            target = ROOT / "src" / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            copy_changed(BASE / "package" / relative, target)
            published.append(target)
    report = {
        "schema_version": 1, "atlas_name": ATLAS, "manifest": MANIFEST.relative_to(ROOT).as_posix(),
        "manifest_sha256": sha(MANIFEST), "named_characters": len(manifest["characters"]), "required_forms": 36,
        "native_portrait_characters": [p["key"] for p in manifest["characters"] if p.get("portrait_mode") == "native"],
        "exported_forms": len(records), "sprite_count": len(attrs), "complete": not missing,
        "published_to_src": publish_to_src, "files": [p.relative_to(ROOT / "src").as_posix() for p in published],
        "missing": missing, "portraits": records, "roundtrip": roundtrip,
        "preview": make_review(records), "native_art_in_atlas": False, "in_game_tested": False,
        "geometry": manifest["geometry"],
        "limitations": [
            "Custom busts fit 88x100; native armor, helmets, weapon and shield sprites overlay the base.",
            "Body/head reconstruct the portrait; _dead is retained for compatibility and _corpse_head reuses exact head pixels with an anatomical neck pivot.",
            "There are no generated injury states, dismemberment drawings or native face/hair/armor pixels.",
            "Alpha bounds and atlas roundtrip are technical checks, not an assertion of style or likeness acceptance.",
            "Old source images may include props or earlier art direction; consult each review_note before acceptance.",
        ],
    }
    save_json(BASE / "build/report.json", report)
    return published, report


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--allow-incomplete", action="store_true", help="Build a local review atlas only; never publish an incomplete set")
    parser.add_argument("--no-publish", action="store_true", help="Leave src untouched even for a complete atlas")
    parser.add_argument("--check-manifest", action="store_true", help="Read-only mapping, review and fingerprint checks")
    parser.add_argument("--bbrusher", type=Path, default=BBRUSHER)
    args = parser.parse_args()
    if args.check_manifest:
        _, ready, missing = read_manifest()
        print(f"PORTRAIT_MANIFEST_CHECKED={len(ready)}/36; missing_or_unreviewed={len(missing)}")
        if missing and not args.allow_incomplete:
            raise SystemExit(1)
        return
    _, report = build_art(require_complete=not args.allow_incomplete,
                          publish_to_src=not (args.allow_incomplete or args.no_publish), bbrusher=args.bbrusher)
    print(f"PORTRAIT_ART_EXPORTED={report['exported_forms']}/36; sprites={report['sprite_count']}; published={report['published_to_src']}")
    print("Atlas pixels and coordinates roundtrip verified. Corpse head pivots packed; in-game acceptance remains unverified.")


if __name__ == "__main__":
    main()
