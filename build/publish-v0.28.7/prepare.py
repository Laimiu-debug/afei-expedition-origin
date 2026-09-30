"""Prepare tavern-only treatment release; no public archive download."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root/'build/publish-v0.28.6/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip() == '0.28.7'
assert all(validation[key] for key in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
sha = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha(root/row['path']) == row['sha256'], row['path']
package = root/'dist/mod_afeix_expedition v0.28.7.zip'
source = {path.relative_to(root/'src').as_posix():path for path in (root/'src').rglob('*') if path.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 287
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == path.read_bytes() for name,path in source.items())
assert not any(row['version'] == '0.28.7' for row in before['releases'])
assert before['id'] == previous['expected_mod_id']
mod = {key:before['metadata'].get(key,value) for key,value in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list): mod[key] = '\n'.join(mod[key])
assertions = sum(row['assertions'] for row in validation['tests'])
count = f'{assertions:,}'
mod['summary'] = 'v0.28.7 飞李不可仅限酒馆，野外与扎营不可用；酒馆黑旗页新增直接入口，100克朗加1点，可同页连续操作。保留Esc退出、接战卡死修复及全员文案和终局平衡；34人起源，请新开战役。'
intro = ('v0.28.7：按现行规则将飞李不可限制为仅限酒馆内使用。野外、扎营、城镇主界面和其他建筑均不可加点，页面会明确提示进入酒馆；'
         '离开酒馆后旧按钮失效，不扣钱、不加属性。酒馆黑旗页面新增直接入口，也可在酒馆内按F8→战团事务→飞李不可。'
         '选择角色后点击属性按钮即支付100克朗并永久增加1点基础属性，仍可同页连续操作；结果和失败原因置顶。保留Esc直接退出和接战卡死修复。')
description = before['metadata']['description']
assert description.startswith('v0.28.6：')
description = description.split('\n\n',1)[1]
old = '“飞李不可”：在世界地图按 F8 → 战团事务 → 飞李不可，野外也可使用，无需扎营或进入酒馆。'
assert old in description
description = description.replace(old,'“飞李不可”：先进入城镇酒馆，在酒馆黑旗页面选择飞李不可；也可在酒馆内按 F8 → 战团事务 → 飞李不可。野外和扎营不可用。')
description = description.replace('33,321',count)
mod['description'] = intro + '\n\n' + description
compatibility = before['metadata']['compatibility_notes']
old_policy = '\n\n飞李不可可在世界地图上的野外直接使用，无需扎营或进入酒馆。'
assert old_policy in compatibility
compatibility = compatibility.split(old_policy,1)[0]
mod['compatibility_notes'] = compatibility + ('\n\n飞李不可只能在酒馆内使用。野外、扎营及城镇其他界面均不可付款；'
    '酒馆黑旗页面有直接入口，也可在酒馆内按F8→战团事务→飞李不可。每次付款重新检查实际酒馆界面，离开酒馆后的旧按钮不会扣钱或加点。'
    '接战、战斗和加载期间同样暂不可加点。请移走旧主包并新开战役验收。')
assert '野外也可使用' not in mod['description'] and '无需扎营或进入酒馆' not in mod['description']
notes = ('飞李不可改为仅限酒馆内使用：野外、扎营及城镇其他界面不可加点，明确提示进入酒馆；离开酒馆后的旧按钮失效，属性和克朗不变。'
         '酒馆黑旗页新增直接入口，熟人分页为每页3人，保持最多6个按钮。保留100克朗／1点基础属性、同页连续加点、结果置顶、Esc退出和接战卡死修复。'
         f'{count}条离线断言、124份脚本和287个包文件核验通过；酒馆交互实机验收仍待复测，请新开战役。')
spec = {'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
        'mod':mod,'version':'0.28.7','notes':notes,'package_filename':package.name,'sha256':sha(package),
        'verification':{'source_root':'src','prior_version':'0.28.6','internal_version':57,'entries':len(source),
                        'behavior_assertions':assertions,'public_download_byte_comparison':False,
                        'policy':'Confirm public version, metadata and download link only, as requested by the user.'}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher = (root/'build/publish-v0.28.6/publish.py').read_text(encoding='utf-8').replace('afeix-0286','afeix-0287').replace('0.28.6','0.28.7')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm = (root/'build/publish-v0.28.6/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.6','0.28.7').replace('33,321',count)
confirm = confirm.replace("'Esc', '飞李不可'", "'Esc', '飞李不可', '仅限酒馆'")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print(f'Prepared v0.28.7, {count} assertions and local archive checks passed; public ZIP download disabled.')
