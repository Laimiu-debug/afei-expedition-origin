from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import shutil

stage = Path(__file__).resolve().parent
root = stage.parents[1]
report = json.loads((root/'dlc/afei-bundle/report.json').read_text(encoding='utf-8'))
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
main = next(m for m in before['mods'] if m['install_name']=='mod_afeix_expedition.zip')
voice = next(m for m in before['mods'] if m['install_name']=='mod_afeix_dlc_afei_voice.zip')
assert voice['id']=='f8909336-43fa-4415-82f6-b6224a8e7340' and voice['owner']==main['owner']
package = root/report['package']
assert hashlib.sha256(package.read_bytes()).hexdigest()==report['package_sha256']
assert report['component_bytes_unchanged'] and report['crc_passed']
assert [t['assertions'] for t in report['validation']['combined_tests']]==[6661,6661]
with ZipFile(package) as archive:
    assert archive.testzip() is None and len(archive.namelist())==22
    assert set(archive.namelist())==set(report['entry_sha256'])
    assert all(hashlib.sha256(archive.read(n)).hexdigest()==v for n,v in report['entry_sha256'].items())
    for name,version in [('skins',2),('voice',3)]:
        preload=archive.read('scripts/!mods_preload/mod_afeix_dlc_afei_'+name+'.nut').decode('utf-8')
        assert '::mods_registerMod("mod_afeix_dlc_afei_'+name+'", '+str(version)+',' in preload
skins = [m for m in before['mods'] if m['install_name']=='mod_afeix_dlc_afei_skins.zip']
old = [voice]+skins
assert all(m['owner']==main['owner'] and not m['blocked'] for m in old)
mod = {
 'title':'阿飞远征团 DLC：阿飞衣橱与哇哇叫',
 'summary':'六套阿飞外观、两张战败CG和五段音量增强版受伤原声，一个ZIP同时安装。替换原独立皮肤和语音包；需搭配阿飞远征团主包。',
 'description':'''阿飞换上新造型，挨打时熟悉的“哇”也一起带来。

本整合DLC把阿飞衣橱0.1.1与阿飞哇哇叫0.1.2放进同一个可直接安装的ZIP，包含六套外观、两张战败CG和五段音量增强版实况原声。

六套外观：黑旗团长、荒野行者、赤巾老兵、裸上身、胡雪儿、蛤蟆形态，另可随时恢复原有阿飞。在阿飞远征团战役中打开F8→战团事务→阿飞外观，点击立即换装并留在当前页，免费、不再确认。人物栏、战斗胸像和行走时的地图头像随选择切换；扎营仍显示原版帐篷。护甲、头盔和武器照常覆盖胸像，可使用战团事务里的隐藏头盔按钮。

在阿飞外观页选择“欣赏阿飞战败CG”，可前后切换两张图并返回原来的皮肤页，Esc沿用主包安全关闭。CG仅供手动查看，不自动触发战败剧情，也不改变战斗结算、死亡或奖励。

阿飞受伤时随机播放五段实况原声，相邻两次避开同一段。沿用哇哇叫0.1.2的音量增强效果，比0.1.0提高约6.6～7.5dB，保留原声音高、语速和时长，游戏音效设置继续生效。六套皮肤下均可播放；改名与转职仍按阿飞身份识别。其他角色、护甲受击与阵亡声音沿用原有处理。

安装前完全退出游戏，移走data目录中所有旧的阿飞哇哇叫、阿飞衣橱和旧整合包ZIP，再把本整合ZIP整包放入data，不要解压。主包与整合包各只保留一个版本。整合包不能与两个原独立包并装，也不能代替主包。

需要阿飞远征团v0.28.12（内部版本62）或更新版，以及Legacy Modding Script Hooks（mod_hooks）；当前已对主包v0.28.13做离线组合回归。请按新开战役验收。原皮肤存档选择旗标保留，无需转换；实际旧档、卸载读档与未知第三方Mod组合仍待实机确认。

六份运行脚本编译、6,617条组件离线断言通过；皮肤先加载与语音先加载分别通过6,661条组合断言，包含复用的主包回归，不相加作为独立用例总数。验证覆盖重复初始化、全部外观下的叫声、存读档、其他角色及起源、菜单与双CG；组件回归另覆盖装备、尸体、复活、断头和资源回退。22个包文件的完整集合、CRC及组件资源逐字节一致性通过。尚未实机战斗、音量与完整战役验收。

主包页面：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/''',
 'category':'装备与外观',
 'source_url':main['metadata']['source_url'],
 'original_author':'Laimiu（DLC制作）；阿飞（原声）',
 'license':'作者授权在BBMOD分发DLC脚本与安装包；原声与参考美术的权利归各原权利人。',
 'game_version':main['metadata']['game_version'],
 'dlc':main['metadata']['dlc'],
 'save_impact':'unknown','seed_impact':'unknown',
 'compatibility_notes':'''需要阿飞远征团主包v0.28.12（内部版本62）或更新版，以及Legacy Modding Script Hooks（mod_hooks），推荐当前主包v0.28.13并新开战役。

完全退出游戏，移走mod_afeix_dlc_afei_voice*.zip、mod_afeix_dlc_afei_skins*.zip及旧的mod_afeix_dlc_afei_bundle*.zip。再将mod_afeix_dlc_afei_bundle.zip整包放入data，不解压；主包和整合包各保留一个版本。整合包不能与任何原独立皮肤或语音包并装，避免组件重复加载。

保留两个组件原有Mod ID和阿飞皮肤选择旗标，选择随战役保存；没有新建存档类，不改变角色属性、装备、费用与转职条件。原有阿飞在主包0.28.13中沿用主包的发型分层，六套独立皮肤保留衣橱的完整贴图。换装、实机音量、旧档、尸体及复活、卸载读档和未知第三方Mod组合仍需实机验收。''',
 'mod_ids':'mod_afeix_dlc_afei_skins\nmod_afeix_dlc_afei_voice',
 'requires':'mod_afeix_expedition\nmod_hooks','conflicts':'',
 'install_name':'mod_afeix_dlc_afei_bundle.zip'}
