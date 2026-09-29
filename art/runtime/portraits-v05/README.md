# 朝右战斗胸像与装备叠加 v0.12

2026-09-28 名单删减：现行 **34 人、36 组主体画刷、144 张分层图**；陈知含的人物及四张运行时头像全部移除，不保留旧档兼容。其余成员只调整分组，不重新绘制头像。

2026-09-28 蓝队更新：罗一可改用[用户本人照片](../../references/2026-09-28-blue-team/luoyike-user.png)重绘，保留长发、薄侧刘海与梅紫围巾；眼子哥按仓库既有 Sylar 海报补齐专属头像。两张透明原图位于 [blue-team-v24](sources/blue-team-v24)，[完整提示词](PROMPTS-blue-team-v24.json)与[素装／装备离线预览](../../../build/blue-team-stories/portraits-review.png)可查。角色键与旧档罗一可画刷 `afeix_p04_xiaohani` 保持兼容，眼子哥使用 `afeix_p04_yanzi`。本轮仅更新本地包，尚未实机验收。

2026-09-28 瑶瑶牙服装更新：按用户要求改为遮住双肩、胸口和上臂的米白色素衣，保留面容、黑长发及朝右姿态。选用 [user-v23/yaoyaoya.png](sources/user-v23/yaoyaoya.png)；[内置 ImageGen 实际提示词](PROMPTS-yaoyaoya-v23.json)与[新旧／装备对照](../../../build/playtest-yaoyaoya/comparison.png)可查。沿用 114×142 画布、颈部分界、画刷 ID 和倒地头部支点。[校验记录](../../../build/playtest-yaoyaoya/validation.json)确认试玩包与本机安装包只更新瑶瑶牙四张精灵，其他 140 张精灵及玩法保持原样；已检查素装、护甲和两种头盔的离线叠加，尚未实机验收。旧源图和更新前安装包均已保留。

2026-09-27 奶盖补充更新：根据[四张用户照片](../../references/2026-09-27-naigai/README.md)，将长发改为齐下巴的黑色短发，校正柔和脸型与眉眼唇形，保留棕色短披肩及奶油色衣领。选用 [user-v18/naigai.png](sources/user-v18/naigai.png)；[实际提示词](PROMPTS-naigai-v18.json)与[原尺寸／装备对照](../../../build/playtest-naigai/comparison.png)可查。114×142 透明画布，人物内容 75×100，头身无损分层与图集回读通过。已检查素装、穿甲、开面盔及全罩盔，尚未实机验收。[安装校验](../../../build/playtest-naigai/validation.json)验证各包仅更新奶盖三张精灵，保留原有其他角色和玩法。

2026-09-27 李李补充更新：按用户指定参考重绘短棕发与足球发卡，使用简洁素装。选用 [user-v18/lili.png](sources/user-v18/lili.png)，旧图保留；[实际提示词](PROMPTS-lili-v18.json)与[游戏尺寸／原版装备对照](../../../build/playtest-lili/comparison.png)可查。使用 114×142 透明画布，人物内容 75×100，朝右、完整下颌及颈部；已导出身体、头部和倒地图并通过图集像素与锚点回读。头盔按原版规则遮住发卡，尚未实机验收。[打包检查](../../../build/playtest-lili/validation.json)逐项验证只替换李李三张精灵，保留各包原有的其他角色与玩法。

2026-09-27 溺水小龟补充更新：按[两张用户吉祥物参考](../../references/2026-09-27-xiaogui/README.md)，重点保留亮粉蝴蝶结，并提亮为浅苹果绿皮肤、奶黄色腹甲、粉色爪印和圆脸笑容。选用 [user-v17/xiaogui.png](sources/user-v17/xiaogui.png)，旧图保留；[实际提示词](PROMPTS-xiaogui-v17.json)与[新旧／装备对照](../../../build/playtest-xiaogui/comparison.png)可查。蝴蝶结在游戏尺寸下可辨认；原版头盔会遮挡头顶，宽龟脸在全罩盔右缘仍有外露，尚未实机验收。

2026-09-27 可可补充更新：根据用户提供的[两张本人照片](../../references/2026-09-27-keke/README.md)，改为圆润脸型、柔和眉眼、薄刘海和低双马尾，保留红褐围巾与棕皮肩衣。选用 [keke-photo-v2.png](sources/user-v17/keke-photo-v2.png)，前版 [keke.png](sources/user-v17/keke.png)保留；[实际提示词](PROMPTS-keke-photos-v17.json)与[新旧／装备叠加对比](../../../build/playtest-keke/comparison.png)可查。已做游戏尺寸、完整下颌颈部及装备叠加的离线检查，尚未实机验收。

