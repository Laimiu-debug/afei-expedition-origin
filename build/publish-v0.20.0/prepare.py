"""Prepare the requested BBMOD update from the current public listing and validated ZIP."""
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
assert report['version'] == '0.20.0'
assert hashlib.sha256(package.read_bytes()).hexdigest() == report['sha256']
with urllib.request.urlopen('https://bbmod.site/api/v1/catalog/', timeout=30) as response:
    catalog = json.load(response)
mod = next(m for m in catalog['mods'] if m['id'] == 'd64a00f6-1d60-4d8d-8d9b-de055fc0b748')
assert mod['file_name'] == package.name and mod['metadata']['uploader'] == 'laimiu'
(stage / 'website-before.json').write_text(json.dumps(mod, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
fields = dict(mod['metadata'])
for key in ('uploader', 'author'):
    fields.pop(key, None)
fields['install_name'] = mod['file_name']
for key in ('mod_ids', 'requires', 'conflicts'):
    fields[key] = '\n'.join(fields[key])
fields['summary'] = '三队长启程，自由组建最多十人出战的远征团。v0.20.0 试玩版新增 10 个随机事件与 30 个选项后续。'
fields['description'] = (
    '阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。通过城镇契约与战斗逐渐结识伙伴，在城镇招募界面邀请达成条件的成员加入。\n\n'
    '最多 40 人在册，每战自选 1～10 人；原版人物栏仍能调整装备与站位。世界地图按 F8 打开黑旗名册，查看已知伙伴和委托，并在安全地点安排队伍。'
    '伙伴 7 级专属技能三选一、11 级自动精通，新的相遇和隐藏内容由玩家探索。\n\n'
    'v0.20.0 新增 10 个可重复随机事件、30 个选项及独立后续，包括四派新相遇和伙伴查账、收零件、看地图、下棋、练舞、记事。'
    '按人物与地点抽选，沿用 1.5 天共享间隔，各自冷却 8～10 天。\n\n'
    '同时包含此前本地版本的技能成长与平衡、人物美术更新、四派事件、刘青松相遇 NPC、红装与小龟体质等内容。旅途对白共 32 段、75 个选项。\n\n'
    '本版通过 20,777 条离线行为检查及 ZIP／源码一致性检查。开发机已安装；新增内容尚未完成实机验收，弹窗显示、事件频率、实战与长期平衡仍待验证。公开开发试玩版。'
)
notes = (
    'v0.20.0 随机事件第二批（公开试玩版）\n\n'
    '新增 10 个可重复事件、30 个选项及独立后续：四派各一段新相遇，以及抹茶查账、小月牙收零件、小宁与老蔡看地图、小龟下棋、帅子与小胖徐练舞、宋暖阳记事。'
    '指定人物须存活在队，按行军／营地／城镇条件抽选；第 3 天起，共享 1.5 天间隔，各自冷却 8～10 天。支持物资容量检查及防重复结算。\n\n'
    '自网站上一版 v0.16.1 起的累计更新：伙伴 7 级三选一、11 级精通与平衡调整；部分人物胸像及技能图标更新；四派随机事件、刘青松两段相遇（不可招募）、红装“老马的垂直握把”、小龟体质，以及人物与路线后续对白。旅途对白合计 32 段、75 个选项。\n\n'
    '验证：26 组离线测试共 20,777 条断言，新事件 356 条；脚本、原版资源、图集及 ZIP 一致性检查通过。本批尚未启动游戏验证，弹窗排版、自然触发频率、实战及长期平衡仍待验收。\n\n'
    '安装：退出游戏，将 ZIP 整包替换 data 目录同名旧包，不解压、不并存多版本；需要 mod_hooks 和中文字体／汉化环境。已有本项目战役可继续，建议更新前备份存档。'
)
spec = {'owner': 'laimiu', 'expected_mod_id': mod['id'], 'expected_metadata': mod['metadata'],
        'version': report['version'], 'sha256': report['sha256'], 'notes': notes, 'mod': fields}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
print(json.dumps({'current_version': mod['version'], 'new_version': spec['version'], 'mod_id': mod['id'],
                  'sha256': spec['sha256'], 'size': package.stat().st_size}, ensure_ascii=False))
