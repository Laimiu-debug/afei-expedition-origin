"""Check the current playable roster and legacy C11 load files in the release ZIP."""
from pathlib import Path
import hashlib
import json
import zipfile

root = Path(__file__).resolve().parents[1]
doc = json.loads((root / "data/document-v0.6.2.json").read_text(encoding="utf-8"))
assert len(doc) == 32 and "C11" not in doc
assert [doc[c]["name"] for c in ("C32", "C33", "C34")] == ["小宁", "小胖", "蔓越莓"]
assert all(doc[c]["background"] for c in ("C32", "C33", "C34"))

path = root / "dist/mod_afei_expedition.zip"
with zipfile.ZipFile(path) as z:
    assert z.testzip() is None
    names = set(z.namelist())
    chars = z.read("scripts/mods/afei/definitions.nut").decode("utf-8").split("::AfeiExpedition.SkillDefs", 1)[0]
    assert '["C11"]=' not in chars
    assert all(f'["{cid}"]=' in chars for cid in ("C32", "C33", "C34"))
    assert "scripts/skills/backgrounds/afei_c11_background.nut" in names
    for cid in ("C32", "C33", "C34"):
        assert f"scripts/skills/backgrounds/afei_{cid.lower()}_background.nut" in names
    for sid in ("pang_anchor", "pang_share", "pang_breath", "berry_eye", "berry_mark", "berry_reserve"):
        assert f"scripts/skills/actives/afei_{sid}.nut" in names
print("ROSTER_PACKAGE_OK", len(doc), "characters", len(names), "entries")
print("SHA256", hashlib.sha256(path.read_bytes()).hexdigest().upper())