2026-09-27 美伢补充更新：根据用户新提供的[四张本人照片](../../references/2026-09-27-meiya/README.md)，重绘更自然的脸型、眉眼、鼻形和唇形，保留长黑发、朝右姿态与原有衣装。选用 [user-v17/meiya.png](sources/user-v17/meiya.png)，旧版源图保留；[精确生图记录](PROMPTS-meiya-v17.json)和[新旧／装备叠加对照](../../../build/playtest-meiya/comparison.png)可查。沿用 114×142 画布及原画刷 ID；已做离线导出与装备叠加检查，尚未实机验收。

现行 34 位成员，包含正常阿飞的蛤蟆路线别名共 36 组主体画刷、144 张分层图。蛤蟆原画与头顶飞碟已停用，转职玩法不变。

现有源图等比缩到最大 88×100，放入 114×142 槽。v0.12 取消固定 y=102 的横切，改为每幅图在 manifest 内记录的颈部折线：保留完整下巴，中央延伸至衣领，两侧让位于护甲。身体在原版护甲下，脸、自绘头发和颈部在护甲上、头盔下；原版武器、盾牌、护甲和头盔随实际装备显示，原版发型和胡须继续隐藏。

本轮以用户提供的五张图片为参考，使用内置 ImageGen 重绘小月牙、溺水小龟、亿口甜筒、瑶瑶牙和美伢；其他人的源图保持不变。[前四人生成记录](PROMPTS-user-v12.json)、[美伢生成记录](PROMPTS-meiya-v12.json)与[更新和验证范围](../../../docs/playtest-0.12.md)保存完整输入、输出和检查边界。

- [全员游戏尺寸检查](build/index.html)：完整胸像预览；实际战斗还会叠加装备。
- [历史照片／v0.4／v0.6 逐人对照](review/likeness.html)：保留旧照片研究；最新五人选图以 manifest 为准。
- [全员颈部及装备对照](../../../build/playtest-neck/index.html)、[五人预览](../../../build/playtest-neck/five-member-preview.png)：按原版锚点离线合成，不等于实机验收。
- [精确提示词](PROMPTS.md)：保留照片校正、简化返修和朝向修图的实际调用历史。
- [运行时映射](manifest.json)及[图集打包核验](build/report.json)：144 个精灵，包含身体、头部、兼容完整倒地图及独立倒地头部画刷。
- [v0.7 更新与实机记录](../../../docs/playtest-0.7.md)：三队长开局、战场装备叠加、大小对照及验证边界。

## 来源与兼容

v0.5 按公开照片校正了 29 位成员、30 幅主体（含阿飞嘉豪）。v0.12 补入用户指定的小月牙、亿口甜筒、瑶瑶牙、美伢参考及小龟吉祥物设计；这些图片作为用户指定的创作依据，不声称已经核验其来源。v0.6 修订全部源图的头、胸肩与视线朝向，[朝向记录 A](PROMPTS-facing-a.json)和[朝向记录 B](PROMPTS-facing-b.json)保存完整调用与额外返修。后续停用蛤蟆图不删除这些历史记录。

保留 `afeix_p04_*` 画刷与 `afeix_portraits_v04` 图集文件名，本轮不改变存档 Schema（仍为 8）。源图位于 `sources/`、`sources/facing/` 与 `sources/user-v12/`，以 manifest 的实际选择为准。原版参考像素、照片和历史母图不进入安装包。[照片来源与待补项](../../references/2026-09-26-likeness/README.md)单独保存。

按 alpha 阈值 20 取透明边界，等比缩放、底部定位；头和身体逐像素合成后等于完整图。v0.21 的 `_corpse_head` 与当前 `_head` 像素完全相同，使用独立颈部连接支点及运行时仰倒角度，接在原版躯干和装备上；`_dead` 为旧资源兼容保留。没有重绘逐人闭眼表情。尸体保留原版随机翻转；斩首、碎颅、吞噬不补回完整头部，昏迷者战后恢复正常外观。[六人对照](../../../build/playtest-corpses/comparison.png)与[全员检查](../../../build/playtest-corpses/all-members.png)为离线合成，不能代替实机验收。

旧版母图、中间修图、[姿态修订前映射](manifest-before-facing.json)、[v0.4 包](../../../dist/archive/v0.4/mod_afeix_expedition.zip)、[v0.5 包](../../../dist/archive/v0.5/mod_afeix_expedition.zip)和[v0.6 包](../../../dist/archive/v0.6/mod_afeix_expedition.zip)均保留。尚未逐一验收全部成员与全部头盔组合。
