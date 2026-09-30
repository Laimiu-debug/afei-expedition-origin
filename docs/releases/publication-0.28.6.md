# v0.28.6 网站发布记录

2026-09-30 13:21（香港时间）已发布至BBMOD原作品“阿飞远征团”，更新野外加点规则、介绍、兼容说明、版本说明和下载入口。

- [作品页](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)
- [主包v0.28.6下载](https://bbmod.site/files/79e4f7f1-aabd-436c-a83e-341d14b8b6c5/download/)
- 上传包：`mod_afeix_expedition v0.28.6.zip`，4,497,022字节、287个文件、内部版本56。
- 网站安装名：`mod_afeix_expedition.zip`。
- 本地上传文件SHA-256：`1fd95bc6d0cd13d6c683b1305bab7886eb768991c13dc2db655be806473b1ccc`。

飞李不可可在世界地图上的野外直接付款加点，无需扎营或进入酒馆；接战、战斗和加载期间仍不可付款。结果和失败原因显示在属性列表上方。保留v0.28.5的Esc退出和接战卡死修复，其他事务地点门槛沿用各自规则。见[v0.28.6说明](v0.28.6.md)。

主包通过124份脚本、33,321条离线行为断言、原版资源与JavaScript检查；287个文件通过本地CRC、完整文件集合和源码字节核验。旧v0.28.5主包在不扎营的野外按钮路径复现拒绝加点，新源码通过同一原版事件输入路径。

网站表单和发布服务确认完成，发布前数据库备份为 `/srv/data/backups/afeix-pre-v0.28.6-20260930T052134948147Z.sqlite3`；事务确认此前其他作品、历史版本和桌面客户端记录未变。本轮只发布主包，DLC未更新，未执行Git提交推送。

[发布数据](../../build/publish-v0.28.6/website-release.json)和[发布结果](../../build/publish-v0.28.6/website-published.json)已保存。按用户要求，只确认公开版本、说明和下载入口，不请求公开压缩包做本地比对。确认记录见 [website-metadata-confirmation.json](../../build/publish-v0.28.6/website-metadata-confirmation.json)。

野外加点实机验收仍待复测；运行中的本机游戏需完全退出后才能更新加载包。
