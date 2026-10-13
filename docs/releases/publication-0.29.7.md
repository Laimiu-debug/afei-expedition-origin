# v0.29.7 发布记录

2026-10-13 发布官网和 GitHub，内部版本 85。

- [官网条目](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.com/files/0709064c-deaa-4ae7-9328-d57e65a15fd6/download/)
- [GitHub 版本](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.7)
- 4,885,957 字节，332 个文件，SHA-256：`ecc2c797c228be779d8f5081b31be28b0689fa9d85c5b4d5c48c980e1146b953`
- 源码提交：`abb152a006952debf9ede0658e8212f7d907357d`，v0.29.7 标签指向该提交。
- 数据库一致快照：`/srv/data/backups/afeix-pre-v0.29.7-20261013T135753160061Z.sqlite3`；没有做整站备份，历史下载原件继续保留。

修复怨魂后台 AI 评估时，勇气读取触发技能和 UI 更新而造成行动条卡死的根因。151 份 Squirrel、46,958 条离线断言、资源、美术、JavaScript 和 ZIP 源码字节检查通过。实际原战前存档副本复测两轮，每轮到第 6 回合、经历 9 次恐怖尖啸，战斗阶段没有原有异常；用户观看第二轮后确认正常。大地图悬停提示框空坐标报错仍待处理。完整战役和全部模组组合不在此次验收范围。

官网简介、说明、兼容性说明及下载目录已更新为 0.29.7。官网公开下载 GET/HEAD 200、Range 206，完整下载的字节、CRC、332 个条目和全部源码与已测试的本地构建一致；33 条旧版本记录未改，上一版 0.29.3 下载哈希保持一致。数据库快照完整性检查 ok，包含旧记录、不含此次新增版本。

GitHub ZIP 和 SHA-256 两个附件已公开下载核对，字节与本地构建一致。官网和 GitHub 下载文件名均为 `mod_afeix_expedition.zip`。直连下载较慢，官网完整校验已通过直连及本机代理路径，GitHub 的完整下载校验通过代理路径。两边都没有覆盖已发布的旧版原件。

临时上传与下载副本按发布约定清理；保留正式下载原件、数据库快照和小体积验收记录。证据在 `build/publish-v0.29.7/`，包括 `website-verification.json`、`github-verification.json`、`release-proof.json` 和 `cleanup-verification.json`；游戏复测摘要见同目录 `gameplay-acceptance.json`。
