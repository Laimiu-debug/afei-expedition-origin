"""Prepare the reviewed original-pitch voice DLC and player-facing website metadata."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

STAGE = Path(__file__).resolve().parent
ROOT = STAGE.parents[1]
DLC = ROOT / 'dlc/afei-voice'
before = json.loads((STAGE / 'website-before.json').read_text(encoding='utf-8'))
report = json.loads((DLC / 'report.json').read_text(encoding='utf-8'))
assert (DLC / 'VERSION').read_text().strip() == report['version'] == '0.1.0'
package = DLC / 'dist/mod_afeix_dlc_afei_voice v0.1.0.zip'
digest = hashlib.sha256(package.read_bytes()).hexdigest()
assert digest == 'e5be48f4d9dfe9028c4363f0c96db291d986c6191d06875e50100aae5b000db2'
source = {p.relative_to(DLC / 'src').as_posix(): p for p in (DLC / 'src').rglob('*') if p.is_file()}
original = json.loads((DLC / 'audio/archive/v0.1.0/source.json').read_text(encoding='utf-8'))
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist()) == len(source) == 8
    assert set(archive.namelist()) == set(source)
    for name, path in source.items():
        assert archive.read(name) == path.read_bytes(), name
    for row in original['clips']:
        assert hashlib.sha256(archive.read(row['path'])).hexdigest() == row['sha256']
assert report['scripts_compiled'] == 3 and report['behavior_assertions'] == 24
assert report['base_path_collisions'] == [] and report['base_source_unchanged']
assert '其他' in [choice[0] for choice in before['categories']]
description = '''阿飞挨了一下，熟悉的“哇”也跟着响起来。

“阿飞哇哇叫”是阿飞远征团的独立可选语音 DLC。阿飞角色受伤时，从 5 段实况原声短叫声中随机播放一段，相邻两次避免重复；改名后仍按角色身份识别。其他角色、护甲撞击、攻击与阵亡声音沿用原版。

0.1.0 使用原声音高与语速，每段约 0.77～0.89 秒。音效经过轻度降噪、音量统一和短淡入淡出，没有升调处理。原声取自提供的阿飞实况视频，完整视频不进入安装包。

本 DLC 只增加声音与独立加载脚本，不改变角色属性、装备或剧情，也不内置阿飞远征团主包。需要同时安装主包与 Legacy Modding Script Hooks（mod_hooks）；推荐主包 v0.28.4 或更新版，最低支持主包 v0.26.2（内部版本 36）。

安装前完全退出游戏，将主包与本 DLC 的 ZIP 整包放入游戏 data 文件夹，不要解压。主包和本 DLC 各只保留一个版本。新开战役选择“阿飞远征团”，在战斗中让阿飞受伤即可按原有受伤音效规则触发。

已通过 3 份脚本编译、24 条离线行为检查，以及 8 个包文件的完整集合、CRC 和源码字节一致性核验。尚未实机战斗验收；实际音量、底声与存读档仍需在游戏中确认。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
compatibility = '''需阿飞远征团主包 v0.26.2（内部版本 36）或更新版，以及 Legacy Modding Script Hooks（mod_hooks）。推荐使用主包 v0.28.4 或更新版，并按新建战役验收。

完全退出游戏后，将整份 mod_afeix_dlc_afei_voice.zip 与主包 ZIP 一起放进游戏 data 文件夹，不要解压；本 DLC 只保留一个版本。本扩展是可选语音包，不能代替主包。

本版不新增存档技能、物品或背景类，仅为阿飞角色替换受伤叫声。旧档加载、撤下 DLC 后读档、其他语音 MOD 组合以及实机战斗效果尚未验收。主包原有存档要求继续适用。'''
spec = {'owner': before['owner'], 'mod': {
    'title': '阿飞远征团 DLC：阿飞哇哇叫',
    'summary': '独立可选语音 DLC：阿飞受伤时随机播放 5 段实况原声叫声，保留原声音高。需搭配阿飞远征团主包；尚未实机验收。',
    'description': description, 'category': '其他',
    'source_url': 'https://github.com/Laimiu-debug/afei-expedition-origin',
    'original_author': 'Laimiu（DLC 制作）；阿飞（原声）',
    'license': 'DLC 脚本与打包允许在 BBMOD 分发；原声来自阿飞实况视频，原素材权利归原权利人。',
    'game_version': '1.5.2.3', 'dlc': '随阿飞远征团主包要求：Lindwurm、Beasts & Exploration、Warriors of the North、Blazing Deserts、Of Flesh and Faith',
    'save_impact': 'unknown', 'seed_impact': 'unknown', 'compatibility_notes': compatibility,
    'mod_ids': 'mod_afeix_dlc_afei_voice', 'requires': 'mod_afeix_expedition\nmod_hooks',
    'conflicts': '', 'install_name': 'mod_afeix_dlc_afei_voice.zip'},
    'version': '0.1.0', 'notes': '首版独立语音 DLC：阿飞受伤时随机播放 5 段实况原声短叫声，相邻两次避免重复。保留原声音高与语速，仅做轻度降噪、音量统一及淡入淡出；其他角色与其他声音沿用原版。需主包及 mod_hooks，推荐主包 v0.28.4、新开战役使用。3 份脚本、24 条离线检查和 8 个包文件核验通过，尚未实机验收。',
    'package_filename': package.name, 'sha256': digest,
    'verification': {'source_root': 'dlc/afei-voice/src', 'mod_id': 'mod_afeix_dlc_afei_voice',
        'internal_version': 1, 'entries': 8, 'voice_clips': 5, 'behavior_assertions': 24}}
if before['target']:
    assert before['target']['owner'] == before['owner']
    spec.update(expected_mod_id=before['target']['id'], expected_metadata=before['target']['metadata'])
else:
    spec['expected_absent'] = True
(STAGE / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, STAGE / package.name)
publisher = (ROOT / 'tools/publish_bbmod_release.py').read_text(encoding='utf-8')
# Require an absent target to remain absent, while keeping same-byte retry recovery.
needle = '    form = ModForm(spec[\'mod\'], instance=existing)'
assert publisher.count(needle) == 1
publisher = publisher.replace(needle,
    '    if spec.get("expected_absent"):\n        assert existing is None, "New DLC target appeared; refresh the snapshot"\n' + needle)
(STAGE / 'publish_bbmod_release.py').write_text(publisher, encoding='utf-8')
print('Prepared original-pitch v0.1.0: 8 exact source files, 5 original clips, separate DLC metadata.')
