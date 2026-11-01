from pathlib import Path
import json, hashlib, shutil
stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
assert before['releases'][0]['version']=='0.29.0-preview.6'
mod=dict(before['metadata'])
mod['install_name']='mod_afeix_expedition.zip'
mod['rights']=True
for key in ['mod_ids','requires','incompatible']:
    if isinstance(mod.get(key),list): mod[key]=','.join(mod[key])
mod['summary']='v0.29.0-preview.8 保留斗鱼大体型，血条抬到头顶；梦境阿飞补电子烟，状态小图标统一原版圆框，自制主动技能增加动画、音效与施放日志。'
intro='v0.29.0-preview.8 战斗显示与反馈修复：斗鱼保持原来的大体型，头顶血量与两条护甲条独立抬高，状态圆图标位于血条上方；跟随实际数值、镜头与移动，支持原版血条显示开关和鼠标悬停。尸体也保留原尺寸。梦境阿飞装备真实电子烟并获得“抽一口”。自制临时状态改用原版小圆框；成员主动技能和晋升指令按类别补充施放浮标、音效和成功日志，电子烟与礼炮增加有限粒子反馈。'
mod['description']=intro+'\n\n斗鱼血条已在独立战斗场景定向检查：原尺寸、满血与半血、镜头放大、血条开关及悬停显示正常。成员技能和电子烟的配置及原生资源通过离线检查，所有技能逐项实战和声音试听尚未完整验收。\n\n'+mod['description'].replace('148份Squirrel脚本、45,956条离线行为断言','150份Squirrel脚本、46,218条离线行为断言').replace('326个包文件','328个包文件')
mod['compatibility_notes']='v0.29.0-preview.8为完整主包，累计preview.6的梦境与斗鱼修复。体验完整梦境开局请新开战役。\n\n'+mod['compatibility_notes']
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],'mod':mod,'version':'0.29.0-preview.8',
 'notes':'保留斗鱼原来的大体型与尸体尺寸，将血量、两条护甲及状态小图标独立抬到头顶；跟随实际数值，支持血条开关和悬停显示。梦境阿飞补电子烟；自制状态统一原版小圆框；44项成员主动技能、晋升指令补充动画、分类音效和成功日志，电子烟与斗鱼礼炮增加有限粒子反馈。完整主包，150份脚本、46,218条离线断言和328个文件校验通过。体验完整新开局请新开战役。声音与所有技能逐项实战试听尚未完整验收。',
 'package_filename':'mod_afeix_expedition v0.29.0-preview.8.zip','verification':{'prior_version':'0.29.0-preview.6','source_root':'src','entries':328,'internal_version':72,'behavior_assertions':46218}}
package=root/'dist'/spec['package_filename']
spec['sha256']=hashlib.sha256(package.read_bytes()).hexdigest()
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
old=root/'build/publish-v0.29.0-preview.6'
for name in ['publish.py','verify_delivery.py','verify_backup.py']:
    text=(old/name).read_text(encoding='utf-8').replace('preview6','preview8').replace('0.29.0-preview.6','0.29.0-preview.8')
    if name=='verify_backup.py':text=text.replace("'0.29.0-preview.3'","'0.29.0-preview.6'")
    (stage/name).write_text(text,encoding='utf-8')
print('Reviewed publication stage:',spec['version'],spec['sha256'])
