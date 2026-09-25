# 大飞午远征团 · 起源 MOD（`mod_afei_expedition`）

《战场兄弟》**1.5.2.3** 自定义战团起源。以阿飞主题起源 v0.6.2 为基底，现有 **32 名可入队人物**。川神已从新战役招募中移除；小宁、小胖、蔓越莓加入黑旗。

**玩家安装与上手见 [INSTALL.md](./INSTALL.md)。**

## 依赖

- Legacy Modding Script Hooks（`mod_hooks`）
- **不**要求 Modern/MSU

## 内容范围（v4.0）

| 模块 | 状态 |
|------|------|
| 命名人物 | **32 人**可入队（三队长 + 29 名伙伴）；旧存档的川神脚本仍保留供读取 |
| 伙伴对话 | 主线节点、成长回访与候选伙伴以**对话事件**主动找上门（event.afei_talk） |
| 黑旗名册 | 世界地图 **F8**：招募试训、主线、驻营、代理、成长回访（查询与手动办理） |
| 阿飞饰品 | **电子烟**：战斗回血 20（每回合一次，不毁）；**自行车**：小酒瓶离队剧情可选遗弃 → 经验 ×1.5（仅一次） |
| 小酒瓶离队 | 阿飞完成个人成长「蛤蟆站稳」或第 60 日触发夜话：**挽留**或**放手**；放手进入「回马灯」，再决定是否遗弃自行车 |
| 技能 / 成长 | 97 项专属技能条目 + 32 条个人成长，统一战斗标记与结算 |
| M01–M09 | 送账、复盘、蓝旗、小熊、钥匙、白影、回信、驻营等 |
| 头像 / 立绘 | 新增三人暂用原版事件与战斗外观；原有事件图继续保留，C01–C06 使用完整战斗胸像并保留可更换的武器、盾牌图层 |

## 包内 ID

- ZIP：`mod_afei_expedition.zip` · mod id：`mod_afei_expedition` · scenario：`scenario.afei_expedition` · 版本：**4.0**

## 构建与检查

```bash
python tools/apply_flavor.py
python tools/verify.py
python tools/build_zip.py
```

人物与技能的当前数据源为 `data/document-v0.6.2.json`、`data/flavor-v0.6.2.json` 和 `data/equipment.json`。`update_roster_20260924.py` 已完成一次性名册迁移；较早的 `prepare_source.py`、`make_flavor.py`、`finish_source.py` 属旧版构建过程，不应再用于重建当前包。

修改 C04–C06 的高分辨率母图后，先运行 `python tools/normalize_battle_style_busts.py`，再运行 `python tools/install_coherent_busts.py`。随后用 `test-output/bbros-modkit-v9/bin/bbrusher.exe pack --gfxPath <mod根目录>/src <mod根目录>/src/brushes/afei_busts.brush <mod根目录>/art/tactical-sprites` 重建画刷，最后运行上述检查与打包。`--gfxPath` 指向 `src`，画刷中的 `gfx/afei_busts.png` 才会写到正确位置。

## 许可

见 `LICENSE.txt`。
