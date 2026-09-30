from datetime import datetime
from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.28.10' and confirmation['description_and_notes_confirmed']
download=confirmation['download_url']
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    assert record['version']=='0.28.10' and record['sha256']==published['sha256']
    record.update(published=True,website_release_id=published['release_id'],installed=False,
                  installation_pending_game_exit=True,public_download_byte_comparison=False,
                  scope='v0.28.10 published to BBMOD, metadata confirmed; installation awaits game exit and in-game testing remains pending.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof_path=stage/'awakening-text-proof.json'
proof=json.loads(proof_path.read_text(encoding='utf-8'))
proof.update(published=True,website_release_id=published['release_id'],installed=False,
             installation_pending_game_exit=True,prior_installed_version='0.28.5',
             public_archive_downloaded=False,public_download_byte_comparison=False)
proof_path.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.10 网站发布记录

2026-09-30香港时间14:50发布至BBMOD。玄武血脉首次、第二次与后续觉醒弹窗删除属性变化介绍，保留对应剧情和五场未觉醒参战胜利的冷却说明；战斗日志同步精简。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.10.zip`，内部版本60，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

124份脚本、33,468条离线断言、原版资源路径与JavaScript检查通过。小龟觉醒回归58条确认首次及重复弹窗保留冷却说明、删除属性介绍，同时覆盖实际强化、战后恢复、五场有效参战胜利、待命／撤退排除和弹窗暂停恢复。完整包CRC、条目集合和源码字节核验通过。

与本地v0.28.9包对比，仅版本入口与小龟觉醒文案两个条目变化。首次、第二次及后续轮换剧情逐字相同；实际觉醒强化、冷却计数、存档与弹窗暂停代码在排除战斗日志文案后逐字相同。包含此前传奇握把和酒馆交互修复。

官网目录API和详情页均返回HTTP200，确认v0.28.10、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；本版弹窗与完整战役仍待实机复测。

证据：`build/publish-v0.28.10/awakening-text-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`、`build/gameplay-package.json`。
'''
(root/'docs/releases/publication-0.28.10.md').write_text(doc,encoding='utf-8')
release=root/'docs/releases/v0.28.10.md'
text=release.read_text(encoding='utf-8').replace('2026-09-30，内部版本60。','2026-09-30，已发布至BBMOD，内部版本60。')
text=text.replace('[本地完整主包]',f'124份脚本、33,468条离线断言和287个包文件校验通过。[发布记录](publication-0.28.10.md) · [官网下载]({download}) · [本地完整主包]')
release.write_text(text,encoding='utf-8')
readme=root/'README.md'
text=readme.read_text(encoding='utf-8')
intro=f'**v0.28.10 已发布至 BBMOD**：玄武血脉首次与后续觉醒弹窗删除属性变化介绍，保留剧情和“此后她必须完成5场未觉醒的参战胜利，才能再次激发血脉”的说明。实际强化与冷却规则保持原样。[官网下载]({download}) · [本地完整主包](<dist/mod_afeix_expedition v0.28.10.zip>) · [更新说明](docs/releases/v0.28.10.md) · [发布记录](docs/releases/publication-0.28.10.md)。33,468条离线断言通过，弹窗仍待实机复测。\n\n'
text=text.replace('**v0.28.9 已发布至 BBMOD**',intro+'**v0.28.9 已发布至 BBMOD**',1)
text=text.replace('当前本地工作区与BBMOD主包均为 **v0.28.9**','当前本地工作区与BBMOD主包均为 **v0.28.10**')
text=text.replace('传奇握把及发布见[v0.28.9说明](docs/releases/v0.28.9.md)和[发布记录](docs/releases/publication-0.28.9.md)',
                  '觉醒文案及发布见[v0.28.10说明](docs/releases/v0.28.10.md)和[发布记录](docs/releases/publication-0.28.10.md)')
lines=text.splitlines()
for i,line in enumerate(lines):
    if line.startswith('公开下载：'):
        lines[i]=line.replace('v0.28.9','v0.28.10').replace('42daa26b-6587-4a1a-b442-a0080b11f994',published['release_id']).replace('publication-0.28.9','publication-0.28.10')
readme.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'version':'0.28.10','published':True,'installed':False,'assertions':33468,'public_archive_downloaded':False}))
