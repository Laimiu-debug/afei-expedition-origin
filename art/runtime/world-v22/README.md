# 阿飞大地图行军图标

使用内置 image_gen，以现有阿飞正常形态作身份参考，原版 `figure_player_01` 只作大地图轮廓与尺寸参考。保留朝右的短黑发、炭灰肩披与米色绗缝衣领。

- [生成源图](sources/afei-map.png)
- [完整提示词及参考记录](PROMPT.json)
- [审阅与导出映射](manifest.json)
- [40×46 游戏精灵](sprites/afeix_world_afei.png)
- [原版／阿飞双向／扎营离线对照](../../../build/playtest-world-afei/comparison-3x.png)

`tools/build_world_art.py` 只按透明边界裁切、等比缩小并放置，保留生成的 alpha。画刷沿用原版 40×46 内容区域、68×106 逻辑画布与 offsetY=20，单独打包为 `afeix_world_v22` 图集。原版参考像素不进入安装包。

地图统一用正常阿飞作为战团标识，转职不切换地图造型；图标不表示重新生成或复活角色。左右翻转交给原版 party 的方向逻辑，旗帜、底座、营地与火光使用原版。图集像素、支点和运行时切换已离线检查；本页预览不是实机截图。
