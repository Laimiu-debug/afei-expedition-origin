# 立绘与图标生成提示词包（v2 · 人设锚点版）

逐条生成原创素材。人物与场景参照游戏原版 `gfx/ui/events/event_65.png`、`event_01.png` 的**事件框尺寸、画法和边框**，不要生成写实摄影或概念海报。立绘/场景图放 `src/gfx/ui/events/`，技能图标放 `src/gfx/skills/`。先缩到 220×220 / 56×56 检查主体是否看得清，再运行 `python tools/apply_flavor.py && python tools/check_art.py && python tools/build_zip.py`。把完整 ZIP 放进游戏 `data/`，不要解压。

> 「贴合现实」的口径：以斗鱼官方个人头像、团播页面成员照和设定稿引用的公开视频为外貌参考，再做中古佣兵化夸张。事件立绘与战斗小人必须保持同一张脸、发型和主色。标志道具放事件图；战斗图只放脸和头发，武器、盾牌、护甲、头盔由游戏实际装备图层绘制。C01–C03 为男性；C04 起全部为女性。允许把阿飞夸张成蛤蟆主题、把抹茶夸张成地精账房，但不得把任何角色画成无特征的通用佣兵。

## 五人一组修图的统一画风

- 先看用户提供的本人参考。发长、刘海、眼形、发饰与整体神态优先于旧立绘；旧立绘只能提供游戏服装和角色道具。用户没有提供照片时，只用已有公开参考，不凭角色名猜真人外貌。
- 母图用透明背景、完整上半身剪影。脸要是粗粝的 2D 游戏手绘：哑光旧色、明显笔触、断续的深色轮廓、简化明暗面。避免摄影般皮肤、写真五官、光滑塑料感和过亮的大眼动漫脸。
- 先在 220×220 事件框检查立绘，再在游戏原生头部／头发层以及穿甲、戴盔叠加预览里检查战斗外观。不能把完整半身像裁成 `head` 层；那样会与实际装备重叠。
- C01–C06 的战斗分层源图在 `art/tactical-sprites/layer-sources/`，由 `tools/build_layered_busts.py` 格式化，装备叠加预览见 `art/reviews/layered-C01-C06.jpg`。后续新角色沿用 Fate 的脸／发分层、原版装备图层，继续保持 C05 的短发和粗粝手绘质感。

## 一、30 人立绘（文件名 afei_CXX.png）

