"""Verify anonymous HTTPS downloads, current catalog, metadata and prior archive."""
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

stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
prior = next(r for r in before['releases'] if r['version'] == '0.25.0')
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url'],
        'download': f'https://bbmod.site/files/{published["release_id"]}/download/',
        'previous_download': f'https://bbmod.site/files/{prior["id"]}/download/'}

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
local = (stage / spec['package_filename']).read_bytes()
assert results['download']['body'] == local
assert hashlib.sha256(local).hexdigest() == spec['sha256']
assert hashlib.sha256(results['previous_download']['body']).hexdigest() == prior['sha256']
disposition = results['download']['headers'].get('Content-Disposition')
assert spec['mod']['install_name'] in disposition
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    entry_count = len(archive.namelist())
    assert entry_count == 283
    # Semantic release 0.27.4 uses the established internal integer version 43.
    preload = archive.read('scripts/!mods_preload/mod_afeix_expedition.nut').decode('utf-8-sig')
    assert re.search(r'\bVersion\s*=\s*43\b', preload)
    assert '::mods_registerMod("mod_afeix_expedition", 43,' in preload
    for suffix in ('', '_front', '_profile', '_medallion', '_golden'):
        assert f'gfx/ui/banners/banner_afeix_toad{suffix}.png' in archive.namelist()
html = results['detail']['body'].decode('utf-8')
assert all(word in html for word in ('0.27.4', '84', '235%', '28,203', '食尸鬼', '新开战役'))
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
            'catalog_and_notes_match': True, 'download_bytes_match': True, 'crc_passed': True,
            'five_banners_included': True, 'download_content_disposition': disposition,
            'previous_version': prior['version'], 'previous_sha256_unchanged': prior['sha256'],
            'backup': published['backup'], 'in_game_tested': False}
(stage / 'website-verification.json').write_text(json.dumps(verified, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(verified, ensure_ascii=False, indent=2))
