"""Read-only real-atlas checks plus corrupted-copy regression cases."""
from copy import deepcopy
import json
from pathlib import Path
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from check_gameplay import verify_custom_atlas, verify_sprite

BASE = ROOT / 'art/runtime/gameplay-v03'
ATLAS = 'afeix_gameplay_v03'
report = json.loads((BASE / 'build/report.json').read_text(encoding='utf-8'))
expected = {'afeix_g03_' + form + '_body' + suffix for form in ('normal', 'jiahao') for suffix in ('', '_dead', '_injured')}
assert 'afeix_g03_feidie' not in {r['id'] for r in report['layers']}
passed = 0


def rejects(operation, text):
    global passed
    try:
        operation()
    except ValueError as error:
        assert text in str(error), str(error)
        passed += 1
    else:
        raise AssertionError('Corrupted art was accepted: ' + text)


actual = verify_custom_atlas(BASE, ATLAS, report, expected)
assert set(actual['sprites']) == expected
passed += 1
disc = next(record for record in report['layers'] if record['id'] == 'afeix_g03_normal_body')
verify_sprite(actual['sprites']['afeix_g03_normal_body'], ROOT / disc['source'], disc['metadata'])
passed += 1

broken = deepcopy(report)
del broken['roundtrip']['atlas_sha256']
rejects(lambda: verify_custom_atlas(BASE, ATLAS, broken, expected), 'missing atlas fingerprint')

broken = deepcopy(report)
broken['roundtrip']['brush_sha256'] = '0' * 64
rejects(lambda: verify_custom_atlas(BASE, ATLAS, broken, expected), 'brush fingerprint differs')

broken = deepcopy(report)
broken['roundtrip']['sprites'] = [entry for entry in broken['roundtrip']['sprites'] if entry['id'] != 'afeix_g03_normal_body']
rejects(lambda: verify_custom_atlas(BASE, ATLAS, broken, expected), 'required brush contract')

# A report with plausible hashes and count cannot lie about the packed IDs.
broken = deepcopy(report)
for entry in broken['roundtrip']['sprites']:
    if entry['id'] == 'afeix_g03_normal_body':
        entry['id'] = 'afeix_g03_missing_body'
invented = (expected - {'afeix_g03_normal_body'}) | {'afeix_g03_missing_body'}
rejects(lambda: verify_custom_atlas(BASE, ATLAS, broken, invented), 'actual shipped brush IDs differ')

cache = ROOT / '.cache/afei-art/gameplay-check'
cache.mkdir(parents=True, exist_ok=True)
with tempfile.TemporaryDirectory(prefix='test-art-hash-', dir=cache) as temporary:
    fixture = Path(temporary)
    fixture_base = fixture / 'art'
    for relative in (f'brushes/{ATLAS}.brush', f'gfx/{ATLAS}.png'):
        for target in (fixture_base / 'package' / relative, fixture / 'src' / relative):
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(BASE / 'package' / relative, target)
    changed = fixture / 'src/gfx' / (ATLAS + '.png')
    changed.write_bytes(changed.read_bytes() + b'not-reviewed')
    rejects(lambda: verify_custom_atlas(fixture_base, ATLAS, report, expected, root=fixture), 'atlas fingerprint differs')

bad_anchor = dict(disc['metadata'])
bad_anchor['left'] = str(int(bad_anchor['left']) + 1)
rejects(lambda: verify_sprite(actual['sprites']['afeix_g03_normal_body'], ROOT / disc['source'], bad_anchor), 'anchor differs')

print('ALL_ART_RESOURCE_CHECKS_PASS')
print(f'TESTS_PASSED={passed}')
