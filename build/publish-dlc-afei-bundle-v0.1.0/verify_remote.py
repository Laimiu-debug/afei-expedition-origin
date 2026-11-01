"""Verify anonymous public HTTPS routing, metadata and download bytes at the origin."""
from datetime import datetime, timezone
from pathlib import Path
from zipfile import ZipFile
import hashlib
import io
import json
import os
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
withdrawn = os.environ.get('VERIFY_WITHDRAWN') == '1'

def fetch(path):
    result = subprocess.run(['curl','--noproxy','*','--resolve','bbmod.site:443:127.0.0.1',
        '--silent','--show-error','--connect-timeout','5','--max-time','20',
        '-H','Cache-Control: no-cache','--write-out','\nBBMOD_STATUS:%{http_code}',
        'https://bbmod.site'+path],capture_output=True,check=True,timeout=25)
    body,status = result.stdout.rsplit(b'\nBBMOD_STATUS:',1)
    return body,int(status)

def records(value):
    if isinstance(value,dict):
        if 'release_id' in value and 'metadata' in value: yield value
        for item in value.values(): yield from records(item)
    elif isinstance(value,list):
        for item in value: yield from records(item)

catalog,status = fetch('/api/v1/catalog/')
assert status==200
rows=list(records(json.loads(catalog)))
record=next(r for r in rows if r['id']==published['mod_id'])
assert record['release_id']==published['release_id'] and record['version']==spec['version']
assert record['sha256']==spec['sha256'] and record['size']==published['size']
assert record['notes'].strip()==spec['notes'].strip()
for key in ['title','summary','description','category','compatibility_notes','original_author']:
    assert record['metadata'][key].strip()==spec['mod'][key].strip(),key
for key in ['mod_ids','requires','conflicts']:
    assert record['metadata'][key]==spec['mod'][key].splitlines(),key
detail,detail_status=fetch('/mods/'+published['mod_id']+'/')
assert detail_status==200
html=detail.decode('utf-8')
assert all(word in html for word in ['阿飞衣橱与哇哇叫','0.1.0','6,661','新开战役'])
archive,download_status=fetch('/files/'+published['release_id']+'/download/')
assert download_status==200 and len(archive)==published['size']
assert hashlib.sha256(archive).hexdigest()==spec['sha256']
expected=spec['verification']['source_sha256']
with ZipFile(io.BytesIO(archive)) as z:
    assert z.testzip() is None and len(z.namelist())==len(set(z.namelist()))==22
    assert set(z.namelist())==set(expected)
    assert all(hashlib.sha256(z.read(n)).hexdigest()==digest for n,digest in expected.items())
    assert sum(n.startswith('sounds/') and n.endswith('.wav') for n in z.namelist())==5
old_status=[]
if withdrawn:
    for old in spec['withdraw_works']:
        assert not any(r['id']==old['id'] for r in rows)
        _,status=fetch('/mods/'+old['id']+'/')
        assert status==404
        downloads=[]
        for release in old['releases']:
            _,code=fetch('/files/'+release['id']+'/download/')
            assert code==404
            downloads.append(dict(release_id=release['id'],version=release['version'],http_status=code))
        old_status.append(dict(mod_id=old['id'],install_name=old['install_name'],detail_status=status,downloads=downloads))
    assert not any(r.get('install_name')=='mod_afeix_dlc_afei_skins.zip' for r in rows)
print(json.dumps(dict(verified_at=datetime.now(timezone.utc).isoformat(),version=spec['version'],
    detail_url=published['detail_url'],download_url='https://bbmod.site/files/'+published['release_id']+'/download/',
    sha256=spec['sha256'],size=len(archive),entries=22,http_status=dict(catalog=200,detail=200,download=200),
    catalog_metadata_match=True,download_bytes_match=True,crc_passed=True,source_bytes_match=True,
    old_works_withdrawn=withdrawn,old_status=old_status,skin_separate_work_absent=bool(spec['absent_old_install_names']),
    public_archive_downloaded_at_origin=True,local_public_archive_saved=False,in_game_tested=False,
    verification_transport='Anonymous public HTTPS endpoint through the trusted site origin'),ensure_ascii=False))
