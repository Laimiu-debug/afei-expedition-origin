# 全员完整胸像：实际生图提示词与沿用记录 v0.4

日期：2026-09-26。当前 34 人、36 种主体外观。飞碟是独立装饰，继续使用既有资源；不在每个人的主图里重复生成。

**本轮规则：**一张透明胸像包含自己的头发、脸、脖子与服装。运行时隐藏原版人物及装备部件，保留选中与战斗状态提示。画风优先考虑 114×142 游戏尺寸下的粗轮廓、简单阴影、低饱和颜色和清晰特征，不追求真人照片。

本文件由 `tools/render_portrait_prompts.py` 从实际生成记录整理；英文段落保留实际提交的提示词。阿飞三形态与小酒瓶、李李、余初九属于复用，不冒充本轮重新生成。来源与最终指纹见 [manifest.json](manifest.json)，新图均使用内置 ImageGen。

小宁、小胖、蔓越莓、宋暖阳、小龟的标记来自用户确认；小哈尼与老蔡为待反馈的原创游戏造型，不宣称真人相貌还原。旧素材只作身份和设计参考，原版官方样本仅作画法参考，图集不复制原版素材。

## 01｜阿飞 · normal

- 角色键／画刷：`afei` / `afeix_p04_afei_normal`
- 选定源图：`art/character-concepts/afei/afei-normal-roguish-v02.png`
- 源图 SHA256：`383f8713d9620f31c76e47c86190073a42bd4f8b19d361ba0f10b9e08d3f5417`
- 沿用既有阿飞自制母图；原始记录：`art/character-concepts/afei/afei-normal-roguish-v02.json`
- 生成器原始输出：`C:/Users/25647/.codex/generated_images/01a0d853-067c-7780-9659-bb36db8ef972/exec-0ab5d6ae-77cf-4d1d-ae58-94bf1c887cfb.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `C:/Users/25647/.codex/generated_images/01a0d853-067c-7780-9659-bb36db8ef972/exec-1a12ac1e-e118-49a3-8ab8-fadf3c3ada74.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/bust_head_01.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/bust_body_01.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer.
EDIT IMAGE 1 ONLY: simplify its rendering into the original Battle Brothers in-game tactical sprite style. Preserve the same adult human Afei identity, black cropped hair silhouette, strong eyebrows, half-lidded alert eyes, small crooked CLOSED-mouth smile, grey-beige gambeson, charcoal mantle, brown fastening, camera direction and compact bust silhouette. Keep true transparency.

Image 1 is the edit target. Images 2 and 3 are the actual native sprite references. Image 4 is the official native bust sheet. Their visual economy is the required result, not merely a vague influence.

ONE CONTROLLED CHANGE: simplify all drawing and painting to native game sprite detail.
- Replace the target's mottled skin texture with a plain warm base and just two or three crisp, deliberately drawn shadow shapes. Each cheek is one simple painted plane, not a smooth beauty-portrait gradient.
- Describe each eye using a dark upper lid, a small flat pale eye shape and a dark dot; no realistic wet eyes or elaborate eyelid anatomy.
- Use a few broad graphic forms for the nose, jaw and ear. Strong, readable dark facial marks, mild native-game caricature. Keep the roguish handsome expression.
- Hair is about five or six solid dark clumps with a few broad highlights, not many individual locks or grainy strokes.
- The cloak has only a few major fold shadows. The gambeson has widely spaced plain seam marks. Erase fine fabric grain, scratches and decorative rendering noise.
- Use confident dark brown outlines and restrained hand-painted fill, matching the enlarged small sprites in the official sheet. The result must read like a small game paper-doll bust enlarged, not polished standalone concept art.

Keep one character, complete head and both shoulders, short torso, facing viewer's RIGHT, matching original native pawn proportions. A transparent margin surrounds it. Keep the face and costume identifiable while reducing the rendering complexity.
No new objects or costume changes, no frog, flag, weapon, text, background, pedestal, white edge, anime style, 3D shading, photoreal face, pixel-grid filter, stippling, speckled brush texture, or painterly canvas texture.
```

## 02｜阿飞 · toad

- 角色键／画刷：`afei` / `afeix_p04_afei_toad`
- 选定源图：`art/character-concepts/afei/afei-toad-promoted-v01.png`
- 源图 SHA256：`e0566647be9ba21b4e9e33d5de03adc29c6cab949dd644c314ccf1721828fb95`
- 沿用既有阿飞自制母图；原始记录：`art/character-concepts/afei/afei-toad-promoted-v01.json`
- 生成器原始输出：`C:/Users/25647/.codex/generated_images/01a0d853-067c-7780-9659-bb36db8ef972/exec-e286ca04-59ff-4613-ad18-b4f7dd9acdc0.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-toad-cold-v01.png`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: style-transfer.
Asset: ONE promoted TOAD-FOLK form of Afei for a Battle Brothers mod.

Image 1 is the old toad concept to improve. Its broad mouth, amphibian brow ridges and pale throat identify the character. It was judged not handsome enough.
Image 2 is the user's APPROVED VISUAL DIRECTION for Afei: use its simple graphic face planes, dark contours, chunky shading, small amount of detail and roguish confidence as the main rendering reference.
Image 3 is the official Battle Brothers native bust sheet: match its compact tactical pawn construction and view.

Redesign image 1 into a sharper, capable-looking toad warrior, the personal-combat promotion of the same Afei. Broader angular brow ridges, narrow focused amber eyes with a little asymmetry, a wide closed mouth with one corner very subtly raised. Tighten the jaw and cheeks. The pale throat remains visible but compact, no inflated sagging bag or huge round chin. Head clearly amphibian, without human hair or a human face pasted on. His self-confidence and alert eyes relate him to image 2.
Muted grey-olive and muddy brown skin, simple pale beige throat plane, no more than a few large toad marks. Robust compact shoulders, upright confident posture, not a giant hulking monster. A practical grey-beige padded coat, a few small dark iron shoulder plates, short neatly gathered charcoal mantle and simple brown leather fastening. Equipment slightly more capable than his starting outfit but still humble mercenary gear.
STRICT rendering match to image 2: flat hand-painted base colors with only two or three deliberate shadow values, dark brown outlines, a few crisp facial marks and cloak folds. Erase dense skin mottling, pores, wet shine, brush speckles and fabric noise. Preserve native-game small-sprite readability.
Match image 2's slightly elevated three-quarter view facing viewer's RIGHT, large head, short neck and very short shoulder-and-chest body. Both shoulders, whole head and complete lower bust silhouette visible with transparent margin. No arms, hands, legs, weapon, shield, flagpole, extra animal, background or ground.
One calm closed-mouth character only, genuinely transparent alpha. No photoreal frog, oil-paint portrait detail, anime eyes, toy proportions, cinematic light, glows, 3D, text or frame.
```

