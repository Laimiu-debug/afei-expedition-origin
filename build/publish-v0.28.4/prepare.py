"""Verify preserved source/art, package the DLC, and prepare both BBMOD uploads."""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import hashlib
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from PIL import Image

stage = Path(__file__).resolve().parent
root = stage.parents[1]
dlc = root / 'dlc/xiwen-regen'
dlc_stage = root / 'build/publish-dlc-xiwen-regen-v0.2.5'
kit = root / '.cache/afei-art/bbros-modkit-v9/bin'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

def check_zip(package, source):
    files = {p.relative_to(source).as_posix():p for p in source.rglob('*') if p.is_file()}
    with ZipFile(package) as z:
        assert z.testzip() is None and len(z.namelist()) == len(files)
        assert set(z.namelist()) == set(files)
        assert all(z.read(name) == p.read_bytes() for name,p in files.items())
    return sorted(files)

assert (root/'VERSION').read_text().strip() == '0.28.4'
validation = json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
assert all(validation[k] for k in ('syntax_passed','behavior_tests_passed','native_resource_paths_passed'))
main_package = root/'dist/mod_afeix_expedition v0.28.4.zip'
main_entries = check_zip(main_package, root/'src')
main_assertions = sum(t['assertions'] for t in validation['tests'])
spec = importlib.util.spec_from_file_location('dlc_builder', dlc/'build.py')
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)
sys.path.insert(0, str(root/'tools'))
import build_portrait_art as portrait

with tempfile.TemporaryDirectory(prefix='release-0284-', dir=root/'.cache') as temp:
    scratch = Path(temp)
    dlc_validation = builder.verify(root, kit, Path('F:/SteamLibrary/steamapps/common/Battle Brothers'), scratch)
    entry = {'key':'xiwen','name':'希文','form':'default','brush':'afeix_p04_xiwen',
             'source':'dlc/xiwen-regen/art/sources/xiwen.png','source_kind':'generated_custom',
             'head_seam':[[0,102],[40,102],[54,114],[66,114],[75,114],[88,102],[114,102]],
             'neck_guard':[62,112]}
    portrait.ALLOWED_SOURCE_ROOTS = (dlc/'art/sources',)
    attrs, exported = portrait.export_portrait(entry, scratch/'expected-sprites')
    result = subprocess.run([str(kit/'bbrusher.exe'),'unpack','--gfxPath',str(dlc/'src'),
                             str(dlc/'src/brushes/afeix_dlc_xiwen_regen.brush'),str(scratch/'unpacked')],capture_output=True)
    assert result.returncode == 0, (result.stdout+result.stderr).decode(errors='replace')
    expected = {a['id']:a for a in attrs}
    actual = list(ET.parse(scratch/'unpacked/metadata.xml').getroot())
    assert len(actual) == len(expected) == 4
    sprites = []
    for element in actual:
        identity = element.get('id')
        packed_path = scratch/'unpacked'/element.get('img').replace('\\','/')
        with Image.open(packed_path) as packed, Image.open(dlc/'art/sprites'/f'{identity}.png') as original, Image.open(scratch/'expected-sprites'/f'{identity}.png') as generated:
            defaults = {'left':-packed.width/2,'right':packed.width/2,'top':-packed.height/2,'bottom':packed.height/2,
                        'width':packed.width,'height':packed.height,'offsetX':0,'offsetY':0}
            assert all(float(element.get(k,default)) == float(expected[identity].get(k,default)) for k,default in defaults.items()), identity
            assert packed.size == original.size == generated.size, identity
            assert packed.convert('RGBA').tobytes() == original.convert('RGBA').tobytes() == generated.convert('RGBA').tobytes(), identity
        sprites.append({'id':identity,'coordinates_identical':True,'pixels_identical':True})
    art = {'export':exported,'roundtrip':{'passed':True,'sprite_count':4,'sprites':sprites,
            'brush_sha256':sha(dlc/'src/brushes/afeix_dlc_xiwen_regen.brush'),
            'atlas_sha256':sha(dlc/'src/gfx/afeix_dlc_xiwen_regen.png'),
            'method':'Unpack existing shipped atlas; compare pixels and coordinates with current exports without modifying source.'},
           'corpse_injury_report':'dlc/xiwen-regen/art/corpse-injuries-v01/build/report.json',
           'corpse_injury_verified_by':'build/gameplay-validation.json'}

