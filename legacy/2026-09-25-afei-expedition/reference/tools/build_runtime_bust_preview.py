"""Preview the actual unpacked tactical brush with changeable game equipment."""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

from build_layered_preview import ROOT, NATIVE, STARTING, metadata, draw_sprite


def main() -> None:
    unpacked = ROOT / "test-output/rendercheck/coherent-unpacked"
    refs = metadata(NATIVE)
    refs.update(metadata(NATIVE.parent / "entity_1"))
    refs.update(metadata(NATIVE.parent / "entity_icons"))
    refs.update(metadata(unpacked))
    out = Image.new("RGB", (6 * 180, 3 * 220), (31, 27, 23))
    draw = ImageDraw.Draw(out)
    font_file = Path("C:/Windows/Fonts/msyh.ttc")
    font = ImageFont.truetype(str(font_file), 13) if font_file.exists() else ImageFont.load_default()
    for row, label in enumerate(("完整胸像", "初始装备", "换装：剑与圆盾")):
        for col, cid in enumerate(STARTING):
            canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
            draw_sprite(canvas, refs, f"afei_figure_{cid}")
            weapon, shield = STARTING[cid] if row == 1 else ("icon_sword_01", "shield_round_00") if row == 2 else (None, None)
            for item in (shield, weapon):
                if item:
                    draw_sprite(canvas, refs, item)
            out.paste(canvas.convert("RGB"), (col * 180, row * 220))
            draw.text((col * 180 + 9, row * 220 + 190), f"{cid} {label}", font=font, fill=(230, 220, 200))
    target = ROOT / "art/reviews/runtime-C01-C06-20260924.jpg"
    out.save(target, quality=95)
    print(target)


if __name__ == "__main__":
    main()