### C01 阿飞 · 空喊的团长 → `afei_C01.png`
```
A young man mercenary of a traveling company in worn gambeson and padded coif, carrying a wooden club, holding a large black company banner slightly too big for him, chin up, overcompensating grin, ink-stained fingers from signing the roster. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C02 抹茶 · 算账的副队长 → `afei_C02.png`
```
A adult man mercenary of a traveling company in worn gambeson and padded coif, carrying a hunting bow, small sharp-eyed quartermaster, wooden abacus hanging at his belt, a folded measuring cord, ledger tucked under one arm. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C03 王大谋 · 顶盾的副队长 → `afei_C03.png`
```
A adult man mercenary of a traveling company in heavy mail hauberk and kettle helm, carrying a short spear with shield, immensely broad shoulders, effortlessly holding a huge supply crate with one hand, the other pressing a recruitment notice to a wall, easy confident grin. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C04 小酒瓶 · 抢节奏的突破手 → `afei_C04.png`
```
A young woman based on the user-provided 小酒瓶 photo: very long dark chestnut-brown hair with natural volume and an off-center part, large soft eyes, delicate oval face, friendly slight smile, small earrings. Charcoal quilted medieval brigandine, short sword, small brass bicycle bell tied to her chest strap. No pink bow, ribbon, flower hairpin, heart sticker, giant red scarf, or cold angry expression. Rough matte Battle Brothers 2D hand painting with visible dry-brush strokes, simplified angular facial planes, broken dark contours, muted medieval colors. Complete transparent bust and recognizable silhouette at both 220x220 event size and 104x142 tactical size, no photorealism, no glossy anime, no text, no frame.
```

### C05 李李超欧 · 聚光下的超巨 → `afei_C05.png`
```
A young woman touring-stage archer with a short chin-length light chestnut bob, airy side bangs, round brown eyes, a small gentle smile, and a pale cream fluffy hair accessory above her left ear, based on the user-provided 李李超欧 portrait. Gray-beige padded travel tunic, tiny muted pink flower brooch, old hunter's bow and two arrows; a subtle warm stage-light edge. Soft and lively, without a crown, long locks, royal fur cape, or photo-realistic skin. Rough matte Battle Brothers 2D hand-painted character bust: angular shadow planes, visible dry-brush strokes, irregular dark contour, muted medieval palette. Complete transparent silhouette, readable at both 220x220 event size and 104x142 tactical size, no text, no frame, no watermark.
```

### C06 余初九 · 数两遍的守夜人 → `afei_C06.png`
```
A young woman based on the user-provided 余初九 photo: long warm medium-brown hair swept over one shoulder, straight airy bangs, pale ruffled headband, soft face and a slightly stubborn protective expression. She is the loyal yet tsundere little hound of the company, shown through her guarding posture, a small white paw emblem on her round shield, and a tiny bell, not literal dog ears. Sky-blue scarf over muted medieval brigandine, short spear and night-watch roster. Rough matte Battle Brothers 2D hand-painted character bust: angular shadow planes, visible dry-brush strokes, irregular dark contour, muted parchment and iron palette. Complete transparent silhouette, readable at both 220x220 event size and 104x142 tactical size, no photographic skin, no text, no frame, no watermark.
```

### C07 小月牙 · 换靶的乐天派 → `afei_C07.png`
```
A adult woman mercenary of a traveling company in worn gambeson and padded coif, carrying javelins, cheerful market-tinkerer woman, an oversized shop sign shrunk and strapped to her pack, a coil of practice ropes and a re-purposed broken tool in hand. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C08 小鱼贝壳 · 栈桥边的盾 → `afei_C08.png`
```
A adult woman mercenary of a traveling company in brigandine over padding and nasal helm, carrying a short spear with shield, quiet shieldbearer woman planting her shield at the outer edge of a short wooden pier, calm steady eyes, a loose shield strap in one hand. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C09 白小帅子 · 数拍子的门神 → `afei_C09.png`
```
A young woman streamer-inspired mercenary of a traveling company in heavy mail hauberk and kettle helm, carrying a wooden club, nervous young drummer clutching a waist drum, lips counting a beat, standing firmly in a doorway despite trembling knees. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C10 王怼怼 · 问最后一遍的传令 → `afei_C10.png`
```
A adult woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a short spear with shield, tense herald woman clutching a wooden message baton like a scepter, leaning slightly away from a distant shout, resolute squint. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C11 川神 · 折图的老副将 → `afei_C11.png`
```
An adult woman streamer-inspired mercenary of a traveling company in brigandine over padding and nasal helm, carrying a polearm, veteran strategist calmly unfolding a much-creased, patch-stitched formation map, patient measured gaze. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C12 小虎 · 回头的信使 → `afei_C12.png`
```
An adult woman streamer-inspired mercenary of a traveling company in worn gambeson and padded coif, carrying a hunting bow, lean scout re-tying an empty dispatch satchel, glancing back over her shoulder down the road, a water bowl at her feet. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C13 大鹅 · 护箱的前锋 → `afei_C13.png`
```
A adult woman mercenary of a traveling company in heavy mail hauberk and kettle helm, carrying a bearded axe, tall broad woman hauling a sealed supply crate stamped with a black banner crest, one protective arm over it, glare daring you to touch. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C14 小杰 · 挂钥匙的学徒 → `afei_C14.png`
```
A young woman streamer-inspired mercenary of a traveling company in brigandine over padding and nasal helm, carrying a short spear with shield, precise young woman with a full ring of keys jangling at her belt, crouched checking a wagon wheel, spare key hung on the wagon frame. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C15 苏袜 · 记路的快脚 → `afei_C15.png`
```
A adult woman mercenary of a traveling company in worn gambeson and padded coif, carrying javelins, swift courier woman mid-stride, chalk waymarks on the milestone behind her, worn shoes, scanning the fork in the road ahead. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C16 涂涂 · 说清楚的告别 → `afei_C16.png`
```
A adult woman mercenary of a traveling company in brigandine over padding and nasal helm, carrying a short sword, gentle woman carefully folding a farewell route map, warm melancholic smile, a packed bundle resting at her feet. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C17 可可 · 认人的守望者 → `afei_C17.png`
```
A adult woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a crossbow, observant woman with a lowered crossbow, tying a small strip of matching cloth to a shield rim, eyes on the shadows beyond the campfire. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C18 童猪 · 讲规则的木熊 → `afei_C18.png`
```
An adult woman streamer-inspired mercenary of a traveling company in brigandine over padding and nasal helm, carrying a polearm, patient showwoman placing a small carved wooden bear on the table beside an upturned cup, wry teacher smile, rules etched under the bear. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C19 奶盖 · 嘴强的盾 → `afei_C19.png`
```
A young woman mercenary of a traveling company in worn gambeson and nasal helm, carrying javelins, brash young shield-maiden talking big with a shield raised slightly too high, chin up, eyes betraying nerves, a reviewed form clutched in the other hand. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C20 余想 · 最后一班的岗 → `afei_C20.png`
```
A weathered middle-aged woman mercenary of a traveling company in brigandine over padding and kettle helm, carrying a long spear, weathered veteran woman on her final watch, spear butt planted, holding a lantern for the relief arriving, bone-deep tired but unbent. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C21 美伢 · 谢幕的舞者 → `afei_C21.png`
```
A young woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a short sword, graceful dancer marking a chalk position on the floorboards, remembering the drummer breathing in, a fallen stage curtain rope in one hand. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C22 陈知含 · 留一份的月饼 → `afei_C22.png`
```
A adult woman mercenary of a traveling company in brigandine over padding and kettle helm, carrying a wooden maul, modest woman sharing round mooncakes from a box, one piece carefully set aside wrapped in cloth for herself. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C23 千涵 · 擦亮木牌的003 → `afei_C23.png`
```
A young woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a short spear with shield, energetic sprinter girl proudly polishing a small wooden tag bearing the number 003, standing nearest the flagpole. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C25 玩蛇 · 画蛇的剑客 → `afei_C25.png`
```
A adult woman mercenary of a traveling company in brigandine over padding and kettle helm, carrying an arming sword, serene swordswoman resting her sword, wooden training posts behind her carved with winding snake marks, appraising eyes inviting you to try a stance. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C26 芷芷 · 撑幕布的手 → `afei_C26.png`
```
A adult woman mercenary of a traveling company in brigandine over padding and kettle helm, carrying a short spear with shield, sturdy stagehand woman hauling a stage curtain rope taut against the wind, two wooden crates laid as a path behind her, an old round shield on her back. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C27 瑶瑶牙 · 回头的吕布 → `afei_C27.png`
```
A adult woman mercenary of a traveling company in heavy mail hauberk and kettle helm, carrying a long poleaxe with a red streamer, imposing vanguard woman resting a long poleaxe across a map spread on a barrel, asking with her eyes where the retreat route is. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C28 羊咩咩 · 听铃铛的车手 → `afei_C28.png`
```
A adult woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a short sword, cart-driver woman leaning into a curve beside a light cart, a small brass bell hanging from the axle, steady hands on the rail. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C29 一凹瑶 · 递棒的瑶瑶 → `afei_C29.png`
```
A young woman mercenary of a traveling company in worn gambeson and nasal helm, carrying a short sword, quick-reflexed relay runner holding out a wooden baton toward the viewer, a medicine pouch slung across her, encouraging nod. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C30 罗一可 · 让角度的人 → `afei_C30.png`
```
A young woman mercenary of a traveling company in brigandine over padding and kettle helm, carrying a short spear with shield, street-football defender woman nudging an obstructing barrel aside with her foot, framing an angle with two fingers, the goal behind her. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

