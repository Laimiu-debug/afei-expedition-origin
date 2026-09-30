"""Prepare the field-treatment fix for BBMOD; no public ZIP comparisons."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.28.5/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root / 'VERSION').read_text().strip() == '0.28.6'
assert all(validation[k] for k in ('syntax_passed', 'behavior_tests_passed', 'native_resource_paths_passed'))
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha(root / row['path']) == row['sha256'], row['path']
package = root / 'dist/mod_afeix_expedition v0.28.6.zip'
source = {p.relative_to(root / 'src').as_posix(): p for p in (root / 'src').rglob('*') if p.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 287
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == path.read_bytes() for name, path in source.items())
assert not any(r['version'] == '0.28.6' for r in before['releases'])
assert before['id'] == previous['expected_mod_id']
mod = {key: before['metadata'].get(key, value) for key, value in previous['mod'].items()}
for key in ('mod_ids', 'requires', 'conflicts'):
    if isinstance(mod[key], list):
        mod[key] = '\n'.join(mod[key])
mod['summary'] = 'v0.28.6 飞李不可支持世界地图野外直接加点，无需扎营或进酒馆，付款结果与失败原因置顶。保留接战卡死修复、Esc退出、全员文案和终局平衡；34人起源，请新开战役。'
intro = ('v0.28.6：修复飞李不可在野外点击属性仍被地点门槛拒绝的问题。现在世界地图上的野外也可直接加点，无需扎营或进入酒馆。'
         '每次点击属性按钮即支付100克朗并永久增加1点基础属性，可在同页连续操作，付款结果和失败原因显示在属性列表上方。'
         '接战、战斗、加载期间暂不可加点；招募、研习和编队继续按各自地点规则办理。保留v0.28.5的Esc直接退出和接战卡死修复。')
description = before['metadata']['description']
assert description.startswith('v0.28.5：')
description = description.replace('v0.28.5：', '保留v0.28.5更新：', 1)
old = '“飞李不可”：到友好城镇附近或安全营地，在世界地图按 F8 → 战团事务 → 飞李不可。'
assert old in description
description = description.replace(old, '“飞李不可”：在世界地图按 F8 → 战团事务 → 飞李不可，野外也可使用，无需扎营或进入酒馆。')
description = description.replace('33,221', '33,321')
mod['description'] = intro + '\n\n' + description
mod['compatibility_notes'] = mod['compatibility_notes'].replace('在安全的世界地图按 F8', '在世界地图按 F8')
mod['compatibility_notes'] += ('\n\n飞李不可可在世界地图上的野外直接使用，无需扎营或进入酒馆。接战、战斗和加载期间暂不可付款；'
                               '余额不足、角色不在队或属性上限等实际原因显示在属性列表上方。招募、研习及编队仍使用各自地点规则。')
notes = ('修复飞李不可野外点击属性被城镇／扎营门槛拒绝的问题：世界地图上可直接付款加点，无需扎营或进酒馆。'
         '100克朗／1点基础属性，保留同页连续加点；付款结果和真实失败原因置顶。接战、战斗和加载期间不扣款。'
         '保留v0.28.5的Esc退出与接战卡死修复。33,321条离线断言、124份脚本和287个包文件核验通过；野外交互实机验收仍待复测，请新开战役。')
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': before['metadata'],
        'mod': mod, 'version': '0.28.6', 'notes': notes, 'package_filename': package.name, 'sha256': sha(package),
        'verification': {'source_root': 'src', 'prior_version': '0.28.5', 'internal_version': 56, 'entries': len(source),
                         'behavior_assertions': sum(row['assertions'] for row in validation['tests']),
                         'public_download_byte_comparison': False,
                         'policy': 'Confirm public version, metadata and download link only, as requested by the user.'}}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
publisher = (root / 'build/publish-v0.28.5/publish.py').read_text(encoding='utf-8').replace('afeix-0285', 'afeix-0286').replace('0.28.5', '0.28.6')
(stage / 'publish.py').write_text(publisher, encoding='utf-8')
confirm = (root / 'build/publish-v0.28.5/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.5', '0.28.6').replace('33,221', '33,321')
(stage / 'confirm_metadata.py').write_text(confirm, encoding='utf-8')
print('Prepared v0.28.6: local package checks passed; public archive download disabled.')
