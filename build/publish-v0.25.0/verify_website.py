from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from email.parser import Parser
from zipfile import ZipFile
from datetime import datetime, timezone
import json, hashlib, io, subprocess, re

stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url'],
        'download': f'https://bbmod.site/files/{published["release_id"]}/download/',
        'previous_download': 'https://bbmod.site/files/d04a3fd4-2005-4061-b3f8-0b129f3298c2/download/'}

def fetch(item):
    name, url = item
    headers, body = stage / (name + '.headers'), stage / (name + '.response')
    subprocess.run(['curl', '--noproxy', '*', '--fail', '--silent', '--show-error', '--max-time', '25',
                    '--dump-header', str(headers), '--output', str(body), url], check=True)
    raw_headers = headers.read_text(encoding='iso-8859-1').strip().split('\n\n')[-1]
    status = int(re.match(r'HTTP/\S+ (\d+)', raw_headers).group(1))
    return name, {'status': status, 'headers': Parser().parsestr(raw_headers.split('\n', 1)[1]), 'body': body.read_bytes()}

with ThreadPoolExecutor(max_workers=4) as pool:
    results = dict(pool.map(fetch, urls.items()))
assert all(r['status'] == 200 for r in results.values())
local = (stage / spec['package_filename']).read_bytes()
assert results['download']['body'] == local
assert hashlib.sha256(local).hexdigest() == spec['sha256']
assert hashlib.sha256(results['previous_download']['body']).hexdigest() == '109dbe4d0df3c1de467d70e3853c768bea840b006631a0d6e2afaff3ccd89b8b'
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    for suffix in ('', '_front', '_profile', '_medallion', '_golden'):
        assert f'gfx/ui/banners/banner_afeix_toad{suffix}.png' in archive.namelist()
    entry_count = len(archive.namelist())
html = results['detail']['body'].decode('utf-8')
assert '0.25.0' in html and '黄金天使蛙' in html and '24,187' in html and '食尸鬼' in html
(stage / 'website-detail.html').write_text(html, encoding='utf-8')
catalog = json.loads(results['catalog']['body'])

def records(value):
    if isinstance(value, dict):
        if value.get('id') == published['mod_id'] and 'version' in value:
            yield value
        for nested in value.values():
            yield from records(nested)
    elif isinstance(value, list):
        for nested in value:
            yield from records(nested)

record = next(records(catalog))
assert record['release_id'] == published['release_id'] and record['version'] == '0.25.0'
assert record['sha256'] == spec['sha256'] and record['size'] == len(local)
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
verified = {'verified_at': datetime.now(timezone.utc).isoformat(), 'detail_url': urls['detail'],
            'download_url': urls['download'], 'release_id': published['release_id'], 'version': spec['version'],
            'sha256': spec['sha256'], 'size': len(local), 'entries': entry_count,
            'http_status': {k: v['status'] for k, v in results.items()}, 'catalog_and_notes_match': True,
            'download_bytes_match': True, 'crc_passed': True, 'five_banners_included': True,
            'download_content_disposition': results['download']['headers'].get('Content-Disposition'),
            'previous_version': '0.24.0', 'previous_sha256_unchanged': hashlib.sha256(results['previous_download']['body']).hexdigest(),
            'backup': published['backup'], 'in_game_tested': False}
(stage / 'website-verification.json').write_text(json.dumps(verified, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(verified, ensure_ascii=False, indent=2))
