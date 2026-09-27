"""Package selected generated layers and skill icons; never ship native artwork.

The body/disc sprites are exact copies of previously generated v1 exports with
new brush identifiers. New skill masters are alpha-cropped and uniformly fitted
to 56x56; no painting, recoloring, background removal or replacement art occurs.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import tempfile
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFont

from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "art/runtime/gameplay-v03"
V1 = ROOT / "art/runtime/afei/v1"
ATLAS = "afeix_gameplay_v03"
ICONS = ("wawa", "haoqi", "quanqian", "feidie")
LAYERS = (
    "normal_body", "normal_body_dead", "normal_body_injured",
    "jiahao_body", "jiahao_body_dead", "jiahao_body_injured",
)
BBRUSHER = ROOT / ".cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save_json(path: Path, data: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def export_icon(key: str) -> tuple[Path, dict]:
    source = BASE / "sources" / f"{key}.png"
    with Image.open(source) as original:
        if original.mode != "RGBA":
            raise ValueError(f"{key}: generated source must be RGBA, got {original.mode}")
        image = original.copy()
    alpha = image.getchannel("A")
    if alpha.getextrema()[0] != 0 or alpha.getextrema()[1] == 0:
        raise ValueError(f"{key}: generated source must have true transparent and visible pixels")
    box = alpha.getbbox()
    cropped = image.crop(box)
    scale = min(52 / cropped.width, 52 / cropped.height)
    size = (max(1, min(52, round(cropped.width * scale))), max(1, min(52, round(cropped.height * scale))))
    resized = cropped.resize(size, Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (56, 56))
    placement = ((56 - size[0]) // 2, (56 - size[1]) // 2)
    canvas.alpha_composite(resized, placement)
    target = ROOT / "src/gfx/skills" / f"afeix_{key}.png"
    target.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(target)
    return target, {
        "key": key, "source": source.relative_to(ROOT).as_posix(), "source_sha256": sha(source),
        "source_size": list(image.size), "alpha_crop_box": list(box), "uniform_scale": scale,
        "resized_size": list(size), "placement": list(placement), "output_size": [56, 56],
        "output": target.relative_to(ROOT).as_posix(), "sha256": sha(target),
        "alpha_extrema": list(canvas.getchannel("A").getextrema()),
        "disabled_icon": "same image; no synthetic grayscale variant",
    }


def make_review(attrs: dict[str, dict], icons: list[dict]) -> str:
    """Local-only diagnostic compositing of existing layers at their anchors."""
    refs = json.loads((V1 / "build/preview/native-reference-sources.json").read_text(encoding="utf-8"))
    references = {key: (V1 / "build/preview" / data["url"], data) for key, data in refs.items()}
    for key, data in attrs.items():
        references[key] = (BASE / "sprites" / f"{key}.png", data)

    def draw_piece(canvas: Image.Image, key: str) -> None:
        path, meta = references[key]
        with Image.open(path) as src:
            sprite = src.convert("RGBA")
        x, y = 80 + int(meta["left"]), 112 - int(meta["bottom"])
        canvas.alpha_composite(sprite, (x, y))

    names = ("Native", "Normal + native head", "Jiahao + native head", "Jiahao (legacy)")
    font_path = Path("C:/Windows/Fonts/arial.ttf")
    font = ImageFont.truetype(str(font_path), 14) if font_path.exists() else ImageFont.load_default()
    report = Image.new("RGBA", (160 * 4, 210 * 4 + 110), (48, 46, 40, 255))
    draw = ImageDraw.Draw(report)
    for row in range(4):
        for column, name in enumerate(names):
            frame = Image.new("RGBA", (160, 180))
            body = "bust_body_01" if column == 0 else "afeix_g03_" + ("normal" if column == 1 else "jiahao") + "_body"
            if row == 3:
                draw_piece(frame, body + "_dead")
                draw_piece(frame, "bust_head_01_dead")
                draw_piece(frame, "hair_black_02_dead")
            else:
                draw_piece(frame, body)
                if row in (1, 2):
                    draw_piece(frame, "bust_body_14")
                draw_piece(frame, "bust_head_01")
                if row == 0:
                    draw_piece(frame, "hair_black_02")
                if row in (1, 2):
                    draw_piece(frame, "bust_helmet_03" if row == 1 else "bust_helmet_18")
                    draw_piece(frame, "icon_sword_01")
                    draw_piece(frame, "shield_round_00")
            report.alpha_composite(frame, (column * 160, row * 210 + 20))
            draw.text((column * 160 + 3, row * 210 + 3), name, font=font, fill="white")
    for i, entry in enumerate(icons):
        with Image.open(ROOT / entry["output"]) as icon:
            report.alpha_composite(icon.convert("RGBA"), (i * 160 + 52, 845))
        draw.text((i * 160 + 30, 906), entry["key"] + " (56px)", font=font, fill="white")
    output = BASE / "build/layer-review-1x.png"
    output.parent.mkdir(parents=True, exist_ok=True)
    report.save(output)
    return output.relative_to(ROOT).as_posix()


def build_art(*, require_icons: bool = True, bbrusher: Path = BBRUSHER) -> tuple[list[Path], dict]:
    missing = [key for key in ICONS if not (BASE / "sources" / f"{key}.png").is_file()]
    if require_icons and missing:
        raise FileNotFoundError("Missing generated skill masters: " + ", ".join(missing))
    (BASE / "build").mkdir(parents=True, exist_ok=True)
    (BASE / "sprites").mkdir(parents=True, exist_ok=True)
    old_meta = {e.get("id"): dict(e.attrib) for e in ET.parse(V1 / "sprites/metadata.xml").getroot()}
    attrs, layer_report = [], []
    with tempfile.TemporaryDirectory(prefix="pack-", dir=BASE / "build") as temporary:
        pack_input = Path(temporary)
        (pack_input / "sprites").mkdir()
        for layer in LAYERS:
            old_id, identity = "afeix_v1_" + layer, "afeix_g03_" + layer
            source = V1 / "sprites" / f"{old_id}.png"
            target = BASE / "sprites" / f"{identity}.png"
            shutil.copyfile(source, target)
            shutil.copyfile(source, pack_input / "sprites" / target.name)
            data = dict(old_meta[old_id])
            data.update(id=identity, img="sprites\\" + target.name)
            attrs.append(data)
            layer_report.append({
                "id": identity, "source": source.relative_to(ROOT).as_posix(),
                "source_sha256": sha(source), "output": target.relative_to(ROOT).as_posix(),
                "sha256": sha(target), "pixels_unchanged": True, "metadata": data,
            })
        roundtrip = pack_and_verify(BASE, ATLAS, pack_input, attrs, bbrusher.resolve())
    outputs = []
    for relative in (f"brushes/{ATLAS}.brush", f"gfx/{ATLAS}.png"):
        target = ROOT / "src" / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(BASE / "package" / relative, target)
        outputs.append(target)
    icon_reports = []
    for key in ICONS:
        if key in missing:
            continue
        target, icon = export_icon(key)
        outputs.append(target)
        icon_reports.append(icon)
    report = {
        "schema_version": 1, "atlas_name": ATLAS, "layers": layer_report, "icons": icon_reports,
        "files": [p.relative_to(ROOT / "src").as_posix() for p in outputs],
        "missing_icon_masters": missing, "roundtrip": roundtrip,
        "preview": make_review({a["id"]: a for a in attrs}, icon_reports),
        "in_game_tested": False,
        "status": "limited_runtime_integration_pending_in_game_visual_acceptance",
        "used": ["normal and Jiahao body/dead/injury layers", "generated skill icons when present"],
        "not_used": ["v1 human live/dead heads", "all v1 toad layers", "retired flying saucer", "v1 test scenario and script hooks"],
        "native_fallbacks": ["all head/hair/beard/face injury layers", "toad route appearance", "missing custom body/required death or injury brush"],
        "limitations": [
            "Toad neck seam and human corpse-head/hair mismatch remain unresolved; those layers are excluded.",
            "Native helmets and armor cover the base clothing normally; no equipment is removed or hidden.",
            "Native corpse construction tints the custom body using the native head color; in-game appearance is not accepted yet.",
            "Disc positioning relative to status icons and roster portrait clipping still requires in-game checks.",
            "Engine sprite serialization is not exposed by the inspected scripts; v0.2 save upgrades and save/load roundtrips remain unverified in game.",
            "Local preview includes native references for inspection only; no native artwork enters src or the gameplay ZIP.",
        ],
    }
    save_json(BASE / "manifest.json", report)
    save_json(BASE / "build/report.json", report)
    return outputs, report


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--allow-missing-icons", action="store_true")
    args = parser.parse_args()
    paths, report = build_art(require_icons=not args.allow_missing_icons)
    print(f"Exported {len(paths)} runtime files, {len(report['layers'])} reviewed layer candidates, {len(report['icons'])} skill icons.")
    print("Roundtrip coordinates/pixels verified; no in-game visual acceptance.")
