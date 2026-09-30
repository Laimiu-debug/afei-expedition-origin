"""Record the verified BBMOD release and update current download links."""
from datetime import datetime, timedelta, timezone
from pathlib import Path
import json

stage = Path(__file__).resolve().parent
root = stage.parents[1]
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
confirmation = json.loads((stage / 'website-metadata-confirmation.json').read_text(encoding='utf-8'))
archive = json.loads((stage / 'website-archive-verification.json').read_text(encoding='utf-8'))
proof_path = stage / 'turtle-tooltip-proof.json'
proof = json.loads(proof_path.read_text(encoding='utf-8'))
assert confirmation['version'] == archive['version'] == '0.28.12'
assert confirmation['description_and_notes_confirmed']
assert archive['source_bytes_match'] and archive['tooltip_old_save_text_removed']
assert archive['sha256'] == published['sha256']
download = archive['download_url']
timestamp = datetime.fromisoformat(archive['confirmed_at']).astimezone(timezone(timedelta(hours=8)))
count = f"{proof['behavior_assertions']:,}"
for name in ('gameplay-package.json', 'endgame-balance-package.json'):
    path = root / 'build' / name
    record = json.loads(path.read_text(encoding='utf-8'))
    assert record['version'] == '0.28.12' and record['sha256'] == published['sha256']
    record.update(published=True, website_release_id=published['release_id'], installed=False,
                  installation_requested=False, installation_pending_game_exit=False,
                  public_download_byte_comparison=True,
                  public_archive_verification_transport=archive['verification_transport'],
                  scope='v0.28.12 published to BBMOD; public HTTPS archive hash, CRC and all source bytes verified through trusted origin. No game installation or in-game test performed.')
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
proof.update(published=True, website_release_id=published['release_id'], installed=False,
             public_download_byte_comparison=True, public_archive_downloaded_at_origin=True,
             local_public_archive_saved=False)
proof_path.write_text(json.dumps(proof, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
doc = f'''# v0.28.12 网站发布记录

{timestamp:%Y-%m-%d}香港时间{timestamp:%H:%M}完成BBMOD发布及公开下载核验。精简小龟“头盔戴不下，龟壳扛得住”特质提示，删除旧存档说明。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.12.zip`，内部版本62，287个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

124份脚本、{count}条离线断言、原版资源路径和JavaScript检查通过。本地完整ZIP的CRC、条目集合及全部源码字节一致性检查通过。与v0.28.11主包相比，仅版本入口和小龟体质提示两个条目变化；小龟脚本的唯一变化为删除指定说明。

网站目录API、详情页及公开下载均返回HTTP200。通过既有可信服务器请求网站源站公开HTTPS下载地址，确认ZIP的SHA256、大小、CRC、条目集合和全部287个源文件哈希一致，并检查小龟说明中已无被删除文字。公开ZIP只在服务器内存中读取，未保存另一份本地下载包。此前网站版本和独立DLC条目保持原样。

本轮未安装游戏包，也未进行实机验收。退出游戏后移走旧主包，将新版ZIP整包放入data，仅保留一个主包；按新建战役验收。

证据：`build/publish-v0.28.12/turtle-tooltip-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`；`build/gameplay-validation.json`。
'''
(root / 'docs/releases/publication-0.28.12.md').write_text(doc, encoding='utf-8')
release = f'''# v0.28.12：小龟特质提示精简

2026-09-30，已发布至BBMOD，内部版本62。

删除小龟“头盔戴不下，龟壳扛得住”特质提示中关于旧存档的最后一段说明。保留体质效果介绍和铁匠台词，装备限制、天生钢头及厚壳防御规则沿用此前设置。

完整主包包含此前契约种类统计、觉醒文案精简、传奇蓝光握把及酒馆交互修复。124份脚本、{count}条离线断言及287个包文件校验通过；公开下载与本地包和源码一致。

[官网下载]({download}) · [本地完整主包](<../../dist/mod_afeix_expedition v0.28.12.zip>) · [发布记录](publication-0.28.12.md)。退出游戏后移走旧主包，将新版ZIP整包放入data，仅保留一个主包。按新建战役验收；本轮未安装或进行实机复测。
'''
(root / 'docs/releases/v0.28.12.md').write_text(release, encoding='utf-8')
readme = root / 'README.md'
text = readme.read_text(encoding='utf-8')
intro = f'**v0.28.12 已发布至 BBMOD**：精简小龟体质提示，删除旧存档说明，保留体质效果与铁匠台词。完整主包包含此前全部更新。[官网下载]({download}) · [本地完整主包](<dist/mod_afeix_expedition v0.28.12.zip>) · [更新说明](docs/releases/v0.28.12.md) · [发布记录](docs/releases/publication-0.28.12.md)。{count}条离线断言和287个包文件校验通过，公开下载与源码一致。\n\n'
assert '**v0.28.12 已发布至 BBMOD**' not in text
assert '**v0.28.11 已发布至 BBMOD**' in text
text = text.replace('**v0.28.11 已发布至 BBMOD**', intro + '**v0.28.11 已发布至 BBMOD**', 1)
text = text.replace('当前本地工作区与BBMOD主包均为 **v0.28.11**', '当前本地工作区与BBMOD主包均为 **v0.28.12**')
text = text.replace('契约类型统计及发布见[v0.28.11说明](docs/releases/v0.28.11.md)和[发布记录](docs/releases/publication-0.28.11.md)',
                    '小龟提示精简及发布见[v0.28.12说明](docs/releases/v0.28.12.md)和[发布记录](docs/releases/publication-0.28.12.md)')
text = text.replace('本机游戏仍运行v0.28.5，退出后才能安装新版。', '退出游戏后再安装新版主包。')
lines = text.splitlines()
for i, line in enumerate(lines):
    if line.startswith('公开下载：'):
        lines[i] = line.replace('v0.28.11', 'v0.28.12').replace('dcf9ee57-3d77-4767-8bf4-8cdddfd1921a', published['release_id']).replace('publication-0.28.11', 'publication-0.28.12')
readme.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print(json.dumps({'version': '0.28.12', 'published': True, 'public_archive_verified': True,
                  'installed': False, 'assertions': proof['behavior_assertions']}, ensure_ascii=False))
