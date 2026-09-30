# v0.28.9 网站发布记录

2026-09-30香港时间14:41发布至BBMOD，老马的垂直握把改为原版传奇品质与蓝色图标底光，保留原造型、持握图、固定战斗数值和商店规则。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/42daa26b-6587-4a1a-b442-a0080b11f994/download/)
- 主包：`mod_afeix_expedition v0.28.9.zip`，内部版本59，287个文件，4,505,968字节。
- SHA256：`010d789517b04b0beabba9469a6604237ac603944423d16363d8386ff77be344`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.9-20260930T064128283472Z.sqlite3`。

124份脚本、33,468条离线断言、原版资源路径与JavaScript检查通过。原版武器回归38条覆盖传奇分类、装备筛选、贵重物品识别、读档、固定伤害、穿甲、破盾与提示。完整包CRC、条目集合和源码字节核验通过。

与本地v0.28.8包对比，仅六个包条目变化：版本入口、武器分类和四个库存图标。四份图标尺寸保持原样，旧图中全不透明的武器像素逐点相同；新增蓝色底光渐隐至透明边缘。已审阅源图、普通及染血持握图集和锚点均保持原样；夜间酒馆F8等之前的修复仍完整包含。

官网目录API和详情页均返回HTTP200，确认v0.28.9、说明、更新记录和新下载链接。按用户要求未下载公开ZIP进行本地包一致性检验。其他版本及独立DLC条目保留。

本机游戏仍运行v0.28.5，本轮未覆盖运行中的包。退出游戏后替换主包；蓝光、传奇装备与完整战役仍待实机复测。哇哇叫音量增强需独立语音DLC0.1.2。

证据：`build/publish-v0.28.9/legendary-grip-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`；`build/gameplay-validation.json`、`build/gameplay-package.json`。
