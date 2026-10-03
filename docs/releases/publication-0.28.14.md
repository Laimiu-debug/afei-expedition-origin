# v0.28.14 网站发布记录

2026-10-02香港时间22:05完成BBMOD发布与公开下载核验。撤回脸与头发拆层，恢复完整头像，默认隐藏全队头盔。旧档首次升级同步开启隐藏；之后用户手动显示/隐藏的选择随存档保留，头盔防护与装备效果正常生效。本次外观回退无需重开战役。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/8d447823-474c-4d2e-9daa-dfea80fb0075/download/)
- 主包：`mod_afeix_expedition v0.28.14.zip`，内部版本64，288个文件，4,507,594字节。
- SHA256：`318d0b3100d5a10e73e57bd93eb2eb5e6866cda376e8815772856ff1a7824504`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.14-20261002T140242294422Z.sqlite3`，备份完整性检查通过。

125份Squirrel脚本、33,715条离线断言、原版资源路径与JavaScript检查通过；当前语音/皮肤整合包两种加载顺序各通过5,108条组合断言。完整ZIP的CRC、文件集合及全部源码字节一致。相对v0.28.13仅移除2个拆发图集文件、更新4个脚本；其余人物美术、数值及技能资源字节一致。

网站目录API与详情页均返回HTTP200，当前版本、说明和下载入口已核验。公开下载通过可信服务器请求网站源站公开HTTPS地址，确认SHA256、大小、CRC、文件集合及全部288个文件哈希与本地包、源码一致；Range请求返回HTTP206，前1024字节相符。历史v0.28.13的公开下载仍返回HTTP200，大小与SHA256保持不变。发布事务核对此前目录记录未变，发布后核对全部历史主包版本记录保持原样。

本轮未安装游戏包或进行实机验收；首次移动停顿仍未定位。退出游戏后替换旧主包，仅保留一个版本。本次头像与头盔显示回退无需重开战役。详细改动见[v0.28.14说明](v0.28.14.md)。

证据：`build/publish-v0.28.14/website-release.json`、`website-before.json`、`website-after.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`和`release-proof.json`。
