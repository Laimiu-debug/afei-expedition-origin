"""Validate actual sound files and native brush IDs used by combat feedback."""
from pathlib import Path
from zipfile import ZipFile
import re

ROOT = Path(__file__).resolve().parents[2]
game = Path("F:/SteamLibrary/steamapps/common/Battle Brothers/data")
files, brush_bytes = set(), []
for path in game.glob("data_*.dat"):
    with ZipFile(path) as z:
        files.update(z.namelist())
        brush_bytes.extend(z.read(n) for n in z.namelist() if n.endswith(".brush"))
assert files, "Installed game resources required"
brushes = b"\n".join(brush_bytes)
checks = 0
for path in (ROOT / "src/scripts").rglob("*.nut"):
    source = path.read_text(encoding="utf-8-sig")
    for sound in set(re.findall(r'"(sounds/[A-Za-z0-9_/]+\.wav)"', source)):
        assert sound in files, (path.name, sound)
        checks += 1
    for brush in set(re.findall(r'"((?:status_effect|active|perk)_\d+(?:_active|_mini)?)"', source)):
        encoded = brush.encode()
        assert len(encoded).to_bytes(2, "little") + encoded in brushes, (path.name, brush)
        checks += 1
print(f"TESTS_PASSED={checks}")
