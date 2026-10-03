"""Verify a prepared BBMOD release through its public catalog and downloads."""
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
root = Path(__file__).resolve().parents[1]
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
expected = spec['verification']
prior = next(r for r in before['releases'] if r['version'] == expected['prior_version'])
urls = {'catalog':'https://bbmod.com/api/v1/catalog/','detail':published['detail_url'],
        'download':f'https://bbmod.com/files/{published["release_id"]}/download/',
        'previous_download':f'https://bbmod.com/files/{prior["id"]}/download/'}

def fetch(item):
    name,url = item
    headers,body = stage/(name+'.headers'),stage/(name+'.response')
    subprocess.run(['curl','--noproxy','*','--ipv4','--fail','--silent','--show-error',
                    '--connect-timeout','8','--max-time','25','--retry','2','--retry-delay','1',
                    '--dump-header',str(headers),'--output',str(body),url],check=True)
    raw = headers.read_text(encoding='iso-8859-1').strip().split('\n\n')[-1]
    return name,{'status':int(re.match(r'HTTP/\S+ (\d+)',raw).group(1)),
                 'headers':Parser().parsestr(raw.split('\n',1)[1]),'body':body.read_bytes()}

with ThreadPoolExecutor(max_workers=4) as pool:
    results = dict(pool.map(fetch,urls.items()))
assert all(r['status']==200 for r in results.values())
local = (stage/spec['package_filename']).read_bytes()
assert local == results['download']['body']
assert hashlib.sha256(local).hexdigest() == spec['sha256']
assert hashlib.sha256(results['previous_download']['body']).hexdigest() == prior['sha256']
disposition = results['download']['headers'].get('Content-Disposition')
assert spec['mod']['install_name'] in disposition
is_main = spec['mod']['install_name']=='mod_afeix_expedition.zip'
mod_key = 'mod_afeix_expedition' if is_main else 'mod_afeix_dlc_xiwen_regen'
with ZipFile(io.BytesIO(local)) as archive:
    assert archive.testzip() is None
    entries = archive.namelist()
    source_root = root/expected['source_root']
    source = {p.relative_to(source_root).as_posix():p for p in source_root.rglob('*') if p.is_file()}
    assert len(entries) == len(set(entries)) == expected['entries']
    assert set(entries) == set(source)
    assert all(archive.read(name) == p.read_bytes() for name,p in source.items())
    preload = archive.read(f'scripts/!mods_preload/{mod_key}.nut').decode('utf-8-sig')
    internal = expected['internal_version']
    assert f'::mods_registerMod("{mod_key}", {internal},' in preload
    pattern = r'\bVersion\s*=\s*' if is_main else r'\bXiwenRegenDLC\s*<-\s*'
    assert re.search(pattern+str(internal)+r'\b',preload)
    if is_main:
        assert 'scripts/mods/afeix/attribute_treatment.nut' in entries
        assert 'brushes/afeix_corpse_injuries_v01.brush' in entries
    else:
        assert 'brushes/afeix_dlc_xiwen_corpse_injuries_v01.brush' in entries
        assert '环世界动物园' in archive.read('scripts/items/accessory/afeix_regen_item.nut').decode('utf-8-sig')
html = results['detail']['body'].decode('utf-8')
assert all(word in html for word in (spec['version'],f'{expected["behavior_assertions"]:,}','新开战役'))
(stage/'website-detail.html').write_text(html,encoding='utf-8')

def records(value):
    if isinstance(value,dict):
        if value.get('id') == published['mod_id'] and 'version' in value: yield value
        for nested in value.values(): yield from records(nested)
    elif isinstance(value,list):
        for nested in value: yield from records(nested)

record = next(records(json.loads(results['catalog']['body'])))
assert record['release_id']==published['release_id'] and record['version']==spec['version']
assert record['sha256']==spec['sha256'] and record['size']==len(local)
assert record['notes'].strip()==spec['notes'].strip()
for key in ('title','summary','description','compatibility_notes'):
    assert record['metadata'][key].strip()==spec['mod'][key].strip(),key
(stage/'website-catalog.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
verified = {'verified_at':datetime.now(timezone.utc).isoformat(),'detail_url':urls['detail'],
    'download_url':urls['download'],'release_id':published['release_id'],'version':spec['version'],
    'sha256':spec['sha256'],'size':len(local),'entries':len(entries),
    'http_status':{k:v['status'] for k,v in results.items()},'source_bytes_match':True,
    'catalog_and_notes_match':True,'download_bytes_match':True,'crc_passed':True,
    'internal_version':internal,'download_content_disposition':disposition,
    'previous_version':prior['version'],'previous_sha256_unchanged':prior['sha256'],
    'backup':published['backup'],'in_game_tested':False,
    'scope':'Public download and offline/package validation; new features and art have no campaign acceptance.'}
(stage/'website-verification.json').write_text(json.dumps(verified,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(verified,ensure_ascii=False,indent=2))
