from pathlib import Path
import json
import re
import shlex
import subprocess
import sys

stage=Path(__file__).resolve().parent
spec=json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
opts=['-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8']
def ssh(command):
    result=subprocess.run(['ssh',*opts,'my-server',command],capture_output=True,timeout=50)
    if result.returncode:
        raise RuntimeError(result.stderr.decode(errors='replace')+result.stdout.decode(errors='replace'))
    return result.stdout.decode()
remote=(stage/'remote-stage.txt').read_text().strip() if (stage/'remote-stage.txt').exists() else ssh('mktemp -d /tmp/afeix-0285.XXXXXX').strip()
assert re.fullmatch(r'/tmp/afeix-0285\.[A-Za-z0-9]+',remote)
(stage/'remote-stage.txt').write_text(remote+'\n')
for name in ['website-release.json','publish_bbmod_release.py',spec['package_filename']]:
    subprocess.run(['scp',*opts,str(stage/name),'my-server:'+remote+'/'],check=True,capture_output=True,timeout=50)
ssh('docker exec -u 0 bbmod-hub-app-1 mkdir -p '+shlex.quote(remote))
ssh('docker cp '+shlex.quote(remote+'/.')+' bbmod-hub-app-1:'+shlex.quote(remote))
ssh('docker exec -u 0 bbmod-hub-app-1 chmod 755 '+shlex.quote(remote))
base='docker exec -w /srv/web -e AFEIX_STAGE='+remote
code='exec(open('+repr(remote+'/publish_bbmod_release.py')+').read())'
validate=ssh(base+' bbmod-hub-app-1 python manage.py shell -c '+shlex.quote(code))
(stage/'validation.log').write_text(validate,encoding='utf-8')
rows=[json.loads(line) for line in validate.splitlines() if line.startswith('{')]
assert any(row.get('validated') for row in rows), validate
print('Validated release 0.28.5 with website forms and archive checks.',flush=True)
if '--publish' not in sys.argv:
    sys.exit(0)
published=ssh(base+' -e AFEIX_PUBLISH=1 bbmod-hub-app-1 python manage.py shell -c '+shlex.quote(code))
(stage/'publish.log').write_text(published,encoding='utf-8')
rows=[json.loads(line) for line in published.splitlines() if line.startswith('{')]
record=next(row for row in rows if row.get('published'))
(stage/'website-published.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(record,ensure_ascii=False))
