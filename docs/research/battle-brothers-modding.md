# 《战场兄弟》Mod 制作研究

核对日期：2026-09-25  
项目目标：阿飞主题的独立公司起源。用户已选择 **PC 原版《战场兄弟》＋官方 DLC**。  
配套：[阿飞 Mod 玩法与剧情蓝图](../design/mod-blueprint.md)。

后续设计决定：用户已选择单支队伍后期最多 **10 人出战**，由玩家从已招募成员中自由编队。本文中的 12 人、20 人等仍是本机原版机制核对值；项目设计以蓝图 v0.2 为准，人数限制及其平衡尚未实现或实机验证。

后续资料补充：用户提供了 `I:/afei-expedition`，其中已有 32 人物、97 技能的旧版源码及素材，现已完整归档。本文原始研究时尚未看到该目录；复用与迁移结论以[旧项目审阅](legacy-project-review.md)补充为准。旧版实际使用 Legacy Modding Script Hooks，本文的 Modern Hooks／MSU 是此前新建项目候选，不是旧版现有依赖。

## 1. 研究结论

这个项目适合做“公司起源＋命名伙伴＋个人事件与成长＋有限的团队指挥规则”。需要首先跑通新战役、招募、战斗、事件和存档之间的联系。

小说能提供语气与场面，人物侧写能提供矛盾，但玩家真正接触的是：一个起源选项、一名可招募单位、一次要付成本的选择、一个战斗按钮，以及选择之后保留下来的变化。制作文档必须同时写清这些东西。

旧 v0.6.1 稿已经包含共享号令、嘉豪成长、逐人招募、阵亡后的承接和叠加上限，值得作为设计材料继续使用。其“94 项技能、31 人、39 人总名册”等是旧稿规模与设定，**不代表已有对应代码或已验证可玩**。当前制作名单为 35 人，必须另做范围核对。

## 2. 本机核对结果

本轮只读检查游戏安装，选取 15 份原版脚本复制到临时目录解密、反编译以观察常量和接口；没有向游戏 data 写入 Mod，也没有启动游戏验证。

| 项目 | 实际发现 |
| --- | --- |
| 游戏目录 | `F:/SteamLibrary/steamapps/common/Battle Brothers` |
| 可执行文件版本 | `win32/BattleBrothers.exe` 的文件版本为 **1.5.2.3** |
| Steam 安装构建 | `appmanifest_365360.acf` 中 buildid 为 **23856902** |
| 资源包 | data_001.dat、data_003.dat、data_004.dat、data_006.dat、data_008.dat、data_010.dat |
| 主包内容 | data_001.dat 中有 9,372 个归档条目，含 3,104 个 .cnut 脚本条目 |
| DLC 标记 | 其余五包分别含 lindwurm、unhold、wildmen、desert、paladins 的 DLC 脚本 |
| 对应内容 | Lindwurm、Beasts & Exploration、Warriors of the North、Blazing Deserts、Of Flesh and Faith 的资源标记均存在 |
| 当前 Mod 包 | data 顶层未见额外 Mod ZIP；这项检查不等于验证所有文件均为未修改原版 |
| 原研究时的当前项目 | 当时只有名单、资料、人物侧写、画像提示词和小说草稿；后来提供的 I 盘旧实现已另行归档，见文首补充 |

