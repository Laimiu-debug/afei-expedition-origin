"""Patch only Naigai's three sprites in existing packages; preserve gameplay bytes."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from zipfile import ZipFile

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from build_afei_art import pack_and_verify
from check_gameplay import validate_custom_art

OUT = Path(__file__).resolve().parent
BASE = ROOT / 'art/runtime/portraits-v05'
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe'
ATLAS = 'afeix_portraits_v04'
ART = [f'brushes/{ATLAS}.brush', f'gfx/{ATLAS}.png']
UPDATED = {f'afeix_p04_naigai{s}' for s in ('', '_head', '_dead')}

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def pixels(path):
    with Image.open(path) as im:
        im = im.convert('RGBA')
        return im.size, hashlib.sha256(im.tobytes()).hexdigest()

def patch(original, name):
    with tempfile.TemporaryDirectory(prefix='naigai-package-', dir=ROOT / '.cache/afei-art') as tmp:
        stage = Path(tmp)
        raw = stage / 'original'
        decoded = stage / 'decoded'
        with ZipFile(original) as z:
            assert z.testzip() is None
            for member in ART:
                path = raw / member
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(z.read(member))
        subprocess.run([str(KIT), 'unpack', '--gfxPath', str(raw), str(raw / ART[0]), str(decoded)], check=True, capture_output=True)
        attrs = [dict(e.attrib) for e in ET.parse(decoded / 'metadata.xml').getroot()]
        assert len(attrs) == 108 and len({a['id'] for a in attrs}) == 108
        assert UPDATED.issubset({a['id'] for a in attrs})
        baseline = {}
        (stage / 'sprites').mkdir()
        pack = stage / 'pack-input'
        (pack / 'sprites').mkdir(parents=True)
        (stage / 'build').mkdir()
        non_naigai_matches_source = True
        for item in attrs:
            identity = item['id']
            prior = (decoded / item['img'].replace('\\', '/')).resolve()
            assert prior.is_relative_to(decoded.resolve())
            baseline[identity] = pixels(prior)
            selected = BASE / 'sprites' / (identity + '.png') if identity in UPDATED else prior
            if identity not in UPDATED and pixels(prior) != pixels(BASE / 'sprites' / (identity + '.png')):
                non_naigai_matches_source = False
            assert pixels(selected)[0] == (114, 142)
            shutil.copyfile(selected, stage / 'sprites' / (identity + '.png'))
            shutil.copyfile(selected, pack / 'sprites' / (identity + '.png'))
            item['img'] = 'sprites\\' + identity + '.png'
        result = pack_and_verify(stage, ATLAS, pack, attrs, KIT)
        assert result['passed']
        changed = sorted(identity for identity in baseline if pixels(stage / 'sprites' / (identity + '.png')) != baseline[identity])
        assert changed == sorted(UPDATED), changed
        # Each old package keeps its other portraits, even if the installed version is older.
        replacement = {member: (stage / 'package' / member).read_bytes() for member in ART}
        destination = OUT / (name + '-mod_afeix_expedition.zip')
        with ZipFile(original) as old, ZipFile(destination, 'w') as new:
            new.comment = old.comment
            for info in old.infolist():
                new.writestr(info, replacement.get(info.filename, old.read(info.filename)))
        with ZipFile(original) as old, ZipFile(destination) as new:
            assert new.testzip() is None
            assert old.namelist() == new.namelist()
            changed_entries = [n for n in old.namelist() if old.read(n) != new.read(n)]
            assert set(changed_entries).issubset(ART) and ART[1] in changed_entries
            for n in old.namelist():
                if n not in ART:
                    assert old.read(n) == new.read(n)
        return {
            'base_package': str(original), 'base_sha256': sha(original),
            'staged_package': str(destination), 'sha256': sha(destination),
            'changed_entries': changed_entries, 'changed_sprites': changed,
            'non_naigai_matches_current_source': non_naigai_matches_source,
            'all_other_sprite_pixels_preserved': True,
            'all_other_zip_entries_preserved': True,
            'atlas_pixels_and_anchors_roundtrip_passed': True,
            'crc_passed': True,
        }

art_check = validate_custom_art()
report = {
    'date': '2026-09-27', 'character': 'naigai', 'custom_art_check': art_check,
    'in_game_tested': False, 'installed': False,
    'packages': [
        patch(ROOT / 'dist/mod_afeix_expedition.zip', 'dist'),
        patch(Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data/mod_afeix_expedition.zip'), 'installed'),
    ],
}
(OUT / 'validation.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'art_check': art_check['passed'], 'packages': [{k: p[k] for k in ('staged_package', 'changed_sprites', 'non_naigai_matches_current_source', 'crc_passed')} for p in report['packages']]}, ensure_ascii=False))
