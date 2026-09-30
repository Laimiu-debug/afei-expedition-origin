from datetime import datetime
from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
proof=json.loads((stage/'legendary-grip-proof.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.28.9' and confirmation['description_and_notes_confirmed']
download=confirmation['download_url']
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    assert record['version']=='0.28.9' and record['sha256']==published['sha256']
    record.update(published=True,website_release_id=published['release_id'],installed=False,
                  installation_pending_game_exit=True,public_download_byte_comparison=False,
                  scope='v0.28.9 published to BBMOD, metadata confirmed; installation awaits game exit and in-game testing remains pending.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof.update(published=True,website_release_id=published['release_id'],installed=False,
             installation_pending_game_exit=True,prior_installed_version='0.28.5',
             public_archive_downloaded=False,public_download_byte_comparison=False)
(stage/'legendary-grip-proof.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.9 网站发布记录

2026-09-30香港时间14:41发布至BBMOD，老马的垂直握把改为原版传奇品质与蓝色图标底光，保留原造型、持握图、固定战斗数值和商店规则。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.9.zip`，内部版本59，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

124份脚本、33,468条离线断言、原版资源路径与JavaScript检查通过。原版武器回归38条覆盖传奇分类、装备筛选、贵重物品识别、读档、固定伤害、穿甲、破盾与提示。完整包CRC、条目集合和源码字节核验通过。

与本地v0.28.8包对比，仅六个包条目变化：版本入口、武器分类和四个库存图标。四份图标尺寸保持原样，旧图中全不透明的武器像素逐点相同；新增蓝色底光渐隐至透明边缘。已审阅源图、普通及染血持握图集和锚点均保持原样；夜间酒馆F8等之前的修复仍完整包含。

官网目录API和详情页均返回HTTP200，确认v0.28.9、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；蓝光、传奇装备与完整战役仍待实机复测。哇哇叫音量增强需独立语音DLC0.1.2。

证据：`build/publish-v0.28.9/legendary-grip-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`、`build/gameplay-package.json`。
'''
(root/'docs/releases/publication-0.28.9.md').write_text(doc,encoding='utf-8')
release=root/'docs/releases/v0.28.9.md'
text=release.read_text(encoding='utf-8').replace('2026-09-30，内部版本59。','2026-09-30，已发布至BBMOD，内部版本59。')
text=text.replace('验证与发布结果见',f'124份脚本、33,468条离线断言、资源路径和287个包文件校验通过。[官网下载]({download})。验证与发布结果见')
release.write_text(text,encoding='utf-8')
readme=root/'README.md'
text=readme.read_text(encoding='utf-8')
intro=f'**v0.28.9 已发布至 BBMOD**：老马的垂直握把升级为**传奇双手锤**，物品图标新增蓝色底光，保留固定属性与商店5%自然补货。包含夜间酒馆F8、飞李不可仅限酒馆、Esc退出与接战卡死修复。[官网下载]({download}) · [本地完整主包](<dist/mod_afeix_expedition v0.28.9.zip>) · [更新说明](docs/releases/v0.28.9.md) · [发布记录](docs/releases/publication-0.28.9.md)。33,468条离线断言通过，蓝光及传奇装备仍待实机复测。\n\n'
text=text.replace('**v0.28.8 已发布至 BBMOD**',intro+'**v0.28.8 已发布至 BBMOD**',1)
text=text.replace('**当前完整主包 v0.28.8**','**当前完整主包 v0.28.9**')
text=text.replace('当前本地工作区与BBMOD主包均为 **v0.28.8**','当前本地工作区与BBMOD主包均为 **v0.28.9**')
text=text.replace('修复及发布见[v0.28.8说明](docs/releases/v0.28.8.md)和[发布记录](docs/releases/publication-0.28.8.md)',
                  '传奇握把及发布见[v0.28.9说明](docs/releases/v0.28.9.md)和[发布记录](docs/releases/publication-0.28.9.md)')
lines=text.splitlines()
for i,line in enumerate(lines):
    if line.startswith('公开下载：') or line.startswith('试玩分发：') or line.startswith('当前完整主包') or line.startswith('主包下载：'):
        lines[i]=line.replace('v0.28.8','v0.28.9').replace('a5f4f9a4-1cfa-4d3a-a620-222e96e3c038',published['release_id']).replace('publication-0.28.8','publication-0.28.9')
text='\n'.join(lines)+'\n'
text=text.replace('红装“老马的垂直握把”','传奇武器“老马的垂直握把”').replace('[红装老马的垂直握把]','[传奇老马的垂直握把]')
readme.write_text(text,encoding='utf-8')
print(json.dumps({'version':'0.28.9','published':True,'installed':False,'assertions':33468,'public_archive_downloaded':False}))
