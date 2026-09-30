"""Prepare the reviewed v0.28.5 main package and current website metadata."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.28.4/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root / 'VERSION').read_text().strip() == '0.28.5'
assert all(validation[key] for key in ('syntax_passed', 'behavior_tests_passed', 'native_resource_paths_passed'))
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha(root / row['path']) == row['sha256'], row['path']
package = root / 'dist/mod_afeix_expedition v0.28.5.zip'
source = {p.relative_to(root / 'src').as_posix(): p for p in (root / 'src').rglob('*') if p.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 287
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == path.read_bytes() for name, path in source.items())
assert not any(row['version'] == '0.28.5' for row in before['releases'])
assert before['id'] == previous['expected_mod_id']
mod = {key: before['metadata'].get(key, value) for key, value in previous['mod'].items()}
for key in ('mod_ids', 'requires', 'conflicts'):
    if isinstance(mod[key], list):
        mod[key] = '\n'.join(mod[key])
mod['summary'] = 'v0.28.5 修复接战卡死，黑旗名册支持 Esc 直接退出，飞李不可选人后点击属性即可付款加点并连续操作。保留全员文案、终局平衡与受伤美术更新；34 人起源，请新开战役。'
intro = ('v0.28.5：修复接战后小龟觉醒弹窗检查引起的卡死。黑旗名册所有页面可按 Esc 直接关闭，返回大地图或城镇。'
         '飞李不可选好角色后，点击属性按钮立即支付 100 克朗并永久增加 1 点基础属性；加点后留在当前页，可以连续点击。'
         '页面显示余额、属性变化和付款结果，双攻与双防在后四项属性。请新开战役。')
description = before['metadata']['description']
assert description.startswith('v0.28.4 累计更新：')
description = description.replace('v0.28.4 累计更新：', '保留 v0.28.4 累计更新：', 1)
old_treatment = ('新增“飞李不可”：安全的世界地图按 F8 → 战团事务 → 飞李不可，选择在队角色与一项属性，'
                 '每支付 100 克朗永久增加 1 点基础属性。八项属性均可选择，可重复参加；普通成员与 DLC 同行者也可使用。')
new_treatment = ('“飞李不可”：到友好城镇附近或安全营地，在世界地图按 F8 → 战团事务 → 飞李不可。'
                 '选择角色后直接点击属性按钮付款加点，不再逐点进入确认页；每次 100 克朗增加 1 点基础属性，可同页连续操作。'
                 '八项属性均可选择，普通成员与 DLC 同行者也可使用。点击属性即付款，浏览角色和翻页不扣钱；按 Esc 退出。')
assert old_treatment in description
description = description.replace(old_treatment, new_treatment)
assert '32,881' in description
description = description.replace('32,881', '33,221')
mod['description'] = intro + '\n\n' + description
old_instructions = '“飞李不可”每次花费 100 克朗，仅永久增加所选基础属性 1 点。'
assert old_instructions in mod['compatibility_notes']
mod['compatibility_notes'] = mod['compatibility_notes'].replace(
    old_instructions, '“飞李不可”选人后点击属性按钮即付款，每次 100 克朗永久增加所选基础属性 1 点；加点后可在同页连续操作，页面显示余额与变化。黑旗名册各页按 Esc 直接退出。')
notes = ('修复接战后小龟觉醒弹窗检查引起的卡死；黑旗名册各页按 Esc 直接退出。飞李不可选人后点击属性按钮即支付100克朗、'
         '永久增加1点基础属性，留在当前页连续加点，显示余额、变化和付款结果；过期按钮不重复扣款。'
         '保留 v0.28.4 的全员文案、终局平衡和受伤美术。33,221 条离线断言、124 份脚本和287个包文件核验通过；'
         '实机接战及语音仍待复测，请新开战役。希文与里根儿、阿飞语音仍为独立可选 DLC。')
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': before['metadata'],
        'mod': mod, 'version': '0.28.5', 'notes': notes, 'package_filename': package.name, 'sha256': sha(package),
        'verification': {'source_root': 'src', 'prior_version': '0.28.4', 'internal_version': 55,
                         'entries': len(source), 'behavior_assertions': sum(row['assertions'] for row in validation['tests']),
                         'public_download_byte_comparison': False,
                         'policy': 'User requested metadata and download-link confirmation only; do not download the public archive for comparison.'}}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
publisher = (root / 'build/publish-v0.28.4/publish.py').read_text(encoding='utf-8').replace('afeix-0284', 'afeix-0285').replace('0.28.4', '0.28.5')
(stage / 'publish.py').write_text(publisher, encoding='utf-8')
print('Prepared v0.28.5: 287 files, local validation and package checks passed. Public-download comparison disabled.')
