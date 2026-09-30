# v0.28.12 网站发布记录

2026-09-30香港时间16:03完成BBMOD发布及公开下载核验。精简小龟“头盔戴不下，龟壳扛得住”特质提示，删除旧存档说明。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/b6ab75df-1515-4a08-a7d3-887a7c9ff85f/download/)
- 主包：`mod_afeix_expedition v0.28.12.zip`，内部版本62，287个文件，4,505,869字节。
- SHA256：`4c07029b35b5e7a2d6a3e4da77db6d52445ec296df0be3e05671a6e81454bdd2`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.12-20260930T080306334194Z.sqlite3`。

124份脚本、33,484条离线断言、原版资源路径和JavaScript检查通过。本地完整ZIP的CRC、条目集合及全部源码字节一致性检查通过。与v0.28.11主包相比，仅版本入口和小龟体质提示两个条目变化；小龟脚本的唯一变化为删除指定说明。

网站目录API、详情页及公开下载均返回HTTP200。通过既有可信服务器请求网站源站公开HTTPS下载地址，确认ZIP的SHA256、大小、CRC、条目集合和全部287个源文件哈希一致，并检查小龟说明中已无被删除文字。公开ZIP只在服务器内存中读取，未保存另一份本地下载包。此前网站版本和独立DLC条目保持原样。

本轮未安装游戏包，也未进行实机验收。退出游戏后移走旧主包，将新版ZIP整包放入data，仅保留一个主包；按新建战役验收。

证据：`build/publish-v0.28.12/turtle-tooltip-proof.json`、`website-release.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`；`build/gameplay-validation.json`。
