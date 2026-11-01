"""Record this verified release without changing game installation or Git state."""
from datetime import datetime, timedelta, timezone
from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
archive=json.loads((stage/'website-archive-verification.json').read_text(encoding='utf-8'))
assert confirmation['version']==archive['version']=='0.28.13'
assert confirmation['description_and_notes_confirmed'] and archive['source_bytes_match']
assert archive['sha256']==published['sha256']
assert archive['turtle_and_helmet_resources_present']
download=archive['download_url']
timestamp=datetime.fromisoformat(archive['confirmed_at']).astimezone(timezone(timedelta(hours=8)))
for name in ('gameplay-package.json','endgame-balance-package.json'):
    path=root/'build'/name
    record=json.loads(path.read_text(encoding='utf-8'))
    assert record['version']=='0.28.13' and record['sha256']==published['sha256']
    record.update(published=True,website_release_id=published['release_id'],website_detail_url=published['detail_url'],
                  installed=False,public_download_byte_comparison=True,
                  public_archive_verification_transport=archive['verification_transport'],
                  scope='v0.28.13 published to BBMOD; public download hash, CRC, entry set and all source bytes verified. No game installation or in-game test performed.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof_path=stage/'release-proof.json'
proof=json.loads(proof_path.read_text(encoding='utf-8'))
proof.update(published=True,website_release_id=published['release_id'],installed=False,public_download_byte_comparison=True)
proof_path.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# v0.28.13 网站发布记录

{timestamp:%Y-%m-%d}香港时间{timestamp:%H:%M}完成BBMOD发布与公开下载核验。小龟基础生命54→69，取消赠送钢头，新增25%头部免伤、其余转身体结算的缩头乌龟；主包33名可戴盔角色保留原画并按轮廓拆出头发，接入原版头盔遮挡。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.13.zip`，内部版本63，290个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`。

125份Squirrel脚本、35,249条离线断言、原版资源路径和JavaScript检查通过；完整ZIP的CRC、文件集合及源码字节一致性检查通过。231个新增画刷的实际图集解包像素、锚点及33人的裸头原画合成校验通过。

网站目录API、详情页与公开下载均返回HTTP200。公开下载通过既有可信服务器请求网站源站公开HTTPS地址，确认SHA256、大小、CRC、条目集合和全部290个文件哈希与本地包、源码一致。目录元数据、版本、说明与下载入口另行核验。发布事务核对此前目录记录未变，并保留历史下载。

本轮未安装游戏包、未进行实机验收；首次移动停顿仍未定位。退出游戏后移走旧主包，将新版完整ZIP放入data，仅保留一个主包，按新建战役验收。详细改动见[v0.28.13说明](v0.28.13.md)。

证据：`build/publish-v0.28.13/website-release.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`和`release-proof.json`。
'''
(root/'docs/releases/publication-0.28.13.md').write_text(doc,encoding='utf-8')
path=root/'docs/releases/v0.28.13.md'
text=path.read_text(encoding='utf-8')
text=text.replace('2026-10-02。本地完整主包，尚未发布。按新建战役验收。',f'2026-10-02，已发布至BBMOD，内部版本63。公开下载与本地完整主包、源码一致。\n\n[官网下载]({download}) · [发布记录](publication-0.28.13.md)。请退出游戏后替换旧主包，仅保留一个版本；按新建战役验收。本轮未安装或进行实机复测。')
path.write_text(text,encoding='utf-8')
path=root/'README.md'
lines=path.read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines):
    if line.startswith('**v0.28.13 本地完整包**'):
        lines[i]=f'**v0.28.13 已发布至 BBMOD**：小龟基础生命54→69，取消赠送钢头；“缩头乌龟”25%免疫头部伤害，其余转为身体结算。主包33名可戴盔角色保留原画像素，拆出独立头发，接入原版头盔遮挡规则。[官网下载]({download}) · [完整主包](<dist/mod_afeix_expedition v0.28.13.zip>) · [更新说明](docs/releases/v0.28.13.md) · [发布记录](docs/releases/publication-0.28.13.md) · [离线戴盔对照](build/helmet-layers-20261002/review-1.png)。35,249条离线断言与290个包文件校验通过，公开下载与源码一致；尚未实机验收，首次移动停顿仍待计时定位。'
    elif line.startswith('公开下载：'):
        lines[i]=line.replace('v0.28.12','v0.28.13').replace('b6ab75df-1515-4a08-a7d3-887a7c9ff85f',published['release_id']).replace('publication-0.28.12','publication-0.28.13')
    elif line.startswith('当前本地工作区与BBMOD主包均为'):
        lines[i]=line.replace('**v0.28.12**','**v0.28.13**').replace('小龟提示精简及发布见[v0.28.12说明](docs/releases/v0.28.12.md)和[发布记录](docs/releases/publication-0.28.12.md)','小龟缩头与头盔遮挡更新见[v0.28.13说明](docs/releases/v0.28.13.md)和[发布记录](docs/releases/publication-0.28.13.md)')
path.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'version':'0.28.13','published':True,'public_archive_verified':True,'installed':False,'assertions':35249}))
