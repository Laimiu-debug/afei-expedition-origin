# v0.16.1 发布记录

2026-09-27 发布公开试玩版。

- GitHub：https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.16.1
- BBMOD：https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/
- 安装文件：`mod_afeix_expedition.zip`，1,934,945 字节，168 个条目。
- SHA-256：`9e20123f07536d9539c81f4629abd39a40f116f6ca0bb387b8a930c89b0dff58`。
- 网站发布账号：现有 `laimiu`；作品 ID `d64a00f6-1d60-4d8d-8d9b-de055fc0b748`；版本 ID `0b8cb9bf-8285-4f01-ac72-6840cc54ac44`。

网站使用现有 ModForm、ReleaseForm 和 create_release 校验并发布，保留大小、CRC、配额、元数据快照及审计记录。发布前完成 SQLite 在线备份及完整性检查；事务内逐项确认原有作品、MOD 版本及管理器版本记录未改变。没有重启网站或修改其他应用。

安装包与本机完成 F8 实测的文件完全相同。公开详情与目录 API 已验证；GitHub Release 和网站 ZIP 均完成匿名实际下载，HTTP 200、大小及 SHA-256 与本地完全一致。GitHub 标签对应源码提交 `9e65ad4dc26ec44a7287af6cd55e325aa8e4e31e`，发布为非草稿的 Pre-release，并附 SHA-256 校验文件。下载验证及发布结果见 `build/publish-v0.16.1/`。实机范围以 [F8 修复记录](../playtest-0.16.1.md) 为准。

Git 同步包括项目源码、测试、设计文档、美术母图及构建产物；原版解包文件、本地缓存、临时存档备份和下载的整页 HTML 留在本机，不随源码发布。原有旧项目 LFS 归档保留。
