"""Record successful publication without altering game installation or Git state."""
from datetime import datetime, timedelta, timezone
from pathlib import Path
import json

stage = Path(__file__).resolve().parent
root = stage.parents[1]
published = json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation = json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
archive = json.loads((stage/'website-archive-verification.json').read_text(encoding='utf-8'))
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
after = json.loads((stage/'website-after.json').read_text(encoding='utf-8'))
assert confirmation['version'] == archive['version'] == '0.28.14'
assert confirmation['description_and_notes_confirmed'] and archive['source_bytes_match']
assert archive['sha256'] == published['sha256']
assert archive['full_portrait_rollback_confirmed'] and archive['prior_release_unchanged']
assert after['releases'][0]['id'] == published['release_id']
after_releases = {row['id']:row for row in after['releases']}
assert all(after_releases[row['id']] == row for row in before['releases'])
download = archive['download_url']
timestamp = max(datetime.fromisoformat(archive['confirmed_at']),
                datetime.fromisoformat(confirmation['confirmed_at'])).astimezone(timezone(timedelta(hours=8)))
for name in ('gameplay-package.json', 'endgame-balance-package.json'):
    path = root/'build'/name
    record = json.loads(path.read_text(encoding='utf-8'))
    assert record['version'] == '0.28.14' and record['sha256'] == published['sha256']
    record.update(published=True, website_release_id=published['release_id'], website_detail_url=published['detail_url'],
                  installed=False, public_download_byte_comparison=True,
                  public_archive_verification_transport=archive['verification_transport'],
                  scope='v0.28.14 published to BBMOD; public ZIP hash, CRC, entry set and all source bytes verified. No installation or in-game test performed.')
    path.write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for path in (stage/'release-proof.json', root/'build/helmet-fix-20261002/verification.json'):
    proof = json.loads(path.read_text(encoding='utf-8'))
    assert proof['sha256'] == published['sha256'] and proof['version'] == '0.28.14'
    proof.update(published=True, website_release_id=published['release_id'], installed=False,
                 public_download_byte_comparison=True, prior_release_unchanged=True)
    path.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc = f'''# v0.28.14 网站发布记录

{timestamp:%Y-%m-%d}香港时间{timestamp:%H:%M}完成BBMOD发布与公开下载核验。撤回脸与头发拆层，恢复完整头像，默认隐藏全队头盔。旧档首次升级同步开启隐藏；之后用户手动显示/隐藏的选择随存档保留，头盔防护与装备效果正常生效。本次外观回退无需重开战役。

- [官网条目]({published['detail_url']})
- [官网下载]({download})
- 主包：`mod_afeix_expedition v0.28.14.zip`，内部版本64，288个文件，{published['size']:,}字节。
- SHA256：`{published['sha256']}`。
- 发布前数据库备份：`{published['backup']}`，备份完整性检查通过。

125份Squirrel脚本、33,715条离线断言、原版资源路径与JavaScript检查通过；当前语音/皮肤整合包两种加载顺序各通过5,108条组合断言。完整ZIP的CRC、文件集合及全部源码字节一致。相对v0.28.13仅移除2个拆发图集文件、更新4个脚本；其余人物美术、数值及技能资源字节一致。

网站目录API与详情页均返回HTTP200，当前版本、说明和下载入口已核验。公开下载通过可信服务器请求网站源站公开HTTPS地址，确认SHA256、大小、CRC、文件集合及全部288个文件哈希与本地包、源码一致；Range请求返回HTTP206，前1024字节相符。历史v0.28.13的公开下载仍返回HTTP200，大小与SHA256保持不变。发布事务核对此前目录记录未变，发布后核对全部历史主包版本记录保持原样。

本轮未安装游戏包或进行实机验收；首次移动停顿仍未定位。退出游戏后替换旧主包，仅保留一个版本。本次头像与头盔显示回退无需重开战役。详细改动见[v0.28.14说明](v0.28.14.md)。

证据：`build/publish-v0.28.14/website-release.json`、`website-before.json`、`website-after.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`和`release-proof.json`。
'''
(root/'docs/releases/publication-0.28.14.md').write_text(doc,encoding='utf-8')
path = root/'docs/releases/v0.28.14.md'
text = path.read_text(encoding='utf-8')
text = text.replace('2026-10-02，本地完整包，内部版本64。', f'2026-10-02，已发布至BBMOD，内部版本64。公开下载与本地完整主包、源码一致。\n\n[官网下载]({download}) · [发布记录](publication-0.28.14.md)。')
text = text.replace('本包已完成离线核验，尚未安装、发布或完成实机验收。', '本包已完成离线核验与官网发布，尚未安装或完成实机验收。')
path.write_text(text,encoding='utf-8')
path = root/'README.md'
lines = path.read_text(encoding='utf-8').splitlines()
for i,line in enumerate(lines):
    if line.startswith('**v0.28.14 本地更新**'):
        lines[i] = f'**v0.28.14 已发布至 BBMOD**：撤回脸与头发拆层，恢复完整头像，默认隐藏全队头盔；旧档首次升级同步隐藏，之后手动显示/隐藏选择随存档保留，头盔防护与装备效果正常生效。[官网下载]({download}) · [完整主包](<dist/mod_afeix_expedition v0.28.14.zip>) · [更新说明](docs/releases/v0.28.14.md) · [发布记录](docs/releases/publication-0.28.14.md)。33,715条离线断言与288个包文件校验通过，公开下载与源码一致；尚未安装或完成实机验收。本次外观回退无需重开战役。'
    elif line.startswith('**v0.28.13 已发布至 BBMOD**'):
        lines[i] = line.replace('**v0.28.13 已发布至 BBMOD**', '**v0.28.13 历史版本**').replace('主包33名可戴盔角色保留原画像素，拆出独立头发，接入原版头盔遮挡规则。', '当时的头发拆层已由v0.28.14撤回。')
    elif line.startswith('公开下载：'):
        lines[i] = line.replace('v0.28.13','v0.28.14').replace('836c50e6-dc27-4b3a-8450-dfce74584d20',published['release_id']).replace('publication-0.28.13','publication-0.28.14')
    elif line.startswith('整合 DLC 已发布：'):
        lines[i] = line.replace('已对 v0.28.13 做离线组合复测。', '已对 v0.28.14 两种加载顺序各通过5,108条离线组合断言。')
    elif line.startswith('当前本地工作区与BBMOD主包均为'):
        lines[i] = line.replace('**v0.28.13**','**v0.28.14**').replace('小龟缩头与头盔遮挡更新见[v0.28.13说明](docs/releases/v0.28.13.md)和[发布记录](docs/releases/publication-0.28.13.md)', '完整头像回退与默认隐藏头盔见[v0.28.14说明](docs/releases/v0.28.14.md)和[发布记录](docs/releases/publication-0.28.14.md)').replace('请按新建战役验收。', '本次外观回退无需重开战役；此前玩法更新仍按新建战役验收。')
path.write_text('\n'.join(lines)+'\n',encoding='utf-8')
print(json.dumps({'version':'0.28.14', 'published':True, 'public_archive_verified':True,
                  'prior_release_unchanged':True, 'installed':False, 'in_game_tested':False,
                  'assertions':33715},ensure_ascii=False))
