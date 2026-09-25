# C01–C06 完整战斗轮廓候选稿

2026-09-24，内置 image_gen 生成并二次整理版式。

用户要求：头发与脸同向、发际线贴合，保留角色衣服并隐藏头盔，武器与盾牌使用游戏装备图层；未确认前不打包。

本目录仅供审稿，尚未接入运行时画刷或游戏 ZIP。六个 PNG 各为 114×142 RGBA，完整人物图包括头发、脸、脖子和衣服，不包含武器、盾牌。metadata.xml 保留对应坐标。源图位于 source-sheet.png。

预览：../../reviews/coherent-C01-C06-equipment-v2.jpg。左列为原版尺寸对照；其余列为角色外观、初始装备、剑与圆盾换装。由 tools/preview_coherent_busts.py 生成，尚未实机验证。

采用完整轮廓后，接入时应将其放在 body 层，隐藏原 head/hair/armor/helmet 及其装备升级外观，保留原生 arms_icon/shield_icon 的显示、朝向和战斗动作。不能再把完整人物贴到 head 层，同时保留原版 body。待外观确认后再完成接入和实机检查。

## 生成提示词

Edit target image 1: six characters repeated in three rows. Create ONE production sprite sheet containing ONLY ONE row of the six different characters from its top row in the same left-to-right order. Image 2 is the actual Battle Brothers native tactical bust style and anatomy reference. Repair the faulty pasted hair/head/torso joins from target: draw each as ONE coherent finished tactical bust with correctly fitted hair covering the scalp, realistic hairline, no bald wedges, no floating wig, no discontinuous fringe, all faces AND hair perspective AND torsos turned three-quarter toward screen RIGHT. Match image 2's compact stout bust proportions, hand-inked thick dark outlines and muted flat painted medieval colors, large readable heads rather than detailed portrait painting. Six adult identities must remain distinct: 1 black short side-swept hair, sharp confident adult male grin, dark green angular leather cloak costume; 2 orange-brown spiky hair, rectangular black glasses, mischievous grinning adult male with goblin-like pointed ears, green merchant leather costume; 3 purple short hair, stern adult male, green scarf and brown padded leather; 4 adult woman with long dark brown loose wavy hair that frames and exposes both eyes naturally, small gold earring, black quilted coat, NO bow, no bald scalp, smooth coherent temple hair; 5 adult woman short chestnut bob with cream flower hair clip, warm eyes, grey-beige cloth cloak and flower brooch; 6 adult woman chestnut long hair and bangs, modest cream frilled hairband, turquoise scarf with cream shirt under leather vest, dog-paw emblem and small brass bell. No real photo faces, no airbrush, no anime gloss. Each bust ends immediately below chest with rounded Battle Brothers token silhouette, no legs, NO hands, NO weapon, NO shield, NO helmets, NO platforms. Absolutely transparent alpha background, no black matte, no shadow halo, no ground shadow, no labels or text or borders. Arrange SIX evenly spaced isolated busts in one horizontal row, identical baseline and similar shoulder width, generous transparent gaps. Render the entire head-hair-neck-costume of each as a coherent piece instead of independently aligned parts. Hair attached to skull; eyes level; no stretching flat heads. Preserve each identity and clothing color, improve all anatomy and tactical readability.

## 版式整理提示词

Precise sprite sheet layout edit. Preserve these EXACT six painted coherent bust characters and all faces, hair, costumes, colors and right-facing poses. Arrange them in a spacious 3 columns by 2 rows sprite sheet on genuinely transparent alpha background. First three men in top row in same order; the three women in bottom row in same order. Every bust fully contained in its own equal-sized rectangular cell with at least 15% clear transparent margin on all four sides. Busts must never touch adjacent cells or canvas edge. Identical baseline and similar shoulder widths within each row. No props, weapons, shields, no text, no frames, no backdrop, no shadow or shadow halo. Absolutely no new bald patches, no hair/head seam. This is transparent game asset layout only, do not redesign the characters.
