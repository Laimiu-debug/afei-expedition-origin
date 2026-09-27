# 朝右战斗胸像：实际生图提示词与 v0.12 接入规则

v0.12 使用用户提供的五张参考图，以内置 ImageGen 重绘小月牙、溺水小龟、亿口甜筒、瑶瑶牙和美伢。全员取消固定 y=102 横切，改用逐人颈部轮廓分层；其余成员保留既有源图，游戏尺寸、装备叠加和旧存档画刷 ID 不变。

v0.7 没有重新生图：将现有源图等比缩到最大 88×100，放入 114×142 槽，在颈部拆成身体和头部，恢复原版武器、盾牌、护甲与头盔叠加。蛤蟆原画和头顶飞碟停用，转职玩法保留。下文保留真实生成历史，不把后续技术处理写成新的生图调用。

照片只负责本人脸型、眉眼、发际线和发型；画法参考《战场兄弟》官方胸像。源图使用少量宽阴影、粗轮廓、低饱和衣物和短肩大头比例，最终按 114×142 输出。

当前映射中 30/36 幅采用 v0.6 朝右姿态修订。头部、胸肩和视线共同朝画面右侧，保留原有个人特征与衣装；每人仍使用包含自绘头发、脸和衣服的一张透明胸像。下面逐次保留实际调用、参考输入、原始输出及局部返修，不能把提示词记录当作实机通过证明。

此前缺参考的四位人类成员本轮已收到用户指定图片；图片仅作美术依据，不声称已核验其来源。小龟使用用户指定吉祥物。蛤蟆立绘与头顶飞碟已于 v0.7 停用，转职玩法保留。

姿态修订前的选择见 [manifest-before-facing.json](manifest-before-facing.json)，原始源图继续保留；`afeix_p04_*` 画刷与 `afeix_portraits_v04` 图集名称不变。参考照片与官方画风样本不打入游戏包。

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
|李李超欧|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/lili.png`|
|小月牙|按用户照片重绘黑色长发、清秀椭圆脸与自然眉眼，替换旧蓝发造型；朝右，完整颈部。|`art/runtime/portraits-v05/sources/user-v12/xiaoyueya.png`|
|余初九|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yuchujiu.png`|
|小鱼贝壳|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaoyubeike.png`|
|王怼怼|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wangduidui.png`|
|老蔡|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/laocai.png`|
|亿口甜筒|按用户照片中央人物重绘浅棕短波波头、圆润脸颊和眼睛；移除旧眼镜与深色长发。|`art/runtime/portraits-v05/sources/user-v12/tiantong.png`|
|小宁|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaoning.png`|
|小胖徐不快乐|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaopangxu.png`|
|大鹅|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/dae.png`|
|蔓越莓|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/manyuemei.png`|
|小哈尼|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaohani.png`|
|可可|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/keke.png`|
|余想|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yuxiang.png`|
|童猪|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/tongzhu.png`|
|美伢|按用户照片重绘长黑发、上挑眉、大眼睛与饱满唇形；不把帽子画入基础层，保留完整下巴和颈部。|`art/runtime/portraits-v05/sources/user-v12/meiya.png`|
|玩蛇|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wanshe.png`|
|涂涂|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/tutu.png`|
|宋暖阳|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/songnuanyang.png`|
|溺水小龟|按用户海报的大龟形象重绘圆脸、浅橄榄绿皮肤和头顶斑纹；去除老爬虫凶相，去除海报及球队元素。|`art/runtime/portraits-v05/sources/user-v12/xiaogui.png`|
|奶盖|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/naigai.png`|
|小杰|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/xiaojie.png`|
|bula|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/bula.png`|
|苏袜|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/suwa.png`|
|千涵|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/qianhan.png`|
|王大芷|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/wangdazhi.png`|
|瑶瑶牙|按用户提供形象重绘黑长发、女性面部和健壮肩颈；短胸像保留力量感，移除旧红色马尾及武器。|`art/runtime/portraits-v05/sources/user-v12/yaoyaoya.png`|
|羊咩咩|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/yangmiemie.png`|
|陈知含|保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。|`art/runtime/portraits-v05/sources/facing/chenzhihan.png`|

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

- 最终文件：`art/runtime/portraits-v05/sources/facing/lili.png`
- SHA256：`6ccd09c26eb53d119684fbcc5da43a40b0f07807ad38c4929247e6b842dbcbba`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/lili.png`
完整记录：[PROMPTS-facing-a.json](PROMPTS-facing-a.json)

