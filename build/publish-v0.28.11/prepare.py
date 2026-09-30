"""Prepare contract type fix; public ZIP comparisons remain disabled."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil
import subprocess

stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous=json.loads((root/'build/publish-v0.28.10/website-release.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip()=='0.28.11'
assert all(validation[k] for k in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts']+validation['ui_scripts']:
    assert sha(root/row['path'])==row['sha256'],row['path']
package=root/'dist/mod_afeix_expedition v0.28.11.zip'
source={p.relative_to(root/'src').as_posix():p for p in (root/'src').rglob('*') if p.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(set(archive.namelist()))==len(source)==287
    assert set(archive.namelist())==set(source)
    assert all(archive.read(n)==p.read_bytes() for n,p in source.items())
with ZipFile(root/'dist/mod_afeix_expedition v0.28.10.zip') as old:
    changed=sorted(n for n,p in source.items() if old.read(n)!=p.read_bytes())
    assert changed==['scripts/!mods_preload/mod_afeix_expedition.nut','scripts/mods/afeix/contracts.nut',
                     'scripts/mods/afeix/hooks.nut','scripts/mods/afeix/quests.nut']
baseline=subprocess.run([str(root/'.cache/afei-art/bbros-modkit-v9/bin/sq.exe'),
                         'build/contract-kinds-20260930/test-before.nut'],cwd=root,capture_output=True)
assert b'FAIL native_manager_reference_records_type_before_contract_is_cleared' in baseline.stdout
(root/'build/contract-kinds-20260930/baseline.log').write_bytes(baseline.stdout+baseline.stderr)
assert before['id']==previous['expected_mod_id']
assert not any(r['version']=='0.28.11' for r in before['releases'])
mod={k:before['metadata'].get(k,v) for k,v in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
assertions=sum(r['assertions'] for r in validation['tests'])
count=f'{assertions:,}'
mod['summary']='v0.28.11 修复委托记录种类一直为0：后续非送信契约按实际类型去重累计，保留已有履约次数，旧记录缺失种类时明确提示。包含觉醒文案精简、传奇蓝光握把及酒馆交互修复。请新开战役验收。'
intro=('v0.28.11：修复委托记录完成次数增加、种类一直为0的问题。后续完成并收款的非送信契约会按实际类型去重累计，'
       '相同类型不会重复增加种类。原版送信和阿飞送信均不增加人物招募所需的有效履约次数。'
       '已有履约记录保留；旧记录若未保存契约种类，无法仅从完成次数推算历史种类。'
       '名册改用“已记录种类”，没有种类记录时显示“暂无（旧记录未保存种类）”。')
description=before['metadata']['description']
assert description.startswith('v0.28.10：')
mod['description']=intro+'\n\n'+description.replace('v0.28.10：','保留v0.28.10更新：',1).replace('33,468',count)
notes=('修复委托记录种类一直为0：从原版契约引用读取真实类型，在完成结算前保存，按不同类型去重累计；'
       '两种送信契约均排除于人物招募履约统计，契约清理为空类型时不覆盖已知记录。保留旧履约次数，缺失的历史种类明确提示，不凭空补算。'
       '包含觉醒文案精简、传奇蓝光握把和酒馆交互修复。'
       +count+'条离线断言、124份脚本和287个包文件校验通过，类型统计仍待实机复测。请新开战役验收。')
proof={'version':'0.28.11','prior_version':'0.28.10','changed_package_entries':changed,
       'cause':'Membership testing skips getType forwarded by native WeakTableRef.',
       'native_reference_failure_reproduced':True,'type_read_before_completion':True,
       'distinct_types_deduplicated':True,'native_and_mod_couriers_excluded':True,
       'empty_type_does_not_erase_known_type':True,'historical_completion_count_retained':True,
       'historical_types_not_invented':True,'missing_history_labeled':True,
       'behavior_assertions':assertions,'contract_hook_assertions':73,'in_game_tested':False}
(stage/'contract-type-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
      'mod':mod,'version':'0.28.11','notes':notes,'package_filename':package.name,'sha256':sha(package),
      'verification':{'source_root':'src','prior_version':'0.28.10','internal_version':61,'entries':287,
                      'behavior_assertions':assertions,'contract_hook_assertions':73,
                      'native_reference_failure_reproduced':True,'public_download_byte_comparison':False}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher=(root/'build/publish-v0.28.10/publish.py').read_text(encoding='utf-8').replace('afeix-02810','afeix-02811').replace('0.28.10','0.28.11')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm=(root/'build/publish-v0.28.10/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.10','0.28.11').replace('33,468',count)
confirm=confirm.replace("'5场未觉醒的参战胜利'", "'5场未觉醒的参战胜利', '已记录种类', '旧记录未保存种类'")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print('Prepared v0.28.11: '+count+' assertions, native-reference failure reproduced, no public ZIP download.')
