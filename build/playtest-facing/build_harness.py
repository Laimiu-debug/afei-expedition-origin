"""Build ONLY the disposable engine-playtest adapter, not the production mod."""
from pathlib import Path
import hashlib
import json
import subprocess
from zipfile import ZipFile, ZIP_DEFLATED

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[1]
files = sorted((BASE / 'source').rglob('*.nut'))
out = BASE / 'compiled'
out.mkdir(exist_ok=True)
for i, path in enumerate(files):
    subprocess.run([str(ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe'), '-c',
                    '-o', str(out / f'{i}.cnut'), str(path)], check=True)
destination = BASE / 'mod_afeix_facing_playtest.zip'
with ZipFile(destination, 'w', ZIP_DEFLATED) as archive:
    for path in files:
        archive.write(path, path.relative_to(BASE / 'source').as_posix())
with ZipFile(destination) as archive:
    assert archive.testzip() is None
report = {'package': str(destination), 'sha256': hashlib.sha256(destination.read_bytes()).hexdigest(),
          'compiled_sources': len(files), 'game_installed': False, 'engine_verified': False,
          'requires': ['mod_afeix_expedition.zip', 'Legacy Script Hooks'],
          'production_src_modified': False, 'entry': 'Scenarios > first entry (id 0)'}
(BASE / 'harness-report.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, indent=2))
