"""Read the BBMOD release targets and dependency records before publication."""
from pathlib import Path
import json
import shlex
import subprocess

STAGE = Path(__file__).resolve().parent
CODE = '''import json
from django.contrib.auth.models import User
from catalog.models import Mod, CATEGORIES
def record(mod):
    if mod is None: return None
    return {'id': str(mod.pk), 'owner': mod.owner.username, 'metadata': mod.snapshot(),
        'releases': [{'id': str(r.pk), 'version': r.version, 'sha256': r.sha256,
            'status': r.status, 'size': r.size} for r in mod.releases.all()]}
owner = User.objects.get(username='laimiu', is_active=True)
result = {'owner': owner.username, 'categories': CATEGORIES,
    'target': record(Mod.objects.filter(install_name__iexact='mod_afeix_dlc_afei_voice.zip').first()),
    'main': record(Mod.objects.get(pk='d64a00f6-1d60-4d8d-8d9b-de055fc0b748')),
    'xiwen': record(Mod.objects.get(pk='247b829d-8aa8-4898-a6dd-8b933c9ff1e9'))}
print(json.dumps(result, ensure_ascii=False))
'''
command = 'docker exec -w /srv/web bbmod-hub-app-1 python manage.py shell -c ' + shlex.quote(CODE)
result = subprocess.run(['ssh', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
    '-o', 'ConnectTimeout=8', 'my-server', command], capture_output=True, timeout=50)
if result.returncode:
    raise RuntimeError(result.stderr.decode(errors='replace'))
snapshot = next(json.loads(line) for line in result.stdout.decode().splitlines() if line.startswith('{'))
(STAGE / 'website-before.json').write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Target:', snapshot['target']['id'] if snapshot['target'] else 'new independent DLC')
for key in ('main', 'xiwen'):
    published = next(r for r in snapshot[key]['releases'] if r['status'] == 'published')
    print(key, published['version'], published['sha256'])
