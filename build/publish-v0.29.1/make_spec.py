"""Build website-release.json for v0.29.1 from the captured live record."""
from pathlib import Path
import hashlib, json, shutil
stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.29.1'
package_name = f'mod_afeix_expedition v{version}.zip'
shutil.copy2(root / 'dist' / package_name, stage / package_name)
sha = hashlib.sha256((stage / package_name).read_bytes()).hexdigest()
assert sha == 'da7741c5a294a99becb26679c19448433de10779391f2de7db062907d0d27c31'
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
meta = before['metadata']
assert before['releases'][0]['version'] == '0.29.0-preview.14'
mod = {k: (', '.join(v) if isinstance(v, list) else v) for k, v in meta.items()}
mod['summary'] = 'v0.29.1：黑潮铺满全屏；剧情、人物、事件、结局和背景文字全部重写；罗一可、眼子与其他伙伴统一。'
assert mod['description'].count('v0.29.0-preview.14：') == 1
mod['description'] = mod['description'].replace('v0.29.0-preview.14：', 'v0.29.1：')
old = 'v0.29.0-preview.14 是完整主包，包含此前所有 preview 的修订。'
assert mod['compatibility_notes'].count(old) == 1
mod['compatibility_notes'] = mod['compatibility_notes'].replace(old, 'v0.29.1 是完整主包，内容同 0.29.0-preview.14，包含此前所有 preview 的修订。')
mod.update({'install_name': 'mod_afeix_expedition.zip', 'rights': True})
notes = (stage / 'github-notes.md').read_text(encoding='utf-8').split('\n', 2)[2].strip()
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': meta,
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package_name,
        'verification': {'prior_version': '0.29.0-preview.14', 'source_root': 'src', 'entries': 332,
                         'internal_version': 79, 'behavior_assertions': 46535},
        'sha256': sha}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('spec ok')
