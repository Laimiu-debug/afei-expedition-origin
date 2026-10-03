# Afei Expedition

阿飞主题的《战场兄弟》独立公司起源项目，目标环境为 PC 原版与官方 DLC。

**v0.29.0-preview.13 已发布官网，已安装本机**：修正黑潮只显示在左上角的全屏尺寸问题。黑潮层移到文档根层，抵消原版UI缩放，按实际屏幕像素定尺寸并校准显示边界；不同窗口和UI比例下横扫与淡黑均覆盖屏幕四边。真实浏览器下4种分辨率、5种缩放共20组画面及实时改尺寸检查通过，新增原生CEF实机复测仍待完成。保持preview.12的横扫方向和全部玩法。153份脚本、46,664条离线断言和334个包条目检查通过。[官网下载](https://bbmod.com/files/f3bd9a09-c0c4-47ff-a902-cafcbae2dd65/download/) · [GitHub版本](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.0-preview.13)。[更新说明](docs/releases/v0.29.0-preview.13.md) · [代码预览](build/dream-tide-preview.13/preview.html)。

**v0.29.0-preview.12 已发布官网与GitHub，已安装本机**：最后独白读完后，黑色浪墙带着横向潮雾从右往左刮过战场，浪头与尾流在2.4秒内扫出画面；随后梦中队员逐个倒下，阿飞最后倒下，再淡黑接入梦醒。整段约4.6秒，暂停菜单退出也能完成；输入、回合和并行AI在收尾期间暂停。包含此前火箭动画、头盔修复和分别配装。153份脚本、46,659条离线断言及Canvas方向和画面帧检查通过，新增演出仍待实机验收。[官网下载](https://bbmod.com/files/9b7812c0-1789-410a-a5e9-37451fe8a4cf/download/) · [GitHub版本](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.0-preview.12) · [本地完整包](<dist/mod_afeix_expedition v0.29.0-preview.12.zip>) · [更新说明](docs/releases/v0.29.0-preview.12.md) · [横扫动画代码预览](build/dream-tide-preview.12/preview.html)。

**v0.29.0-preview.10 本地修订版，已安装本机**：斗鱼“超级火箭”增加橙红筒身、黄铜尖头与尾焰的实际下落动画。红圈预告一回合后，镜头先聚焦落点，一枚火箭从上方落下，约0.75秒后落地，爆炸、音效与七格伤害同步。走位规避、700点实际生命与护甲伤害打断和组合技不重复重击保持原规则。包含preview.9的剧情铺垫、头盔修复和人物配装；152份脚本、46,419条离线断言和332个包文件校验通过，新增动画尚待实机验收，未发布官网。[本地完整包](<dist/mod_afeix_expedition v0.29.0-preview.10.zip>) · [更新说明](docs/releases/v0.29.0-preview.10.md)。

**v0.29.0-preview.9 本地修订版**：梦潮从狼幕开始铺垫，斗鱼幕五轮交锋后先阅读“黑旗与最后一道潮”，再倒下梦醒。修复梦中头盔在创建时显示、第一次换武器或受伤刷新后才隐藏的时序错误；默认隐藏并保留F8显示选择。十人改为各自的护甲与头盔组合，瓶队斩刀、初九钉锤及对应专精同步。150份脚本、46,298条离线断言和完整主包字节校验通过；新增流程与配装待实机体验，未发布官网。[本地完整包](<dist/mod_afeix_expedition v0.29.0-preview.9.zip>) · [更新说明](docs/releases/v0.29.0-preview.9.md)。

**v0.29.0-preview.8 已发布官网**：斗鱼保持原来的大体型，血条与圆框状态图标单独抬至头顶；梦境阿飞补电子烟，自制主动技能补充动画、音效与成功日志。血条位置、满血/半血、镜头缩放、显示开关和悬停已定向实测；150份脚本、46,218条离线断言及328个包文件校验通过。所有技能逐项实战和声音试听仍待完整验收。[官网下载](https://bbmod.com/files/6d807943-1c25-4a52-bea4-34cd52c4ceb4/download/) · [本地完整包](<dist/mod_afeix_expedition v0.29.0-preview.8.zip>) · [更新说明](docs/releases/v0.29.0-preview.8.md) · [发布记录](docs/releases/publication-0.29.0-preview.8.md)。

**v0.29.0-preview.6 梦潮结局与斗鱼调整，已发布官网**：梦境无论撤退、败战或提前击败斗鱼，都由梦潮剧情杀收束，再接回现实三人。略过也先阅读梦醒；介绍保留祭场的神秘感。斗鱼加强，并修正持续集火使它不断取消蓄力、挤掉普通攻击的循环；走位、打断与盾防仍有效。本机已安装，定向实机结果与完整对战边界见[更新说明](docs/releases/v0.29.0-preview.6.md)和[测试报告](build/douyu-balance-0.29-preview.6.json)。本版已发布官网：[官网下载](https://bbmod.com/files/a0ef0043-bd1b-4c1e-8ec7-aa70513dc735/download/) · [发布记录](docs/releases/publication-0.29.0-preview.6.md)。[本地完整主包](<dist/mod_afeix_expedition v0.29.0-preview.6.zip>)。

**v0.29.0-preview.5 历史文案调整，已累计至preview.6**：梦醒启程、F8“再赴梦潮”和祭场说明不再提前透露装备奖励，只保留背景、方位与挑战信息，让祭场的秘密留待探索。[本地完整主包](<dist/mod_afeix_expedition v0.29.0-preview.5.zip>) · [更新说明](docs/releases/v0.29.0-preview.5.md)。

**v0.29.0-preview.4 梦境入口修复，已完成定向实机验证并包含于preview.5**：修复原版初始化随机调用、装备继承字段、敌方兵种布阵数据和战术阵营底座分配四处兼容错误。新开局及原失败存档的 F8 → 再赴梦潮均能进入第一幕，十人部署、移动、攻击和菜单撤退梦醒通过；45,818条离线断言、324个包文件校验通过。原存档已按字节还原，本版未发布官网，完整四幕与现实终局仍待实机验收。[本地修复包](<dist/mod_afeix_expedition v0.29.0-preview.4.zip>) · [更新说明](docs/releases/v0.29.0-preview.4.md) · [实机报告](build/dream-entry-0.29-preview.4.json) · [实战截图](build/dream-entry-preview.4/new-campaign-battle.png)。F8继续梦境须在友好城镇旁或安全扎营处。

**v0.29.0-preview.3 梦境与现实终局试玩版，已发布至BBMOD**：开局采用原版新战团教程式的分步故事弹窗，“黑旗未满 → 三人同梦 → 黑旗初醒 → 黑旗启程”，配夜营、道路插画与三位队长头像。刀一十人全员11级、传奇配装，依次挑战蜘蛛、恐狼、林德虫与“斗鱼·深渊之主”；梦醒接回三人黑旗，自由招募组队。略过梦境也介绍现实旅程，Esc可暂时收起，F8能继续或只读回看背景。现实大陆的唯一传奇据点“梦潮祭场”需正常行军抵达，潮声背后的秘密留待亲自探索。保留《战场兄弟》美术与原版装备动作。离线检查和包校验见[预览报告](build/dream-story-0.29-preview.3.json)；公开下载与本地完整主包、源码一致；发布时仅完成离线与公开包验证，梦境入口修复见上方preview.4记录。[本地预览包](<dist/mod_afeix_expedition v0.29.0-preview.3.zip>) · [序章设计与正文编辑入口](docs/design/dream-opening.md) · [现实据点与装备](docs/design/douyu-world-and-trophies.md) · [试玩验收](docs/playtest-dream-0.29.md)。 [官网下载](https://bbmod.com/files/11748b97-53c8-4052-acf9-39f7434306ef/download/) · [更新说明](docs/releases/v0.29.0-preview.3.md) · [发布记录](docs/releases/publication-0.29.0-preview.3.md)。

**v0.28.14 已发布至 BBMOD**：撤回脸与头发拆层，恢复完整头像，默认隐藏全队头盔；旧档首次升级同步隐藏，之后手动显示/隐藏选择随存档保留，头盔防护与装备效果正常生效。[官网下载](https://bbmod.com/files/8d447823-474c-4d2e-9daa-dfea80fb0075/download/) · [完整主包](<dist/mod_afeix_expedition v0.28.14.zip>) · [更新说明](docs/releases/v0.28.14.md) · [发布记录](docs/releases/publication-0.28.14.md)。33,715条离线断言与288个包文件校验通过，公开下载与源码一致；尚未安装或完成实机验收。本次外观回退无需重开战役。

**v0.28.13 历史版本**：小龟基础生命54→69，取消赠送钢头；“缩头乌龟”25%免疫头部伤害，其余转为身体结算。当时的头发拆层已由v0.28.14撤回。[官网下载](https://bbmod.com/files/836c50e6-dc27-4b3a-8450-dfce74584d20/download/) · [完整主包](<dist/mod_afeix_expedition v0.28.13.zip>) · [更新说明](docs/releases/v0.28.13.md) · [发布记录](docs/releases/publication-0.28.13.md) · [离线戴盔对照](build/helmet-layers-20261002/review-1.png)。35,249条离线断言与290个包文件校验通过，公开下载与源码一致；尚未实机验收，首次移动停顿仍待计时定位。

**v0.28.12 已发布至 BBMOD**：精简小龟体质提示，删除旧存档说明，保留体质效果与铁匠台词。完整主包包含此前全部更新。[官网下载](https://bbmod.com/files/b6ab75df-1515-4a08-a7d3-887a7c9ff85f/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.12.zip>) · [更新说明](docs/releases/v0.28.12.md) · [发布记录](docs/releases/publication-0.28.12.md)。33,484条离线断言和287个包文件校验通过，公开下载与源码一致。

**v0.28.11 已发布至 BBMOD**：修复委托种类一直为0。后续完成并收款的非送信契约按实际类型去重累计，保留已有履约次数，旧记录缺失种类时明确提示。包含此前觉醒文案、传奇蓝光握把与酒馆交互修复。[官网下载](https://bbmod.com/files/dcf9ee57-3d77-4767-8bf4-8cdddfd1921a/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.11.zip>) · [更新说明](docs/releases/v0.28.11.md) · [发布记录](docs/releases/publication-0.28.11.md)。33,484条离线断言通过，类型统计仍待实机复测。

**v0.28.10 已发布至 BBMOD**：玄武血脉首次与后续觉醒弹窗删除属性变化介绍，保留剧情和“此后她必须完成5场未觉醒的参战胜利，才能再次激发血脉”的说明。实际强化与冷却规则保持原样。[官网下载](https://bbmod.com/files/d3459cc4-6959-4a34-a4e3-2930c233d1b6/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.10.zip>) · [更新说明](docs/releases/v0.28.10.md) · [发布记录](docs/releases/publication-0.28.10.md)。33,468条离线断言通过，弹窗仍待实机复测。

**v0.28.9 已发布至 BBMOD**：老马的垂直握把升级为**传奇双手锤**，物品图标新增蓝色底光，保留固定属性与商店5%自然补货。包含夜间酒馆F8、飞李不可仅限酒馆、Esc退出与接战卡死修复。[官网下载](https://bbmod.com/files/42daa26b-6587-4a1a-b442-a0080b11f994/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.9.zip>) · [更新说明](docs/releases/v0.28.9.md) · [发布记录](docs/releases/publication-0.28.9.md)。33,468条离线断言通过，蓝光及传奇装备仍待实机复测。

**v0.28.8 已发布至 BBMOD**：修复夜间酒馆按F8打不开名册，已进入友好城镇时使用当前界面判断，解除城外敌情对开界面的误拦截。保留Esc返回酒馆、人物栏防重叠和飞李不可仅限酒馆的规则。[官网下载](https://bbmod.com/files/a5f4f9a4-1cfa-4d3a-a620-222e96e3c038/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.8.zip>) · [更新说明](docs/releases/v0.28.8.md) · [发布记录](docs/releases/publication-0.28.8.md)。33,464条离线断言通过，夜间酒馆实机仍待复测。

**v0.28.7 已发布至 BBMOD**：飞李不可**只能在酒馆内使用**，野外、扎营与城镇其他界面均不可加点；酒馆黑旗页面新增直接入口，仍可在同页连续点击加点。保留Esc退出与接战卡死修复。[官网下载](https://bbmod.com/files/d35a345e-78b0-4431-a5d3-1844ca5a4c38/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.7.zip>) · [更新说明](docs/releases/v0.28.7.md) · [发布记录](docs/releases/publication-0.28.7.md)。酒馆交互实机验收仍待复测。

**v0.28.5 已发布至 BBMOD**：修复接战后小龟弹窗检查反复抛错、阻断战斗更新的问题；黑旗名册各页支持 **Esc 直接关闭**；飞李不可选定角色后，点击属性按钮立即花费100克朗加1点，留在当前页连续操作。[官网下载](https://bbmod.com/files/d4306351-2d12-45b2-8dbf-89800cdbac9a/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.5.zip>) · [修复说明](docs/releases/v0.28.5.md) · [发布记录](docs/releases/publication-0.28.5.md)。本机已安装；实机接战及语音仍待复测。

**v0.28.4 已发布至 BBMOD**：优化全员文案、调整终局岗位平衡，新增“飞李不可”付费属性培养，修正颈部、尸体与受伤血迹，累计小龟觉醒冷却和说明弹窗。主包32,881条离线断言、287个包文件一致性校验通过；可选DLC 0.2.5同步希文文案和美术，里根儿介绍保持原样。公开下载与本地包及源码一致。[公开下载](https://bbmod.com/files/ded2ff8f-6009-4dd5-a511-e7b159458cae/download/) · [本地完整主包](<dist/mod_afeix_expedition v0.28.4.zip>) · [完整更新说明](docs/releases/v0.28.4.md) · [发布记录](docs/releases/publication-0.28.4.md)。新增玩法与美术尚未实机验收，请新开战役。

**飞李不可**：先进入城镇的**酒馆**，在酒馆黑旗页面选择“飞李不可”；也可在酒馆内 **F8 → 战团事务 → 飞李不可**。选择在队角色，点击属性按钮立即支付 **100 克朗**并永久增加 **1 点基础属性**。页面显示余额和属性变化，可在同页连续加点；双攻、双防在后四项属性，按 Esc 退出。野外和扎营均不可用。[玩家用法与验证](docs/design/attribute-treatment.md)。

v0.28.3 更新（已累计至 v0.28.4）：**玄武血脉觉醒后，小龟须再完成5场未觉醒的参战胜利才能再次触发**；新增暂停战斗的属性说明弹窗，首次、第二次及后续觉醒使用不同文案，背景介绍统一使用“她”。[本地历史安装包](<dist/mod_afeix_expedition v0.28.3.zip>) · [规则与验证](docs/releases/v0.28.3.md)。尚未实机验收。

v0.28.2 已发布至 BBMOD：**候选首次停留4日、重逢2日，新面孔优先并照顾等待较久的回流成员**。同批达标按解锁日期排序，单个人物生成失败不再挡住后续候选；包含网站 v0.27.6 之后的招募日期、独立随机来客、握把穿甲与美术、四派称号全部更新。30,038 条离线断言通过，公开下载与本地包及 284 个源码文件一致。[公开下载](https://bbmod.com/files/b0d85f1f-88be-414e-99fd-d16017970516/download/) · [本地安装包](<dist/mod_afeix_expedition v0.28.2.zip>) · [队列规则与验证](docs/releases/v0.28.2.md) · [发布记录](docs/releases/publication-0.28.2.md)。

v0.28.1 本地修复：**老马的垂直握把70%穿甲接入实际攻击**。猛击使用70%，无额外修正时提示最多98点无视护甲；横扫保留原版低10个百分点的区别，使用60%。[本地安装包](<dist/mod_afeix_expedition v0.28.1.zip>) · [修复说明](docs/releases/v0.28.1.md)。

v0.28.0 本地更新：**刀一前10天补员，刀二和飞团整体提前6天；宋暖阳第16日起、小龟全流程随机相遇**。来客各有独立位置与第5次有效抽取保底；常规队列优先新面孔。[本地安装包](<dist/mod_afeix_expedition v0.28.0.zip>) · [规则与验证](docs/releases/v0.28.0.md)。

v0.27.10 本地更新：**老马的垂直握把持握显示放大50%**，围绕握柄位置缩放，普通／染血状态同步；保留朝向及28,888克朗基础价值。[本地安装包](<dist/mod_afeix_expedition v0.27.10.zip>) · [改动与验证](docs/releases/v0.27.10.md)。

v0.27.9 本地更新：**老马的垂直握把基础价值改为28,888克朗**，马头调整为朝向角色前方，物品图标与普通／染血持握资源同步。[本地安装包](<dist/mod_afeix_expedition v0.27.9.zip>) · [改动与验证](docs/releases/v0.27.9.md)。

v0.27.8 本地更新：**小酒瓶第5日起、基准850克朗；李李超欧第12日起、基准460克朗**。两人的参战、有效契约、聚落和等级门槛已配套调整，全部达标后进入原有候选队列。[本地安装包](<dist/mod_afeix_expedition v0.27.8.zip>) · [条件与验证](docs/releases/v0.27.8.md)。

v0.27.7 本地更新：阿飞起源中新生成且没有称号的普通人物，随机冠名 **保飞派／倒飞派／儿飞派／曹飞派**，各 25%。已有称号及专属人物称号保留。[本地安装包](<dist/mod_afeix_expedition v0.27.7.zip>) · [规则与验证](docs/releases/v0.27.7.md)。

v0.27.6 已发布至 BBMOD：实机复现并修复“被网敌人挣脱失败后，断头击杀未戴头盔伙伴导致崩溃”；修复后死亡、掉落、AI 解网和第 2 回合均正常。减少开局出生点重复寻路，配套 DLC 0.2.4 将里根儿介绍中的“老动物园”改为“动物园”。主包 29,739 条、DLC 5,612 条离线断言通过；大地图停顿尚无实机耗时对照。[主包下载](https://bbmod.com/files/c6947252-4944-47ae-8a19-486a4ce4572d/download/) · [处理与验证](docs/releases/v0.27.6.md) · [发布记录](docs/releases/publication-0.27.6.md)。

v0.27.5 已发布至 BBMOD：修复清理随机特质时误删人物背景，恢复背景图标、身份介绍与正常背景工资计算。固定特质和表格数值保持既定设置，**请替换主包并新开战役**。[主包下载](https://bbmod.com/files/553f6536-30b0-4671-938b-ce134c2a91dd/download/) · [更新说明](docs/releases/v0.27.5.md)。

v0.27.4 已发布至 BBMOD：**老马的垂直握把**按指定固定为84～120伤害、70%穿甲、235%破甲、52破盾；保留单体追加削甲30和曹飞派领袖化身介绍。包含网站 v0.25.0 之后的人物平衡、特质、招募、技能与事件更新，**请新开战役**。[主包下载](https://bbmod.com/files/1fb0335a-8c51-4ca1-aa96-edc206bc1ec9/download/) · [本地包](<dist/mod_afeix_expedition v0.27.4.ZIP>) · [更新说明](docs/releases/v0.27.4.md)。

v0.27.3 本地更新：**老马的垂直握把**加强至75～95伤害、210%破甲、单体追加削甲30，介绍改为曹飞派领袖老马的化身；原版异教徒转化已逐人核查。[主包下载](<dist/mod_afeix_expedition v0.27.3.ZIP>) · [更新说明](docs/releases/v0.27.3.md)。

v0.27.2 本地更新：宋暖阳改为高先攻轻甲刺剑手，一级 **63血 / 104疲劳 / 50决心 / 108先攻 / 55近攻 / 6近防**，先攻3星、双近各2星，固定 **快速+体弱多病**。[主包下载](<dist/mod_afeix_expedition v0.27.2.ZIP>) · [更新说明](docs/releases/v0.27.2.md)。

v0.27.1 本地更新：眼子改为后排多功能柄投，一级 **先攻90 / 近攻55 / 远攻50**，双攻各2星，固定 **忠诚+团队协作**；按表培养11级近攻85、远攻90。[主包下载](<dist/mod_afeix_expedition v0.27.1.ZIP>) · [更新说明](docs/releases/v0.27.1.md)。

v0.27.0 本地更新：小杰改为 **生命/近攻/近防各2星** 的血牛轻甲长柄构筑，按表培养11级巨像后150血、近攻90、近防37；小虎、眼子、小胖更名同步，小龟介绍添了些不显眼的细节。[主包下载](<dist/mod_afeix_expedition v0.27.0.ZIP>) · [更新说明](docs/releases/v0.27.0.md)。

v0.26.4 本地更新：小酒瓶 **步伐稳健+坚定**，可可 **肥胖+巨大**，余初九 **忠诚+犹豫**，小月牙 **贪吃+乐观**。一级八维保持总表值；修正肥胖疲劳基础反推，贪吃食品支出同步。[主包下载](<dist/mod_afeix_expedition v0.26.4.ZIP>) · [更新说明](docs/releases/v0.26.4.md)。

v0.26.3 本地更新：小酒瓶初始近战命中 **53→60**；总表与源码同步，近攻三星，按表培养含剧情分支一时11级近攻均值98。[主包下载](<dist/mod_afeix_expedition v0.26.3.ZIP>) · [更新说明](docs/releases/v0.26.3.md)。

v0.26.2 本地更新：重甲压力配装的壮实后缓冲目标改为 **55**，调整6人的基础属性与30项培养分配；阿飞取消额外逐级耐力，按普通培养仍达11级裸疲劳均值124。小酒瓶同样取消额外等级加成，决心三星转给疲劳，普通培养11级均值127。希文第35日起满足全部门槛入池，2级基础报价590。修正阶段补级上限与路线事件解锁。**以后每次打包更新均按新建战役验收，不承诺旧档迁移。** [主包](<dist/mod_afeix_expedition v0.26.2.ZIP>) · [希文与里根DLC 0.2.1](<dlc/xiwen-regen/dist/mod_afeix_dlc_xiwen_regen v0.2.1.zip>) · [完整说明](docs/releases/v0.26.2.md)。

历史：v0.26.1 本地更新：小酒瓶增加逐级远征耐力，2～11级每级+3，11级裸疲劳 **127**，装备负重另扣；旧档自动补上且不会重复叠加。[下载主包](<dist/mod_afeix_expedition v0.26.1.ZIP>) · [更新说明](docs/releases/v0.26.1.md)。

v0.26.0 本地平衡版（2026-09-29）：已按 V2 总表接入 35 人属性、固定原版特质、招募节奏与技能规则（主包 34 人，希文使用独立 DLC 0.2.0）。阿飞 11 级裸疲劳上限 124；希文本体决心 21，随身圆圆化妆镜 +20，7 级技能书三选一、11 级精通。主包通过 27,778 条离线断言，尚未实机验收。下载 [主包](<dist/mod_afeix_expedition v0.26.0.ZIP>)、[希文与里根 DLC](<dlc/xiwen-regen/dist/mod_afeix_dlc_xiwen_regen v0.2.0.ZIP>)，详见[改动、旧档迁移与安装说明](docs/releases/v0.26.0.md)。

v0.25.1 本地修复（2026-09-29，尚未发布）：修复在黑旗名册确认研习后仍显示“待选择”，以及同一人物引用问题导致专属技能失效、11 级精通失效的问题。读取存档中已有选择，保留成长剧情与研习的独立规则。蛤妈离队流程已补充从学习技能、个人成长、剧情发现到确认离队的离线检查，触发条件见[修复与安装说明](docs/releases/v0.25.1.md)。

v0.25.0 更新（2026-09-29，已发布至 BBMOD）：战团事务中可从任意自定义旗帜切回建团时所选旗帜，并可隐藏／显示全队头盔，设置随存档保存。已安装早先 v0.25.0 的玩家需重新下载覆盖。保留随机事件异常阻塞野心完成的修复、五款蛤蟆专属旗帜（含电子烟足球款与黄金天使蛙）、“老马的垂直握把”在友好集市和武器店自然补货各 5% 的出现概率，以及最多 12 人出战、40 人名册。食尸鬼战斗闪退尚未复现或确认修复。见[本轮处理与验证](docs/playtest-0.25.md)、[安装说明](docs/releases/v0.25.0.md)。

v0.24.0 名单更正（2026-09-28）：删除陈知含后共 **34 人**；宋暖阳和溺水小龟归为“旅途来客”，原旅途来客其余七人、九月联动六人及奶盖合并为 **0.5DFW猪团（14 人）**。刀一 10 人、刀二 8 人不变，详见[制作名单](docs/design/character-roster.md)。陈知含的角色、剧情、技能与游戏资源直接移除，不保留旧档兼容；其余人的独立招募条件不变。罗一可与眼子哥的[完整剧情](docs/design/blue-team-stories.md)和[新头像](build/blue-team-stories/portraits-review.png)已随本版发布至 BBMOD。

文案修订：[酒馆、信件与留言](docs/playtest-tavern-text.md)。六段相遇与回应已改用具体对话，保留现有触发顺序和奖励，已随 v0.22.0 发布。

公开下载：[BBMOD v0.29.0-preview.3 试玩版](https://bbmod.com/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/) · [直接下载ZIP](https://bbmod.com/files/11748b97-53c8-4052-acf9-39f7434306ef/download/) · [安装与更新说明](docs/releases/v0.29.0-preview.3.md) · [网站发布记录](docs/releases/publication-0.29.0-preview.3.md)。[GitHub Release](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.16.1) 暂仍为v0.16.1。

独立扩展：[希文与里根儿 DLC 0.2.5](https://bbmod.com/mods/247b829d-8aa8-4898-a6dd-8b933c9ff1e9/) · [下载 DLC .zip](https://bbmod.com/files/76341887-9c0c-4a58-aaf7-fd2ef7f478ac/download/)。战犬里根儿随黑旗启程，怀念在环世界动物园与飞碟共度的日子。开局在队伍仓库查看，战前给一名队员装备即可释放。需与主包一起安装并新开战役；希文第35日起满足全部门槛后进入招募队列。见[DLC 安装说明](dlc/xiwen-regen/README.md)。

整合 DLC 已发布：[阿飞衣橱与哇哇叫 0.1.0](https://bbmod.com/mods/e554fc31-28b0-4b26-a8f5-295141ed79ef/) · [官网下载](https://bbmod.com/files/a0cec096-c0c4-4314-9f75-819dc445d629/download/) · [安装说明](dlc/afei-bundle/README.md) · [发布与下架记录](docs/releases/publication-dlc-afei-bundle-0.1.0.md)。一个 ZIP 同时包含六套外观、两张战败 CG 与五段音量增强版受伤原声。使用整合包时移走原独立皮肤和语音包；需要主包 v0.28.12 或更新版，已对 v0.28.14 两种加载顺序各通过5,108条离线组合断言。公开下载与本地包及组件资源一致，尚未实机验收。

原独立语音 DLC 已于 2026-10-02 下架，其 0.1.0、0.1.2 公开页面与下载均已撤回；独立皮肤包从未上架。请使用上面的整合 DLC，旧语音源码和试听保留在[原声记录](dlc/afei-voice/README.md)。

打包命名：后续分发压缩包均带版本号，**主包、DLC 和素材包的文件后缀统一使用小写 `.zip`**。保留已审阅美术直接打包时，先更新根目录 `VERSION`，运行 `python tools/check_gameplay.py`，通过后运行 `python tools/package_verified_gameplay.py`，生成 `dist/mod_afeix_expedition v<版本>.zip` 和同名 `.sha256`；`tools/build_gameplay.py` 用于需要重新生成资源的构建。安装时将带版本号的 ZIP 直接放入游戏 `data` 目录，并移走此前的本 Mod 旧包。五款旗帜已集成，世界地图按 F8 → 战团事务 → 更换旗帜。

当前本地工作区与安装主包为 **v0.29.0-preview.9**；本次未发布官网，历史公开包见上方preview.8发布记录。配套可选DLC为 **0.2.5**。梦境开局按新建战役验收；旧档可主动回看，并在安全世界更新时生成或复用现实祭场。完整头像回退与默认隐藏头盔见[v0.28.14说明](docs/releases/v0.28.14.md)和[发布记录](docs/releases/publication-0.28.14.md)。退出游戏后再安装新版主包。保留此前候选轮换、握把穿甲修复与招募时间表。本版新增流程与配装尚未实机战役验收；v0.27.6 的网后断头崩溃曾实机复现并复测至下一回合，完整战役与大地图帧耗时仍待验收。保留 v0.23.2 的解网后技能回调修复：[修复与验证](docs/playtest-0.23.2.md)。

保留 v0.23.1 的招募属性显示 Mod（`mod_fox_043`）兼容修复，解决人物已解锁却不生成的问题，保留属性显示功能。当前主题招募有3个常规位置和2个独立随机来客位置；常规位置在雇佣后间隔1个游戏日补人，首次展示4日、重逢2日。普通中立村庄也能招募，入口为原版雇佣新兵的人物列表；修正空佣兵池隐藏招募入口，以及额外送信干扰普通契约供给的问题。[招募更新](docs/playtest-0.23.md) · [全部解锁条件](docs/design/recruit-unlocks.md)。

v0.22 的大地图阿飞图标继续保留，支持左右转向，保留原版扎营和战团旗帜。[大地图预览](build/playtest-world-afei/comparison-3x.png) · [版本说明](docs/playtest-0.22.md)。

v0.21 的战死与结局更新继续保留：修复专属人物战死后只剩横放胸像的问题，保留原版倒地躯干、护甲与头盔；包含 **8 种战团主结局、当前 34 人各自的两种退隐后续与阵亡纪念，以及路线／六根／自行车回应**。已接入退隐、败亡界面。[版本与验证](docs/playtest-0.21.md) · [结局全文](docs/design/company-endings.md) · [战死新旧离线对照](build/playtest-corpses/comparison.png)。离线测试通过，实机画面尚待验收。

v0.20.0 在 v0.19.1 基础上新增 **10 个可重复随机事件、30 个选项及独立后续**，包括四派新相遇、抹茶查账、小月牙收零件、小宁与老蔡看地图、小龟下棋、帅子与小胖徐练舞、宋暖阳记事。指定人物须存活在队，按行军／营地／城镇条件抽选，沿用 1.5 天共享间隔，单事件冷却 8～10 天。[完整对白（32 段、75 个选项）](docs/design/encounter-dialogues.md) · [新增事件与验证](docs/playtest-0.20.md)。

原有四派事件、刘青松的两段相遇（不可招募）、传奇武器“老马的垂直握把”、小龟禁戴头盔／厚壳／天生钢头，以及六根、路线和小酒瓶的回应继续保留。[v0.19 规则与验证](docs/playtest-0.19.md) · [头像与红装预览](art/runtime/ideas-v19/preview.png)。

当前平衡以 [V2 总表](docs/design/balance-v2/全人物数值与招募总表.xlsx) 为准，主包 33 名伙伴各有 **7 级专属技能三选一、11 级自动精通**，眼子哥已补齐三项技能；阿飞采用独立晋升。安装 DLC 后再增加希文三项技能。原 v0.18 参数仅保留作[历史记录](docs/playtest-0.18.md)。查看[现行技能表](docs/design/member-skills.md)、[属性与固定特质表](docs/design/character-stats.md)。

- [历史本地修复包 v0.25.2](<dist/mod_afeix_expedition v0.25.2.ZIP>)修复人物栏按 F8 后无法退出，见[修复与安装说明](docs/releases/v0.25.2.md)；保留[v0.16.1 F8 修复和验证](docs/playtest-0.16.1.md)：34 人、最多 40 人在册，自选 1～12 人出战。[v0.16 队伍强度与开局资源](docs/playtest-0.16.md)、[v0.15 技能接入](docs/playtest-0.15.md)、[v0.13 天赋说明](docs/playtest-0.13.md)、[v0.12 美术说明](docs/playtest-0.12.md)、[五人更新预览](build/playtest-neck/five-member-preview.png)与[全员颈部图层对照](build/playtest-neck/index.html)保留。
- 瑶瑶牙已换成遮肩遮胸的米白素衣，试玩包与本机安装包已同步：[新版源图](art/runtime/portraits-v05/sources/user-v23/yaoyaoya.png) · [新旧与装备对照](build/playtest-yaoyaoya/comparison.png)。离线检查通过，尚未实机验收。
- 可可已按[两张本人照片](art/references/2026-09-27-keke/README.md)重绘：[新版源图](art/runtime/portraits-v05/sources/user-v17/keke-photo-v2.png) · [新旧与装备对照](build/playtest-keke/comparison.png)。
- 溺水小龟已按[两张吉祥物参考](art/references/2026-09-27-xiaogui/README.md)优化为亮粉蝴蝶结、浅绿圆脸和奶黄腹甲：[新版源图](art/runtime/portraits-v05/sources/user-v17/xiaogui.png) · [新旧与装备对照](build/playtest-xiaogui/comparison.png)。
- [v0.11 历史审阅存档](dist/saves/afeix_all_34_v11.sav)：保留当时的 34 人与测试补给记录；不适用于 v0.24.0 当前名单，当前版本请新开战役。
- [全部 34 人的解锁条件表](docs/design/recruit-unlocks.md)：从实际运行数据生成，包含刷新间隔、排队和送信规则；供作者审阅，不在游戏里公布。
- [历史照片／旧稿对照](art/runtime/portraits-v05/review/likeness.html)、[全员资源](art/runtime/portraits-v05/README.md)、[实际生图提示词 MD](art/runtime/portraits-v05/PROMPTS.md)与[当前游戏尺寸预览](art/runtime/portraits-v05/build/index.html)。[本轮五人参考](art/references/2026-09-27-user/README.md)已补齐此前缺图成员；美伢已按新增的[四张照片](art/references/2026-09-27-meiya/README.md)优化，[新旧与装备对照](build/playtest-meiya/comparison.png)可直接查看。[历史照片来源与待补项](art/references/2026-09-26-likeness/README.md)和[v0.11 备份包](dist/archive/v0.11/mod_afeix_expedition.zip)保留。
- [v0.3 玩法规则](docs/playtest-0.3.md)与[技能图标记录](art/runtime/gameplay-v03/README.md)：成长、转职、六根与自行车规则保留；其中原版脸与衣装分层的旧美术方案已被 v0.4 取代。
- [34 人配置与相遇清单](docs/design/member-implementation.md)：各人的起步方向、招募费用、装备、天赋与旧相遇剧本存稿；[机器可读数据](build/characters.json)从真实入口导出。
- [旧技能与图标沿用审阅](docs/design/legacy-skills-reuse.md)与[历史图册](build/legacy-skills-review/index.html)：97 项旧设计、91 张专属图标，保留迁移前的逐人评估；当前接入状态以[现行技能表](docs/design/member-skills.md)为准。
- [源码](src/)、[行为测试](tests/gameplay/)、[离线构建验证记录](build/gameplay-validation.json)：离线检查与定向实机记录分开保存，各版实机范围见对应试玩记录。

已确定的玩法方向：从逐渐扩大的成员池中自由编队，单支队伍后期最多 12 人出战，其他已招募伙伴待命。

- [奇思妙想与灵感手记](docs/design/idea-journal.md)：原始构想、当前实现与制作顺序。已补齐[四派 8 事件首稿](docs/design/faction-events.md)、[传奇儿飞派刘青松](docs/design/liu-qingsong.md)及[传奇老马的垂直握把](docs/design/laoma-vertical-grip.md)的剧情和数值；新增内容已接入 v0.19，实机验收范围见版本记录。
- [玩法与剧情制作蓝图](docs/design/mod-blueprint.md)：核心玩法、首条内容链、人物规模与分阶段验收。
- [阿飞分支转职](docs/design/afei-promotion.md)：正常形态起步，蛤蟆人与嘉豪两条路线；六根开启后解锁飞碟，后期可付费重修。
- [水友四派与六根](docs/design/supporter-factions.md)：保飞派、儿飞派、曹飞派、倒飞派；六位指定人物的隐藏支线触发后解锁飞碟。新增四派随机事件、传奇儿飞派刘青松及传奇武器“老马的垂直握把”已记入[灵感手记](docs/design/idea-journal.md)，已接入 v0.19。
- [游戏与 Mod 制作研究](docs/research/battle-brothers-modding.md)：本机版本核对、原版机制、技术工具与来源。
- [其他起源的人物美术做法](docs/research/origin-art-pipeline.md)：原版、Fate 样本、非人类 Mod 的分层方式，以及阿飞的共用模板与装备适配建议。
- [旧项目审阅与复用建议](docs/research/legacy-project-review.md)：I 盘旧工程中可以延续的代码和需要调整的规则。
- [旧素材索引](docs/art/legacy-asset-index.md)与[完整归档](legacy/2026-09-25-afei-expedition/README.md)：立绘、图标、图集、母图、参考照及人物编号对应。
- [34 人制作名单](docs/design/character-roster.md)：当前人物范围。
- [人物造型讨论与生图提示词](docs/art/character-art-prompts.md)：当前美术主记录；已有阿飞正常形态与蛤蟆人候选图，三形态与飞碟资源进度见 [阿飞美术目录](art/character-concepts/afei/README.md)。
- [阿飞分层游戏美术 v1](art/runtime/afei/v1/README.md)：头、身体、伤痕、倒地、独立飞碟与美术测试起源；格式与静态检查通过，头颈和倒地组合仍需修正，尚未实机验收。
- [34 人故事梗概](docs/design/character-stories.md)：按个人特点重写的当前故事主文档，区分用户确认、旧稿母题与原创提案；长线情节不等于已经实现。
- [34 人专属背景设计](docs/design/character-backgrounds.md)：逐人的出身、习惯与成长主题，以及异教徒转化后继续个人路线的规则；v0.20.1 已接入背景、转化文案和旧档迁移，实机验收待补。
- [旧人物侧写](docs/design/character-profiles.md)：保留当时 35 人版本，已由新版故事文档取代；眼子哥已于 2026-09-28 恢复，见现行制作名单。[旧画像提示词](docs/art/portrait-prompts.md)已停用。

剧情草稿用于提供场面与语气；实际玩法和任务实施以制作蓝图及后续详细规格为准。

旧项目完整归档 `legacy/2026-09-25-afei-expedition/original-project.zip` 使用 Git LFS 保存。克隆后如仅取得指针文件，请安装 Git LFS 并运行 `git lfs pull` 下载完整压缩包；归档校验值见其目录内的 README。
