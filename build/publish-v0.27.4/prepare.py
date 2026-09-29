"""Prepare the main-package website release from the live metadata snapshot."""
import hashlib
import json
import shutil
from pathlib import Path

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root / 'build/publish-v0.25.0-company/website-release.json').read_text(encoding='utf-8'))
metadata = before['metadata']
mod = {key: metadata[key] for key in previous['mod'] if key in metadata}
mod['install_name'] = 'mod_afeix_expedition.zip'
for key in ('mod_ids', 'requires', 'conflicts'):
    mod[key] = '\n'.join(mod[key])
mod['summary'] = '34 人起源、最多 40 人在册、12 人出战。v0.27.4 实装 V2 人物平衡与招募、装备、技能、事件和经济调整，更新小杰、眼子、宋暖阳及老马的垂直握把。请新开战役。'
mod['description'] = '''阿飞、王大谋、午夜抹抹茶带着一面黑旗上路。通过契约与战斗逐渐结识伙伴，在聚落的雇佣界面邀请达成条件的成员加入。

主包共 34 人，最多 40 人在册，每战自选 1～12 人。世界地图按 F8 打开黑旗名册，查看伙伴、委托与旅途故事；原版人物栏可调整装备、站位和待命。33 名伙伴各有 7 级专属技能三选一、11 级自动精通，共 99 项技能选项；阿飞使用独立晋升路线。

v0.27.4 累计实装 V2 总表中的人物属性、星位星级、固定特质、招募门槛与费用、初始装备、技能消耗、事件及经济调整。阿飞与小酒瓶通过普通培养提高疲劳，不再拥有专属逐级耐力加成。小酒瓶初始近战命中为 60。

小杰调整为高生命轻甲长柄方向，生命、近攻、近防各两星；眼子调整为后排长柄与投掷兼修，近攻、远攻各两星，固定特质为忠诚、团队协作；宋暖阳调整为主动刺剑方向，先攻三星、近攻与近防各两星，固定特质为快速、体弱多病。小酒瓶为步伐稳健与坚定，可可为肥胖与巨大，余初九为忠诚与犹豫，小月牙为贪吃与乐观。亿口甜筒、眼子哥、小胖徐不快乐分别改名小虎、眼子、小胖。

红装“老马的垂直握把”以曹飞派领袖老马的化身登场：马头一昂，蛤蟆低头；握把一挺，铁甲开口。固定伤害 84～120、穿甲 70%、护甲伤害效率 235%、破盾伤害 52，保留单体命中后额外削甲 30。友好集市与武器店自然补货时各有 5% 概率出现，同店已有库存时不再重复新增；反复开关商店不会重抽。

本次也包含黑旗名册研习选择与 11 级精通读取修复、人物界面 F8 冲突修复，以及大名册滚动和拖拽编队修复。请在世界地图打开 F8 菜单。战团事务支持五款蛤蟆旗帜、切回建团所选旗帜、隐藏或显示全队头盔外观；外观开关不会改变装备防护与负重。

保留刀一黑队 10 人、刀二蓝队 8 人、0.5DFW猪团 14 人、旅途来客 2 人的名单，以及个人成长剧情、四派相遇、随机事件、战团结局、大地图阿飞造型与专属人物美术。招募地点为白天的非敌对普通村庄或城镇；军事城堡与要塞不适用。最多同时出现 3 位已达标伙伴，每雇佣一人，该位置间隔 1 个完整游戏日补入排队伙伴。保留 mod_fox_043 招募属性显示兼容、野心结算和解网后技能回调修复。

本页面提供主包。希文与里根属于独立可选 DLC，不包含在本次主包下载中。

公开开发试玩版，按新建战役使用，不承诺旧存档迁移。本地主包已通过 28,203 项离线断言及 283 个包内文件的 CRC、源文件一致性校验，尚未完成本轮实机验收。此前反馈的食尸鬼战斗闪退仍未确认修复。'''
mod['save_impact'] = 'yes'
mod['compatibility_notes'] = '''本版请新开战役。人物平衡、招募与事件均按新建战役验收，不承诺旧存档迁移。

安装前完全退出游戏。网站下载文件名固定为 mod_afeix_expedition.zip，整包放入游戏 data 文件夹，不要解压；替换同名旧包，并将此前带版本号的本 Mod 旧包移出 data，一次只保留一个版本。手动下载后可命名为 mod_afeix_expedition v0.27.4.ZIP。

需要 Legacy Modding Script Hooks（mod_hooks）以及中文字体／汉化环境。新建战役选择“阿飞远征团”。本页面仅发布主包，希文与里根为独立可选 DLC。

在安全的世界地图按 F8 打开黑旗名册；研习专属技能、更换旗帜和头盔外观开关位于“战团事务”。人物界面不打开 F8 菜单。老马的垂直握把需要等待商店自然补货。

存档依赖本 MOD。不保证与 Legends、Reforged 或其他改动编队、人物图层的 MOD 兼容；不要同时加载旧工程或阿飞美术测试起源。保留针对 mod_fox_043 的招募显示兼容修复。食尸鬼战斗闪退尚未确认修复，本轮仍待实机验收。'''
notes = '''v0.27.4 主包更新（含网站 v0.25.0 之后的累计改动）：

1. 按 V2 总表实装人物属性、星位星级、固定特质、招募节奏与费用、初始装备、技能、事件和经济调整。阿飞、小酒瓶通过普通培养提高疲劳，取消专属逐级耐力加成；小酒瓶初始近攻 60。
2. 小杰改为高生命轻甲长柄方向；眼子改为后排长柄／投掷兼修，采用忠诚、团队协作；宋暖阳改为主动刺剑方向，采用快速、体弱多病。同步更新小酒瓶、可可、余初九、小月牙的固定特质。亿口甜筒、眼子哥、小胖徐不快乐改名为小虎、眼子、小胖。
3. 老马的垂直握把固定为伤害 84～120、穿甲 70%、护甲伤害效率 235%、破盾伤害 52，保留额外削甲 30，并更新曹飞派领袖化身的介绍。修正本武器护甲伤害效率提示的取整显示。
4. 修复名册研习后仍显示待选择、专属技能与 11 级精通失效的问题；修复人物界面 F8 冲突，以及大名册滚动、拖拽和编队操作。
5. 主包现有 34 人，33 名伙伴共 99 项专属技能选项；最多 12 人出战、40 人在册。五款旗帜、切回建团旗及全队头盔外观开关继续保留。

请新开战役，退出游戏后替换 ZIP，data 目录只保留本 Mod 一个版本。希文与里根 DLC 不包含在本次主包中。

主包 28,203 项离线断言、283 个包内文件校验通过；尚未完成本轮实机验收。食尸鬼战斗闪退仍未确认修复。'''
filename = 'mod_afeix_expedition v0.27.4.ZIP'
package = root / 'dist' / filename
sha256 = hashlib.sha256(package.read_bytes()).hexdigest()
assert sha256 == '125c7284a03ca706d413ac9e5c4cfe180602183e401eb2f1db8fd04678be87df'
public_text = '\n'.join([mod['summary'], mod['description'], mod['compatibility_notes'], notes])
assert all(secret not in public_text for secret in ('玄武', '只剩阿飞', '只剩下阿飞', '觉醒', '异教徒转化'))
spec = {'owner': 'laimiu', 'expected_mod_id': before['id'], 'expected_metadata': metadata,
        'mod': mod, 'version': '0.27.4', 'package_filename': filename, 'sha256': sha256, 'notes': notes}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / filename)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
print(json.dumps({'prepared': True, 'version': spec['version'], 'sha256': sha256, 'size': package.stat().st_size}))
