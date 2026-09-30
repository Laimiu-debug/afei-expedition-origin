"""Verify the public HTTPS download at the origin without saving a local ZIP."""
from datetime import datetime, timezone
from pathlib import Path
import json
import re
import shlex
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
expected = {'url': 'https://bbmod.site/files/' + published['release_id'] + '/download/',
            'sha256': spec['sha256'], 'size': published['size'],
            'files': spec['verification']['source_sha256']}
remote = (stage / 'remote-stage.txt').read_text().strip()
assert re.fullmatch(r'/tmp/afeix-02812\.[A-Za-z0-9]+', remote)
code = '''
import hashlib, io, json, subprocess, zipfile
from pathlib import Path
spec = json.loads(Path(SPEC_PATH).read_text(encoding='utf-8'))
expected = {'url': DOWNLOAD_URL, 'sha256': spec['sha256'],
            'size': ARCHIVE_SIZE, 'files': spec['verification']['source_sha256']}
response = subprocess.run(['curl', '--noproxy', '*', '--resolve', 'bbmod.site:443:127.0.0.1',
    '--connect-timeout', '5', '--max-time', '30', '--fail', '--silent', '--show-error',
    '--write-out', '\\nBBMOD_STATUS:%{http_code}', expected['url']],
    capture_output=True, check=True, timeout=40)
archive, status = response.stdout.rsplit(b'\\nBBMOD_STATUS:', 1)
assert status == b'200'
assert len(archive) == expected['size']
assert hashlib.sha256(archive).hexdigest() == expected['sha256']
with zipfile.ZipFile(io.BytesIO(archive)) as z:
    assert z.testzip() is None
    assert len(z.namelist()) == len(set(z.namelist())) == len(expected['files'])
    assert set(z.namelist()) == set(expected['files'])
    assert all(hashlib.sha256(z.read(n)).hexdigest() == digest for n, digest in expected['files'].items())
    text = z.read('scripts/skills/traits/afeix_turtle_body.nut').decode('utf-8')
    assert '旧档头盔' not in text and '头部减伤暂不生效' not in text
print(json.dumps({'http_status': 200, 'sha256': expected['sha256'], 'size': len(archive),
    'entries': len(expected['files']), 'crc_passed': True, 'entry_set_match': True,
    'source_bytes_match': True, 'tooltip_old_save_text_removed': True}))
'''.replace('SPEC_PATH', repr(remote + '/website-release.json')).replace('DOWNLOAD_URL', repr(expected['url'])).replace('ARCHIVE_SIZE', repr(expected['size']))
result = subprocess.run(['ssh', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
                         '-o', 'ConnectTimeout=8', 'my-server', 'python3 -c ' + shlex.quote(code)],
                        capture_output=True, check=True, timeout=50)
report = json.loads(result.stdout)
report.update(version=spec['version'], release_id=published['release_id'], download_url=expected['url'],
              confirmed_at=datetime.now(timezone.utc).isoformat(), in_game_tested=False,
              public_archive_downloaded_at_origin=True, local_public_archive_saved=False,
              verification_transport='Public HTTPS download endpoint through trusted website origin')
(stage / 'website-archive-verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report, ensure_ascii=False))
