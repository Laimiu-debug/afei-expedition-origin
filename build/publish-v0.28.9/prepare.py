"""Publish the legendary grip update; public archive downloads stay disabled."""
from pathlib import Path
from zipfile import ZipFile
from PIL import Image
from io import BytesIO
import hashlib
import json
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
before=json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous=json.loads((root/'build/publish-v0.28.8/website-release.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert (root/'VERSION').read_text().strip()=='0.28.9'
assert all(validation[k] for k in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
for row in validation['scripts']+validation['ui_scripts']:
    assert sha(root/row['path'])==row['sha256'],row['path']
package=root/'dist/mod_afeix_expedition v0.28.9.zip'
source={p.relative_to(root/'src').as_posix():p for p in (root/'src').rglob('*') if p.is_file()}
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist())==len(set(archive.namelist()))==len(source)==287
    assert set(archive.namelist())==set(source)
    assert all(archive.read(name)==p.read_bytes() for name,p in source.items())
with ZipFile(root/'dist/mod_afeix_expedition v0.28.8.zip') as old:
    changed=sorted(n for n,p in source.items() if old.read(n)!=p.read_bytes())
    icons=[folder+'/afeix_laoma_grip'+suffix+'.png'
           for folder in ('gfx/ui/items/weapons','gfx/items/weapons') for suffix in ('','_70x70')]
    assert set(changed)==set(icons+['scripts/!mods_preload/mod_afeix_expedition.nut','scripts/items/weapons/afeix_laoma_grip.nut'])
    for n in icons:
        prior=Image.open(BytesIO(old.read(n))).convert('RGBA')
        current=Image.open(source[n]).convert('RGBA')
        assert prior.size==current.size
        assert all(a==b for a,b in zip(prior.getdata(),current.getdata()) if a[3]==255),n
        assert any(a[3]==0 and b[3]>0 and b[:3]==(69,108,160) for a,b in zip(prior.getdata(),current.getdata())),n
        assert current.getpixel((0,0))[3]==0 and current.getpixel((current.width-1,current.height-1))[3]==0,n
assert before['id']==previous['expected_mod_id']
assert not any(r['version']=='0.28.9' for r in before['releases'])
mod={k:before['metadata'].get(k,v) for k,v in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
assertions=sum(r['assertions'] for r in validation['tests'])
count=f'{assertions:,}'
mod['summary']='v0.28.9 老马的垂直握把升级为传奇双手锤，背包、商店和装备栏显示蓝色底光；保留固定战斗数值、夜间酒馆F8、飞李不可仅限酒馆连续加点、Esc退出和接战卡死修复。请新开战役。'
intro=('v0.28.9：老马的垂直握把改为原版传奇品质，类别显示“传奇双手锤”，背包、商店和装备栏图标新增蓝色底光。'
       '保留马头造型、朝向及战斗持握图。固定84～120伤害、猛击70%／横扫60%穿甲、235%护甲效率、52破盾、'
       '单体追加削甲最多30；耐久100、负重-18、单体20疲劳、28,888克朗基础价值和友好商店5%自然补货沿用此前规则。'
       '原版红光对应冠名装备、蓝光对应传奇装备，底光显示在图标上；战斗中不新增光效。本版蓝光仍待实机复测。')
description=before['metadata']['description']
assert description.startswith('v0.28.8：')
mod['description']=intro+'\n\n'+description.replace('v0.28.8：','保留v0.28.8更新：',1).replace('33,464',count)
mod['compatibility_notes']+='\n\n老马的垂直握把为传奇品质，蓝色底光显示在物品图标上；固定属性和商店5%自然补货规则沿用此前设置。阿飞哇哇叫音量增强需要另行下载独立语音DLC0.1.2。退出游戏后移走旧主包，只保留一个新版主包ZIP，并按新建战役验收。'
notes=('老马的垂直握把升级为原版传奇品质，类别显示传奇双手锤，物品图标增加蓝色底光，保持武器原造型、朝向和持握图。'
       '沿用84～120伤害、猛击70%／横扫60%穿甲、235%护甲效率、52破盾、单体追加削甲最多30以及友好商店5%自然补货。'
       '包含夜间酒馆F8、飞李不可仅限酒馆连续加点、Esc退出和接战卡死修复。'
       +count+'条离线断言、124份脚本和287个包文件核验通过；传奇分类、读档与战斗数值原版回归38条通过，蓝光仍待实机复测。请新开战役。')
proof={'version':'0.28.9','prior_version':'0.28.8','changed_package_entries':changed,
       'native_quality':'Legendary','named_flag_removed':True,'blue_glow_rgb':[69,108,160],
       'opaque_weapon_pixels_preserved':True,'icon_sizes_preserved':True,
       'reviewed_source_and_equipped_atlas_unchanged':True,'combat_stats_unchanged':True,
       'behavior_assertions':assertions,'native_weapon_assertions':38,'in_game_tested':False}
(stage/'legendary-grip-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
spec={'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
      'mod':mod,'version':'0.28.9','notes':notes,'package_filename':package.name,'sha256':sha(package),
      'verification':{'source_root':'src','prior_version':'0.28.8','internal_version':59,'entries':287,
                      'behavior_assertions':assertions,'native_weapon_assertions':38,'public_download_byte_comparison':False}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher=(root/'build/publish-v0.28.8/publish.py').read_text(encoding='utf-8').replace('afeix-0288','afeix-0289').replace('0.28.8','0.28.9')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm=(root/'build/publish-v0.28.8/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.8','0.28.9').replace('33,464',count)
confirm=confirm.replace("'夜间', 'F8'", "'夜间', 'F8', '传奇双手锤', '蓝色底光'")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print('Prepared v0.28.9: '+count+' assertions, six package-entry changes, original weapon pixels preserved, no public ZIP download.')
