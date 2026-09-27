# v0.5 B 组照片转绘提示词与记录

日期：2026-09-26。使用内置 ImageGen，共 9 张独立生图；本组没有后续返修。参考原图、精确提示词与输出文件逐项保存。

照片仅作为公开外观参考，不进入 Mod。衣服、胸扣等属于游戏造型；照片中的滤镜、摄影透视不作为精确面部测量。所有头像已按 alpha≥20 的主体范围裁切、等比缩到 108×124 内并放入 114×142 预览检查；原始 PNG 保持原生透明像素。尚未在游戏引擎中验收。

对照预览：[照片与游戏尺寸](build/group-b-photos-and-game-size.png)。

## 玩蛇（wanshe）

- 选用源图：`art/runtime/portraits-v05/sources/wanshe.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-141963a9-0bf1-47fb-8d7b-912ecb092e74.png`
- SHA256：`858cd36f1394badb364f8849eb2f56ee8a3b2529847549ad46e14a8305bd72f4`
- 核对依据：单人近距离自拍直播画面；斗鱼8458376页面明确昵称玩蛇姐姐；同页头像与旧C25文件SHA256完全一致，链接到既有角色，不以脸相认。
- 参考局限：直播图头顶有裁切、视线向下；不能把旧插画的粉发箍当作真实发型。
- 本地复核：按照片保留低马尾、薄碎刘海、平眉狭长眼与微张嘴；蛇仅作为旧设定的小胸扣。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.douyu.com/8458376](https://www.douyu.com/8458376)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/wanshe/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 涂涂（tutu）

- 选用源图：`art/runtime/portraits-v05/sources/tutu.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-254f84b8-b970-442c-bc57-ac465be1352a.png`
- SHA256：`e956331dad7311e74a6f1488e448f5e748aad7af86f12172af2c18744ef6c0f0`
- 核对依据：涂涂吃饱了本人鱼吧公开动态《天冷加衣》，照片水印斗鱼@涂涂吃饱了；帖子作者与已核实99927房间昵称相同。
- 参考局限：2025-12旧造型、摄影/美颜可影响脸型；发色只按照片描述。
- 本地复核：纠正旧稿短发，保留照片长棕发和薄刘海；绿色衣物与短浅色毛领沿用游戏配色，兜帽移到脑后。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.douyu.com/99927](https://www.douyu.com/99927), [https://yuba.douyu.com/feed/2965382107494433206](https://yuba.douyu.com/feed/2965382107494433206)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/tutu/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 奶盖（naigai）

- 选用源图：`art/runtime/portraits-v05/sources/naigai.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-2c48dd37-605c-40c6-989a-c5042263bdda.png`
- SHA256：`6c2fae9f31d5ba0a05a3163ba0cd469dfb54021459e268792ea39d0ac9f2c246`
- 核对依据：公开B站视频标题“CSTG新主播奶盖开播”，封面大字同名；中心正面女性正接受化妆。
- 参考局限：旁边化妆师不是角色；原图上边缘略裁头顶，化妆滤镜不转为写实材质。
- 本地复核：保留近中分黑长发、横向眼型与柔和脸颊；没有把化妆师或手画入。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.bilibili.com/video/BV1ThtN6vEa7/](https://www.bilibili.com/video/BV1ThtN6vEa7/)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/naigai/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 小杰（xiaojie）

- 选用源图：`art/runtime/portraits-v05/sources/xiaojie.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-a12001f9-c024-4ace-8b1a-bf3644bb6d51.png`
- SHA256：`e79dbcd3ccfb7a2e033991943909ad9c7afedc6990aa05e555bb80c2050177f5`
- 核对依据：B站标题“【阿飞与小杰】小杰想锁阿飞车”；单一近脸特写，阿飞声音/字幕背景语境；旧参考中小杰为女性，与超级小桀无关。
- 参考局限：特写裁去头顶与一侧脸，发型只能确认后扎；不依据近摄透视夸大鼻子。
- 本地复核：依据后扎头发、鼻梁和收窄下颌作三分之二朝右转译；照片裁头顶，发束结构为最少补全；双钥匙为游戏衣饰。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.bilibili.com/video/BV1fGeG6HEKc/](https://www.bilibili.com/video/BV1fGeG6HEKc/)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaojie/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 苏袜（suwa）

- 选用源图：`art/runtime/portraits-v05/sources/suwa.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-85bcf68c-363c-4733-b052-9bf9088c21e5.png`
- SHA256：`e4f91792c10600e8cdd32948c8f18e2b924189f6b6913286f540ee1a164b8450`
- 核对依据：公开视频标题及封面“苏袜被弹幕串哭”均点名，画面唯一清晰人物。
- 参考局限：眼镜可作为此照造型选择，不能断言永远戴；不把哭泣充血当固有外貌。
- 本地复核：长深发、薄刘海和宽矩形黑框眼镜清晰保留；没有把哭泣或红眼固化为人物身份。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.bilibili.com/video/BV1DG4f6pEz5/](https://www.bilibili.com/video/BV1DG4f6pEz5/)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/suwa/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 千涵（qianhan）

- 选用源图：`art/runtime/portraits-v05/sources/qianhan.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-18842b30-a8b1-4680-be2f-2a35250ef1ef.png`
- SHA256：`8b6896df3ad767bb6164f80d9603df60f33030de607e7bf19e45fa08cebf1342`
- 核对依据：公开视频标题“今天是双马尾千涵”和封面同名字幕，唯一前景正脸；补图bilibili-style.jpg也明确千涵。
- 参考局限：此前三人合集封面不能独立定身份，已弃作主参考；双马尾是明确拍摄造型，可转成粗块轮廓。
- 本地复核：按具名照片保留双低马尾、宽额和圆缓下颌；眼睛使用小哑光瞳孔，未沿用单马尾旧稿。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.bilibili.com/video/BV1U8tz6PE6U/](https://www.bilibili.com/video/BV1U8tz6PE6U/)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/qianhan/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 王大芷（wangdazhi）

- 选用源图：`art/runtime/portraits-v05/sources/wangdazhi.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-f5d90423-d22b-4b29-8ab8-b09fa759975c.png`
- SHA256：`2bc53c52b48a214face3737334a9f239a20132f8d90097eaaa6857127e38c3b4`
- 核对依据：用户确认王大芷=芷芷；斗鱼12831589页面昵称芷芷QwQ单人自拍直播；舞台视频BV1tcbM61EyS字幕芷芷提供第二公开语境。
- 参考局限：头顶略裁切，眼睛向下且化妆显著；小痣可简化为一点，不凭镜像猜左右。
- 本地复核：纠正旧稿短发，保留棕色长直发、薄齐刘海、细长眼和小痣；紫围巾仅是旧设定服装。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.douyu.com/12831589](https://www.douyu.com/12831589)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/wangdazhi/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 羊咩咩（yangmiemie）

- 选用源图：`art/runtime/portraits-v05/sources/yangmiemie.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-9371d84c-c236-448e-8654-19c73e68f497.png`
- SHA256：`8ed8a4e11f4174cb832d12fdbbef83c1d977ebf75a07b558d0a73a166263c084`
- 核对依据：斗鱼6632房间名羊咩咩ee；画面广告写“羊咩咩942”，右侧主播摄像头位于其直播伴侣预览，实际房间4742942。
- 参考局限：有美颜与直播摄像头缩放；旧S7名册裁切触及汉堡标签，弃用；现图足以看发型五官，但不推断身高。
- 本地复核：按官方直播近照保留长直棕发、薄刘海和说话嘴形；弃用旧错误名册裁图与蓝帽，羊扣/铃为设定衣饰。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.douyu.com/6632](https://www.douyu.com/6632)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/yangmiemie/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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

## 陈知含（chenzhihan）

- 选用源图：`art/runtime/portraits-v05/sources/chenzhihan.png`
- 原始输出：`C:\Users\25647\.codex\generated_images\01a0dd56-7b16-7921-8180-e67f14d1c0d7\exec-b8b2ab06-9926-486d-bfdd-56571ff0aeff.png`
- SHA256：`e748731e84a841f641aa61cf3fc9c14ebd31fec77ed43102898e75b1a216dffb`
- 核对依据：斗鱼12832995页面明确陈知含or且直播标题CSTG郎团S1；画面为单人坐沙发面对手机自拍，B站封面另明确点名陈知含可交叉佐证。
- 参考局限：头像为动画不得用；本图五官受直播美颜影响，使用形状关系而非写真皮肤。
- 本地复核：按本人公开直播保留低束侧发、圆缓脸颊和细长眼；不使用动画头像；月饼纹仅为衣扣设计。 已逐张检查完整大头短肩轮廓、朝右、透明通道与 114×142 实际尺寸。
- 来源：[https://www.douyu.com/12832995](https://www.douyu.com/12832995)

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/chenzhihan/reference-crop.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png`

完整实际提示词：

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
