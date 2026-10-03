"""Extract ignored local native sources for the Douyu world lifecycle tests."""
from pathlib import Path
from zipfile import ZipFile
import argparse
import subprocess

ROOT = Path(__file__).resolve().parents[1]
SOURCES = (
    "scripts/entity/world/world_entity.cnut",
    "scripts/entity/world/location.cnut",
    "scripts/entity/world/entity_manager.cnut",
    "scripts/entity/world/locations/legendary/black_monolith_location.cnut",
    "scripts/entity/world/locations/legendary/kraken_cult_location.cnut",
    "scripts/states/world_state.cnut",
    "scripts/config/world_entity_common.cnut",
    "scripts/config/world_locations.cnut",
    "scripts/tools/tag_collection.cnut",
    "scripts/tools/weak_table_ref.cnut",
    "scripts/items/stash_container.cnut",
)


def prepare_douyu_world_native(game: Path, *, output: Path | None = None) -> list[Path]:
    archive = Path(game) / "data/data_001.dat"
    kit = ROOT / ".cache/afei-art/bbros-modkit-v9/bin"
    for required in (archive, kit / "bbsq.exe", kit / "nutcracker.exe"):
        if not required.is_file():
            raise FileNotFoundError(f"Douyu world native prerequisite missing: {required}")
    destination = output or ROOT / ".cache/afei-art/douyu-world-native"
    destination.mkdir(parents=True, exist_ok=True)
    files = []
    with ZipFile(archive) as data:
        for source in SOURCES:
            bytecode = destination / Path(source).name
            bytecode.write_bytes(data.read(source))
            subprocess.run([str(kit / "bbsq.exe"), "-d", str(bytecode)], check=True, capture_output=True)
            result = subprocess.run([str(kit / "nutcracker.exe"), str(bytecode)], check=True, capture_output=True)
            native = bytecode.with_suffix(".nut")
            native.write_bytes(result.stdout)
            files.append(native)
    return files


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--game", type=Path, default=Path("F:/SteamLibrary/steamapps/common/Battle Brothers"))
    args = parser.parse_args()
    print(f"DOUYU_WORLD_NATIVE_FIXTURES={len(prepare_douyu_world_native(args.game))}")
