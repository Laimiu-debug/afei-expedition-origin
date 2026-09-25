"""Diagnostic comparison of hair direction and height; writes only a review image."""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

import build_layered_busts as build
from build_layered_preview import metadata, draw_sprite, NATIVE, CUSTOM, ROOT


def place(canvas: Image.Image, img: Image.Image, left: int, bottom: int) -> None:
    canvas.alpha_composite(img, (36 + 52 + left, 20 + 71 - bottom))


def main() -> None:
    refs = metadata(NATIVE)
    refs.update(metadata(CUSTOM, "sprites.xml"))
    sheet = Image.new("RGB", (1080, 4 * 220), (31, 27, 23))
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 13)
    labels = ("现状", "仅镜像头发", "头发降低 12 像素", "镜像并降低 12 像素")
    for row in range(4):
        for col, cid in enumerate(build.IDS):
            raw = Image.open(build.SOURCES / f"{cid}.png").convert("RGBA")
            face, hair = build.component(raw, True), build.component(raw, False)
            if cid in build.MIRROR:
                face, hair = ImageOps.mirror(face), ImageOps.mirror(hair)
            if row % 2:
                hair = ImageOps.mirror(hair)
            face = build.head_sprite(face)
            hair = build.hair_sprite(hair, cid, face)
            if row >= 2:
                lowered = Image.new("RGBA", hair.size)
                lowered.alpha_composite(hair, (0, 12))
                hair = lowered
            canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
            draw_sprite(canvas, refs, f"afei_body_{cid}")
            if cid == "C04":
                merged = hair.copy()
                merged.alpha_composite(face, (47, 30))
                merged.alpha_composite(hair.crop((0, 0, 140, 67)), (0, 0))
                place(canvas, merged, -70, 90)
            else:
                place(canvas, face, -23, 48)
                place(canvas, hair, -70, 90)
            sheet.paste(canvas.convert("RGB"), (col * 180, row * 220))
            draw.text((col * 180 + 8, row * 220 + 190), f"{cid} {labels[row]}", fill=(230, 220, 200), font=font)
    out = ROOT / "art/reviews/hair-direction-height-C01-C06.jpg"
    sheet.save(out, quality=95)
    print(out)


if __name__ == "__main__":
    main()