## 03｜阿飞 · jiahao

- 角色键／画刷：`afei` / `afeix_p04_afei_jiahao`
- 选定源图：`art/character-concepts/afei/afei-jiahao-promoted-v01.png`
- 源图 SHA256：`884b95ada340f3b9212691a2d84ab51b491b1b5b12df1b125352eb16e143681f`
- 沿用既有阿飞自制母图；原始记录：`art/character-concepts/afei/afei-jiahao-promoted-v01.json`
- 生成器原始输出：`C:/Users/25647/.codex/generated_images/01a0d853-067c-7780-9659-bb36db8ef972/exec-1068abf7-2bdd-483d-bd1d-a4669a1eaa65.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`

```text
Use case: identity-preserve.
Asset: ONE JIAHAO promoted commander form of Afei for a Battle Brothers mod.

Image 1 is the approved starting-form visual direction and the EDIT TARGET. Keep EXACTLY the same recognizable human face, age, skin color, cropped black hair silhouette, slanted dark brows, low upper eyelids, alert eyes and roguish small closed-mouth half-smile. He must look like the same man after promotion.
Image 2 is the official Battle Brothers native bust sheet, a style/proportion reference.

Change his costume and bearing to an experienced charismatic mercenary captain whose role is to inspire and lead companions. Upright compact shoulders and a subtly raised chin, composed confidence with a trace of swagger. Keep the eyes clear and serious enough to command when needed.
Replace the poor grey-beige starter coat with neat dark brown leather or brigandine over a muted grey underlayer. A well-kept short charcoal mantle has a small muted burgundy lining visible at its edge. A modest upright collar frames the jaw without obscuring it. One clear OLD BRASS clasp is the main ornament, at the same chest fastening position as the starting form. A few simple armor seams and muted rivets only. Convey a step up in presence through clean silhouette and organized clothing, not excessive wealth.
STRICTLY retain image 1's simplified graphic rendering: broad matte color planes, two or three restrained shadow values, dark brown contours, chunky hair groups, crisp simplified brows, nose and mouth. No increase in skin realism or detailed fabric texture. Native-game small-sprite readability is essential.
Keep the same slightly elevated three-quarter camera facing viewer's RIGHT, large head and compact short shoulder/chest tactical pawn proportions, full head and both shoulders visible. Leave transparent margin around the intact lower bust.
No arms, hands, legs, weapons, shields, crowns, coins in the air, frog companion, flying saucer, flagpole, glowing aura, ornamental portrait background, anime beautification, photoreal skin, glossy 3D, text or frame.
One character only. TRUE transparent alpha background.
```

## 04｜王大谋

- 角色键／画刷：`damou` / `afeix_p04_damou`
- 选定源图：`art/runtime/portraits-v04/sources/damou.png`
- 源图 SHA256：`7560313a351cddde2169cdb9bae1e52976cc3506671386f1fb4ee66f937a5347`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-98d1fff4-2250-4cd6-bae8-c97a3b7b3162.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/coherent-v2/afei_figure_C03.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Short dusty purple hair, broad adult male face and square jaw, heavy stern eyebrows, dark green scarf, brown padded leather shoulders; confident strong deputy captain.
```

## 05｜午夜抹抹茶

- 角色键／画刷：`mocha` / `afeix_p04_mocha`
- 选定源图：`art/runtime/portraits-v04/sources/mocha.png`
- 源图 SHA256：`0766f294ef2d720598286a3683fe16a7859f602dc0a6b16cd8300d3f1e9a2e21`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-2451ad86-3634-41b5-a087-f2023d5306c0.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/coherent-v2/afei_figure_C02.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Messy chestnut short hair, black rectangular spectacles, mouth open in a cheeky calculating grin, slightly pointed ears from the old fantasy design, weathered green-brown merchant leather outfit. Adult male.
```

## 06｜小酒瓶

- 角色键／画刷：`bottle` / `afeix_p04_bottle`
- 选定源图：`art/runtime/portraits-v04/sources/bottle.png`
- 源图 SHA256：`a79d4318fed367be33a2d8bb0fd8397111665e1e7ea86d1ee249d2bff107aaa6`
- 本轮沿用旧自制完整胸像；以下为归档保存的提示词说明，未重新调用生成。

