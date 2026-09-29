"""Prepare the authorized v0.22.0 release from live BBMOD metadata."""
import hashlib
import json
import shutil
import sys
import urllib.request
import zipfile
from pathlib import Path

sys.stdout.reconfigure(encoding='utf-8')
root = Path(__file__).resolve().parents[2]
stage = Path(__file__).resolve().parent
report = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
package = root / report['package']
assert report['version'] == '0.22.0'
assert report['sha256'] == '5bb5c7d4bee9e7d4c5acad4a5b63d06f4492eccee969c3892e5158894345e93f'
assert hashlib.sha256(package.read_bytes()).hexdigest() == report['sha256']
assert report['crc_passed'] and report['source_bytes_match']
assert validation['syntax_passed'] and validation['behavior_tests_passed']
with zipfile.ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == 234
    for name in archive.namelist():
        if not name.endswith('/'):
            assert archive.read(name) == (root / 'src' / name).read_bytes(), name
with urllib.request.urlopen('https://bbmod.site/api/v1/catalog/', timeout=30) as response:
    catalog = json.load(response)
mod = next(m for m in catalog['mods'] if m['id'] == 'd64a00f6-1d60-4d8d-8d9b-de055fc0b748')
assert mod['file_name'] == package.name and mod['metadata']['uploader'] == 'laimiu'
assert mod['version'] == '0.20.1', 'Unexpected latest version; review before publishing'
(stage / 'website-before.json').write_text(json.dumps(mod, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
fields = dict(mod['metadata'])
for key in ('uploader', 'author'):
    fields.pop(key, None)
fields['install_name'] = mod['file_name']
for key in ('mod_ids', 'requires', 'conflicts'):
    fields[key] = '\n'.join(fields[key])
fields['summary'] = '三队长启程，自由组建最多十人出战的远征团。v0.22.0 修正倒地头部位置，扩写战团结局，并将大地图队伍换为阿飞。'
fields['description'] = (
    '阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。通过城镇契约与战斗逐渐结识伙伴，在城镇招募界面邀请达成条件的成员加入。\n\n'
    '最多 40 人在册，每战自选 1～10 人；原版人物栏仍能调整装备与站位。世界地图按 F8 打开黑旗名册，查看已知伙伴和委托，并在安全地点安排队伍。'
    '伙伴 7 级专属技能三选一、11 级自动精通，新的相遇和隐藏内容由玩家探索。\n\n'
    'v0.22.0 将本起源大地图行军与站立时的队伍图标替换为阿飞，按移动方向左右转向，保留所选战团旗帜和原版扎营帐篷。旧档重新启动游戏并读取后生效。\n\n'
    '同时发布战死与结局更新：倒地人物保留原版躯干、护甲与头盔，专属头部按颈部连接点和仰倒方向重新定位。'
    '新增 8 种战团主结局，34 人各有两种退隐后续与一段阵亡纪念，共 102 段个人文字，另有 11 段阿飞路线、六根、自行车等回应。'
    '结局按实际在册、生死和经历选择，未招募伙伴不会出场。\n\n'
    '六段酒馆相遇与旧留言、十二个选项及回应重新编写，保留触发顺序和奖励；信件页补充回应与补给的显示。'
    '沿用 34 人专属背景、四派事件、刘青松相遇 NPC、红装“老马的垂直握把”、小龟体质、技能成长和平衡，以及 v0.20.1 的战斗和理发店修复。\n\n'
    '公开开发试玩版。通过 22,057 条离线断言及脚本编译、资源、图集和 ZIP／源码一致性检查，已安装至开发机。'
    '本轮倒地图层、大地图动态图标与结局滚动排版尚未完成游戏内实机验收。'
)
notes = (
    'v0.22.0 阿飞大地图、战死资源与战团结局（公开试玩版）\n\n'
    '1. 大地图行军与站立队伍图标换为阿飞，支持左右转向。保留战团旗帜、原版帐篷与营火，以及移动速度和寻路；收营恢复阿飞，其他起源不替换。\n'
    '2. 修复战死后只剩横放胸像的问题，保留原版倒地躯干、护甲、头盔及同格已有尸体；专属头部改按颈部连接点定位，并修正仰倒方向和镜像角度。36 组外观新增倒地头部资源，昏迷和复活保留身份；斩首、碎颅等特殊死亡不补回完整头部。本轮没有逐人重绘闭眼表情或新增专属断头动画。\n'
    '3. 扩写 8 种退隐与败亡主结局。34 人各有声名已立、平凡收旗和阵亡纪念三段文字，共 102 段；另有 11 段阿飞缺席／路线、六根和自行车回应。按真实在册、生死与已完成选择生成后续，未招募成员不出场。修正结局在原版资产管理器上的注册入口。\n'
    '4. 更新小原、哈曼、四哥的酒馆相遇，以及可可、小龟、余初九的旧留言，共六段、十二个选项及回应。触发顺序、奖励和存档标记不变；信件页分别显示回应和补给。\n\n'
    '包含 v0.21.0 的本地更新，并保留此前人物背景、随机事件、技能、平衡与修复。\n\n'
    '验证：22,057 条离线断言通过；脚本编译、原版资源、图集像素／锚点回读、ZIP CRC 与逐文件源码一致性检查通过。'
    '本轮尚未启动游戏验收倒地锚点、头盔变体、地图动态图标及结局滚动排版；离线合成预览不是实机截图。\n\n'
    '安装：完全退出游戏，将 ZIP 整包替换 data 目录同名旧包，不解压、不并存多版本；需要 mod_hooks 和中文字体／汉化环境。'
    '重启后直接读取本项目旧战役，无需重新开局；更新前建议备份存档。进行中战场已经生成的旧尸体不会即时重绘。'
)
spec = {'owner': 'laimiu', 'expected_mod_id': mod['id'], 'expected_metadata': mod['metadata'],
        'version': report['version'], 'sha256': report['sha256'], 'notes': notes, 'mod': fields}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
upload = (root / 'build/publish-v0.20.1/upload.py').read_text(encoding='utf-8')
upload = upload.replace('afeix-v0.20.1-51011ac5', 'afeix-v0.22.0-' + spec['sha256'][:8])
(stage / 'upload.py').write_text(upload, encoding='utf-8')
verify = (root / 'build/publish-v0.20.1/verify.py').read_text(encoding='utf-8')
verify = verify.replace("assert 'scripts/mods/afeix/barber_hooks.nut' in archive.namelist()",
    "assert 'scripts/mods/afeix/world_art_hooks.nut' in archive.namelist()\n    assert 'scripts/mods/afeix/ending_data.nut' in archive.namelist()\n    assert len(archive.namelist()) == 234")
(stage / 'verify.py').write_text(verify, encoding='utf-8')
print(json.dumps({'current_version': mod['version'], 'new_version': spec['version'], 'mod_id': mod['id'],
                  'sha256': spec['sha256'], 'size': package.stat().st_size,
                  'behavior_assertions': report['behavior_assertions']}, ensure_ascii=False))
