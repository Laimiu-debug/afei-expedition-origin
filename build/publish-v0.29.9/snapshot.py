"""Read-only: capture the live BBMOD record before publishing."""
from pathlib import Path
import json, shlex, subprocess
stage = Path(__file__).resolve().parent
opts = ['-o', 'StrictHostKeyChecking=yes', '-o', 'BatchMode=yes', '-o', 'ConnectTimeout=10']
code = ("import json\nfrom catalog.models import Mod\n"
        "m = Mod.objects.get(pk='d64a00f6-1d60-4d8d-8d9b-de055fc0b748')\n"
        "rows = [dict(r, id=str(r['id'])) for r in m.releases.values('id','version','sha256','size','status')]\n"
        "print(json.dumps({'id': str(m.pk), 'owner': m.owner.username, 'metadata': m.snapshot(), 'releases': rows}, ensure_ascii=False, default=str))\n")
cmd = 'docker exec -w /srv/web bbmod-candidate-app-1 python manage.py shell -c ' + shlex.quote(code)
out = subprocess.run(['C:/Windows/System32/OpenSSH/ssh.exe', *opts, 'cloudcone-laptop', cmd], capture_output=True, timeout=60)
assert out.returncode == 0, out.stderr.decode(errors='replace')
line = next(l for l in out.stdout.decode('utf-8').splitlines() if l.startswith('{'))
data = json.loads(line)
(stage / 'website-before.json').write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(len(data['releases']), [r['version'] for r in data['releases']][:3])
print(data['metadata']['summary'])