C04：保留小酒瓶的温和表情、深棕长发、金色耳饰与黑色绗缝高领。只将画法改为粗糙手绘阴影、浓重不规则墨线和暗赭色调，保持朝屏幕右侧的三分之四胸像、透明背景；不要武器、盾牌、头盔或文字。

[原始三人提示词记录](../../../legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/battle-style-v6/PROMPTS.md)

## 07｜白小帅子

- 角色键／画刷：`shuaizi` / `afeix_p04_shuaizi`
- 选定源图：`art/runtime/portraits-v04/sources/shuaizi.png`
- 源图 SHA256：`10ac891ae4d4b704987f8bc35271fbd0134f8c9513c5085bf8eab0f8eb346c4f`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-113790eb-6a17-4e1f-93a3-abed77500e65.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C09.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with dark almost-black twin braids and dusty pink hair ties, small worried yet brave expression, brick-red scarf, muted leather. Preserve a compact drum motif as a little round drum medallion on the chest, NOT a large drum or hands.
```

## 08｜李李超欧

- 角色键／画刷：`lili` / `afeix_p04_lili`
- 选定源图：`art/runtime/portraits-v04/sources/lili.png`
- 源图 SHA256：`e8c6cdfbd08e0a2d9d72a7c89715741ff9c0f29960097636a33d94c35bd6cca5`
- 本轮沿用旧自制完整胸像；以下为归档保存的提示词说明，未重新调用生成。

C05：保留李李的圆润脸型、大眼、短棕发、左侧奶油色花饰、灰色衣服和肩带。只加强手绘笔触与墨线，减少平滑皮肤质感，保持完整胸像与透明背景；不要武器、盾牌、头盔或文字。

[原始三人提示词记录](../../../legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/battle-style-v6/PROMPTS.md)

## 09｜小月牙

- 角色键／画刷：`xiaoyueya` / `afeix_p04_xiaoyueya`
- 选定源图：`art/runtime/portraits-v04/sources/xiaoyueya.png`
- 源图 SHA256：`0d5575d95aed855631836d2ecac1527e24218e39befe68128b8b00ef143b9fde`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-c7be70a6-bcf3-47c1-a24b-99e30874c6b7.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C07.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with dusty blue high ponytail, tiny pale-gold star hair ornament, slightly impish alert expression, muted ochre scarf and blue-brown leather clothing.
```

## 10｜余初九

- 角色键／画刷：`yuchujiu` / `afeix_p04_yuchujiu`
- 选定源图：`art/runtime/portraits-v04/sources/yuchujiu.png`
- 源图 SHA256：`d1db8df1a0e1c8215c5409df1449638558e5c8257d2035b09a02da09befb21a7`
- 本轮沿用旧自制完整胸像；以下为归档保存的提示词说明，未重新调用生成。

C06：保留余初九的椭圆脸、略垂的杏眼、薄刘海、米色褶边发饰、米色衣服、青绿色领口与爪印。只改为厚重不规则墨线、宽阔手绘阴影和低饱和赭绿灰色，保持完整胸像与透明背景；不要武器、盾牌、头盔或文字。

[原始三人提示词记录](../../../legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/battle-style-v6/PROMPTS.md)

## 11｜小鱼贝壳

- 角色键／画刷：`xiaoyubeike` / `afeix_p04_xiaoyubeike`
- 选定源图：`art/runtime/portraits-v04/sources/xiaoyubeike.png`
- 源图 SHA256：`f918e202aba31f5142c7c8eb2695ed7c51120e1b595e62b064906231d21c3458`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-c88c9b3d-afa5-4457-8f37-9c35407f66b2.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C08.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with soft white-grey hood, dark hair framing face, calm responsible determined expression, muted dark travel leather and a small shell-shaped clasp. Remove large shield.
```

## 12｜王怼怼

- 角色键／画刷：`wangduidui` / `afeix_p04_wangduidui`
- 选定源图：`art/runtime/portraits-v04/sources/wangduidui.png`
- 源图 SHA256：`a5133eae972f190f6d0352c61438d29cccf0ddc6ab73a3c1bb26f9bace4bd8fd`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-a151b3b2-8806-4109-907a-1bfbb8e3b13e.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C10.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with long warm brown hair, pale flower hairpin, dusty purple drape over leather shoulders, raised critical eyebrow and knowing challenging half-smile. Remove long weapon and flag.
```

## 13｜老蔡

- 角色键／画刷：`laocai` / `afeix_p04_laocai`
- 选定源图：`art/runtime/portraits-v04/sources/laocai.png`
- 源图 SHA256：`8c5dd1f16149c1a21ffd14761afa0cc59544e94509b9493fcb81c656663787e4`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-9ff06acc-996e-48d5-b436-1fb04ff013fe.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult male HUMAN medieval tactical adviser. Original provisional game design, no claim of exact real-person likeness. Short neat black hair brushed back with one uneven fringe, narrow thoughtful eyes, broad straight eyebrows, an angular long jaw and thin closed mouth; clean-shaven, no elderly stereotype or white hair. A slate-blue standing-collar short wool coat over a little dark dull chainmail at the neck, folded square gray shoulder cape, one tiny folded parchment edge tucked at the chest, no written marks. Composed slightly stern expression. A head-dominant compact mercenary bust, subdued slate blue and brown, no elegant anime man, no realistic portrait, no oversized scroll or staff.
```

## 14｜亿口甜筒

- 角色键／画刷：`tiantong` / `afeix_p04_tiantong`
- 选定源图：`art/runtime/portraits-v04/sources/tiantong.png`
- 源图 SHA256：`9e8906af7ac0a01d141dc9e4c9f059bbde394ee2d348d5cbb32ed330871efb0e`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-fff0d6fc-9228-43fa-89d9-f63e40245eab.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C12.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with warm brown hair, round dark spectacles and restrained friendly expression, distinctive ochre tiger-striped scarf, worn medieval messenger leather. Remove long bow and quiver.
```

