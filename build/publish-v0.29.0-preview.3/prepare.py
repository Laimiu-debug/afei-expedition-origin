"""Prepare the reviewed complete dream-origin Mod for the migrated BBMOD site."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.29.0-preview.3'
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.28.14/website-release.json').read_text(encoding='utf-8'))
validation = json.loads((root / 'build/gameplay-validation.json').read_text(encoding='utf-8'))
package_report = json.loads((root / 'build/gameplay-package.json').read_text(encoding='utf-8'))
sha = lambda data: hashlib.sha256(data).hexdigest()
assert (root / 'VERSION').read_text().strip() == package_report['version'] == version
assert all(validation[key] for key in ('syntax_passed', 'behavior_tests_passed', 'native_resource_paths_passed'))
assert validation['custom_art']['passed']
for row in validation['scripts'] + validation['ui_scripts']:
    assert sha((root / row['path']).read_bytes()) == row['sha256'], row['path']
assertions = sum(row['assertions'] for row in validation['tests'])
assert assertions == 45691 and len(validation['scripts']) == 147
source = {p.relative_to(root / 'src').as_posix(): p.read_bytes() for p in (root / 'src').rglob('*') if p.is_file()}
package = root / package_report['package']
assert sha(package.read_bytes()) == package_report['sha256'] == 'aa13a6e0fbb890fd91b7b983c230d92634992269f3da344ba3b4cd92569fee29'
assert package.stat().st_size == 4858322
with ZipFile(package) as archive:
    assert archive.testzip() is None
    assert len(archive.namelist()) == len(set(archive.namelist())) == len(source) == 324
    assert set(archive.namelist()) == set(source)
    assert all(archive.read(name) == data for name, data in source.items())
assert b'Version = 67' in source['scripts/!mods_preload/mod_afeix_expedition.nut']
for name in ('dream_ledger', 'dream_flow', 'dream_hooks', 'douyu_world', 'douyu_gear'):
    assert 'scripts/mods/afeix/' + name + '.nut' in source
assert 'scripts/entity/world/locations/afeix_douyu_location.nut' in source
assert before['id'] == previous['expected_mod_id']
prior = next(row for row in before['releases'] if row['version'] == '0.28.14')
assert prior['sha256'] == previous['sha256'] and prior['status'] == 'published'
assert not any(row['version'] == version for row in before['releases'])
mod = {key: before['metadata'].get(key, value) for key, value in previous['mod'].items()}
for key in ('mod_ids', 'requires', 'conflicts'):
    if isinstance(mod[key], list):
        mod[key] = '\n'.join(mod[key])
mod['summary'] = 'v0.29.0-preview.3 完整主包：三人同梦、刀一十人11级传奇配装，原版教程式故事弹窗；梦醒自由招募，前往现实梦潮祭场挑战斗鱼，掉落鲨皮重甲、鱼翅双手砍刀与鲨牙单手矛。体验完整开局请新开战役。'
intro = '''v0.29.0-preview.3：阿飞、抹茶与大谋在大陆旅途中围着营火看地图，夜里走进同一个梦。刀一十人全员11级、传奇配装，按既有成长方向各守岗位，依次挑战蜘蛛、恐狼、林德虫与“斗鱼·深渊之主”；最后从败北的梦潮中醒来，接回真实三人黑旗的原始队伍、装备、资源和时间。可略过梦境战斗，直接启程。

开局采用原版“新战团”教程式故事窗口：黑旗未满 → 三人同梦 → 黑旗初醒 → 黑旗启程，配夜营、道路插画与三位队长头像，介绍旅程、伙伴与目标。Esc可暂时收起；F8 → 再赴梦潮可继续未读故事，已读启程背景可只读回看。阅读进度随存档保留，回看不启动战斗或重复奖励。

现实大陆新增唯一传奇据点“梦潮祭场”。自由招募、培养和选择最多十二人出战，不强制凑齐梦中十人。F8提供最近城镇与方位，标记后需正常行军抵达再挑战，未击杀时撤退可重来。斗鱼保留《战场兄弟》画风，点名、弹幕洪流与超级火箭有出招预兆，走位和集中攻击可应对；现实战斗的伤亡、消耗与战利品沿用原版规则。

现实击杀掉落三件固定传奇装备各一件：深渊鲨衣，460护甲、疲劳−26，可修理与加装附件；断潮鱼翅，双手砍刀，90–120伤害、165%护甲伤害、55%穿甲；破浪鲨牙，单手矛，54–62伤害、145%护甲伤害、45%穿甲。主属性比同类顶级传奇高一档，沿用原版砍刀与矛的动作及专精。梦境不掉落，现实击杀记录持久保存，不重复生成Boss或发放装备。

这是整个主Mod的完整包，不是独立DLC，包含此前全部更新。请新开战役体验完整梦境开局；原有阿飞旧档不会自动插入梦境，可在F8主动进入序章和查看现实祭场。完全退出游戏后替换旧主包，不要解压，data中仅保留一份阿飞主包ZIP。

147份Squirrel脚本、45,691条离线断言、原版资源路径与JavaScript检查通过；324个包文件的CRC、完整条目与源码字节一致。故事窗口标题、插画与头像、Esc、保存续读、梦境隔离、现实据点、原生战利品与装备数值均有离线检查。尚未安装或完成实机战役验收，弹窗排版、美术贴合、地图可达性与Boss实战平衡待试玩确认。'''
history = before['metadata']['description'].replace('本次v0.28.14外观回退可以沿用旧档。', '此前v0.28.14的外观回退允许沿用旧档；本次梦境开局请新开战役。')
mod['description'] = intro + '\n\n此前版本累计内容：\n\n' + history
mod['compatibility_notes'] = 'v0.29.0-preview.3：完整梦境开局请新开战役。旧阿飞档不自动插入梦境，可主动进入序章；未完成实机存档与第三方Mod组合验收。梦境期间不能保存临时队伍，幕前保留原战役自动存档；现实据点、战斗与三件装备采用原版保存和战利品流程。更新时完全退出游戏，data中只保留一份主包。希文、衣橱与语音仍为独立可选DLC，本包不包含它们。\n\n此前兼容说明：\n\n' + before['metadata']['compatibility_notes']
notes = '新增三人同梦开局：刀一十人全员11级、传奇配装，蜘蛛→恐狼→林德虫→斗鱼，梦醒接回真实三人黑旗。增加原版教程式故事弹窗与头像，Esc收起、F8续读及只读回看。现实大陆新增唯一梦潮祭场，自由组队行军挑战；击杀掉落鲨皮重甲、鱼翅双手砍刀、鲨牙单手矛各一件，梦境不掉落。保留战场兄弟画风与此前全部更新。45,691条离线断言、147份脚本、324个包文件校验通过。完整主包，体验开局请新开战役；尚待实机验收。'
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': before['metadata'],
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package.name, 'sha256': sha(package.read_bytes()),
        'verification': {'source_root': 'src', 'prior_version': '0.28.14', 'internal_version': 67, 'entries': len(source),
                         'behavior_assertions': assertions, 'source_sha256': {name: sha(data) for name, data in sorted(source.items())}}}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / package.name)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
print(f'Prepared v{version}: {assertions:,} assertions; {len(source)} source-matching files; {package.stat().st_size} bytes.')
