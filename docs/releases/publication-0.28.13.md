# v0.28.13 网站发布记录

2026-10-02香港时间16:21完成BBMOD发布与公开下载核验。小龟基础生命54→69，取消赠送钢头，新增25%头部免伤、其余转身体结算的缩头乌龟；主包33名可戴盔角色保留原画并按轮廓拆出头发，接入原版头盔遮挡。

- [官网条目](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.site/files/836c50e6-dc27-4b3a-8450-dfce74584d20/download/)
- 主包：`mod_afeix_expedition v0.28.13.zip`，内部版本63，290个文件，5,583,595字节。
- SHA256：`c9227c64ef612af3cff3c085e8ffcd1215c1a60dd3ebb755544d589fe20e1b09`。
- 发布前数据库备份：`/srv/data/backups/afeix-pre-v0.28.13-20261002T082106368638Z.sqlite3`。

125份Squirrel脚本、35,249条离线断言、原版资源路径和JavaScript检查通过；完整ZIP的CRC、文件集合及源码字节一致性检查通过。231个新增画刷的实际图集解包像素、锚点及33人的裸头原画合成校验通过。

网站目录API、详情页与公开下载均返回HTTP200。公开下载通过既有可信服务器请求网站源站公开HTTPS地址，确认SHA256、大小、CRC、条目集合和全部290个文件哈希与本地包、源码一致。目录元数据、版本、说明与下载入口另行核验。发布事务核对此前目录记录未变，并保留历史下载。

本机直连目录API返回200，详情页三次请求超时；随后通过可信服务器请求同一公开HTTPS源站，详情页和目录API均返回200并完成内容核验。此记录区分本机访问结果与源站核验结果。

本轮未安装游戏包、未进行实机验收；首次移动停顿仍未定位。退出游戏后移走旧主包，将新版完整ZIP放入data，仅保留一个主包，按新建战役验收。详细改动见[v0.28.13说明](v0.28.13.md)。

证据：`build/publish-v0.28.13/website-release.json`、`website-published.json`、`website-metadata-confirmation.json`、`website-archive-verification.json`和`release-proof.json`。
