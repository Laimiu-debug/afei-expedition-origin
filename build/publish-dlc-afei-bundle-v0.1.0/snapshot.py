from pathlib import Path
import json
import shlex
import subprocess

stage = Path(__file__).resolve().parent
code = '''import json
from catalog.models import Mod
from django.db.models import Q
mods=Mod.objects.filter(Q(install_name__icontains="afeix")|Q(title__icontains="阿飞")|Q(title__icontains="衣橱")).select_related("owner")
print(json.dumps({"mods":[{"id":str(m.pk),"install_name":m.install_name,"owner":m.owner.username,
 "blocked":m.blocked,"metadata":m.snapshot(),"releases":[{"id":str(r.pk),"version":r.version,
 "sha256":r.sha256,"status":r.status,"size":r.size} for r in m.releases.all()]} for m in mods]},ensure_ascii=False))
'''
result = subprocess.run(['ssh','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8',
    'my-server','docker exec -w /srv/web bbmod-hub-app-1 python manage.py shell -c '+shlex.quote(code)],
    capture_output=True, check=True, timeout=50)
snapshot = next(json.loads(row) for row in result.stdout.decode().splitlines() if row.startswith('{'))
(stage/'website-before.json').write_text(json.dumps(snapshot,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps([dict(id=m['id'],install_name=m['install_name'],title=m['metadata']['title'],owner=m['owner'],
    versions=[dict(version=r['version'],status=r['status']) for r in m['releases']]) for m in snapshot['mods']],ensure_ascii=False))