## 15｜小宁

- 角色键／画刷：`xiaoning` / `afeix_p04_xiaoning`
- 选定源图：`art/runtime/portraits-v04/sources/xiaoning.png`
- 源图 SHA256：`55f70f4f5b173cc2c2c0ce6813401a535e184c505e37c14dd58b1625eb5f4517`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-33f6590d-8648-43ae-9662-ff24066929c9.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult female human eccentric scout, narrow oval face, wide-set distracted small eyes looking a little upward, short untidy dark bob with two uneven stubborn tufts that suggest an 'alien' nickname without making her an actual alien. A single tiny comic droplet at one corner of a slightly open mouth, charmingly absent-minded rather than sick or distressed. Muted dusty teal short cowl over plain weathered brown quilted clothing. Lean short shoulder silhouette. No green skin or science fiction. Original game design from the supplied nickname, not a real person's likeness.
```

## 16｜小胖徐不快乐

- 角色键／画刷：`xiaopangxu` / `afeix_p04_xiaopangxu`
- 选定源图：`art/runtime/portraits-v04/sources/xiaopangxu.png`
- 源图 SHA256：`528375522598d56273c5b87b00efb550b61d30ec3bbd6c05fbc860e78debcc37`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-4361b5e0-16c9-4b9f-ae19-ea1f48b0f310.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult female human street-dance-inspired medieval skirmisher, angular cheekbones, concentrated sideways grin, alert narrow eyes and strong eyebrows, black hair tightly braided back under a short ochre cloth headband. Asymmetrical one-shoulder brown leather guard, warm ochre collar, one small tied cloth knot close to the shoulder. Energetic tilted head and offset shoulders suggest rhythmic footwork without showing legs or modern dance gear. Ordinary athletic build, do not infer a fat body from her nickname. Keep silhouette compact and sturdy.
```

## 17｜大鹅

- 角色键／画刷：`dae` / `afeix_p04_dae`
- 选定源图：`art/runtime/portraits-v04/sources/dae.png`
- 源图 SHA256：`7b42f6e3179d347b118ce15e1e405b9df2f550e2fbe0bdf1005da20193639872`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-a16f4e6f-8fe8-4ea9-b5d3-12e1824b635c.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C13.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with long brown hair, white-grey fur collar, assertive unamused eyes, brown leather shoulders, compact white goose-head-shaped shoulder brooch with orange beak as identifying motif. Remove oversized shield and large separate goose.
```

## 18｜蔓越莓

- 角色键／画刷：`manyuemei` / `afeix_p04_manyuemei`
- 选定源图：`art/runtime/portraits-v04/sources/manyuemei.png`
- 源图 SHA256：`e2920d84e39810a59ebf22fa3c6ca78c6b0958a1ce7fb1a1ed411a7561e00c7a`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-b39e0ac9-e263-4bc5-896e-92a8c38b24db.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult female human tactician with a commanding gaze, long narrow face, one slightly raised sharp eyebrow and closed unsmiling mouth, black hair swept tightly back into a clearly visible low short braid. High charcoal standing collar, muted cranberry-red short shoulder cape, one plain aged iron clasp. Upright composed shoulders and authoritative expression. Fully covered functional medieval clothing, no sexualized features, no whip, no bondage. Use the cranberry cape and geometric upright silhouette to distinguish her.
```

## 19｜小哈尼

- 角色键／画刷：`xiaohani` / `afeix_p04_xiaohani`
- 选定源图：`art/runtime/portraits-v04/sources/xiaohani.png`
- 源图 SHA256：`f4d0040adb853dd3b2c41e7a04202409c6f621dba829de4acf7892c6e4566660`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-fc238d45-cda8-4a8d-8262-383dc416ba3a.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult female human wandering recruit with a broad softly square face, small steady eyes, calm reserved expression, short chestnut bob with a blunt uneven fringe. A weathered oatmeal-colored small hood pushed behind the head, a single muted slate-blue scarf fold and simple brown travel tunic. Humble approachable distinctive silhouette, no jeweled beauty styling. This is an original provisional game character, not a representation of a real person's unknown face. Keep her visually separate from black-haired and red-caped teammates.
```

## 20｜可可

- 角色键／画刷：`keke` / `afeix_p04_keke`
- 选定源图：`art/runtime/portraits-v04/sources/keke.png`
- 源图 SHA256：`fc9e419a561c7da205bca58806613acd49532310e8863b39ee1ab8fab5a41459`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-baf86b5c-806a-4a20-a455-7884754fed1c.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C17.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with brown high ponytail tied with a brick-red ribbon, brick-red scarf, focused watchful eyes and faint dry half-smile, russet brown travel leather. Remove large crossbow and hands.
```

## 21｜余想

