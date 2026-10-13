"""Prepare the tested 0.29.7 bytes against a fresh website snapshot."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = (root / 'VERSION').read_text().strip()
assert version == '0.29.7'
package_name = f'mod_afeix_expedition v{version}.zip'
package = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
engine = json.loads((root / 'build/geist-turnbar-fix-20261013/root-fix-v0.29.7.json').read_text(encoding='utf-8'))
repeat_dir = root / 'build/geist-turnbar-fix-20261013/visible-retest-20261013-213125'
repeat = json.loads((repeat_dir / 'report.json').read_text(encoding='utf-8'))
cleanup = json.loads((repeat_dir / 'cleanup.json').read_text(encoding='utf-8-sig'))
assert engine['fixed_max_round'] >= 6 and engine['terror_uses'] >= 9 and not engine['battle_exceptions']
assert repeat['max_round'] >= 6 and repeat['terror_uses'] >= 9 and not repeat['battle_exceptions']
assert cleanup['UserConfirmedNormal'] and cleanup['ProbeRemoved'] and cleanup['CopyRemoved']
assert all(row['Unchanged'] for row in cleanup['OriginalSaves'])
source = {p.relative_to(root / 'src').as_posix(): p for p in (root / 'src').rglob('*') if p.is_file()}
with ZipFile(root / 'dist' / package_name) as archive:
    assert archive.testzip() is None and set(archive.namelist()) == set(source)
    assert all(archive.read(name) == path.read_bytes() for name, path in source.items())
    assert 'ui/mods/afeix/turnbar_portraits.js' not in archive.namelist()
shutil.copy2(root / 'dist' / package_name, stage / package_name)
sha = hashlib.sha256((stage / package_name).read_bytes()).hexdigest()
assert sha == package['sha256'] == package['installation']['Sha256']
assert validation['behavior_tests_passed'] and validation['syntax_passed']
assert sum(t['assertions'] for t in validation['tests']) == 46958
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
assert before['id'] == 'd64a00f6-1d60-4d8d-8d9b-de055fc0b748'
assert before['releases'][0]['version'] == '0.29.3'
assert not any(r['version'] == version for r in before['releases'])
meta = before['metadata']
mod = {k: (', '.join(v) if isinstance(v, list) else v) for k, v in meta.items()}
mod['summary'] = 'v0.29.7：修复怨魂尖啸后的回合卡死，勇气读取不再触发技能、头像和界面刷新。'
mod['description'] += ('\n\nv0.29.7：修复怨魂战斗中行动条卡住，甚至引擎崩溃的问题。'
    '怨魂 AI 评估目标时读取勇气，此前会同时刷新技能和头像，导致后台评估期间更新界面。'
    '本版移除读取函数里的写操作，条件勇气加成在真正的士气检定及行动事件中刷新。'
    '怨魂技能、士气判定规则和人物数值不变；临时头像补丁已撤回。'
    '151 份 Squirrel 脚本、46,958 条离线断言及资源检查通过。'
    '原战前存档副本在实际游戏中复测两轮，每轮推进到第 6 回合、经历 9 次尖啸，原异常未再出现，观看复测的玩家确认正常。'
    '此验收针对该怨魂遭遇，完整战役及全部模组组合仍未全部验收。'
    '大地图悬停提示框的空坐标报错仍待处理。')
old = ('v0.29.3 是完整主包，包含此前所有版本的修订，修复 MSU 1.9.0 环境下的斗鱼 AI 行为登记。'
       '本次未改存档格式；完全退出游戏后替换主包，已经卡住的战斗请读取战前存档重新进入。')
assert mod['compatibility_notes'].count(old) == 1
mod['compatibility_notes'] = mod['compatibility_notes'].replace(old,
    'v0.29.7 是完整主包，包含此前已发布版本的修订，修复怨魂战斗中的回合卡死。'
    '本次未改存档格式；完全退出游戏后替换主包，已经卡住的战斗请读取战前存档重新进入。')
mod.update({'install_name': 'mod_afeix_expedition.zip', 'rights': True})
notes = ('修复怨魂尖啸后行动条卡住，甚至引擎崩溃的问题。'
    '怨魂 AI 在后台评估目标时读取勇气，此前本模组却会在读取过程中刷新技能、头像和界面。'
    '现在保留原版勇气读取，在真正士气检定及行动事件中更新条件加成；怨魂技能、士气规则和人物数值不变。'
    '撤回此前仅在本地测试的头像重建、缓存及选择器补丁。\n\n'
    '151 份 Squirrel 脚本、46,958 条离线断言、原生资源、美术、JavaScript 与 332 个包条目检查通过。'
    '实际游戏使用原战前存档副本复测两轮：每轮到第 6 回合，经历 9 次恐怖尖啸，原卡死和引擎异常未再出现；玩家观看复测后确认正常。'
    '自动推进该遭遇的结果不等于完整战役或全部模组组合验收。大地图提示框的空坐标报错仍待处理。\n\n'
    '完全退出游戏后替换完整的 mod_afeix_expedition.zip，不解压，只保留一份主包；可选 DLC 另装。'
    '本次未改存档格式，已卡住的战斗请读取战前存档重新进入。完整梦境开局请新开战役，旧阿飞存档可在安全地点按 F8 → 再赴梦潮回看。\n\n'
    f'SHA-256：`{sha}`')
(stage / 'github-notes.md').write_text('# v0.29.7：修复怨魂尖啸导致回合卡住\n\n' + notes + '\n', encoding='utf-8')
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': meta,
    'mod': mod, 'version': version, 'notes': notes, 'package_filename': package_name,
    'verification': {'prior_version': '0.29.3', 'source_root': 'src', 'entries': len(source),
                     'internal_version': 85, 'behavior_assertions': 46958}, 'sha256': sha}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Prepared v' + version + ': ' + sha)
