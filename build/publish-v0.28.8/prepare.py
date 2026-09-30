"""Prepare entered-town F8 fix; public ZIP comparisons stay disabled."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous=json.loads((root/'build/publish-v0.28.7/website-release.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip()=='0.28.8'
assert all(validation[key] for key in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts']+validation['ui_scripts']:
    assert sha(root/row['path'])==row['sha256'],row['path']
package=root/'dist/mod_afeix_expedition v0.28.8.zip'
source={path.relative_to(root/'src').as_posix():path for path in (root/'src').rglob('*') if path.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(set(archive.namelist()))==len(source)==287
    assert set(archive.namelist())==set(source)
    assert all(archive.read(name)==path.read_bytes() for name,path in source.items())
assert before['id']==previous['expected_mod_id']
assert not any(row['version']=='0.28.8' for row in before['releases'])
mod={key:before['metadata'].get(key,value) for key,value in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
count=f"{sum(row['assertions'] for row in validation['tests']):,}"
mod['summary']='v0.28.8 修复夜间酒馆F8打不开：已进入友好城镇可打开黑旗名册，城外敌情不再拦截开界面。飞李不可仍仅限酒馆，保留连续加点、Esc退出、接战卡死修复及全员文案和平衡；请新开战役。'
intro=('v0.28.8：修复夜间在酒馆按F8打不开黑旗名册的问题。已经进入友好城镇后，打开名册根据当前城镇界面判断，'
       '不再被城外敌情或世界地图距离条件误拦截。白天和夜间均可打开，Esc退出后返回原酒馆，重复F8不会叠加界面。'
       '人物栏、加载、接战、战斗及其他事件期间仍暂不可打开。飞李不可仍仅限酒馆内使用，100克朗加1点，可在同页连续操作。')
description=before['metadata']['description']
assert description.startswith('v0.28.7：')
description=description.replace('v0.28.7：','保留v0.28.7更新：',1).replace('33,422',count)
mod['description']=intro+'\n\n'+description
mod['compatibility_notes']+='\n\n已进入友好城镇后，酒馆里的F8名册白天和夜间均可打开；附近敌人不再拦截开界面。飞李不可仍只能在酒馆使用，其他事务继续按各自条件确认。请退出游戏后替换旧主包，只保留一个主包ZIP。'
notes=('修复夜间酒馆按F8打不开：使用已经进入的友好城镇界面判断是否可打开名册，解除城外敌情和地图距离对开界面的误拦截。'
       '保留人物栏、加载、接战、战斗、事件和城镇动画拦截，以及Esc返回酒馆与重复F8保护；拒绝打开时不改变名册页面或酒馆记录。'
       '飞李不可仍仅限酒馆，其他事务保留各自条件。'+count+'条离线断言、124份脚本和287个包文件核验通过，其中原版F8／Esc菜单回归188条；夜间酒馆仍待实机复测，请新开战役。')
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
      'mod':mod,'version':'0.28.8','notes':notes,'package_filename':package.name,'sha256':sha(package),
      'verification':{'source_root':'src','prior_version':'0.28.7','internal_version':58,'entries':287,
                      'behavior_assertions':sum(row['assertions'] for row in validation['tests']),
                      'native_ledger_ui_assertions':188,'old_town_gate_failure_reproduced':True,
                      'public_download_byte_comparison':False}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher=(root/'build/publish-v0.28.7/publish.py').read_text(encoding='utf-8').replace('afeix-0287','afeix-0288').replace('0.28.7','0.28.8')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm=(root/'build/publish-v0.28.7/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.7','0.28.8').replace('33,422',count)
confirm=confirm.replace("'Esc', '飞李不可', '仅限酒馆'", "'Esc', '飞李不可', '仅限酒馆', '夜间', 'F8'")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print('Prepared v0.28.8: '+count+' assertions, exact local source bytes, no public ZIP download.')