- 角色键／画刷：`yuxiang` / `afeix_p04_yuxiang`
- 选定源图：`art/runtime/portraits-v04/sources/yuxiang.png`
- 源图 SHA256：`be574515978475db472c9044c0ceab91df686cdc497d6eafe565142a80ce7b3b`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-3486aed6-9dd3-4f13-aef0-88e217c03fb1.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C20.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with long deep brown hair and a pale flower tucked into it, dusty plum cloak, calm steady thoughtful expression, little antique brass lantern-shaped chest clasp. Remove large handheld lantern and hands. Keep this woman's face distinct: gently rounded cheeks, a small straight nose, horizontal relaxed eyebrows and a closed neutral mouth with soft corners. Her look is patient and thoughtful, NOT Afei's angular male jaw, thick slanted eyebrows or signature smirk. Retain the reference woman's gently oval facial silhouette.
```

### 定向返修（已选用）

Restore omitted identifying lantern and separate Yu Xiang's silhouette from Wang Duidui using one low braid.

生成器输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-3486aed6-9dd3-4f13-aef0-88e217c03fb1.png`

输入参考：`G:/CODE/afei-xcpedition/art/runtime/portraits-v04/sources/yuxiang.png`、`G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C20.png`、`G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`、`G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: targeted image edit / character differentiation. IMAGE 1 is the ONLY EDIT TARGET: the already finished transparent Battle Brothers bust of Yu Xiang. IMAGE 2 is the legacy identity reference, where the distinctive object is a lantern. IMAGE 3 is ONLY the official compact bust proportion reference. IMAGE 4 is ONLY the coarse painted line/color style reference; NEVER copy its face. Keep image 1's own calm adult female oval face, natural small eyes, relaxed mostly straight eyebrows, closed neutral mouth, purple travel cloak, pale flower, short chest proportions, right-facing three-quarter pose, rough dark outlines, simple flat earthy painted shading, and transparent alpha background. Make ONLY these two controlled identifying changes: (1) REPLACE the round gold flower-shaped chest clasp with an unmistakable little old brass LANTERN hung against the upper chest, under her chin and clear of her face, approximately one quarter of the face height. Draw its small handle, dark box frame and one simple muted amber glass pane. It must read as a lantern silhouette at 114px; no light rays or halo, no hands, no floating object, no extra large prop. (2) Gather the hair that falls over the viewer-left shoulder into ONE visibly chunky loose low braid resting on that shoulder, keeping the remainder of the long brown hair and pale flower. This distinguishes her from another long-haired purple-cloaked party member. Keep head and figure scale unchanged, with an intact rounded lower chest contour. Do not change her into a man or into Afei; no sharp V-shaped heavy masculine eyebrows or signature smirk. Maintain matte hand-painted Battle Brothers game-bust appearance, NOT photorealism or anime. Output one complete isolated bust as true transparent PNG, no background, labels, borders, or checkerboard.
```

## 22｜童猪

- 角色键／画刷：`tongzhu` / `afeix_p04_tongzhu`
- 选定源图：`art/runtime/portraits-v04/sources/tongzhu.png`
- 源图 SHA256：`0f51983d2a5035cd64da3713cd01fa44824e4db683027d16074f72a9f4127d7a`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-7260b9d3-ffd6-44b3-9460-0a8c466c28ab.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C18.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with long nearly black hair, heavy straight fringe, dusty blue cloak, serious small-eyed face, small carved wooden bear head chest badge. Remove tall blue banner and spear. Keep this woman's face distinct: a broad softly rounded face with full cheeks, short upturned nose, compact straight brows under blunt bangs, slightly pursed lips and a deadpan quizzical expression. Do not copy Afei's long angular face or smug smile. Adult, not baby-faced.
```

## 23｜美伢

- 角色键／画刷：`meiya` / `afeix_p04_meiya`
- 选定源图：`art/runtime/portraits-v04/sources/meiya.png`
- 源图 SHA256：`2c4f63d9ed6d98452e36de78a9839d1e50fa74a74d5584f2c2c5570d1c986237`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-b9f3-7e10-8bf5-116ccc83ae77\exec-ff8210b7-0d89-4917-bc26-bc953de4175e.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C21.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer. Create one finished transparent PNG tactical character bust for a Battle Brothers mod. INPUT ROLES: Image 1 is the ONLY character to edit and the source of this person's identity cues. Image 2 is the official Battle Brothers reference sheet for compact bust proportions, adult facial construction, three-quarter angle and readability; do NOT copy any of its faces or bare torsos. Image 3 is only a reference for coarse hand-painted color blocks, rough dark contour and understated expression; do NOT copy Afei's face, haircut, clothes or sex. Redraw the complete integrated figure from image 1 in the gritty illustrated 2D Battle Brothers visual language. Keep the specific identity anchors below. One head, own original hair, neck, shoulders and simple clothing form ONE coherent compact upper-chest bust. Full silhouette visible with comfortable transparent padding, facing the viewer's RIGHT in mild three-quarter view, near-orthographic game-token view. Oversized but adult head approximately 60 percent of bust height, short sturdy neck, compressed torso, broad shoulders roughly 1.45 times head width. End upper chest at a deliberate shallow rounded bottom contour, not a straight photograph crop. No lower body, no hands, no long weapons, no full shield, no large props protruding above the head. Big readable angular color planes, heavy slightly uneven dark brown outer line, economical interior lines, subdued earthy colors, weathered matte cloth and leather, only two or three simple shadow tones. Small expressive natural eyes with heavy lids, clear nose and jaw planes, adult proportions; NOT photorealistic, NOT 3D, NOT anime, NOT manga, NOT big glossy eyes, NOT delicate pretty portrait rendering, NOT elaborate engraving or micro-textures. Optimized to remain recognizable at roughly 108x130 pixels. Character and clothing must be opaque; true transparent alpha everywhere outside the silhouette. Absolutely no white/grey background, checkerboard pattern, vignette, glow, cast shadow, text, labels, border, or additional figures. Do not use or overlay native game head/hair/face components; draw this character's own complete head and hair as part of the single illustration. IDENTITY TO PRESERVE FROM IMAGE 1: Adult woman with long dark brown hair, dusty rose medieval soft cap, confident theatrical squint and one raised brow, worn brown and wine-red travelling clothes, small ivory theatre fox-mask ornament at side of cap which must not cover her face. Keep this woman's face distinct: elongated oval face, high thin arched brows with one lifted, long narrow nose, a small asymmetric theatrical smile, clear mature eyelids. Do not copy Afei's thick slanted brows or square jaw. Retain the reference woman's self-possessed expression.
```

