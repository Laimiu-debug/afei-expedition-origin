"""Prepare the authorized hotfix publication from live website metadata."""
import hashlib
import json
import shutil
import sys
import urllib.request
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
root = Path(__file__).resolve().parents[2]
stage = Path(__file__).resolve().parent
report = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
package = root / report['package']
assert report['version'] == '0.20.1'
assert hashlib.sha256(package.read_bytes()).hexdigest() == report['sha256']
assert report['crc_passed'] and report['source_bytes_match']
with urllib.request.urlopen('https://bbmod.site/api/v1/catalog/', timeout=30) as response:
    catalog = json.load(response)
mod = next(m for m in catalog['mods'] if m['id'] == 'd64a00f6-1d60-4d8d-8d9b-de055fc0b748')
assert mod['file_name'] == package.name and mod['metadata']['uploader'] == 'laimiu'
assert mod['version'] in ('0.20.0', '0.20.1'), 'Unexpected latest version; review before publishing'
(stage / 'website-before.json').write_text(json.dumps(mod, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
fields = dict(mod['metadata'])
for key in ('uploader', 'author'):
    fields.pop(key, None)
fields['install_name'] = mod['file_name']
for key in ('mod_ids', 'requires', 'conflicts'):
    fields[key] = '\n'.join(fields[key])
fields['summary'] = '三队长启程，自由组建最多十人出战的远征团。v0.20.1 修复战斗崩溃、理发店头像叠层，并接入 34 人专属背景。'
fields['description'] = (
    '阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。通过城镇契约与战斗逐渐结识伙伴，在城镇招募界面邀请达成条件的成员加入。\n\n'
    '最多 40 人在册，每战自选 1～10 人；原版人物栏仍能调整装备与站位。世界地图按 F8 打开黑旗名册，查看已知伙伴和委托，并在安全地点安排队伍。'
    '伙伴 7 级专属技能三选一、11 级自动精通，新的相遇和隐藏内容由玩家探索。\n\n'
    'v0.20.1 修复击杀敌人后访问已移出地图目标导致的战斗崩溃；修复理发店原版头发、胡须和纹身叠在专属头像上的问题。'
    '专属人物外观保持固定，理发店显示说明并禁用不适用的修改；普通佣兵仍可正常理发。\n\n'
    '正式接入 34 人专属背景与故事：阿飞为“黑旗发起人”，王大谋为“游历盾师”，午夜抹抹茶为“随军账房”。'
    '旧档自动迁移原有短工、民兵、偷猎者背景，保留培养进度、装备、工资倍率和个人路线；已皈依者保留原版皈依身份与相应文案。\n\n'
    '保留 v0.20.0 新增的 10 个可重复随机事件、30 个选项及独立后续，以及此前的技能成长与平衡、人物美术、四派事件、刘青松相遇 NPC、红装和小龟体质。'
    '旅途对白共 32 段、75 个选项。\n\n'
    '本版通过 29 组离线测试，共 21,742 条断言，以及 105 个脚本编译、原版资源与 ZIP／源码一致性检查。'
    '已安装至开发机；本次热修复尚未启动游戏做实机复测。公开开发试玩版。'
)
notes = (
    'v0.20.1 战斗、理发店与人物背景热修复（公开试玩版）\n\n'
    '1. 修复近战和远程击杀后，命中回调读取已移出地图敌人的位置导致的崩溃。击杀时仍正常结算相关命中效果与疲劳恢复。\n'
    '2. 修复理发店原版发型、胡须和纹身叠在专属胸像上的问题。专属外观不可在理发店修改，界面显示说明；普通佣兵的理发功能保留。\n'
    '3. 接入全部 34 人专属背景名称与故事。旧档读取时自动替换仍使用原始模板的具名伙伴背景，不重掷属性、天赋、装备、等级与特性。\n'
    '4. 保留已皈依角色的原版身份，补充个人经历与皈依文案；修复转化时专属身体缺少原版纹身资源的问题。个人路线、专属研习及工资倍率保留。\n\n'
    '沿用 v0.20.0 的随机事件、技能成长、平衡与美术更新。\n\n'
    '验证：29 组离线测试共 21,742 条断言；105 个脚本编译、原版资源引用、ZIP CRC 与源码一致性检查通过。'
    '本次尚未启动游戏做实机复测，上传成功不代表完成实机验收。\n\n'
    '安装：完全退出游戏，将 ZIP 整包替换 data 目录同名旧包，不解压、不并存多版本；需要 mod_hooks 和中文字体／汉化环境。'
    '重启游戏后直接读取本项目旧战役，无需重新开局；更新前建议备份存档。'
)
spec = {'owner': 'laimiu', 'expected_mod_id': mod['id'], 'expected_metadata': mod['metadata'],
        'version': report['version'], 'sha256': report['sha256'], 'notes': notes, 'mod': fields}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
upload = (root / 'build/publish-v0.20.0/upload.py').read_text(encoding='utf-8')
upload = upload.replace('afeix-v0.20.0-29971ed3', 'afeix-v0.20.1-' + spec['sha256'][:8])
(stage / 'upload.py').write_text(upload, encoding='utf-8')
verify = (root / 'build/publish-v0.20.0/verify.py').read_text(encoding='utf-8')
verify = verify.replace("assert 'scripts/mods/afeix/ideas_random.nut' in archive.namelist()",
    "assert 'scripts/mods/afeix/barber_hooks.nut' in archive.namelist()\n    assert 'scripts/skills/backgrounds/afeix_afei_background.nut' in archive.namelist()")
(stage / 'verify.py').write_text(verify, encoding='utf-8')
print(json.dumps({'current_version': mod['version'], 'new_version': spec['version'], 'mod_id': mod['id'],
                  'sha256': spec['sha256'], 'size': package.stat().st_size}, ensure_ascii=False))
