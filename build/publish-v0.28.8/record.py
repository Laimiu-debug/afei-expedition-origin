from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import re
import shutil

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
package=json.loads((root/'build/gameplay-package.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.28.8' and confirmation['description_and_notes_confirmed']
with ZipFile(root/'dist/mod_afeix_expedition v0.28.7.zip') as old:
    assert old.read('scripts/mods/afeix/core.nut')==(root/'src/scripts/mods/afeix/core.nut').read_bytes()
proof=root/'build/night-tavern-20260930'
proof.mkdir(exist_ok=True)
shutil.copy2(root/'.cache/ledger-before-night-tavern.nut',proof/'ledger-before.nut')
test=(root/'.cache/test-night-tavern-before.nut').read_text(encoding='utf-8')
(proof/'test-before.nut').write_text(test.replace('.cache/ledger-before-night-tavern.nut','build/night-tavern-20260930/ledger-before.nut'),encoding='utf-8')
for source,destination in [('gameplay-validation.json','validation.json'),('gameplay-package.json','package.json')]:
    shutil.copy2(root/'build'/source,proof/destination)
log=Path('C:/Users/25647/OneDrive/Documents/Battle Brothers/log.html').read_bytes()
entries=[]
for row in re.split(r'<div class="row ',log.decode('utf-8',errors='replace'))[1:]:
    if 'Ledger blocked:' not in row:continue
    timestamp=re.search(r'<div class="time">([^<]+)',row)
    reason=re.search(r'Ledger blocked: ([^<]+)',row)
    entries.append({'time':timestamp[1] if timestamp else None,'reason':reason[1]})
log_proof={'log_sha256':hashlib.sha256(log).hexdigest(),'loaded_main_version':'0.28.5','loaded_internal_version':55,
           'ledger_rejections':entries,'specific_unsafe_town_subcondition_logged':False}
(proof/'game-log-evidence.json').write_text(json.dumps(log_proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
report={'version':'0.28.8','internal_version':58,'night_tavern_F8_fixed':True,
        'cause':'Entered-town UI opening incorrectly used the world-map canManage proximity/hostile-party gate.',
        'old_failure_reproduced':True,'old_failure':'FAIL native F8 opens entered tavern by day/night despite outside enemies',
        'town_screen_authoritative':True,'canManage_unchanged':True,'treatment_still_tavern_only':True,
        'character_loading_combat_event_animation_guards_preserved':True,'rejected_open_has_no_page_or_tavern_side_effects':True,
        'tests':len(validation['tests']),'behavior_assertions':sum(row['assertions'] for row in validation['tests']),
        'native_ui_assertions':188,'scripts_compiled':len(validation['scripts']),
        'package':package['package'],'entries':len(package['entries']),'sha256':package['sha256'],
        'crc_passed':True,'source_bytes_match':True,'published':True,'website_metadata_confirmed':True,
        'website_release_id':published['release_id'],'installed':False,'installation_pending_game_exit':True,
        'prior_installed_version':'0.28.5','in_game_tested':False,'public_archive_downloaded':False,
        'public_download_byte_comparison':False}
(proof/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    record.update(published=True,website_release_id=published['release_id'],installed=False,
                  installation_pending_game_exit=True,public_download_byte_comparison=False,
                  scope='v0.28.8 published to BBMOD, metadata confirmed; installation awaits game exit and in-game testing remains pending.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.8 网站发布记录

2026-09-30 香港时间14:19发布至BBMOD，修复夜间酒馆按F8打不开。已经进入友好城镇时使用当前城镇界面判断，城外敌情和地图位置不再拦截开界面。保留Esc返回酒馆、人物栏防重叠、加载／战斗／事件／动画拦截及飞李不可仅限酒馆的规则。

- [官网条目]({published['detail_url']})
- [官网下载](https://bbmod.site/files/{published['release_id']}/download/)
- 主包：`mod_afeix_expedition v0.28.8.zip`，内部版本58，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

124份脚本、33,464条离线断言、资源路径与JavaScript检查通过。旧代码的夜间酒馆附近有敌人场景已离线复现，修复后原版F8／Esc菜单栈188条断言通过；原有canManage代码与v0.28.7逐字节相同。包内CRC、条目集合和源码字节核验通过。

官网目录API和详情页确认v0.28.8、说明、更新记录和新下载链接，均返回HTTP200。按用户要求未下载公开ZIP进行本地包一致性检验。服务器使用既有表单和发布服务更新主包，保留其他版本及DLC条目。

本机日志确认当前运行主包v0.28.5（内部版本55），本轮未覆盖运行中的包。v0.28.8安装待退出游戏；夜间酒馆、战斗和完整战役仍待实机复测。

证据：`build/night-tavern-20260930/report.json`、`game-log-evidence.json`、`test-before.nut`、`ledger-before.nut`；`build/publish-v0.28.8/website-release.json`、`website-published.json`、`website-metadata-confirmation.json`。
'''
(root/'docs/releases/publication-0.28.8.md').write_text(doc,encoding='utf-8')
print(json.dumps({'version':report['version'],'assertions':report['behavior_assertions'],'published':True,'installed':False,'public_archive_downloaded':False}))
