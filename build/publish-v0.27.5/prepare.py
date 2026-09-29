"""Prepare the background hotfix using the refreshed live website snapshot."""
import hashlib
import json
import shutil
from pathlib import Path
from zipfile import ZipFile

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.27.4/website-release.json').read_text(encoding='utf-8'))
package = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
dlc = json.loads((root / 'dlc/xiwen-regen/report.json').read_text(encoding='utf-8'))
assert package['version'] == '0.27.5' and package['crc_passed'] and package['source_bytes_match']
assert package['behavior_assertions'] == 28849
assert dlc['package_sha256'] == 'e6da8d4a66b5774dd7c76481d38b8e770fa07456cf0247f3658987fd198e211a'
assert dlc['base_package_sha256'] == package['sha256']
with ZipFile(root / 'dist/mod_afeix_expedition v0.27.4.ZIP') as old, ZipFile(root / package['package']) as new:
    assert sorted(old.namelist()) == sorted(new.namelist())
    changed = [name for name in new.namelist() if old.read(name) != new.read(name)]
    assert sorted(changed) == ['scripts/!mods_preload/mod_afeix_expedition.nut', 'scripts/mods/afeix/balance_v26.nut'], changed
assert hashlib.sha256((root / 'dist/mod_afeix_expedition v0.27.4.ZIP').read_bytes()).hexdigest() == previous['sha256']
workbook_sha = hashlib.sha256((root / 'docs/design/balance-v2/全人物数值与招募总表.xlsx').read_bytes()).hexdigest()
assert workbook_sha == '132ea33d0bf8992e70d617e1100ebe57b50e0f8d10893c0a77df621beb13f240'
background_test = next(t for t in validation['tests'] if t['file'].endswith('/test_backgrounds.nut'))
assert background_test['assertions'] == 1502
assert 'FAIL afei background survives trait cleanup' in (root / 'build/background-v0.27.5/before-fix.log').read_text(encoding='utf-8-sig')
report = {'version': package['version'], 'sha256': package['sha256'], 'reproduced_before_fix': True,
          'cause': 'Fresh trait cleanup matched the Trait bit on native Background | Trait skills.',
          'fix': 'Remove only ordinary Trait skills, preserving backgrounds and personal traits.',
          'background_regression_assertions': background_test['assertions'],
          'main_assertions': package['behavior_assertions'],
          'dlc_related_assertions': sum(t['assertions'] for t in dlc['validation']['tests']),
          'changed_package_files': changed, 'workbook_sha256_unchanged': workbook_sha,
          'dlc_archive_unchanged': True, 'new_campaigns_only': True, 'in_game_tested': False}
(root / 'build/background-v0.27.5/verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
metadata = before['metadata']
mod = {key: metadata[key] for key in previous['mod'] if key in metadata}
mod['install_name'] = 'mod_afeix_expedition.zip'
for key in ('mod_ids', 'requires', 'conflicts'):
    mod[key] = '\n'.join(mod[key])
mod['summary'] = 'v0.27.5 修复人物背景被误删，恢复背景图标、身份介绍和正常工资计算。保留 V2 平衡与老马握把最终数值。34 人起源、最多 12 人出战、40 人在册，请新开战役。'
mod['description'] = '''v0.27.5 背景修复：新角色创建时清理随机特质曾误删人物背景，导致背景图标和身份介绍不显示、背景工资回调失效。现在保留背景，仅清理普通随机特质，再赋予设定的固定特质。人物属性、星位星级、招募、装备、技能、事件和老马握把数值均沿用此前设定。请使用本版新开战役。

''' + mod['description'].replace('v0.27.4 累计实装', 'V2 累计实装').replace('28,203', '28,849')
mod['compatibility_notes'] = mod['compatibility_notes'].replace('v0.27.4.ZIP', 'v0.27.5.ZIP')
notes = '''v0.27.5 人物背景修复：

修复新角色创建时清理随机特质误删人物背景的问题。背景图标、身份介绍和背景工资计算恢复；角色固定特质继续按设定添加。主包 34 人及可选 DLC 希文均已通过背景保留、显示查询、属性、工资与背景存取检查。

人物数值、星位星级、招募、装备、技能、事件和经济设定均不变。老马的垂直握把继续使用 84～120 伤害、70% 穿甲、235% 护甲伤害效率、52 破盾和额外削甲 30。

请完全退出游戏后替换主包 ZIP，data 中仅保留一个主包版本，并新开战役；不迁移旧档。希文与里根 DLC 文件不变，本次下载仍仅包含主包。

主包 28,849 项离线断言及 283 个包内文件校验通过，其中人物背景回归检查 1,502 项；含 DLC 的相关检查 5,587 项通过。尚未实机验收，食尸鬼战斗闪退仍未确认修复。'''
filename = Path(package['package']).name
spec = {'owner': 'laimiu', 'expected_mod_id': before['id'], 'expected_metadata': metadata,
        'mod': mod, 'version': package['version'], 'package_filename': filename, 'sha256': package['sha256'], 'notes': notes}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(root / package['package'], stage / filename)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
verify = (root / 'build/publish-v0.27.4/verify_website.py').read_text(encoding='utf-8')
verify = verify.replace("r['version'] == '0.25.0'", "r['version'] == '0.27.4'")
verify = verify.replace('Semantic release 0.27.4', 'Semantic release 0.27.5').replace('integer version 43', 'integer version 44')
verify = verify.replace(r'\s*43\b', r'\s*44\b').replace('"mod_afeix_expedition", 43,', '"mod_afeix_expedition", 44,')
verify = verify.replace("('0.27.4', '84', '235%', '28,203', '食尸鬼', '新开战役')", "('0.27.5', '84', '235%', '28,849', '背景', '新开战役')")
(stage / 'verify_website.py').write_text(verify, encoding='utf-8')
print(json.dumps(report, ensure_ascii=False, indent=2))
