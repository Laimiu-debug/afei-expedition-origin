"""Confirm public HEAD/Range delivery and immutable historical release records."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import re
import subprocess

stage = Path(__file__).resolve().parent
spec = json.loads((stage / 'website-release.json').read_text(encoding='utf-8'))
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
after = json.loads((stage / 'website-after.json').read_text(encoding='utf-8'))
after_rows = {row['id']: row for row in after['releases']}
assert all(after_rows[row['id']] == row for row in before['releases'])
assert after['releases'][0]['id'] == published['release_id']
assert len(after_rows) == len(before['releases']) + 1
url = f'https://bbmod.com/files/{published["release_id"]}/download/'
common = ['curl', '--noproxy', '*', '--ipv4', '--fail', '--silent', '--show-error',
          '--connect-timeout', '8', '--max-time', '25', '--retry', '2', '--retry-delay', '1']
head = subprocess.run([*common, '--head', url], check=True, capture_output=True).stdout.decode('iso-8859-1')
assert re.findall(r'HTTP/\S+ (\d+)', head)[-1] == '200'
assert int(re.findall(r'(?im)^content-length:\s*(\d+)', head)[-1]) == published['size']
(stage / 'download-head.headers').write_text(head, encoding='utf-8')
headers, part = stage / 'download-range.headers', stage / 'download-range.response'
subprocess.run([*common, '--range', '0-1023', '--dump-header', str(headers), '--output', str(part), url], check=True)
text = headers.read_text(encoding='iso-8859-1')
assert re.findall(r'HTTP/\S+ (\d+)', text)[-1] == '206'
assert f'bytes 0-1023/{published["size"]}' in text
assert part.read_bytes() == (stage / spec['package_filename']).read_bytes()[:1024]
report = {'confirmed_at': datetime.now(timezone.utc).isoformat(), 'version': spec['version'],
          'download_url': url, 'head_http_status': 200, 'range_http_status': 206,
          'range_bytes_match': True, 'size': published['size'], 'prior_release_records_unchanged': True,
          'prior_release_record_count': len(before['releases']), 'verification_transport': 'Public HTTPS from local machine'}
(stage / 'website-delivery-verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(report))
