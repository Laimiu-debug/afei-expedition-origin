"""Prepare the renamed companion and revised flavor text for publication."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import re
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
report=json.loads((root/'dlc/xiwen-regen/report.json').read_text(encoding='utf-8'))
assert report['version']=='0.2.3-dlc'
assert sum(t['assertions'] for t in report['validation']['tests'])==5612
mod=dict(before['dlc']['metadata'])
mod['install_name']='mod_afeix_dlc_xiwen_regen.zip'
for key in ('uploader','author'): mod.pop(key,None)
for key in ('mod_ids','requires','conflicts'): mod[key]='\n'.join(mod[key])
mod['title']='阿飞远征团 DLC：希文与里根儿'
mod['summary']='战犬里根儿随黑旗启程，希文第35日起满足条件后可招募。独立可选扩展，需与阿飞远征团主包一起安装，并新开战役。'
item_source=(root/'dlc/xiwen-regen/src/scripts/items/accessory/afeix_regen_item.nut').read_text(encoding='utf-8')
flavor=re.search(r'this.m.Description = "([^"]+)";',item_source).group(1)
mod['description']='''希文与里根儿是“阿飞远征团”的独立可选扩展，必须与主包一起安装，推荐主包v0.27.5或更新版。

【战犬里根儿】
'''+flavor+'''

新建“阿飞远征团”战役后，在队伍仓库查看里根儿。战前给任一队员装备到饰品栏，战斗中使用释放战犬技能，将他放到相邻空地，再由原版AI行动。放出后饰品显示“里根儿的项圈”，存活时战后返回。

里根儿不需要购买或招募，不占佣兵名额，也不另加工资。沿用原版战犬外观、数值和生死规则；出售、遗失或阵亡后不会重新配发。请新开战役，旧战役不自动补发。

【希文】
第35日起，同时满足参战历史最高值至少14、非送信付费履约至少5、不同合格城镇至少6、历史最高等级至少5后，进入主包三个候选位的招募队列。第35日为最早入池时间，不保证当天轮到；补级上限2级、基础报价590克朗，最终报价受城镇倍率影响。

希文持短剑与小圆盾、穿轻装，携带仅本人装备时决心+20的圆圆化妆镜。固定特质为聪慧、健步如飞；7级从《识隙札记》《同行守则》《长路笔记》中三选一，11级精通，不占普通专长点。包含独立头像、背景、成长及结局文本。

0.2.3统一更新战犬、项圈和相关剧情中的名字，并重写同行与物品介绍。通过5,612项离线相关检查、六个脚本编译及八个包文件校验，尚未实机验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
mod['compatibility_notes']='''完全退出游戏后更新DLC，重新启动并新建“阿飞远征团”战役。主包使用v0.27.5或更新版，并安装Legacy Modding Script Hooks（mod_hooks）与所需中文字体／汉化环境。

主包和DLC各保留一个版本，两份.zip同时放入data，不要解压。DLC下载名为mod_afeix_dlc_xiwen_regen.zip，后缀小写；本扩展不能代替主包。

开局在队伍仓库查看里根儿，战前装备到一名队员的饰品栏，战斗中即可释放。里根儿售出、遗失或阵亡后不补发。每次更新按新战役验收，旧战役不自动配发战犬。

存档需要持续保留主包与本DLC。尚未实机验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
notes='''DLC 0.2.3：战犬里根儿。

- 统一更新物品、战场实体、项圈、起源介绍与希文剧情中的称呼。
- 重写战犬及项圈介绍，加入这段回忆：“他很怀念在环世界老动物园中与飞碟一起度过的日子，一步一步，不忘来时路。”
- 原有开局发放、战犬数值、释放与战后返回规则保持不变。

5,612项离线相关检查、六个脚本编译和八个包文件校验通过，尚未实机验收。退出游戏后更新DLC并新开战役，主包使用v0.27.5或更新版。'''
assert all('电子烟' not in mod[k] and '冲突' not in mod[k] and '狗' not in mod[k]
           for k in ('title','summary','description','compatibility_notes'))
filename='mod_afeix_dlc_xiwen_regen v0.2.3.zip'
package=root/'dlc/xiwen-regen/dist'/filename
sha=hashlib.sha256(package.read_bytes()).hexdigest()
assert sha==report['package_sha256']
with ZipFile(package) as new, ZipFile(package.with_name('mod_afeix_dlc_xiwen_regen v0.2.2.zip')) as old:
    assert new.namelist()==old.namelist() and new.testzip() is None
    changed=[name for name in new.namelist() if new.read(name)!=old.read(name)]
    assert len(changed)==4
    assert new.read('scripts/mods/afeix_dlc_xiwen_regen/pet.nut')==old.read('scripts/mods/afeix_dlc_xiwen_regen/pet.nut')
spec={'owner':'laimiu','expected_mod_id':before['dlc']['id'],'expected_metadata':before['dlc']['metadata'],
      'mod':mod,'version':'0.2.3','package_filename':filename,'sha256':sha,'notes':notes}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/filename)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
print(json.dumps({'prepared':True,'size':package.stat().st_size,'sha256':sha,'changed':changed}))
