from pathlib import Path
import json
import re
import shlex
import subprocess
import sys
import time

stage = Path(__file__).resolve().parent
remote=(stage/'remote-stage.txt').read_text().strip()
assert re.fullmatch(r'/tmp/afeix-bundle-010\.[A-Za-z0-9]+',remote)
opts=['-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8']

def ssh(command):
    for attempt in range(3):
        result=subprocess.run(['ssh',*opts,'my-server',command],capture_output=True,timeout=50)
        if result.returncode==0: return result.stdout.decode('utf-8')
        if b'Connection timed out' not in result.stderr: break
        time.sleep(1)
    raise RuntimeError(result.stderr.decode(errors='replace')+result.stdout.decode(errors='replace'))

def copy(names,container=False):
    for name in names:
        subprocess.run(['scp',*opts,str(stage/name),'my-server:'+remote+'/'],check=True,capture_output=True,timeout=50)
    if container: ssh('docker cp '+shlex.quote(remote+'/.')+' bbmod-hub-app-1:'+shlex.quote(remote))

if '--withdraw' in sys.argv:
    prior=json.loads((stage/'website-verification.json').read_text(encoding='utf-8'))
    assert prior['download_bytes_match'] and prior['crc_passed']
    copy(['withdraw_remote.py','website-published.json','website-verification.json'],container=True)
    code='exec(open('+repr(remote+'/withdraw_remote.py')+').read())'
    base='docker exec -w /srv/web -e AFEIX_STAGE='+remote
    validation=ssh(base+' bbmod-hub-app-1 python manage.py shell -c '+shlex.quote(code))
    assert any(json.loads(line).get('validated') for line in validation.splitlines() if line.startswith('{'))
    output=ssh(base+' -e AFEIX_WITHDRAW=1 bbmod-hub-app-1 python manage.py shell -c '+shlex.quote(code))
    record=next(json.loads(line) for line in output.splitlines() if line.startswith('{') and json.loads(line).get('withdrawn'))
    (stage/'website-withdrawn.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(record,ensure_ascii=False),flush=True)
copy(['verify_remote.py','website-published.json'])
command=('VERIFY_WITHDRAWN=1 ' if '--withdraw' in sys.argv else '')+'python3 '+shlex.quote(remote+'/verify_remote.py')
verification=json.loads(ssh(command))
(stage/'website-verification.json').write_text(json.dumps(verification,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(verification,ensure_ascii=False),flush=True)
