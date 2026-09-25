"""Format ImageGen face/hair sheets as native Battle Brothers tactical layers.

The creative artwork is in art/tactical-sprites/layer-sources. This tool only
splits the two transparent components, scales them to native sprite slots,
and updates the bbrusher metadata. Event portraits are untouched.
"""
from __future__ import annotations

from pathlib import Path
import re

from PIL import Image, ImageEnhance, ImageOps


ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "art/tactical-sprites/layer-sources"
SPRITES = ROOT / "art/tactical-sprites"
ICONS = SPRITES / "icons"
IDS = tuple(f"C{i:02}" for i in range(1, 7))
MIRROR = {"C01", "C03"}  # These sheets were painted facing screen left.
MIRROR_HAIR_AGAIN = {"C01", "C04", "C05"}
HAIR_DROP = {"C01": 12, "C02": 12, "C03": 12, "C04": 0, "C05": 0, "C06": 0}
HAIR_SIZE = {
    "C01": (62, 57),
    "C02": (68, 62),
    "C03": (68, 61),
    "C04": (91, 99),
    "C05": (70, 66),
    "C06": (91, 99),
}


def component(sheet: Image.Image, left: bool) -> Image.Image:
    w, h = sheet.size
    # On three sheets a few strands from the right component cross the
    # midpoint. Keep them out of the face extraction.
    half = sheet.crop((0 if left else w // 2, 0, min(750, w // 2) if left else w, h))
    mask = half.getchannel("A").point(lambda a: 255 if a >= 20 else 0)
    box = mask.getbbox()
    if box is None:
        raise ValueError("transparent component")
    return half.crop(box)


def head_sprite(face: Image.Image) -> Image.Image:
    # Keep the painted face's aspect ratio. Stretching every face to 50 x 68
    # squeezed wider faces and made the heads look visibly flat.
    face.thumbnail((52, 68), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (54, 68))
    canvas.alpha_composite(face, ((54 - face.width) // 2, 68 - face.height))
    return canvas


def body_sprite(source: Image.Image) -> Image.Image:
    mask = source.getchannel("A").point(lambda a: 255 if a >= 128 else 0)
    box = mask.getbbox()
    if box is None:
        raise ValueError("transparent body")
    source = source.crop(box)
    source.thumbnail((108, 76), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (108, 76))
    canvas.alpha_composite(source, ((108 - source.width) // 2, 76 - source.height))
    return canvas


def hair_sprite(hair: Image.Image, cid: str, face: Image.Image) -> Image.Image:
    # Native hair is a separate, helmet-controlled sprite. Long locks may hang
    # over armor; they contain no painted armor, shield, or weapon.
    width, height = HAIR_SIZE[cid]
    hair.thumbnail((width, height), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (140, 140))
    x = 74 - hair.width // 2
    y = (18 if cid in {"C04", "C06"} else 22) + HAIR_DROP[cid]
    if cid == "C04":
        x += 8
    canvas.alpha_composite(hair, (x, y))
    return canvas


def dead_sprite(sprite: Image.Image) -> Image.Image:
    dead = ImageEnhance.Brightness(ImageOps.grayscale(sprite).convert("RGBA")).enhance(0.55)
    dead.putalpha(sprite.getchannel("A"))
    return dead


def update_metadata(path: Path) -> None:
    lines = path.read_text(encoding="utf-8").splitlines()
    seen: set[str] = set()
    for index, line in enumerate(lines):
        match = re.search(r'<sprite id="afei_(head|hair|body)_(C0[1-6])(_dead)?"', line)
        if match is None:
            continue
        kind, cid = match.group(1), match.group(2)
        seen.add(cid)
        if kind == "head":
            for attr, value in (("width", 140), ("height", 140), ("left", -70), ("right", 70), ("top", -50), ("bottom", 90)) if cid == "C04" else (("width", 104), ("height", 142), ("left", -23), ("right", 31), ("top", -20), ("bottom", 48)):
                line = re.sub(fr'{attr}="-?\d+"', f'{attr}="{value}"', line)
        elif kind == "hair":
            line = re.sub(r'width="\d+"', 'width="140"', line)
            line = re.sub(r'height="\d+"', 'height="140"', line)
            line = re.sub(r'left="-?\d+"', 'left="-70"', line)
            line = re.sub(r'right="-?\d+"', 'right="70"', line)
            line = re.sub(r'top="-?\d+"', 'top="-50"', line)
            line = re.sub(r'bottom="-?\d+"', 'bottom="90"', line)
        else:
            for attr, value in (("width", 114), ("height", 142), ("left", -54), ("right", 54), ("top", -55), ("bottom", 21)):
                line = re.sub(fr'{attr}="-?\d+"', f'{attr}="{value}"', line)
        lines[index] = line
    if seen != set(IDS):
        raise ValueError(f"missing metadata for {set(IDS) - seen}")
    for cid in IDS:
        for suffix in ("", "_dead"):
            name = f"afei_body_{cid}{suffix}"
            if any(f'id="{name}"' in line for line in lines):
                continue
            lines.insert(-1, f'  <sprite id="{name}" offsetY="35" width="114" height="142" img="icons\\{name}.png" left="-54" right="54" top="-55" bottom="21" />')
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    ICONS.mkdir(parents=True, exist_ok=True)
    for cid in IDS:
        sheet = Image.open(SOURCES / f"{cid}.png").convert("RGBA")
        face_art, hair_art = component(sheet, True), component(sheet, False)
        if cid in MIRROR:
            face_art, hair_art = ImageOps.mirror(face_art), ImageOps.mirror(hair_art)
        if cid in MIRROR_HAIR_AGAIN:
            hair_art = ImageOps.mirror(hair_art)
        face = head_sprite(face_art)
        hair = hair_sprite(hair_art, cid, face)
        if cid == "C04":
            # Long hair sits behind the face; only the upper fringe crosses it.
            # The native head layer can hold this combined hair/face silhouette.
            merged = hair.copy()
            merged.alpha_composite(face, (47, 30))
            merged.alpha_composite(hair.crop((0, 0, 140, 67)), (0, 0))
            face = merged
            hair = Image.new("RGBA", (140, 140))
        for kind, sprite in (("head", face), ("hair", hair)):
            name = f"afei_{kind}_{cid}"
            sprite.save(ICONS / f"{name}.png")
            dead_sprite(sprite).save(ICONS / f"{name}_dead.png")
        body = body_sprite(Image.open(SOURCES / f"body-{cid}.png").convert("RGBA"))
        body.save(ICONS / f"afei_body_{cid}.png")
        dead_sprite(body).save(ICONS / f"afei_body_{cid}_dead.png")
        print(f"{cid}: proportional head 54x68 + hair 140x140 + costume 108x76")
    update_metadata(SPRITES / "sprites.xml")


if __name__ == "__main__":
    main()
