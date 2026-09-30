# 希文与里根儿 DLC 0.2.5 网站发布记录

2026-09-30 11:30（香港时间）已发布至 BBMOD 原DLC作品，推荐搭配主包v0.28.4并新开战役。

- [DLC作品页](https://bbmod.site/mods/247b829d-8aa8-4898-a6dd-8b933c9ff1e9/)
- [DLC 0.2.5下载](https://bbmod.site/files/76341887-9c0c-4a58-aaf7-fd2ef7f478ac/download/)
- 上传包：`mod_afeix_dlc_xiwen_regen v0.2.5.zip`，48,217字节、10个文件、内部版本6。
- 网站下载名：`mod_afeix_dlc_xiwen_regen.zip`。
- SHA-256：`8b0d3afa56de63255caa323d1d0e4f76c0b3f9b464ed905c4da1aaed1164db43`。

优化希文介绍、背景、相遇、成长和结局文字，修正颈部衔接与倒地头部，增加三种倒地伤痕头部的独立图集。里根儿的介绍、物品、宠物和钩子脚本保留原内容；网站完整的战犬介绍及操作说明也原样保留。主包负责终局岗位属性与培养配置。

通过8,018条相关离线断言、6份DLC脚本编译，头像四个画刷的实际解包像素与坐标符合当前导出，新增伤痕图集由主包美术检查覆盖。全部10个包文件通过CRC、完整文件集合与源码字节校验。相关断言包括主包回归，不能直接与主包32,881条断言相加。

发布使用网站自身表单、归档检查和服务。发布前数据库备份为 `/srv/data/backups/afeix-pre-v0.2.5-20260930T033017342033Z.sqlite3`，完整性检查通过；事务确认此前其他作品、版本与桌面客户端记录未变。

公开目录API、作品页、新版下载和历史0.2.4下载均返回HTTP 200。公开下载与本地包逐字节一致，源码、SHA-256、CRC、内部版本、元数据与版本说明核验通过。0.2.4的历史下载SHA-256保持 `906e9713acf65635fe546654bc7c3a228324c5c1e48b1031896d2c0580316ba4`。

公开核验时间：`2026-09-30T03:30:55.699638+00:00`。[发布数据](../../build/publish-dlc-xiwen-regen-v0.2.5/website-release.json)、[发布结果](../../build/publish-dlc-xiwen-regen-v0.2.5/website-published.json)、[网站核验](../../build/publish-dlc-xiwen-regen-v0.2.5/website-verification.json)已保存。核验命令为 `python tools/verify_bbmod_release.py build/publish-dlc-xiwen-regen-v0.2.5`。

本轮未更新本机游戏安装包。宠物流程与美术尚未实机验收。完全退出游戏后将主包与DLC的完整ZIP放入 `data`，不要解压，各只保留一个版本，并新开战役；旧战役不会自动配发战犬。
