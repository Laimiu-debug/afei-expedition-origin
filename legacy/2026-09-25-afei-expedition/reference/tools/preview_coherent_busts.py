"""Stage coherent tactical figures and a native-equipment review, without packaging."""
import argparse
import json
from pathlib import Path
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFont

from build_layered_preview import ROOT, NATIVE, STARTING, metadata, draw_sprite


DEST = ROOT / "art/tactical-sprites/coherent-v2"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("sheet", type=Path)
    args = parser.parse_args()
    source = Image.open(args.sheet).convert("RGBA")
    if source.getchannel("A").getextrema()[0] != 0:
        raise ValueError("The sprite sheet must have a transparent background")
    DEST.mkdir(parents=True, exist_ok=True)
    source.save(DEST / "source-sheet.png")
    solid = source.getchannel("A").point(lambda a: 255 if a >= 128 else 0)
    split = min(range(int(source.height * .47), int(source.height * .54)),
                key=lambda y: sum(solid.crop((0, y, source.width, y + 1)).getdata()))
    row_edges = (0, split, source.height)
    xml = ET.Element("sprites")
    for index, cid in enumerate(STARTING):
        col, row = index % 3, index // 3
        cell = source.crop((col * source.width // 3, row_edges[row],
                            (col + 1) * source.width // 3, row_edges[row + 1]))
        box = cell.getchannel("A").point(lambda a: 255 if a >= 128 else 0).getbbox()
        if not box:
            raise ValueError(f"No character in {cid}")
        # Crop and proportional downsampling only; do not redraw or stretch.
        figure = cell.crop(box)
        figure.thumbnail((108, 124), Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", (114, 142))
        canvas.alpha_composite(figure, ((114 - figure.width) // 2, 142 - figure.height))
        filename = f"afei_figure_{cid}.png"
        canvas.save(DEST / filename)
        ET.SubElement(xml, "sprite", id=f"afei_figure_{cid}", img=filename,
                      offsetY="35", width="114", height="142", left="-57",
                      right="57", top="-55", bottom="87")
    ET.indent(xml)
    ET.ElementTree(xml).write(DEST / "metadata.xml", encoding="utf-8", xml_declaration=True)
    refs = metadata(NATIVE)
    refs.update(metadata(NATIVE.parent / "entity_1"))
    refs.update(metadata(NATIVE.parent / "entity_icons"))
    refs.update(metadata(DEST))
    out = Image.new("RGB", (1260, 690), (31, 27, 23))
    draw = ImageDraw.Draw(out)
    font = ImageFont.truetype("C:/Windows/Fonts/msyh.ttc", 13)
    roster = json.loads((ROOT / "data/document-v0.6.2.json").read_text(encoding="utf-8"))
    names = ("原版对照", *(f"{cid} {roster[cid]['name']}" for cid in STARTING))
    labels = ("固定外观", "初始武器／盾牌", "换装：剑／圆盾")
    for row in range(3):
        for col, cid in enumerate((None, *STARTING)):
            canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
            if cid is None:
                for part in ("bust_naked_body_00", "bust_body_19", "bust_head_01", "hair_brown_01"):
                    draw_sprite(canvas, refs, part)
            else:
                draw_sprite(canvas, refs, f"afei_figure_{cid}")
            weapon, shield = (None, None) if row == 0 else STARTING[cid] if row == 1 and cid else ("icon_sword_01", "shield_round_00")
            for item in (shield, weapon):
                if item:
                    draw_sprite(canvas, refs, item)
            out.paste(canvas.convert("RGB"), (col * 180, row * 230))
            draw.text((col * 180 + 8, row * 230 + 184), names[col], font=font, fill=(230, 220, 200))
            draw.text((col * 180 + 8, row * 230 + 205), labels[row], font=font, fill=(177, 165, 145))
    path = ROOT / "art/reviews/coherent-C01-C06-equipment-v2.jpg"
    out.save(path, quality=96)
    print(f"Staged six figures and review: {path}; no atlas or game ZIP changed")


if __name__ == "__main__":
    main()
