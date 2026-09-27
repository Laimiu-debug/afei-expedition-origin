# 34 人整体胸像图集 v0.4

本目录只管理本项目自制的完整人物胸像。34 名成员对应 36 种常态外观：33 名伙伴各一张，阿飞正常、蛤蟆、嘉豪各一张。飞碟继续使用独立图层，不把飞碟画入主图。当前选图状态以 [manifest.json](manifest.json) 为准；[旧图审阅清单](legacy-candidates.json)只提供候选依据，不会自动批准或覆盖现行映射。

这是整体胸像方案，角色服装已经画在图中。武器、护甲和头盔仍由游戏保存其装备与数值，外观显隐交由运行时脚本处理。图集不包含原版脸、头发、盔甲或其他原生图片。

本轮已完成全部 36 幅主体选图：**30 人新画／按旧特征重绘，6 幅主体沿用既有自制图**（阿飞三形态、小酒瓶、李李、余初九）。阿飞整个人直接由自制图表示，蛤蟆不再接原版人类身体。飞碟在人类主体上额外升高 12 像素，避免压到头发；较矮蛤蟆沿用原飞碟高度，实机仍待检查。

[实际提示词 MD](PROMPTS.md)汇总每幅图的输入、完整提示词与返修；[A 组记录](PROMPTS-group-a.json)、[B 组记录](PROMPTS-group-b.json)、[补图与复用记录](root-source-selections.json)保留原始文件路径。所有旧归档不修改，源图保持原分辨率；仅导出图等比缩小。

当前运行时隐藏原版头发、脸、衣装、武器和伤痕，保留选中及战斗状态。伤口不单画，倒地用同图整体旋转；同格尸体装饰被统一替换，原生掉落及尸体数据保留。玩法、安装及明确限制见 [v0.4 试玩说明](../../../docs/playtest-0.4.md)。

## 源图清单与审核

每位成员的 `key`、`name` 和顺序与 `data/character-stories.json` 一致。阿飞的 `forms` 为 `normal`、`toad`、`jiahao`；其他人的唯一形态为 `default`。

每个形态使用以下字段：

| 字段 | 作用 |
| --- | --- |
| `brush` | 固定运行时名称，普通成员为 `afeix_p04_<key>`，阿飞附形态名 |
| `source` | 相对于仓库根的 PNG 路径；允许 `art/character-concepts/` 或本目录 `sources/` |
| `source_kind` | `generated_custom` 或 `legacy_custom`，必须明确是项目自制图 |
| `approved_for_export` | 是否已经选定这份图用于本轮导出，不等于实机美术验收通过 |
| `source_sha256` | 审阅时的原图指纹；源图变更后须重新检查并更新 |
| `source_box` | 可选 `[left, top, right, bottom]` 技术裁切范围；默认 `null`，取整图透明边界 |
| `review_note` | 来源、画风、道具或身份映射的已知限制 |

旧自制源图先复制到 `sources/<key>.png`，在审阅记录中保留归档原路径与指纹；不要修改旧归档。工具不读取 `native`、原版参考目录或解包缓存，也不从候选清单自动挑图。每份源图必须是具有真实透明与不透明像素的 RGBA PNG。

## 尺寸与画刷契约

统一 PNG 尺寸为 **114×142**。以 alpha ≥20 查找可见边界，仅作裁切和等比缩放，使内容不超过 **108×124**，随后水平居中、底部对齐到 y=142。不会补画、重染色、擦背景、加伤口或改人物姿势。

| 状态 | PNG | 画刷坐标 | 画布与偏移 |
| --- | --- | --- | --- |
| 常态 | 完整胸像 | left=-57、right=57、top=-55、bottom=87 | width=114、height=142、offsetY=35 |
| `_dead` | 与常态 PNG 字节完全相同 | left=-57、right=57、top=-71、bottom=71 | width=114、height=142、offsetX=0、offsetY=0 |

每个主图有且仅有一个 `_dead` 配套，共 **72 个 brush**。倒地图只是以中心锚点引用同一幅自制胸像，**不是重新画过的尸体**；运行时必须单独完成整体旋转、落点和尸体装饰的处理，随后在游戏内检查。工具不旋转 PNG。不输出 `_injured`；受伤继续使用完整胸像，伤势规则与状态提示由游戏负责。

## 导出和检查

使用带 Pillow 的 Python，以及 `.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe`：

```text
python tools/build_portrait_art.py --check-manifest
python tools/build_portrait_art.py
```

正常构建要求全部 36 种形态有已审核源图，并且原图 SHA 一致。成功后只向 `src/` 发布：

- `brushes/afeix_portraits_v04.brush`
- `gfx/afeix_portraits_v04.png`

选图尚未完成时，可运行 `--allow-incomplete`；它只产生本目录的局部检查包，**不会写入 `src/`**。`--no-publish` 可对完整清单进行同样的本地检查。`--check-manifest --allow-incomplete` 只读验证当前清单并报告缺项。

Python 集成接口：`build_portrait_art.build_art(require_complete=True, publish_to_src=True, bbrusher=...)`，返回 `(published_paths, report)`。主构建应使用默认完整模式，并把返回的两份文件加入允许发布的自制美术列表。

导出先在忽略缓存中暂存，bbrusher 打包后立即解包，逐个核对 72 个预期标识、坐标与 RGBA 像素，全部一致才发布。检查产物：

- [交互检查页](build/index.html)：浅深背景与 1×／2× 显示。
- [1× 联系表](build/contact-sheet-1x.png)和 [2× 联系表](build/contact-sheet-2x.png)。
- [阿飞三主体与飞碟静态定位检查](build/afei-forms-2x.png)：使用实际画刷坐标与运行时偏移，不是游戏截图。
- [构建报告](build/report.json)：来源指纹、裁切、缩放、每形态状态、缺项和 roundtrip 结果。
- `sprites/metadata.xml`：最终坐标；`package/`：仅本图集的两份资源。

格式检查不能确认真人辨识度、战场兄弟画风或引擎兼容。角色名册裁切、世界与战斗切换、飞碟高度、倒地落点、昏迷复苏、死亡特效、存读档以及旧档升级均需实机验收。
