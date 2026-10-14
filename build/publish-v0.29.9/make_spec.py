"""Prepare the tested complete package and combined 0.29.8/9 release notes."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
version=(root/'VERSION').read_text().strip()
assert version=='0.29.9'
package_name=f'mod_afeix_expedition v{version}.zip'
package=json.loads((root/'build/gameplay-package.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
menu=json.loads((root/'build/company-ledger-fix-20261013/verified-menu-v0.29.8.json').read_text(encoding='utf-8'))
combat=json.loads((root/'build/kill-hitch-20261014/verified-kill-hitch-v0.29.9.json').read_text(encoding='utf-8'))
assert menu['engine_passed'] and menu['native_ui_checks']==79 and not menu['script_errors']
assert combat['engine_tested'] and combat['full_behavior_assertions']==47065
assert all(s['counts']['tryTurtleAwakening']==1 and s['counts']['battle_scans']==3 for s in combat['runs']['fixed-v87']['samples'])
assert all(v['unchanged'] for v in menu['campaign_files']+combat['original_files'])
assert menu['temporary_probe_removed'] and menu['temporary_save_removed']
assert combat['temporary_game_probe_removed'] and combat['temporary_save_removed']
source={p.relative_to(root/'src').as_posix():p for p in (root/'src').rglob('*') if p.is_file()}
with ZipFile(root/'dist'/package_name) as z:
    assert z.testzip() is None and set(z.namelist())==set(source)
    assert all(z.read(n)==p.read_bytes() for n,p in source.items())
    assert not any('probe' in n for n in z.namelist())
with ZipFile(root/'dist/mod_afeix_expedition v0.29.8.zip') as z:
    for n in ['scripts/mods/afeix/ledger.nut','scripts/mods/afeix/discovery.nut','scripts/mods/afeix/hooks.nut']:
        assert z.read(n)==source[n].read_bytes(), 'Menu-tested code changed: '+n
sha=hashlib.sha256((root/'dist'/package_name).read_bytes()).hexdigest()
assert sha==package['sha256']==combat['installation']['installed_sha256']
assert validation['behavior_tests_passed'] and validation['syntax_passed']
assert sum(t['assertions'] for t in validation['tests'])==47065
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
assert before['id']=='d64a00f6-1d60-4d8d-8d9b-de055fc0b748'
assert before['releases'][0]['version']=='0.29.7' and not any(r['version']==version for r in before['releases'])
meta=before['metadata']
mod={k:(', '.join(v) if isinstance(v,list) else v) for k,v in meta.items()}
mod['summary']='v0.29.9：修复 F8 战团事务与衣橱入口冲突、酒馆识别及 Esc 关闭，减少击杀后的重复扫描和画像刷新。'
mod['description']+='\n\nv0.29.9：包含 v0.29.8 与 v0.29.9 的完整修订。安装衣橱 DLC 后，战团事务超过六个按钮时自动分页，“阿飞外观”位于第二页；修复原版弱引用导致酒馆识别失败、MSU 接管 Esc 后名册关不掉。击杀时，小龟觉醒检测由每个存活角色重复扫描改为只检查一次；原版直接跳过的士气检定不再额外刷新技能和画像。保留 v0.29.7 的怨魂修复。151 份 Squirrel、47,065 条行为断言、资源与 JavaScript 检查通过。酒馆原生菜单 79 项实机检查通过；原战前存档副本中的三次死亡回调复测，每次觉醒检测由约 30–32 次降至 1 次。帧间隔结果为计数器下的小样本，不能保证所有战斗固定延迟；完整战役、全部模组组合及人工鼠标攻击仍未全部验收。'
old='v0.29.7 是完整主包，包含此前已发布版本的修订，修复怨魂战斗中的回合卡死。'
assert mod['compatibility_notes'].count(old)==1
mod['compatibility_notes']=mod['compatibility_notes'].replace(old,'v0.29.9 是完整主包，包含此前修订及 v0.29.8 的酒馆菜单修复，减少击杀后的额外卡顿。现有衣橱、语音与希文 DLC 可继续搭配，主包里不含可选 DLC。')
mod.update(install_name='mod_afeix_expedition.zip',rights=True)
notes=('本版为完整主包，合并酒馆菜单与击杀性能修复：\n\n'
    '- 修复 F8 → 战团事务打不开：安装衣橱后超过原版六按钮上限的入口自动分页，第二页可打开“阿飞外观”。\n'
    '- 修复原版弱引用造成的酒馆识别失败，以及 MSU 接管 Esc 后名册无法关闭。\n'
    '- 减少击杀后卡顿：小龟觉醒检测只扫描一次全场；原版跳过的士气检定不再额外刷新技能和画像。\n'
    '- 保留怨魂 AI 勇气读取修复，真正需要士气检定时仍正常刷新条件加成。\n\n'
    '检查通过：151 份 Squirrel、47,065 条行为断言、原版资源、美术、JavaScript，以及 ZIP 的 332 个条目、CRC 和源码字节。'
    '实际游戏验证了 79 项酒馆菜单检查；同一战前存档副本的三次死亡处理，每次觉醒检测由 30–32 次降至 1 次，全场扫描由 32–34 次降至 3 次。'
    '计数器下的三次击杀至下一帧间隔由约 46–87 ms 降至 39–58 ms，包含计数器、渲染、声音和调度开销，不代表所有战斗的固定延迟。'
    '死亡处理测试使用原版 actor.kill，未进行人工鼠标攻击验收；完整战役和所有模组组合仍未全部验收，大地图提示框空坐标报错另待处理。\n\n'
    '安装：完全退出游戏，把完整 mod_afeix_expedition.zip 原样放入 data，不解压；移走其他版本主包，一次只保留一份。'
    '可选 DLC 另装，现有衣橱、语音与希文包无需替换。本次仍使用存档 schema 8，原战役副本测试后原存档校验保持一致；加载已卡住的战斗请回到战前存档。'
    '完整梦境开局请新开战役，旧阿飞存档可在安全地点按 F8 → 再赴梦潮回看。\n\n'
    f'SHA-256：`{sha}`')
(stage/'github-notes.md').write_text('# v0.29.9：修复酒馆菜单，减少击杀卡顿\n\n'+notes+'\n',encoding='utf-8')
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':meta,'mod':mod,'version':version,
    'notes':notes,'package_filename':package_name,'verification':{'prior_version':'0.29.7','source_root':'src','entries':len(source),'internal_version':87,'behavior_assertions':47065},'sha256':sha}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
acceptance={'version':version,'internal_version':87,'package_sha256':sha,'syntax_files':151,'behavior_assertions':47065,
    'menu_native_checks':79,'menu_tested_version':'0.29.8','menu_code_unchanged_in_release':True,
    'death_callback_runs':combat['runs'],'original_campaign_files_unchanged':True,'temporary_game_probes_removed':True,
    'scope':combat['scope'],'timing_limit':combat['timing_limit']}
(stage/'gameplay-acceptance.json').write_text(json.dumps(acceptance,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(root/'dist'/package_name,stage/package_name)
print('Prepared release',version,'with combined fixes; SHA256',sha)
