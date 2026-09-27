# 阿飞玩法 v0.3 美术接入

**v0.4 更新：**全员人物改用 [完整胸像](../portraits-v04/README.md)，不再显示原版头发、脸或装备。本目录继续提供四张技能图标和独立飞碟；旧衣装画刷保留供兼容引用，当前运行时不再显示。以下为 v0.3 历史制作记录。

本目录记录 v0.3 玩法 Mod 的有限美术范围。正常与嘉豪复用经过静态合成筛选的基础衣装；头顶飞碟使用独立图层。**原版人物头、头发、胡须、头盔、护甲、武器和盾牌保留。蛤蟆职业的技能可运行，蛤蟆头与身体本轮未接入。**

四张技能图使用内置 ImageGen 生成，原图与实际提示词保存在 [sources/](sources/)和 [generation-prompts.json](generation-prompts.json)。`tools/build_gameplay_art.py` 裁去透明余量、等比缩到 52×52 范围并置入 56×56 透明画布。禁用图暂沿用同一张原色图。

## 构建与包内路径

运行 `python tools/build_gameplay_art.py`，或从整体构建调用 `build_art()`。返回 `(paths, report)`，其中 paths 是已经写入 `src/` 的 Path 列表。默认四张生成源必须齐备，否则停止构建；开发检查可用 `--allow-missing-icons`。

- `gfx/skills/afeix_wawa.png`
- `gfx/skills/afeix_haoqi.png`
- `gfx/skills/afeix_quanqian.png`
- `gfx/skills/afeix_feidie.png`
- `gfx/afeix_gameplay_v03.png`
- `brushes/afeix_gameplay_v03.brush`

原版 `data_001.dat` 的技能文件实际位于 `gfx/skills/`，脚本的 `m.Icon` 使用 `skills/afeix_*.png`。不输出到 `gfx/ui/skills/`。

图集只包含 `afeix_g03_normal_body`、`afeix_g03_jiahao_body` 各自的常态、`_dead`、`_injured`，以及 `afeix_g03_feidie`。这些七张图片精确复用 v1 已生成导出像素，使用新 brush 名称，旧目录与旧图集未被修改。打包后再次解包比对坐标、标记与每个像素。

## 外观接口与生命周期

`A.syncCharacterArt(bro)` 只处理当前阿飞起源、`afeix_character == "afei"` 的角色。它读取 `A.route()`，飞碟形态另读 `A.get("feidie_base_route", "normal")`。正常或嘉豪映射到各自基础衣装；蛤蟆与未知底形回退原版身体，飞碟仍可独立出现。缺任何身体必需状态 brush 会整体回退，不选一个只有活体却没有尸体的素材组。

- `A.ensureCharacterArtLayer(bro)`：在全部 player 初始化及读档前一致调用，建立空飞碟层；其他角色始终空白、不可见。这是图层创建约定，不能据此承诺旧存档兼容。
- `A.syncCharacterArt(bro)`：转职、原生外观刷新、完整世界读档与昏迷恢复后调用。不更换 actor、不改装备，不强迫任何原版隐藏层显示。
- `A.hideCharacterArt(bro)`：死亡前隐藏并清空飞碟，不改变身体，让原版继续使用身体对应的 `_dead`。
- `A.suspendCharacterArt(bro)`：原版序列化前恢复原版身体及身体伤口并清空飞碟，原版序列化完成或抛异常后都重新 `syncCharacterArt`。Squirrel 中用正常路径和 `catch` 分别恢复，不使用 `finally` 语法。这样脚本序列化执行期间没有自定义身体或飞碟 brush 引用；此接口需配套 hooks。

接入位于 `src/scripts/mods/afeix/art_hooks.nut`：`onInit()` 在原版初始化后加空层；`onAppearanceChanged(appearance, setDirty = true)`、`onUpdateInjuryLayer()`、`onFactionChanged()`、`onCombatFinished()` 在原版回调后同步；`onDeserialize(input)` 在原版读入前确保空层、完成后尝试同步，完整世界读档还由角色元数据／转职恢复再次同步。各 wrapper 保留原生参数、默认值与返回值。

`onSerialize(output)` 和 `onDeath(killer, skill, tile, fatalityType)` 使用角色 `m` 中的临时挂起计数，不写进 Flags。保存时遇到嵌套外观回调或嵌套保存，都不会提前恢复自定义层；成功和异常路径均还原计数。死亡时只清空飞碟、禁止同步，保留当前身体供原版选取 `_dead`，不调用恢复原版身体的保存接口。昏迷幸存者在原版战后复苏完成后恢复衣装和飞碟。

本地解包的 `entity.onSerialize/onDeserialize` 仅调用 Flags；`actor`、`human`、`player` 的对应脚本也未显示 sprite 数量、顺序或按名称存读规则。脚本证据不足以判定引擎内部 sprite 序列化方式，因此不能宣称空层方案或保存前恢复已验证 v0.2 存档升级安全。新档保存、读回以及 v0.2 存档升级均需实机验证。

## 已检查与未完成

本轮检查了原版头搭配两套衣装、开面盔与链甲、封闭盔、尸体，以及 56×56 四图标的静态合成。对照图在 [build/layer-review-1x.png](build/layer-review-1x.png)，构建哈希与检查结果在 [manifest.json](manifest.json)。预览中的原版参考仅供本地诊断，不进入 `src/` 或发布包。

`tests/gameplay/test_appearance.nut` 加载实际 helper 与生命周期 hooks，通过 87 条 stub 行为断言，覆盖缺图回退、原版图层与装备不变、保存异常和嵌套回调、死亡与昏迷恢复、读档先后顺序。该测试不读取真实游戏存档，不能替代实机验收。

v1 人类倒地头与原版倒地头发方向不匹配、蛤蟆活头与衣领接缝问题仍然存在，未作修复声明，相关头部与全部蛤蟆层均排除在此图集之外。未复制旧测试起源、旧 helper 或副本角色。

**未启动游戏，未进行实机外观验收。**原版尸体会将头部肤色色染用于身体，最终衣装色调仍需实机看图；头顶状态标记、名册裁切、全部装备、战斗翻转与真正存读档也仍需验收。当前静态检查和脚本测试不意味着人物美术已经全部完成。
