"""Record verified official publication without installing or changing Git state."""
from datetime import datetime, timedelta, timezone
from pathlib import Path
import json

stage = Path(__file__).resolve().parent
root = stage.parents[1]
version = '0.29.0-preview.3'
published = json.loads((stage / 'website-published.json').read_text(encoding='utf-8'))
verified = json.loads((stage / 'website-verification.json').read_text(encoding='utf-8'))
delivery = json.loads((stage / 'website-delivery-verification.json').read_text(encoding='utf-8'))
backup = json.loads((stage / 'backup-verification.json').read_text(encoding='utf-8'))
assert verified['version'] == delivery['version'] == version
assert verified['sha256'] == published['sha256']
assert verified['source_bytes_match'] and verified['download_bytes_match'] and verified['catalog_and_notes_match']
assert delivery['prior_release_records_unchanged'] and delivery['range_bytes_match']
assert backup['integrity_check'] == 'ok' and backup['predates_new_release']
download, detail = verified['download_url'], published['detail_url']
stamp = datetime.fromisoformat(delivery['confirmed_at']).astimezone(timezone(timedelta(hours=8)))
for filename in ('gameplay-package.json', 'endgame-balance-package.json'):
    path = root / 'build' / filename
    report = json.loads(path.read_text(encoding='utf-8'))
    assert report['version'] == version and report['sha256'] == published['sha256']
    report.update(published=True, installed=False, website_release_id=published['release_id'],
                  website_detail_url=detail, website_download_url=download, public_download_byte_comparison=True,
                  public_archive_verification_transport='Public HTTPS from local machine',
                  scope='Complete main Mod published to bbmod.com; public ZIP hash, CRC, full entry set and source bytes verified. No installation or in-game acceptance.')
    path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
path = root / 'build/dream-story-0.29-preview.3.json'
report = json.loads(path.read_text(encoding='utf-8'))
assert report['package_sha256'] == published['sha256']
report.update(published=True, installed=False, website_release_id=published['release_id'],
              website_detail_url=detail, website_download_url=download, public_download_byte_comparison=True,
              scope='Full main Mod published to bbmod.com, including tutorial-style story, physical boss and trophies; public source bytes verified. No installation or in-game acceptance.')
path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

release = f'''# v{version}：梦境开局、故事弹窗与现实斗鱼

{stamp:%Y-%m-%d}，已发布至BBMOD新官网，内部版本67。完整主Mod包，包含此前全部更新。

[官网下载]({download}) · [官网作品]({detail}) · [发布记录](publication-{version}.md)。

阿飞、抹茶与大谋在大陆旅途中做了同一个梦。刀一十人全员11级、传奇配装，依次迎战蜘蛛、恐狼、林德虫与斗鱼；梦潮在斗鱼战第三轮结束后吞没战场，三人醒来，接回真实队伍、原始装备、资源与世界时间。可以略过梦境战斗。

开局采用原版新战团教程式故事窗口：黑旗未满 → 三人同梦 → 黑旗初醒 → 黑旗启程。夜营、道路插画与队长头像介绍旅程、找人和组队目标。略过梦境也展示启程介绍，Esc可收起，F8“再赴梦潮”可继续未读页或只读回看已读背景。

现实大陆生成唯一传奇据点“梦潮祭场”。队伍自由选择，最多十二人出战；F8提供方位，正常行军抵达后挑战，未击杀时撤退可重来。现实击杀掉落以下三件固定传奇各一件，梦境不掉落：

| 装备 | 类型 | 主要属性 |
| --- | --- | --- |
| 深渊鲨衣 | 鲨皮身体重甲 | 460护甲，疲劳−26，可修理与加装附件 |
| 断潮鱼翅 | 双手砍刀 | 90–120伤害，165%护甲伤害，55%穿甲 |
| 破浪鲨牙 | 单手矛 | 54–62伤害，145%护甲伤害，45%穿甲 |

保留《战场兄弟》画风与原版装备动作。斗鱼的点名、弹幕与火箭有预兆，走位或集中攻击可应对；现实战斗采用正常伤亡、消耗与战利品规则。

请新开战役体验完整开局。旧阿飞档不会自动插入梦境，可在F8主动进入序章；其他起源不会获得本序章或据点。退出游戏后替换旧主包，不解压，data中只保留一份主包。希文、衣橱与语音为另外下载的可选DLC。

147份脚本、45,691条离线断言及324个包文件校验通过，官网公开下载与本地包和源码一致。尚未安装或完成实机战役验收，弹窗排版、装备贴合、地图可达性与Boss平衡待试玩确认。

编辑入口及详细规则：[序章与故事](../design/dream-opening.md)、[现实据点与掉落](../design/douyu-world-and-trophies.md)、[试玩步骤](../playtest-dream-0.29.md)。
'''
(root / f'docs/releases/v{version}.md').write_text(release, encoding='utf-8')
publication = f'''# v{version} 网站发布记录

{stamp:%Y-%m-%d}香港时间{stamp:%H:%M}完成BBMOD新官网发布及公开下载核验。使用已迁移的 `bbmod.com` 与 CloudCone 生产站，旧 `bbmod.site` 服务保持停用。

- [官网条目]({detail})
- [官网下载]({download})
- 上传完整主包：`mod_afeix_expedition v{version}.zip`，内部版本67，324个文件，{published['size']:,}字节。
- 官网下载使用固定安装文件名 `mod_afeix_expedition.zip`，文件内容与本地版本包完全一致。
- SHA-256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。完整性检查为ok；备份包含上一版、不包含本次新增版本。

发布前重新确认147份脚本、45,691条离线断言的验证记录与当前源码指纹一致；ZIP的CRC、完整条目集合及全部源码字节一致。服务器使用网站原生表单、归档检查、额度与审计服务，备份完整性通过后才新增发布记录。

官网目录API、详情页、新版完整下载、上一版完整下载均返回HTTP200。通过本机公开HTTPS完整下载新包，SHA-256、长度、CRC、全部324个条目和源码字节一致；网站版本、说明及资料与发布规格一致。HEAD返回200，Range返回206，前1024字节与完整包相符。

历史24条主包版本记录保持原样，v0.28.14公开下载的大小与SHA-256不变。发布事务同时核对既有其他作品和版本记录未改变。

本轮发布整个主Mod，不是独立DLC；梦境序章、教程式弹窗、现实斗鱼据点和三件装备都在同一主包中。未安装游戏包或进行实机验收，完整开局请新开战役。详见[v{version}说明](v{version}.md)。

证据：`build/publish-v{version}/website-release.json`、`website-before.json`、`website-after.json`、`website-published.json`、`website-verification.json`、`website-delivery-verification.json`、`backup-verification.json`。
'''
(root / f'docs/releases/publication-{version}.md').write_text(publication, encoding='utf-8')