### C31 bula · 核账的bula → `afei_C31.png`
```
A adult woman mercenary of a traveling company in worn gambeson and nasal helm, carrying javelins, frugal quartermaster woman auditing a shared coin pouch, one eyebrow raised, a spare needle-and-thread packet tucked under her arm. original hand-painted 2D medieval game event-panel art, readable half-body silhouette at 220x220, muted parchment midtones with oxblood and iron accents, simplified face and clear prop, thin dark border, no photorealism, no text, no watermark, no modern clothing
```

## 二、场景插画（放到 src/gfx/ui/events/）

### `afei_scene_welcome.png`
```
Three founders around a tavern table at night signing a blank roster under a large black banner flag — a loud young commander, a small sharp quartermaster, a big calm frontliner; candlelight, ink and empty wine cups. original hand-painted 2D medieval game event-panel art, square readable composition at 220x220, muted parchment midtones with oxblood and iron accents, thin dark border, no photorealism, no text, no watermark, no modern objects
```

### `afei_scene_farewell.png`
```
A night camp farewell: campfire shadows rotating like a lantern carousel across a wagon shaft, silhouettes replaying old memories — a training ground, a shield wall breakthrough, a drum beat; a young striker walking away down the road at dawn, leaving an old bicycle against the wagon. original hand-painted 2D medieval game event-panel art, square readable composition at 220x220, muted parchment midtones with oxblood and iron accents, thin dark border, no photorealism, no text, no watermark, no modern objects
```

