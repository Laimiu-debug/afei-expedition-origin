"""Verify the actual trophy artifacts and every equipment-to-art binding."""
from pathlib import Path
import re
import sys

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))
from build_douyu_trophy_art import GEOMETRY, validate_art


def main():
    result = validate_art()
    if not result["passed"]:
        raise AssertionError("Trophy atlas validation failed")
    checks = 1
    for folder, name in (("armor", "sharkskin"), ("weapons", "fin_cleaver"), ("weapons", "tooth_spear")):
        source = (ROOT / f"src/scripts/items/{folder}/legendary/afeix_douyu_{name}.nut").read_text(encoding="utf-8")
        for field, size in (("Icon", (70, 70)), ("IconLarge", (70, 140))):
            match = re.search(r"this\.m\." + field + r'\s*=\s*"([^"]+)"', source)
            if not match:
                raise AssertionError(f"{name}: missing runtime {field} binding")
            with Image.open(ROOT / "src/gfx/ui/items" / match[1]) as image:
                if image.mode != "RGBA" or image.size != size or image.getchannel("A").getextrema()[1] == 0:
                    raise AssertionError(f"{name}: invalid runtime {field} image")
            checks += 1
        for field in (("Sprite", "SpriteDamaged", "SpriteCorpse") if folder == "armor" else ("ArmamentIcon", "ArmamentIconBloody")):
            match = re.search(r"this\.m\." + field + r'\s*=\s*"([^"]+)"', source)
            if not match or match[1] not in GEOMETRY:
                raise AssertionError(f"{name}: {field} references an unavailable trophy brush")
            checks += 1
    print(f"TESTS_PASSED={checks}")


if __name__ == "__main__":
    main()
