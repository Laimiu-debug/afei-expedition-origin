# Afei Expedition

阿飞主题的《战场兄弟》独立公司起源项目，目标环境为 PC 原版与官方 DLC。

公开下载：[BBMOD 网站](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/) · [GitHub v0.16.1 试玩版](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.16.1) · [安装说明](docs/releases/v0.16.1.md)。

当前为 v0.16.1：修复世界地图附近有非友方队伍时 F8 名册被原版随机事件条件拦截的问题；允许查看，确认编队等操作仍要求安全地点。已在同一旧档复现旧包故障，并实测修复包打开、关闭和再次打开。沿用 v0.16 的十人队伍强度上限及高／中／低初始资金设置。33 名伙伴的 99 项技能与阿飞独立转职沿用；入队开放两项，个人成长解锁第三项。[全员技能表](docs/design/member-skills.md)和[图册](build/member-skills/index.html)由运行数据生成。未知人物与隐藏支线仍由玩家探索。首战结算、技能实际施放和长期平衡仍待验收。

- [当前试玩包](dist/mod_afeix_expedition.zip)与[v0.16.1 F8 修复和验证](docs/playtest-0.16.1.md)：34 人、最多 40 人在册，自选 1～10 人出战。[v0.16 队伍强度与开局资源](docs/playtest-0.16.md)、[v0.15 技能接入](docs/playtest-0.15.md)、[v0.13 天赋说明](docs/playtest-0.13.md)、[v0.12 美术说明](docs/playtest-0.12.md)、[五人更新预览](build/playtest-neck/five-member-preview.png)与[全员颈部图层对照](build/playtest-neck/index.html)保留。
- [34 人审阅存档](dist/saves/afeix_all_34_v11.sav)：游戏“读取战役”中选择“阿飞全员审阅 · 34人 · 自行车与电子烟”。全员正常 1 级，附测试补给；已验证读档、人物栏和预备队滚动，电子烟实战回血仍待验证。
- [全部 34 人的解锁条件表](docs/design/recruit-unlocks.md)：从实际运行数据生成，包含刷新间隔、排队和送信规则；供作者审阅，不在游戏里公布。
- [历史照片／旧稿对照](art/runtime/portraits-v05/review/likeness.html)、[全员资源](art/runtime/portraits-v05/README.md)、[实际生图提示词 MD](art/runtime/portraits-v05/PROMPTS.md)与[当前游戏尺寸预览](art/runtime/portraits-v05/build/index.html)。[本轮五人参考](art/references/2026-09-27-user/README.md)已补齐此前缺图成员；[历史照片来源与待补项](art/references/2026-09-26-likeness/README.md)和[v0.11 备份包](dist/archive/v0.11/mod_afeix_expedition.zip)保留。
- [v0.3 玩法规则](docs/playtest-0.3.md)与[技能图标记录](art/runtime/gameplay-v03/README.md)：成长、转职、六根与自行车规则保留；其中原版脸与衣装分层的旧美术方案已被 v0.4 取代。
- [34 人配置与相遇清单](docs/design/member-implementation.md)：各人的起步方向、招募费用、装备、天赋与旧相遇剧本存稿；[机器可读数据](build/characters.json)从真实入口导出。
- [旧技能与图标沿用审阅](docs/design/legacy-skills-reuse.md)与[历史图册](build/legacy-skills-review/index.html)：97 项旧设计、91 张专属图标，保留迁移前的逐人评估；当前接入状态以[现行技能表](docs/design/member-skills.md)为准。
- [源码](src/)、[行为测试](tests/gameplay/)、[离线构建验证记录](build/gameplay-validation.json)：离线检查与定向实机记录分开保存，各版实机范围见对应试玩记录。

已确定的玩法方向：从逐渐扩大的成员池中自由编队，单支队伍后期最多 10 人出战，其他已招募伙伴待命。

- [奇思妙想与灵感手记](docs/design/idea-journal.md)：集中记录原始构想、已确认方向、待讨论问题与相关设计，后续持续补充。
- [玩法与剧情制作蓝图](docs/design/mod-blueprint.md)：核心玩法、首条内容链、人物规模与分阶段验收。
- [阿飞分支转职](docs/design/afei-promotion.md)：正常形态起步，蛤蟆人与嘉豪两条路线；六根开启后解锁飞碟，后期可付费重修。
- [水友三派与六根](docs/design/supporter-factions.md)：保飞派、儿飞派、倒飞派；六位指定人物的隐藏支线触发后解锁飞碟。
- [游戏与 Mod 制作研究](docs/research/battle-brothers-modding.md)：本机版本核对、原版机制、技术工具与来源。
- [其他起源的人物美术做法](docs/research/origin-art-pipeline.md)：原版、Fate 样本、非人类 Mod 的分层方式，以及阿飞的共用模板与装备适配建议。
- [旧项目审阅与复用建议](docs/research/legacy-project-review.md)：I 盘旧工程中可以延续的代码和需要调整的规则。
- [旧素材索引](docs/art/legacy-asset-index.md)与[完整归档](legacy/2026-09-25-afei-expedition/README.md)：立绘、图标、图集、母图、参考照及人物编号对应。
- [34 人制作名单](docs/design/character-roster.md)：当前人物范围。
- [人物造型讨论与生图提示词](docs/art/character-art-prompts.md)：当前美术主记录；已有阿飞正常形态与蛤蟆人候选图，三形态与飞碟资源进度见 [阿飞美术目录](art/character-concepts/afei/README.md)。
- [阿飞分层游戏美术 v1](art/runtime/afei/v1/README.md)：头、身体、伤痕、倒地、独立飞碟与美术测试起源；格式与静态检查通过，头颈和倒地组合仍需修正，尚未实机验收。
- [34 人故事梗概](docs/design/character-stories.md)：按个人特点重写的当前故事主文档，区分用户确认、旧稿母题与原创提案；长线情节不等于已经实现。
- [旧人物侧写](docs/design/character-profiles.md)：保留当时 35 人版本，已由新版故事文档取代；眼子已移出当前制作名单。[旧画像提示词](docs/art/portrait-prompts.md)已停用。

剧情草稿用于提供场面与语气；实际玩法和任务实施以制作蓝图及后续详细规格为准。

旧项目完整归档 `legacy/2026-09-25-afei-expedition/original-project.zip` 使用 Git LFS 保存。克隆后如仅取得指针文件，请安装 Git LFS 并运行 `git lfs pull` 下载完整压缩包；归档校验值见其目录内的 README。
