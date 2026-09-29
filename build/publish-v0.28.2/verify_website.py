"""Verify this release's public metadata, download bytes and prior immutable archive."""
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
import sys

stage = Path(sys.argv[1]).resolve()
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
is_main = spec['mod']['install_name'] == 'mod_afeix_expedition.zip'
prior_version, internal_version, expected_entries = ('0.27.6', 52, 284) if is_main else ('0.2.3', 5, 8)
prior = next(r for r in before['releases'] if r['version'] == prior_version)
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url'],
        'download': f'https://bbmod.site/files/{published["release_id"]}/download/',
        'previous_download': f'https://bbmod.site/files/{prior["id"]}/download/'}

dlc_before = json.loads((stage / 'dlc-before.json').read_text(encoding='utf-8'))
dlc_release = next(r for r in dlc_before['releases'] if r['version'] == '0.2.4')
urls['dlc_download'] = f"https://bbmod.site/files/{dlc_release['id']}/download/"

def fetch(item):
    name, url = item
    headers, body = stage / (name + '.headers'), stage / (name + '.response')
    if '--reuse-responses' not in sys.argv:
        subprocess.run(['curl', '--noproxy', '*', '--ipv4', '--fail', '--silent', '--show-error',
                        '--connect-timeout', '8', '--max-time', '25', '--retry', '2', '--retry-delay', '1',
                        '--dump-header', str(headers), '--output', str(body), url], check=True)
    raw_headers = headers.read_text(encoding='iso-8859-1').strip().split('\n\n')[-1]
    status = int(re.match(r'HTTP/\S+ (\d+)', raw_headers).group(1))
    return name, {'status': status, 'headers': Parser().parsestr(raw_headers.split('\n', 1)[1]), 'body': body.read_bytes()}

with ThreadPoolExecutor(max_workers=4) as pool:
    results = dict(pool.map(fetch, urls.items()))
assert all(result['status'] == 200 for result in results.values())
assert hashlib.sha256(results['dlc_download']['body']).hexdigest() == dlc_release['sha256']
local = (stage / spec['package_filename']).read_bytes()
assert results['download']['body'] == local
assert hashlib.sha256(local).hexdigest() == spec['sha256']
assert hashlib.sha256(results['previous_download']['body']).hexdigest() == prior['sha256']
disposition = results['download']['headers'].get('Content-Disposition')
assert spec['mod']['install_name'] in disposition
mod_key = 'mod_afeix_expedition' if is_main else 'mod_afeix_dlc_xiwen_regen'
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    entry_count = len(archive.namelist())
    assert entry_count == expected_entries
    source_root = stage.parents[1] / 'src'
    source = {p.relative_to(source_root).as_posix(): p for p in source_root.rglob('*') if p.is_file()}
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == p.read_bytes() for name, p in source.items())
    preload = archive.read(f'scripts/!mods_preload/{mod_key}.nut').decode('utf-8-sig')
    if is_main:
        assert re.search(r'\bVersion\s*=\s*' + str(internal_version) + r'\b', preload)
    else:
        assert re.search(r'\bXiwenRegenDLC\s*<-\s*' + str(internal_version) + r'\b', preload)
    assert f'::mods_registerMod("{mod_key}", {internal_version},' in preload
    if is_main:
        for suffix in ('', '_front', '_profile', '_medallion', '_golden'):
            assert f'gfx/ui/banners/banner_afeix_toad{suffix}.png' in archive.namelist()
    else:
        pet = archive.read('scripts/items/accessory/afeix_regen_item.nut').decode('utf-8-sig')
        assert '环世界动物园' in pet and '老动物园' not in pet
html = results['detail']['body'].decode('utf-8')
words = (spec['version'], '30,038', '重逢', '新开战役') if is_main else (spec['version'], '环世界动物园', '5,612')
assert all(word in html for word in words)
(stage / 'website-detail.html').write_text(html, encoding='utf-8')

def records(value):
    if isinstance(value, dict):
        if value.get('id') == published['mod_id'] and 'version' in value:
            yield value
        for nested in value.values():
            yield from records(nested)
    elif isinstance(value, list):
        for nested in value:
            yield from records(nested)

record = next(records(json.loads(results['catalog']['body'])))
assert record['release_id'] == published['release_id'] and record['version'] == spec['version']
assert record['sha256'] == spec['sha256'] and record['size'] == len(local)
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
verified = {'verified_at': datetime.now(timezone.utc).isoformat(), 'detail_url': urls['detail'],
            'download_url': urls['download'], 'release_id': published['release_id'], 'version': spec['version'],
            'sha256': spec['sha256'], 'size': len(local), 'entries': entry_count,
            'http_status': {key: value['status'] for key, value in results.items()},
            'source_bytes_match': True, 'dlc_version': '0.2.4', 'dlc_sha256_unchanged': dlc_release['sha256'],
            'catalog_and_notes_match': True, 'download_bytes_match': True, 'crc_passed': True,
            'internal_version': internal_version, 'download_content_disposition': disposition,
            'previous_version': prior['version'], 'previous_sha256_unchanged': prior['sha256'],
            'backup': published['backup'],
            'engine_test_evidence': 'build/net-startup-20260929/engine-test.json' if is_main else None,
            'in_game_tested_scope': 'v0.28.2 changes not tested in game; inherited net decapitation fix was tested in v0.27.6' if is_main else 'DLC pet lifecycle not tested in game'}
(stage / 'website-verification.json').write_text(json.dumps(verified, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(verified, ensure_ascii=False, indent=2))
