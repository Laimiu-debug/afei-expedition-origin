"""Export the generated nose-down rocket into a verified native particle brush."""
from pathlib import Path
import hashlib
import json
import shutil
from PIL import Image
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "art/runtime/douyu-rocket-v01"
ATLAS = "afeix_douyu_rocket_v01"
IDENTITY = "afeix_douyu_rocket_falling"
GEOMETRY = dict(left=-32, right=32, top=-180, bottom=0, width=64, height=180, offsetX=0, offsetY=0)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def export():
    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    source = BASE / manifest["source"]
    if not manifest["reviewed_for_export"] or sha(source) != manifest["sha256"]:
        raise ValueError("Rocket source is changed or unreviewed")
    with Image.open(source) as image:
        if image.mode != "RGBA" or image.getchannel("A").getextrema() != (0, 255):
            raise ValueError("Rocket source requires genuine transparent alpha")
        bounds = image.getchannel("A").point(lambda a: 255 if a >= 20 else 0).getbbox()
        sprite = image.crop(bounds)
    sprite.thumbnail((60, 176), Image.Resampling.LANCZOS)
    result = Image.new("RGBA", (64, 180))
    result.alpha_composite(sprite, ((64 - sprite.width) // 2, 178 - sprite.height))
    return result


def build():
    sprite = export()
    pack = BASE / "pack"
    for directory in (BASE / "sprites", BASE / "build", pack / "sprites"):
        directory.mkdir(parents=True, exist_ok=True)
    sprite.save(BASE / "sprites" / (IDENTITY + ".png"))
    sprite.save(pack / "sprites" / (IDENTITY + ".png"))
    attrs = [{"id": IDENTITY, "img": "sprites\\" + IDENTITY + ".png", **{k: str(v) for k, v in GEOMETRY.items()}}]
    report = {"manifest_sha256": sha(BASE / "manifest.json"), "source_sha256": sha(BASE / "sources/falling-rocket.png"),
              "sprite_sha256": sha(BASE / "sprites" / (IDENTITY + ".png")), "geometry": GEOMETRY,
              "in_game_tested": False, "roundtrip": pack_and_verify(BASE, ATLAS, pack, attrs, ROOT / ".cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe")}
    for relative in (f"brushes/{ATLAS}.brush", f"gfx/{ATLAS}.png"):
        shutil.copyfile(BASE / "package" / relative, ROOT / "src" / relative)
    (BASE / "report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def validate_art():
    from check_gameplay import verify_custom_atlas, verify_sprite
    report = json.loads((BASE / "report.json").read_text(encoding="utf-8"))
    assert report["manifest_sha256"] == sha(BASE / "manifest.json")
    sprite = BASE / "sprites" / (IDENTITY + ".png")
    assert report["source_sha256"] == sha(BASE / "sources/falling-rocket.png")
    assert report["sprite_sha256"] == sha(sprite)
    with Image.open(sprite) as image:
        assert image.mode == "RGBA" and image.size == (64, 180) and image.tobytes() == export().tobytes()
    atlas = verify_custom_atlas(BASE, ATLAS, report, {IDENTITY})
    verify_sprite(atlas["sprites"][IDENTITY], sprite, GEOMETRY)
    return {"passed": True, "brushes": 1, "particle_size": [64, 180], "nose_anchor": "ground", "in_game_tested": False}


if __name__ == "__main__":
    build()
    print(validate_art())
