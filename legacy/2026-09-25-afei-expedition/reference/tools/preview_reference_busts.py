"""Stage photo-guided character revisions; never build or install a game package."""
import argparse
import shutil
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

from build_layered_preview import ROOT, NATIVE, STARTING, metadata, draw_sprite


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--variant", default="likeness-v3")
    for cid in ("C04", "C05", "C06"):
        parser.add_argument("--" + cid, type=Path, required=True)
    args = parser.parse_args()
    dest = ROOT / "art/tactical-sprites" / args.variant
    dest.mkdir(parents=True, exist_ok=True)
    refs = metadata(NATIVE.parent / "entity_icons")
    sheet = Image.new("RGB", (900, 690), (31, 27, 23))
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 17)
    for col, (cid, name) in enumerate((("C06", "余处九"), ("C05", "李李"), ("C04", "小酒瓶"))):
        path = getattr(args, cid)
        shutil.copy2(path, dest / f"{cid}-master.png")
        source = Image.open(path).convert("RGBA")
        if source.getchannel("A").getextrema()[0] != 0:
            raise ValueError(f"{cid}: background is not transparent")
        box = source.getchannel("A").point(lambda a: 255 if a >= 128 else 0).getbbox()
        source = source.crop(box)
        large = source.copy()
        large.thumbnail((220, 230), Image.Resampling.LANCZOS)
        sheet.paste(large, (col * 300 + (300 - large.width) // 2, 20 + 230 - large.height), large)
        draw.text((col * 300 + 105, 260), name, font=font, fill=(235, 220, 198))
        source.thumbnail((108, 124), Image.Resampling.LANCZOS)
        sprite = Image.new("RGBA", (114, 142))
        sprite.alpha_composite(source, ((114 - source.width) // 2, 142 - source.height))
        target = dest / f"afei_figure_{cid}.png"
        sprite.save(target)
        refs[f"afei_figure_{cid}"] = (target, -57, 87)
        for row in range(2):
            canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
            draw_sprite(canvas, refs, f"afei_figure_{cid}")
            if row:
                weapon, shield = STARTING[cid]
                for item in (shield, weapon):
                    if item:
                        draw_sprite(canvas, refs, item)
            top = 295 + row * 195
            sheet.paste(canvas.convert("RGB"), (col * 300 + 60, top))
            draw.text((col * 300 + 80, top + 165), "战斗尺寸＋初始装备" if row else "战斗尺寸", font=font, fill=(202, 190, 170))
    out = ROOT / "art/reviews" / ("likeness-C06-C05-C04-v3.jpg" if args.variant == "likeness-v3" else f"{args.variant}-C06-C05-C04.jpg")
    sheet.save(out, quality=96)
    print(out)


if __name__ == "__main__":
    main()
