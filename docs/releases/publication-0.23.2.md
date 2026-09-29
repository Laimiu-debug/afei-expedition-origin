# v0.23.2 网站发布记录

2026-09-28，按用户要求将解网后技能回调修复发布至现有 BBMOD 作品页，同时更新摘要、介绍、兼容说明和版本说明。

- [作品页](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [v0.23.2 下载](https://bbmod.site/files/eb67fe28-797c-45d9-af1d-139fa0fb916c/download/)
- 账号：`laimiu`；版本 ID：`eb67fe28-797c-45d9-af1d-139fa0fb916c`。
- 文件：`mod_afeix_expedition.zip`，2,253,379 字节，234 个条目。
- SHA-256：`3a521049f570f3a40318582d4a6d612f7199ac9504a345278aed427c1ba94a86`。

发布前确认网站最新版本为 v0.23.1，核对公开目录元数据与数据库快照一致；使用现有 ModForm、ReleaseForm 和 create_release 服务先校验再发布。发布前完成 SQLite 在线备份与完整性检查，备份为 `/srv/data/backups/afeix-pre-v0.23.2-20260928T080316614939Z.sqlite3`。事务内核对已有历史版本、其他作品及桌面端版本记录保持不变。

发布后匿名获取目录 API、作品页、新版本下载与上一版下载，均返回 HTTP 200。v0.23.2 的目录版本、说明与公开元数据符合本次提交；下载文件逐字节等于本地包，SHA-256 和 ZIP CRC 校验通过，确认包含修复回调。v0.23.1 下载的校验值保持不变。记录见 `build/publish-v0.23.2/website-verification.json`。

公开说明补充：从 v0.23.1 升级无需重开，存档 Schema、存读档逻辑和人物／物品标识不变；更早的本项目版本沿用现有迁移逻辑，更新前建议备份。保留“影响存档：是”，因为新增内容本身会写入存档，存档仍依赖本 MOD。

游戏验证沿用 33 组行为测试、22,227 条离线断言；本次发布未新增实机验收。GitHub Release 未更新。
