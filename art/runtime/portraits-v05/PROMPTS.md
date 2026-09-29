# 朝右战斗胸像：实际生图提示词与 v0.12 接入规则

v0.12 使用用户提供的五张参考图，以内置 ImageGen 重绘小月牙、溺水小龟、小虎、瑶瑶牙和美伢。全员取消固定 y=102 横切，改用逐人颈部轮廓分层；其余成员保留既有源图，游戏尺寸、装备叠加和旧存档画刷 ID 不变。

v0.7 没有重新生图：将现有源图等比缩到最大 88×100，放入 114×142 槽，在颈部拆成身体和头部，恢复原版武器、盾牌、护甲与头盔叠加。蛤蟆原画和头顶飞碟停用，转职玩法保留。下文保留真实生成历史，不把后续技术处理写成新的生图调用。

v0.19 新增小龟禁戴头盔、厚壳与天生钢头；刘青松仅为照片参考的相遇 NPC，没有加入本战斗胸像图集。新事件头像与红装提示词见 [本轮实际提示词](../../art/runtime/ideas-v19/PROMPTS.json)，规则见 [v0.19](../playtest-0.19.md)。

照片只负责本人脸型、眉眼、发际线和发型；画法参考《战场兄弟》官方胸像。源图使用少量宽阴影、粗轮廓、低饱和衣物和短肩大头比例，最终按 114×142 输出。

当前映射中 25/36 幅采用 v0.6 朝右姿态修订。头部、胸肩和视线共同朝画面右侧，保留原有个人特征与衣装；每人仍使用包含自绘头发、脸和衣服的一张透明胸像。下面逐次保留实际调用、参考输入、原始输出及局部返修，不能把提示词记录当作实机通过证明。

此前缺参考的四位人类成员本轮已收到用户指定图片；图片仅作美术依据，不声称已核验其来源。小龟使用用户指定吉祥物。蛤蟆立绘与头顶飞碟已于 v0.7 停用，转职玩法保留。

姿态修订前的选择见 [manifest-before-facing.json](manifest-before-facing.json)，原始源图继续保留；`afeix_p04_*` 画刷与 `afeix_portraits_v04` 图集名称不变。参考照片与官方画风样本不打入游戏包。

当前 34 名成员均有专属胸像；罗一可按本轮用户照片重绘，眼子按仓库既有 Sylar 海报绘制。

## 来源与选择

|成员／形态|本轮处理|源图|
|---|---|---|
|阿飞 · normal|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/afei_normal.png`|
|阿飞 · toad|蛤蟆立绘已停用；旧画刷只作为正常阿飞外观的兼容别名，转职玩法保留。|`art/runtime/portraits-v05/sources/facing/afei_normal.png`|
|阿飞 · jiahao|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/afei_jiahao.png`|
|王大谋|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/damou.png`|
|午夜抹抹茶|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/mocha.png`|
|小酒瓶|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/bottle.png`|
|白小帅子|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/shuaizi.png`|
|李李超欧|按用户指定李李参考重绘短棕发、温和眉眼与足球发卡；简洁素装，无固定弓箭。透明朝右胸像，已检查原尺寸及原版装备叠加，未实机验收。|`art/runtime/portraits-v05/sources/user-v18/lili.png`|
|小月牙|按用户照片重绘黑色长发、清秀椭圆脸与自然眉眼，替换旧蓝发造型；朝右，完整颈部。|`art/runtime/portraits-v05/sources/user-v12/xiaoyueya.png`|
|余初九|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yuchujiu.png`|
|小鱼贝壳|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaoyubeike.png`|
|王怼怼|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wangduidui.png`|
|老蔡|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/laocai.png`|
|眼子|内置 ImageGen 按仓库 Sylar 活动海报右侧人物绘制，黑短发与本人五官，短肩剑盾旅装。|`art/runtime/portraits-v05/sources/blue-team-v24/yanzi.png`|
|小虎|按用户照片中央人物重绘浅棕短波波头、圆润脸颊和眼睛；移除旧眼镜与深色长发。|`art/runtime/portraits-v05/sources/user-v12/tiantong.png`|
|小宁|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaoning.png`|
|小胖|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaopangxu.png`|
|大鹅|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/dae.png`|
|蔓越莓|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/manyuemei.png`|
|罗一可|内置 ImageGen 按用户罗一可照片绘制，人类长发、侧刘海与软面颊，梅紫围巾和小粮袋。|`art/runtime/portraits-v05/sources/blue-team-v24/luoyike.png`|
|可可|根据用户提供的两张可可照片重绘圆润紧凑脸型、柔和眉眼、小巧鼻唇、薄刘海与低双马尾；保留红褐围巾、棕皮肩衣、月形搭扣、朝右姿态和完整下颌短颈。已检查游戏尺寸及装备叠加，尚未实机验收。|`art/runtime/portraits-v05/sources/user-v17/keke-photo-v2.png`|
|余想|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yuxiang.png`|
|童猪|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/tongzhu.png`|
|美伢|根据用户提供的四张美伢正侧面照片校准长椭圆脸、细弧眉、自然杏眼、鼻形与轻微笑意；收敛旧稿粗眉和噘嘴。保留近中分长黑发、朝右姿态、棕皮肩衣和完整下颌颈部；不将帽子画入基础层。|`art/runtime/portraits-v05/sources/user-v17/meiya.png`|
|玩蛇|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wanshe.png`|
|涂涂|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/tutu.png`|
|奶盖|按四张用户照片校正奶盖的齐下巴黑色短发、柔和脸型与眉眼唇形；保留棕色短披肩。透明朝右胸像，已检查原尺寸及原版装备叠加，未实机验收。|`art/runtime/portraits-v05/sources/user-v18/naigai.png`|
|小杰|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaojie.png`|
|bula|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/bula.png`|
|苏袜|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/suwa.png`|
|千涵|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/qianhan.png`|
|王大芷|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wangdazhi.png`|
|瑶瑶牙|按用户要求将露肩裹胸改为遮住双肩、胸口和上臂的米白色素衣；保留黑长发、面容、朝右姿态及原画风。|`art/runtime/portraits-v05/sources/user-v23/yaoyaoya.png`|
|羊咩咩|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yangmiemie.png`|
|宋暖阳|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/songnuanyang.png`|
|溺水小龟|按两张用户吉祥物图及明确要求重绘：保留醒目亮粉蝴蝶结，提亮浅苹果绿皮肤和奶黄色腹甲，圆脸笑容、绿色斑纹、粉色爪印。朝右，保留龟壳和皮带；不加入直播设备与球队元素。蝴蝶结在游戏尺寸可辨认；全罩头盔右缘仍有龟脸外露，尚未实机验收。|`art/runtime/portraits-v05/sources/user-v17/xiaogui.png`|

以下照片与官方画风参考只保存在研究目录，不打入游戏包。装饰、服装与幻想种族属于游戏设计，不宣称是真实人物穿着。

## 阿飞 · normal

- 最终文件：`art/runtime/portraits-v05/sources/facing/afei_normal.png`
- SHA256：`1f291f548b542473f3d66acc311ef579337199251545e3aff6aee5f330121f50`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/afei_normal.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/afei_normal.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-86e8a12d-0203-47cb-a04c-ba684a6f1825.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: ���� (normal).
```

