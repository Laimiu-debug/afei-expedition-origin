# 阿飞游戏图层 v1｜实际生图提示词

日期：2026-09-26。工具：内置 image_gen。下列 14 张候选图的原始 PNG 全部保留在 sources/，用于当前 16 个试验画刷。本文件记录它们实际提交的英文提示词，机器可读记录见 [generation-prompts.json](generation-prompts.json)。额外返修尝试另见 [attempts.json](attempts/attempts.json)：人类死头 v2 已生成但方向仍未验收，蛤蟆死头 v2 调用中止、未取得输出。用户转向研究其他起源后暂停生图。

创作目标：参考旧版的原尺寸识别和锚点，改用头部、基础衣装、伤痕、倒地及独立飞碟图层。人类短黑发及人类伤痕调用原版画刷。后续导出只裁透明边、等比缩放与按坐标放置，不把整张概念胸像压进身体层。

旧版、概念稿和游戏参考图各有不同用途，具体参考顺序列在每个条目中。原版小图仅作参考和本地验收，发行 ZIP 不包含其副本。

## 01｜human-head

输出：[原始 PNG](sources/human-head.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/bust_head_01.png`
3. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer. Production game asset: ONE isolated BALD HEAD sprite for Afei, to layer under separate hair and helmets in Battle Brothers. Image 1 is the identity to preserve; images 2 and 3 are the actual game style and native head construction references, their art language takes priority.
Redraw image 1's adult roguishly handsome East Asian-inspired male face into the native game style of image 2. Keep strong slanted black eyebrows, low upper eyelids, alert eyes, broad firm cheekbones, slightly asymmetrical CLOSED mouth smirk. Slightly roughen and exaggerate the nose, brow and cheek planes like image 2; not a polished young anime idol. Three-quarter slightly elevated view facing viewer RIGHT. Full BALD skull, both ears as visible in the angle, face, jaw and very short bare neck stump ONLY. Hair will be a separate sprite, so paint a COMPLETE smooth bald scalp with NO stubble/no hair/no sideburns. No shirt, cloak, shoulders, torso, armor or accessories.
Native-style compact skull-to-face proportions; must fit a roughly 54 wide by 68 high game head slot when exported, not a tall portrait. Fine dark-brown outlines at native size, muted warm skin and a few economical painted shade planes; no near-black thick comic sticker outline, no polygonal facets, no dense brush streaks, no photographic details or pores, no airbrushed portrait, no anime eyes, no glossy lighting.
ONE head only centered, entire skull ears and neck enclosed, generous transparent margin on all sides. TRUE TRANSPARENT alpha background, no checkerboard drawing, no labels, no sheet, no cast shadow. This is a modular head layer, not a complete bust.
```

## 02｜toad-head

输出：[原始 PNG](sources/toad-head.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-toad-promoted-v01.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/bust_head_01.png`
3. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer. Production game asset: ONE isolated toad HEAD sprite for Afei's personal-combat promotion in Battle Brothers. Image 1 supplies the toad identity; images 2 and 3 supply native game rendering, compact skull size, viewpoint.
Redesign image 1 into ONLY a compact toad head with a short narrow throat base, facing viewer RIGHT in the same slightly elevated three-quarter camera as the native head in image 2. Strong slightly angular brow ridges, low amber eyes with small black pupils, broad CLOSED mouth with a very restrained crooked smirk, firm jaw. Keep recognizable grey-olive / earthy brown skin, paler lower jaw, just 3 or 4 simple bump markings. Improve its veteran fighter presence: tighten the cheeks and throat, reduce the enormous round pale throat, no giant triangular hanging neck, no baby frog eyes. Skull should be no wider than a normal human head with hair; restrained amphibian brow ridges so human helmets can cover the crown. No pointed fins, no crown extensions.
Match Battle Brothers native inked hand-painted game sprite treatment from images 2-3, muted 3-4 value shading, economical narrow dark contours, understated highlights. Avoid image 1's heavy near-black sticker outline, faceted polygon-like planes and fuzzy hatching. No realistic wet amphibian skin, no slime, no cinematic or anime portrait.
ONLY the complete head and a very short neck stump; remove ALL clothes, collar, cloak, shoulder plates, straps, torso and accessories. Head stays compact enough for a native approximately 58x66 head layer. Entire outline enclosed with generous clear margin. Genuine TRANSPARENT alpha background. No other heads or states, no text, no frame, no drop shadow.
```

## 03｜feidie

输出：[原始 PNG](sources/feidie.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-feidie-promoted-v01.png`
2. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: precise-object-edit. Production game sprite: extract and redraw ONLY the little flying saucer floating above the character in image 1, on TRUE TRANSPARENT background. Remove the entire person and everything other than the saucer. Image 2 is the native Battle Brothers game rendering reference.
Keep the saucer's simple low oval disk, small shallow central dome, dull dark steel body and one aged brass rim, viewed slightly from above. Simplify to 3 broad readable painted values, a thin dark brown contour and tiny muted highlight. Match the native hand-painted medieval equipment look; it must remain readable at about 34x16 pixels. No polygonal faceting, heavy sticker border, intricate mechanical details, realistic chrome, lights, beam, glow, exhaust or shadow.
ONE complete independent saucer sprite centered with generous transparent padding. Do not include a head, hair, body, other props, labels or checkerboard pattern. This will be a separate head-top overlay in the game.
```

## 04｜normal-body

输出：[原始 PNG](sources/normal-body.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01.png`
3. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer. Asset: ONE modular BODY/COSTUME sprite for the normal form of Afei in Battle Brothers. Image 1 is the costume identity to adapt, image 2 is the actual native body-layer geometry and camera reference, image 3 is native game style.
Draw ONLY the headless compact shoulder-and-chest costume. Remove the head, all facial skin, neck, hair entirely; leave the neck opening a clean transparent notch, for a separately layered game head to cover. Preserve this costume: plain grey-beige padded gambeson, simple charcoal short mantle and one plain brown fastening.
Rebuild into the body geometry of image 2: broad rounded shoulders and extremely SHORT upper chest, oval bottom cutoff, three-quarter facing viewer RIGHT, slightly overhead. Width-to-height approximately 82:74 INCLUDING shoulders/collar. Collar modest in height with natural opening that accepts a native head; do NOT include a long portrait torso or high rear collar that blocks the jaw. Center the neck opening slightly right of body center as in the actual game. No arms, hands, sleeves hanging down, legs or weapons or shield.
Use the restrained hand-painted native Battle Brothers sprite finish: dark brown thin contours when seen at game size, a few simplified material shadow shapes, subdued highlights, muted cloth/leather/iron colors. Limit quilting to a few lines, rivets to a few large marks; no dense hatching, polygon planes, oily realistic fabrics, cinematic realism or anime card-art. The new image will be exported at only 82x74; prioritize readable silhouette.
One complete BODY layer only, entire shoulders and bottom fully enclosed, generous clear transparent margin, TRUE alpha TRANSPARENT background. No head or bare neck stump, no dummy mannequin, no text or other views, no glow or ground shadow.
```

## 05｜toad-body

输出：[原始 PNG](sources/toad-body.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-toad-promoted-v01.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01.png`
3. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer. Asset: ONE modular BODY/COSTUME sprite for the toad form of Afei in Battle Brothers. Image 1 is the costume identity to adapt, image 2 is the actual native body-layer geometry and camera reference, image 3 is native game style.
Draw ONLY the headless compact shoulder-and-chest costume. Remove the head, all facial skin, neck, hair entirely; leave the neck opening a clean transparent notch, for a separately layered game head to cover. Preserve this costume: grey-beige quilted gambeson, short charcoal mantle, two SMALL dull iron shoulder plates and plain brown leather fastening.
Rebuild into the body geometry of image 2: broad rounded shoulders and extremely SHORT upper chest, oval bottom cutoff, three-quarter facing viewer RIGHT, slightly overhead. Width-to-height approximately 82:74 INCLUDING shoulders/collar. Collar modest in height with natural opening that accepts a native head; do NOT include a long portrait torso or high rear collar that blocks the jaw. Center the neck opening slightly right of body center as in the actual game. No arms, hands, sleeves hanging down, legs or weapons or shield.
Use the restrained hand-painted native Battle Brothers sprite finish: dark brown thin contours when seen at game size, a few simplified material shadow shapes, subdued highlights, muted cloth/leather/iron colors. Limit quilting to a few lines, rivets to a few large marks; no dense hatching, polygon planes, oily realistic fabrics, cinematic realism or anime card-art. The new image will be exported at only 82x74; prioritize readable silhouette.
One complete BODY layer only, entire shoulders and bottom fully enclosed, generous clear transparent margin, TRUE alpha TRANSPARENT background. No head or bare neck stump, no dummy mannequin, no text or other views, no glow or ground shadow.
```

## 06｜jiahao-body

输出：[原始 PNG](sources/jiahao-body.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-jiahao-promoted-v01.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01.png`
3. `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer. Asset: ONE modular BODY/COSTUME sprite for the jiahao form of Afei in Battle Brothers. Image 1 is the costume identity to adapt, image 2 is the actual native body-layer geometry and camera reference, image 3 is native game style.
Draw ONLY the headless compact shoulder-and-chest costume. Remove the head, all facial skin, neck, hair entirely; leave the neck opening a clean transparent notch, for a separately layered game head to cover. Preserve this costume: brown simple riveted leather brigandine, upright SHORT grey collar, charcoal short mantle with a muted burgundy border and one small aged brass fastening.
Rebuild into the body geometry of image 2: broad rounded shoulders and extremely SHORT upper chest, oval bottom cutoff, three-quarter facing viewer RIGHT, slightly overhead. Width-to-height approximately 82:74 INCLUDING shoulders/collar. Collar modest in height with natural opening that accepts a native head; do NOT include a long portrait torso or high rear collar that blocks the jaw. Center the neck opening slightly right of body center as in the actual game. No arms, hands, sleeves hanging down, legs or weapons or shield.
Use the restrained hand-painted native Battle Brothers sprite finish: dark brown thin contours when seen at game size, a few simplified material shadow shapes, subdued highlights, muted cloth/leather/iron colors. Limit quilting to a few lines, rivets to a few large marks; no dense hatching, polygon planes, oily realistic fabrics, cinematic realism or anime card-art. The new image will be exported at only 82x74; prioritize readable silhouette.
One complete BODY layer only, entire shoulders and bottom fully enclosed, generous clear transparent margin, TRUE alpha TRANSPARENT background. No head or bare neck stump, no dummy mannequin, no text or other views, no glow or ground shadow.
```

## 07｜human-head-dead

输出：[原始 PNG](sources/human-head-dead.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/runtime/afei/v1/sources/human-head.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/heads/bust_head_01_dead.png`

```text
Use case: identity-preserve. Asset: ONE DEAD HEAD sprite for a Battle Brothers game character. Image 1 is the living bald adult human Afei with strong angled brows and a broad jaw identity. Image 2 is the actual native corpse head sprite: match its lying-down position, camera direction, silhouette orientation and readable at 60x58 pixels construction.
Paint the head from image 1 deceased, eyes CLOSED and face slack with no smile, lying on its side as image 2 with crown to the upper LEFT and chin toward lower RIGHT, seen from the same slightly overhead camera. No upright floating living head. Preserve facial identity, muted warm skin, complete bald scalp (hair will be separate), strong brows and jaw, simple hand-painted shadows and narrow dark-brown contour. A small dried blood smear on the brow is enough; no gore or exposed tissue. Completely closed eyelids, no alive amber pupils. No neck gore.
ONE head only, no body/clothes/hair/equipment. Full head enclosed with transparent margin. TRUE TRANSPARENT alpha background. Native Battle Brothers cartoon battlefield sprite style, not photo-realism, not a detailed portrait, not 3D.
```

## 08｜toad-head-dead

输出：[原始 PNG](sources/toad-head-dead.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/runtime/afei/v1/sources/toad-head.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/heads/bust_head_01_dead.png`

```text
Use case: identity-preserve. Asset: ONE DEAD HEAD sprite for a Battle Brothers game character. Image 1 is the living grey-olive toad Afei with broad closed mouth, amber eye sockets and compact throat identity. Image 2 is the actual native corpse head sprite: match its lying-down position, camera direction, silhouette orientation and readable at 60x58 pixels construction.
Paint the head from image 1 deceased, eyes CLOSED and face slack with no smile, lying on its side as image 2 with crown to the upper LEFT and chin toward lower RIGHT, seen from the same slightly overhead camera. No upright floating living head. Preserve facial identity, muted olive-brown skin, ridged brow, broad mouth and light jaw, simple hand-painted shadows and narrow dark-brown contour. A small dried blood smear on the brow is enough; no gore or exposed tissue. Completely closed eyelids, no alive amber pupils. No neck gore.
ONE head only, no body/clothes/hair/equipment. Full head enclosed with transparent margin. TRUE TRANSPARENT alpha background. Native Battle Brothers cartoon battlefield sprite style, not photo-realism, not a detailed portrait, not 3D.
```

## 09｜body-injury

输出：[原始 PNG](sources/body-injury.png)。

全新绘制，不传入参考图。

```text
Use case: stylized-concept. Asset: ONE reusable transparent BLOOD AND SCUFF OVERLAY for a Battle Brothers tactical mercenary chest sprite. Draw ONLY a sparse small group of irregular dark dried-red blood stains and 2 rough cloth-scratch marks, arranged across a low WIDE shoulder/chest region. Left: one small diagonal slash with muted dark red short bleed. Middle-lower: a few uneven small spatters. Right: one smaller scraped smudge. Most of the layer MUST remain transparent so the game costume underneath stays visible. Marks should remain clearly readable at 74x40 pixels: chunky economical hand-painted marks, dark reddish brown fill and slightly darker inner marks, no detailed splatter spray.
Do NOT draw any body, skin, clothes, cloth silhouette, fabric panel, armor, person or contour around a chest. No full rectangular texture. Only the isolated irregular blood/scuff marks floating on TRUE TRANSPARENT alpha. No white fill between marks. Wide compact arrangement, generous clear margin all around. Medieval Battle Brothers ink-and-paint game sprite style, no photo textures, no gore, no text.
```

## 10｜normal-body-dead

输出：[原始 PNG](sources/normal-body-dead.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/runtime/afei/v1/sources/normal-body.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01_dead.png`

```text
Use case: identity-preserve. ONE Battle Brothers modular CORPSE BODY / fallen costume sprite. Image 1 is the live costume whose identity and colors must be preserved. Image 2 is the actual native corpse body geometry reference, and its TOP-DOWN FALLEN layout takes priority.
Redraw image 1's grey-beige gambeson with charcoal mantle and plain brown buckle collapsed on the ground as a dead mercenary's compact upper torso, WITHOUT ANY HEAD, neck skin, hair, arms, hands, legs or equipment. Like image 2, an asymmetrical low oval mass of flattened shoulders, crumpled folds and chest viewed from above, turned so the neck opening is toward the lower LEFT side where a separate corpse head will overlap. Do NOT give it an upright symmetrical empty vest presentation: this lies flat, and should match image 2's fallen posture.
Add only a few torn/scuffed cloth edges and small dried dark-red stains, no exposed tissue. Keep costume colors muted and slightly duller than alive. Simple dark-brown contours and economical 3-4 painted values, matching native Battle Brothers battlefield sprites; at export it will be only 106x88 pixels. No polished portrait rendering, no heavy black sticker outline, no background or ground shadow.
ONLY one fallen body/costume layer, whole silhouette inside canvas with clear margin. TRUE TRANSPARENT alpha. No floating head, skeleton, mannequin, text or labels.
```

## 11｜toad-body-dead

输出：[原始 PNG](sources/toad-body-dead.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/runtime/afei/v1/sources/toad-body.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01_dead.png`

```text
Use case: identity-preserve. ONE Battle Brothers modular CORPSE BODY / fallen costume sprite. Image 1 is the live costume whose identity and colors must be preserved. Image 2 is the actual native corpse body geometry reference, and its TOP-DOWN FALLEN layout takes priority.
Redraw image 1's grey-beige quilted gambeson with charcoal mantle, small iron shoulder plates and brown straps collapsed on the ground as a dead mercenary's compact upper torso, WITHOUT ANY HEAD, neck skin, hair, arms, hands, legs or equipment. Like image 2, an asymmetrical low oval mass of flattened shoulders, crumpled folds and chest viewed from above, turned so the neck opening is toward the lower LEFT side where a separate corpse head will overlap. Do NOT give it an upright symmetrical empty vest presentation: this lies flat, and should match image 2's fallen posture.
Add only a few torn/scuffed cloth edges and small dried dark-red stains, no exposed tissue. Keep costume colors muted and slightly duller than alive. Simple dark-brown contours and economical 3-4 painted values, matching native Battle Brothers battlefield sprites; at export it will be only 106x88 pixels. No polished portrait rendering, no heavy black sticker outline, no background or ground shadow.
ONLY one fallen body/costume layer, whole silhouette inside canvas with clear margin. TRUE TRANSPARENT alpha. No floating head, skeleton, mannequin, text or labels.
```

## 12｜jiahao-body-dead

输出：[原始 PNG](sources/jiahao-body-dead.png)。

参考图顺序：

1. `G:/CODE/afei-xcpedition/art/runtime/afei/v1/sources/jiahao-body.png`
2. `I:/afei-expedition/test-output/vanilla-layer-audit/entity_0/entity/bodies/bust_body_01_dead.png`

```text
Use case: identity-preserve. ONE Battle Brothers modular CORPSE BODY / fallen costume sprite. Image 1 is the live costume whose identity and colors must be preserved. Image 2 is the actual native corpse body geometry reference, and its TOP-DOWN FALLEN layout takes priority.
Redraw image 1's brown riveted leather brigandine, short grey collar and charcoal mantle with burgundy edge collapsed on the ground as a dead mercenary's compact upper torso, WITHOUT ANY HEAD, neck skin, hair, arms, hands, legs or equipment. Like image 2, an asymmetrical low oval mass of flattened shoulders, crumpled folds and chest viewed from above, turned so the neck opening is toward the lower LEFT side where a separate corpse head will overlap. Do NOT give it an upright symmetrical empty vest presentation: this lies flat, and should match image 2's fallen posture.
Add only a few torn/scuffed cloth edges and small dried dark-red stains, no exposed tissue. Keep costume colors muted and slightly duller than alive. Simple dark-brown contours and economical 3-4 painted values, matching native Battle Brothers battlefield sprites; at export it will be only 106x88 pixels. No polished portrait rendering, no heavy black sticker outline, no background or ground shadow.
ONLY one fallen body/costume layer, whole silhouette inside canvas with clear margin. TRUE TRANSPARENT alpha. No floating head, skeleton, mannequin, text or labels.
```

## 13｜toad-head-injury-01

输出：[原始 PNG](sources/toad-head-injury-01.png)。

全新绘制，不传入参考图。

```text
Use case: stylized-concept. ONE isolated transparent facial INJURY OVERLAY for a Battle Brothers toad warrior head, severity 1 of 2. Draw only a small irregular dark-red diagonal brow cut with one short downward blood streak, plus two tiny adjacent dried spatters. The marks have a slightly curved compact arrangement suitable for the brow and cheek of a small game head.
This must be ONLY blood marks and scratches. NO head, eyes, face, skin, frog, body, fabric or bounding silhouette. True TRANSPARENT alpha between and around all marks. The game paints this over an independently drawn face. Color: muted dried reddish brown and dark maroon, no bright scarlet or gloss, no exposed tissue. Native Battle Brothers hand-painted sprite, chunky simple economical marks legible when the entire overlay is 28x27 pixels. No thin noisy spray texture, no checkerboard painting, no labels. Clear transparent margin around the compact group.
```

## 14｜toad-head-injury-02

输出：[原始 PNG](sources/toad-head-injury-02.png)。

全新绘制，不传入参考图。

```text
Use case: stylized-concept. ONE isolated transparent facial INJURY OVERLAY for a Battle Brothers toad warrior head, severity 2 of 2. Draw only two irregular dark-red brow and cheek scratches, a short vertical blood streak and several small dried spatters, with more marks than a light scratch but most of the area still transparent. The marks have a slightly curved compact arrangement suitable for the brow and cheek of a small game head.
This must be ONLY blood marks and scratches. NO head, eyes, face, skin, frog, body, fabric or bounding silhouette. True TRANSPARENT alpha between and around all marks. The game paints this over an independently drawn face. Color: muted dried reddish brown and dark maroon, no bright scarlet or gloss, no exposed tissue. Native Battle Brothers hand-painted sprite, chunky simple economical marks legible when the entire overlay is 34x39 pixels. No thin noisy spray texture, no checkerboard painting, no labels. Clear transparent margin around the compact group.
```
