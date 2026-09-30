# v0.28.11 网站发布记录

2026-09-30香港时间15:09发布至BBMOD。修复委托记录种类一直为0：记录原版契约引用转发的真实类型，再按类型去重累计；有旧履约记录却缺失种类时明确提示。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/dcf9ee57-3d77-4767-8bf4-8cdddfd1921a/download/)
- 主包：`mod_afeix_expedition v0.28.11.zip`，内部版本61，287个文件，4,505,945字节。
- SHA256：`5d19d31fb5f2fc0881557253b685d643d82ebfc9b681118c496a2055d7cbd54b`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.11-20260930T070930429500Z.sqlite3`。

124份脚本、33,484条离线断言、原版资源路径与JavaScript检查通过。契约收款及完成回归73条，包括本机原版WeakTableRef和契约getType：旧版失败已复现，新版覆盖结算前读类型、同类去重、不同类型累计、原版与阿飞送信排除、重复完成与加载不重复累计、空类型不覆盖已知记录。

旧11份未标注种类的履约计数在回归中保持原样；新完成一份不同契约后为12份、已记录1种，不虚构此前种类。完整包CRC、条目集合和源码字节核验通过。与本地v0.28.10包相比仅版本入口、类型读取、契约回调与委托摘要四个条目变化。保留此前觉醒文案精简、传奇握把和酒馆交互修复。

本机公网读取超时后，通过既有服务器访问网站源站的HTTPS目录API和详情页，均返回HTTP200，确认v0.28.11、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；契约类型统计及完整战役仍待实机复测。

证据：`build/contract-kinds-20260930/baseline.log`、`test-before.nut`、`contracts-before.nut`、`quests-before.nut`、`hooks-before.nut`；`build/publish-v0.28.11/contract-type-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`。
