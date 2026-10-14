"""Verify byte-range downloads, all historical releases, and the prepublish backup."""
from pathlib import Path
from email.parser import Parser
import json
import re
import shlex
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage/'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
url = f'https://bbmod.com/files/{published["release_id"]}/download/'
common = ['curl', '--noproxy', '*', '--ipv4', '--fail', '--silent', '--show-error',
          '--connect-timeout', '8', '--max-time', '25']
results = {}
for name, options in [('head', ['--head']), ('range', ['--header', 'Range: bytes=0-1023'])]:
    headers = stage/(name+'.headers')
    body = stage/(name+'.response')
    subprocess.run(common+options+['--dump-header', str(headers), '--output', str(body), url], check=True)
    raw = headers.read_text(encoding='iso-8859-1').strip().split('\n\n')[-1]
    results[name] = {'status': int(re.match(r'HTTP/\S+ (\d+)', raw).group(1)),
                     'headers': Parser().parsestr(raw.split('\n', 1)[1]), 'body': body.read_bytes()}
assert results['head']['status'] == 200
assert int(results['head']['headers']['Content-Length']) == published['size']
assert results['range']['status'] == 206
assert results['range']['headers']['Content-Range'] == f'bytes 0-1023/{published["size"]}'
assert results['range']['body'] == (stage/spec['package_filename']).read_bytes()[:1024]

code = """
import json, sqlite3
from catalog.models import Mod, Release
m = Mod.objects.get(pk=MOD_ID)
rows = list(m.releases.values('id','version','sha256','size','status'))
with sqlite3.connect('file:'+BACKUP+'?mode=ro', uri=True) as db:
    integrity = db.execute('PRAGMA integrity_check').fetchone()[0]
    prior_count = db.execute('SELECT count(*) FROM '+Release._meta.db_table+' WHERE mod_id=?', (m.pk.hex,)).fetchone()[0]
    new_count = db.execute('SELECT count(*) FROM '+Release._meta.db_table+' WHERE mod_id=? AND version=?', (m.pk.hex, VERSION)).fetchone()[0]
print(json.dumps({'releases':rows,'backup_integrity':integrity,'backup_prior_count':prior_count,'backup_has_new_version':new_count},default=str))
""".replace('MOD_ID', repr(before['id'])).replace('BACKUP', repr(published['backup'])).replace('VERSION', repr(spec['version']))
command = 'docker exec -w /srv/web bbmod-candidate-app-1 python manage.py shell -c '+shlex.quote(code)
remote = subprocess.run(['C:/Windows/System32/OpenSSH/ssh.exe', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
                         '-o', 'ConnectTimeout=10', 'cloudcone-laptop', command], capture_output=True, timeout=40, check=True)
after = next(json.loads(line) for line in remote.stdout.decode().splitlines() if line.startswith('{'))
rows = {r['id']: r for r in after['releases']}
assert len(rows) == len(before['releases'])+1
assert all(rows[r['id']] == r for r in before['releases'])
assert rows[published['release_id']]['sha256'] == spec['sha256']
assert after['backup_integrity'] == 'ok'
assert after['backup_prior_count'] == len(before['releases'])
assert after['backup_has_new_version'] == 0
proof = {'head_status': 200, 'range_status': 206, 'range_bytes_match': True,
         'history_records_unchanged': len(before['releases']), 'backup_integrity': 'ok',
         'backup_contains_prior_not_new': True, 'backup': published['backup']}
(stage/'release-proof.json').write_text(json.dumps(proof, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
print(json.dumps(proof, ensure_ascii=False, indent=2))
