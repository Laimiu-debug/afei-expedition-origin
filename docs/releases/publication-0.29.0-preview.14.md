# v0.29.0-preview.14 发布记录

2026-10-07 发布官网和 GitHub，内部版本 78。

- [官网条目](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.com/files/9e0c2459-f8c6-4149-9a52-4abbecb41bfc/download/)
- [GitHub 版本](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.0-preview.14)
- 4,885,011 字节，332 个文件，SHA-256：`9439a437748d0e66e9a94982ad5952904b5447f9ef90ce0abba30af598400a08`
- 数据库备份：`/srv/data/backups/afeix-pre-v0.29.0-preview.14-20261007T064545747776Z.sqlite3`，完整性检查 ok，含全部 29 条旧版本，不含本次新版。

官网条目页的简介、说明和兼容性说明这次一并重写，换成和 README 一致的玩家向写法。

官网目录、详情页、新版和 preview.13 下载都返回 200。公开下载与源码、dist 包字节一致，CRC、清单、版本和说明匹配；HEAD 200，Range 206，前 1024 字节一致；29 条历史记录和 preview.13 下载指纹没变。

GitHub 的 main、预览版标签都指向 `ce4c453e73b464200c4453656372099b056a398a`。ZIP 和 SHA-256 附件已公开下载核对，ZIP 与官网、dist 包完全一致。

证据在 `build/publish-v0.29.0-preview.14/`。151 份脚本、46,535 条离线断言通过；新文本和黑潮的完整战役流程还没在游戏里验收。
