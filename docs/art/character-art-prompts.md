# 阿飞远征团｜人物造型讨论与生图提示词

**v0.19 更新：**小龟禁戴头盔、天生钢头与厚壳已接入；刘青松仅为相遇 NPC，不增加战斗人物数。详见 [版本记录](../playtest-0.19.md)。

版本：v0.17（v0.12 五人参考重绘与全员颈部修复）
创建日期：2026-09-25；更新日期：2026-09-27。

**新增待实现特例（2026-09-27 用户确认）：**溺水小龟因为头部太大，无法装备头盔；龟壳厚、防御高，并自带钢头。后续保留大头圆脸与厚壳辨识，禁戴头盔落实到装备规则；身体护甲和武器仍按当前规则处理。具体防御数值与叠加待细化，见 [灵感手记 IDEA-013](../design/idea-journal.md#idea-013小龟头盔戴不下龟壳扛得住)。本段为后续制作设定，下面仍是当前已实现的通用分层规则。

当前分层规则以 [2026-09-30 死亡姿态与颈部分层修复](death-and-neck-20260930.md)为准：保留既有朝右立绘，按逐人记录的颈部轮廓分层，保留完整下巴与短颈，将衣领、肩部和脖子两侧放在实际防具下方。内容仍等比缩到最大 88×100，脸和短颈在护甲上、头盔下；实际武器、防具继续显示，原版发型、胡须隐藏。死亡头部使用已写入倒地姿态的贴图。蛤蟆使用正常阿飞外观，飞碟沿用人类阿飞外观，转职玩法保留。[v0.12 更新和离线验证](../playtest-0.12.md)与[v0.7 历史实机观察](../playtest-0.7.md)作为历史记录保留。

历史来源：v0.5 按公开照片校正 29 人、30 幅主体（含阿飞嘉豪）；v0.6 完成朝右姿态修订。此前缺图的小月牙、亿口甜筒、美伢和瑶瑶牙，本轮已收到[用户指定参考](../../art/references/2026-09-27-user/README.md)，小龟改用用户海报中的圆脸吉祥物；不对参考图片来源或真伪另作判断。旧蛤蟆图与飞碟图仅留历史归档。

实际提示词、参考输入与完整返修链统一在 [PROMPTS.md](../../art/runtime/portraits-v05/PROMPTS.md)，源图、指纹和画刷见 [manifest.json](../../art/runtime/portraits-v05/manifest.json)。[历史照片来源与排除记录](../../art/references/2026-09-26-likeness/README.md)保留原页面、原图和技术裁切；[全员颈部与装备对照](../../build/playtest-neck/index.html)展示当前导出结果。朝向修订前的 [manifest](../../art/runtime/portraits-v05/manifest-before-facing.json)、原源图及旧包均归档保留，画刷 `afeix_p04_*` 和图集 `afeix_portraits_v04` 名称不变，本轮新源图另存 `sources/user-v12/`。技术选用不等于用户最终定稿。

下文保留逐人讨论和早期提示词，遇到冲突以本段、v0.5 的照片依据和 v0.6 的姿态要求为准。照片决定个人脸型、眉眼、发际线和发型，官方样本只负责画法，不借用其他人物的脸。继续使用粗轮廓、少量宽阴影、低饱和衣物与 114×142 下可读的紧凑胸像；避免皮肤细节、写实光影、玻璃眼睛和统一冷脸。小哈尼与老蔡在 v0.5 已有公开照片依据，旧稿中的“无真人参考”不再适用。

四张技能图标继续使用 [v0.3 资源](../../art/runtime/gameplay-v03/README.md)，飞碟装饰不再进入发行图集。早期试验及返修仍保存在 [v1 目录](../../art/runtime/afei/v1/README.md)。下文早期提示词与讨论属于历史记录，不能覆盖页首的 v0.12 接入规则。

这是新版人物美术的主记录文件。后续逐人讨论后在本文件更新，不把未经用户确认的候选方案写成定稿。旧版 [portrait-prompts.md](portrait-prompts.md) 为停用历史稿；[旧人物侧写](../design/character-profiles.md) 已由 [新版故事梗概](../design/character-stories.md)取代，旧职业、服装和心理设定只作参考，不限制本轮重新设计。

## 一、用户已确认的方向

1. 从头讨论人物造型，先记录提示词，不花生成额度批量试图。随后按用户请求生成阿飞冷脸蛤蟆人、正常形态及简化修正；2026-09-26 用户反馈正常形态“不错 但是转职的样子呢”，继续试画三种转职。此处是当时的授权范围；最新要求已明确更新全员完整立绘，其他表情仍未扩展。
2. **《战场兄弟》游戏内战斗角色的画风与融合度，优先于真人相貌还原。**
3. 参考《光明与黑暗／光明力量》的群像设计思路，讨论人类、类人及非人类成员的差异；具体人物种族尚未决定。
4. 已有明显辨识特点的成员，可以保留并夸张少量特征；缺乏鲜明外貌标记的成员，需要原创的游戏造型。
5. 芷芷与王大芷是同一个人，已由用户确认。瑶瑶牙与一凹瑶不合并。
6. 本轮此前生成的写实肖像已被否定，不作为参考母图或正式资源。旧版人物图逐张审视，不整套默认合格。
7. 阿飞采用正常形态起步，满足等级与条件后选择转职蛤蟆人或嘉豪；后期可以付出代价重修。蛤蟆人代表技能为哇哇叫，嘉豪为豪气冲天和全力圈。“全力圈”指圈钱。
8. 水友分保飞派、儿飞派、倒飞派。小原大人、哈曼卡恩、四哥，加上可可、溺水小龟、余初九构成六根；六人各自隐藏支线都触发后解锁隐藏转职“飞碟”。
9. **飞碟外观只需在人物头顶加一个飞碟。**保留人物主体，不另造飞船身体；颜色、材质、距离和具体尺寸尚未定稿。
10. 2026-09-26：阿飞“嘉豪但是大事理得清”；前期很弱，后期成长为能鼓舞、帮助伙伴的大哥；气质为痞帅，认真时很有气势。
11. 2026-09-26：“飞碟”是“飞爹”的谐音，为儿飞派的叫法。名字和头顶飞碟设计保留，人物气质沿用阿飞。
12. 2026-09-26：转职分工为蛤蟆人自己能打、嘉豪带人、飞碟自己能打也能带人。带人的动力是成就感。阿飞、大谋、抹茶三队长开局，大谋前期很强；任务招揽的队员小酒瓶外号“蛤妈”，对阿飞成长帮助很大。具体武器与站位仍未定。
13. 2026-09-26：战斗小人与原版一样朝画面右侧，并进行实机验证。源图的头、胸肩与视线一起向右，友军直接显示，敌对阵营按原版规则镜像；不要求死亡后仍统一朝右。
14. 2026-09-26：删除蛤蟆与飞碟立绘但保留转职；缩小人物到原版附近的大小，恢复武器与防具外观叠加。此条更新第 9、11 条的外观约定。

## 二、画风基准：以进入战斗后是否协调来判断

借鉴《光明力量》的内容是“多种族、多职业、不同轮廓的伙伴阵容”。图形表现使用《战场兄弟》的战斗胸像语言；不混用光明系列的日式人物插画或全身战斗演出画法。

以下是本项目的制作约束与建议，不声称每项都是原版官方固定数值。

| 维度 | 本项目标准 |
| --- | --- |
| 主要对照 | 原版游戏内战斗角色；使用实际胸像、脸、头发和装备作为风格参考 |
| 构图 | 完整头部、短颈与紧凑肩胸；头、胸肩与视线一起朝画面右侧约 35–45°，双眼可见但远侧眼收窄；画面左肩较宽靠前、右肩较窄退后 |
| 比例 | 成人特征作适度漫画夸张；头大、胸短、轮廓紧凑；具体头身关系与原版并排校准 |
| 线条 | 深褐或近黑轮廓明确，五官和装备转折有概括的内线 |
| 面部 | 用少量阴影形状表达眉骨、鼻翼、眼窝和下颌，避免真人皮肤光影及密集微纹理 |
| 头发／羽毛／毛皮 | 画成可读的成束形状，局部线条说明方向，不逐根精描 |
| 色彩 | 布、皮、木和暗钢的朴实基底；每人一处主要强调色；不能只靠颜色区别两个人 |
| 光照与材质 | 跟随原版参考的明暗；布皮铁各有简单可读的材质差异，减少连续渐变和高光 |
| 奇幻种族 | 同一套线条、材质和光照；身体差异服务于识别和职业，不靠光效建立存在感 |
| 轮廓范围 | 头、肩、胸的标记优先；角、耳、翅收在可用范围内，避免遮住邻格或装备 |
| 武器和盾 | v0.7 恢复原版装备层，显示实际携带的武器和盾 |
| 背景 | 单体战斗素材使用真正透明背景；底座、框和地面另行处理 |
| 装备变化 | v0.7 身体在护甲下、脸在护甲上和头盔下，按原版装备逻辑刷新 |

《战场兄弟》的官方说明讨论了较大的头部、突出的五官和小尺寸下的可读性。这里采用这些原则，但最终仍须看图与进游戏检查，不能仅凭提示词包含游戏名就宣称画风合格。

### 图像验收方式（候选已试画，游戏内验收尚未完成）

- 将候选角色放在原版角色旁边，使用相同显示尺寸和相近装备条件观察。
- 先看头身比例、视角、轮廓线和明暗密度，再看个人标记。
- 缩小后不用名字仍可与同队其他角色区分；灰度下也不能只剩相似头形。
- 装卸轻甲、重甲与常见头盔，确认实际装备显示与属性同步，脸不会被护甲领口错误遮住；全盔正常遮脸。
- 新种族的角、翼、嘴吻等要单独检查裁切和装备穿插。
- 当前旧项目使用过 114×142 战斗胸像、220×220 事件图、56×56 技能图标。这些是旧工程的输出规格，不等于原版全部图层都采用这些尺寸；最终画布与位置以接入方式为准。
- 在原尺寸和常用战斗缩放下检查。高分辨率大图的细节不能替代游戏内验收。

## 三、每个人怎样建立辨识度

每次讨论围绕以下六项，尽量先决定前四项，再写完整提示词：

1. **玩家怎样记住这个角色？**一句容易记住的游戏身份。真实人物的名字、关系和梗可提供连接。
2. **种族与体形。**人类、类人或非人类均为候选；不根据昵称自动分配动物，也不规定每人必须独占一个种族。
3. **主要轮廓。**选一项最强识别点，例如方形厚肩、尖窄羽冠、圆头短颈、竖直高领。
4. **辅助标记。**再选一项，例如特定发型、眼镜、衣领形状或一件标志装备，避免堆叠多个小挂件。
5. **战斗职责与装备。**造型让玩家大致理解其用途；形态不自动附送飞行、免伤、变身等能力，具体机制另行设计。
6. **队内差异与故事。**与谁最容易撞型，如何调整；这种外形怎样关联入队经历与成长。

“角色在游戏里好认”与“第一眼认出对应主播”分别处理。游戏辨识由造型承担；主播对应还由名字、台词、熟悉的关系和剧情建立。没有鲜明真人脸部特征的成员，也可以成为鲜明的原创伙伴。

## 四、生图提示词的组织方式

完整提示词由三部分组成：**通用画风段＋人物段＋当前资产用途段**。人物段未定稿时默认不执行生成；用户明确要求试画时，可按指定候选生成样图，不能把试画授权等同于最终造型确认。以后如果采用参考图，原版战斗角色作主参考；真人照片仅辅助提取已选定的少量特征，不能重新变成照片临摹任务。

### 通用画风段 v0.2（含 v0.6 朝向约束）

```text
为《战场兄弟》Battle Brothers Mod 绘制一个可融入原版战斗画面的二维角色胸像。以所附原版游戏战斗胸像为首要风格标准，匹配其头身比例、观察角度、轮廓线、面部概括程度、装备材质和明暗密度。

头部、胸腔、双肩和视线一起朝画面右侧约 35–45 度，鼻尖明确向右，不回看观众。保留双眼，画面右侧的远眼明显收窄；画面左肩较宽靠前，右肩收窄退后。身体不能仍正对观众，也不能用水平翻转正面图代替真正的透视转向。不要转成完全侧脸。

角色采用较大的头部、短颈和紧凑肩胸，成人五官进行有节制的漫画夸张；深褐近黑的清楚轮廓，少量明确的面部阴影，概括的眉眼鼻口。头发、羽毛或毛皮以成束形状表现。服装使用朴实的布、旧皮、木、暗钢材质；结构清楚，细节为游戏小尺寸服务。

画法保持统一的游戏插画感与适度夸张。面部不出现照片式皮肤、毛孔、真实反光或连续柔滑的肖像光影；不采用油画肖像、电影概念图、3D 渲染、精致美颜、日式卡牌或幼儿玩偶比例。种族特殊也使用同一套画法。

准确保留人物段规定的一项主要轮廓与一项辅助标记，兼顾与其他队员的差异。整个人物必须在战斗常用缩放下读得清楚。只生成一个角色，不输出角色合集或多视图排版。

输出范围、参考图用途和透明背景要求以当前资产用途段为准。
```

### 人物段模板

```text
角色名：【姓名／称呼】。
本段状态：【讨论稿／用户已确认】。
游戏身份：【一句话】。
种族与可见体形：【已讨论确定的内容】。
主要半身轮廓：【一项强识别点】。
辅助标记：【一项】。
头部、脸部与惯常表情：【概括形状；如有真人参照，只提取已选定的特征】。
基础衣装与强调色：【衣领、肩线、布皮铁结构；颜色不能成为唯一识别点】。
装备关系：【可更换部分、须保留的身份特征，以及可能遮挡的部分】。
同队差异：【最容易与哪位混淆，本角色用什么轮廓区分】。
禁止误解：【例如不因昵称画醉态、不把职业道具当成身体结构】。
```

### 单体造型母图用途段

```text
用途：角色造型母图，供后续战斗胸像与图层制作参考。绘制完整头顶、短颈、肩部和上胸，裁切方式及朝向跟随所附原版战斗角色。轮廓完全入画并留透明余量，真正透明背景，无场景、光圈、文字、姓名牌、装饰边框、底座或地面。不绘制手臂、手或腿。武器和盾不融合进身体。

这是一张角色造型母图，不是已验证的游戏图层。分层、坐标、遮挡、受伤与死亡状态应在造型确定后按对应资产任务分别制作。
```

## 五、逐人讨论与人物提示词

### 01｜阿飞

**状态：正常形态 v02 方向获初步认可；蛤蟆人、嘉豪和飞碟概念候选已留档，并按用户后续要求制作分层游戏资源 v1。最新气质为痞帅、认真时很有气势；冷脸凶相作为认真状态保留。下面保留概念阶段的设计和生成词，当前游戏资源另见本页顶部链接。**

用户原话：**“蛤蟆 杀人犯 哇哇大叫 嘉豪步伐 骚叫”**。

这些是用户提供的梗与游戏创作素材。用户已说明“杀人犯”指冷脸凶相，提示词只记录对应神态。其他关键词的细化表达仍为设计建议。

#### 当前方案：三套基础造型＋头顶飞碟

玩法与重修记录见 [阿飞分支转职](../design/afei-promotion.md)。正常形态及三种转职已试画，实际提交词见本节生成记录；独立飞碟层后续已在游戏美术 v1 制作。冷脸蛤蟆人 v01 实际提交词保留为历史记录，不作为最新转职造型标准。文字方案、概念 PNG 与游戏图层分别编号，不能混同。

| 形态 | 用户确定的用途 | 当前美术提案 | 状态 |
| --- | --- | --- | --- |
| 正常形态阿飞 | 实力偏弱的起步形态，达到条件后才能转职 | 人类候选；短黑发、朴素佣兵衣装，以略带不对称的眉眼和嘴线表达痞帅 | v02 方向获初步认可；未实机验证 |
| 蛤蟆人 | 自己能打，代表技能哇哇叫 | 保留宽嘴与眼眶特征；更利落的眉眼、下颌、小片护肩 | 转职 v01 候选已生成；旧冷脸 v01 留档 |
| 嘉豪 | 带人，代表技能豪气冲天、全力圈 | 同一张人类脸，立领、皮甲、黑披肩配少量暗红与旧金 | 转职 v01 候选已生成，待反馈 |
| 飞碟 | 自己能打也能带人；六根隐藏线均触发后解锁，头顶加飞碟 | 以嘉豪主体加暗钢、旧铜色小飞碟展示效果 | 整体预览留档；独立层已在游戏美术 v1 制作 |

三形态的画法优先级一致：原版战斗胸像比例、角度、线条和阴影密度优先，帅气由形状与神态建立，不用写实俊脸或大量发光特效。候选共同标记为低眼睑与嘴线的关系，以及同一处黑色布结／领扣；具体标记尚未确认。

性格以用户的“嘉豪但是大事理得清”为准，三套造型都保留这一点。表情设计提案为两种可切换的气质：常态用轻微挑眉、略不对称的嘴角表现痞帅；认真时收起笑意、目光集中、嘴线收紧。具体眉嘴形状是助手美术提案，不是已确认的真人相貌。每张母图只表现一种状态，暂不生成表情组。早期实力弱可以通过朴素装备与尚不成熟的姿态体现，仍保留清醒的眼神。

#### 当前提示词：正常形态阿飞 v02（文字方案，已据此试画，未定稿）

```text
角色：阿飞，主角开局时的正常形态；本候选按成年男性人类佣兵设计。
服从通用《战场兄弟》原版战斗胸像画风段及单体母图用途段。匹配原版的紧凑肩胸、相对较大的头部、略朝同一侧的视角、清楚的深色轮廓和概括阴影。
候选外貌为短黑发，顶部少量成束发形、侧边收短。低眼睑、清楚的眉线；一侧眉毛略抬，闭合嘴角微微不对称，表现带点嘉豪劲儿的痞帅。目光清醒，保留大事拎得清的感觉。只提炼少量特征，不临摹真人皮肤和精细五官。
身穿灰米色棉甲、旧褐皮带与简洁黑色短披肩。保持朴素但利落的领口和肩部轮廓，为后续转职留出成长空间。黑色布结或领扣的位置可作为三形态的共同标记，待定。
开局实力很弱，衣装朴素，气势尚未达到后期团长程度；帅气来自眉眼关系、轻微痞气和清楚的衣装结构。无写实肖像、漂亮卡牌脸、巨大王冠、闪光光环或装饰堆叠。
透明背景，单体胸像，武器与盾另做；不画腿或手持动作。
```

#### 当前提示词：蛤蟆人转职 v03（文字方案，已据此试画，未定稿）

```text
角色：阿飞转职后的蛤蟆人。参考 v01 只保留蛤蟆头、宽嘴、冷脸和佣兵身份；重新设计得更利落、更有主角气势。
严格匹配所附《战场兄弟》原版战斗胸像画法、角度与比例。使用明确的深色轮廓、少量有结构的阴影和朴实装备材质，保持小尺寸读得清楚。
宽扁蛤蟆头，眼眶隆起，眼睑较低；两侧眼睑和宽嘴末端略带不对称，宽嘴闭合，表现克制的痞气而非大笑。目光清醒。下颌和颊部收紧，减少 v01 圆软松垮的观感。保留可见的浅色喉部，但常态不过度膨大；叫喊状态另做。
灰橄榄至泥褐的肤色，表面哑光；少量疣点作为大形点缀，不逐颗精描。头相对身体较大，但肩胸紧凑、姿态挺直，不能拉成长身写实英雄。
候选转职衣装为轮廓清楚的棉甲与小片护肩，搭配收束利落的黑色短披肩；喉部和宽嘴保持可见。结构比开局更成熟，仍像原版佣兵装备。共同黑色布结／领扣待讨论，不堆小配饰。
常态痞帅，保留蛤蟆本身的识别度。认真状态可另以收平嘴线、压低眼睑和凝视表现冷脸凶相，本张只画常态。无写真式两栖皮肤、黏液反光、巨型腹部、幼儿玩偶眼、肌肉怪兽体形、华丽发光铠甲。
单体透明胸像，不画张嘴叫喊、腿部步法、武器持握或多视图。
```

#### 当前提示词：嘉豪转职 v02（文字方案，已据此试画，未定稿）

```text
角色：阿飞转职后的嘉豪。本候选为正常人类阿飞的进阶形态，保留开局已确定的脸型、眉眼与嘴线关系，避免变成完全不同的人。
服从《战场兄弟》原版战斗胸像的头身比例、视角、轮廓线和概括阴影；与正常形态、蛤蟆人形态使用同样的画法。
短黑发整理得更利落，低眼睑仍可辨认；下颌略抬，一侧眉毛和闭合嘴角轻微上扬，表现自信、有点痞气的团长。目光清醒，肩胸稳当，保留遇到大事能收起玩笑的感觉。痞帅气质已确认，具体五官形状为候选，不能转成写实男明星肖像。
候选装备为黑色短披肩、结构利落的皮甲或棉甲、露出脸部的挺括短领。一枚醒目的旧金色领扣或徽记作为辅助标记；只保留有限的旧金与暗红强调色，整体仍是布、皮、暗钢的佣兵材质。
肩胸紧凑，站姿有精神；三形态的共同布结／领扣位置待确认。财富感通过衣装整洁度、扣件和轮廓表达，不在人物周围堆金币或画金币雨。
透明背景，单体战斗胸像；武器、盾另做。无现代西装、墨镜、写实美颜、华丽卡牌背景、金色能量光环或大面积金属镜面反光。
```

#### 当前提示词：飞碟头顶附加层 v01（讨论稿，不执行）

用户原话：“在人物头顶加个飞碟就好了”。下面是独立装饰的中文设计稿，未原样提交生成；概念阶段另用整体编辑词制作预览，后续游戏美术 v1 又用独立层实际提示词制作单独飞碟。飞碟的职业能力另议，不用一张图预先决定技能。六根条件与接入方案见 [水友三派与六根](../design/supporter-factions.md)。

2026-09-26 补充：“飞碟”为儿飞派称呼“飞爹”的谐音。附加物把谐音变成视觉标记，下面的人物继续沿用痞帅、认真时有气势的阿飞；不因称呼而擅自改成年迈父亲形象。

```text
用途：《战场兄弟》阿飞隐藏转职“飞碟”的头顶附加精灵，只画一只小飞碟，真正透明背景。
严格匹配所附原版战斗胸像参考的视角、光向、轮廓粗细与阴影密度。物体需要像原版手绘装备图层，缩小后仍能辨认其形状。
候选造型：低矮的扁碟形主体，一圈清楚的外沿，中央一个简洁的矮凸顶。轮廓紧凑，略俯视的椭圆与角色视角一致。用少量大色块表达立体感。
候选配色为低饱和暗钢灰，或带少许旧铜色；深褐至近黑描边，哑光表面，仅少量概括高光。材质细节适度，保持《战场兄弟》的朴实手绘感。
设计为悬在人物头顶的小附加物，尺寸以合成时能辨认且不盖住脸、头盔或状态标记为准。画面只含飞碟，主体完整并留透明余量；实际悬浮位置在游戏中设置。
不绘制人物、头、头盔、外星人、背景或文字。不画光束、霓虹灯环、大面积发光、写实科幻金属、3D 飞船渲染或密集机械零件。
```

制作约定：先用静态贴图跟随角色，浮动或旋转属于后续可选效果。飞碟与头盔为独立层，不把它画死在脸、头发或头盔上。合成预览沿用选定的阿飞主体；是否沿用转职前具体形态为当前提案，不代表保留该职业全部技能。战斗、名册预览的遮挡与裁切分别验证，不能直接认定旧版 114×142 胸像画布足够容纳头顶新增物。

#### 正常形态实际生成记录（2026-09-26）

- 本轮请求：“不如先完善一下阿飞的美术资源”。先试画正常形态，再做一次有针对性的画风简化，共两次内置 image_gen 调用。
- v01：[过程稿](../../art/character-concepts/afei/afei-normal-roguish-v01.png)；人物神态与衣装已出现，但纹理偏多。
- v02：[当前候选母图](../../art/character-concepts/afei/afei-normal-roguish-v02.png)；脸、头发与衣料改为更简明的色块，人物身份和衣装方向保持。
- [v01 元数据](../../art/character-concepts/afei/afei-normal-roguish-v01.json)、[v02 元数据](../../art/character-concepts/afei/afei-normal-roguish-v02.json)保存实际提示词、参考顺序、源文件路径、尺寸、透明通道检查和 SHA-256。
- 旧 C01 人类母图仅提供黑发、眉眼与神态参考；原版官方合集、原版头部与衣装图层作为画风参考。旧人类稿中的肩部蛤蟆、旗杆与复杂装饰在本次候选中移除。
- 后续用户反馈 v02“不错”，作为本轮转职试画的身份与画法基准；仍未完成严格的原尺寸并排、换装、受伤／死亡与实机验证。

v01 实际提交词：

```text
Use case: style-transfer.
Asset: ONE revised human starting-form tactical bust for the Afei Battle Brothers mod.

INPUTS:
Image 1 is the OLD Afei human character concept to redesign. Keep the recognizable short black hair, strong slanted eyebrows, alert narrow eyes and roguishly handsome adult male identity. This is NOT the target rendering style.
Image 2 is the official Battle Brothers bust sheet and is the PRIMARY style, proportions, camera and simplification reference.
Images 3 and 4 are native Battle Brothers head and cloth-body sprites. Match their simple facial marks, compact pawn construction and economical material shading.

EDIT:
Rebuild image 1 as a small native Battle Brothers tactical character bust, not a tall character portrait. Remove the frog on his shoulder, rear flag and flagpole, frog badges and ornate gear. Replace the costume with a plain worn grey-beige gambeson, a short charcoal cloth shoulder mantle, one plain brown leather fastening. He is a weak beginning mercenary with potential, not already a richly armored commander.
Keep a human face. Short black hair in just a few chunky painted locks, sides shorter. Adult East Asian-inspired facial shapes, slightly broad face, strong simple brows, low upper eyelids, observant eyes. A restrained crooked CLOSED-mouth half-smile and subtly raised brow give roguish confidence. His expression should feel alert and capable of becoming serious; no broad toothy grin, no vacant clown expression. Handsomeness must come from clear shape and expression rather than realism.
Turn the bust slightly toward viewer's RIGHT, with the slightly elevated three-quarter view of image 2. Large head above very short compact shoulders and chest. Full hair, both shoulders and bottom chest edge must be visible. No arms, hands, legs, weapons, shield or accessories beyond the simple fastening.

STYLE PRIORITY:
Match the actual GAME SPRITES in images 2-4: dark brown contours, mildly exaggerated adult facial features, a handful of deliberate painted shadow shapes, restrained highlights, muted warm skin, matte cloth and leather. Deliberately limit detail to what survives on a roughly 114 by 142 pixel game bust. Display enlarged for inspection, but do not add extra detail because of the large output canvas.
Do not retain image 1's polished fantasy portrait finish. No photographic skin, pores, realistic strand-by-strand hair, dense painterly texture, cinematic lighting, smooth airbrushed face, 3D gloss, anime face or eyes, enormous shoulder armor, long torso, watercolor edges, white cutout halo or text.

COMPOSITION:
One intact isolated bust only, centered with clear margin around the full silhouette, TRUE TRANSPARENT ALPHA background. No scene, floor, pedestal, shadow on the ground, sheet of variants, labels, decorative frame or checkerboard drawing.
Only the calm roguish expression in this image. This is a design candidate, with game equipment layers to be prepared separately.
```

v02 实际提交词：

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


#### 转职样图实际生成记录（2026-09-26）

- 用户请求：“不错 但是转职的样子呢”。本轮共三次内置 image_gen 调用，分别制作以下候选；正常形态 v02 提供画法与人物身份基准，官方原版胸像用于校准。
- 蛤蟆人从旧蛤蟆人探索图重做，嘉豪从正常形态 v02 派生，飞碟在新嘉豪图上编辑。每个 JSON 保存参考图顺序、源路径、实际尺寸、透明通道、SHA-256 和评审状态。
- 新三张均为待反馈的造型母图；没有替换游戏内资产。飞碟是整体生成预览，尚未输出独立飞碟层，也不是与嘉豪逐像素一致的叠图。它不决定隐藏职业从其他路线转入时的身体外观或技能继承。
- [四形态对照页](../../art/character-concepts/afei/promotion-comparison.html)提供缩放观察；114×142 仅沿用旧工程观察窗口，不代表新图层规格或实机验收。

**蛤蟆人转职 v01**：[PNG](../../art/character-concepts/afei/afei-toad-promoted-v01.png) · [生成记录](../../art/character-concepts/afei/afei-toad-promoted-v01.json)。

实际提交词：

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

**嘉豪转职 v01**：[PNG](../../art/character-concepts/afei/afei-jiahao-promoted-v01.png) · [生成记录](../../art/character-concepts/afei/afei-jiahao-promoted-v01.json)。

实际提交词：

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

**飞碟转职 v01（整体预览）**：[PNG](../../art/character-concepts/afei/afei-feidie-promoted-v01.png) · [生成记录](../../art/character-concepts/afei/afei-feidie-promoted-v01.json)。

实际提交词：

```text
Use case: precise-object-edit.
Asset: ONE complete preview of Afei's hidden FEIDIE promotion for the Battle Brothers mod.

EDIT THE PROVIDED IMAGE. Preserve the entire human character exactly: same recognizable face, black hair, eyes, eyebrows, small roguish closed-mouth smile, pose, skin, charcoal mantle with muted burgundy edge, old brass clasp, brown armor, simplified drawing style and facing direction.
The ONLY design addition is ONE small flying saucer floating above his hair. The user specifically wants a saucer above the existing character's head. "Feidie" is a pun on "Feidie / flying dad"; do not transform the body into a vehicle.

Saucer design: a compact flattened elliptical disk with a low central dome and a simple dark rim, drawn as a modest hand-painted game accessory. Muted old-steel grey with a restrained worn brass edge, dark brown outline and just two or three flat shadow planes. Same slightly elevated three-quarter perspective and light direction as the character. No polished chrome, tiny mechanical detail or sci-fi lighting.
Width about half to three-fifths of the character's head width. Place it centrally above the hair with a clearly visible small transparent gap. It must read as hovering, not a helmet or halo. Leave clear margin above the saucer; extend the transparent canvas upward if needed. Do not cover the hair or face and do not crop the shoulders or bottom of the bust.
Keep the body and head visually unchanged and avoid adding texture or realism. This is a small Battle Brothers tactical bust preview enlarged, with simple matte color shapes.
One character and one saucer only. TRUE TRANSPARENT ALPHA. No beam, glow, sparks, magical circle, legs, hands, weapon, text, frame, ground or background.

```

#### 分支技能图标的文字方向（尚未执行）

- **哇哇叫／蛤蟆人：**用张开的宽嘴与鼓起喉部表达喊声，必要时只加少量清楚的声音线；图标尺寸下保持强识别。
- **豪气冲天／嘉豪：**若采用“花钱支持关键战斗”的玩法，可用递出的赏钱与向上的团旗构成简明图形；具体图标须在效果定案后确定，不按名称自动画成魔法光柱。
- **全力圈／嘉豪：****圈钱含义已确认。**首个图标候选是少量克朗落入打开的钱袋，主体和落入方向清楚；不画为环形斩击、圆形冲击波或无关的回复法阵。是否采用赞助、契约溢价等表现取决于技能机制。

以下为 v01 历史探索记录，说明旧图怎么产生；新的造型讨论以前面的三形态段为准。

#### 关键词如何进入角色设计

| 用户关键词 | 候选表达 | 放在哪类资源里 | 尚待确定 |
| --- | --- | --- | --- |
| 蛤蟆 | 宽扁头、宽嘴线、眼上方隆起、短颈和可读的喉部轮廓 | 常态战斗胸像的主要剪影 | 完整蛤蟆人，还是保留较多人脸的两栖类人 |
| 杀人犯 | 冷脸凶相；本次试画用压低眼睑、闭合宽嘴与凝视表现 | 常态表情 | 含义已由用户确认；具体图形表现待样图反馈 |
| 哇哇大叫 | 宽嘴张开、下颌下落、喉部鼓起，形成明显叫喊表情 | 叫喊表情候选、技能图标或事件图 | 与“骚叫”是否需要区分成两个状态 |
| 嘉豪步伐 | 与步法有关的技能图标和动作参考；先记名称 | 技能资源／动作设计记录 | 具体步态未获描述，不擅自写成内八、外八、踮脚或左右摇摆 |
| 骚叫 | 候选为扬眉、歪嘴、夸张口形等带表演感的叫声表达 | 另一种表情候选或技能图标 | 具体口形、神态待用户描述，不自行解释为色情内容 |

五项内容按用途分配。常态胸像承载蛤蟆轮廓和一个表情，声音与步法可以在技能或事件中表达，避免把所有梗堆在同一张图上。

#### 历史造型候选 A：蛤蟆人佣兵 v01

**一句话形象：一个宽脸短颈、常态冷脸凶相，一张嘴就能大声叫喊的蛤蟆人佣兵。**本次只试画闭嘴常态。

- **主要识别点：**宽扁蛤蟆头及一条清楚的宽嘴线，缩到战斗尺寸仍可辨认。
- **辅助识别点：**短颈下浅色的喉部轮廓，供叫喊表情变化使用；不用多个小挂件承担识别。
- **头部处理：**眼睛位于隆起的眼眶中，眼睑形状决定神态。嘴与眼窝用明确线条和少量阴影表示。常态不必永久张大嘴。
- **肤色候选：**灰橄榄或泥褐底色，喉部浅灰米色。疣点只作少量大形概括，避免写实湿亮皮肤和密集颗粒。
- **基础衣装候选：**适配其体形的灰米色棉甲、旧褐皮带与炭黑短披肩。喉部开口须可读；具体职业和初始装备另议。
- **游戏融合：**头部相对身体较大，肩胸紧凑；轮廓线、色块、材质和明暗密度跟随原版战斗角色。不能画成动物写生、黏液怪物或儿童玩偶。
- **装备适配：**早期曾计划适配头盔和衣领；v0.4 已按用户要求隐藏原版装备图层，使用完整蛤蟆主体，装备玩法保留。
- **成长表达：**以后可改变装备整理程度、神态和旗帜状态，保留头形、嘴线与喉部这组身份标记；不自动把成长画成变回人类。

#### 人物提示词候选 A（中文设计记录；本次实际提交词见后）

```text
角色：阿飞的原创游戏化身。本次获准试画蛤蟆人佣兵，最终造型尚待看图讨论。
严格服从本文件的《战场兄弟》原版战斗胸像通用画风段；原版游戏角色是主要画法参考，真人照片不作为脸部临摹目标。

紧凑的半身棋子轮廓，宽扁蛤蟆头、短颈、短而结实的肩胸。头部较大，一条清楚的宽嘴线形成主要识别点。眼眶略隆起，眼睑和眉部用简单的深色线条概括，面部只保留少量明暗形状。

肤色暂用灰橄榄与泥褐，短颈下的喉部为浅灰米色。肤面哑光，零星疣点简化成几处图形，不描绘湿润反光、毛孔或密集纹理。

常态表情采用用户确认的冷脸凶相：眼睑压低、凝视前方、宽嘴闭合、嘴角平直或略向下，用简明的五官线条表达。

基础衣装暂用灰米色旧棉甲、简洁褐色皮带和炭黑短披肩；领口为喉部留出可读空间，具体装备待定。武器、盾与真正的团旗独立处理。

以原版的粗细适度的深色轮廓、概括色块和朴实装备材质表现成年奇幻佣兵。无写实人像、连续柔滑肖像光影、3D 反光、糖果色、幼儿大圆眼、现代衣物、文字或背景装饰。

仅绘制常态单体胸像。“哇哇大叫”“骚叫”和“嘉豪步伐”分配到各自的后续资源，不在此图同时画出五种状态。
```

#### 表情与步法资源的文字记录（均未确认，不执行）

- **哇哇大叫表情段：**保持已定的头形、肤色和衣装，改为宽嘴张开、喉部鼓起、眉眼用力的叫喊状态；不增加凭空漂浮的文字和霓虹声波。
- **骚叫表情段：**等待用户说明与哇哇大叫的区别，再决定口形与眉眼，不复制同一表情充数。
- **嘉豪步伐：**先保留名称，待具体动作描述或参考后写图标提示词。当前战斗胸像不画腿，不通过硬塞全身舞步改变《战场兄弟》的构图。动作、音效和表情切换的实际实现另议，不视为已有功能。

v01 已获得用户反馈：基本方向可以，但不够帅。现按前述三形态方案继续讨论，历史生成词保持原样。

#### 单张样图 01：实际生成记录

- 用户授权：“冷脸凶相 你生成一个看看”。
- 工具：内置 image_gen；仅一个生成请求。
- 状态：已生成一张；用户反馈“可以，但是不够帅”。保留为历史探索稿，尚未实机验证，不作为转职最终美术。
- 样图：[阿飞蛤蟆人冷脸 v01](../../art/character-concepts/afei/afei-toad-cold-v01.png)。原始生成文件另行保留，未覆盖旧图。
- 生成参数与来源：[记录 JSON](../../art/character-concepts/afei/afei-toad-cold-v01.json)。
- 视觉检查：宽头、低眼睑、闭合宽嘴、浅色喉部、紧凑肩胸与旧棉甲均已出现。图中笔触仍较明显；这张只作造型候选，不声称已经通过原尺寸或游戏内融合度验收。
- 主参考：[原版官方胸像合集](../../art/references/battle-brothers-style/official-brothers-busts-2016.jpg)。只用于画法、比例和视角。
- 辅助参考：[原版头部](../../art/references/battle-brothers-style/bust_head_01.png)、[原版棉甲](../../art/references/battle-brothers-style/bust_body_01.png)。来自已归档旧工程的原版图层检查资源。
- 此次不输入真人照片或已否定的写实肖像。

实际提交提示词：

```text
Use case: stylized-concept.
Asset: ONE sample tactical character bust for an Afei Battle Brothers mod.

STYLE REFERENCES:
Image 1 is an official Battle Brothers in-game bust sheet. Match its compact pawn proportions, slightly elevated three-quarter view, outlined facial shapes, simple hand-painted shading and modest detail density. It is a STYLE reference, not a request to reproduce the sheet.
Image 2 is an actual native Battle Brothers head sprite: match its economy of facial marks and painted shadow shapes.
Image 3 is an actual native Battle Brothers cloth armor sprite: match this clothing construction and graphic material treatment.
The output must look like another SMALL GAME SPRITE made for the same game, enlarged for inspection. Keep the simplicity of a tiny native sprite even on the large canvas. ONE character only.

CHARACTER:
Afei reimagined as an adult TOAD-FOLK mercenary. A broad flattened toad head, low heavy eye ridges, narrow half-lidded amber eyes, a wide CLOSED horizontal mouth with slightly downturned corners, short thick neck, pale grey-beige throat pouch resting naturally (not inflated). Cold, stern, intimidating deadpan expression. Distinctly amphibian face, no human face pasted on, no human hair. The humor comes from the unusual toad mercenary silhouette, not a smile. Head turned slightly toward the viewer's RIGHT, matching the reference sheet's tactical view. Eyes focused ahead under the low lids.
Muted grey-olive and muddy brown skin in a few broad painted planes, at most a handful of large understated toad bumps. Matte skin without biological realism. Large head above a short compact shoulder-and-chest body.
A plain worn grey-beige quilted gambeson with a simple brown leather fastening; a short charcoal-black cloth mantle over the shoulders. Open low collar leaves the pale throat visible. Ordinary low-rank mercenary equipment, modest and practical. No elaborate ornament.

RENDERING:
Dark brown silhouette and selective internal lines. Restrained native-game painterly shading, crisp important contours, stylized exaggerated features. Match the references' light direction and contrast. No fine skin texture, stippling, pores, photographic soft gradients, realistic frog anatomy rendering, polished fantasy concept-art finish, brush-noise filter, 3D, anime eyes, glossy toy or vector logo style. No green glow. No photoreal portrait.

COMPOSITION:
One intact compact chest-up tactical pawn, full head, both shoulders, short torso with a shallow rounded bottom cut like the references. No arms, hands, legs, weapon, shield, flagpole, ground or base. Do not make a conventional tall portrait or a full-body frog.
Centered on a square canvas with at least 8 percent clear margin; TRUE TRANSPARENT ALPHA background, no drawn checkerboard, no white outline, no text or border.
Generate only the calm closed-mouth expression. Do not add screaming variants, gait diagrams or multiple views.
```

### 蓝队名单更正（2026-09-28）

刘佳俊／眼子哥已恢复为当前第 12 位，共 35 人；罗一可为第 18 位。两人的专属头像现已完成：罗一可以本轮用户照片为唯一身份参考，眼子哥参考仓库 Sylar 历史海报。见[实际提示词与原图记录](../../art/runtime/portraits-v05/PROMPTS-blue-team-v24.json)及[装备预览](../../build/blue-team-stories/portraits-review.png)。

罗一可仍保留内部键 `xiaohani` 与旧画刷 ID 兼容存档，默认姓名更新，玩家自定义姓名保留。以下旧编号表保留当时讨论过程，当前状态以现行名单和新头像记录为准。

原小哈尼照片、提示词及头像仅保留来源记录，不能标成罗一可本人的参考。

### 全员讨论进度（历史记录）

当前序号沿用 [34 人制作名单](../design/character-roster.md)，眼子已按用户要求移出，**不是旧工程 Cxx 资源编号**。下表不预先分配种族和职业；讨论到该人物时再增加完整人物段。

本轮只记录辨识方向，不执行生图。小宁的“外星人／流口水”可探索神态与喜感，街舞可影响小胖徐的重心和动作语言，蔓越莓的“S”只转译为强势主导气场；这些都不要求写实或预定种族。宋暖阳的“鹌鹑”也先作为称呼与神态方向。小龟是不露脸皮套主播，游戏角色按男性设计，后续从公开皮套意象讨论化身，不寻找或猜测真人脸；具体壳形、装备和种族尚未定稿。小哈尼的辨识点待补。所有方案仍服从《战场兄弟》的原版比例、深色轮廓、概括色块与小尺寸可读性。

| 当前序号 | 人物 | 新造型状态 |
| --- | --- | --- |
| 01 | 阿飞 | 正常 v02 方向获初步认可；三种转职概念稿留档；游戏图层 v1 已制作头／身体／伤痕／倒地／独立飞碟，待实机验收 |
| 02 | 王大谋 | 造型待讨论；开局队长，前期很强 |
| 03 | 午夜抹抹茶 | 待讨论 |
| 04 | 小酒瓶 | 造型待讨论；任务招揽的队员，外号蛤妈，对阿飞成长帮助很大 |
| 05 | 白小帅子 | 待讨论 |
| 06 | 李李超欧 | 待讨论 |
| 07 | 小月牙 | 待讨论 |
| 08 | 余初九 | 造型待讨论；已列入六根隐藏支线 |
| 09 | 小鱼贝壳 | 待讨论 |
| 10 | 王怼怼 | 待讨论 |
| 11 | 老蔡／川神／陈彦川 | 待讨论 |
| 12 | 亿口甜筒／小虎 | 待讨论 |
| 13 | 小宁 | 已记录外星人／流口水的喜感方向；造型与种族未定，不生图 |
| 14 | 小胖徐不快乐 | 已记录街舞、卡拍与重心方向；不从昵称推定体型，不生图 |
| 15 | 大鹅 | 待讨论 |
| 16 | 蔓越莓 | 已记录强势主导气场；具体神态、轮廓与服装待讨论，不生图 |
| 17 | 罗一可 | 蓝队名单已更正；个人辨识点与本人参考待补，当前头像仅占位 |
| 18 | 可可 | 造型待讨论；已列入六根隐藏支线 |
| 19 | 余想 | 待讨论 |
| 20 | 童猪 | 待讨论 |
| 21 | 美伢 | 待讨论 |
| 22 | 玩蛇 | 待讨论 |
| 23 | 涂涂 | 待讨论 |
| 24 | 宋暖阳 | 已记录鹌鹑称呼；神态与轮廓待讨论，不自动设为鸟人 |
| 25 | 溺水小龟 | 不露脸皮套主播；男性游戏化身，沿用用户指定圆脸小龟参考；六根身份保留。新增待实现设定：大头禁戴头盔、厚壳高防、天生钢头 |
| 26 | 奶盖 | 待讨论 |
| 27 | 小杰 | 待讨论 |
| 28 | bula | 待讨论 |
| 29 | 苏袜 | 待讨论 |
| 30 | 千涵 | 待讨论 |
| 31 | 王大芷／芷芷 | 待讨论；与芷芷为同一人已确认 |
| 32 | 瑶瑶牙 | 待讨论 |
| 33 | 羊咩咩 | 待讨论 |
| 34 | 陈知含 | 待讨论 |

### 新增水友代表的造型讨论

以下三人加入剧情设计范围，是否可招募参战尚未确定，暂不列入 34 人战斗制作名单。可可、溺水小龟、余初九沿用上表身份。

| 人物 | 已确认内容 | 提示词状态 |
| --- | --- | --- |
| 小原大人 | 儿飞派代表、六根之一 | 待讨论个人梗、种族、轮廓与标记后编写 |
| 哈曼卡恩 | 儿飞派代表、六根之一 | 待讨论；不凭昵称直接套用同名动漫人物造型 |
| 四哥 | 儿飞派代表、六根之一 | 待讨论个人梗、种族、轮廓与标记后编写 |

保飞派、倒飞派代表名单待用户指定。所有新人物沿用同一《战场兄弟》画风约束。

## 六、决定记录

| 日期 | 内容 | 类型 |
| --- | --- | --- |
| 2026-09-25 | 新人物造型从头讨论，当前只写提示词，不生图 | 用户指令 |
| 2026-09-25 | 原版战斗画风与进游戏协调性为最高美术要求，真人相似度退居辅助 | 用户指令 |
| 2026-09-25 | 多种族群像可作讨论方向，尚未确认个人种族 | 讨论范围 |
| 2026-09-25 | 王大芷与芷芷为同一人 | 用户确认 |
| 2026-09-25 | 阿飞先讨论最该保留的特点，再决定种族与造型 | 用户选择 |
| 2026-09-25 | 阿飞关键词：蛤蟆、杀人犯、哇哇大叫、嘉豪步伐、骚叫 | 用户提供 |
| 2026-09-25 | 蛤蟆人佣兵为首个造型候选；关键词的视觉分工与具体神态均未确认 | 助手建议 |
| 2026-09-25 | “杀人犯”指冷脸凶相；授权生成一张样图看看 | 用户确认与请求 |
| 2026-09-25 | 蛤蟆人样图可以但不够帅；主角应有更多美术与成长投入 | 用户反馈 |
| 2026-09-25 | 正常形态起步，达到等级和条件后选择蛤蟆人或嘉豪；技能归属及全力圈＝圈钱 | 用户提出 |
| 2026-09-25 | 后期可以付出代价重修 | 用户选择 |
| 2026-09-25 | 水友三派参与；小原大人、哈曼卡恩、四哥、可可、溺水小龟、余初九构成六根，六条隐藏支线都触发后解锁飞碟 | 用户提出 |
| 2026-09-25 | 飞碟外观在人物头顶加个飞碟，保留人物主体 | 用户指定 |
| 2026-09-25 | 飞碟独立图层、静态悬浮起步、暗钢或旧铜配色；具体大小和位置需实机校准 | 助手提案 |
| 2026-09-26 | 阿飞嘉豪但大事拎得清；前期很弱，后期成长为能鼓舞、帮助伙伴的大哥 | 用户确认 |
| 2026-09-26 | 气质为痞帅，认真时很有气势；当前三形态提示词按此更新，历史生成词不变 | 用户确认与文字更新 |
| 2026-09-26 | 飞碟是飞爹的谐音，为儿飞派的叫法；显示名称和头顶附加物保留 | 用户解释 |
| 2026-09-26 | 蛤蟆人自己能打、嘉豪带人、飞碟兼顾；动机为带人的成就感；三队长开局，大谋前期强，小酒瓶为后续招揽的队员、外号蛤妈，对阿飞成长帮助很大 | 用户确认 |
| 2026-09-26 | 用户要求先完善阿飞美术；以旧 C01 人类形象保留短黑发、眉眼和痞气，参照原版胸像试画正常形态，首版后进行一次细节简化；v02 保存为待反馈候选 | 本轮制作记录 |
| 2026-09-26 | 用户反馈正常形态“不错 但是转职的样子呢”；以正常形态 v02 为画法基准，三次内置生图分别制作蛤蟆人、嘉豪和头顶飞碟整体预览，保存完整生成词与四形态对照页 | 用户反馈与制作记录 |
| 2026-09-26 | 用户要求看旧版并优化成游戏可用资源；按原生头／身体拆层制作 v1，新增伤痕和倒地素材、独立飞碟、图集构建与美术验收起源；实际生成词另存游戏图层提示词，未宣称实机通过 | 用户请求与制作记录 |
| 2026-09-26 | 用户移出眼子，当前34人；补充小宁外星人／流口水、小胖徐街舞、蔓越莓强势主导、宋暖阳鹌鹑、小龟不露脸皮套及男性游戏化身，哈尼特点待补。仅记录方向，未生图，未确定其他成员种族 | 用户补充与文字整理 |

## 参考与范围

- [《战场兄弟》官方角色美术说明](https://battlebrothersgame.com/dev-blog-5-concept-art-explaining-battle-brothers-character-art-style/)：夸张五官、半身棋子、小尺寸可读性。
- [《战场兄弟》官方人物分层说明](https://battlebrothersgame.com/dev-blog-33-character-generation-hiring-shopping/)：头部和装备的组合方式。
- [世嘉《光明力量 II》官方角色介绍](https://vc.sega.jp/vc_shiningforce2/character.html)：多种族群像的参考。
- [旧素材索引](legacy-asset-index.md)：用于查找已有素材，不自动确定新版造型。
- [当前人物名单](../design/character-roster.md)：人物范围与现实身份记录。

本文件里的种族、职业和性格表现属于游戏创作，不当作真实人物的身份或心理事实。文字提示词无法保证所有生成结果自动符合原版，后续仍需逐项视觉核验。概念母图全部保留，新版分层资源与接入代码见游戏美术 v1；没有自动替换游戏安装目录内的文件，实机验收尚未完成。
