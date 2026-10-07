"""Build website-release.json for v0.29.2 from the captured live record."""
from pathlib import Path
import hashlib, json, re, shutil
stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.29.2'
package_name = f'mod_afeix_expedition v{version}.zip'
shutil.copy2(root / 'dist' / package_name, stage / package_name)
sha = hashlib.sha256((stage / package_name).read_bytes()).hexdigest()
assert sha == '4a4fdf21852ce40c7ef26c5a4cb987cec91af2ba297edc5a079656840cf9e71f'
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
meta = before['metadata']
assert before['releases'][0]['version'] == '0.29.1'
mod = {k: (', '.join(v) if isinstance(v, list) else v) for k, v in meta.items()}
mod['summary'] = 'v0.29.2：酒馆剧情弹窗等动画放完再弹，友好酒馆城外有敌人也能谈剧情，F8 回到被打断的剧情。'
paragraphs = mod['description'].split('\n\n')
hits = [i for i, p in enumerate(paragraphs) if p.startswith('v0.29.1：')]
assert len(hits) == 1
paragraphs[hits[0]] = ('v0.29.2：进酒馆后的剧情相遇等对话框动画放完再弹，不再漏掉或叠出旧弹窗；友好城镇酒馆里城外有敌人也能看交谈、'
                       '做个人成长和根脉选择；剧情被打断后在酒馆按 F8 直接回到那段剧情；梦里删掉“三、二、一，放轻松”。'
                       '0.29.1 起游戏里的剧情、人物、事件、结局和出身背景已全部重写；剧情走向、数值和触发条件不变。')
mod['description'] = '\n\n'.join(paragraphs)
old = 'v0.29.1 是完整主包，内容同 0.29.0-preview.14，包含此前所有 preview 的修订。'
assert mod['compatibility_notes'].count(old) == 1
mod['compatibility_notes'] = mod['compatibility_notes'].replace(old, 'v0.29.2 是完整主包，包含此前所有版本的修订；装了 0.29.1 的直接替换，存档兼容。')
mod.update({'install_name': 'mod_afeix_expedition.zip', 'rights': True})
notes = (stage / 'github-notes.md').read_text(encoding='utf-8').split('\n', 2)[2].strip()
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': meta,
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package_name,
        'verification': {'prior_version': '0.29.1', 'source_root': 'src', 'entries': 332,
                         'internal_version': 80, 'behavior_assertions': 46736},
        'sha256': sha}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('spec ok')