# The excluded dog's writing and implementation must retain their source bytes.
for name in ['scripts/items/accessory/afeix_regen_item.nut','scripts/mods/afeix_dlc_xiwen_regen/pet.nut','scripts/mods/afeix_dlc_xiwen_regen/hooks.nut']:
    old = subprocess.run(['git','show','HEAD:dlc/xiwen-regen/src/'+name],capture_output=True,check=True).stdout
    assert old.replace(b'\r\n',b'\n') == (dlc/'src'/name).read_bytes().replace(b'\r\n',b'\n'), name

files = sorted(p for p in (dlc/'src').rglob('*') if p.is_file())
assert all(p.suffix in {'.nut','.png','.brush'} for p in files)
dlc_package = dlc/'dist/mod_afeix_dlc_xiwen_regen v0.2.5.zip'
with ZipFile(dlc_package,'w',ZIP_DEFLATED) as z:
    for path in files:
        info = ZipInfo(path.relative_to(dlc/'src').as_posix(),(2026,9,30,0,0,0))
        info.compress_type = ZIP_DEFLATED
        z.writestr(info,path.read_bytes())
dlc_entries = check_zip(dlc_package, dlc/'src')
dlc_package.with_suffix('.sha256').write_text(f'{sha(dlc_package)}  {dlc_package.name}\n',encoding='utf-8')
dlc_assertions = sum(t['assertions'] for t in dlc_validation['tests'])
save(dlc/'report.json', {'version':'0.2.5-dlc','minimum_base':'0.26.2 / internal 36','recommended_base':'0.28.4 / internal 54',
    'base_preload_sha256':sha(root/'src/scripts/!mods_preload/mod_afeix_expedition.nut'),
    'base_package_sha256':sha(main_package),'package_sha256':sha(dlc_package),
    'entries':dlc_entries,'crc_and_source_match':True,'art':art,'validation':dlc_validation,
    'scripts':[{'path':p.relative_to(root).as_posix(),'sha256':sha(p)} for p in files if p.suffix=='.nut'],
    'regen_source_unchanged':True,'in_game_tested':False})

