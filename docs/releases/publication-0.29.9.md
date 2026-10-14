# v0.29.9 发布记录

2026-10-14 发布官网与 GitHub，内部版本 87。完整主包合并 v0.29.8 的酒馆菜单修复和 v0.29.9 的击杀优化。

- [官网条目](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.com/files/0890233f-ee4d-467d-9a72-2d5b9d9ba5f8/download/)
- [GitHub 版本](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.9)
- 4,886,787 字节，332 个文件，SHA-256：`22eaa60063ae251b1624944d7cdccaa451a167c4aea5f213caac9ab2696bdbf1`
- 源码提交：`6aaf44b907d3cbb8333e51b299a2f4da53dd5f5e`，v0.29.9 标签指向该提交。
- 数据库一致快照：`/srv/data/backups/afeix-pre-v0.29.9-20261014T000600661054Z.sqlite3`。仅做必要的数据库快照，未做整站备份，旧版下载原件继续保留。

检查通过：151 份 Squirrel、47,065 条行为断言、资源、美术、JavaScript，以及 ZIP 条目、CRC 和源码字节。酒馆菜单在 v0.29.8 上完成 79 项实际引擎检查；发布包中 ledger、discovery 和 hooks 三份相关脚本与该验收版本字节相同。v0.29.9 原战前存档副本中的三次死亡回调复测，觉醒检测从每次 30–32 次降至 1 次，全场扫描从 32–34 次降至 3 次。计数器帧间隔包含渲染和调度开销，仅为小样本诊断。没有进行人工鼠标攻击或完整战役验收，大地图提示框空坐标问题仍另待处理。

官网详情、简介、兼容性说明与目录最新版本均为 0.29.9。公开完整下载 GET/HEAD 为 200，Range 为 206；下载内容、332 个条目、CRC 和所有源码与已测试安装包完全一致。34 条旧版本记录未改变，上一版 0.29.7 公开下载的完整哈希保持一致。数据库快照完整性检查 ok，包含旧版本而没有新版本记录。

GitHub 正式版本及两个附件已公开下载验证：`mod_afeix_expedition.zip` 和 `mod_afeix_expedition.sha256` 的字节、名称、大小、校验值均正确。标签对应源码提交，发布说明与官网一致；未覆盖旧版附件。两边的大文件下载验收使用现有本机代理，不修改代理或服务器入口设置。

发布证据在 `build/publish-v0.29.9/`，游戏验收摘要为 `gameplay-acceptance.json`，下载与历史记录验收为 `website-verification.json`、`github-verification.json` 和 `release-proof.json`。传输临时文件的清理记录为 `cleanup-verification.json`，正式下载原件、数据库快照与本地 dist 发布包保留。
