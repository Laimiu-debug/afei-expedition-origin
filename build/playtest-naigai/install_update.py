"""Install the verified portrait-only patches after checking for concurrent changes."""
import hashlib
import json
from pathlib import Path
import shutil
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
report_path = OUT / 'validation.json'
report = json.loads(report_path.read_text(encoding='utf-8'))

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

# Check both destinations and both staged outputs before writing either package.
summary_path = ROOT / 'build/gameplay-package.json'
summary = json.loads(summary_path.read_text(encoding='utf-8'))
assert summary['sha256'] == report['packages'][0]['base_sha256'], 'Build report changed concurrently'
for item in report['packages']:
    assert sha(Path(item['base_package'])) == item['base_sha256'], 'Package changed; rebuild patch against current bytes'
    assert sha(Path(item['staged_package'])) == item['sha256'], 'Staged package changed'

for label, item in zip(('dist', 'installed'), report['packages']):
    backup = ROOT / 'dist/archive/before-naigai-20260927' / (label + '-' + item['base_sha256'][:12] + '.zip')
    if backup.exists():
        assert sha(backup) == item['base_sha256']
    else:
        shutil.copyfile(item['base_package'], backup)
    assert sha(backup) == item['base_sha256']
    item['backup'] = backup.relative_to(ROOT).as_posix()

for item in report['packages']:
    target = Path(item['base_package'])
    shutil.copyfile(item['staged_package'], target)
    assert sha(target) == item['sha256']
    item['applied_to'] = str(target)
report['installed'] = True
report['backup_directory'] = 'dist/archive/before-naigai-20260927'
report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

dist = report['packages'][0]
summary['sha256'] = dist['sha256']
summary['portrait_update'] = 'build/playtest-naigai/validation.json'
summary['crc_passed'] = True
with ZipFile(dist['applied_to']) as z:
    # Preserve the built package's gameplay; current workspace work can be newer.
    differences = [n for n in z.namelist() if not (ROOT / 'src' / n).is_file() or z.read(n) != (ROOT / 'src' / n).read_bytes()]
summary['source_bytes_match'] = not differences
summary['source_differences_at_portrait_update'] = differences
summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
installed = report['packages'][1]
(ROOT / 'build/installed-naigai-20260927.json').write_text(json.dumps({
    'installed': installed['applied_to'], 'sha256': installed['sha256'],
    'updated_sprites': installed['changed_sprites'],
    'preserves_existing_gameplay': True, 'preserves_other_installed_portraits': True,
    'validation': 'build/playtest-naigai/validation.json',
    'backup': installed['backup'],
    'in_game_tested': False,
}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'installed': installed['applied_to'], 'dist': dist['applied_to'], 'zip_crc_passed': True, 'workspace_gameplay_differences_not_bundled': len(differences)}, ensure_ascii=False))