## 24｜玩蛇

- 角色键／画刷：`wanshe` / `afeix_p04_wanshe`
- 选定源图：`art/runtime/portraits-v04/sources/wanshe.png`
- 源图 SHA256：`5a56c4676de5088edd9ad2404532d4a5427da0bd465518ecf311a74dcb56d3a2`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-6cef96c8-c44d-4e9b-a569-c9486b486b25.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C25.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Wanshe. Preserve the dusty muted pink head scarf framing long dark hair, serious narrow-eyed expression, dark worn brown/olive clothing, and the small coiled green snake ornament at her shoulder. The snake is a compact identity ornament, not proof of a nonhuman species. No long snake staff or weapon extending above the head.
```

## 25｜涂涂

- 角色键／画刷：`tutu` / `afeix_p04_tutu`
- 选定源图：`art/runtime/portraits-v04/sources/tutu.png`
- 源图 SHA256：`b51c18433c0de693dd1d3de3152fdd67ddbb278ce7e7b7635fd756b647bedddb`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-57f188ce-6b37-4935-994e-ceba9248fbb3.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C16.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Tutu. Preserve the deep moss-green hood with a thick but simplified pale fur rim, tousled short black hair, thoughtful slightly weary eyes, brown leather fastenings, and the folded parchment travel letter held close to the lower chest. Keep the hood compact enough to show her full adult face; omit the tall sword behind her.
```

## 26｜宋暖阳

- 角色键／画刷：`songnuanyang` / `afeix_p04_songnuanyang`
- 选定源图：`art/runtime/portraits-v04/sources/songnuanyang.png`
- 源图 SHA256：`073bd67a6b81c41d490e71a56f45f37a8e7590190455086fd862043ac4a3a530`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-574cae1f-8d8b-4f1a-91d6-d54662c39dda.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: An adult female HUMAN scout inspired by the nickname 'quail', short rounded neck-tucked shoulder silhouette, round cheeks, small watchful eyes, a hesitant but determined closed mouth. Warm dark-brown chin-length hair inside a compact mottled-brown padded hood whose silhouette suggests a quail, one short brown feather tied at the side. Dull warm cream collar with three broad dark-brown spots. She remains fully human, no beak or bird anatomy. Rustic muted warm browns and clear low silhouette, avoid cutesy anime or baby proportions.
```

## 27｜溺水小龟

- 角色键／画刷：`xiaogui` / `afeix_p04_xiaogui`
- 选定源图：`art/runtime/portraits-v04/sources/xiaogui.png`
- 源图 SHA256：`e1f889b172a960ba85cd7c4af0d44e1cd3976db240fc9d0ba22e90c94e12ab58`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0d853-067c-7780-9659-bb36db8ef972\exec-6ac41697-9073-47e6-a678-752b4abe64bc.png`

```text
Use case: stylized-concept. Create one original complete integrated character bust sprite for a Battle Brothers mod. This is a game piece for a tiny 114x142 slot, not a realistic portrait or a full-length illustration. Single compact head-and-shoulders bust with all hair, face, neck and clothing painted together in one silhouette, front three-quarter view facing screen-right, large head, very short neck, short shoulders/upper chest ending in a rounded base. Genuinely transparent background, comfortable transparent margin, centered. Match Battle Brothers coarse medieval mercenary art: thick irregular dark-brown contour, simplified angular facial planes, two or three broad painted shadow shapes, desaturated ochre/olive/gray palette, visible economical hand-painted marks, matte worn cloth and leather. Sharp readable silhouette at tiny size. No anime eyes, no smooth doll face, no photoreal skin, no fine pores, no glossy 3D, no gradients, no modern clothing, no frame, no UI, no floor shadow, no text or labels. Do not add a separate extra figure, arms, legs, big weapon, shield, or long accessory. The hair must be original drawn hair fully integrated with this character.
Subject and defining features: A male anthropomorphic small turtle mercenary avatar, with NO HUMAN FACE and no human hair. Broad squat moss-olive turtle head, small intelligent amber eyes under thick low brows, dry wry half-smile, short thick neck, beige segmented plastron over the upper chest, a rounded dark olive shell rim visible behind both shoulders. Worn charcoal cloth collar and two plain brown leather straps integrated into one compact bust. A tiny faded red cloth knot near one shoulder is the only accent. Sturdy adult companion, not a baby mascot; no ninja mask, no famous cartoon character costume, no snorkel or water, no realistic reptile texture. The silhouette should read as a turtle at very small size.
```

## 28｜奶盖

