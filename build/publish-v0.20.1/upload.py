"""Stage, validate, then publish through the website's existing release service."""
import json
import shlex
import subprocess
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
stage = Path(__file__).resolve().parent
name = 'afeix-v0.20.1-51011ac5'
remote = '/home/ubuntu/bbmod-hub/imports/' + name
container_stage = '/tmp/' + name
container = 'bbmod-hub-app-1'
options = ['-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8']

def ssh(*args):
    result = subprocess.run(['ssh', *options, 'my-server', shlex.join(args)], capture_output=True)
    output = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode:
        raise RuntimeError(output)
    return output

publish = '--publish' in sys.argv
if not publish:
    ssh('mkdir', '-p', remote)
    subprocess.run(['scp', *options, *[str(stage / f) for f in
                   ('website-release.json', 'publish_bbmod_release.py', 'mod_afeix_expedition.zip')],
                   'my-server:' + remote + '/'], check=True)
    ssh('docker', 'exec', container, 'mkdir', '-p', container_stage)
    ssh('docker', 'cp', remote + '/.', container + ':' + container_stage)
args = ['docker', 'exec', '-e', 'AFEIX_STAGE=' + container_stage]
if publish:
    args += ['-e', 'AFEIX_PUBLISH=1']
args += [container, 'sh', '-c', 'python manage.py shell < ' + shlex.quote(container_stage + '/publish_bbmod_release.py')]
output = ssh(*args)
(stage / ('website-publish.log' if publish else 'website-validation.log')).write_text(output, encoding='utf-8')
records = [json.loads(line) for line in output.splitlines() if line.startswith('{')]
assert any(r.get('published') or r.get('already_published') for r in records) if publish else any(r.get('validated') or r.get('already_published') for r in records)
if publish:
    (stage / 'website-published.json').write_text(json.dumps(records[-1], ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(output)
