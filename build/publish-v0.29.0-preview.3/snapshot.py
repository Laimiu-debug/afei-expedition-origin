from pathlib import Path
import json
import shlex
import subprocess

stage = Path(__file__).resolve().parent
code = '''import json
from catalog.models import Mod
mod=Mod.objects.get(pk="d64a00f6-1d60-4d8d-8d9b-de055fc0b748")
print(json.dumps({"id":str(mod.pk),"owner":mod.owner.username,"metadata":mod.snapshot(),"releases":[{"id":str(r.pk),"version":r.version,"sha256":r.sha256,"status":r.status,"size":r.size} for r in mod.releases.all()]},ensure_ascii=False))
'''
command = 'docker exec -w /srv/web bbmod-candidate-app-1 python manage.py shell -c ' + shlex.quote(code)
result = subprocess.run(['ssh','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','cloudcone',command],capture_output=True,check=True,timeout=50)
snapshot = next(json.loads(row) for row in result.stdout.decode().splitlines() if row.startswith('{'))
(stage/'website-before.json').write_text(json.dumps(snapshot,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'id':snapshot['id'],'owner':snapshot['owner'],'versions':[row['version'] for row in snapshot['releases']][:5]}))
