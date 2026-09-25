"""Prepare a C06 likeness/style comparison at real tactical size, without packing."""
import argparse
import shutil
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

from build_layered_preview import ROOT, NATIVE, STARTING, metadata, draw_sprite


def sized_sprite(path: Path, out: Path) -> None:
    source = Image.open(path).convert("RGBA")
    if source.getchannel("A").getextrema()[0] != 0:
        raise ValueError("Expected a transparent cutout")
    box = source.getchannel("A").point(lambda a: 255 if a >= 128 else 0).getbbox()
    if not box:
        raise ValueError("The cutout has no figure")
    source = source.crop(box)
    source.thumbnail((108, 124), Image.Resampling.LANCZOS)
    sprite = Image.new("RGBA", (114, 142))
    sprite.alpha_composite(source, ((114 - source.width) // 2, 142 - source.height))
    sprite.save(out)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("art", type=Path)
    args = parser.parse_args()
    dest = ROOT / "art/tactical-sprites/identity-lock-v5"
    dest.mkdir(parents=True, exist_ok=True)
    master = dest / "C06-master.png"
    shutil.copy2(args.art, master)
    sized_sprite(master, dest / "afei_figure_C06.png")
    refs = metadata(NATIVE.parent / "entity_icons")
    refs.update({
        "previous": (ROOT / "art/tactical-sprites/likeness-v3/afei_figure_C06.png", -57, 87),
        "revised": (dest / "afei_figure_C06.png", -57, 87),
    })
    sheet = Image.new("RGB", (660, 460), (31, 27, 23))
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 16)
    for col, (key, label) in enumerate((
        ("previous", "上一版：脸较像，笔触偏人像"),
        ("revised", "新版：按原版战斗画风修"),
        ("native", "游戏原版比例对照"),
    )):
        for row in range(2):
            canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
            if key == "native":
                native = metadata(NATIVE)
                for part in ("bust_naked_body_00", "bust_body_19", "bust_head_01", "hair_brown_01"):
                    draw_sprite(canvas, native, part)
            else:
                draw_sprite(canvas, refs, key)
            if row:
                weapon, shield = STARTING["C06"]
                for item in (shield, weapon):
                    if item:
                        draw_sprite(canvas, refs, item)
            sheet.paste(canvas.convert("RGB"), (col * 220 + 20, row * 230))
            draw.text((col * 220 + 10, row * 230 + 190), label if row == 0 else "实际尺寸＋初始装备", fill=(220, 207, 187), font=font)
    out = ROOT / "art/reviews/C06-identity-lock-v5.jpg"
    sheet.save(out, quality=96)
    print(out)


if __name__ == "__main__":
    main()
