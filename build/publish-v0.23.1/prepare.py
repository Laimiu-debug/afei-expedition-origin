"""Prepare the authorized v0.23.1 release from current public metadata."""
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
assert report['version'] == '0.23.1'
assert report['sha256'] == '0cc0b6bacc8eddf0321d690da5ca1a666e52c1df55ec631545ad96d3650fd0d8'
assert hashlib.sha256(package.read_bytes()).hexdigest() == report['sha256']
installed = Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data') / package.name
assert package.read_bytes() == installed.read_bytes()
assert report['crc_passed'] and report['source_bytes_match']
assert validation['syntax_passed'] and validation['behavior_tests_passed']
assert report['behavior_assertions'] == 22112
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
assert mod['version'] == '0.22.0', 'Unexpected latest version; review before publishing'
(stage / 'website-before.json').write_text(json.dumps(mod, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
fields = dict(mod['metadata'])
for key in ('uploader', 'author'):
    fields.pop(key, None)
fields['install_name'] = mod['file_name']
for key in ('mod_ids', 'requires', 'conflicts'):
    fields[key] = '\n'.join(fields[key])
fields['summary'] = '三队长启程，自由组建最多十人出战的远征团。v0.23.1 修复已解锁伙伴不出现，改为最多三人同时招募、雇佣后一天补位，并修正额外送信干扰普通契约的问题。'
fields['description'] = (
    '阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。通过契约与战斗逐渐结识伙伴，在聚落的雇佣界面邀请达成条件的成员加入。\n\n'
    '最多 40 人在册，每战自选 1～10 人；原版人物栏仍能调整装备与站位。世界地图按 F8 打开黑旗名册，查看已知伙伴和委托，并在安全地点安排队伍。'
    '伙伴 7 级专属技能三选一、11 级自动精通，新的相遇和隐藏内容由玩家探索。\n\n'
    'v0.23.1 修复招募属性显示 Mod（mod_fox_043）覆盖招募查询后，已解锁伙伴一直不出现的问题，保留属性显示功能。'
    '现在最多同时出现 3 位已达标伙伴；每雇佣一人，该位置在 1 个完整游戏日后补入排队伙伴，其他候选人仍可立即雇佣。'
    '每人保留 4 天，错过后回到队尾；换村会转移现有人选，保留装备与剩余停留时间。各人的解锁条件仍需完成。\n\n'
    '招募地点：白天进入非敌对的普通村庄或城镇，点击人群进入原版雇佣新兵列表。普通中立村庄也可以，无需先刷到友好；军事城堡与要塞不适用。'
    '集市的装备和粮食交易列表不显示人物，夜间可等天亮后再进入。另修复普通佣兵池为空时，已达标主题人物也无法使招募入口显示的问题。\n\n'
    '额外送信不再占用普通契约供给名额，也不再推进原版供给计时；护送商队、猎杀野兽、驱逐强盗等原版任务继续按原版规则生成。'
    '旧档此前已开始的供给冷却可能仍需自然结束一次，不保证每个聚落随时有任务。\n\n'
    '沿用 34 人专属背景、随机事件与四派故事、刘青松相遇 NPC、红装“老马的垂直握把”、小龟体质、技能成长和平衡。'
    '保留阿飞大地图图标、左右转向与原版扎营，战死头部定位修复、8 种战团主结局、102 段个人后续，以及酒馆和信件文案更新。\n\n'
    '公开开发试玩版。通过 22,112 条离线断言及脚本编译、资源、图集和 ZIP／源码一致性检查。'
    '已使用上述属性显示 Mod 的实际查询和雇佣脚本复现并验证兼容修复；本轮游戏内招募显示与完整存读档仍待实机验收。'
    '完全退出并重启游戏后可继续原战役，已解锁队列和原有候选人会衔接，无需重开或重做解锁任务。'
)
fields['compatibility_notes'] += (
    '\n\nv0.23.1 针对 mod_fox_043 招募属性显示 Mod 补充兼容修复，保留其显示功能；此项已通过离线脚本复现验证，尚待实机确认。'
    '旧档自动保留招募队列、已有候选人和装备，新增两个候选位置；旧三天补位等待按原雇佣时刻缩短为一天，已超过一天的等待不会重新计时。'
    '更新后需完全重启游戏。'
)
notes = (
    'v0.23.1 三人同时招募、一天补位与招募显示兼容修复（公开试玩版）\n\n'
    '1. 修复与招募属性显示 Mod（mod_fox_043）一起使用时，已完成解锁任务的伙伴仍不出现的问题。保留属性显示及其雇佣流程，无需卸载该 Mod。\n'
    '2. 主题候选人上限改为同时 3 人。每个位置独立计时：雇佣后等待 1 个完整游戏日，由最早排队的达标伙伴补位；其他候选人仍可立即招募。空闲位置在有人达标时立即填充。\n'
    '3. 每位候选人保留 4 天，过期后排回队尾。换聚落转移现有人物，不重抽、不刷新停留时间；旧档保留原候选实体、装备、有效期和已解锁队列，旧三天冷却按原雇佣时间缩短为一天。\n'
    '4. 修复普通佣兵池为空时招募人群入口被隐藏，导致主题候选人无法出现的问题。白天进入非敌对的普通村庄或城镇即可在雇佣列表招募；中立村庄符合条件，无需先刷到友好。军事城堡与要塞不适用，夜间需等天亮。集市商品列表不显示人物。\n'
    '5. 修正额外 Mod 送信占用普通契约容量、重置原版供给计时的问题。护送商队、猎杀野兽、清剿墓地、驱逐强盗等原版契约保留，仍受原版生成规则和冷却约束。旧档已经开始的供给冷却可能需要自然结束一次。\n\n'
    '包含 v0.23.0 招募调整，保留此前 34 人内容、专属技能、美术、大地图阿飞、战死修复、结局和事件文案。各人的解锁条件继续生效，单纯等待不会自动解锁全部人物。\n\n'
    '验证：32 组行为测试、22,112 条离线断言通过；脚本编译、资源、图集、ZIP CRC 和逐文件源码一致性检查通过。'
    '属性显示兼容测试使用该 Mod 的实际查询与雇佣脚本，单个人物画面转换使用测试替身；本轮游戏内界面与完整存读档尚待实机验收。\n\n'
    '安装：完全退出游戏，将 ZIP 整包替换 data 目录同名旧包，不解压、不并存多版本；需要 mod_hooks 和中文字体／汉化环境。'
    '重启后读取本项目原战役即可，无需重开或重做已完成的解锁任务；更新前建议备份存档。'
)
spec = {'owner': 'laimiu', 'expected_mod_id': mod['id'], 'expected_metadata': mod['metadata'],
        'version': report['version'], 'sha256': report['sha256'], 'notes': notes, 'mod': fields}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
upload = (root / 'build/publish-v0.22.0/upload.py').read_text(encoding='utf-8')
upload = upload.replace('afeix-v0.22.0-5bb5c7d4', 'afeix-v0.23.1-' + spec['sha256'][:8])
(stage / 'upload.py').write_text(upload, encoding='utf-8')
verify = (root / 'build/publish-v0.22.0/verify.py').read_text(encoding='utf-8')
verify = verify.replace("assert mod['metadata']['description'] == spec['mod']['description']",
    "for key in ('summary', 'description', 'compatibility_notes'):\n    assert mod['metadata'][key] == spec['mod'][key]")
verify = verify.replace("assert 'scripts/mods/afeix/world_art_hooks.nut' in archive.namelist()",
    "assert 'scripts/mods/afeix/world_art_hooks.nut' in archive.namelist()\n    assert b'showHireDialog' in archive.read('scripts/mods/afeix/hooks.nut')")
(stage / 'verify.py').write_text(verify, encoding='utf-8')
print(json.dumps({'current_version': mod['version'], 'new_version': spec['version'], 'mod_id': mod['id'],
                  'sha256': spec['sha256'], 'size': package.stat().st_size,
                  'behavior_assertions': report['behavior_assertions']}, ensure_ascii=False))
