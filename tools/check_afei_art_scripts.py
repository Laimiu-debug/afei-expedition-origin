"""Compile the art adapter and verify preview-origin paths in an installed game."""
from pathlib import Path
from zipfile import ZipFile
import argparse
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/afei/v1'
CACHE = ROOT / '.cache/afei-art'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--game', type=Path, default=Path('F:/SteamLibrary/steamapps/common/Battle Brothers'))
    args = parser.parse_args()
    files = sorted((BASE / 'package/scripts').rglob('*.nut'))
    if not files:
        raise ValueError('No art scripts found')
    runner = CACHE / 'check-art-syntax.nut'
    runner.write_text('local failed=0;\n' + '\n'.join(
        'try { loadfile(' + json.dumps(p.as_posix()) + ', true); print("OK ' + p.name + '\\n"); } catch(e) { print("FAIL ' + p.name + ': "+e+"\\n"); failed++; }'
        for p in files) + '\nprint("FAILURES="+failed+"\\n");\n', encoding='utf-8')
    result = subprocess.run([str(CACHE / 'bbros-modkit-v9/bin/sq.exe'), str(runner)], capture_output=True)
    log = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode != 0 or 'FAILURES=0' not in log:
        raise RuntimeError(log)
    dependencies = [
        'scripts/skills/backgrounds/companion_1h_background.cnut',
        'scripts/items/weapons/arming_sword.cnut',
        'scripts/items/shields/wooden_shield.cnut',
        'scripts/items/armor/linen_tunic.cnut',
        'scripts/items/armor/padded_surcoat.cnut',
        'scripts/items/armor/mail_shirt.cnut',
        'scripts/items/helmets/nasal_helmet.cnut',
        'scripts/items/helmets/full_helm.cnut',
        'scripts/items/supplies/ground_grains_item.cnut',
    ]
    with ZipFile(args.game / 'data/data_001.dat') as archive:
        missing = sorted(set(dependencies) - set(archive.namelist()))
    if missing:
        raise ValueError(f'Missing native scenario dependencies: {missing}')
    report = {
        'method': 'Squirrel loadfile compilation and native dependency path checks',
        'scripts': [{'file': p.relative_to(BASE).as_posix(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in files],
        'syntax_passed': True, 'log': log, 'native_paths_verified': dependencies,
        'in_game_tested': False,
    }
    (BASE / 'build').mkdir(exist_ok=True)
    (BASE / 'build/script-validation.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(log + 'Preview-origin dependencies exist in the installed game.')


if __name__ == '__main__':
    main()
