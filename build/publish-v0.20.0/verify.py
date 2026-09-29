"""Verify the public listing, detail page and anonymous downloadable bytes."""
import hashlib
import io
import json
import sys
import urllib.request
import zipfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
base = 'https://bbmod.site'
urls = {'catalog': base + '/api/v1/catalog/', 'detail': base + '/mods/' + published['mod_id'] + '/',
        'download': base + '/files/' + published['release_id'] + '/download/'}

def fetch(item):
    key, url = item
    with urllib.request.urlopen(url, timeout=30) as response:
        return key, (response.status, dict(response.headers), response.read())

with ThreadPoolExecutor(max_workers=3) as pool:
    responses = dict(pool.map(fetch, urls.items()))
assert all(response[0] == 200 for response in responses.values())
catalog = json.loads(responses['catalog'][2])
mod = next(m for m in catalog['mods'] if m['id'] == published['mod_id'])
assert mod['version'] == spec['version'] and mod['release_id'] == published['release_id']
assert mod['sha256'] == spec['sha256'] and mod['notes'] == spec['notes']
assert mod['metadata']['description'] == spec['mod']['description']
detail = responses['detail'][2].decode('utf-8')
assert spec['version'] in detail and mod['download_path'] in detail
download = responses['download'][2]
local = (stage / spec['mod']['install_name']).read_bytes()
assert download == local
assert hashlib.sha256(download).hexdigest() == spec['sha256']
with zipfile.ZipFile(io.BytesIO(download)) as archive:
    assert archive.testzip() is None
    assert 'scripts/mods/afeix/ideas_random.nut' in archive.namelist()
record = {'detail_url': urls['detail'], 'download_url': urls['download'], 'http_status': 200,
          'version': mod['version'], 'release_id': mod['release_id'], 'sha256': spec['sha256'],
          'size': len(download), 'bytes_match': True, 'crc_passed': True,
          'catalog_and_notes_match': True, 'content_disposition': responses['download'][1].get('Content-Disposition')}
(stage / 'website-catalog.json').write_text(json.dumps(mod, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(stage / 'website-verification.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(record, ensure_ascii=False, indent=2))
