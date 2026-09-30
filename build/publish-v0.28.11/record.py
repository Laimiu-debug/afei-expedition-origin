from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.28.11' and confirmation['description_and_notes_confirmed']
download=confirmation['download_url']
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    assert record['version']=='0.28.11' and record['sha256']==published['sha256']
    record.update(published=True,website_release_id=published['release_id'],installed=False,
                  installation_pending_game_exit=True,public_download_byte_comparison=False,
                  scope='v0.28.11 published to BBMOD, metadata confirmed; installation awaits game exit and in-game testing remains pending.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof_path=stage/'contract-type-proof.json'
proof=json.loads(proof_path.read_text(encoding='utf-8'))
proof.update(published=True,website_release_id=published['release_id'],installed=False,
             installation_pending_game_exit=True,prior_installed_version='0.28.5',
             public_archive_downloaded=False,public_download_byte_comparison=False)
proof_path.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.11 网站发布记录

2026-09-30香港时间15:09发布至BBMOD。修复委托记录种类一直为0：记录原版契约引用转发的真实类型，再按类型去重累计；有旧履约记录却缺失种类时明确提示。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.11.zip`，内部版本61，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

124份脚本、33,484条离线断言、原版资源路径与JavaScript检查通过。契约收款及完成回归73条，包括本机原版WeakTableRef和契约getType：旧版失败已复现，新版覆盖结算前读类型、同类去重、不同类型累计、原版与阿飞送信排除、重复完成与加载不重复累计、空类型不覆盖已知记录。

旧11份未标注种类的履约计数在回归中保持原样；新完成一份不同契约后为12份、已记录1种，不虚构此前种类。完整包CRC、条目集合和源码字节核验通过。与本地v0.28.10包相比仅版本入口、类型读取、契约回调与委托摘要四个条目变化。保留此前觉醒文案精简、传奇握把和酒馆交互修复。

本机公网读取超时后，通过既有服务器访问网站源站的HTTPS目录API和详情页，均返回HTTP200，确认v0.28.11、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；契约类型统计及完整战役仍待实机复测。

证据：`build/contract-kinds-20260930/baseline.log`、`test-before.nut`、`contracts-before.nut`、`quests-before.nut`、`hooks-before.nut`；`build/publish-v0.28.11/contract-type-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`。
'''
(root/'docs/releases/publication-0.28.11.md').write_text(doc,encoding='utf-8')
release=root/'docs/releases/v0.28.11.md'
text=release.read_text(encoding='utf-8').replace('2026-09-30，内部版本61。','2026-09-30，已发布至BBMOD，内部版本61。')
text=text.replace('[本地完整主包]',f'124份脚本、33,484条离线断言和287个包文件校验通过。[发布记录](publication-0.28.11.md) · [官网下载]({download}) · [本地完整主包]')
release.write_text(text,encoding='utf-8')
readme=root/'README.md'
text=readme.read_text(encoding='utf-8')
intro=f'**v0.28.11 已发布至 BBMOD**：修复委托种类一直为0。后续完成并收款的非送信契约按实际类型去重累计，保留已有履约次数，旧记录缺失种类时明确提示。包含此前觉醒文案、传奇蓝光握把与酒馆交互修复。[官网下载]({download}) · [本地完整主包](<dist/mod_afeix_expedition v0.28.11.zip>) · [更新说明](docs/releases/v0.28.11.md) · [发布记录](docs/releases/publication-0.28.11.md)。33,484条离线断言通过，类型统计仍待实机复测。\n\n'
text=text.replace('**v0.28.10 已发布至 BBMOD**',intro+'**v0.28.10 已发布至 BBMOD**',1)
text=text.replace('当前本地工作区与BBMOD主包均为 **v0.28.10**','当前本地工作区与BBMOD主包均为 **v0.28.11**')
text=text.replace('觉醒文案及发布见[v0.28.10说明](docs/releases/v0.28.10.md)和[发布记录](docs/releases/publication-0.28.10.md)',
                  '契约类型统计及发布见[v0.28.11说明](docs/releases/v0.28.11.md)和[发布记录](docs/releases/publication-0.28.11.md)')
lines=text.splitlines()
for i,line in enumerate(lines):
    if line.startswith('公开下载：'):
        lines[i]=line.replace('v0.28.10','v0.28.11').replace('d3459cc4-6959-4a34-a4e3-2930c233d1b6',published['release_id']).replace('publication-0.28.10','publication-0.28.11')
readme.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'version':'0.28.11','published':True,'installed':False,'assertions':33484,'public_archive_downloaded':False}))
