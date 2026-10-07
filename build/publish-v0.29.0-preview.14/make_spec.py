"""Build website-release.json for v0.29.0-preview.14 from the captured live record."""
from pathlib import Path
import hashlib, json, shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.29.0-preview.14'
package_name = f'mod_afeix_expedition v{version}.zip'
shutil.copy2(root / 'dist' / package_name, stage / package_name)
sha = hashlib.sha256((stage / package_name).read_bytes()).hexdigest()
assert sha == '9439a437748d0e66e9a94982ad5952904b5447f9ef90ce0abba30af598400a08'
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
meta = before['metadata']
assert before['releases'][0]['version'] == '0.29.0-preview.13'

description = """阿飞、王大谋、午夜抹抹茶三个人扛着一面黑旗起家，路上陆续招人，名册里一共 34 个熟面孔。最多 40 人在册，一场仗最多上 12 个。

开局先做一场梦：刀一十人 11 级、一身传奇装备，连打蜘蛛、恐狼、林德虫，最后对上斗鱼·深渊之主。梦醒以后只剩三个人和一面旗，招人、补给、修装备都得从头来。不想打梦境可以跳过，之后在世界地图按 F8 → 再赴梦潮还能回去。斗鱼在现实大陆上也留了个窝，梦潮祭场得自己行军过去。

34 个人各有出场时间和招募条件，会在城镇的招募列表里陆续出现。每人有自己的出身、招募相遇、3 级成长事件、7 级三选一的专属技能和 11 级精通。阿飞可以转职蛤蟆人或嘉豪，凑齐六根还能解锁飞碟。另外还有水友四派的随机事件、传奇武器“老马的垂直握把”、酒馆里花钱加属性的“飞李不可”、8 种战团结局，以及每个人的退隐和阵亡后续。

世界地图按 F8 打开黑旗名册：伙伴线索、招募条件、布阵、换旗、隐藏头盔、回看剧情都在这里，Esc 关闭。

v0.29.0-preview.14：黑潮按游戏实际分辨率绘制，2560×1440 下也能铺满全屏。游戏里的剧情、人物介绍、招募相遇、成长事件、随机事件、结局和出身背景全部重写，换成《战场兄弟》的口吻，再加上每个人自己的梗。罗一可和眼子的专属后续剧情删除，两人和其他伙伴一样。剧情走向、数值和触发条件不变；新文本还没在游戏里逐段看过。"""

compat = """v0.29.0-preview.14 是完整主包，包含此前所有 preview 的修订。完整的梦境开局请新开战役；旧阿飞存档可以在安全地点按 F8 → 再赴梦潮回看梦境。

安装：完全退出游戏，把整份 mod_afeix_expedition.zip 放进 data，不要解压。替换同名旧包，移走其他版本的主包，一次只留一份。需要 Legacy Modding Script Hooks（mod_hooks）、中文字体或汉化，以及上面列出的官方 DLC。可选 DLC 另外安装，主包里不含。

梦境期间不能保存临时队伍，进幕前的自动存档保留原战役状态；梦醒后现实里的人物、装备和主要资源都会恢复。存档依赖本 Mod，不保证和 Legends、Reforged 或其他改动编队、图层、战斗流程的 Mod 兼容。"""

notes = (root / 'build/publish-v0.29.0-preview.14/github-notes.md').read_text(encoding='utf-8').split('\n', 2)[2].strip()

def joined(value):
    return ', '.join(value) if isinstance(value, list) else value

mod = {k: joined(v) for k, v in meta.items()}
mod.update({'summary': 'v0.29.0-preview.14：黑潮铺满全屏；剧情、人物、事件、结局和背景文字全部重写；罗一可、眼子与其他伙伴统一。',
            'description': description, 'compatibility_notes': compat,
            'install_name': 'mod_afeix_expedition.zip', 'rights': True})
spec = {'owner': before['owner'], 'expected_mod_id': before['id'], 'expected_metadata': meta,
        'mod': mod, 'version': version, 'notes': notes, 'package_filename': package_name,
        'verification': {'prior_version': '0.29.0-preview.13', 'source_root': 'src', 'entries': 332,
                         'internal_version': 78, 'behavior_assertions': 46535},
        'sha256': sha}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('spec ok', sha, len(description), len(mod['summary']))