#### 朝向调用 1

检查记录：Viewed actual generated image: right-facing head and shoulder perspective, original facial silhouette, hair and costume retained; transparent complete bust. Candidate remains subject to in-game scale review.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/lili.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd6c-7651-73a3-b13d-27d44f51bf1a\exec-5a076067-12d2-442a-a464-02735839447d.png`

```text
Use case: identity-preserve.
Asset: single transparent-background Battle Brothers tactical mercenary bust. Image 1 is the exact edit target and sole identity/costume source. Image 2 is the official game sheet only for pose, proportions, and painting style, never copy a face or outfit from it.
Change only the facing pose and slightly simplify the painting. Turn the ENTIRE bust distinctly toward SCREEN RIGHT by about 40 degrees, matching the game's right-facing fighters: head, neck, chest and BOTH shoulders rotated together, nose visibly projecting right, gaze aimed right rather than at the viewer. The screen-left shoulder is the large near shoulder; the screen-right shoulder recedes and is narrower. Both eyes still visible, but the far eye at screen right is distinctly narrower. It must read as a fighter looking to the right, not a frontal character portrait and not a complete side profile. Do not simply mirror the existing pose.
Preserve this exact person's individual face outline, age, eye shape, eyebrows, nose, lips, expression, hairstyle and hair color, clothing, clasps and accessories. Do not beautify, masculinize, age, or swap identity. Preserve all original signature details while reconstructing their correct perspective.
Match Battle Brothers' compact hand-painted game token: head and a short upper chest, no arms or legs, low broad curved cut-off at the bottom, thick uneven dark brown outlines, earthy muted colors, small angular painted shadow masses, 2–3 value groups, sparse folds, clumped hair. Keep the existing simplified illustration style or simplify further, never become photorealistic. Keep normal small human eyes, not anime eyes. Clean readable silhouette at 114x142 pixels. No pores, photographic skin, glossy lighting, fine strands, canvas grain, added text, platform, scenery or framing.
Output exactly ONE isolated complete bust on genuinely transparent alpha with a small clear margin. Keep full top of hair and both shoulder edges.
Subject identifier only: lili (default).
```

完整机器记录：[PROMPTS-root-selected.json](PROMPTS-root-selected.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/lili/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-81ca4dd6-9f05-4df5-aeca-97ddb8576a7f.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific invariants and costume:
Preserve this adult woman's round full cheeks and short rounded chin, chin-length BLACK side-parted bob, gentle nearly straight brows, narrow smiling eye shape, rounded nose tip and softly full lips. Keep a relaxed lively almost-smile with slightly parted lips, no huge doll eyes or generic sharp fantasy cheekbones. Neutralize the pink venue lighting and close-camera perspective. Loose slate-gray medieval linen neckline and one cream shoulder strap, one small ivory flower clip as her existing game identity accent; no bare modern shoulders, no weapon.
```

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

## 亿口甜筒

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

## 小胖徐不快乐

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

## 小哈尼

