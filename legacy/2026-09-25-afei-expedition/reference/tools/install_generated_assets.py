"""Install generated item icons and tactical portrait sheets into game assets."""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path
from PIL import Image, ImageDraw, ImageEnhance, ImageOps

ROOT = Path(__file__).resolve().parents[1]
GFX = ROOT / "src" / "gfx"
HEADS = ROOT / "art" / "tactical-sprites"

GROUPS = [
    ["C01", "C02", "C03", "C04", "C05", "C06", "C07", "C08", "C09", "C10"],
    ["C11", "C12", "C13", "C14", "C15", "C16", "C17", "C18", "C19", "C20"],
    ["C21", "C22", "C23", "C25", "C26", "C27", "C28", "C29", "C30", "C31"],
]


def isolated_icon(source: Path, size: int) -> Image.Image:
    image = Image.open(source).convert("RGBA")
    box = image.getchannel("A").getbbox()
    if box:
        image = image.crop(box)
    image.thumbnail((size - 6, size - 6), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (size, size))
    canvas.alpha_composite(image, ((size - image.width) // 2, (size - image.height) // 2))
    return canvas


def install_icon(source: Path, target: Path, size: int) -> Image.Image:
    target.parent.mkdir(parents=True, exist_ok=True)
    image = isolated_icon(source, size)
    image.save(target)
    return image


def install_sheet(source: Path, ids: list[str]) -> None:
    sheet = Image.open(source).convert("RGBA")
    cell_w, cell_h = sheet.width // 5, sheet.height // 2
    icons = HEADS / "icons"
    icons.mkdir(parents=True, exist_ok=True)
    for index, cid in enumerate(ids):
        x, y = index % 5, index // 5
        cell = sheet.crop((x * cell_w, y * cell_h, (x + 1) * cell_w, (y + 1) * cell_h))
        box = cell.getchannel("A").getbbox()
        if box:
            cell = cell.crop(box)
        cell.thumbnail((104, 142), Image.Resampling.LANCZOS)
        head = Image.new("RGBA", (104, 142))
        head.alpha_composite(cell, ((104 - cell.width) // 2, 142 - cell.height))
        head.save(icons / f"afei_head_{cid}.png")
        dead = ImageEnhance.Brightness(ImageOps.grayscale(head).convert("RGBA")).enhance(0.55)
        dead.putalpha(head.getchannel("A"))
        dead.save(icons / f"afei_head_{cid}_dead.png")
        blank = Image.new("RGBA", (140, 100))
        blank.save(icons / f"afei_hair_{cid}.png")
        blank.save(icons / f"afei_hair_{cid}_dead.png")

        portrait = Image.new("RGBA", (220, 220), (27, 23, 19, 255))
        draw = ImageDraw.Draw(portrait)
        for y2 in range(220):
            shade = int(18 * (1.0 - abs(y2 - 110) / 110.0))
            draw.line((0, y2, 219, y2), fill=(27 + shade, 23 + shade, 19 + shade, 255))
        large = cell.copy()
        large.thumbnail((214, 214), Image.Resampling.LANCZOS)
        portrait.alpha_composite(large, ((220 - large.width) // 2, 220 - large.height))
        draw.rectangle((2, 2, 217, 217), outline=(112, 83, 49, 255), width=3)
        events = GFX / "ui" / "events"
        events.mkdir(parents=True, exist_ok=True)
        portrait.save(events / f"afei_{cid}.png")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bike", type=Path, required=True)
    parser.add_argument("--ecig", type=Path, required=True)
    parser.add_argument("--sheet", action="append", type=Path, required=True)
    parser.add_argument("--metadata", type=Path, required=True)
    args = parser.parse_args()
    if len(args.sheet) != 3:
        parser.error("exactly three --sheet arguments are required")

    bike = install_icon(args.bike, GFX / "ui" / "items" / "accessory" / "afei_bicycle.png", 70)
    ecig = install_icon(args.ecig, GFX / "ui" / "items" / "accessory" / "afei_ecig.png", 70)
    skill = ecig.resize((56, 56), Image.Resampling.LANCZOS)
    (GFX / "skills").mkdir(parents=True, exist_ok=True)
    skill.save(GFX / "skills" / "afei_ecig_puff.png")
    disabled = ImageEnhance.Contrast(ImageOps.grayscale(skill).convert("RGBA")).enhance(0.75)
    disabled.putalpha(skill.getchannel("A"))
    disabled.save(GFX / "skills" / "afei_ecig_puff_sw.png")

    HEADS.mkdir(parents=True, exist_ok=True)
    metadata_target = HEADS / "metadata.xml"
    if args.metadata.resolve() != metadata_target.resolve():
        shutil.copy2(args.metadata, metadata_target)
    for source, ids in zip(args.sheet, GROUPS):
        install_sheet(source, ids)
    print("installed 2 item icons, 2 skill icons, and 30 matched event/tactical identities")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
