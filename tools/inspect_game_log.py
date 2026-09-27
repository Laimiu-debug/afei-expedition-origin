"""Save concise evidence from a locally executed Battle Brothers session."""
from pathlib import Path
from html import unescape
import argparse
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--log', type=Path, default=Path('C:/Users/25647/OneDrive/Documents/Battle Brothers/log.html'))
parser.add_argument('--snapshot')
args = parser.parse_args()
raw = args.log.read_bytes()
html = raw.decode('utf-8', errors='replace')
plain = lambda text: re.sub(r'\s+', ' ', unescape(re.sub(r'<[^>]*>', ' ', text))).strip()
rows = re.split(r'<div class="row ', html)[1:]
errors = [plain(row) for row in rows if row.startswith(('error', 'critical'))]
messages = list(dict.fromkeys(unescape(x) for x in re.findall(r'<div class="tag">Script Error</div><div class="text">(.*?)</div>', html)))
markers = [plain(row) for row in rows if 'AFEIX_FACING_TEST' in row]
result = {'log': str(args.log), 'sha256': hashlib.sha256(raw).hexdigest(),
          'error_rows': len(errors), 'script_error_messages': messages, 'test_markers': markers}
if args.snapshot:
    output = ROOT / 'build/playtest-facing'
    output.mkdir(parents=True, exist_ok=True)
    (output / (args.snapshot + '.html')).write_bytes(raw)
    (output / (args.snapshot + '.json')).write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
if errors:
    print('FIRST ERROR:', errors[0][:1800])
