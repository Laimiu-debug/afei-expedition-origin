"""Extract only local, ignored native fixtures required by the dream review.

No native script is checked in or copied to src/package output. The installed
game and existing modkit are prerequisites, exactly as for check_gameplay.py.
"""
from pathlib import Path
from zipfile import ZipFile
import argparse
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SOURCES = (
    "scripts/entity/tactical/tactical_entity_manager.cnut",
    "scripts/mapgen/map_template.cnut",
    "scripts/mapgen/tactical_template.cnut",
    "scripts/mapgen/templates/tactical/tactical_swamp.cnut",
    "scripts/mapgen/templates/tactical/patches/patch_swamp.cnut",
    "scripts/mapgen/templates/tactical/patches/patch_swamp_pond.cnut",
    "scripts/mapgen/templates/tactical/tiles/swamp1.cnut",
    "scripts/mapgen/templates/tactical/tiles/swamp2.cnut",
    "scripts/mapgen/templates/tactical/tiles/swamp3.cnut",
    "scripts/mapgen/templates/tactical/tiles/swamp4.cnut",
    "scripts/mapgen/templates/tactical/tiles/swamp5.cnut",
)


def prepare_dream_test_native(game: Path, *, output: Path | None = None) -> list[Path]:
    game = Path(game)
    archive_path = game / "data/data_001.dat"
    kit = ROOT / ".cache/afei-art/bbros-modkit-v9/bin"
    for path in (archive_path, kit / "bbsq.exe", kit / "nutcracker.exe"):
        if not path.is_file():
            raise FileNotFoundError(f"Dream native fixture prerequisite missing: {path}")
    destination = output or ROOT / ".cache/afei-art/dream-native"
    destination.mkdir(parents=True, exist_ok=True)
    created = []
    with ZipFile(archive_path) as archive:
        for source in SOURCES:
            bytecode = destination / Path(source).name
            bytecode.write_bytes(archive.read(source))
            subprocess.run([str(kit / "bbsq.exe"), "-d", str(bytecode)],
                           check=True, capture_output=True)
            result = subprocess.run([str(kit / "nutcracker.exe"), str(bytecode)],
                                    check=True, capture_output=True)
            native = bytecode.with_suffix(".nut")
            native.write_bytes(result.stdout)
            created.append(native)
    return created


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--game", type=Path,
                        default=Path("F:/SteamLibrary/steamapps/common/Battle Brothers"))
    args = parser.parse_args()
    files = prepare_dream_test_native(args.game)
    print(f"DREAM_NATIVE_FIXTURES={len(files)}")


if __name__ == "__main__":
    main()
