"""Prepare awakening text update; do not fetch public archives."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import re
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous=json.loads((root/'build/publish-v0.28.9/website-release.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip()=='0.28.10'
assert all(validation[k] for k in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts']+validation['ui_scripts']:
    assert sha(root/row['path'])==row['sha256'],row['path']
package=root/'dist/mod_afeix_expedition v0.28.10.zip'
source={p.relative_to(root/'src').as_posix():p for p in (root/'src').rglob('*') if p.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(set(archive.namelist()))==len(source)==287
    assert set(archive.namelist())==set(source)
    assert all(archive.read(name)==p.read_bytes() for name,p in source.items())
with ZipFile(root/'dist/mod_afeix_expedition v0.28.9.zip') as old:
    changed=sorted(n for n,p in source.items() if old.read(n)!=p.read_bytes())
    assert changed==['scripts/!mods_preload/mod_afeix_expedition.nut','scripts/mods/afeix/turtle_secret.nut']
    name='scripts/mods/afeix/turtle_secret.nut'
    prior=old.read(name).decode('utf-8')
    current=source[name].read_text(encoding='utf-8')
    assert prior.split('    return scenes[index]')[0]==current.split('    return scenes[index]')[0]
    # All battle detection, bonuses, persistence, pause and cooldown code stays
    # exactly the same after removing the one changed combat-log message.
    remove_log=lambda s:re.sub(r'    ::Tactical\.EventLog\.log\([^\n]+\);\r?\n','',s)
    assert remove_log(prior.split('// Actor flags')[1])==remove_log(current.split('// Actor flags')[1])
assert before['id']==previous['expected_mod_id']
assert not any(r['version']=='0.28.10' for r in before['releases'])
mod={k:before['metadata'].get(k,v) for k,v in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
assertions=sum(r['assertions'] for r in validation['tests'])
count=f'{assertions:,}'
mod['summary']='v0.28.10 玄武血脉首次和后续觉醒弹窗精简为剧情与五场未觉醒参战胜利的冷却说明，不再列出属性变化。保留传奇蓝光握把、夜间酒馆F8、飞李不可仅限酒馆连续加点、Esc退出和接战卡死修复。请新开战役。'
intro=('v0.28.10：玄武血脉首次、第二次和后续觉醒弹窗只显示相应剧情和冷却说明，删除属性变化介绍，'
       '战斗日志同步精简。保留说明：“此后她必须完成5场未觉醒的参战胜利，才能再次激发血脉。待命和撤退不计。”'
       '首次与第二次仍使用各自剧情，第三次起仍轮换后续剧情。实际觉醒强化、五场胜利冷却和弹窗暂停／恢复机制沿用此前规则。')
description=before['metadata']['description']
assert description.startswith('v0.28.9：')
mod['description']=intro+'\n\n'+description.replace('v0.28.9：','保留v0.28.9更新：',1)
notes=('玄武血脉首次、第二次及后续觉醒弹窗删除属性变化介绍，保留对应剧情和“此后她必须完成5场未觉醒的参战胜利，才能再次激发血脉。待命和撤退不计。”'
       '战斗日志同步精简；觉醒实际效果、冷却计数与弹窗暂停机制保持原样。包含v0.28.9传奇蓝光握把及此前酒馆交互修复。'
       +count+'条离线断言、124份脚本和287个包文件核验通过，弹窗仍待实机复测。请新开战役。')
proof={'version':'0.28.10','prior_version':'0.28.9','changed_package_entries':changed,
       'first_and_repeat_popup_attributes_removed':True,'recovery_rule_retained':True,
       'first_second_and_rotating_scenes_unchanged':True,'combat_log_attributes_removed':True,
       'actual_awakening_bonuses_cooldown_and_pause_code_unchanged':True,
       'behavior_assertions':assertions,'in_game_tested':False}
(stage/'awakening-text-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
      'mod':mod,'version':'0.28.10','notes':notes,'package_filename':package.name,'sha256':sha(package),
      'verification':{'source_root':'src','prior_version':'0.28.9','internal_version':60,'entries':287,
                      'behavior_assertions':assertions,'public_download_byte_comparison':False}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher=(root/'build/publish-v0.28.9/publish.py').read_text(encoding='utf-8').replace('afeix-0289','afeix-02810').replace('0.28.9','0.28.10')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm=(root/'build/publish-v0.28.9/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.9','0.28.10')
confirm=confirm.replace("'传奇双手锤', '蓝色底光'", "'传奇双手锤', '蓝色底光', '玄武血脉', '5场未觉醒的参战胜利'")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print('Prepared v0.28.10: '+count+' assertions, only version entry and awakening text changed, no public ZIP download.')
