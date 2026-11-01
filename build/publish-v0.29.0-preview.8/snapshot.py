from pathlib import Path
import json, shlex, subprocess, sys
stage=Path(__file__).resolve().parent
code="""import json
from catalog.models import Mod
m=Mod.objects.get(pk='d64a00f6-1d60-4d8d-8d9b-de055fc0b748')
print(json.dumps({'id':str(m.pk),'owner':m.owner.username,'metadata':m.snapshot(),'releases':[{'id':str(r.pk),'version':r.version,'sha256':r.sha256,'status':r.status,'size':r.size} for r in m.releases.order_by('-created_at')]},ensure_ascii=True))
"""
r=subprocess.run(['ssh','-o','BatchMode=yes','-o','StrictHostKeyChecking=yes','-o','ConnectTimeout=8','cloudcone','docker exec -w /srv/web bbmod-candidate-app-1 python manage.py shell -c '+shlex.quote(code)],capture_output=True,timeout=50,check=True)
j=json.loads(next(s for s in r.stdout.decode().splitlines() if s.startswith('{')))
(stage/('website-after.json' if '--after' in sys.argv else 'website-before.json')).write_text(json.dumps(j,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Latest official version:',j['releases'][0]['version'],'Historical records:',len(j['releases']))
