# v0.22.0：大地图阿飞图标

内部版本 25，存档 Schema 仍为 8。

阿飞起源在大地图的行军／站立队伍图标替换为专用阿飞胸像，采用当前正常形态的短黑发、灰披肩与米色衣领。原版移动逻辑按目的地方向左右翻转，保留玩家选择的旗帜、底座、缩放旗帜和全部移动参数。

开局通过原版 `updateLook` 入口应用；旧档等待世界状态完整反序列化后再应用，避免玩家对象早于起源状态加载。原版更新队伍外观时重新使用阿飞图标；扎营仍显示帐篷、隐藏旗帜并开启原版火光，收营恢复阿飞。营地期间刷新外观不会把帐篷换成头像。资源缺失时使用原版图标，其他起源不替换。

本轮同时修正 v0.21 结局的注册入口：`asset_manager` 是原版裸表，应使用 `mods_hookNewObject`；`mods_hookExactClass` 不会在其创建时触发。新增注册流程测试验证结局确实接入原生资产管理器，结局文案与选择规则不变。

[图标与生图记录](../art/runtime/world-v22/README.md) · [原尺寸预览](../build/playtest-world-afei/comparison-1x.png) · [3倍对照](../build/playtest-world-afei/comparison-3x.png)。图片为离线图层合成。

使用本机原版资产管理器的 `updateLook`、`setCamping` 与玩家队伍的 `setCamping` 方法测试开局、多个外观档位、反复扎营与收营、旧档、切换其他起源、资源缺失和注册入口；核对移动目标、速度、旗帜及缩放不被覆盖。完整构建另检查 Squirrel 语法、行为测试、JavaScript、原版路径、新图集的像素／锚点回读，以及 ZIP CRC 和逐文件源码一致性。

旧包保存在 `build/world-afei-v22/baseline-*/`，安装校验见该目录的 `installed.json`。更新后完整退出并重启游戏，可直接读取旧存档。本轮尚未实机验收。2026-09-27 已按用户要求发布至 BBMOD，公开下载包与本地包逐字节一致，详见[发布记录](releases/publication-0.22.0.md)；GitHub Release 未更新。
