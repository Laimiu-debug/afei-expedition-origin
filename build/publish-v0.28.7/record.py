from pathlib import Path
import json
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
package=json.loads((root/'build/gameplay-package.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.28.7' and confirmation['description_and_notes_confirmed']
proof=root/'build/tavern-treatment-20260930'
proof.mkdir(exist_ok=True)
for source,target in [('gameplay-validation.json','validation.json'),('gameplay-package.json','package.json')]:
    shutil.copy2(root/'build'/source,proof/target)
report={'version':'0.28.7','internal_version':57,'tavern_only':True,
        'world_map_camping_other_town_modules_denied':True,'native_visible_tavern_module_required':True,
        'stale_tavern_token_cannot_enable_purchase':True,'manual_F8_inside_tavern_supported':True,
        'location_rechecked_before_payment':True,'leaving_tavern_keeps_money_and_attributes':True,
        'tavern_service_entry':True,'tavern_visitors_per_page':3,'max_native_buttons':6,
        'attribute_click_buys_one_point_for_100':True,'receipt_placement':'Above page content',
        'tests':len(validation['tests']),'gameplay_assertions':sum(row['assertions'] for row in validation['tests']),
        'targeted_tests':[{key:row[key] for key in ('file','assertions')} for row in validation['tests'] if row['file'] in ('tests/gameplay/test_attribute_treatment.nut','tests/gameplay/test_ledger.nut')],
        'scripts_compiled':len(validation['scripts']),'package':package['package'],'sha256':package['sha256'],
        'entries':len(package['entries']),'crc_passed':package['crc_passed'],'source_bytes_match':package['source_bytes_match'],
        'installed':False,'installation_pending_game_exit':True,
        'prior_installed_package':'F:/SteamLibrary/steamapps/common/Battle Brothers/data/mod_afeix_expedition v0.28.5.zip',
        'published':True,'website_release_id':published['release_id'],'website_detail_url':published['detail_url'],
        'website_metadata_confirmed':True,'public_archive_downloaded':False,'public_download_byte_comparison':False,
        'pushed':False,'in_game_tested':False}
assert len(report['targeted_tests'])==2
(proof/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    record.update({'published':True,'installed':False,'installation_pending_game_exit':True,
                   'website_release_id':published['release_id'],'public_download_byte_comparison':False,
                   'scope':'v0.28.7 published to BBMOD, metadata confirmed; installation awaits game exit and in-game testing remains pending.'})
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.7 网站发布记录

2026-09-30 香港时间13:46发布至BBMOD。飞李不可改为仅限酒馆，新增酒馆黑旗直接入口；野外、扎营、城镇其他界面及离开酒馆后的旧按钮不可加点。每次100克朗加1点，保留同页连续操作、结果置顶、Esc退出与接战卡死修复。

- [官网条目]({published['detail_url']})
- [官网下载](https://bbmod.site/files/{published['release_id']}/download/)
- 主包：`mod_afeix_expedition v0.28.7.zip`，内部版本57，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 数据库备份：`{published['backup']}`。

124份脚本、33,422条离线断言、资源路径和JavaScript检查通过。本地包已核验ZIP条目集合、CRC及全部源码字节。服务器使用既有Mod/Release表单和发布服务发布，保留既有版本与其他条目。

公开目录API和详情页确认v0.28.7、说明及新下载链接，均返回HTTP200。按用户要求未下载公开ZIP进行本地包一致性检验；本记录不声明公开ZIP字节核验结果。

本机游戏仍在运行v0.28.5，未覆盖运行中的包；v0.28.7安装待退出游戏。酒馆交互和完整战役仍未实机复测。离线验证、发布和本机安装分别记录。

证据：`build/tavern-treatment-20260930/report.json`、`build/publish-v0.28.7/website-release.json`、`website-published.json`、`website-metadata-confirmation.json`。
'''
(root/'docs/releases/publication-0.28.7.md').write_text(doc,encoding='utf-8')
print(json.dumps({'version':report['version'],'assertions':report['gameplay_assertions'],'published':True,'installed':False,'public_archive_downloaded':False}))
