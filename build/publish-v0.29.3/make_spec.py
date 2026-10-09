"""Prepare the 0.29.3 release against a fresh, read-only website snapshot."""
from pathlib import Path
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = (root / 'VERSION').read_text().strip()
assert version == '0.29.3'
package_name = f'mod_afeix_expedition v{version}.zip'
shutil.copy2(root / 'dist' / package_name, stage / package_name)
package = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
sha = hashlib.sha256((stage / package_name).read_bytes()).hexdigest()
assert sha == package['sha256'] and package['source_bytes_match'] and package['crc_passed']
assert validation['behavior_tests_passed'] and validation['syntax_passed']
assert next(t for t in validation['tests'] if t['file'] == 'tests/gameplay/test_douyu_ai_compat.nut')['assertions'] == 98
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
meta = before['metadata']
assert before['releases'][0]['version'] == '0.29.2'
assert not any(r['version'] == version for r in before['releases'])
mod = {k: (', '.join(v) if isinstance(v, list) else v) for k, v in meta.items()}
mod['summary'] = 'v0.29.3：修复 MSU 1.9.0 环境下梦境斗鱼回合卡住，恢复移动、挣脱和待机；现实祭场同步修复。'
mod['description'] += ('\n\nv0.29.3：修复同时安装 MSU 1.9.0 时斗鱼回合卡住并报 onBeforeExecute 不存在的问题。'
                       'Boss 初始化时同步清理 AI 行为登记，恢复完整的移动、挣脱、待机和攻击；梦境战和现实祭场都适用。'
                       '斗鱼数值、技能费用和梦境剧情时限不变。新增 98 条兼容回归断言，全部 46,834 条离线断言通过；'
                       '尚未完成群友整套模组组合的实机复测。')
old = 'v0.29.2 是完整主包，包含此前所有版本的修订；装了 0.29.1 的直接替换，存档兼容。'
assert mod['compatibility_notes'].count(old) == 1
mod['compatibility_notes'] = mod['compatibility_notes'].replace(old,
    'v0.29.3 是完整主包，包含此前所有版本的修订，修复 MSU 1.9.0 环境下的斗鱼 AI 行为登记。'
    '本次未改存档格式；完全退出游戏后替换主包，已经卡住的战斗请读取战前存档重新进入。')
mod.update({'install_name': 'mod_afeix_expedition.zip', 'rights': True})
notes = ('修复同时安装 MSU 1.9.0 时，轮到“斗鱼·深渊之主”出现 onBeforeExecute 不存在并卡住的问题。'
         'Boss 初始化通过原版接口逐个移除旧 AI 行为，使 MSU 同步清理登记，恢复移动、挣脱、待机和攻击。'
         '梦境战与现实梦潮祭场同步修复；斗鱼数值、技能费用和梦境剧情时限不变。\n\n'
         '新增 98 条 AI 兼容回归断言，覆盖装有和未装 MSU、远处目标、特殊攻击及行动点耗尽后的待机。'
         '151 份 Squirrel 脚本、46,834 条离线断言、原生资源、美术、JavaScript 与 332 个包条目检查通过；'
         '尚未完成群友整套模组组合的实机复测。\n\n'
         '退出游戏后替换完整的 mod_afeix_expedition.zip，不用解压，只保留一份主包；可选 DLC 另装。'
         '本次未改存档格式；已经卡住的战斗请读取战前存档重新进入。完整梦境开局请新开战役，'
         '旧阿飞存档可在安全地点按 F8 → 再赴梦潮回看。\n\n'
         f'SHA-256：`{sha}`')
(stage / 'github-notes.md').write_text('# v0.29.3：修复 MSU 环境下斗鱼回合卡住\n\n' + notes + '\n', encoding='utf-8')
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': meta,
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package_name,
        'verification': {'prior_version': '0.29.2', 'source_root': 'src', 'entries': len(package['entries']),
                         'internal_version': 81, 'behavior_assertions': sum(t['assertions'] for t in validation['tests'])},
        'sha256': sha}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('Prepared v' + version + ': ' + sha)
