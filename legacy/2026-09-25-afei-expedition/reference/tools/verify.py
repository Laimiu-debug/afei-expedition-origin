"""Compile every packaged script with the game's Squirrel language version."""
from pathlib import Path
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SQ = ROOT.parents[1] / 'app/build/full-l10n/tools/bin/sq.exe'
OUT = ROOT / 'test-output'
OUT.mkdir(exist_ok=True)
files = sorted((ROOT / 'src').rglob('*.nut'))
runner = OUT / 'compile.nut'
runner.write_text('local failed=0;\n' + '\n'.join(
    'try {loadfile(' + json.dumps(str(p).replace('\\', '/'), ensure_ascii=False) +
    ',true);} catch(e) {print("FAIL '+p.name+': "+e+"\\n");failed++;}' for p in files
) + '\nif(failed==0)print("ALL_COMPILED\\n");else print("COMPILE_FAILURES="+failed+"\\n");', encoding='utf-8')
result = subprocess.run([str(SQ), str(runner)], cwd=ROOT, capture_output=True)
output = (result.stdout + result.stderr).decode('utf-8', errors='replace')
(OUT / 'compile.log').write_text(output, encoding='utf-8')
print(output)
print(f'{len(files)} scripts inspected')
sys.exit(0 if result.returncode == 0 and 'ALL_COMPILED' in output else 1)