- 角色键／画刷：`naigai` / `afeix_p04_naigai`
- 选定源图：`art/runtime/portraits-v04/sources/naigai.png`
- 源图 SHA256：`9b411ff385b0392d252b332a3268019a4a17ba5ec9348a6515308f61d03e2a5f`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-77f9e8ca-55eb-460a-9bdd-fa463d67971a.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C19.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Naigai. Preserve the long straight black hair, skeptical confident sideways glance, short off-white fur collar, brown mercenary clothing, and a compact round wooden shield with a simple cream-colored dripping milk-foam emblem. The shield stays close across the lower bust, leaving the face and shoulders large and readable. Remove the tall quiver and spear above her hair; no modern drink cup.
```

## 29｜小杰

- 角色键／画刷：`xiaojie` / `afeix_p04_xiaojie`
- 选定源图：`art/runtime/portraits-v04/sources/xiaojie.png`
- 源图 SHA256：`2873e7d94cdcce1fd1a5c2bdf480949c1cd06fb3002be033e44f0787287083a6`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-7746bc4f-7971-4cea-b326-b13d8f89839f.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-000b63b2-d73c-42c3-b903-ce2d5f6cd84e.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: precise-object-edit. Image 1 is the ONLY edit target, the completed custom Xiaojie tactical bust. Images 2 and 3 are style references only; never copy their characters.
Make exactly one correction: MIRROR THE ENTIRE TARGET ILLUSTRATION HORIZONTALLY so this woman's nose, face, eyes and torso point toward the RIGHT EDGE OF THE IMAGE, not the left. The existing target currently faces left. Flip the head, brown bun, white fur collar, brass keys, lock-emblem shield and every existing costume part together as one coherent mirrored bust. Preserve her identity, the exact coarse matte BB painting, colors, complete rounded lower bust, relative proportions and all depicted objects. Do not add or remove props, do not beautify or smooth the painting. No other redesign. Keep the same generous truly transparent RGBA margin, no background or text. One whole bust, facing screen RIGHT.
```

### 补充生成记录：original_prompt

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Xiaojie. Preserve the brown hair gathered in a messy high bun, focused suspicious look, white fur-lined collar over worn brown practical clothing, and very readable brass keys hung close to her chest. Retain the old lock emblem as a small inset mark on a compact partial round shield at her lower side. No long spear or long dangling key chain; face must remain dominant.
```

## 30｜bula

- 角色键／画刷：`bula` / `afeix_p04_bula`
- 选定源图：`art/runtime/portraits-v04/sources/bula.png`
- 源图 SHA256：`7c99647d3bb9577b5090110e69e73cb3f58b57c107ca08f2d06d5a64b8432463`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-2b9bcb8a-a2d7-46f3-b126-09ea0d35ca76.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C31.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Bula. Preserve long dark hair swept across one side, composed calculating eyes, muted grey-beige scarf, brown leather layers, and the round brass/gold clasp. A short arrow quiver may peek at shoulder height only, no oversized bow and no arrows higher than her head. Her silhouette is calm and contained; no floating coins or magic effects.
```

## 31｜苏袜

- 角色键／画刷：`suwa` / `afeix_p04_suwa`
- 选定源图：`art/runtime/portraits-v04/sources/suwa.png`
- 源图 SHA256：`8e5ae130d8892c75926815a4f3d04de044db3422eaca7b2e8ecc519db4597352`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-fd5ec4a4-59ed-494c-95cf-031b3e5e476e.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-0a5875ee-ac0b-43e3-b17e-927361a4c6f7.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: precise-object-edit. Image 1 is the ONLY edit target, the completed custom Suwa tactical bust. Images 2 and 3 are style references only; never copy their characters.
Make exactly one correction: MIRROR THE ENTIRE TARGET ILLUSTRATION HORIZONTALLY so this woman's nose, face, eyes and torso point toward the RIGHT EDGE OF THE IMAGE, not the left. The existing target currently faces left. Flip her whole short-haired head, tied off-white linen bow, red scarf and every existing costume part together as one coherent mirrored bust. Preserve her adult female identity, sly smile, the exact coarse matte BB painting, colors, complete rounded lower bust, relative proportions and all depicted objects. Do not add a weapon, do not remove the bow, do not beautify or smooth the painting. No other redesign. Keep the same generous truly transparent RGBA margin, no background or text. One whole bust, facing screen RIGHT.
```

### 补充生成记录：original_prompt

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Suwa. Preserve her short tousled black hair, distinct off-white tied cloth bow, lively sly smile, weathered red scarf and brown padded/leather clothing. Keep the bow modest but clearly recognizable, like practical tied linen. Remove the raised long weapon, hand-on-spear pose and tall quiver so the agile character reads as a compact shoulder bust, not a tiny head beside equipment.
```

## 32｜千涵

- 角色键／画刷：`qianhan` / `afeix_p04_qianhan`
- 选定源图：`art/runtime/portraits-v04/sources/qianhan.png`
- 源图 SHA256：`758726f0eadc915cf7a11ad97a371f72dc8871e6b7f763a5f9ca6d77259de164`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-081c9abc-5e7f-4b82-b8d7-436249a76cbd.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C23.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Qianhan. Preserve dark hair pulled into a low trailing ponytail, swept loose fringe, rust-red neck scarf and straps, earnest focused expression, brown-grey practical armor, and a partial close-held round wooden shield with a muted red mark. Keep shield low and compact; no large upright spear, no text or numbers, no glamorous make-up.
```

## 33｜王大芷

- 角色键／画刷：`wangdazhi` / `afeix_p04_wangdazhi`
- 选定源图：`art/runtime/portraits-v04/sources/wangdazhi.png`
- 源图 SHA256：`252b8026da9074d28120bcc619d1c29bbfe9dd57bd4056ecc9909d19000050fc`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-a6f03e5a-1a4e-41d7-aad9-dfb7918982ff.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C26.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Wangdazhi, the same legacy character called Zhizhi. Preserve her short chestnut-brown bob, long side fringe, calm self-contained expression, clearly purple/lavender scarf faded for this world, and brown leather shoulder panels with one round brass fastening. No new weapon, no extra prop, no glamorous face. Keep her short hair and purple scarf distinct from the other women.
```

