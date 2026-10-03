# v0.29.0-preview.6 发布记录

2026-10-03香港时间11:50完成BBMOD官网发布与公开下载核验。版本内部编号70。

- [官网条目](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [官网下载](https://bbmod.com/files/a0ef0043-bd1b-4c1e-8ec7-aa70513dc735/download/)
- 完整主包：`mod_afeix_expedition v0.29.0-preview.6.zip`，4,861,536字节，326个文件。
- 官网下载使用固定安装文件名`mod_afeix_expedition.zip`；与本地实测安装包和dist包字节一致。
- SHA-256：`0bba1c6f1ef4297cf42ed9da4ac25269a93c1ad4b15c48063112c5a8d3e8d7dc`。
- 数据库备份：`/srv/data/backups/afeix-pre-v0.29.0-preview.6-20261003T034927366736Z.sqlite3`；完整性检查为ok，包含上一版、不包含此次新增版本。

官网目录、详情页、新版完整下载与上一版完整下载均返回HTTP200。完整公开下载的长度、SHA-256、CRC、全部文件清单与源码字节均相符；目录的版本、发布说明与资料也相符。HEAD返回200，Range返回206，前1024字节一致。25条历史主包版本记录保持原样，上一版preview.3公开下载指纹不变。发布事务同时核对其他作品与既有版本没有改变。

公开介绍不透露装备掉落。新开局及F8入口、梦境收尾和原生AI斗鱼对战的定向实测见[实机报告](../../build/douyu-balance-0.29-preview.6.json)及[版本说明](v0.29.0-preview.6.md)。148份脚本和45,956条离线行为断言通过。完整四幕连打、现实祭场行军与结算、玩家多阵容胜率仍未验收。网站下载验证本身不替代游戏测试。

证据位于`build/publish-v0.29.0-preview.6/`：发布规格、发布前后目录、发布结果、公开下载校验、HEAD/Range与数据库备份校验。原始游戏日志、存档和测试原生资源保留在本机忽略缓存，不进入发布主包或GitHub提交。
