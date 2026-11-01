# 斗鱼传奇战利品美术

可分发资源由 `tools/build_douyu_trophy_art.py` 导出。源图由内置 imagegen 生成，经过人工检查后，在 `manifest.json` 中记录 SHA-256 并标为 `reviewed_for_export`。导出只执行透明边缘裁切、等比缩放、透明画布摆放及砍刀库存图的水平镜像，不重绘源图。

八张源图分别是鲨衣库存、完整胸像、受损胸像、尸体覆甲，以及双手砍刀和单手矛的完整与沾血版本。鲨衣的战场覆甲使用专用胸像，不用库存图替代。两把武器的库存与持握图使用同一完整源图，持握版采用原版双手砍刀、战矛的坐标和动作参数。

库存大图为 70×140，小图为 70×70。脚本使用 `armor/afeix_douyu_sharkskin.png` 等路径，实际文件存于 `src/gfx/ui/items/`。七个战场画刷保存在独立 `afeix_douyu_trophies_v01` 图集。

原版参照只在 `.cache/afei-art/douyu-trophy-reference/`；不会写入源图、导出图集或分发包。`preview.png` 和 `preview-2x.png` 使用新装备及已有自制阿飞立绘，以实际画刷坐标检查叠加；它们是离线检查图，并非游戏截图。

构建：`python tools/build_douyu_trophy_art.py`。工具会校验源图审批与指纹、PNG 导出、画刷坐标，以及图集解包后的像素。实际游戏中的护甲附件、伤损、尸体、左右转向与武器持握仍需验收。
