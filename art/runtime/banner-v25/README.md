# 蛤蟆专属旗帜

由内置 imagegen 生成透明母图，参考原版旗帜的绘画风格与悬挂结构，蛤蟆图案为新生成内容。只打包自制图像；手持旗杆引用原版已有资源。

现有五款均已接入 Mod：首版黑金蛤蟆，加上[四款新图](variants/README.md)。F8 → 战团事务 → 更换旗帜，选择随存档保存。

使用 `tools/build_banner_art.py` 按原版旗帜锚点导出全部五款的大地图、手持战旗与 UI 图。已检查生成图与游戏尺寸导出；实机渲染仍待验收。

## 生成提示词（内置工具）

Use case: stylized-concept. Asset type: transparent 2D game sprite for a Battle Brothers company banner, subsequently downscaled for world map, UI, and a carried battle standard. Input image is a STYLE AND SILHOUETTE REFERENCE ONLY: use the same readable medieval hand-painted outlined style, front-on hanging cloth proportions, hanging metal rings and small horizontal crossbar; create an ORIGINAL design, not a copy of its emblem. Primary request: 蛤蟆专属旗帜 for the black-flag mercenary company. A tall weathered charcoal-black cloth gonfalon, broad simple pale gold stitched border, with one bold large muted jade-green squat TOAD heraldic emblem centered on the cloth, two bulging amber eyes, broad grumpy mouth, visible crouched legs and a few simple wart marks. Toad must read clearly at 40 pixels tall. Cloth bottom ends in two modest pointed tails. Top ring suspension, bronze/iron crossbar. No long vertical flagpole, no ground shadow, no scene, no text, no watermark. Full banner completely inside canvas with small transparent margins. Native true transparent alpha background. Restrained dark medieval palette, compact broad flat shading, strong contour lines. The central frog should fill the available cloth and look assertive rather than cute.
