"""Verify only backup integrity and public release boundaries, never private rows."""
from pathlib import Path
import json
import shlex
import subprocess

stage = Path(__file__).resolve().parent
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
prior = next(row for row in before['releases'] if row['version'] == '0.29.0-preview.3')
code = '''import hashlib,json,sqlite3,uuid
from pathlib import Path
p=Path(BACKUP)
assert p.is_file()
with sqlite3.connect('file:'+str(p)+'?mode=ro',uri=True) as db:
    assert db.execute('PRAGMA integrity_check').fetchone()[0]=='ok'
    assert db.execute('SELECT count(*) FROM catalog_release WHERE id=?',(uuid.UUID(PRIOR).hex,)).fetchone()[0]==1
    assert db.execute('SELECT count(*) FROM catalog_release WHERE id=?',(uuid.UUID(NEW).hex,)).fetchone()[0]==0
print(json.dumps({'backup':str(p),'size':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'integrity_check':'ok','contains_prior_release':True,'predates_new_release':True}))
'''.replace('BACKUP', repr(published['backup'])).replace('PRIOR', repr(prior['id'])).replace('NEW', repr(published['release_id']))
command = 'docker exec bbmod-candidate-app-1 python -c ' + shlex.quote(code)
result = subprocess.run(['ssh', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=8',
                         'cloudcone', command], capture_output=True, check=True, timeout=50)
report = json.loads(result.stdout)
(stage / 'backup-verification.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report))
