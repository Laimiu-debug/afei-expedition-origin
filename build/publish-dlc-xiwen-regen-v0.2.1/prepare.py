"""Prepare the independent Xiwen/Regen DLC publication from verified artifacts."""
import hashlib
import json
import shutil
from pathlib import Path

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
assert before['matches'] == [], 'Refresh the existing DLC work instead of creating a duplicate'
main = before['main']['metadata']
main_url = 'https://bbmod.site/mods/' + before['main']['id'] + '/'
report = json.loads((root / 'dlc/xiwen-regen/report.json').read_text(encoding='utf-8'))
assert sum(t['assertions'] for t in report['validation']['tests']) == 5587
assert report['base_package_sha256'] == '27d9bee4f7998eaac79d341e92ba436f6373927a1c2b5ab988af50a76dca9e83'
mod = {key: main[key] for key in ('category', 'source_url', 'license', 'original_author', 'game_version', 'dlc')}
mod.update({
    'title': '阿飞远征团 DLC：希文与里根',
    'install_name': 'mod_afeix_dlc_xiwen_regen.zip',
    'summary': '阿飞远征团的独立可选扩展：里根开局随阿飞同行，希文第 35 日起满足条件后可招募。需同时安装主包，不能单独运行；请新开战役。',
    'mod_ids': 'mod_afeix_dlc_xiwen_regen',
    'requires': 'mod_afeix_expedition\nmod_hooks',
    'conflicts': '', 'save_impact': 'yes', 'seed_impact': 'unknown',
    'description': '''希文与里根是“阿飞远征团”的独立可选扩展。本页面只提供 DLC，必须与主包一起安装。推荐使用当前主包 v0.27.5 或更新版。

里根是阿飞的狗。新建“阿飞远征团”战役时，它会直接放入阿飞的饰品栏，不需要购买或招募，也不占佣兵名额、不另加工资。战斗中由阿飞使用释放战犬技能，将它放到相邻空地，随后由原版 AI 行动。放出后饰品显示“里根的项圈”；里根存活时战后返回。

里根沿用原版战犬外观、数值和生死规则。出售、遗失或阵亡后不会重新配发；旧战役不会自动补发，请新开战役。若其他 Mod 已占用阿飞开局饰品栏，本扩展不会顶掉该物品。

希文是独立可招募角色。第 35 日起，同时满足参战历史最高值至少 14、非送信付费履约至少 5、不同合格城镇至少 6、历史最高等级至少 5 后，进入主包现有招募队列。沿用三个候选位与轮换规则，第 35 日是最早入池日，不保证当天立即出现。补级上限 2 级，基础报价 590 克朗，城镇倍率会影响最终报价。

希文穿轻装、持短剑与小圆盾，携带“希文的圆圆化妆镜”。本体决心较低，镜子仅由希文装备时增加 20 点决心。固定特质为聪慧、健步如飞；7 级从《识隙札记》《同行守则》《长路笔记》中选择一项专属方向，11 级精通已选方向，不占普通专长点。包含独立头像、人物背景、个人成长与退隐／阵亡文本。

DLC 只有八个新增文件，不覆盖主包文件，也不能代替主包。配合 v0.27.5 主包完成 5,587 项离线相关检查，包含原版背景、招募、里根装备与释放、存取和战后返回规则；ZIP CRC 与源码一致性检查通过。尚未完成实机验收。

主包页面：''' + main_url,
    'compatibility_notes': '''安装前完全退出游戏，把本 DLC 与“阿飞远征团”主包一起放入游戏 data 文件夹，保持 ZIP 原样，不要解压。网站下载名为 mod_afeix_dlc_xiwen_regen.zip，后缀为小写 .zip。主包与 DLC 各只保留一个版本，两个包需要同时存在。

推荐搭配主包 v0.27.5 或更新版，并安装主包要求的 Legacy Modding Script Hooks（mod_hooks）和中文字体／汉化环境。本扩展不能单独运行。

重新启动游戏，新建“阿飞远征团”战役。起源说明会出现“里根同行”，开局查看阿飞饰品栏，战斗中由阿飞手动释放里根。旧战役不补发宠物；失去或阵亡后也不会重新生成。

希文从第 35 日起满足全部门槛后进入城镇招募队列。存档需要持续保留主包和本 DLC。不保证与改动开局饰品、起源或人物图层的其他 Mod 兼容。

本次离线验证使用主包 v0.27.5，尚未实机验收。

主包下载页：''' + main_url,
})
notes = '''希文与里根 DLC 0.2.1 首次公开发布：

- 里根开局装备在阿飞饰品栏，战斗中可释放，不占佣兵名额、不另加工资；出售、失去或阵亡后不重复配发。
- 希文第 35 日起满足战斗、履约、城镇与等级门槛后进入主包招募队列，补级上限 2 级、基础报价 590 克朗。
- 希文携带圆圆化妆镜，本人装备时决心 +20；7 级专属技能书三选一、11 级精通，并包含头像、背景、成长与结局文本。

本页面仅提供独立 DLC，必须同时安装阿飞远征团主包。请使用当前主包 v0.27.5 或更新版，退出游戏后将两个 .zip 放入 data，不解压，并新开战役。

与主包 v0.27.5 配合通过 5,587 项离线相关检查，八个包内文件的 CRC 和源码一致性通过；尚未实机验收。'''
filename = 'mod_afeix_dlc_xiwen_regen v0.2.1.zip'
package = root / 'dlc/xiwen-regen/dist' / filename
sha = hashlib.sha256(package.read_bytes()).hexdigest()
assert sha == report['package_sha256']
spec = {'owner': 'laimiu', 'mod': mod, 'version': '0.2.1', 'package_filename': filename,
        'sha256': sha, 'notes': notes}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
shutil.copy2(package, stage / filename)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
print(json.dumps({'prepared': True, 'filename': filename, 'sha256': sha, 'size': package.stat().st_size}))
