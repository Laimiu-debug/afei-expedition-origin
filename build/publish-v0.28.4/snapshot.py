"""Read the two existing BBMOD records before preparing this release."""
import json
from pathlib import Path
import shlex
import subprocess

stage = Path(__file__).resolve().parent
root = stage.parents[1]
code = '''import json
from catalog.models import Mod
ids = ['d64a00f6-1d60-4d8d-8d9b-de055fc0b748', '247b829d-8aa8-4898-a6dd-8b933c9ff1e9']
rows = []
for key in ids:
    mod = Mod.objects.get(pk=key)
    rows.append({'id':str(mod.pk), 'owner':mod.owner.username, 'metadata':mod.snapshot(),
                 'releases':[{'id':str(r.pk), 'version':r.version, 'sha256':r.sha256,
                              'status':r.status, 'size':r.size} for r in mod.releases.all()]})
print(json.dumps({'records':rows}, ensure_ascii=False))
'''
command = 'docker exec -w /srv/web bbmod-hub-app-1 python manage.py shell -c ' + shlex.quote(code)
result = subprocess.run(['ssh', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
                         '-o', 'ConnectTimeout=8', 'my-server', command], capture_output=True, timeout=50)
assert result.returncode == 0, result.stderr.decode(errors='replace')
rows = next(json.loads(line)['records'] for line in result.stdout.decode().splitlines() if line.startswith('{'))
dlc_stage = root / 'build/publish-dlc-xiwen-regen-v0.2.5'
dlc_stage.mkdir(parents=True, exist_ok=True)
for destination, row in zip([stage, dlc_stage], rows):
    (destination / 'website-before.json').write_text(json.dumps(row, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(row['id'], row['owner'], [(r['version'], r['size']) for r in row['releases'][:3]])
