"""Export reviewed Douyu trophies using native equipment sizes and anchors.

The source art remains untouched. Exports use alpha crop, uniform resampling,
transparent placement and the native cleaver inventory horizontal reflection.
Native reference pixels live only under .cache and never enter this atlas.
"""
from pathlib import Path
import hashlib
import json
import shutil

from PIL import Image, ImageDraw
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "art/runtime/douyu-trophies-v01"
ATLAS = "afeix_douyu_trophies_v01"
BBRUSHER = ROOT / ".cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe"
SOURCE_KEYS = ("sharkskin-inventory", "sharkskin-live", "sharkskin-damaged", "sharkskin-dead",
               "fin-cleaver", "fin-cleaver-bloodied", "tooth-spear", "tooth-spear-bloodied")
GEOMETRY = {
    "afeix_douyu_sharkskin": {"left": -48, "right": 46, "top": -52, "bottom": 14,
                              "width": 104, "height": 142, "offsetY": 35},
    "afeix_douyu_sharkskin_damaged": {"left": -52, "right": 48, "top": -52, "bottom": 22,
                                      "width": 104, "height": 142, "offsetY": 35},
    "afeix_douyu_sharkskin_dead": {"left": -57, "right": 59, "top": -53, "bottom": 55,
                                  "width": 131, "height": 125, "offsetX": 6, "offsetY": 10, "f": "64FE"},
    "afeix_douyu_fin_cleaver": {"left": -65, "right": 13, "top": -56, "bottom": 52,
                                "width": 130, "height": 142, "offsetY": 35},
    "afeix_douyu_fin_cleaver_bloodied": {"left": -65, "right": 13, "top": -56, "bottom": 52,
                                         "width": 130, "height": 142, "offsetY": 35},
    "afeix_douyu_tooth_spear": {"left": -3, "right": 57, "top": -59, "bottom": 21,
                                "width": 130, "height": 142, "offsetY": 35, "f1": "20", "f2": "-45"},
    "afeix_douyu_tooth_spear_bloodied": {"left": -3, "right": 57, "top": -59, "bottom": 21,
                                         "width": 130, "height": 142, "offsetY": 35, "f1": "20", "f2": "-45"},
}
SPRITE_SOURCES = dict(zip(GEOMETRY, SOURCE_KEYS[1:4] + SOURCE_KEYS[4:]))
ITEMS = {
    "sharkskin": ("armor", "sharkskin-inventory", False),
    "fin_cleaver": ("weapons/melee", "fin-cleaver", True),
    "tooth_spear": ("weapons/melee", "tooth-spear", False),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source(key):
    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    if set(manifest["sources"]) != set(SOURCE_KEYS):
        raise ValueError("Trophy manifest must cover the eight dedicated source images")
    record = manifest["sources"][key]
    path = (BASE / record["source"]).resolve()
    if not path.is_relative_to((BASE / "sources").resolve()):
        raise ValueError("Trophy source must live under sources/")
    if manifest.get("source_art_reviewed") is not True or record["reviewed_for_export"] is not True or sha(path) != record["sha256"]:
        raise ValueError("Unreviewed or changed trophy artwork: " + key)
    with Image.open(path) as original:
        if original.mode != "RGBA" or original.getchannel("A").getextrema()[0] != 0 or original.getchannel("A").getextrema()[1] < 200:
            raise ValueError("Trophy source requires genuine transparent alpha: " + key)
        image = original.copy()
    box = image.getchannel("A").point(lambda a: 255 if a >= 20 else 0).getbbox()
    if box is None:
        raise ValueError("Empty trophy image: " + key)
    return image.crop(box)


def fit(image, size, padding=1, mirror=False):
    result = Image.new("RGBA", size)
    scaled = image.transpose(Image.Transpose.FLIP_LEFT_RIGHT) if mirror else image.copy()
    scaled.thumbnail((size[0] - 2 * padding, size[1] - 2 * padding), Image.Resampling.LANCZOS)
    result.alpha_composite(scaled, ((size[0] - scaled.width) // 2, (size[1] - scaled.height) // 2))
    return result


def exports():
    for identity, (folder, key, mirror) in ITEMS.items():
        for suffix, size in (("", (70, 140)), ("_70x70", (70, 70))):
            yield f"gfx/ui/items/{folder}/afeix_douyu_{identity}{suffix}.png", fit(source(key), size, 2, mirror)


def make_preview():
    # These are existing, user-approved custom portraits, not native pixels.
    portrait = ROOT / "art/runtime/portraits-v05/sprites/afeix_p04_afei_normal.png"
    head = portrait.with_name("afeix_p04_afei_normal_head.png")
    corpse_head = portrait.with_name("afeix_p04_afei_normal_corpse_head.png")
    preview = Image.new("RGB", (1080, 520), "#b7ae98")
    draw = ImageDraw.Draw(preview)
    draw.text((16, 12), "OFFLINE TROPHY REVIEW - actual sizes and brush anchors; not an in-game screenshot", fill="#302923")
    for column, (identity, (folder, _, _)) in enumerate(ITEMS.items()):
        x = 30 + column * 340
        for suffix, offset in (("", 0), ("_70x70", 90)):
            with Image.open(ROOT / f"src/gfx/ui/items/{folder}/afeix_douyu_{identity}{suffix}.png") as icon:
                preview.paste(icon, (x + offset, 50), icon)
        draw.text((x, 202), identity + ": 70x140 / 70x70", fill="#302923")
    for column, (armor, weapon, label) in enumerate([
        ("afeix_douyu_sharkskin", "afeix_douyu_fin_cleaver", "intact armor + cleaver"),
        ("afeix_douyu_sharkskin_damaged", "afeix_douyu_tooth_spear", "damaged armor + spear"),
        (None, None, "corpse armor / bloodied arms")]):
        frame = Image.new("RGBA", (330, 265))
        origin = (150, 170)
        if armor is not None:
            if portrait.is_file():
                with Image.open(portrait) as body:
                    frame.alpha_composite(body.convert("RGBA"), (origin[0]-57, origin[1]-91))
            for identity in (armor, weapon):
                meta = GEOMETRY[identity]
                with Image.open(BASE / "sprites" / (identity + ".png")) as image:
                    frame.alpha_composite(image, (origin[0]+meta["left"], origin[1]-meta["bottom"]))
            if head.is_file():
                with Image.open(head) as image:
                    frame.alpha_composite(image.convert("RGBA"), (origin[0]-57, origin[1]-91))
        else:
            # Reviewed custom prone head uses its own native-compatible anchor.
            # No native reference pixels appear in this distributable preview.
            corpse_origin = (85, 160)
            meta = GEOMETRY["afeix_douyu_sharkskin_dead"]
            with Image.open(BASE / "sprites/afeix_douyu_sharkskin_dead.png") as image:
                frame.alpha_composite(image, (corpse_origin[0]+meta["left"], corpse_origin[1]-meta["bottom"]))
            if corpse_head.is_file():
                with Image.open(corpse_head) as image:
                    frame.alpha_composite(image.convert("RGBA"), (corpse_origin[0]-80, corpse_origin[1]-65))
            for identity, position in (("afeix_douyu_fin_cleaver_bloodied", (166, 55)),
                                       ("afeix_douyu_tooth_spear_bloodied", (256, 55))):
                with Image.open(BASE / "sprites" / (identity + ".png")) as image:
                    frame.alpha_composite(image, position)
        preview.paste(frame, (column * 350 + 12, 238), frame)
        draw.text((column * 350 + 26, 498), label, fill="#302923")
    preview.save(BASE / "preview.png")
    preview.resize((2160, 1040), Image.Resampling.NEAREST).save(BASE / "preview-2x.png")


def build_art():
    (BASE / "sprites").mkdir(parents=True, exist_ok=True)
    (BASE / "build").mkdir(exist_ok=True)
    pack = BASE / "pack"
    (pack / "sprites").mkdir(parents=True, exist_ok=True)
    records = []
    for relative, image in exports():
        path = ROOT / "src" / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        image.save(path)
        package_path = BASE / "package" / relative
        package_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, package_path)
        records.append({"path": relative, "sha256": sha(path), "size": list(image.size)})
    attrs, sprite_records = [], []
    for identity, geometry in GEOMETRY.items():
        size = (geometry["right"]-geometry["left"], geometry["bottom"]-geometry["top"])
        sprite = fit(source(SPRITE_SOURCES[identity]), size, 0)
        sprite.save(BASE / "sprites" / (identity + ".png"))
        sprite.save(pack / "sprites" / (identity + ".png"))
        attrs.append({"id": identity, "img": f"sprites\\{identity}.png", **{k: str(v) for k,v in geometry.items()}})
        sprite_records.append({"id": identity, "source_key": SPRITE_SOURCES[identity],
                               "sha256": sha(BASE / "sprites" / (identity + ".png")), "size": list(size)})
    report = {"schema": 1, "atlas": ATLAS, "manifest_sha256": sha(BASE / "manifest.json"),
              "exports": records, "sprites": sprite_records, "geometry": GEOMETRY, "source_art_reviewed": True,
              "native_reference_pixels_packaged": False, "in_game_tested": False,
              "inventory_reflection": {"fin_cleaver": True, "tooth_spear": False},
              "roundtrip": pack_and_verify(BASE, ATLAS, pack, attrs, BBRUSHER)}
    for relative in (f"brushes/{ATLAS}.brush", f"gfx/{ATLAS}.png"):
        destination = ROOT / "src" / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(BASE / "package" / relative, destination)
    (BASE / "report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    make_preview()
    return report


def validate_art():
    from check_gameplay import verify_custom_atlas, verify_sprite
    report = json.loads((BASE / "report.json").read_text(encoding="utf-8"))
    if report["manifest_sha256"] != sha(BASE / "manifest.json"):
        raise ValueError("Trophy manifest changed after export")
    expected = dict(exports())
    if set(expected) != {row["path"] for row in report["exports"]}:
        raise ValueError("Trophy export set differs")
    for row in report["exports"]:
        path = ROOT / "src" / row["path"]
        with Image.open(path) as image:
            if image.mode != "RGBA" or image.size != expected[row["path"]].size or image.tobytes() != expected[row["path"]].tobytes():
                raise ValueError("Trophy export pixels differ: " + row["path"])
        if sha(path) != row["sha256"]:
            raise ValueError("Trophy export fingerprint differs")
        if sha(BASE / "package" / row["path"]) != row["sha256"]:
            raise ValueError("Trophy package icon fingerprint differs")
    atlas = verify_custom_atlas(BASE, ATLAS, report, set(GEOMETRY))
    sprite_records = {row["id"]: row for row in report.get("sprites", [])}
    if set(sprite_records) != set(GEOMETRY) or len(report.get("sprites", [])) != len(GEOMETRY):
        raise ValueError("Trophy sprite report must cover the seven brushes")
    for identity, geometry in GEOMETRY.items():
        path = BASE / "sprites" / (identity + ".png")
        expected_sprite = fit(source(SPRITE_SOURCES[identity]), (geometry["right"]-geometry["left"], geometry["bottom"]-geometry["top"]), 0)
        row = sprite_records[identity]
        with Image.open(path) as image:
            if image.mode != "RGBA" or image.size != expected_sprite.size or image.tobytes() != expected_sprite.tobytes():
                raise ValueError("Trophy brush pixels differ from approved source: " + identity)
        if row["source_key"] != SPRITE_SOURCES[identity] or row["size"] != list(expected_sprite.size) or row["sha256"] != sha(path):
            raise ValueError("Trophy sprite report differs: " + identity)
        verify_sprite(atlas["sprites"][identity], path, geometry)
    return {"passed": True, "files": len(expected) + 2, "brushes": len(GEOMETRY),
            "generated_source_art": True, "in_game_tested": False}


if __name__ == "__main__":
    build_art()
    print(validate_art())
