# 自行车与电子烟图标

复用用户旧项目的原有像素文件，没有新增生图、重绘或改色。

| 资源 | 原图 | 新版用途 |
| --- | --- | --- |
| 自行车 | `legacy/.../gfx/ui/items/accessory/afei_bicycle.png` | 公共行囊物品与提示图 |
| 电子烟 | `legacy/.../gfx/ui/items/accessory/afei_ecig.png` | 饰品栏物品与提示图 |
| 抽一口 | `legacy/.../gfx/skills/afei_ecig_puff.png` | 战斗技能可用状态 |
| 抽一口（禁用） | `legacy/.../gfx/skills/afei_ecig_puff_sw.png` | 战斗技能禁用状态 |

物品同时保留 `gfx/items` 与 `gfx/ui/items` 版本，共六个文件。`report.json` 记录完整路径、尺寸与 SHA256；构建时逐字节核对旧源图。构建入口：`tools/build_keepsake_art.py`。
