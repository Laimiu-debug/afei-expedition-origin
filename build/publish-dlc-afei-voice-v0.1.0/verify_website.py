"""Verify the public voice DLC and the two unchanged existing Afei downloads."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from email.parser import Parser
from pathlib import Path
from zipfile import ZipFile
import hashlib
import io
import json
import re
import subprocess

stage = Path(__file__).resolve().parent
root = stage.parents[1]
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
prior = {key: next(r for r in before[key]['releases'] if r['status'] == 'published') for key in ('main', 'xiwen')}
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url'],
    'download': f'https://bbmod.site/files/{published["release_id"]}/download/'}
for key, release in prior.items():
    urls[key + '_download'] = f'https://bbmod.site/files/{release["id"]}/download/'

def fetch(item):
    name, url = item
    headers, body = stage / (name + '.headers'), stage / (name + '.response')
    subprocess.run(['curl', '--noproxy', '*', '--ipv4', '--fail', '--silent', '--show-error',
        '--connect-timeout', '8', '--max-time', '25', '--retry', '2', '--retry-delay', '1',
        '--dump-header', str(headers), '--output', str(body), url], check=True)
    raw = headers.read_text(encoding='iso-8859-1').strip().split('\n\n')[-1]
    return name, {'status': int(re.match(r'HTTP/\S+ (\d+)', raw).group(1)),
        'headers': Parser().parsestr(raw.split('\n', 1)[1]), 'body': body.read_bytes()}

with ThreadPoolExecutor(max_workers=5) as pool:
    results = dict(pool.map(fetch, urls.items()))
assert all(row['status'] == 200 for row in results.values())
local = (stage / spec['package_filename']).read_bytes()
assert results['download']['body'] == local
assert hashlib.sha256(local).hexdigest() == spec['sha256']
disposition = results['download']['headers'].get('Content-Disposition', '')
assert spec['mod']['install_name'] in disposition
expected = spec['verification']
source_root = root / expected['source_root']
files = {p.relative_to(source_root).as_posix(): p for p in source_root.rglob('*') if p.is_file()}
original = json.loads((root / 'dlc/afei-voice/audio/archive/v0.1.0/source.json').read_text(encoding='utf-8'))
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == expected['entries'] == 8
    assert set(archive.namelist()) == set(files)
    for name, path in files.items():
        assert archive.read(name) == path.read_bytes(), name
    for row in original['clips']:
        assert hashlib.sha256(archive.read(row['path'])).hexdigest() == row['sha256']
    preload = archive.read('scripts/!mods_preload/mod_afeix_dlc_afei_voice.nut').decode('utf-8')
    assert '::mods_registerMod("mod_afeix_dlc_afei_voice", 1,' in preload
    assert 'mod_afeix_expedition(>=36)' in preload
    assert 'scripts/!mods_preload/mod_afeix_expedition.nut' not in archive.namelist()
html = results['detail']['body'].decode('utf-8')
assert all(word in html for word in ('0.1.0', '阿飞哇哇叫', '原声', '24', '尚未实机'))
(stage / 'website-detail.html').write_text(html, encoding='utf-8')

def records(value):
    if isinstance(value, dict):
        if 'release_id' in value and 'version' in value:
            yield value
        for nested in value.values():
            yield from records(nested)
    elif isinstance(value, list):
        for nested in value:
            yield from records(nested)

catalog = list(records(json.loads(results['catalog']['body'])))
record = next(row for row in catalog if row['id'] == published['mod_id'])
assert record['release_id'] == published['release_id'] and record['version'] == '0.1.0'
assert record['sha256'] == spec['sha256'] and record['size'] == len(local)
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes', 'license', 'source_url', 'original_author'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
assert record['metadata']['mod_ids'] == ['mod_afeix_dlc_afei_voice']
assert record['metadata']['requires'] == ['mod_afeix_expedition', 'mod_hooks']
for key, release in prior.items():
    existing = next(row for row in catalog if row['id'] == before[key]['id'])
    assert existing['release_id'] == release['id'] and existing['sha256'] == release['sha256']
    assert existing['metadata'] == before[key]['metadata']
    assert hashlib.sha256(results[key + '_download']['body']).hexdigest() == release['sha256']
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
verified = {'verified_at': datetime.now(timezone.utc).isoformat(), 'detail_url': urls['detail'],
    'download_url': urls['download'], 'mod_id': published['mod_id'], 'release_id': published['release_id'],
    'version': '0.1.0', 'sha256': spec['sha256'], 'size': len(local), 'entries': 8, 'voice_clips': 5,
    'http_status': {key: value['status'] for key, value in results.items()},
    'download_bytes_match': True, 'source_bytes_match': True, 'original_pitch_clip_hashes_match': True,
    'crc_passed': True, 'catalog_and_notes_match': True, 'dependency_ids_match': True,
    'main_work_unchanged': True, 'xiwen_work_unchanged': True,
    'main_version': prior['main']['version'], 'xiwen_version': prior['xiwen']['version'],
    'download_content_disposition': disposition, 'backup': published.get('backup'),
    'in_game_tested': False, 'installed': False}
(stage / 'website-verification.json').write_text(json.dumps(verified, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(verified, ensure_ascii=False, indent=2))
