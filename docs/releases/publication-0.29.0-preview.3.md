# v0.29.0-preview.3 网站发布记录

2026-10-03香港时间08:00完成BBMOD新官网发布及公开下载核验。使用已迁移的 `bbmod.com` 与 CloudCone 生产站，旧 `bbmod.site` 服务保持停用。

- [官网条目](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.com/files/11748b97-53c8-4052-acf9-39f7434306ef/download/)
- 上传完整主包：`mod_afeix_expedition v0.29.0-preview.3.zip`，内部版本67，324个文件，4,858,322字节。
- 官网下载使用固定安装文件名 `mod_afeix_expedition.zip`，文件内容与本地版本包完全一致。
- SHA-256：`aa13a6e0fbb890fd91b7b983c230d92634992269f3da344ba3b4cd92569fee29`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.29.0-preview.3-20261002T235901227296Z.sqlite3`。完整性检查为ok；备份包含上一版、不包含本次新增版本。

发布前重新确认147份脚本、45,691条离线断言的验证记录与当前源码指纹一致；ZIP的CRC、完整条目集合及全部源码字节一致。服务器使用网站原生表单、归档检查、额度与审计服务，备份完整性通过后才新增发布记录。

官网目录API、详情页、新版完整下载、上一版完整下载均返回HTTP200。通过本机公开HTTPS完整下载新包，SHA-256、长度、CRC、全部324个条目和源码字节一致；网站版本、说明及资料与发布规格一致。HEAD返回200，Range返回206，前1024字节与完整包相符。

历史24条主包版本记录保持原样，v0.28.14公开下载的大小与SHA-256不变。发布事务同时核对既有其他作品和版本记录未改变。

本轮发布整个主Mod，不是独立DLC；梦境序章、教程式弹窗、现实斗鱼据点和三件装备都在同一主包中。未安装游戏包或进行实机验收，完整开局请新开战役。详见[v0.29.0-preview.3说明](v0.29.0-preview.3.md)。

证据：`build/publish-v0.29.0-preview.3/website-release.json`、`website-before.json`、`website-after.json`、`website-published.json`、`website-verification.json`、`website-delivery-verification.json`、`backup-verification.json`。
