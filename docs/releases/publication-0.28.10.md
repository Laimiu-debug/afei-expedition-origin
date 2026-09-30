# v0.28.10 网站发布记录

2026-09-30香港时间14:50发布至BBMOD。玄武血脉首次、第二次与后续觉醒弹窗删除属性变化介绍，保留对应剧情和五场未觉醒参战胜利的冷却说明；战斗日志同步精简。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/d3459cc4-6959-4a34-a4e3-2930c233d1b6/download/)
- 主包：`mod_afeix_expedition v0.28.10.zip`，内部版本60，287个文件，4,505,747字节。
- SHA256：`930ee70d35cb7a0b05573ab069ee501bad1a71e5bbc7b40997711a7e928e3f89`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.10-20260930T065053929131Z.sqlite3`。

124份脚本、33,468条离线断言、原版资源路径与JavaScript检查通过。小龟觉醒回归58条确认首次及重复弹窗保留冷却说明、删除属性介绍，同时覆盖实际强化、战后恢复、五场有效参战胜利、待命／撤退排除和弹窗暂停恢复。完整包CRC、条目集合和源码字节核验通过。

与本地v0.28.9包对比，仅版本入口与小龟觉醒文案两个条目变化。首次、第二次及后续轮换剧情逐字相同；实际觉醒强化、冷却计数、存档与弹窗暂停代码在排除战斗日志文案后逐字相同。包含此前传奇握把和酒馆交互修复。

官网目录API和详情页均返回HTTP200，确认v0.28.10、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；本版弹窗与完整战役仍待实机复测。

证据：`build/publish-v0.28.10/awakening-text-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`、`build/gameplay-package.json`。
