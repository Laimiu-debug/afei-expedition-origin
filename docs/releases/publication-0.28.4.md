# v0.28.4 网站发布记录

2026-09-30 11:30（香港时间）已发布至 BBMOD 原作品“阿飞远征团”，同步更新简介、完整介绍、兼容说明和版本说明。累计源码、资源、测试、文档与安装包先提交推送至 `main`（`f422652`），再上传发布。

- [作品页](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [主包 v0.28.4 下载](https://bbmod.site/files/ded2ff8f-6009-4dd5-a511-e7b159458cae/download/)
- 上传包：`mod_afeix_expedition v0.28.4.zip`，4,495,731字节、287个文件、内部版本54。
- 网站下载名：`mod_afeix_expedition.zip`。
- SHA-256：`233a6556721ddb202fbae07344098c83ee647bc46949e535c08985d5bdb5a5c2`。

包含主包全员文案优化、终局岗位平衡、“飞李不可”付费属性培养、小龟觉醒冷却与说明弹窗，以及颈部、倒地头部和受伤血迹修正。具体规则与验收范围见[v0.28.4说明](v0.28.4.md)。希文的文案与人物美术另外发布于[可选DLC 0.2.5](publication-dlc-xiwen-regen-0.2.5.md)，里根儿介绍保持原样。

发布前重新通过124份Squirrel脚本、32,881条离线行为断言、原版资源路径、JavaScript与美术图集检查。使用已核验的现有美术文件打包，未重新生成并替换人物美术；全部287个文件通过CRC、完整集合与源码字节核验。

发布使用网站自身表单、归档检查和服务。数据库发布前备份为 `/srv/data/backups/afeix-pre-v0.28.4-20260930T033003141718Z.sqlite3`，完整性检查通过；事务确认此前其他作品、版本与桌面客户端记录未变。

公开目录API、作品页、新版下载与历史v0.28.2下载均返回HTTP 200。新包与本地包逐字节一致，源码字节、SHA-256、CRC、内部版本、网站元数据与版本说明核验通过。v0.28.2的历史下载SHA-256保持 `c325681e3a89a066c02a8a727973fc397fe1281eb89cb6682a9d2fde38eeaa9c`。

公开核验时间：`2026-09-30T03:31:01.384893+00:00`。[发布数据](../../build/publish-v0.28.4/website-release.json)、[发布结果](../../build/publish-v0.28.4/website-published.json)、[网站核验](../../build/publish-v0.28.4/website-verification.json)已保存。核验命令为 `python tools/verify_bbmod_release.py build/publish-v0.28.4`。

本次仅打包、提交推送与网站发布，未更新本机游戏安装包。新增玩法和美术尚未实机战役验收。更新时完全退出游戏，主包和可选DLC各保留一份ZIP，并新开战役；不承诺旧存档迁移。
