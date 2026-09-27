# 六位成员：公开照片参考版生图记录

日期：2026-09-26；工具：内置 image_gen.imagegen。共生成6张，每人1次，无二次修正。照片来源均已事先核对并查看。

这六张是待整体复核的 v0.5 美术候选，不等于用户最终认可或游戏实测通过。仅使用照片的发型、脸部比例和表情轮廓；画法参考官方《战场兄弟》胸像。bottle.png只作阴影简化与构图参考，不作为其他人的脸部模板。

技术处理仅复制原文件、读取透明通道、等比缩小和排预览。没有用Python改脸、补画、改姿势或重新涂色。

[114px深底预览](review/group-missing-114px.png) · [2倍放大](review/group-missing-114px-2x.png) · [浅底预览](review/group-missing-114px-light.png) · [精确JSON记录](PROMPTS-group-missing.json)

## 老蔡 / laocai

选定文件：[sources/laocai.png](sources/laocai.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-db842eb0-7115-42a9-bcfa-61f3be005c0e.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/laocai-attempt-1.png`。
SHA256：`ab26a47229b4b9cdd2657a71999743dc31bebccbcbfac1df387ff87856d1d15c`。

照片：[公开来源](https://vmobile.douyu.com/show/2Bj8vG3roaVvObnd)；[本地照片](../../references/2026-09-26-likeness/laocai/official-vod-20250118-face-crop.png)。

检查：宽圆面部、短黑发、窄眼与照片相符；灰蓝衣物保留；114px清晰，原图少量面部块面纹理比bottle略多。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/laocai/official-vod-20250118-face-crop.png` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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

## 小宁 / xiaoning

选定文件：[sources/xiaoning.png](sources/xiaoning.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-234eade2-78c6-4470-927b-234b125c96a7.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/xiaoning-attempt-1.png`。
SHA256：`70f6b1127344606c589ca456f884971751b2e85b3616d984432f17898a3275c8`。

照片：[公开来源](https://www.bilibili.com/video/BV1eS9CBjE2X/)；[本地照片](../../references/2026-09-26-likeness/xiaoning/BV1eS9CBjE2X-cover.jpg)。

检查：长棕发、露额偏中分、花耳饰与照片相符；补入口水游戏记号。照片滤镜对眼睛比例仍有影响；114px无写实皮肤或玻璃眼。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaoning/BV1eS9CBjE2X-cover.jpg` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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

## 小胖徐不快乐 / xiaopangxu

选定文件：[sources/xiaopangxu.png](sources/xiaopangxu.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-584b2c49-7cf9-497f-aede-2469fb8492c5.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/xiaopangxu-attempt-1.png`。
SHA256：`f4b08779630a9b722c4672ec67f37f77ea64d726421307bd755d8559d982563b`。

照片：[公开来源](https://www.douyu.com/7300160)；[本地照片](../../references/2026-09-26-likeness/xiaopangxu/avatar-20260926.jpg)。

检查：短棕bob和薄刘海、开朗不对称笑容保留，淘汰了无依据的辫子头带；114px与其他人可区分。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaopangxu/avatar-20260926.jpg` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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

## 蔓越莓 / manyuemei

选定文件：[sources/manyuemei.png](sources/manyuemei.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-de989910-f2ed-4f25-9dcb-913122b10c47.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/manyuemei-attempt-1.png`。
SHA256：`3a11f8213d1f01eb7d8620d400917bdb70446d038d7c4f660d118f9598c6bf75`。

照片：[公开来源](https://www.bilibili.com/video/BV19G9VBFEy8/)；[本地照片](../../references/2026-09-26-likeness/manyuemei/BV19G9VBFEy8-cover.jpg)。

检查：按具名回放的黑短bob、侧分及微张嘴形改编，保留莓红披肩。未复制原照覆盖字幕；114px识别轮廓清楚。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/manyuemei/BV19G9VBFEy8-cover.jpg` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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

## 小哈尼 / xiaohani

选定文件：[sources/xiaohani.png](sources/xiaohani.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-ec3511f6-3c5b-45fd-9057-8c079e54f8ca.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/xiaohani-attempt-1.png`。
SHA256：`82008b134939a5983bf95434cdd8aa903e5d4ab09cdd5eb0097c73aec1c81133`。

照片：[公开来源](https://yuba.douyu.com/feed/2892967498041343833)；[本地照片](../../references/2026-09-26-likeness/xiaohani/2892967498041343833-photo-3.jpg)。

检查：恢复参考自拍的深棕长发与较窄下颌，去掉前版原创短bob。保留灰蓝围巾、棕色旅装，114px轮廓完整。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/xiaohani/2892967498041343833-photo-3.jpg` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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

## 宋暖阳 / songnuanyang

选定文件：[sources/songnuanyang.png](sources/songnuanyang.png)。
原始工具输出：`C:\Users\25647\.codex\generated_images\01a0dd46-49db-7880-a1b1-e6936a243e85\exec-fa05359e-3173-48d2-9899-e9a13fe4a415.png`。
原图归档：`art/runtime/portraits-v05/archive/group-missing/songnuanyang-attempt-1.png`。
SHA256：`69ac02e3494e554374edc2e80b50caa9aec4c3c736309bef31bcbaa736221f85`。

照片：[公开来源](https://yuba.douyu.com/feed/2967845210136093171)；[本地照片](../../references/2026-09-26-likeness/songnuanyang/public-live-photo-4.jpg)。

检查：按本人公开照片改为后束黑发、露额及侧边碎发，鹌鹑梗缩为肩部斑纹。眼睛仍有照片美颜影响，但已使用哑光简化画法。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/references/2026-09-26-likeness/songnuanyang/public-live-photo-4.jpg` — Only facial identity and hairstyle, from named public source
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg` — Official Battle Brothers drawing/composition reference, never copy a face
3. `G:/CODE/afei-xcpedition/art/runtime/portraits-v05/sources/bottle.png` — bottle v05 shading simplification and compact crop only, never copy facial features

精确提示词：

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
