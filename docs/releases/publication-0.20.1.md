# v0.20.1 网站发布记录

2026-09-27，按用户要求将战斗、理发店与专属背景热修复发布到现有 BBMOD 作品页。

- [作品页](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [v0.20.1 下载](https://bbmod.site/files/bf3c226e-66f3-4cb0-9463-8d1e84cf22c2/download/)
- 账号：`laimiu`；版本 ID：`bf3c226e-66f3-4cb0-9463-8d1e84cf22c2`。
- 文件：`mod_afeix_expedition.zip`，2,078,053 字节，227 个条目。
- SHA-256：`51011ac5d92fb53254b9d19db6661a1b13106a9374e1ce2199df9f9947fd968b`。

使用现有网站 ModForm、ReleaseForm 和 create_release 服务进行校验与发布，更新介绍、摘要和版本说明，保留历史发布。发布前完成 SQLite 在线备份与完整性检查；事务检查已有版本、其他作品及管理器发布记录未被修改。

发布后匿名访问目录 API、作品页、直接下载地址均返回 HTTP 200。目录版本、更新说明、作品介绍符合发布规格；公开下载文件与本地 v0.20.1 包逐字节一致，SHA-256 和 ZIP CRC 校验通过。

完整发布规格、服务回执及公开验证保存在 `build/publish-v0.20.1/`。未重新构建游戏包；本次热修复仍未实机复测，网站已明确说明。GitHub Release 沿用原版本。
