"""Build the playable mod zip from src/."""
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
OUT = ROOT / "dist" / "mod_afei_expedition.zip"
EXCLUDE = {".DS_Store", "Thumbs.db"}

def main():
    OUT.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(SRC.rglob("*")):
            if not path.is_file() or path.name in EXCLUDE:
                continue
            zf.write(path, path.relative_to(SRC).as_posix())
    print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")

if __name__ == "__main__":
    main()
