"""Verify current and retained archives through their public HTTPS endpoints."""
from datetime import datetime, timezone
from pathlib import Path
import json
import re
import shlex
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
prior = next(r for r in before['releases'] if r['version'] == '0.28.13')
remote = (stage/'remote-stage.txt').read_text().strip()
assert re.fullmatch(r'/tmp/afeix-02814\.[A-Za-z0-9]+', remote)
download = 'https://bbmod.site/files/' + published['release_id'] + '/download/'
code = '''
import hashlib, io, json, subprocess, zipfile
from pathlib import Path
spec = json.loads(Path(SPEC_PATH).read_text(encoding='utf-8'))
def fetch(url, extra=()):
    response = subprocess.run(['curl', '--noproxy', '*', '--resolve', 'bbmod.site:443:127.0.0.1',
        '--connect-timeout', '5', '--max-time', '30', '--fail', '--silent', '--show-error',
        *extra, '--write-out', '\\nBBMOD_STATUS:%{http_code}', url],
        capture_output=True, check=True, timeout=40)
    data, status = response.stdout.rsplit(b'\\nBBMOD_STATUS:',1)
    return data, int(status)
archive, status = fetch(DOWNLOAD_URL)
assert status == 200 and len(archive) == ARCHIVE_SIZE
assert hashlib.sha256(archive).hexdigest() == spec['sha256']
with zipfile.ZipFile(io.BytesIO(archive)) as z:
    files = spec['verification']['source_sha256']
    assert z.testzip() is None
    assert len(z.namelist()) == len(set(z.namelist())) == len(files) == 288
    assert set(z.namelist()) == set(files)
    assert all(hashlib.sha256(z.read(n)).hexdigest() == digest for n,digest in files.items())
    assert 'brushes/afeix_helmet_layers_v01.brush' not in z.namelist()
    assert 'gfx/afeix_helmet_layers_v01.png' not in z.namelist()
    assert b'hasSplitHairArt' not in z.read('scripts/mods/afeix/appearance.nut')
    assert b'afeix_full_portrait_helmet_default' in z.read('scripts/mods/afeix/company_appearance_hooks.nut')
    assert b'Version = 64' in z.read('scripts/!mods_preload/mod_afeix_expedition.nut')
prior = PRIOR
old, old_status = fetch('https://bbmod.site/files/' + prior['id'] + '/download/')
assert old_status == 200 and len(old) == prior['size']
assert hashlib.sha256(old).hexdigest() == prior['sha256']
part, range_status = fetch(DOWNLOAD_URL, ('--range', '0-1023'))
assert range_status == 206 and part == archive[:1024]
print(json.dumps({'http_status':200, 'sha256':spec['sha256'], 'size':len(archive),
    'entries':len(files), 'crc_passed':True, 'entry_set_match':True, 'source_bytes_match':True,
    'full_portrait_rollback_confirmed':True, 'internal_version':64,
    'prior_release_unchanged':True, 'prior_release_id':prior['id'], 'prior_release_sha256':prior['sha256'],
    'range_http_status':range_status, 'range_bytes_match':True}))
'''.replace('SPEC_PATH',repr(remote+'/website-release.json')).replace('DOWNLOAD_URL',repr(download)).replace('ARCHIVE_SIZE',repr(published['size'])).replace('PRIOR',repr(prior))
result = subprocess.run(['ssh','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8',
                         'my-server','python3 -c '+shlex.quote(code)],capture_output=True,check=True,timeout=50)
report = json.loads(result.stdout)
report.update(version=spec['version'],release_id=published['release_id'],download_url=download,
              confirmed_at=datetime.now(timezone.utc).isoformat(),in_game_tested=False,
              public_archive_downloaded_at_origin=True,local_public_archive_saved=False,
              verification_transport='Public HTTPS download endpoint through trusted website origin')
(stage/'website-archive-verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(report,ensure_ascii=False))
