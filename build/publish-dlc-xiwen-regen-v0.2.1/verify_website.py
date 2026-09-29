"""Verify the public DLC download, dependency metadata and unchanged main work."""
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
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
prior = before['main']['releases'][0]
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url'],
        'download': f'https://bbmod.site/files/{published["release_id"]}/download/',
        'main_download': f'https://bbmod.site/files/{prior["id"]}/download/'}

def fetch(item):
    name, url = item
    headers, body = stage / (name + '.headers'), stage / (name + '.response')
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
assert hashlib.sha256(results['main_download']['body']).hexdigest() == prior['sha256']
disposition = results['download']['headers'].get('Content-Disposition')
assert 'filename="' + spec['mod']['install_name'] + '"' in disposition
assert spec['mod']['install_name'].endswith('.zip') and spec['package_filename'].endswith('.zip')
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == 8
    assert 'scripts/items/accessory/afeix_regen_item.nut' in archive.namelist()
    assert 'scripts/skills/backgrounds/afeix_xiwen_background.nut' in archive.namelist()
    assert 'scripts/!mods_preload/mod_afeix_expedition.nut' not in archive.namelist()
html = results['detail']['body'].decode('utf-8')
assert all(word in html for word in ('0.2.1', '希文', '里根', '饰品栏', '新开战役', '5,587'))
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
assert record['release_id'] == published['release_id'] and record['version'] == '0.2.1'
assert record['sha256'] == spec['sha256'] and record['size'] == len(local)
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
assert record['metadata']['mod_ids'] == ['mod_afeix_dlc_xiwen_regen']
assert record['metadata']['requires'] == ['mod_afeix_expedition', 'mod_hooks']
main = next(row for row in catalog if row['id'] == before['main']['id'])
assert main['release_id'] == prior['id'] and main['sha256'] == prior['sha256']
assert main['metadata'] == before['main']['metadata']
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
verified = {'verified_at': datetime.now(timezone.utc).isoformat(), 'detail_url': urls['detail'],
            'download_url': urls['download'], 'release_id': published['release_id'], 'version': '0.2.1',
            'sha256': spec['sha256'], 'size': len(local), 'entries': 8,
            'http_status': {key: value['status'] for key, value in results.items()},
            'catalog_and_notes_match': True, 'dependency_ids_match': True, 'main_work_unchanged': True,
            'download_bytes_match': True, 'crc_passed': True, 'lowercase_zip_filename': True,
            'download_content_disposition': disposition,
            'main_version': prior['version'], 'main_sha256_unchanged': prior['sha256'],
            'backup': published['backup'], 'in_game_tested': False}
(stage / 'website-verification.json').write_text(json.dumps(verified, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(verified, ensure_ascii=False, indent=2))