反编译工具来自 [BBBuilder 1.6.3 的作者发行包](https://github.com/TaroEld/BBbuilder/releases/tag/1.6.3)，在临时目录使用其附带的 bbsq 与 nutcracker。原始 .cnut 必须先解密；直接反编译会失败。部分反编译结果的循环和分支重建不自然，因此**本轮用它核对常量、字段和入口，不把还原文本当成可以原样复制的实现**。

## 3. 原版真正的玩法结构

### 战役经营

玩家在程序生成的地图上接契约、招人、交易、购买装备和寻找敌人。工资、食物、工具、药品、行程与休整构成长期成本。一次伤亡的损失除了角色，还包括此前投入的装备、训练和后续赚钱能力。[官方玩法介绍](https://battlebrothersgame.com/features/)

阿飞起源的故事应依附这些行为。例如“给新人机会”可以意味着拿出一套装备、占用出战位置、承担训练期的战斗风险；“许下承诺”则应落实到工资、期限、补给或接应安排。

### 战术战斗

单位使用行动点和疲劳，在六角格上考虑地形、包围、控制区、射程、先攻、士气与武器特点。临时伤势、永久伤势与死亡影响后面的战役。武器、背景、特性与 Perk 一起构成角色，而不是固定职业决定一切。[官方玩法介绍](https://battlebrothersgame.com/features/)

因此“旗手”“突击手”“护卫”应是适配方向，仍允许玩家换武器和自行配 Perk。专属技能需要保留原有站位与培养选择。

### 公司起源

起源可以定义初始成员、装备、资源、出生条件，以及影响整场战役的规则。阿飞 Mod 应从这个入口开始。[官方起源介绍](https://battlebrothersgame.com/dev-blog-113-company-origins-part-i/)

本地 `scripts/scenarios/world/starting_scenario.cnut` 可识别的入口包括：

- `onSpawnAssets()`：初始成员和资源；
- `onSpawnPlayer()`：世界地图上的初始队伍与位置；
- `onInit()`：起源规则初始化；
- `onHired(_bro)`、`onUpdateHiringRoster(_roster)`：招募相关入口；
- `onCombatFinished()`、`onContractFinished(_contractType, _cancelled)`：战斗与契约结束入口。

这些入口已在本地脚本中识别，具体接入与成功判定仍需写原型验证。例如“契约结束”不应未经判断就当成“成功获得报酬”。

### 事件与目标

事件会依据地点、背景、成员和队伍状态提供不同选项与结果；原版的野心系统为沙盒提供中期目标。[官方事件介绍](https://battlebrothersgame.com/dev-blog-43-event-system/)、[官方野心介绍](https://battlebrothersgame.com/dev-blog-89-ambitions/)

本地事件管理器显示事件使用资格判断、权重选择和时间控制。达到成长条件不等于下一秒必然抽中对应事件。因此主线和招募需要有明确的提示入口或待处理队列；不能仅靠提高随机事件权重承诺“七日内必定出现”。

非战斗随从 Retinue 是另一套公司加成系统。它可作为长期经营的参照，但不能直接替代“把可战斗的具名伙伴存入营地、以后再调出”的需求。[官方随从介绍](https://battlebrothersgame.com/dev-blog-127-the-retinue-part-i/)

## 4. 从本机脚本核实的具体边界

以下为该安装版本的可识别默认值，不是所有起源、特性与 Mod 环境都通用的绝对上限。

| 项目 | 发现 | 本地归档内依据 |
| --- | --- | --- |
| 普通名册 | 默认 20 人 | scripts/states/world/asset_manager.cnut：BrothersMax |
| 普通出战人数 | 默认 12 人 | 同上：BrothersMaxInCombat |
| 规模计算参数 | 默认 BrothersScaleMax 为 12 | 同上；完整难度公式未在本轮逐项审计 |
| 民兵起源 | 名册 25、出战 16、规模参数 14 | scripts/scenarios/world/militia_scenario.cnut：onInit |
| 普通玩家单位 | 基础行动点 9 | scripts/entity/tactical/player.cnut：初始化 |
| 基础疲劳恢复 | 属性默认值 15 | scripts/config/character.cnut：FatigueRecoveryRate |
| 常规升级 Perk 节点 | MaxLevelWithPerkpoints 为 11 | scripts/config/character.cnut |
| Rally | 基础成本 5 AP、25 疲劳；效果范围在逻辑与提示中为 4 格 | scripts/skills/actives/rally_the_troops.cnut |
| Footwork | 基础成本 3 AP、20 疲劳；有控制区、定身与目标格检查 | scripts/skills/actives/footwork.cnut |
| 孤狼死亡条件 | onCombatFinished 检查主角是否仍在名册，据此返回结果 | scripts/scenarios/world/lone_wolf_scenario.cnut |
| 事件招人 | 原版邪教招募事件有起源检查、容量检查与创建玩家角色的流程 | scripts/events/events/dlc4/cultist_origin_flock_event.cnut |
| 事件自身存档 | 事件基类默认序列化冷却时间 | scripts/events/event.cnut：onSerialize/onDeserialize |

这产生几个直接的制作决定：

1. 35 名可招募人物、同时受雇人数和战场人数必须分开定义。
2. 号令不能随意返还 AP，否则会改变武器行动次数与原版回合经济。
3. “增加决心”与“恢复当前士气等级”必须分清。旧稿的哇哇叫可以定位为预防崩溃，原版 Rally 仍承担恢复士气的用途。
4. 紧急脱身要借鉴 Footwork 的合法格与定身检查，不能只移动坐标。
5. 阿飞死后若允许公司继续，不能直接沿用孤狼的结束条件。
6. 自定义事件里的招募状态、成长完成状态不会因为写进普通字段就自动得到可靠存档，必须设计持久化。

官方早期开发博客里的数字可能是开发中方案。例如 2019 年民兵介绍曾写 18 人出战，本机脚本为 16。设计理念可参考开发日志，数值与接口要以目标版本核实。

## 5. 实现技术与工具

### 代码与资源

游戏主体规则位于 Squirrel 脚本，源文件为 .nut，归档中通常是 .cnut。界面使用 HTML、CSS、JavaScript。UI 图标与角色精灵使用不同的资源组织方式。[原版文件结构说明](https://bbmodding.enduriel.com/docs/vanilla-files/)

此前按新建项目建议的模块如下。这是**拟定目录**，不代表后来找到的旧工程结构；旧实现实际集中在 `scripts/mods/afei` 等目录，迁移时先核对后者：

```text
scripts/!mods_preload/mod_afei_expedition.nut
scripts/scenarios/world/afei_expedition_scenario.nut
scripts/events/events/afei_*.nut
scripts/contracts/contracts/afei_*.nut
scripts/skills/actives/afei_*.nut
scripts/skills/effects/afei_*.nut
scripts/skills/traits/afei_*.nut
mod_afei_expedition/
    character_registry.nut
    recruitment.nut
    progression.nut
    command_budget.nut
    persistence.nut
gfx/
brushes/
ui/mods/mod_afei_expedition/
```

新增起源继承原版起源基类，使用独立 ID；修改共享规则时使用 Hook，避免整份覆盖公共文件。[起源示例](https://bbmodding.enduriel.com/docs/mod-examples/origin-mod/)、[Modern Hooks 文档](https://bbmodding.enduriel.com/docs/modern-hooks/introduction/)

### 候选依赖版本

| 组件 | 本轮查到的正式发行版 | 用途与状态 |
| --- | --- | --- |
| Modern Hooks | 0.6.0 | 注册、依赖顺序和共享类扩展；未在本机加载测试 |
| MSU | 1.9.0 | 设置、技能辅助、持久化等；发行说明明确适配 1.5.2.2，本机 1.5.2.3 仍须验证 |
| BBBuilder | 1.6.3 | 构建、语法检查、精灵打包和开发辅助；本轮只使用发行包内的脚本读取工具 |

来源：[Modern Hooks 0.6.0](https://github.com/MSUTeam/Modern-Hooks/releases/tag/0.6.0)、[MSU 1.9.0](https://github.com/MSUTeam/MSU/releases/tag/1.9.0)、[BBBuilder 1.6.3](https://github.com/TaroEld/BBbuilder/releases/tag/1.6.3)。

Modern Hooks 与 MSU 是基础库，不等于采用 Legends 或 Reforged。一个只增加简单起源的 Mod 可以不需要整套库；本项目如果保留成长记录、共享号令、设置和营地，采用有文档的基础库更合适。最终依赖清单由最小原型验证后锁定。

不要照抄旧教程中已经变化的构建命令。BBBuilder 当前 README 提供 extract-basegame、build 等流程，也有构建后复制到游戏目录的功能；开发时应明确输出位置和是否部署。[BBBuilder 作者说明](https://github.com/TaroEld/BBbuilder)

### 存档是核心工程

至少需要保存：

- 人物固定 ID、是否已见过、已招募、死亡或永久离开；
- 招募线索与暂缓状态；
- 每人的成长条件进度与奖励领取状态；
- 阿飞已获得成长奖励的人物集合；
- 主线阶段、分支、历史成员记录；
- 存档结构版本；
- 如果做驻营，还包括伙伴本体、装备、经验、伤势、工资状态和回归位置。

可以使用世界／角色 Flags 及 MSU 的序列化设施。跨战役共享数据与单个战役状态要分开；不能因为存在通用持久化功能，就把某一局的成长写成所有新局共有。[MSU 序列化说明](https://github.com/MSUTeam/MSU/wiki/Serialization)

同一事件反复打开、读档、等待、撤退和重新入队，都不能重复发奖励。显示名不是身份 ID；例如老蔡、川神、陈彦川只能指向同一个人物记录。

## 6. 美术与中文

之前的画像提示词可用于确定脸和气质，不能直接当作全部游戏美术已经齐全。

实际至少涉及：

- 脸、头发及必要的身体层；女性角色需要检查默认身体与头盔适配；
- 与原版护甲、头盔、伤势、尸体显示的组合；
- 战场、角色面板与行动顺序栏中的尺寸和锚点；
- 技能正常／禁用图标、成长特性图标；
- 起源图、事件插画、团旗及其他必要 UI 素材；
- 精灵图集和 .brush 定义。

把“脸＋衣服＋装备”画成一张固定图，会在换甲、戴盔和伤势显示时造成错位或覆盖。应先完成一名角色的全流程适配，再批量做 35 人。[精灵与 Brushes 说明](https://bbmodding.enduriel.com/docs/concepts/brushes/)

Steam 商店当前列出的官方界面语言为英语。中文事件不仅需要 UTF-8 文本，还要验证字体、换行、提示框高度和人物名字显示。[Steam 语言信息](https://store.steampowered.com/app/365360/Battle_Brothers/)

本轮未核定具体汉化包。可选择一套验证过的汉化／字体兼容方案作为运行环境，或制作明确范围的中文字体支持；不应同时覆盖整套汉化脚本。中文显示应列入第一阶段验证，避免大量文案完成后才发现无法显示。

## 7. 工作量与优先级

“新增一个起源”本身规模可控；难度主要随着独立系统之间的交互增长。

| 工作 | 相对成本 | 容易漏掉的部分 |
| --- | --- | --- |
| 三人开局、资源、介绍页 | 低至中 | 出生位置、起源可见性、其他起源不受影响 |
| 单名伙伴招募与事件 | 中 | 满员、没钱、暂缓、死亡、重复入队 |
| 有限号令与简单属性效果 | 中 | AP／疲劳支付、待机、控制状态、结束清理 |
| 单人成长与阿飞反馈 | 中 | 真实战斗计数、重复领取、加载后恢复 |
| 原版装备兼容的真人形象 | 中 | 分层、遮挡、战场与面板一致性 |
| 35 人的角色内容 | 高，且持续累积 | 工资与技能差异、事件碰撞、资料不足 |
| 独立驻营与超过 20 人的保存 | 高 | 装备复制、实体恢复、工资、战斗规模计算 |
| 自定义推车、开门、计时守点等战术目标 | 高 | 战斗生成、胜败判定、AI、撤退与重试 |
| 94 项以上独立技能及任意组合 | 很高 | 叠加、效果顺序、可读性与测试组合 |

这不是工期承诺。实际工期取决于玩法保留量、美术完成度、是否做独立 UI、字体方案与兼容测试结果。

## 8. 第一阶段验收

只有以下流程在目标游戏中跑通，才能称为可玩的第一版：

1. 新建战役可以选择阿飞起源，三位初始人物、装备和资源正确。
2. 中文起源说明、事件、姓名和技能提示完整显示。
3. 玩家可以完成一条招募支线；没钱、满员和暂缓都有合理反馈。
4. 阿飞、抹茶与大谋各有能理解的战斗用途；阿飞弱而非毫无选择。
5. 共享号令能正确扣除，待机、控制和读档不刷新预算。
6. 一位伙伴通过实际游戏行为完成成长；阿飞只获得一次反馈。
7. 普通保存、加载、战斗中保存加载（若模式允许）、撤退、伤亡后均正常。
8. 玩家拒绝支线或失去重要人物后，仍有能够继续的战役状态。
9. 进入普通原版起源时，不触发阿飞专属事件或规则。
10. 发布包包含版本、依赖、安装位置、已知限制及测试记录。

本轮完成的是研究与设计范围梳理。尚未安装依赖、运行 Mod 或进行实机平衡测试。
