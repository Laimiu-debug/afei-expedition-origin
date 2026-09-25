"""Show the first six tactical costumes with native, changeable equipment layers."""
from pathlib import Path
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
NATIVE = ROOT / "test-output/vanilla-layer-audit/entity_0"
CUSTOM = ROOT / "art/tactical-sprites"
STARTING = {
    "C01": ("icon_mace_02", "shield_buckler_01"),
    "C02": ("icon_hunting_bow", None),
    "C03": ("icon_spear_01", "shield_round_00"),
    "C04": ("icon_sword_01", "shield_round_00"),
    "C05": ("icon_hunting_bow", None),
    "C06": ("icon_spear_01", "shield_buckler_01"),
}
ALTERNATE = ("icon_sword_01", "shield_round_00")
LABELS = ("角色衣服＋头发", "初始武器、盾牌", "换装示例：剑＋圆盾")


def metadata(folder: Path, file: str = "metadata.xml") -> dict[str, tuple[Path, int, int]]:
    result = {}
    for item in ET.parse(folder / file).getroot():
        path = folder / item.attrib["img"].replace("\\", "/")
        width = int(item.attrib.get("width", 104))
        height = int(item.attrib.get("height", 142))
        result[item.attrib["id"]] = (
            path,
            int(item.attrib.get("left", -width // 2)),
            int(item.attrib.get("bottom", height // 2)),
        )
    return result


def draw_sprite(canvas: Image.Image, refs: dict, name: str) -> None:
    path, left, bottom = refs[name]
    img = Image.open(path).convert("RGBA")
    canvas.alpha_composite(img, (36 + 52 + left, 20 + 71 - bottom))


def render(cid: str, mode: int, refs: dict) -> Image.Image:
    canvas = Image.new("RGBA", (180, 190), (31, 27, 23, 255))
    for part in ("body", "head", "hair"):
        draw_sprite(canvas, refs, f"afei_{part}_{cid}")
    weapon, shield = STARTING[cid] if mode == 1 else ALTERNATE if mode == 2 else (None, None)
    if shield:
        draw_sprite(canvas, refs, shield)
    if weapon:
        draw_sprite(canvas, refs, weapon)
    return canvas


def main() -> None:
    refs = metadata(NATIVE)
    refs.update(metadata(NATIVE.parent / "entity_1"))
    refs.update(metadata(NATIVE.parent / "entity_icons"))
    refs.update(metadata(CUSTOM, "sprites.xml"))
    sheet = Image.new("RGB", (6 * 180, 3 * 220), (31, 27, 23))
    draw = ImageDraw.Draw(sheet)
    font_path = Path("C:/Windows/Fonts/msyh.ttc")
    font = ImageFont.truetype(str(font_path), 13) if font_path.exists() else ImageFont.load_default()
    for row in range(3):
        for col, cid in enumerate(STARTING):
            sheet.paste(render(cid, row, refs).convert("RGB"), (col * 180, row * 220))
            draw.text((col * 180 + 9, row * 220 + 190), f"{cid}  {LABELS[row]}", fill=(230, 220, 200), font=font)
    dest = ROOT / "art/reviews/layered-C01-C06-equipment-preview.jpg"
    dest.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(dest, quality=95)
    print(dest)


if __name__ == "__main__":
    main()