path = root / 'README.md'
lines = path.read_text(encoding='utf-8').splitlines()
for i, line in enumerate(lines):
    if line.startswith('**v0.29.0-preview.3 本地梦境与现实终局预览版**'):
        lines[i] = line.replace('本地梦境与现实终局预览版', '梦境与现实终局试玩版，已发布至BBMOD')
        lines[i] = lines[i].replace('尚未安装、发布或完成实机验收。', '公开下载与本地完整主包、源码一致；尚未安装或完成实机验收。')
        lines[i] += f' [官网下载]({download}) · [更新说明](docs/releases/v{version}.md) · [发布记录](docs/releases/publication-{version}.md)。'
    elif line.startswith('公开下载：'):
        lines[i] = f'公开下载：[BBMOD v{version} 试玩版]({detail}) · [直接下载ZIP]({download}) · [安装与更新说明](docs/releases/v{version}.md) · [网站发布记录](docs/releases/publication-{version}.md)。[GitHub Release](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.16.1) 暂仍为v0.16.1。'
    elif line.startswith('当前本地工作区为 **v0.29.0-preview.3**'):
        lines[i] = line.replace('当前本地工作区为 **v0.29.0-preview.3**，BBMOD主包仍为 **v0.28.14**', '当前本地工作区与BBMOD主包均为 **v0.29.0-preview.3**')
path.write_text('\n'.join(lines).replace('https://bbmod.site/', 'https://bbmod.com/') + '\n', encoding='utf-8')
path = root / 'docs/playtest-dream-0.29.md'
text = path.read_text(encoding='utf-8').replace('本地构建，未发布至BBMOD，未安装到游戏。', '已发布至BBMOD新官网，公开下载与本地包、源码一致，未安装到游戏。')
text += f'\n官网下载：[v{version}完整主包]({download})。公开验收见[发布记录](releases/publication-{version}.md)。\n'
path.write_text(text, encoding='utf-8')
path = root / 'docs/design/dream-opening.md'
text = path.read_text(encoding='utf-8').replace('本地预览版 `0.29.0-preview.3`', '官网试玩版 `0.29.0-preview.3`')
text += f'\n本版已发布至[BBMOD新官网]({detail})，完整主包公开下载已与源码核验一致；[发布记录](../releases/publication-{version}.md)。实机验收边界保持上述说明。\n'
path.write_text(text, encoding='utf-8')
print(json.dumps({'version': version, 'published': True, 'public_archive_verified': True,
                  'historical_records_unchanged': True, 'installed': False, 'in_game_tested': False}))