## 三、91 项技能图标（生成后放到 src/gfx/skills/，命名 afei_<ID>.png）

> 图标提示词通用模板：`original hand-painted medieval game skill icon, bold single silhouette readable at 56x56, tarnished gold and bone highlights, dark oxblood background, thin weathered iron frame, no text or numbers` + 下表符号描述。

**阿飞**
- `afei_wawa_call.png` 哇哇叫：`an open shouting mouth with sound rings`
- `afei_jiahao.png` 嘉豪：`a banner flag with names being written onto it`
- `afei_toad_escape.png` 蛤蟆：`a crouching toad leaping sideways`
- `afei_full_circle.png` 全力圈：`a glowing ring enclosing tired soldiers`

**抹茶**
- `afei_scrap_parts.png` 地精出身：`salvaged tool scraps in a leather pouch`
- `afei_abacus_mark.png` 地精算盘：`a wooden abacus with one bead pushed forward`
- `afei_shadow_captain.png` 幕后队长：`a hand passing coins of energy behind a shield line`

**王大谋**
- `afei_steal_bro.png` 偷大哥：`a firm handshake over a recruitment notice`
- `afei_borrow_strike.png` 大哥借我：`a small sword borrowing a bigger sword swing`
- `afei_together_lift.png` 一起抬：`two pairs of hands lifting one crate`

**小酒瓶**
- `afei_bottle_breakthrough.png` 瓶队突破：`a runner bursting through a paper door`
- `afei_finals_moment.png` 决赛时刻：`an hourglass glowing from the fifth hour`
- `afei_teammate_ball.png` 队友给的球：`a ball passed mid-air between two silhouettes`

**李李超欧**
- `afei_unselectable.png` 无法选中：`an archer aiming at a fading mirage silhouette`
- `afei_chaoju.png` 超巨：`a spotlight cone on a single figure`
- `afei_ouqi.png` 欧气：`a six-sided lucky die re-rolling`

**余初九**
- `afei_dog_bark.png` 狗叫：`a barking small dog silhouette intimidating a raider`
- `afei_loyalty.png` 忠诚：`a shield orbiting a banner pole`
- `afei_guard_swap.png` 护团换位：`two figures exchanging grid tiles`

**小月牙**
- `afei_supermarket.png` 超市里：`a market stall with a discounted grain sack`
- `afei_biantai.png` 变态：`an arrow curving to a second target`
- `afei_optimist.png` 乐天派：`a smiling mask catching a falling spirit`

**小鱼贝壳**
- `afei_only_man.png` 唯一的男人：`a lone shield covering a neighbor`
- `afei_nicotine.png` 尼古丁：`a small pipe releasing a wisp of vapor`
- `afei_cover_up.png` 顶上去：`a shield intercepting an incoming arrow`

**白小帅子**
- `afei_small_heart.png` 小心脏：`a timid heart peeking from behind a shield`
- `afei_drum.png` 打鼓：`a waist drum with beat rings`
- `afei_guard_gate.png` 守门：`a braced shield blocking a doorway`

**王怼怼**
- `afei_fear_afei.png` 恐飞派：`a flinching herald hearing a loud shout`
- `afei_prince_order.png` 太子发令：`a raised baton of command`
- `afei_dui_sentence.png` 怼一句：`a message scroll being relayed hand to hand`

**川神**
- `afei_blue_form.png` 蓝旗布阵：`soldiers snapping into a blue line formation`
- `afei_steady_hand.png` 稳一手：`a steadying hand on a wavering pike`
- `afei_good_card.png` 一张好牌：`a played card revealing a shield`

**小虎**
- `afei_scout_path.png` 探路：`探路 symbol`
- `afei_return_arrow.png` 回头箭：`an arrow that loops back over a shoulder`
- `afei_catch_rear.png` 接住后排：`a rearguard stepping back with covering shot`

**大鹅**
- `afei_goose_bully.png` 鹅势欺人：`a hissing goose with puffed chest among allies`
- `afei_gaga_charge.png` 嘎嘎冲：`a goose barging forward one tile`
- `afei_guard_nest.png` 守窝：`a brooding goose guarding a nest crate`

**小杰**
- `afei_lock_wagon.png` 锁车：`锁车 symbol`
- `afei_not_fooled.png` 不上这个当：`a hooded man ignoring a lure of coins`
- `afei_spare_key.png` 备用钥匙：`a ring of keys unlocking a net snare`