spec = dict(owner=main['owner'],mod=mod,version=report['version'],package_filename=package.name,
 sha256=report['package_sha256'],expected_absent=True,
 notes='首版整合DLC：合并阿飞衣橱0.1.1与阿飞哇哇叫0.1.2，一个ZIP包含六套皮肤、双CG和五段增强版受伤原声。保留皮肤选择与组件身份。对主包0.28.13复测通过；6份运行脚本、6,617条组件断言、两种顺序各6,661条组合断言及22个包文件核验通过。请移走原独立语音和皮肤包，再安装整合包，不解压；新开战役验收。尚未实机验收。',
 verification=dict(entries=22,source_sha256=report['entry_sha256'],component_assertions=6617,
                   combined_assertions=[6661,6661],in_game_tested=False),
 withdraw_works=old,absent_old_install_names=[] if skins else ['mod_afeix_dlc_afei_skins.zip'])
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
publisher = (root/'tools/publish_bbmod_release.py').read_text(encoding='utf-8')
publisher = publisher.replace('    form = ModForm(spec[\'mod\'], instance=existing)',
 '    assert not spec.get("expected_absent") or existing is None, "Unexpected existing bundle work"\n    form = ModForm(spec[\'mod\'], instance=existing)')
(stage/'publish_bbmod_release.py').write_text(publisher,encoding='utf-8')
controller = (root/'build/publish-dlc-afei-voice-v0.1.2/publish.py').read_text(encoding='utf-8')
controller = controller.replace('afeix-voice-012','afeix-bundle-010').replace('voice DLC 0.1.2','bundle DLC 0.1.0')
(stage/'publish.py').write_text(controller,encoding='utf-8')
print(json.dumps(dict(ready=True,sha256=spec['sha256'],bytes=package.stat().st_size,
    withdraw=[m['install_name'] for m in old],old_skin_never_published=not bool(skins)),ensure_ascii=False))
