# 阿飞 V1 分层美术接入

这是格式与静态验证通过的独立美术试验包与检查入口，**尚未通过美术验收，也未启动游戏实测**，不包含转职玩法、技能、任务或成长数值。正常、蛤蟆人、嘉豪、飞碟的外观可分别调用；测试中的飞碟采用嘉豪主体，并不确定正式游戏的转职继承关系。

## 包结构和安装

当前已构建的文件是 [dist/mod_afeix_art_v1.zip](dist/mod_afeix_art_v1.zip)。其中 `brushes/`、`gfx/`、`scripts/` 位于 ZIP 根目录；自行重打包时也需保持该结构。后续人工测试时将这个 ZIP 放入《战场兄弟》的 `data/` 目录。需要原版游戏及 **Legacy Modding Script Hooks**，不要同时加载一份解压版和 ZIP 版。

本次没有自动安装到游戏目录，也没有启动游戏。脚本语法检查与资源打包检查不等于实机验收。

离线图层检查已发现：人类倒地头与原版 `hair_black_02_dead` 方向不匹配，造成头发遮脸；蛤蟆活头与身体衣领的头颈接缝仍需调整。这两项尚未修复，当前包仅用于继续研究和验证接入，不能作为美术完成版。

新建战役时可以手动选择 **阿飞美术验收（测试）**。该起源提供四名外观副本、基础武器盾牌和四套各类测试盔甲。其他起源不会被自动替换，现有队员不会自动换脸。没有正式版的 10 人限制、转职解锁或水友系统。

若只要资源和接入函数，可在打包前去掉 `scripts/scenarios/world/afeix_art_preview_scenario.nut`。已经用测试起源建立的存档仍需保留该起源脚本才能继续使用。

## 接入调用

加载后命名空间是 `::AfeiArtV1`。只管理带有 `afeix_v1_form` 标记的队员。

```squirrel
::AfeiArtV1.setForm(bro, "normal");
::AfeiArtV1.setForm(bro, "toad");
::AfeiArtV1.setForm(bro, "jiahao");
::AfeiArtV1.setForm(bro, "feidie"); // 本美术测试使用嘉豪主体 + 飞碟
::AfeiArtV1.setDiscVisible(bro, false);
::AfeiArtV1.setForm(bro, "toad", true); // 可独立验证蛤蟆主体叠加飞碟
```

脚本将形态和飞碟开关写入原生 Flags，设计为读档后重设外观。生前飞碟使用独立层 `afeix_v1_feidie_layer`，不占头盔图层或缩放人物；死亡时隐藏，原生尸体不包含该额外图层，昏迷后返回队伍时预期恢复。这些生命周期行为仍需实际运行与存读档验证。

## 精确 brush 名称

| 层 | 必需名称 |
| --- | --- |
| 人类头 | `afeix_v1_human_head`、`afeix_v1_human_head_dead` |
| 蛤蟆头 | `afeix_v1_toad_head`、`afeix_v1_toad_head_dead` |
| 正常身体 | `afeix_v1_normal_body`、`afeix_v1_normal_body_dead`、`afeix_v1_normal_body_injured` |
| 蛤蟆身体 | `afeix_v1_toad_body`、`afeix_v1_toad_body_dead`、`afeix_v1_toad_body_injured` |
| 嘉豪身体 | `afeix_v1_jiahao_body`、`afeix_v1_jiahao_body_dead`、`afeix_v1_jiahao_body_injured` |
| 飞碟 | `afeix_v1_feidie` |
| 蛤蟆脸伤势，可选 | `afeix_v1_toad_head_injured_01`、`afeix_v1_toad_head_injured_02` |

头发复用原版短侧分 `hair_black_02`，死亡路径使用原版 `hair_black_02_dead`；目前它与新倒地头方向不匹配，需要修正后重新验收。蛤蟆形态清空头发。头与身体取消随机肤色色染，显示图像原色。装备、护甲升级、武器盾牌以及永久伤势仍交由原版控制。正式装备覆盖基础衣装是分层装备的预期表现，具体组合仍待实机检查。

原版在生命值低于或等于 40% 时查询身体名称加 `_injured` 的覆盖层。头部轻伤/重伤沿用原版 67%/33% 阈值，蛤蟆头的两个可选伤势覆盖存在时会替换原版人脸血污；若缺失则保留原版覆盖。死亡使用独立 `_dead` 图，而不是将站立图原样当尸体。

`appearance.Corpse` 保留原生值，以继续使用原版箭矢/标枪尸体覆盖；本包不隐去尸体装备。断头、碎头和永久伤势仍走原版逻辑，蛤蟆轮廓与全部原生特效的几何贴合仍需实机逐项查看。

## 旧版迁移注意

旧原型的 `AfeiExpedition.applyLook` 会把整张人物画进 `body` 并隐藏头、头发、盔甲和头盔，`withCorpseAppearance` 也会隐藏尸体装备。把本 helper 合入旧原型时，必须停用阿飞对应的这两处整图覆盖，再在建角与转职时调用 `setForm`。本资源包没有修改旧归档，不声称可以直接叠加旧版的整图接入。

## 人工验收顺序

1. 新建测试起源，四人无外层护甲时检查头颈连接、脸部方向、飞碟间距和缩小后的辨识度。
2. 逐件穿戴仓库中的布甲、棉甲、链甲、开面盔和封闭盔，再卸下；检查头发的遮挡与恢复，以及武器盾牌位置。
3. 实际战斗检查翻转、受伤层、普通死亡、断头、碎头和昏迷后恢复。飞碟不应进入尸体。
4. 保存并重读测试战役，检查四种形态、当前装备、血污与飞碟开关是否恢复。

目前以上项目尚未在游戏中执行。应先修复已发现的死头／头发方向与蛤蟆头颈接缝，再开展实机检查；最终是否可发布取决于美术与运行验收结果。
