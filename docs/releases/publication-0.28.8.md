# v0.28.8 网站发布记录

2026-09-30 香港时间14:19发布至BBMOD，修复夜间酒馆按F8打不开。已经进入友好城镇时使用当前城镇界面判断，城外敌情和地图位置不再拦截开界面。保留Esc返回酒馆、人物栏防重叠、加载／战斗／事件／动画拦截及飞李不可仅限酒馆的规则。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/a5f4f9a4-1cfa-4d3a-a620-222e96e3c038/download/)
- 主包：`mod_afeix_expedition v0.28.8.zip`，内部版本58，287个文件，4,497,383字节。
- SHA256：`139390b5e325038ce52eff8204ddcdeab752b25929420420d367bec45c9214b1`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.8-20260930T061920415797Z.sqlite3`。

124份脚本、33,464条离线断言、资源路径与JavaScript检查通过。旧代码的夜间酒馆附近有敌人场景已离线复现，修复后原版F8／Esc菜单栈188条断言通过；原有canManage代码与v0.28.7逐字节相同。包内CRC、条目集合和源码字节核验通过。

官网目录API和详情页确认v0.28.8、说明、更新记录和新下载链接，均返回HTTP200。按用户要求未下载公开ZIP进行本地包一致性检验。服务器使用既有表单和发布服务更新主包，保留其他版本及DLC条目。

本机日志确认当前运行主包v0.28.5（内部版本55），本轮未覆盖运行中的包。v0.28.8安装待退出游戏；夜间酒馆、战斗和完整战役仍待实机复测。

证据：`build/night-tavern-20260930/report.json`、`game-log-evidence.json`、`test-before.nut`、`ledger-before.nut`；`build/publish-v0.28.8/website-release.json`、`website-published.json`、`website-metadata-confirmation.json`。
