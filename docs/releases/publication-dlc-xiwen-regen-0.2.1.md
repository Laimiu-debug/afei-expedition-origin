# 希文与里根 DLC 0.2.1 网站发布记录

2026-09-29（香港时间）将“阿飞远征团 DLC：希文与里根”作为独立作品首次发布至 BBMOD。

- [DLC 作品页](https://bbmod.site/mods/247b829d-8aa8-4898-a6dd-8b933c9ff1e9/)
- [直接下载 DLC](https://bbmod.site/files/3c5c209a-08ea-4cff-9bda-fe6623b9a8ab/download/)
- 作品 ID：`247b829d-8aa8-4898-a6dd-8b933c9ff1e9`。
- 发布 ID：`3c5c209a-08ea-4cff-9bda-fe6623b9a8ab`。
- 上传包：`mod_afeix_dlc_xiwen_regen v0.2.1.zip`，26,568 字节、8 个文件。
- 网站安装名：`mod_afeix_dlc_xiwen_regen.zip`。上传与下载后缀均为小写 `.zip`。
- SHA-256：`e6da8d4a66b5774dd7c76481d38b8e770fa07456cf0247f3658987fd198e211a`。

网站登记独立 Mod ID `mod_afeix_dlc_xiwen_regen`，前置为 `mod_afeix_expedition` 与 `mod_hooks`。介绍和安装说明要求主包、DLC 同时安装，推荐当前主包 v0.27.5 或更新版本，并新开战役。里根直接装备在阿飞饰品栏，战斗中手动释放；希文从第35日起满足全部门槛后进入招募队列。

发布使用与主包 v0.27.5 配合验证的现有 DLC 包，没有重新改变其内容。5,587 项离线相关检查通过；发布前重新核对 ZIP CRC、八个文件与当前源码字节一致。本次未启动游戏实机验收，也未安装到本机游戏。

发布前核对网站无重复 DLC 作品，经网站自身表单、归档校验和发布服务创建。SQLite 在线备份完整性检查通过，备份为 `/srv/data/backups/afeix-pre-v0.2.1-20260929T084025537504Z.sqlite3`；事务确认此前所有作品和版本记录未改动。

公开 HTTPS 请求部分超时，重试后目录、DLC 页面、DLC 下载和主包下载均返回 HTTP 200。新下载与本地包逐字节一致，SHA-256、文件大小、CRC、文件数量和小写下载名通过。公开目录中的版本、文案、依赖与提交一致，主包 v0.27.5 的元数据及包哈希保持不变。

核验时间：`2026-09-29T08:40:53.454564+00:00`。证据保存在 `build/publish-dlc-xiwen-regen-v0.2.1/`，包含发布前快照、提交规格、校验与发布日志、公开页面和目录、最终 `website-verification.json`。
