"""Install a reviewed group of individual character masters into event and tactical art."""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

from PIL import Image, ImageDraw, ImageEnhance, ImageOps

ROOT = Path(__file__).resolve().parents[1]
MASTERS = ROOT / "art" / "character-masters"
HEADS = ROOT / "art" / "tactical-sprites" / "icons"
EVENTS = ROOT / "src" / "gfx" / "ui" / "events"
BACKUPS = ROOT / "test-output" / "backups" / "pre-five-person-redraw"


def backup_once(path: Path) -> None:
    target = BACKUPS / path.relative_to(ROOT)
    if path.exists() and not target.exists():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, target)


def event_portrait(source: Image.Image) -> Image.Image:
    bbox = source.getchannel("A").getbbox()
    source = source.crop(bbox)
    side = min(source.width, source.height)
    left = (source.width - side) // 2
    # Favor the face and head ornaments over the lower torso.
    top = max(0, int((source.height - side) * 0.08))
    crop = source.crop((left, top, left + side, top + side))
    crop = crop.resize((212, 212), Image.Resampling.LANCZOS)
    portrait = Image.new("RGBA", (220, 220), (27, 23, 19, 255))
    draw = ImageDraw.Draw(portrait)
    for y in range(220):
        shade = int(18 * (1.0 - abs(y - 110) / 110.0))
        draw.line((0, y, 219, y), fill=(27 + shade, 23 + shade, 19 + shade, 255))
    portrait.alpha_composite(crop, (4, 4))
    draw.rectangle((2, 2, 217, 217), outline=(112, 83, 49, 255), width=3)
    return portrait


def tactical_bust(source: Image.Image) -> Image.Image:
    bbox = source.getchannel("A").getbbox()
    source = source.crop(bbox)
    desired_width = round(source.height * 104 / 142)
    if source.width > desired_width:
        left = (source.width - desired_width) // 2
        source = source.crop((left, 0, left + desired_width, source.height))
    source.thumbnail((104, 142), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (104, 142))
    canvas.alpha_composite(source, ((104 - source.width) // 2, 142 - source.height))
    return canvas


def install(cid: str, source_path: Path, batch: str, event_only: bool = False) -> None:
    if not source_path.is_file():
        raise FileNotFoundError(source_path)
    if (ROOT / "art/tactical-sprites/layer-sources" / f"{cid}.png").exists() and not event_only:
        raise ValueError(
            f"{cid} now uses separate tactical face/hair layers; do not overwrite "
            "them with a full event bust. Use --event-only for the portrait, "
            "then update its layered source and run build_layered_busts.py."
        )
    MASTER_DIR = MASTERS / batch
    MASTER_DIR.mkdir(parents=True, exist_ok=True)
    HEADS.mkdir(parents=True, exist_ok=True)
    EVENTS.mkdir(parents=True, exist_ok=True)
    master_path = MASTER_DIR / f"{cid}.png"
    shutil.copy2(source_path, master_path)
    image = Image.open(master_path).convert("RGBA")
    if image.getchannel("A").getextrema()[0] != 0:
        raise ValueError(f"{cid} is missing transparency")

    event = EVENTS / f"afei_{cid}.png"
    if event_only:
        backup_once(event)
        event_portrait(image).save(event)
        print(f"{cid}: {event.name} (tactical layers preserved)")
        return
    head_path = HEADS / f"afei_head_{cid}.png"
    dead_path = HEADS / f"afei_head_{cid}_dead.png"
    for path in (event, head_path, dead_path):
        backup_once(path)
    event_portrait(image).save(event)
    head = tactical_bust(image)
    head.save(head_path)
    dead = ImageEnhance.Brightness(ImageOps.grayscale(head).convert("RGBA")).enhance(0.55)
    dead.putalpha(head.getchannel("A"))
    dead.save(dead_path)
    print(f"{cid}: {event.name}, {head_path.name}, {dead_path.name}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--character", action="append", required=True, metavar="ID=PNG")
    parser.add_argument("--batch", default="batch-01")
    parser.add_argument("--event-only", action="store_true")
    args = parser.parse_args()
    if not 1 <= len(args.character) <= 5:
        parser.error("install one to five characters at a time")
    for item in args.character:
        cid, separator, path = item.partition("=")
        if not separator or not cid.startswith("C"):
            parser.error(f"invalid character argument: {item}")
        install(cid, Path(path), args.batch, args.event_only)


if __name__ == "__main__":
    main()