- 最终文件：`art/runtime/portraits-v05/sources/facing/xiaohani.png`
- SHA256：`3ab24602d7e056ce200d80abeabca766eab10806f3edc108e143306489c388ce`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/xiaohani.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Whole head/chest/gaze face screen right, far eye narrower, nearer shoulder wider. Original face/hair/clothes preserved; transparent margins intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/xiaohani.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-971444d8-a331-4fbc-9bc7-586eac3212ee.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 小哈尼 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-missing.json](PROMPTS-group-missing.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaohani/2892967498041343833-photo-3.jpg`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-ec3511f6-3c5b-45fd-9057-8c079e54f8ca.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT-SPECIFIC IDENTITY AND CLOTHING:
Depict the adult woman 小哈尼yo from image 1. Preserve the long dark chestnut hair with a side part and a few forehead pieces, the narrow gently tapered lower face, her own nearly straight soft brows, compact mouth and reserved expression. Do not make her bob-haired, broad square-faced or identical to image 3. Translate the face into only two broad painted shadows, absolutely no selfie-filter skin or shining lips. Clothing: muted oatmeal cloth around the shoulders, a single slate-blue scarf fold, simple brown travel tunic; hood lies down BEHIND the shoulders and never covers the identifying long hair. Fully covered functional medieval chest. Remove the photo's modern buttons, lace, watermark and pose; no hands.
```

## 可可

- 最终文件：`art/runtime/portraits-v05/sources/facing/keke.png`
- SHA256：`bc4332eac882e43c31861767836e7fad306c694280a193a177f0b5947d5f5cfd`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/keke.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Whole head/chest/gaze face screen right, far eye narrower, nearer shoulder wider. Original face/hair/clothes preserved; transparent margins intact.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/keke.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-bdd863ee-d467-4fcc-8f37-48a63716e655.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 可可 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-a-root.json](PROMPTS-group-a-root.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/keke/face-reference.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-cd993357-01df-4c5c-8f4e-e3d296ec7062.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

Subject-specific identity and costume:
Adult woman with long straight BLACK hair side-parted, soft slightly broad oval face, straight dark brows, narrow almond eyes, rounded nose tip and naturally full lips with slight closed-mouth smile. Brick-red scarf and russet medieval travel leather, one small brass crescent clasp. No invented ponytail or brown dye; no cold masculine jaw.
```

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

- 最终文件：`art/runtime/portraits-v05/sources/user-v12/meiya.png`
- SHA256：`d2ad153b2a672c0ca154bbf3629e4ebf0dd1edfc4f74efa331ebadbcec9ce603`
- 选用记录：按用户照片重绘长黑发、上挑眉、大眼睛与饱满唇形；不把帽子画入基础层，保留完整下巴和颈部。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/meiya.png`
完整记录：[PROMPTS-meiya-v12.json](PROMPTS-meiya-v12.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-user/meiya.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-91a2b002-ad01-4326-a9a4-c004fad73e6f.png`

```text
Use case: stylized-concept. Generate ONE transparent Battle Brothers mercenary game bust of 美伢. Image 1 is user-supplied IDENTITY reference: the single adult woman in the close-up. Image 2 is official Battle Brothers STYLE AND PROPORTION reference, not identity. Keep recognizable long straight black hair, arched dark brows, large rounded expressive dark eyes with simplified upper lashes, compact oval face and narrow chin, small nose, notably full rose-colored lips with a slightly open playful skeptical expression. The face is the identity priority; simplify it into the game's coarse hand-painted 2D look rather than reproducing skin or makeup photographically. Match official sprite style: firm brown-black contour, angular broad colored shadows, earthy muted palette, exaggerated head above short shoulders, no soft 3D lighting, no airbrushed beauty portrait, no shiny anime eyes. Face, nose, gaze, neck and chest oriented SCREEN-RIGHT in consistent three-quarter angle, no looking at viewer. Complete black hair crown, ears, entire jaw and visible intact neck joined to a simple low muted dusty-rose linen neckline and weathered brown leather shoulders. No hat or headgear painted into the base layer because actual equippable helmets overlay in game; no pink cap, no masks in hair. One short upper-chest bust with a curved oval bottom, no arms/hands, no finger, no weapons, no lettering. Head about upper 60 percent of silhouette, continuous neck and neckline middle 10 percent, cropped shoulders and chest bottom 30 percent. Readable at 88x100 game pixels; strong facial features with few purposeful strokes. Centered on truly transparent background with small margins, no floor, shadow, logos, watermark or other people. Repaint in game style, do not paste photographic pixels. Preserve full chin and neck for layered sprite export.
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

- 最终文件：`art/runtime/portraits-v05/sources/user-v12/xiaogui.png`
- SHA256：`cd2c4d78bdb7515a3f6730c60b71fdbedd571eba01e78b609a77545454ba87e0`
- 选用记录：按用户海报的大龟形象重绘圆脸、浅橄榄绿皮肤和头顶斑纹；去除老爬虫凶相，去除海报及球队元素。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/xiaogui.png`
完整记录：[PROMPTS-user-v12.json](PROMPTS-user-v12.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-user/xiaogui.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-ab2d4695-836a-423d-8af6-bfcd1138bca6.png`

```text
Use case: stylized-concept. Create ONE production-ready Battle Brothers game bust sprite on a genuinely transparent background. Image 1 is the user's identity/design reference ONLY. Image 2 is the official Battle Brothers STYLE AND PROPORTION reference ONLY; do not reproduce any of its men. Match its rough hand-painted 2D mercenary-token style: strong dark brown outlines, economical broad shadow planes, muted earthy colors, visible brush character, slightly exaggerated head and short cropped shoulders, readable at only 88 by 100 pixels in game. NOT photorealistic, NOT 3D, NOT smooth anime/gacha or cinematic portrait. Entire head, nose, eyes, neck, chest and shoulders face SCREEN-RIGHT in consistent three-quarter view, both eyes visible but nose projects to the right, no eye contact with viewer. One continuous compact bust from complete hair crown through a visible intact neck into short shoulders and an oval cut across upper chest. Head, chin and neck must NOT be cropped or severed; leave a clearly drawn neck connecting jaw to collar. Head occupies upper 60 percent of silhouette, neck/collar transition around 68 percent, short torso the bottom 30 percent. Keep ears/crown compatible with an overlaid game helmet; no raised arms, hands, full body, weapons, shields or floating props. Center with small empty margins. Simple low dark cloth neckline below the jaw, no thick scarf covering chin. No background, floor, shadow, text, logos, poster graphics or watermark. Paint all pixels freshly; do not paste photographs. Use ONLY the larger round green turtle mascot in image 1, not the smaller frog, sports kit, branding or lettering. Recognizable rounded friendly turtle head with soft pale olive/yellow-green skin, a few large muted darker shell-like patches on the upper head, short broad snout, small nostrils, dark expressive eyes with restrained painted highlights, warm subtle cheek color and a faint cheeky smile. Both eyes open, right-facing in battle. Reinterpret in the hand-painted medieval game's muted colors and broad shadow planes, not shiny anime. Rounded and companionable, NOT a grotesque wrinkled old reptile, not a frog, not an alien. Clear short sturdy neck leading into dull ochre linen and plain dark brown leather shoulder straps, a small turtle-shell rim just behind the shoulders, no huge shell.
```

颈部分界：`[[0, 108], [35, 108], [48, 113], [57, 123], [73, 123], [85, 113], [95, 108], [114, 108]]`。原图只作等比缩放和无损分层。

## 奶盖

- 最终文件：`art/runtime/portraits-v05/sources/facing/naigai.png`
- SHA256：`b70b73981f0382c3425f046e3b2db0d21d5e0882a93d49864bf5427a1b9b530f`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/naigai.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Right-facing head/chest and gaze, nearer shoulder broad/far side recedes. Long straight black hair, long face, fuller lips and buttoned brown garment retained.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/naigai.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-88ffb071-b4c8-4ac8-b20b-da3f9775334c.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 奶盖 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/naigai/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-2c48dd37-605c-40c6-989a-c5042263bdda.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Naigai, 奶盖. Long straight near-black hair parted a little off center, soft round cheeks narrowing gradually toward a small chin, natural straight brows rising slightly at ends, horizontally open almond eyes, moderately full lips and defined little cupid bow. Keep her face broad enough, do not give her the long thin jaw or brows of image 3. Quiet attentive, slightly parted mouth. Do not copy the makeup artist or their hands. Costume: worn warm-brown mercenary leather and a very short off-white wool collar, a small dull cream enamel clasp. No shield, no cup, no quiver, no hat.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```

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

- 最终文件：`art/runtime/portraits-v05/sources/user-v12/yaoyaoya.png`
- SHA256：`829a7913d4ff89a0a44a49c5d0943b7601ef4cdd4e956c6f2da72420919ae1fe`
- 选用记录：按用户提供形象重绘黑长发、女性面部和健壮肩颈；短胸像保留力量感，移除旧红色马尾及武器。

### 用户参考重绘 · 内置 ImageGen

旧图：`art/runtime/portraits-v05/sources/facing/yaoyaoya.png`
完整记录：[PROMPTS-user-v12.json](PROMPTS-user-v12.json)

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-27-user/yaoyaoya.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-4d5cca8f-fd4b-49cc-ac2f-a6802af91c48.png`

```text
Use case: stylized-concept. Create ONE production-ready Battle Brothers game bust sprite on a genuinely transparent background. Image 1 is the user's identity/design reference ONLY. Image 2 is the official Battle Brothers STYLE AND PROPORTION reference ONLY; do not reproduce any of its men. Match its rough hand-painted 2D mercenary-token style: strong dark brown outlines, economical broad shadow planes, muted earthy colors, visible brush character, slightly exaggerated head and short cropped shoulders, readable at only 88 by 100 pixels in game. NOT photorealistic, NOT 3D, NOT smooth anime/gacha or cinematic portrait. Entire head, nose, eyes, neck, chest and shoulders face SCREEN-RIGHT in consistent three-quarter view, both eyes visible but nose projects to the right, no eye contact with viewer. One continuous compact bust from complete hair crown through a visible intact neck into short shoulders and an oval cut across upper chest. Head, chin and neck must NOT be cropped or severed; leave a clearly drawn neck connecting jaw to collar. Head occupies upper 60 percent of silhouette, neck/collar transition around 68 percent, short torso the bottom 30 percent. Keep ears/crown compatible with an overlaid game helmet; no raised arms, hands, full body, weapons, shields or floating props. Center with small empty margins. Simple low dark cloth neckline below the jaw, no thick scarf covering chin. No background, floor, shadow, text, logos, poster graphics or watermark. Paint all pixels freshly; do not paste photographs. Adult athletic East Asian woman from image 1: long black hair parted near middle, thick flowing locks kept close enough to silhouette for sprite clarity; small oval face with distinct jaw, level dark brows, focused narrow-almond eyes, small straight nose and determined closed lips. Preserve unusually muscular robust shoulders and strong trapezius/neck from the supplied athletic reference, feminine face above powerful fighter shoulders. Simple weathered off-white linen training wrap covering upper chest with a small worn ochre fabric shoulder edge. No exposed chest cleavage, no modern shorts, no hands, fists, kick, weapons, ponytail or red ribbons. Express calm combative confidence.
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

## 陈知含

- 最终文件：`art/runtime/portraits-v05/sources/facing/chenzhihan.png`
- SHA256：`432c21fa1195928a5467b0ba2a731dd236ae4787bc8ad99dfef489e5b6810ae5`
- 选用记录：保留既有脸型、发型与衣装，头部、胸肩和视线统一朝画面右侧；实机验收范围见朝向测试记录。

### 朝右姿态修订

保留身份和服装；头部、胸肩和视线一起朝右。

原图：`art/runtime/portraits-v05/sources/chenzhihan.png`
完整记录：[PROMPTS-facing-b.json](PROMPTS-facing-b.json)

#### 朝向调用 1

检查记录：Viewed generated PNG individually. Head, chest and eyes point screen right; nearer left shoulder is wider. Preserves face shape, hairstyle, expression, garment and personal clasp details; no clipping.

参考输入：

- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/chenzhihan.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0dd71-b2e1-7d42-bd89-5a65aac80b5f\exec-5a20f36f-d8b2-4013-962b-75d8ca17bd8e.png`

```text
Use case: identity-preserve. Edit target is image 1: existing 陈知含 Battle Brothers mod pawn. Image 2 is the official Battle Brothers sprite reference; use its compact bust pose and painted game style only, do not copy its male faces. Change ONLY the facing pose. Rotate the whole head, chest, shoulders and eye gaze toward SCREEN RIGHT by 40 degrees, an unmistakable right-facing three-quarter tactical pawn. Both eyes remain visible but the far eye on screen right is narrower; nose points right and sits to the right of facial centre. The nearer shoulder on screen left projects wider and forward; screen-right shoulder recedes and narrows. Preserve this individual's exact face shape, facial features, expression, hair silhouette/color/parting, accessories, garment design and colors. Keep integrated head, hair, shoulders and short chest in one piece, roughly Battle Brothers proportions with compact shoulder base and no arms or legs. Thick dark brown painted contours, earthy muted palette, simple rough hand-painted flat shadow planes, readable at 114 pixels. No photorealism, no glossy/anime rendering, no extra items, text, frame or cast shadow. Actual transparent background; keep generous clear margin around whole uncut bust.
```

完整机器记录：[PROMPTS-group-b.json](PROMPTS-group-b.json)

### 调用 1

参考输入：

- `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/chenzhihan/reference-crop.png`
- `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
- `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

生成器输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-b8b2ab06-9926-486d-bfdd-56571ff0aeff.png`

```text
Use case: style-transfer / identity-preserve.
Create ONE complete transparent tactical bust for a Battle Brothers mod. Image 1 is the named subject photograph and the ONLY source of facial identity, hairstyle and age. Image 2 is the official Battle Brothers bust sheet and is ONLY a reference for drawing technique, compact head/shoulder proportions, view and restrained detail. Do not copy any face from image 2.
Translate the specific recognizable person in image 1 into that native game's small hand-painted pawn style, not a generic fantasy hero. Preserve their face width/length, jaw softness, eye shape/spacing, brow shape, nose and mouth character, hairline and hair silhouette. Use ordinary human ears. Do not sharpen everyone's chin, masculinize female faces, add angry V eyebrows, or substitute a doll/anime face.
A single attached head-neck-shoulders/short-upper-chest bust, slightly turned toward screen RIGHT with both eyes readable, large head, short neck and compact rounded shoulder base; face is the main identifying feature. No hands, arms, legs, weapons or background. The complete custom hair belongs inside this one image. Leave transparent margin around every edge.
Match the Battle Brothers sprites' economical slightly caricatured painted form: uneven dark brown contours, simple eye marks and a few broad cheek/nose shadows, muted warm skin, matte earth-colored cloth/leather, a handful of hair masses. Keep the actual person's natural expression. NOT polished fantasy comic art, photorealism, smooth beauty rendering, oil-paint texture, fine skin, glossy anime eyes, extreme sharp cheekbones, or modern clothing. Intended final size 114x142 pixels; draw for that size even if source output is larger. No text, labels, frame, cast shadow, backdrop, checkerboard or glow. Truly transparent background.

STRICT STYLE PASS: Face is a flat warm base with TWO large painted shadow regions only. Large deliberate brush shapes, dark uneven brown outline, simple eyelid strokes and tiny matte pupils. Nose described by ONE shadow plane, lips by one curved line. Hair in 5-8 broad clumps. Matte plain surfaces, no pores, no rim light, no delicate gradients or tiny individual hair strands. Remove 80 percent of realistic portrait rendering. Preserve the photographed person's own face proportions and relaxed/asymmetric expression, not any example character's face. Short compact torso, large attached head. Portrait must read as an old hand-drawn tactical pawn at 114x142 pixels. If a third image is provided, it demonstrates ONLY shading simplification and compact crop; NEVER copy its eyes, jaw, brows or hairstyle.

SUBJECT AND COSTUME:
Adult woman Chenzhihan, 陈知含. Dark brown long hair loosely gathered LOW over one shoulder, offset part with light wispy bangs and long temple locks, fairly long eyes with gently flat upper lids, softly rounded cheeks, a small nose and subtle upturned relaxed mouth corners. Keep this specific soft round face rather than a thin sharply pointed generic heroine. Costume: practical medium-brown cloth shoulders with very short pale wool collar, a single modest round ochre clasp with a simple pressed circular pastry motif. No headband, no pink knots, no phone, no hands or weapons.

FINAL PRIORITY: likeness comes exclusively from image 1; coarse flat paint and compact shape only from images 2 and 3. One complete very short bust with large head, facing screen RIGHT. Do not convert into polished comic/realistic portrait.
```