**苏袜**
- `afei_foot_point.png` 踩点：`a marked foothold stone before a leap`
- `afei_half_step.png` 抢半步：`a half step ahead of a shadow`
- `afei_hard_brake.png` 急刹：`boots skidding to a stop line`

**涂涂**
- `afei_return_road.png` 回头路：`two figures stepping back along drawn footprints`
- `afei_leave_not_gone.png` 离席未散：`a farewell footprint returning`
- `afei_one_more_night.png` 再留一晚：`a tent lantern kept lit one more night`

**可可**
- `afei_own_people.png` 自己人：`a friendly arrow passing beside an ally silhouette`
- `afei_pokemon.png` 保可梦：`a watchful eye guarding a smaller figure`
- `afei_breathe_easy.png` 松口气：`lungs easing with slow wind`

**童猪**
- `afei_bear_strike.png` 小熊出击：`a wooden bear paw swatting`
- `afei_know_rules.png` 先懂规则：`an open rulebook with accumulating bookmarks`
- `afei_cup_signal.png` 敲杯为号：`an upturned cup struck like a bell`

**奶盖**
- `afei_mouth_strong.png` 嘴强王者：`a boasting mouth before a raised shield`
- `afei_shrink_cover.png` 缩进奶盖：`a soldier retreating into a jar-like cover`
- `afei_abs_comeback.png` 抽象整活：`a comeback sparkle after a miss`

**余想**
- `afei_five_elder.png` 五老压阵：`five tally marks of enduring shifts`
- `afei_long_watch.png` 长轮守门：`a lantern-lit long vigil at a gate`
- `afei_shift_arrive.png` 替班到了：`a relief watchman arriving to take the post`

**美伢**
- `afei_king_dance.png` 大王舞：`a ceremonial dancer marking positions`
- `afei_read_beat.png` 看懂节拍：`an ear catching a rhythm mark`
- `afei_curtain_yield.png` 谢幕让位：`a curtain drawn aside to yield the stage`

**陈知含**
- `afei_moon_cake.png` 月饼帮：`a round mooncake split into shares`
- `afei_remember_shield.png` 这一盾记住了：`a shield remembering a struck blow`
- `afei_guard_self.png` 先护住自己：`a shield wrapped around its bearer`

**千涵**
- `afei_start_run.png` 003号起跑：`a starting line scratched in dirt`
- `afei_short_sprint.png` 短坡冲刺：`quick short dash lines between flags`
- `afei_segment_breath.png` 分段呼吸：`measured breath between waypoints`

**玩蛇**
- `afei_snake_read.png` 秦国的神：`a snake coiled reading an opponent stance`
- `afei_snake_trial.png` 蛇形试招：`a serpent strike testing a guard`
- `afei_next_path.png` 下一招换个路：`a fork in the road with one marked path`

**芷芷**
- `afei_hold_ground.png` 站稳场子：`站稳场子 symbol`
- `afei_hold_curtain.png` 撑住幕布：`hands holding a stage curtain taut`
- `afei_door_mine.png` 门口有我：`门口有我 symbol`

**瑶瑶牙**
- `afei_lvbu_weapon.png` 奶团吕布：`奶团吕布 symbol`
- `afei_breach_strike.png` 破口一击：`a poleaxe cleaving an opening in a wall`
- `afei_look_flag.png` 回看旗子：`a warrior glancing back at the company banner`

**羊咩咩**
- `afei_curve_force.png` 弯道留力：`a cart leaning into a curving road`
- `afei_line_detour.png` 贴线绕行：`a route threading around an obstacle`
- `afei_bell_lead.png` 铃铛带路：`a small bell marking a safe tile`

**一凹瑶**
- `afei_half_react.png` 反应半拍：`a lightning-quick reflex spark`
- `afei_catch_baton.png` 接住这一棒：`a baton passing between two hands`
- `afei_duck_turn.png` 鸭步回身：`a side-step swirl dodging a blow`

**罗一可**
- `afei_two_steps.png` 脚下两步：`two measured footprints framing an angle`
- `afei_door_block.png` 门前卡位：`a door slammed into a chokepoint`
- `afei_long_run_breath.png` 长跑留一口：`a runner rationing breath over distance`

**bula**
- `afei_purse_clear.png` 钱袋算清：`a balanced ledger over a coin pouch`
- `afei_budget_share.png` 提前分好：`a coin pouch divided into labeled shares`
- `afei_no_last_throw.png` 别把最后一支乱扔：`the last javelin held back`