for destination, version, package, old_stage, assertions, entries, internal in [
    (stage,'0.28.4',main_package,'publish-v0.28.2',main_assertions,main_entries,54),
    (dlc_stage,'0.2.5',dlc_package,'publish-dlc-xiwen-regen-v0.2.4',dlc_assertions,dlc_entries,6)]:
    before = json.loads((destination/'website-before.json').read_text(encoding='utf-8'))
    previous = json.loads((root/'build'/old_stage/'website-release.json').read_text(encoding='utf-8'))
    mod = {key:before['metadata'].get(key,value) for key,value in previous['mod'].items()}
    for key in ('mod_ids','requires','conflicts'):
        if isinstance(mod[key],list): mod[key] = '\n'.join(mod[key])
    if destination == stage:
        mod['summary'] = 'v0.28.4 优化全员背景、相遇与成长文案，调整终局岗位平衡，新增“飞李不可”付费属性培养，修正颈部、尸体与受伤血迹。34 人起源，最多 12 人出战、40 人在册；请新开战役。'
        mod['description'] = f'''v0.28.4 累计更新：优化主包 34 名成员的介绍、背景、相遇、个人成长与阵亡纪念，并整理蓝队剧情。可选 DLC 0.2.5 同步希文文案；里根儿介绍保持原样。请新开战役。

终局岗位平衡覆盖主包 34 人与可选希文：保留每人的基础八维总和与总天赋星数，调整培养分配，区分盾卫、旗手、长柄与远程职责；六项被动精通强化各自岗位效果。旧档差额同步不等于完整存档迁移验收。

新增“飞李不可”：安全的世界地图按 F8 → 战团事务 → 飞李不可，选择在队角色与一项属性，每支付 100 克朗永久增加 1 点基础属性。八项属性均可选择，可重复参加；普通成员与 DLC 同行者也可使用。

小龟的玄武血脉觉醒增加冷却：觉醒后须再完成 5 场未觉醒的参战胜利才可再次触发。新增暂停战斗的属性说明弹窗，区分首次、第二次及后续觉醒文字，人物介绍统一使用“她”。

修正自定义人物颈部与倒地头部的衔接，受伤时显示原版身体、防具血迹和分档脸部伤痕，尸体保留生前伤痕。主包与希文分别使用各自图集；原版特殊死亡处理保留。离线美术校验通过，实际游戏显示仍待验收。

阿飞、王大谋、午夜抹抹茶带着黑旗上路。主包共 34 人，最多 40 人在册，每战自选 1～12 人。世界地图 F8 黑旗名册用于查看伙伴、委托、故事和战团事务；原版人物栏可调整装备与站位。33 名伙伴各有 7 级专属技能三选一、11 级自动精通，共 99 项技能选项；阿飞使用独立晋升路线。

保留此前招募轮换：刀一前十天分批开放，刀二与飞团整体提前六天。常规候选首次停留 4 日、重逢 2 日，新面孔优先并保护等待较久的回流成员。普通候选最多 3 位，每雇佣一人，该位置等待一个完整游戏日后补员；宋暖阳与小龟使用独立随机来客位置。希文使用相同的常规队列优先级。白天的非敌对普通村镇可招募，军事城堡与要塞不适用。

保留老马的垂直握把实际穿甲修复、五款蛤蟆旗帜、头盔外观开关、研习与名册操作修复、普通人物四派称号，以及此前网后断头与解网回调修复。

本页面提供主包；希文与里根儿为独立可选 DLC 0.2.5，需另行下载。公开开发试玩版，请按新建战役使用，不承诺旧存档迁移。本轮通过 {assertions:,} 条离线断言、124 份脚本检查，以及 {len(entries)} 个包文件的 CRC、完整文件集合和源码字节一致性校验。新增玩法与美术尚未实机战役验收；此前 v0.27.6 网后断头修复有独立战场实测记录，食尸鬼战斗闪退仍未确认修复。'''
        mod['compatibility_notes'] = '''请新开战役，不承诺旧存档迁移。安装前完全退出游戏，将整份 mod_afeix_expedition.zip 放入游戏 data 文件夹，不要解压；替换同名旧包，并将带其他版本号的本 Mod 旧包移出 data，一次只保留一个主包。

需要 Legacy Modding Script Hooks（mod_hooks）与中文字体／汉化环境。新建战役选择“阿飞远征团”。希文与里根儿为独立可选 DLC 0.2.5，使用时主包与 DLC 各保留一个版本。

在安全的世界地图按 F8 打开黑旗名册。研习、“飞李不可”、旗帜与头盔外观开关位于“战团事务”；人物界面不打开 F8 菜单。“飞李不可”每次花费 100 克朗，仅永久增加所选基础属性 1 点。

存档依赖本 MOD。不保证与 Legends、Reforged 或其他改动编队、人物图层的 MOD 兼容。保留 mod_fox_043 招募显示兼容。新增玩法与美术尚未实机战役验收，食尸鬼闪退尚未确认修复。'''
        notes = f'优化 34 名成员背景、相遇、成长和阵亡纪念，整理蓝队剧情；里根儿文案不变。累计终局岗位数值平衡、“飞李不可”（100 克朗永久增加所选基础属性 1 点）、小龟觉醒 5 场胜利冷却及说明弹窗，以及颈部、尸体和受伤血迹修正。保留此前招募轮换与修复。{assertions:,} 条离线断言、124 份脚本、{len(entries)} 个包文件校验通过；新增玩法及美术尚未实机验收，请新开战役。希文与里根儿另用可选 DLC 0.2.5。'
        source_root, prior_version = 'src', '0.28.2'
    else:
        # Preserve the entire existing dog's introduction and player instructions.
        dog = before['metadata']['description'].split('【战犬里根儿】',1)[1].split('【希文】',1)[0]
        mod['summary'] = 'DLC 0.2.5 优化希文介绍、背景、相遇、成长与结局，更新颈部及倒地伤痕美术；里根儿介绍保持原样。独立可选扩展，推荐主包 v0.28.4，并新开战役。'
        mod['description'] = f'''0.2.5：优化希文的介绍、背景、相遇、成长与结局文字，更新颈部衔接、倒地头部和伤痕图集。推荐搭配主包 v0.28.4，包含希文终局岗位培养调整。里根儿介绍与战犬机制保持原样。

本扩展必须与阿飞远征团主包同时安装，请新开战役。

【战犬里根儿】{dog}【希文】
三位队长还在城门边争路，希文已经看完告示，指住角落的日期：“桥昨天修好了。”沿途的桥梁、水源和守夜安排记在册上，浅蓝花饰与圆圆化妆镜也一并带着。

第 35 日起，同时满足参战历史最高值至少 14、非送信付费履约至少 5、不同合格城镇至少 6、历史最高等级至少 5 后，进入主包三个普通候选位的招募队列，使用相同优先级与轮换保护。第 35 日是最早入池时间，不保证当天轮到。补级上限 2 级，基础报价 590 克朗，最终报价受城镇倍率影响。

希文持短剑、小圆盾与轻装，携带仅本人装备时决心 +20 的圆圆化妆镜。固定特质为聪慧、健步如飞；7 级从《识隙札记》《同行守则》《长路笔记》中三选一，11 级精通，不占普通专长点。包含专属头像、背景、个人成长与结局；属性与培养由主包配置。

本轮配合主包 v0.28.4，通过 {assertions:,} 条相关离线断言、6 份 DLC 脚本编译、4 个头像画刷的像素与坐标核验，以及 {len(entries)} 个包文件的 CRC、完整文件集合和源码字节一致性校验。新增 3 种倒地伤痕头部的图集另由主包美术检查覆盖；原版素材不进入压缩包。离线断言包含主包相关回归，不能与主包断言数直接相加。DLC 宠物流程与本次美术尚未实机验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/'''
        mod['compatibility_notes'] = before['metadata']['compatibility_notes'].replace('v0.27.6或更新版','v0.28.4或更新版')
        notes = f'优化希文介绍、背景、相遇、成长和结局，修正颈部与倒地头部，增加三种倒地伤痕头部图集。里根儿介绍、开局仓库发放与原版战犬机制保持原样。推荐主包 v0.28.4，新开战役使用。{assertions:,} 条离线相关断言、6 份脚本、4 个头像画刷和 {len(entries)} 个包文件核验通过；宠物流程与美术尚未实机验收。'
        source_root, prior_version = 'dlc/xiwen-regen/src', '0.2.4'
    record = {'owner':before['owner'],'expected_mod_id':before['id'],'expected_metadata':before['metadata'],
              'mod':mod,'version':version,'notes':notes,'package_filename':package.name,'sha256':sha(package),
              'verification':{'source_root':source_root,'prior_version':prior_version,'internal_version':internal,
                              'entries':len(entries),'behavior_assertions':assertions}}
    assert not any(r['version']==version for r in before['releases'])
    save(destination/'website-release.json',record)
    shutil.copy2(package,destination/package.name)
    shutil.copy2(root/'tools/publish_bbmod_release.py',destination/'publish_bbmod_release.py')
    publish_script = (root/'build/publish-v0.28.2/publish.py').read_text(encoding='utf-8')
    prefix = 'afeix-0284' if destination == stage else 'afeix-dlc-025'
    publish_script = publish_script.replace('afeix-0282',prefix).replace('main 0.28.2', 'release '+version)
    (destination/'publish.py').write_text(publish_script,encoding='utf-8')
    print(f'Prepared {version}: {assertions:,} assertions, {len(entries)} files, SHA-256 {sha(package)}')