## 34｜瑶瑶牙

- 角色键／画刷：`yaoyaoya` / `afeix_p04_yaoyaoya`
- 选定源图：`art/runtime/portraits-v04/sources/yaoyaoya.png`
- 源图 SHA256：`60363f558e875bff7b9d56a8c5f222f01d5bbd3bd1019cb0b63d1b60a23e0f9e`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-1c64e5c9-7c02-4529-9437-c227f5b9254d.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C27.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Yaoyaoya, legacy C27, NOT the unrelated C29. Preserve dark high ponytail tied with a red ribbon, determined forward-looking expression, worn dull iron shoulder plate, and rusty red scarf and banner-cloth accent. Fold the red pennant close behind one shoulder, with any axe shaft ending below head height; do not let a tall flag or pole determine the silhouette. No crown, no fantasy ears, no invented species.
```

## 35｜羊咩咩

- 角色键／画刷：`yangmiemie` / `afeix_p04_yangmiemie`
- 选定源图：`art/runtime/portraits-v04/sources/yangmiemie.png`
- 源图 SHA256：`c00f87840ae047187b13544d8a357921b86a6d83fe3d9ae3e83d9d276867052d`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-2abff599-1be5-4517-b516-26e2657265c4.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C28.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Yangmiemie. Preserve medium wavy brown hair, cheerful but alert face, dusty blue headwear and neckerchief, and the small sheep-shaped shoulder ornament. Translate the modern blue baseball cap into a soft medieval blue cloth coif with a modest folded brim, keeping the blue head silhouette. Add her already established small travel bell as a single brass collar charm. No modern logos, car, horns or new fantasy race; remove the raised long sword.
```

## 36｜陈知含

- 角色键／画刷：`chenzhihan` / `afeix_p04_chenzhihan`
- 选定源图：`art/runtime/portraits-v04/sources/chenzhihan.png`
- 源图 SHA256：`02ecb9e60786ba35554ec3801f67932a59589ca97168b6ce511158a40a0161fe`
- 生成器原始输出：`C:\Users\25647\.codex\generated_images\01a0db41-93b8-7612-a75d-353cda0f6892\exec-d28d0e25-f9bb-4697-a7eb-e49739a60b3a.png`
- 参考输入（角色目标与画法参考的角色由提示词区分）：
  - `G:/CODE/afei-xcpedition/legacy/2026-09-25-afei-expedition/reference/art/tactical-sprites/icons/afei_head_C22.png`
  - `G:/CODE/afei-xcpedition/art/references/battle-brothers-style/official-brothers-busts-2016.jpg`
  - `G:/CODE/afei-xcpedition/art/character-concepts/afei/afei-normal-roguish-v02.png`

```text
Use case: style-transfer.
Asset type: ONE complete transparent Battle Brothers tactical bust for a named party member.
Input roles: IMAGE 1 is the ONLY EDIT TARGET and identity source. IMAGE 2 is the official Battle Brothers proportion/shape reference. IMAGE 3 is the Afei custom master, a brushwork and shadow-economy reference ONLY. Do NOT copy any reference man's face, hair, skin features or outfit onto this woman.
Primary request: redraw all of IMAGE 1 into the native Battle Brothers tactical-sprite visual language while preserving that character's identity markers below. This is a fully custom one-piece head+neck+shoulders+short-chest image, never a native face pasted onto a new body.
Style: deliberately coarse dark-brown contour, matte restrained earth colors, only two or three broad hard-edged shadow planes on face and fabric. Adult slightly caricatured face, small simple eyes beneath clear upper lids, strongly readable nose and mouth, chunky hair groups. Match the blunt small-game-sprite painting economy of IMAGE 2 and IMAGE 3. No photoreal skin, smooth beauty portrait, manga eyes, eyelashes, glossy hair strands, microtexture, airbrush lighting or cinematic realism.
Composition: slightly elevated three-quarter view facing screen RIGHT, large head, very short neck, compact short shoulders and rounded lower chest termination like a Battle Brothers pawn. Whole head and both shoulders plus all small identity props completely visible. No legs, waist, pedestal, portrait frame, scenery, shadow backdrop or user interface. Generous truly transparent margin surrounds the intact silhouette. Face remains the dominant feature at a final sprite display around 108x124 pixels; do not shrink the person to fit tall weapons. Keep any identifying prop tight against the lower chest and within shoulder width. One adult character only. No text, logos, numbers, other people, duplicate views or watermark.
Output: genuine transparent RGBA background, preserve alpha. No checkerboard painted into the image.

Identity: adult woman Chenzhihan. Preserve long dark hair with a straight fringe, narrow pale headband with small muted pink side knots, warm attentive expression, short pale fur collar, brown clothing and a small round mooncake motif at the chest/hand. Replace the doll-like huge eyes with native-game small eyes and strong nose planes. Keep the round mooncake small, the head and both shoulders complete; no giant mallet or long weapon.
```
