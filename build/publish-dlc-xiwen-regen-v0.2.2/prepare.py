"""Prepare the reviewed DLC startup fix against the live website snapshot."""
from pathlib import Path
import hashlib
import json
import shutil
from zipfile import ZipFile

stage = Path(__file__).resolve().parent
root = stage.parents[1]
before = json.loads((stage / 'website-before.json').read_text(encoding='utf-8'))
report = json.loads((root / 'dlc/xiwen-regen/report.json').read_text(encoding='utf-8'))
checks = sum(test['assertions'] for test in report['validation']['tests'])
assert checks == 5612 and report['version'] == '0.2.2-dlc'
mod = dict(before['dlc']['metadata'])
mod['install_name'] = 'mod_afeix_dlc_xiwen_regen.zip'
for key in ('uploader', 'author'):
    mod.pop(key, None)
for key in ('mod_ids', 'requires', 'conflicts'):
    mod[key] = '\n'.join(mod[key])
mod['summary'] = '独立可选扩展。0.2.2 修复电子烟占饰品栏导致里根开局漏发：保留电子烟，里根进入队伍仓库。希文第35日起满足条件可招募，需主包并新开战役。'
mod['description'] = '''希文与里根是“阿飞远征团”的独立可选扩展，必须与主包一起安装，推荐主包 v0.27.5 或更新版。

0.2.2 修复里根开局漏发：主包会先给阿飞装备电子烟，旧版 DLC 发现饰品栏被占用后直接放弃发放。现在保留已装备的电子烟等饰品，把里根放入队伍仓库；如果阿飞饰品栏为空，则直接装备里根。

新建“阿飞远征团”战役后，打开队伍仓库即可找到里根。战前将里根装备到任一队员的饰品栏，战斗中使用释放战犬技能，放到相邻空地，再由原版 AI 行动。可以让大谋或抹茶携带里根，同时让阿飞继续使用电子烟。单个队员的饰品栏仍只能装备一件物品。

里根不需要购买或招募，不占佣兵名额，也不另加工资。沿用原版战犬外观、数值和生死规则，放出后饰品显示“里根的项圈”，存活时战后返回。出售、遗失或阵亡后不会重新配发；旧战役不会自动补发，请新开战役。

希文第35日起，同时满足参战历史最高值至少14、非送信付费履约至少5、不同合格城镇至少6、历史最高等级至少5后，进入主包三个候选位的招募队列；最早第35日入池，不保证当天轮到。补级上限2级、基础报价590克朗，城镇倍率影响最终报价。

希文使用短剑、小圆盾和轻装，携带仅本人装备时决心+20的圆圆化妆镜。固定特质为聪慧、健步如飞；7级从《识隙札记》《同行守则》《长路笔记》中三选一，11级精通，不占普通专长点。保留头像、背景、成长与结局内容。

DLC仍为八个独立新增文件，不覆盖主包。配合主包v0.27.5通过5,612项离线相关检查，新增主包真实开局方法、电子烟发放与DLC钩子的联动回归。覆盖饰品占位、仓库发放、空饰品位装备、发放失败与重复配发保护；原版战犬释放和战后返回回归通过。ZIP与源码逐文件一致。尚未实机验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
mod['compatibility_notes'] = '''完全退出游戏后更新本DLC，再重新启动游戏并新建“阿飞远征团”战役。主包继续使用v0.27.5或更新版，并安装Legacy Modding Script Hooks（mod_hooks）及所需中文字体／汉化环境。

主包和DLC各保留一个版本，两份.zip同时放入data，不要解压。下载名为mod_afeix_dlc_xiwen_regen.zip，后缀小写。本DLC不能替代主包。

开局阿飞通常已经装备电子烟，因此里根在队伍仓库。战前把里根装备给大谋、抹茶或其他队员，即可在战斗中释放；阿飞可继续使用电子烟。若由阿飞携带里根，需要替换他的电子烟，两者不能同时占用同一个饰品位。

每次更新按新战役验收，旧战役不自动补发里根；里根遗失、售出或阵亡后也不会补发。希文的35日起招募门槛及数值不变。存档需持续保留主包和DLC。尚未实机验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
notes = '''DLC 0.2.2：修复电子烟占用阿飞饰品栏导致里根开局漏发。

- 保留电子烟等已装备物品，里根改发到队伍仓库；阿飞饰品栏为空时仍直接装备。
- 起源介绍和里根物品说明写明领取位置、装备与释放方法。可由其他队员携带里根，让阿飞继续用电子烟。
- 保留一次性发放、死亡／售出／遗失后不补发。希文数值、招募、技能与主包均不变。
- 新增主包开局、电子烟和DLC的联动回归；共5,612项离线相关检查通过，六个脚本编译及八个包文件校验通过，尚未实机验收。

退出游戏后更新DLC并新开战役，在队伍仓库查找里根。主包使用v0.27.5或更新版。'''
filename = 'mod_afeix_dlc_xiwen_regen v0.2.2.zip'
package = root / 'dlc/xiwen-regen/dist' / filename
sha = hashlib.sha256(package.read_bytes()).hexdigest()
assert sha == report['package_sha256']
with ZipFile(package) as new, ZipFile(package.with_name('mod_afeix_dlc_xiwen_regen v0.2.1.zip')) as old:
    assert new.namelist() == old.namelist() and new.testzip() is None
    changed = [name for name in new.namelist() if new.read(name) != old.read(name)]
    assert len(changed) == 4
spec = {'owner': 'laimiu', 'expected_mod_id': before['dlc']['id'],
        'expected_metadata': before['dlc']['metadata'], 'mod': mod, 'version': '0.2.2',
        'package_filename': filename, 'sha256': sha, 'notes': notes}
(stage / 'website-release.json').write_text(json.dumps(spec, ensure_ascii=False, indent=2)+'\n',encoding='utf-8')
shutil.copy2(package, stage / filename)
shutil.copy2(root / 'tools/publish_bbmod_release.py', stage / 'publish_bbmod_release.py')
print(json.dumps({'prepared': True, 'size': package.stat().st_size, 'sha256': sha, 'changed': changed}))
