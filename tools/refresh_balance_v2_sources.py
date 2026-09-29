"""Refresh current-source/DLC evidence without changing any V2 design inputs."""
from pathlib import Path
import hashlib
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs/design/balance-v2'
CACHE = ROOT / '.cache/refresh-v2'
sys.stdout.reconfigure(encoding='utf-8')


def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    source = (ROOT / 'tools/export_gameplay_roster.nut').read_text(encoding='utf-8')
    marker = 'function quoteJson(value) {'
    source = source.replace(marker, 'dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");\n' + marker, 1)
    source = source.replace('version=A.Version,schema=', 'memberGrowth=A.MemberGrowth,version=A.Version,schema=')
    exporter = CACHE / 'export-with-dlc.nut'
    exporter.write_text(source, encoding='utf-8')
    result = subprocess.run([str(ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe'), str(exporter)], cwd=ROOT, capture_output=True, encoding='utf-8', check=True)
    roster = json.loads(result.stdout.split('ROSTER_JSON_BEGIN\n')[1].split('\nROSTER_JSON_END')[0])
    assert len(roster['characters']) == 35
    assert len(roster['memberSkillDefs']) == 96
    assert len({c['key'] for c in roster['characters']}) == 35
    files = sorted((ROOT / 'src/scripts').rglob('*.nut')) + sorted((ROOT / 'dlc/xiwen-regen/src').rglob('*'))
    manifest = {'date': '2026-09-29', 'version': roster['version'], 'scope': 'current main source plus optional xiwen-regen DLC', 'files': [
        {'path': p.relative_to(ROOT).as_posix(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in files if p.is_file()
    ]}
    for name, data in [('current-roster.json', roster), ('source-manifest.json', manifest)]:
        (OUT / name).write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f"Refreshed {len(roster['characters'])} characters, {len(roster['memberSkillDefs'])} current skills; internal version {roster['version']}.")


if __name__ == '__main__':
    main()
