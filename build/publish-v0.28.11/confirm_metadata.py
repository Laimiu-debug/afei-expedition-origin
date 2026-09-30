"""Confirm public metadata and download link without fetching any ZIP."""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
import json
import re
import base64
import shlex
import subprocess
import sys

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

if '--via-server' in sys.argv:
    # Read the same public HTTPS endpoints through the already trusted server;
    # the local route can time out. No release archive is requested.
    code = 'import subprocess,json,base64,concurrent.futures\nurls='+repr(urls)+'''\n
def fetch(pair):
    name,url=pair
    response=subprocess.run(['curl','--noproxy','*','--resolve','bbmod.site:443:127.0.0.1',
        '--connect-timeout','5','--max-time','20','--fail','--silent','--show-error',
        '--dump-header','-','--write-out','\\nBBMOD_STATUS:%{http_code}',url],
        check=True,capture_output=True,timeout=25)
    payload,status=response.stdout.rsplit(b'\\nBBMOD_STATUS:',1)
    headers,sep,body=payload.partition(b'\\r\\n\\r\\n')
    assert sep
    return name,{'status':int(status),'headers':headers.decode('iso-8859-1'),
                 'body':base64.b64encode(body).decode('ascii')}
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
    print(json.dumps(dict(pool.map(fetch,urls.items()))))
'''
    response=subprocess.run(['ssh','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes',
                             '-o','ConnectTimeout=8','my-server','python3 -c '+shlex.quote(code)],
                            capture_output=True,check=True,timeout=50)
    remote=json.loads(response.stdout)
    results={}
    for name,row in remote.items():
        assert row['status']==200,name
        results[name]=base64.b64decode(row['body'])
        (stage/(name+'.response')).write_bytes(results[name])
        (stage/(name+'.headers')).write_text(row['headers'],encoding='utf-8')
else:
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
assert record['version'] == '0.28.11' and record['release_id'] == published['release_id']
assert record['notes'].strip() == spec['notes'].strip()
for key in ('title', 'summary', 'description', 'compatibility_notes'):
    assert record['metadata'][key].strip() == spec['mod'][key].strip(), key
html = results['detail'].decode('utf-8')
assert all(word in html for word in ('0.28.11', '33,484', 'Esc', '飞李不可', '仅限酒馆', '夜间', 'F8', '传奇双手锤', '蓝色底光', '玄武血脉', '5场未觉醒的参战胜利', '已记录种类', '旧记录未保存种类'))
download_path = '/files/' + published['release_id'] + '/download/'
assert download_path in html
report = {'confirmed_at': datetime.now(timezone.utc).isoformat(), 'version': '0.28.11',
          'detail_url': published['detail_url'], 'download_url': 'https://bbmod.site' + download_path,
          'release_id': published['release_id'], 'http_status': {'catalog': 200, 'detail': 200},
          'catalog_version_confirmed': True, 'description_and_notes_confirmed': True,
          'download_link_present': True, 'public_archive_downloaded': False,
          'public_download_byte_comparison': False, 'in_game_tested': False,
          'verification_transport': 'HTTPS served by website origin via trusted server' if '--via-server' in sys.argv else 'HTTPS from local machine',
          'scope': 'Version, metadata and download-link confirmation only, as requested by the user.'}
(stage / 'website-metadata-confirmation.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
(stage / 'website-catalog.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, ensure_ascii=False))
