# v0.22.0 网站发布记录

2026-09-27，按用户要求将倒地头部修正、战团结局扩写和大地图阿飞图标发布至现有 BBMOD 作品页，同时包含已打包的酒馆、信件与留言文案修订。

- [作品页](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [v0.22.0 下载](https://bbmod.site/files/ca83a7d7-c51d-4957-9fee-7ef7c14c7b1e/download/)
- 账号：`laimiu`；版本 ID：`ca83a7d7-c51d-4957-9fee-7ef7c14c7b1e`。
- 文件：`mod_afeix_expedition.zip`，2,252,081 字节，234 个条目。
- SHA-256：`5bb5c7d4bee9e7d4c5acad4a5b63d06f4492eccee969c3892e5158894345e93f`。

发布前核对网站最新版本为 v0.20.1；本地 v0.22.0 包与源码和开发机安装包一致。使用网站现有 ModForm、ReleaseForm 和 create_release 服务完成校验及发布，更新摘要、介绍和版本说明，保留历史发布。

发布前完成 SQLite 在线备份及完整性检查，备份为 `/srv/data/backups/afeix-pre-v0.22.0-20260927T141948228508Z.sqlite3`。发布事务核对已有版本、其他作品及管理器发布记录未被修改。

发布后匿名访问目录 API、作品页与下载地址均返回 HTTP 200。公开目录显示 v0.22.0，作品介绍和更新说明与发布规格一致；下载文件与本地包逐字节一致，SHA-256 和 ZIP CRC 校验通过。

完整发布规格、服务回执和公开验证保存在 `build/publish-v0.22.0/`。本次发布未重新构建游戏包；沿用通过 22,057 条离线断言的安装包。网站已明确本轮尚未完成游戏内实机验收。GitHub Release 未更新。
