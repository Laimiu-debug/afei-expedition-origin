"""Install the reviewed one-piece tactical busts into the brush source.

C01-C03 use coherent-v2; C04-C06 use the battle-style-v6 revision.
The legacy head/hair sprites remain in the brush for existing saves.
"""
from pathlib import Path
import shutil
import xml.etree.ElementTree as ET

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "art/tactical-sprites"
ICONS = ART / "icons"
METADATA = ART / "sprites.xml"
PACK_METADATA = ART / "metadata.xml"
IDS = tuple(f"C{i:02}" for i in range(1, 7))


def main() -> None:
    tree = ET.parse(METADATA)
    brush = tree.getroot()
    if brush.tag != "brush":
        raise ValueError("Expected a bbrusher brush metadata file")
    existing = {sprite.attrib["id"]: sprite for sprite in brush}
    for cid in IDS:
        folder = "battle-style-v6" if cid in {"C04", "C05", "C06"} else "coherent-v2"
        source = ART / folder / f"afei_figure_{cid}.png"
        with Image.open(source) as image:
            if image.size != (114, 142) or image.mode != "RGBA":
                raise ValueError(f"Invalid tactical sprite {source}: {image.size}, {image.mode}")
            if image.getchannel("A").getextrema()[0] != 0:
                raise ValueError(f"Tactical sprite lacks transparency: {source}")
        for suffix in ("", "_dead", "_injured"):
            name = f"afei_figure_{cid}{suffix}"
            target = ICONS / f"{name}.png"
            if suffix == "_injured":
                # The native injury_body layer is an overlay on top of body.
                # A blank overlay keeps the custom figure from being doubled.
                Image.new("RGBA", (114, 142)).save(target)
            else:
                shutil.copyfile(source, target)
            attrs = {
                "id": name,
                "offsetY": "35",
                "width": "114",
                "height": "142",
                "img": f"icons\\{name}.png",
                "left": "-57",
                "right": "57",
                "top": "-55",
                "bottom": "87",
            }
            if name in existing:
                existing[name].attrib.clear()
                existing[name].attrib.update(attrs)
            else:
                ET.SubElement(brush, "sprite", attrs)
    ET.indent(tree, space="  ")
    tree.write(METADATA, encoding="utf-8", xml_declaration=False)
    tree.write(PACK_METADATA, encoding="utf-8", xml_declaration=False)
    print("Installed 6 complete tactical busts, corpse sprites and injury overlays")


if __name__ == "__main__":
    main()