完整机器记录：[PROMPTS-root-selected.json](PROMPTS-root-selected.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/afei/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-cb5b46ae-0b4d-4f23-9bb1-38bbf409172a.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

Subject-specific invariants and costume:
Keep the photographed adult man's longer oval face, broad forehead, short black upward brushed hair, rather straight slim eyebrows, narrow alert eyes, straight nose, and softly asymmetric closed-mouth half smile. Calm roguish confidence, not exaggerated scowling. Gray-beige plain gambeson and short charcoal shoulder mantle fastened with a small dull brown buckle; NO spikes, armor spectacle or new face scars.
```

### 调用 2

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/attempts/afei_normal-photo-like-v1.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-5965c3a6-5fba-45a2-a869-49e75894e883.png`

```text
Use case: style-transfer. IMAGE 1 is the EDIT TARGET: a recognizable person's painted bust that is STILL MUCH TOO REALISTIC. IMAGE 2 is the exact required BATTLE BROTHERS small tactical sprite drawing style. Change the rendering into a simple small 2D game pawn enlarged; keep the person's distinctive facial outline, eye spacing and shape, nose shape, mouth expression, hair silhouette and costume from image 1. Do not borrow a face from image 2.
Most important correction: DRAMATICALLY SIMPLIFY the face, hair and clothes. Replace all photo-like modelling and speckled/painterly skin with a FLAT warm base color plus ONLY TWO large deliberate shadow shapes. Each cheek is one simple shape. Eyes are a small dark upper-lid mark, a tiny pale flat shape and a dark pupil; no wet eyeball shading or realistic eyelid anatomy. Nose is a single dark side plane and simple nostril marks. Lips are a single curved dark mouth stroke with a small lower shadow, no realistically modeled lipstick. Thick irregular dark-brown outer contours and selective interior strokes. Hair in FIVE TO EIGHT chunky painted clumps, no individual strands, no textured brush hatching. Clothing in a handful of broad color patches with just a few major seams and folds. Lose 80 percent of the rendering detail while retaining this person's face proportions. Do not make the eyebrows angry, face sharp or eyes anime-large. Do not paint a beauty portrait or an oil painting.
Complete integrated large-head short-shouldered bust, like image 2, with a very short neck and rounded cropped chest. Three-quarter facing SCREEN RIGHT, both eyes visible. If image 1 faces left, re-draw the view to face right while preserving identity. NO new accessories, medieval costume unchanged. No anime or flat vector logo, no photorealism, no grain filter, no stippled skin. True transparent background, clear margin, no text or scenery.
```

## 阿飞 · toad

- 最终文件：`art/runtime/portraits-v05/sources/facing/afei_normal.png`
- SHA256：`1f291f548b542473f3d66acc311ef579337199251545e3aff6aee5f330121f50`
- 选用记录：蛤蟆立绘已停用；旧画刷只作为正常阿飞外观的兼容别名，转职玩法保留。

不再使用蛤蟆原图；复用上面的正常阿飞源图，旧画刷 ID 仅用于存档兼容。

## 阿飞 · jiahao

- 最终文件：`art/runtime/portraits-v05/sources/facing/afei_jiahao.png`
- SHA256：`96358d2401b0a9d956547ac72186901894f5648d82cceff2012343ed3b252f62`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/afei_jiahao.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/afei_jiahao.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-016978bb-81b6-4d31-81b4-58d919e27026.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: afei (jiahao).
```

完整机器记录：[PROMPTS-promotion.json](PROMPTS-promotion.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/afei_normal.png`
- `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-jiahao-promoted-v01.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-806ca9e2-0e42-44c9-b5e5-f2b68c5edead.png`

```text
Use case: identity-preserving costume edit for a Battle Brothers tactical bust. Image 1 is the selected NEW Afei normal portrait, the exact same man's face and hair to preserve. Image 2 is the OLD promoted costume, use clothing design ONLY, not its face or haircut. Image 3 is official Battle Brothers proportions/style reference. Keep the new Afei's longer oval face, slim nearly straight brows, narrow eyes, straight nose, hairline and short brushed-up black hair. Give him a slightly more assured asymmetric half-smile and focused eyes, not a new man. Change clothing to sturdy brown riveted leather shoulders, dark charcoal short captain mantle with muted burgundy edge and dull brass rectangular clasp like image 2. Simple few broad shadows, rough darkbrown outline, no realistic skin, no glossy eyes, no fabric microtexture. One compact head/neck/shortshoulders tactical pawn, screen RIGHT mild three-quarter, large head about60percent of whole bust height, base ends at upperchest. Keep transparent margin, opaque figure, no hands, weapons, background, text, UFO or other objects. This is a human commander promotion, a deliberate costume upgrade over image1 while matching its drawing economy. Transparent background.
```

## 王大谋

- 最终文件：`art/runtime/portraits-v05/sources/facing/damou.png`
- SHA256：`159d4a14a1744544e486bd3c10a390de0f3d599bdb37afe935b4e5fe90f8c729`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/damou.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/damou.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-1e49ff5a-fb8f-4ab2-af73-59e76db44a18.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: ����ı (default).
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/damou/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-bef3973f-b893-4853-a108-ae88e285cd7b.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Preserve this adult man's broad rounded cheeks, short dark fluffy forward fringe (NOT purple), low flat brows, narrow eyes and small relaxed mouth. Remove headphones. Keep short dark-green scarf over brown padded leather shoulders, calm grounded expression. Do not sharpen his jaw or copy Afei face.
```

## 午夜抹抹茶

- 最终文件：`art/runtime/portraits-v05/sources/facing/mocha.png`
- SHA256：`beb634bfdb0a378cac73fd71dbef4b4eeaccbb31c24d52a4bec3af4164f9f4bd`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/mocha.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/mocha.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-90af4bf7-594d-4a3e-84fe-e66f0e221650.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: mocha (default).
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/mocha/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-b553b8d7-c2c4-44cb-93ce-bebd20167ffc.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Preserve adult man's longer oval cheeks with a rounded chin, short light-brown hair swept up and to the side, fine gently curved brows, narrow almond eyes, small straight nose, naturally full soft mouth. Confident almost-smile. Worn green-brown medieval merchant leather with one dark buckle; no glasses because selected photograph has none. Do not copy Afei V eyebrows or modern jacket.
```

## 小酒瓶

- 最终文件：`art/runtime/portraits-v05/sources/facing/bottle.png`
- SHA256：`350773547e853fa2a6c36db74d0ed53bf1a3bbeb07df427c689183b2c5872893`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/bottle.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-9a11b1d9-050b-44b6-b6e1-ac17db8d85ec.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: bottle (default).
```

完整机器记录：[PROMPTS-root-selected.json](PROMPTS-root-selected.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/bottle/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-e565ad34-37f2-439b-ae80-4367c21f7b70.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

Subject-specific invariants and costume:
Keep the photographed adult woman's narrow soft oval face and tapered chin, long dark brown hair with top section loosely tied back and two thin face-framing locks, gentle slender brows, slim almond eyes and small understated mouth. Composed warm expression, not angry. Simple dark charcoal quilted high collar with a tiny brass fastener. Omit the modern headset, cables and microphone. Do not give her a beauty-model angular jaw or elaborate jewelry.
```

### 调用 2

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/attempts/bottle-photo-like-v1.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-f4134878-5750-42c5-977f-bedbafe8f0cc.png`

```text
Use case: style-transfer. IMAGE 1 is the EDIT TARGET: a recognizable person's painted bust that is STILL MUCH TOO REALISTIC. IMAGE 2 is the exact required BATTLE BROTHERS small tactical sprite drawing style. Change the rendering into a simple small 2D game pawn enlarged; keep the person's distinctive facial outline, eye spacing and shape, nose shape, mouth expression, hair silhouette and costume from image 1. Do not borrow a face from image 2.
Most important correction: DRAMATICALLY SIMPLIFY the face, hair and clothes. Replace all photo-like modelling and speckled/painterly skin with a FLAT warm base color plus ONLY TWO large deliberate shadow shapes. Each cheek is one simple shape. Eyes are a small dark upper-lid mark, a tiny pale flat shape and a dark pupil; no wet eyeball shading or realistic eyelid anatomy. Nose is a single dark side plane and simple nostril marks. Lips are a single curved dark mouth stroke with a small lower shadow, no realistically modeled lipstick. Thick irregular dark-brown outer contours and selective interior strokes. Hair in FIVE TO EIGHT chunky painted clumps, no individual strands, no textured brush hatching. Clothing in a handful of broad color patches with just a few major seams and folds. Lose 80 percent of the rendering detail while retaining this person's face proportions. Do not make the eyebrows angry, face sharp or eyes anime-large. Do not paint a beauty portrait or an oil painting.
Complete integrated large-head short-shouldered bust, like image 2, with a very short neck and rounded cropped chest. Three-quarter facing SCREEN RIGHT, both eyes visible. If image 1 faces left, re-draw the view to face right while preserving identity. NO new accessories, medieval costume unchanged. No anime or flat vector logo, no photorealism, no grain filter, no stippled skin. True transparent background, clear margin, no text or scenery.
```

## 白小帅子

- 最终文件：`art/runtime/portraits-v05/sources/facing/shuaizi.png`
- SHA256：`eb7d03bb759faa9d8ac05cb6d14c863b37e60a253b4654178ade94faba948b7a`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/shuaizi.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/shuaizi.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-d5f1a6fa-e3c1-4ac4-a031-29f7e0e10e42.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: shuaizi (default).
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/shuaizi/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-24be2589-1b90-4017-bc0b-2ca8028507d4.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Adult woman with long dark hair half-tied into a compact high knot, open forehead, soft longer oval face, gentle almond eyes and small mouth slightly parted. Replace fluffy modern headband with narrow gray cloth tie while keeping hair shape. Brick-red neck scarf, muted leather and a tiny round drum chest medallion. No invented braids, angry brows, headset or musical instrument.
```

## 李李超欧

- 最终文件：`art/runtime/portraits-v05/sources/user-v18/lili.png`
- SHA256：`181ad42c05cc78892753e0b4bc37ea25e8c5a0130015ec0bad9b43c3c24d1ea9`
- 选用记录：按用户指定李李参考重绘短棕发、温和眉眼与足球发卡；简洁素装，无固定弓箭。透明朝右胸像，已检查原尺寸及原版装备叠加，未实机验收。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/lili.png`
完整记录：[PROMPTS-lili-v18.json](PROMPTS-lili-v18.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/character-concepts/lili/lili-football-plain-v01.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/facing/lili.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e1aa-5e78-74d0-a826-eb755a8f575e/exec-954d485e-3f97-4bb6-ae60-78df086b9f84.png`

```text
Use case: style-transfer / identity-preserve.
Asset type: PRODUCTION transparent Battle Brothers tactical game pawn for 李李超欧, not an illustration, poster or concept sheet.
Input roles:
Image 1 is ONLY the user-chosen facial identity, short chestnut bob hairstyle, gentle smile and BLACK-AND-WHITE SOCCER BALL HAIR CLIP design; keep these distinctive traits. Its realistic rendering, front-facing pose and long torso are NOT suitable for the game and must be changed.
Image 2 is ONLY the official game's economical hand-painted rendering and compact pawn proportions. Never copy its male faces, beard or bare chest.
Image 3 is ONLY the existing sprite's crop and equipment-compatible shoulder/head silhouette reference. Do NOT copy the old black hair, flower accessory or face.

Create ONE connected head-neck-shoulders bust with actual transparent alpha background. Turn the entire head, chest, shoulders AND eye gaze clearly toward SCREEN RIGHT by about 35 degrees: right-facing three-quarter view, both eyes visible, far eye smaller, nose displaced rightward. No head tilt.
Preserve the identity from image 1: adult young woman with soft oval face, warm brown almond eyes, gentle eyebrows, small rounded nose, natural lightly smiling closed lips, chestnut short chin-length bob with loose fringe. Hair in 6 to 8 broad angular masses. Add ONE readable round black-and-ivory soccer-ball hair clip at the SCREEN LEFT temple, within the hair silhouette, about one fifth of the head width; clear black pentagon markings, a flat wearable ornament. No flower hairclip.
Strict GAME PROPORTIONS: large head accounts for approximately 70 percent of total nontransparent bust height; very short but complete connected neck; narrow compact sloping shoulders and a shallow curved chest base. The full head and neck above the collar are readable. The bottom portion is only a small shoulder-and-collar pedestal, NOT a full upper-body illustration. Rounded bust base, no cut jaw or floating head. The character will be uniformly reduced to at most 88 x 100 visible pixels in a 114 x 142 sprite. Design every mark for THAT size. Head must fit inside standard game helmet footprint.
Outfit: simple low-collared muted beige medieval cloth tunic, subtle brown neckline with two simple cord strokes, no bulky collar or scarf. NO bow, arrows, quiver, weapons, armor, bags, diagonal straps, flower brooch or jewelry. Equipment will be overlaid by the game.
STRICT PAINT STYLE: economical matte hand-drawn Battle Brothers pawn. Thick dark-brown irregular silhouette contour. Flat warm skin base plus TWO or THREE large shadow planes at most. Eyes simplified to small painted eyelid strokes and dark brown pupils, no glossy eyeballs or many highlights. Nose indicated by one simple shadow plane. Lips one soft short line. Hair broad shaded clumps, no fine individual strands. Cloth 3 broad color blocks, no textile grain, no embroidery details or realistic wrinkles. Remove all photographic/rendered-skin texture, avoid realistic glamour portrait and anime. Keep the user's recognizable proportions and friendly expression while strongly simplifying.
ONE sprite only, centered with transparent margin around all edges. Actual transparent background, no white rectangle, no checkerboard baked in, no cast shadow, glow, border, watermark, text, panels, hands, arms or legs. Complete uncut hair, clip, jaw, neck and compact shoulder base.
```

颈部分界：`[[0, 109], [35, 109], [48, 114], [57, 123], [73, 123], [85, 114], [95, 109], [114, 109]]`。原图只作等比缩放和无损分层。

## 小月牙

- 最终文件：`art/runtime/portraits-v05/sources/user-v12/xiaoyueya.png`
- SHA256：`10c5a2919f55a840ae9cf10287f9f4e109847a66656ee53f27099d5ade3ae681`
- 选用记录：按用户照片重绘黑色长发、清秀椭圆脸与自然眉眼，替换旧蓝发造型；朝右，完整颈部。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/xiaoyueya.png`
完整记录：[PROMPTS-user-v12.json](PROMPTS-user-v12.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-user/xiaoyueya.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-5b6a94d1-434e-443d-b36b-00e31470a367.png`

```text
Use case: stylized-concept. Create ONE production-ready Battle Brothers game bust sprite on a genuinely transparent background. Image 1 is the user's identity/design reference ONLY. Image 2 is the official Battle Brothers STYLE AND PROPORTION reference ONLY; do not reproduce any of its men. Match its rough hand-painted 2D mercenary-token style: strong dark brown outlines, economical broad shadow planes, muted earthy colors, visible brush character, slightly exaggerated head and short cropped shoulders, readable at only 88 by 100 pixels in game. NOT photorealistic, NOT 3D, NOT smooth anime/gacha or cinematic portrait. Entire head, nose, eyes, neck, chest and shoulders face SCREEN-RIGHT in consistent three-quarter view, both eyes visible but nose projects to the right, no eye contact with viewer. One continuous compact bust from complete hair crown through a visible intact neck into short shoulders and an oval cut across upper chest. Head, chin and neck must NOT be cropped or severed; leave a clearly drawn neck connecting jaw to collar. Head occupies upper 60 percent of silhouette, neck/collar transition around 68 percent, short torso the bottom 30 percent. Keep ears/crown compatible with an overlaid game helmet; no raised arms, hands, full body, weapons, shields or floating props. Center with small empty margins. Simple low dark cloth neckline below the jaw, no thick scarf covering chin. No background, floor, shadow, text, logos, poster graphics or watermark. Paint all pixels freshly; do not paste photographs. Adult East Asian woman from image 1: long almost-black straight hair with a slight side part and loose soft locks at cheeks, slim oval face with gently pointed chin, dark almond eyes, soft straight brows, small rounded nose, natural full lips slightly parted, reserved quietly alert expression. Preserve her recognizable facial proportions without beautifying into a generic anime face. Dark hair must stay black-brown, NO blue ponytail, NO stars. Simple faded blue-grey linen neckline and plain brown leather shoulder straps, no jewelry.
```

颈部分界：`[[0, 108], [35, 108], [48, 113], [57, 122], [73, 122], [85, 113], [95, 108], [114, 108]]`。原图只作等比缩放和无损分层。

## 余初九

- 最终文件：`art/runtime/portraits-v05/sources/facing/yuchujiu.png`
- SHA256：`e1f8c0c821f1ad2b220759c6e8bc2db93c96bfa5eaf009fe30c4159e183c92cc`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/yuchujiu.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/yuchujiu.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-bf5a6a71-f4fb-4d5b-9cf7-bcb6ac1f9015.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: yuchujiu (default).
```

完整机器记录：[PROMPTS-root-selected.json](PROMPTS-root-selected.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/yuchujiu/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-5ceb79b2-828a-48ab-b946-476a06b9ae73.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific invariants and costume:
Preserve the photographed adult woman's small soft oval face, short tapered chin, chestnut-brown long hair with lightly separated forehead bangs, gentle low eyebrows, dark round-almond eye shape and small slightly parted mouth. Translate beauty-filtered photo into simple game eyes without enlarging them further. Warm cream short padded tunic with muted teal neckline and tiny paw-shaped brass clasp, a slim cream cloth hair band; compact shoulders and natural quiet expression. No anger, extra aging, pointed ears, fashion makeup or anime gloss.
```

## 小鱼贝壳

- 最终文件：`art/runtime/portraits-v05/sources/facing/xiaoyubeike.png`
- SHA256：`2767800440cf8e1d7cb94fe58d953fccfd7e2db75d21a892804ef1e9ce6ee7f0`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/xiaoyubeike.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/xiaoyubeike.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-37a7f295-7e3a-46a1-b608-9cd30cb5308a.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: xiaoyubeike (default).
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaoyubeike/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-95742e90-d4e0-431c-bfbe-7f8e32ca3830.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Preserve adult woman's dark brown shoulder-length hair with long curtain fringe, soft oval face with round cheeks, slender nearly flat eyebrows and dark rectangular spectacles. Relaxed thoughtful eyes, small quiet mouth. Glasses simple non-glossy dark frame. Plain gray linen neck and dark olive leather vest, tiny shell clasp; NO hood over hair. Omit smartphone and sofa.
```

## 王怼怼

- 最终文件：`art/runtime/portraits-v05/sources/facing/wangduidui.png`
- SHA256：`ea24c1b3c96e5baf6e6e42887aed9a9fb55ba667132612cd26dcf98726e0c4da`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/wangduidui.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/wangduidui.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-5b2f4850-597b-44e9-8b2c-9a54fde1c912.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: wangduidui (default).
```

完整机器记录：[PROMPTS-supplement.json](PROMPTS-supplement.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/wangduidui/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0dd45-fffa-72e3-8ad7-af136bf168c3/exec-813aa6d8-62f9-48da-ad7a-e41fc889c549.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman IU王怼怼 in Image 1. Retain her current dark brown chin-to-neck-length side-parted bob with slightly outward ends, soft full cheeks and rounded jaw, gently level brows, narrow natural eyes, and small slightly open lips. Both eyes readable; do not copy the photograph's low upward camera angle, but keep her own features. Ordinary level-headed alert expression. Outfit: muted dusty-purple short cloth drape over simple brown leather shoulders with one small pale flower clasp low on the collar. Hair is the photographed short bob, NOT the old long-haired design. No modern jewelry or bag strap.
```

## 老蔡

- 最终文件：`art/runtime/portraits-v05/sources/facing/laocai.png`
- SHA256：`e443245e266897f7c036787d756acd66d598c06c1eac241d347300fad9db597b`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/laocai.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/laocai.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-42534849-404d-4bdb-a1c2-b8afc21b6baf.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: laocai (default).
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/laocai/official-vod-20250118-face-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-db842eb0-7115-42a9-bcfa-61f3be005c0e.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult male streamer in image 1, 老蔡 / 川神, with his broad soft round face, full cheeks, short straight black hair swept to one side with a small forehead fringe, small naturally narrowed eyes and compact nose; clean-shaven. Preserve his ordinary slightly puzzled, unforced mouth, not an aristocratic sharp-jawed male hero. Remove the modern headphones and printed shirt. Clothing: muted slate-blue wool standing collar with gray shoulder cape and a plain brown fastening, compact medieval adviser bust. No scroll, map, logos or written marks. Keep the whole hair silhouette visible.
```

## 眼子

- 最终文件：`art/runtime/portraits-v05/sources/blue-team-v24/yanzi.png`
- SHA256：`d400d587157b2329e41770b412ccd12b0bbdb051f12eacf0024489f2b8ef459b`
- 选用记录：内置 ImageGen 按仓库 Sylar 活动海报右侧人物绘制，黑短发与本人五官，短肩剑盾旅装。

### 蓝队个人头像 · 内置 ImageGen

仓库既有 Sylar 活动海报，右侧人物，仅用其五官与发型，不是新提供近照。

完整记录：[PROMPTS-blue-team-v24.json](PROMPTS-blue-team-v24.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-25/sylar-huya-2019.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e72b-fd93-7953-983b-9f4b33075dd2/exec-b8c1566b-9e1b-42db-a6ad-9811e484fecd.png`

```text
Use case: stylized-concept / identity-preserve. Asset type: one finished transparent head-and-short-shoulders bust for a Battle Brothers mod, readable as 88x100 painted pixels within a 114x142 game frame. Follow reference 1 for the person's identity only. Reference 2 is official Battle Brothers STYLE AND PROPORTION guidance only; do not copy its people, bare torsos or assets. Make original painted artwork with a large head, narrow very short fully clothed shoulders, economical dark brown outlines, broad 3-4 tone planar shadows, muted natural skin, earthy medieval fabrics. No photographic skin detail, airbrushed beauty, anime eyes, 3D render, polished gradients, modern clothes, logos or text. Full hair crown and rounded bottom visible with margins. Face, nose, gaze, neck and chest consistently three-quarter toward SCREEN RIGHT; both eyes visible, eyes look right not at viewer. Keep the entire chin and an intact short bare neck clearly above the low clothing collar; head occupies about 70% of visible silhouette height, upper chest only bottom 20%. No arms, hands, weapons, background scene, ground shadow, border, labels or watermark. Genuinely transparent RGBA background, a single complete bust asset.
Character: 眼子哥 (Yanzi / Sylar), the adult East Asian man on the RIGHT of reference 1, the yellow/black gaming promotional poster. Follow his recognizable proportions: slim oval face with fuller upper cheeks, gently tapered chin, straight medium brows, narrow relaxed dark eyes with soft lower lids, small straight nose, restrained slightly wry closed smile. Preserve his dense short black hair with an uneven side-swept fringe across the forehead and compact sideburns; clean-shaven, no beard or mustache, no eyewear. Adapt the earlier photograph into a mature but youthful adult, do not age into an elderly veteran. Medieval outfit: low slate-blue cloth collar below a visible short neck, charcoal padded jerkin with a simple diagonally crossing brown leather strap and plain small brass clasp. No paper/prop covering face or neck. His expression is attentive and dryly amused, not arrogant or stern. Large tactical-game head and short shoulders, not realistic half-body portrait.
```

颈部分界：`[[0, 110], [35, 110], [48, 121], [66, 122], [78, 120], [87, 112], [100, 110], [114, 110]]`。源图只作等比缩放和互补分层。

## 小虎

- 最终文件：`art/runtime/portraits-v05/sources/user-v12/tiantong.png`
- SHA256：`0164b995add343b28d459bcca08fda806b590224a3bcdb9a8adf20c6d8b4fdb9`
- 选用记录：按用户照片中央人物重绘浅棕短波波头、圆润脸颊和眼睛；移除旧眼镜与深色长发。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/tiantong.png`
完整记录：[PROMPTS-user-v12.json](PROMPTS-user-v12.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-user/tiantong.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-7a6dcc08-9d9f-448e-9702-8c702ae0d864.png`

```text
Use case: stylized-concept. Create ONE production-ready Battle Brothers game bust sprite on a genuinely transparent background. Image 1 is the user's identity/design reference ONLY. Image 2 is the official Battle Brothers STYLE AND PROPORTION reference ONLY; do not reproduce any of its men. Match its rough hand-painted 2D mercenary-token style: strong dark brown outlines, economical broad shadow planes, muted earthy colors, visible brush character, slightly exaggerated head and short cropped shoulders, readable at only 88 by 100 pixels in game. NOT photorealistic, NOT 3D, NOT smooth anime/gacha or cinematic portrait. Entire head, nose, eyes, neck, chest and shoulders face SCREEN-RIGHT in consistent three-quarter view, both eyes visible but nose projects to the right, no eye contact with viewer. One continuous compact bust from complete hair crown through a visible intact neck into short shoulders and an oval cut across upper chest. Head, chin and neck must NOT be cropped or severed; leave a clearly drawn neck connecting jaw to collar. Head occupies upper 60 percent of silhouette, neck/collar transition around 68 percent, short torso the bottom 30 percent. Keep ears/crown compatible with an overlaid game helmet; no raised arms, hands, full body, weapons, shields or floating props. Center with small empty margins. Simple low dark cloth neckline below the jaw, no thick scarf covering chin. No background, floor, shadow, text, logos, poster graphics or watermark. Paint all pixels freshly; do not paste photographs. Adult East Asian woman in center foreground of image 1: light warm chestnut-brown chin-length bob, side part and side-swept long fringe, ends softly turned inward; rounded oval face, full cheeks, large rounded dark eyes, short delicate nose, soft small mouth, friendly slightly bashful expression. NO glasses, NO long dark messy hair, NO yellow thick scarf. Keep her facial proportions recognizable while boldly simplifying into the game's painted style. Faded cream linen blouse neckline with plain brown leather short shoulder vest, small warm muted apricot accent.
```

颈部分界：`[[0, 110], [35, 110], [48, 115], [57, 123], [73, 123], [85, 115], [95, 110], [114, 110]]`。原图只作等比缩放和无损分层。

## 小宁

- 最终文件：`art/runtime/portraits-v05/sources/facing/xiaoning.png`
- SHA256：`2e09ec5211edaaa2b3ab47aac1ed68f03276d4fbf873771d71b6a36cf23dd2e0`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/xiaoning.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/xiaoning.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-0118f1a0-3803-405a-a14b-a1388eef154a.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: xiaoning (default).
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaoning/BV1eS9CBjE2X-cover.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-234eade2-78c6-4470-927b-234b125c96a7.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Image 1 shows the SAME adult woman twice; draw only ONE bust of 小宁oni. Preserve her long dark chestnut-brown hair, a near-center slightly side part with visible forehead, upper face wider than the gently tapering lower jaw, original gently curved brows and small smiling mouth. Hair falls as a few broad masses to the shoulders. Simplify photographed eye makeup into small matte eyelid marks; do not copy beauty-filter huge iris sizes. A tiny simple flower-outline earring near the visible ear is allowed. Wear a dusty teal short cowl BELOW her hair and a plain weathered brown tunic. Add one tiny playful droplet at a mouth corner as the requested game motif, not wet realism. Do not use short hair, antennae, alien ears or science-fiction clothing.
```

## 小胖

- 最终文件：`art/runtime/portraits-v05/sources/facing/xiaopangxu.png`
- SHA256：`f364b5324754bea942ad4da7c66cc2f47c895a9f29b939aaec769897257c8136`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/xiaopangxu.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/xiaopangxu.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-e1e9ae35-164c-43b9-b32d-e2c4853de910.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: xiaopangxu (default).
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaopangxu/avatar-20260926.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-584b2c49-7cf9-497f-aede-2469fb8492c5.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 徐不快乐 from image 1. Her chief identifier is a rounded warm dark-brown chin-length bob, lightly separated thin short fringe, soft broad cheeks and a rounded jaw; preserve her cheerful slightly asymmetric smile and naturally narrow smiling eye shape. Keep this own face, not the woman from image 3. Do NOT replace her short bob with braids, ponytail or a headband. Outfit: compact brown leather shoulder vest over muted warm ochre cloth collar; plain brown fastening. Slightly offset shoulder line may suggest a dancer's playful energy, no limbs or dance props. Her nickname is NOT permission to invent an obese physique. Remove modern jewelry and the turquoise modern top.
```

## 大鹅

- 最终文件：`art/runtime/portraits-v05/sources/facing/dae.png`
- SHA256：`b6985bd218dd5432abc561da1d7e3859f90af6561f86b933a394e96d84b79d25`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/dae.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/dae.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-6cf18af4-0f1f-4e74-80ce-2266f228f540.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: dae (default).
```

完整机器记录：[PROMPTS-supplement.json](PROMPTS-supplement.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/dae/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0dd45-fffa-72e3-8ad7-af136bf168c3/exec-eb0c60fa-e292-4ea9-a15c-b3e096133d0b.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 大鹅/叫我好姑娘吧 in Image 1. Retain her dark brown long straight hair parted near the center and pinned behind the sides, full soft cheek shape and gently rounded jaw, near-horizontal brows, elongated outer upper eyelid and natural open eyes, full lower lip and quiet slightly asymmetric smile. Keep the tiny beauty mark below the eye visible on the photograph's left only as one small ink dot if readable; do not invent freckles. Outfit: brown leather shoulders with a short muted ivory-grey collar, and a small flat ivory goose-head-shaped shoulder clasp with dull orange tip. No separate goose, no huge fur texture, no sharp angry face.
```

## 蔓越莓

- 最终文件：`art/runtime/portraits-v05/sources/facing/manyuemei.png`
- SHA256：`27417d7e29d248e44d7c645e49f7ceb3b51ceca088ca8d672b2c9bed0a12aec2`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/manyuemei.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/manyuemei.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-8098683d-e965-4e2a-8ab7-0c7f0d31f476.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: manyuemei (default).
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/manyuemei/BV19G9VBFEy8-cover.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-de989910-f2ed-4f25-9dcb-913122b10c47.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 蔓越莓很甜i in image 1, using her black chin-length bob with a clear side part, hair curving toward the jaw, original fairly straight defined brows, lightly upturned outer eye shape, tapered but soft lower face and small slightly open mouth. Retain this specific short hairstyle; no braid or long ponytail. Photo's central overlay text is NOT part of her face: never reproduce letters or guess extra facial marks hidden under them. Clothing: high charcoal collar, muted cranberry-red short shoulder cape and one plain dark iron clasp. Calm assured expression, not angry V-shaped eyebrows. Fully clothed medieval attire; no whip, no sexualized costume. Render her normal eyes as small restrained marks, not huge beautified anime eyes.
```

## 罗一可

- 最终文件：`art/runtime/portraits-v05/sources/blue-team-v24/luoyike.png`
- SHA256：`dbdddc1ca7c19771318fe1df7bd8ff9249791d8410ab80b89f1c3f342ee1e6c0`
- 选用记录：内置 ImageGen 按用户罗一可照片绘制，人类长发、侧刘海与软面颊，梅紫围巾和小粮袋。

### 蓝队个人头像 · 内置 ImageGen

用户本轮提供照片；仓鼠为用户确认梗，仅保留人类软面颊和警觉神态。

完整记录：[PROMPTS-blue-team-v24.json](PROMPTS-blue-team-v24.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-28-blue-team/luoyike-user.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e72b-fd93-7953-983b-9f4b33075dd2/exec-d7ae00fc-b4a0-4562-8dc8-e4bf18980906.png`

```text
Use case: stylized-concept / identity-preserve. Asset type: one finished transparent head-and-short-shoulders bust for a Battle Brothers mod, readable as 88x100 painted pixels within a 114x142 game frame. Follow reference 1 for the person's identity only. Reference 2 is official Battle Brothers STYLE AND PROPORTION guidance only; do not copy its people, bare torsos or assets. Make original painted artwork with a large head, narrow very short fully clothed shoulders, economical dark brown outlines, broad 3-4 tone planar shadows, muted natural skin, earthy medieval fabrics. No photographic skin detail, airbrushed beauty, anime eyes, 3D render, polished gradients, modern clothes, logos or text. Full hair crown and rounded bottom visible with margins. Face, nose, gaze, neck and chest consistently three-quarter toward SCREEN RIGHT; both eyes visible, eyes look right not at viewer. Keep the entire chin and an intact short bare neck clearly above the low clothing collar; head occupies about 70% of visible silhouette height, upper chest only bottom 20%. No arms, hands, weapons, background scene, ground shadow, border, labels or watermark. Genuinely transparent RGBA background, a single complete bust asset.
Character: 罗一可 (Luoyike), the adult East Asian woman in the user's photograph, reference 1, which is the ONLY identity ground truth. Preserve her long straight chestnut-brown hair, off-center part with delicate wispy diagonal curtain fringe across her forehead, naturally wide dark almond eyes, gently curved brows, small straight nose, soft oval face with gently full cheeks and a small tapered chin, delicate natural lips. Keep likeness and expressive bright attentive eyes, but simplify the photographic detail into a painted game sprite. Closed relaxed lips with a hint of a smile, no exaggerated teeth or open mouth. The user calls her 'hamster': express this very subtly through soft cheeks and alert resourceful expression; do not inflate cheeks or replace her face with an animal. She remains human, with NO animal ears, muzzle, whiskers, fur, teeth, headband or mascot. Medieval outfit inspired by her photo: muted plum-burgundy scarf with just one simple ochre woven stripe, low enough to expose full lower jaw and short neck, dark brown padded shoulder vest, small rounded grain-pouch flap on her chest strap. No school crest or modern uniform, no branded costume. Hair falls behind the compact shoulders, not below the short rounded bust bottom. Genuinely transparent RGBA.
```

颈部分界：`[[0, 110], [35, 110], [48, 114], [57, 118], [73, 118], [85, 114], [95, 110], [114, 110]]`。源图只作等比缩放和互补分层。

## 可可

- 最终文件：`art/runtime/portraits-v05/sources/user-v17/keke-photo-v2.png`
- SHA256：`dd3c2ec863aba882e61b2e03a5926c64c971ab8d76bedfb249177fbd25973e1b`
- 选用记录：根据用户提供的两张可可照片重绘圆润紧凑脸型、柔和眉眼、小巧鼻唇、薄刘海与低双马尾；保留红褐围巾、棕皮肩衣、月形搭扣、朝右姿态和完整下颌短颈。已检查游戏尺寸及装备叠加，尚未实机验收。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/user-v17/keke.png`
完整记录：[PROMPTS-keke-photos-v17.json](PROMPTS-keke-photos-v17.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-keke/01-front-bangs-twin-tails.png`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-keke/02-three-quarter.png`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/user-v17/keke.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e182-4f3d-7eb2-ac38-307dc7d2ee97/exec-8b397020-aa1a-4fb6-aa04-f024fcb66cf6.png`

```text
Use case: identity-preserve / stylized-concept.
Asset type: one finished transparent Battle Brothers character bust sprite, 可可 (Keke).
Input roles: Images 1 and 2 are the user's photographs of the SAME woman and are the identity ground truth. Image 1 is the primary front-face proportion and hairstyle reference: rounded soft cheeks, compact rounded oval face, wispy brow-length fringe, dark brown hair tied into two low tails. Image 2 provides a second angle for her eyes, nose, mouth and natural expression. Image 3 is the CURRENT GAME ASSET to replace: keep its brown leather medieval shoulder garment, muted brick-red scarf, small plain crescent-shaped brass fastener, compact bust framing, screen-right pose, and crisp painted sprite treatment. Its long angular face, sharp aggressive eyebrows and loose long hair are inaccurate and MUST NOT be preserved. Image 4 is official Battle Brothers sprite STYLE AND PROPORTION reference only, not identity.
Primary request: redraw Keke so that she is recognizable from the two photos. Use a softly rounded compact oval face, fuller natural cheeks, gentle small rounded chin, short-to-medium midface, small understated nose, expressive dark almond eyes of natural moderate size, gentle nearly straight softly curved brows, small natural rose mouth with a full but restrained lower lip. Calm attentive, softly confident expression with relaxed closed lips, not stern or seductive, no duck lips. Avoid elongated angular jaw, high carved cheekbones, sharp frowning eyebrows and mature weathered face from the old illustration. Do not invent moles, freckles, makeup or jewelry.
Hair: dark chestnut brown, softly parted above a wispy fringe with short separated locks across forehead at brow height, gentle loose cheek-framing strands, two compact low ponytails tied behind ears as in photo 1; simple dark ties, no bright ribbons. Hair should read as fringe plus low twin tails when tiny, not loose waist-length hair, no braids and no hat.
Style: Battle Brothers hand-painted medieval tactical game sprite. Strong economical dark brown contour, broad slightly angular 3-4 tone shadows, warm muted natural skin, earthy cloth and leather. Simplified planar paintwork and feature marks legible at 88x100 visible pixels. Keep recognizability without photographic skin detail or airbrushed beauty portrait. No anime/chibi/doll eyes, no 3D render, no shiny makeup, no cute sticker style.
Composition: one fully clothed head-and-short-shoulders bust. Face, nose, gaze, neck and chest turned consistently three-quarter toward SCREEN RIGHT; both eyes visible, gaze right rather than looking at viewer. Large game head around upper 60 percent of silhouette, entire lower jaw and intact short neck visible above a low red scarf, short narrow shoulders in lower 30 percent. Scarf must stay below the jaw and not hide the chin. Compact curved oval bottom; no arms, hands, weapons or full body. Complete hair crown and shoulders inside canvas with small margins.
Output: genuinely transparent RGBA background; a single asset with no text, labels, streamer overlays, watermark, frame, scene, ground, cast shadow or comparison sheet. Identity follows photos; game costume and facing follow image 3.
```

颈部分界：`[[0, 109], [35, 109], [48, 114], [57, 121], [73, 121], [85, 114], [95, 109], [114, 109]]`。原图只作等比缩放和无损分层。

## 余想

- 最终文件：`art/runtime/portraits-v05/sources/facing/yuxiang.png`
- SHA256：`51805715556765c9f06daebd2301daf339a72b688e9f2245711464a428afd2e0`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/yuxiang.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and gaze now consistently face screen right. Character-specific face shape, hair, eyewear where present and garment details retained; silhouette and transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/yuxiang.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-ca860a83-ea4e-43b6-9a19-f0d88afbadbb.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 余想 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-supplement.json](PROMPTS-supplement.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/yuxiang/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0dd45-fffa-72e3-8ad7-af136bf168c3/exec-ffdd2b1a-8a23-4c1b-b509-625b1acca03f.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 余想的room in Image 1. Retain her slightly long oval face and soft narrowing chin, side-parted long dark brown straight hair with one voluminous swept forehead lock, gently arched brows, separated natural almond-shaped eyes, and fuller lips with a restrained asymmetric half-smile. Her face must differ from the sample: do not copy the sample's eyes, nose, jaw, hair or expression. Outfit: muted dusty-plum short mantle with a small dull brass lantern-shaped collar clasp over ordinary brown leather. No large flower or extra head accessory, no modern dress.
```

## 童猪

- 最终文件：`art/runtime/portraits-v05/sources/facing/tongzhu.png`
- SHA256：`d2a0355f68606cfbaf6d737564b3bbd5e773d6cffae4f19efb20e2e29866c586`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/tongzhu.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and gaze now consistently face screen right. Character-specific face shape, hair, eyewear where present and garment details retained; silhouette and transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/tongzhu.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-53f40313-e6af-487f-9281-6ffa40eb9bfa.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 童猪 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/tongzhu/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-222fc435-0183-4c0c-b3a9-44a9c38b0957.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Adult woman with long dark hair parted near center, round black spectacles, softly rounded oval face and small narrow eyes, quiet intent closed mouth. Keep matte glasses with no glare, slim cloth collar and dusty-blue cloak, a tiny carved bear clasp. Omit headset and microphone. Do not use a long pointed chin or generic angry eyes.
```

## 美伢

- 最终文件：`art/runtime/portraits-v05/sources/user-v17/meiya.png`
- SHA256：`072cd373b42e05f1d3e87600c1db488328958e8d1e44fcead00c0aaadcc5afc0`
- 选用记录：根据用户提供的四张美伢正侧面照片校准长椭圆脸、细弧眉、自然杏眼、鼻形与轻微笑意；收敛旧稿粗眉和噘嘴。保留近中分长黑发、朝右姿态、棕皮肩衣和完整下颌颈部；不将帽子画入基础层。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/user-v12/meiya.png`
完整记录：[PROMPTS-meiya-v17.json](PROMPTS-meiya-v17.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-meiya/01-side-closeup.jpg`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-meiya/02-hat-closeup.jpg`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-meiya/03-side-smile.jpg`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-meiya/04-front-long-hair.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/user-v12/meiya.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e182-4f3d-7eb2-ac38-307dc7d2ee97/exec-6e00b4ff-8923-448e-b969-e5c742e8e518.png`

```text
Use case: identity-preserve / stylized-concept.
Asset type: ONE updated transparent character bust sprite for the Battle Brothers mod character 美伢 (Meiya), recognizable from four user-supplied photographs.
Input roles: Images 1-4 are IDENTITY reference photographs of the SAME adult woman, to be synthesized across front and side views. Image 4 (front view) anchors facial proportions; images 1 and 3 clarify her nose, jaw and profile; image 2 supports eyes and relaxed mouth. Image 5 is the EXISTING GAME ASSET to improve: preserve its screen-right three-quarter facing, compact single bust framing, simple brown leather shoulder garment and dusty rose linen neckline, but correct its exaggerated face using the photographs.
Primary request: repaint the existing asset with a more faithful, natural likeness. Refined elongated oval face with gently tapering small chin, soft cheek planes, slim straight nose with compact rounded tip, medium-thin gently curved natural dark eyebrows (not thick severe angular eyebrows), expressive dark almond eyes with restrained upper lash line (not huge doll eyes), naturally defined muted rose lips with visible cupid's bow and a relaxed subtle friendly almost-smile. Lips should be smaller and less protruding than the old illustration; no duck-lip pout, no exaggerated open mouth, no angry or suspicious expression. Use the photographs rather than inheriting the inaccurate features of the old art. Long very dark brown-black hair, near-centre part, softly flowing broad locks framing the face and resting behind the shoulders, modest crown volume. No invented moles or freckles.
Style: clearly a hand-painted low-resolution medieval game sprite, matching Battle Brothers: firm dark brown outer contour, broad economical shadow shapes and restrained painterly shading, muted warm earthy palette, simplified purposeful feature marks legible after reduction to 88x100 visible pixels. Not photorealistic, not anime, not glamour illustration. Keep likeness without airbrushed beauty lighting.
Composition: head, nose, gaze, shoulders and chest consistently turned three-quarter toward SCREEN RIGHT; gaze slightly to screen right, not directly at viewer. Exaggerated game head occupying roughly 60 percent of total silhouette height; full jaw and intact short neck; narrow rounded shoulder/chest base in bottom 30 percent. Match the old asset's body crop and scale. Entire crown and both shoulders inside canvas with small transparent margins. One isolated bust only, no hands/arms, weapons, headgear, necklace, accessories, text, UI overlays, watermarks, background, ground or cast shadow. The photos' hats are NOT part of the base sprite because game helmets overlay it. Modest fully clothed linen and leather shoulders.
Output: actual transparent RGBA background, preserve alpha; one finished source asset, not a comparison sheet or grid.
```

颈部分界：`[[0, 108], [35, 108], [48, 113], [57, 122], [73, 122], [85, 113], [95, 108], [114, 108]]`。原图只作等比缩放和无损分层。

## 玩蛇

- 最终文件：`art/runtime/portraits-v05/sources/facing/wanshe.png`
- SHA256：`ad193ce44f1ce7c0afa4039c508043e9a4e1607a2c5839d157fb0dd9e6a7af83`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/wanshe.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and gaze consistently face screen right. Ponytail, beauty mark, expression, snake clasp and garment retained; silhouette and transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/wanshe.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-67e6ff23-987a-4bdd-8340-b543c9bb1455.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 玩蛇 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/wanshe/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-141963a9-0bf1-47fb-8d7b-912ecb092e74.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Wanshe, 玩蛇. Dark brown hair in a LOW ponytail, thin irregular separated fringe, relatively straight natural brows, narrow elongated eyes, softly rounded jaw and clearly shaped lips. Use a calm slightly parted mouth rather than an angry expression. Keep her delicate natural facial planes, do not broaden the jaw or thicken brows. Photo crops the crown: finish the ordinary dark ponytail silhouette simply, without inventing ornate hair. Costume: plain worn muted olive-brown padded linen/leather shoulders, a small dull green coiled-snake clasp as a fictional game motif; no headscarf, no hat, no large prop.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 涂涂

- 最终文件：`art/runtime/portraits-v05/sources/facing/tutu.png`
- SHA256：`49655e56bd9ad65b70f46275603aa62694b42ae55e47c1eddf37a464b0484813`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/tutu.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and gaze consistently face screen right; forehead, hairstyle, individual eye/mouth shape, cloak and clasp retained. Both eyes visible and far side narrower; silhouette/transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/tutu.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-92c3b58f-0a79-4132-beb5-692d39b926e8.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 涂涂 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/tutu/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-254f84b8-b970-442c-bc57-ac465be1352a.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Tutu, 涂涂. Long straight DARK BROWN hair past shoulders, very light thin irregular fringe, longer eye shape and gently curved rather flat brows; soft oval jaw, thinner upper lip and fuller lower lip. Preserve individual nose/mouth relation from image 1, a quiet thoughtful expression. Do not replace long hair with the old short-haired hooded character. Costume: deep moss-green cloth mantle with a SHORT off-white sheepskin collar and plain brown leather fastener. Hood remains DOWN behind neck, not on head, so the full hairline and bangs are visible. No letter in hand, no equipment prop.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 奶盖

- 最终文件：`art/runtime/portraits-v05/sources/user-v18/naigai.png`
- SHA256：`6e5e371558394c4b61cff3f859fd3ee94c4d1ba4eeaab78c3a4dbbb6719c15bf`
- 选用记录：按四张用户照片校正奶盖的齐下巴黑色短发、柔和脸型与眉眼唇形；保留棕色短披肩。透明朝右胸像，已检查原尺寸及原版装备叠加，未实机验收。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/naigai.png`
完整记录：[PROMPTS-naigai-v18.json](PROMPTS-naigai-v18.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-naigai/01-bob-closeup.png`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-naigai/02-beach.png`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-naigai/03-smile.png`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-naigai/04-street.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e1aa-5e78-74d0-a826-eb755a8f575e/exec-22bedfcf-8e05-4bcf-a8cb-546b4aa87f77.png`

```text
Use case: identity-preserve / style-transfer.
Asset type: ONE PRODUCTION transparent Battle Brothers tactical game pawn bust for the character 奶盖 (Naigai).
Input roles:
Images 1 through 4 are user-provided photographs of the SAME adult woman and are the ONLY source for her facial identity and hair. Image 1 primarily establishes facial profile, eye/nose/lip proportions and the blunt black bob; image 3 adds her natural soft smile; images 2 and 4 confirm the rounded jaw, forehead and hairstyle in less close-up views. Do not reproduce the photos' clothing, poses, necklaces, hands, bags or backgrounds.
Image 5 is ONLY the official Battle Brothers hand-painted sprite technique and compact large-head proportions; never copy any male face.
The existing game design wears a brown short cape with a cream inner collar and small round brass clasp; retain that outfit as described. Replace the previous long-haired design with the photographed person's actual short bob and facial identity.

Produce one large-head, short-neck, compact-shoulder medieval game bust on genuinely TRANSPARENT RGBA. Head, chest, shoulders and eye gaze all turn about 35 to 40 degrees toward SCREEN RIGHT. Both eyes visible, far eye narrower, nose points to screen right. No looking back over a shoulder, no head tilt, no frontal or screen-left pose.
Naigai's identifying features from photos: soft slightly rounded oval face, gentle full cheeks and a small rounded tapering jaw, light warm natural skin, clear dark almond eyes with lightly defined eyelids, naturally nearly straight fine dark eyebrows with a subtle arch, a compact straight nose with softly rounded tip, softly full muted pink lips and a restrained friendly smile. Keep her particular eye spacing and unsharpened jaw, do not substitute a generic doll or beauty-filter face.
Most important hairstyle correction: SHORT BLACK BOB ending at the jaw/upper neck, slightly off-center part exposing most of the forehead, broad swept front section, one or two separated face-framing locks, gently rounded volume, dark charcoal highlights. Clean blunt slightly irregular ends as in all four photos. Hair must end ABOVE the shoulders, no long hair over chest, no ponytail, no bangs covering the entire forehead. No hair ornament.
Outfit: retain the existing modest muted warm-brown compact shoulder cape over a low cream collar, small round matte brass clasp at upper chest. Only a shallow shoulder-and-collar base. No modern clothing, no necklace, no armor, weapons, quiver, props or additional accessories; native equipment will be layered by the game.
GAME SCALE: whole visible silhouette must read when reduced to at most 88 x 100 pixels inside the game's 114 x 142 slot. Head including hair roughly upper 65-70 percent of silhouette, short complete neck, shallow sloping shoulders and rounded short bust base. No long torso or full upper-body portrait. Preserve complete uncut jaw and neck. Hair not excessively wide so standard helmets fit.
STRICT RENDERING: original Battle Brothers economical matte hand-painted pawn style. Thick uneven dark-brown outer contour, a small number of broad deliberate shadow planes, warm flat base skin with just two or three cheek/nose shadows, painted eyelid strokes and small dark pupils, simple lip line, hair in 6-8 broad masses. Muted earthy cloth with a few broad folds. Strong readable silhouette and simplified face. No photographic texture, skin pores, delicate individual hair strands, textile weave, smooth glamour rendering, glossy anime eyes, 3D render, oversized baby features or sharp harsh cheekbones. Capture her specific photographed identity through proportions and silhouette.
Output exactly one isolated connected head-neck-shoulder pawn, entire hair and shoulders inside frame with transparent margin, truly transparent background not a white rectangle or baked checkerboard. No text, labels, comparison panels, border, cast shadow, watermark, hands, arms, legs or scenery.
```

颈部分界：`[[0, 110], [35, 110], [48, 115], [57, 123], [73, 123], [85, 115], [95, 110], [114, 110]]`。原图只作等比缩放和无损分层。

## 小杰

- 最终文件：`art/runtime/portraits-v05/sources/facing/xiaojie.png`
- SHA256：`addf03faea8908c4f87fb9fc5c87bc82df4ae473e6922cc99ee406bfe01af379`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/xiaojie.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Right-facing head/chest/gaze, broad nearer left shoulder and receding far side. Individual face shape, hair, expression, collar, scarf and clasp retained; silhouette/transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/xiaojie.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-b09c0f24-1147-4ece-a388-f35d35779cb9.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 小杰 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaojie/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-a12001f9-c024-4ace-8b1a-bf3644bb6d51.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Xiaojie, 小杰. Dark hair drawn BACK into a plain low tie with loose temple strands, open forehead, clear upper eyelids, slightly elongated eyes, a comparatively high straight nose bridge and gently narrowing jaw, thinner upper lip and a small restrained closed-mouth half smile. Preserve these specific proportions from the close-up WITHOUT exaggerating close-camera nose perspective. IMPORTANT: photo faces left; invent the corresponding three-quarter head view facing the RIGHT EDGE, showing both eyes, in the same direction as image 3. Do not retain the photograph's hand at her lip. Costume: worn brown padded cloth with short pale wool collar and two tiny brass keys attached directly to the chest clasp. No high bun invented from old art, no shield, no weapons.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## bula

- 最终文件：`art/runtime/portraits-v05/sources/facing/bula.png`
- SHA256：`094a9e64edb9e859008b26ff1ee6433bbba8ce3dfe623277c624ce161b036b75`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/bula.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Right-facing head/chest/gaze, broad nearer left shoulder and receding far side. Individual face shape, hair, expression, collar, scarf and clasp retained; silhouette/transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bula.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-50c32733-dabd-4731-a43e-77df377a72a6.png`

```text
Use case: identity-preserve. Edit target is image 1: existing bula Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-supplement.json](PROMPTS-supplement.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/bula/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0dd45-fffa-72e3-8ad7-af136bf168c3/exec-dfd27e7d-c4f3-4513-97b9-00f77f069eb5.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman bulaQoQ in Image 1, using this partial profile reference faithfully. Retain her dark side-parted shoulder-length straight hair tucked behind one ordinary ear, slightly long eye shape, gently level brows, clear straight nose profile and soft cheek-to-narrow-chin outline, fuller lower lip and calm closed mouth. Keep a mild right-facing three-quarter angle close to the photograph, not a completely invented full frontal face. Outfit: muted grey-beige scarf and brown leather shoulders with one simple dull brass circular clasp. Remove the phone, earbuds and hands. Hair should have shoulder-length broad masses, not the sample's long wavy hairstyle. No quiver or extra props.
```

## 苏袜

- 最终文件：`art/runtime/portraits-v05/sources/facing/suwa.png`
- SHA256：`6b7101b6da193ab622f49a4bc6c9fc671cc405a75c9a74d2b2a272cf6bc363a8`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/suwa.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head/chest/gaze turned right with nearer left shoulder wider; retains individual face proportions, hair, eyewear where present, muted red scarf and padded outfit. No clipping or new object.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/suwa.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-db6c8d05-ae20-42de-8755-61fcc346afd2.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 苏袜 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/suwa/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-85bcf68c-363c-4733-b052-9bf9088c21e5.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Suwa, 苏袜. LONG straight dark brown-black hair with thin scattered bangs, large WIDE RECTANGULAR BLACK-RIM glasses as in photo, a relatively long soft face gradually narrowing to chin, full lips with clear cupid bow. Keep her natural brows thin and relaxed. Translate the photographed face shape but do NOT preserve crying redness or tearful suffering: relaxed alert closed lips. Eyes behind glasses are small matte natural eyes, not giant anime eyes or shiny lens reflections. Costume: muted faded brick-red neck scarf, weathered brown quilted leather shoulders. No cloth hair bow, no short invented hair, no weapons, no hands.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 千涵

- 最终文件：`art/runtime/portraits-v05/sources/facing/qianhan.png`
- SHA256：`fd9895036dd644e16398fb0bca8dbafb11d8bd2f0e4a730f3019bbb082f948f6`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/qianhan.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head/chest/gaze turned right with nearer left shoulder wider; retains individual face proportions, hair, eyewear where present, muted red scarf and padded outfit. No clipping or new object.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/qianhan.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-f6f9ada3-44a4-4c2f-bd6c-fc9877c02276.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 千涵 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/qianhan/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-18842b30-a8b1-4680-be2f-2a35250ef1ef.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Qianhan, 千涵. Dark brown hair parted close to center, tied in TWO LOW PONYTAILS as specifically pictured; smooth broad forehead, softly full cheeks tapering gently to a rounded chin, naturally straight eyebrows, broadly spaced almond eyes, small nose tip, thin upper lip and distinct fuller lower lip. Keep a placid focused expression, NOT a sharp angry jaw. Photo beauty filters are not a reason for anime eyes: small dark matte pupils. Costume: plain gray-brown padded mercenary shoulders, a short muted rust-red neck scarf and simple brown strap. No shield, no spear, no ornate hair accessory.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 王大芷

- 最终文件：`art/runtime/portraits-v05/sources/facing/wangdazhi.png`
- SHA256：`7f4dcbf9e5e9fbf3dffd30f5f97ee6eaef74f5cebfa48f012d4ab1e6f6cc0e50`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/wangdazhi.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head/chest/gaze now right facing. Bangs, reddish brown long hair, beauty mark, half-lidded smile and purple scarf preserved; no clipped silhouette.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/wangdazhi.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-26f6dafd-a39c-471e-bd95-71bc66403e6c.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 王大芷 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/wangdazhi/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-f5d90423-d22b-4b29-8ab8-b09fa759975c.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Wangdazhi / Zhizhi, 王大芷 / 芷芷. WARM CHESTNUT BROWN LONG STRAIGHT HAIR with thin straight bangs above the brows, elongated eyes and gently flat eyebrows, softly tapered narrow chin, distinctive fuller lower lip, a small relaxed lightly open smile. Keep the tiny cheek beauty mark visible in the reference as a single brown dot beneath the outer eye on the corresponding visible cheek; no oversized mark. It is NOT a short bob. Hair silhouette should be unmistakably long. Costume: faded muted lavender-purple scarf, plain brown leather shoulder panels with a single modest round brass fastening. No hat, no hands, no weapons.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 瑶瑶牙

- 最终文件：`art/runtime/portraits-v05/sources/user-v23/yaoyaoya.png`
- SHA256：`36d401d588ec39cc1f48a0643370685554b1745cb75cb6412ef262f711569ccb`
- 选用记录：按用户要求将露肩裹胸改为遮住双肩、胸口和上臂的米白色素衣；保留黑长发、面容、朝右姿态及原画风。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/user-v12/yaoyaoya.png`
完整记录：[PROMPTS-yaoyaoya-v23.json](PROMPTS-yaoyaoya-v23.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/user-v12/yaoyaoya.png`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e73d-c031-7ba3-92a1-cff44b554d01/exec-95cc1bd4-9b91-4fce-bf8f-f50715a84e12.png`

```text
Use case: identity-preserve. Asset type: transparent hand-painted game portrait for the existing Battle Brothers mod. Input image 1 is the EDIT TARGET: the current portrait of 瑶瑶牙. Change ONLY her clothing: replace the strapless wrapped bandeau and exposed shoulders/upper chest with a simple modest medieval cream linen tunic with a closed high round neckline at the base of her neck and sleeves fully covering both shoulders and all visible upper arms. Subtle ochre seam/edge details may match the old strap, keep clothing simple and practical. Her chest, cleavage, collarbone area, shoulders and upper arms must all be covered in opaque cloth; only her face and neck remain exposed. Preserve the exact face, likeness, gaze to viewer-right, long flowing black hair, expression, skin tone, pose, head-to-body scale, head location, bust silhouette, framing, brushwork, outline thickness, palette, and lighting of the source image. Keep the neck and jaw fully intact and clearly separated from clothing. Isolated bust with the same rounded lower edge, no arms or hands added beyond the existing crop, no props, no jewelry, no armor, no text, no watermark. Preserve a genuinely transparent alpha background with clean edges. Output one edited portrait, closely aligned to the original.
```

颈部分界：`[[0, 107], [35, 107], [48, 112], [57, 118], [73, 118], [85, 112], [95, 107], [114, 107]]`。原图只作等比缩放和无损分层。

## 羊咩咩

- 最终文件：`art/runtime/portraits-v05/sources/facing/yangmiemie.png`
- SHA256：`5795621990e9b6f127bbf72b4a5f42e89206a78c28259e4b851b6e2642886f96`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/yangmiemie.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and eyes point screen right; nearer left shoulder is wider. Preserves face shape, hairstyle, expression, garment and personal clasp details; no clipping.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/yangmiemie.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-5c5f56f5-6529-4a4d-844e-af4ac8233b73.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 羊咩咩 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/yangmiemie/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-9371d84c-c236-448e-8654-19c73e68f497.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Yangmiemie, 羊咩咩. Long straight DARK BROWN hair, sparse see-through thin fringe above brows, relatively long narrow eyes and slightly raised brow ends, narrow soft jaw. Warm animated lightly open mouth as in photo, just a short cream tooth mark if visible, no broad generic grimace. Do not replace real long straight hair with short curls, a cap, or blue headwear. Costume: plain dusty muted blue neckerchief over brown linen/leather, a small brass travel bell attached at collar and a very small ivory sheep clasp as established fictional game motifs. No hat, no sheep on head, no modern microphone, no hands.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

## 宋暖阳

- 最终文件：`art/runtime/portraits-v05/sources/facing/songnuanyang.png`
- SHA256：`def57bf4345ba4613b5022b0b8ba808d7f5fb6fa0e80a14c41a0af13250dd5ca`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/songnuanyang.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and gaze consistently face screen right; forehead, hairstyle, individual eye/mouth shape, cloak and clasp retained. Both eyes visible and far side narrower; silhouette/transparency intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/songnuanyang.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-afb692c3-1e35-442a-b474-b1da8acc5651.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 宋暖阳 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/songnuanyang/public-live-photo-4.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-fa05359e-3173-48d2-9899-e9a13fe4a415.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 宋暖阳绝不咕咕 from image 1. Her own dark black hair is pulled back low, leaving the forehead visible, with one loose longer strand near the cheek; retain her gently arched brows, clearly spaced natural eyes, soft rounded narrowing jaw, compact nose and neutral closed mouth. Do not hide her identifying hairline inside a hood or replace it with short brown hair. Outfit: a short muted warm-brown padded shoulder cape, dull cream collar and three broad darker-brown feather-like spots on one shoulder as a very restrained quail nickname motif. No real bird anatomy, no beak, no feather crown, no cute baby face. Plain matte cloth; all face detail flattened to small painted marks, not skin realism.
```

## 溺水小龟

- 最终文件：`art/runtime/portraits-v05/sources/user-v17/xiaogui.png`
- SHA256：`ea47d8b87dcbd4358e6e75c8613d870ed0aa76f22b7b77787b0d5ecfc8a03157`
- 选用记录：按两张用户吉祥物图及明确要求重绘：保留醒目亮粉蝴蝶结，提亮浅苹果绿皮肤和奶黄色腹甲，圆脸笑容、绿色斑纹、粉色爪印。朝右，保留龟壳和皮带；不加入直播设备与球队元素。蝴蝶结在游戏尺寸可辨认；全罩头盔右缘仍有龟脸外露，尚未实机验收。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/user-v12/xiaogui.png`
完整记录：[PROMPTS-xiaogui-v17.json](PROMPTS-xiaogui-v17.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-xiaogui/01-streamer-mascot-expressions.jpg`
- `G:/CODE/afei-xcpedition/art/references/2026-09-27-xiaogui/02-spotted-turtle-mascot.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/user-v12/xiaogui.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:/Users/25647/.codex/generated_images/01a0e182-4f3d-7eb2-ac38-307dc7d2ee97/exec-8e7078b7-7afc-4698-9baa-11a6844c3681.png`

```text
Use case: stylized-concept / identity-preserve.
Asset type: ONE finished transparent Battle Brothers game bust of the turtle mascot character 溺水小龟 (Xiaogui), based on two user-supplied mascot reference images.
Inputs: Image 1 is CHARACTER DESIGN reference: cheerful round green turtle with small pink bow, yellow segmented plastron and expressive friendly face. Image 2 is CHARACTER DESIGN reference: light-green round head, olive crown spots, soft cheeks and pink paw-shaped cheek mark. Use these two to correct the existing likeness. Image 3 is the EXISTING GAME BUST to improve: keep its screen-right three-quarter pose, compact isolated head-and-short-shoulders crop, visible short neck, brown medieval leather shoulder straps and small shell rim behind shoulders. Image 4 is the official Battle Brothers STYLE reference only.
Primary request: make the mascot closer to the references: a compact rounded turtle head with soft full cheeks, short shallow muzzle and two tiny nostrils, clean round chin; eliminate the old long bulbous projecting duck-like beak and long reptile neck. Bright fresh pale apple-green skin with a warm mint tint, soft medium leaf-green irregular crown spots, large friendly dark brown eyes with one simple highlight each, gentle lifted brows, relaxed cheerful small open smile with a tiny pink tongue. Both eyes open and looking screen right. Warm subtle cheek blush, one small simple soft-pink paw mark on the visible near cheek. Not a realistic wrinkly reptile, not angry or elderly.
USER'S LATEST PRIORITY: the PINK BOW MUST BE PRESENT AND CLEARLY VISIBLE. Draw one charming candy-pink fabric bow centered at the front/top of the crown, about 30 percent of the head width, with two rounded softly folded loops and a rounded knot. Keep it compact against the crown so it can later be covered by equipped helmets, but do NOT miniaturize, hide, desaturate or omit the bow. Friendly and cute, not sombre. Retain a few visible olive crown spots. No headset, microphone, gaming chair, controller, keyboard, computer or streamer props.
Body: light warm creamy-yellow segmented turtle chest/plastron at the neckline, simple light honey-tan leather shoulder harness adapted from the existing bust, a subtle medium fresh green shell rim behind the shoulders. Short intact green neck visibly joins the full rounded jaw to the low collar. Both shoulders compact, no arms/hands. No soccer jersey, logo, sponsor, lettering or sports insignia.
Style: hand-painted medieval tactical game sprite fitting Battle Brothers alongside the existing busts. Clean medium warm-brown outer contour, broad economical hand-painted shadow shapes, limited light/shadow tones, light honey-tan leather. USER REQUESTS MUCH LIGHTER COLORS AND MORE CUTENESS: predominantly luminous pale apple-green, creamy yellow and soft candy pink; use soft green shading on green skin. Bright softly lit cheek and crown planes, rounded welcoming shapes and joyful expression. Only use small restrained shadow areas for depth; avoid dirty brown skin shadows, olive-drab complexion, desaturated mustard, heavy dark vignette or gloomy muddy palette. Keep the mascot's rounded charm and readable color while avoiding neon acid green, shiny plastic, 3D rendering, glossy airbrush, oversized anime sparkle eyes, sticker outline or flat emoji graphics. Small-size readability matters: the final visible character is only at most 88x100 game pixels.
Composition: a single coherent 3/4 bust, head/nose/gaze/neck/chest all turned toward SCREEN RIGHT. Head roughly upper 60 percent of silhouette, intact short neck in middle 10 percent, curved cropped shoulders/chest bottom 30 percent. No straight-on face, no looking at viewer, no winking. Entire crown, small bow and shoulders comfortably inside frame with small clear transparent margins. Maintain game-compatible head scale; do not draw a whole-body baby turtle.
Output: genuinely transparent RGBA background, ONE final source image, not a grid or comparison. No text, borders, sticker-white rim, scene, ground, cast shadow, watermark or other characters.
```

颈部分界：`[[0, 108], [35, 108], [48, 113], [57, 123], [73, 123], [85, 113], [95, 108], [114, 108]]`。原图只作等比缩放和无损分层。
