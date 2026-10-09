"""Remove only this release's verified temporary upload and download copies."""
from pathlib import Path
import json
import re
import shlex
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
website = json.loads((stage/'website-verification.json').read_text(encoding='utf-8'))
github = json.loads((stage/'github-verification.json').read_text(encoding='utf-8'))
assert website['download_bytes_match'] and github['source_bytes_match']
assert all(asset['public_bytes_match'] for asset in github['assets'])
remote = (stage/'remote-stage.txt').read_text().strip()
assert re.fullmatch(r'/tmp/afeix-0293\.[A-Za-z0-9]+', remote)
code = ('from pathlib import Path\nimport shutil\n'
        f'p=Path({remote!r})\n'
        "assert p.parent == Path('/tmp') and not p.is_symlink()\n"
        "assert p.resolve() == p and p.name.startswith('afeix-0293.')\n"
        "if p.exists(): shutil.rmtree(p)\n"
        "assert not p.exists()\nprint('temporary release upload removed')")
opts = ['-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=10']
for command in [
    'docker exec -u 0 bbmod-candidate-app-1 python -c '+shlex.quote(code),
    'python3 -c '+shlex.quote(code),
]:
    result = subprocess.run(['C:/Windows/System32/OpenSSH/ssh.exe',*opts,'cloudcone-laptop',command],
                            capture_output=True,timeout=40,check=True)
    assert 'temporary release upload removed' in result.stdout.decode()
removed=[]
for name in [spec['package_filename'],'mod_afeix_expedition.zip','github-download.zip',
             'download.response','previous_download.response']:
    path = stage/name
    assert path.resolve().parent == stage
    if path.exists():path.unlink();removed.append(name)
record = {'server_upload_removed':True,'container_upload_removed':True,
          'local_temporary_copies_removed':removed,'dist_release_preserved':True,
          'website_archives_and_database_backup_preserved':True}
(stage/'cleanup-verification.json').write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record,indent=2))
