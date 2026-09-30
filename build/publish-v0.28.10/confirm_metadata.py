"""Confirm public metadata and download link without fetching any ZIP."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
import json
import re
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
urls = {'catalog': 'https://bbmod.site/api/v1/catalog/', 'detail': published['detail_url']}

def fetch(item):
    name, url = item
    headers, body = stage / (name + '.headers'), stage / (name + '.response')
    subprocess.run(['curl', '--noproxy', '*', '--ipv4', '--fail', '--silent', '--show-error',
                    '--connect-timeout', '8', '--max-time', '25', '--retry', '2', '--retry-delay', '1',
                    '--dump-header', str(headers), '--output', str(body), url], check=True)
    statuses = re.findall(r'HTTP/\S+ (\d+)', headers.read_text(encoding='iso-8859-1'))
    assert statuses and statuses[-1] == '200', name
    return name, body.read_bytes()

with ThreadPoolExecutor(max_workers=2) as pool:
    results = dict(pool.map(fetch, urls.items()))

def records(value):
    if isinstance(value, dict):
        if value.get('id') == published['mod_id'] and 'version' in value:
            yield value
        for nested in value.values():
            yield from records(nested)
    elif isinstance(value, list):
        for nested in value:
            yield from records(nested)

record = next(records(json.loads(results['catalog'])))
assert record['version'] == '0.28.10' and record['release_id'] == published['release_id']
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
html = results['detail'].decode('utf-8')
assert all(word in html for word in ('0.28.10', '33,468', 'Esc', '飞李不可', '仅限酒馆', '夜间', 'F8', '传奇双手锤', '蓝色底光', '玄武血脉', '5场未觉醒的参战胜利'))
download_path = '/files/' + published['release_id'] + '/download/'
assert download_path in html
report = {'confirmed_at': datetime.now(timezone.utc).isoformat(), 'version': '0.28.10',
          'detail_url': published['detail_url'], 'download_url': 'https://bbmod.site' + download_path,
          'release_id': published['release_id'], 'http_status': {'catalog': 200, 'detail': 200},
          'catalog_version_confirmed': True, 'description_and_notes_confirmed': True,
          'download_link_present': True, 'public_archive_downloaded': False,
          'public_download_byte_comparison': False, 'in_game_tested': False,
          'scope': 'Version, metadata and download-link confirmation only, as requested by the user.'}
(stage / 'website-metadata-confirmation.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, ensure_ascii=False))
