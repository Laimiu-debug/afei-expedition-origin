"""Build and validate the penetration fix on the delivered v0.28.0 baseline."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import hashlib
import json
import re
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / 'dist/mod_afeix_expedition v0.28.0.zip'
OUT = ROOT / 'dist/mod_afeix_expedition v0.28.1.zip'
STAGE = ROOT / '.cache/grip-penetration-v0281/package-validation'
PATCHES = ['scripts/!mods_preload/mod_afeix_expedition.nut',
           'scripts/items/weapons/afeix_laoma_grip.nut']
SQ = ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def run_sq(path, marker):
    result = subprocess.run([str(SQ), str(path)], cwd=STAGE, capture_output=True)
    log = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode or marker not in log or re.search(r'AN ERROR HAS OCCUR+ED|FAIL ', log):
        raise RuntimeError(log)
    return log


baseline_report = json.loads((ROOT / 'build/recruitment-v0280-validation.json').read_text(encoding='utf-8'))
assert digest(BASE.read_bytes()) == baseline_report['package_sha256']
assert (ROOT / 'VERSION').read_text().strip() == '0.28.1'
preload = (ROOT / 'src' / PATCHES[0]).read_text(encoding='utf-8')
assert 'Version = 51, Schema = 8' in preload
assert 'mods_registerMod("mod_afeix_expedition", 51,' in preload

with ZipFile(BASE) as source, ZipFile(OUT, 'w', compression=ZIP_DEFLATED) as target:
    assert source.testzip() is None
    for entry in source.infolist():
        payload = (ROOT / 'src' / entry.filename).read_bytes() if entry.filename in PATCHES else source.read(entry)
        target.writestr(entry, payload)

with ZipFile(BASE) as before, ZipFile(OUT) as after:
    assert after.testzip() is None
    assert before.namelist() == after.namelist()
    changed = [name for name in after.namelist() if before.read(name) != after.read(name)]
    assert sorted(changed) == sorted(PATCHES), changed
    for name in after.namelist():
        destination = (STAGE / 'src' / name).resolve()
        assert destination.is_relative_to((STAGE / 'src').resolve())
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(after.read(name))
    names = after.namelist()
    unrelated_workspace_changes = [name for name in names if name not in PATCHES
                                   and (ROOT / 'src' / name).read_bytes() != after.read(name)]

fixture = '.cache/afei-art/native-contract-fixture'
shutil.copytree(ROOT / fixture, STAGE / fixture, dirs_exist_ok=True)
tests = ['tests/gameplay/member_skill_fixture.nut',
         'tests/gameplay/test_native_grip_weapon.nut',
         'tests/gameplay/test_native_grip_shops.nut']
for name in tests:
    destination = STAGE / name
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(ROOT / name, destination)

scripts = sorted((STAGE / 'src').rglob('*.nut'))
syntax = STAGE / 'syntax.nut'
syntax.write_text('local failed=0;\n' + '\n'.join(
    'try { loadfile(' + json.dumps(p.as_posix()) + ', true); } catch(e) { print("FAIL: "+e+"\\n"); failed++; }'
    for p in scripts) + '\nif(failed==0) print("SYNTAX_PASSED\\n");\n', encoding='utf-8')
run_sq(syntax, 'SYNTAX_PASSED')
checks = []
for name in tests[1:]:
    log = run_sq(STAGE / name, 'TESTS_PASSED=')
    checks.append({'file': name, 'assertions': int(re.search(r'TESTS_PASSED=(\d+)', log)[1]), 'log': log})

workspace = json.loads((ROOT / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
sha256 = digest(OUT.read_bytes())
OUT.with_suffix('.sha256').write_text(sha256 + '  ' + OUT.name + '\n', encoding='utf-8')
report = {
    'version': '0.28.1', 'internal_version': 51, 'schema': 8,
    'package': OUT.relative_to(ROOT).as_posix(), 'package_sha256': sha256,
    'base_package': BASE.relative_to(ROOT).as_posix(), 'base_sha256': digest(BASE.read_bytes()),
    'package_entries': len(names), 'crc_passed': True,
    'changed_entries': changed, 'unchanged_entries': len(names) - len(changed),
    'latest_source_patch_bytes_match': all((ROOT / 'src' / name).read_bytes() == (STAGE / 'src' / name).read_bytes() for name in PATCHES),
    'unrelated_workspace_changes_excluded': unrelated_workspace_changes,
    'package_scripts_compiled': len(scripts), 'package_targeted_tests': checks,
    'package_targeted_assertions': sum(check['assertions'] for check in checks),
    'workspace_full_behavior_assertions': sum(test['assertions'] for test in workspace['tests']),
    'workspace_full_report': 'build/gameplay-validation.json',
    'smite_penetration': 0.7, 'smite_direct_tooltip_max': 98,
    'shatter_penetration': 0.6, 'shatter_direct_tooltip_max': 72,
    'native_attack_dispatch_checked': True, 'native_save_load_checked': True,
    'in_game_tested': False, 'published': False, 'installed': False,
}
(ROOT / 'build/grip-penetration-v0281-validation.json').write_text(
    json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'entries': len(names), 'changed': changed, 'scripts': len(scripts),
                  'assertions': report['package_targeted_assertions'], 'sha256': sha256}))
