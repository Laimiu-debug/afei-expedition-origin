# 旧项目归档：I:\afei-expedition

归档日期：2026-09-25。原目录保持原样，本目录用于保留历史和后续取材，尚未合并为当前十人制的运行源码。

## 保存范围与校验

| 项目 | 结果 |
| --- | --- |
| 原目录文件数 | 5,015 |
| 原目录文件总大小 | 234,068,375 字节，约 223.22 MiB |
| 完整快照 | [original-project.zip](original-project.zip)，229,701,467 字节 |
| 完整性 | 逐文件 SHA-256 校验压缩包内容，5,015 项全部一致 |
| 便于查阅的副本 | [reference](reference/)，638 个文件；复制后逐文件校验一致 |
| 副本图片检查 | 414 张图片可读取，尺寸、模式与 SHA-256 见 [asset-inventory.csv](asset-inventory.csv) |

完整快照包括原目录的源码、数据、美术、工具、发行包、历史备份、离线测试和原版拆包参考，未按“是否成品”删除旧版本。reference 收录 art、data、dist、src、tools（不含 Python 缓存）、根目录文档，以及 test-output 顶层图片和素材来源 JSON；其余测试文件和历史包仍可从完整快照取得。

完整快照 SHA-256：

```text
c06cf2cfea844330c3fc16f9ff58c8f927be0eaeaa1ab3f11416a73b4c3d4b3b
```

逐文件信息：[manifest.json](manifest.json)。

## 后续从哪里开始

- [旧项目审阅与复用建议](../../docs/research/legacy-project-review.md)
- [美术与人物对应索引](../../docs/art/legacy-asset-index.md)
- [人物对应数据](character-map.json)：当前 35 人与旧 Cxx 编号分别保存，不自动合并身份。
- [旧版发行包](reference/dist/mod_afei_expedition.zip)：301 项，CRC 正常，与本次保存的 src 逐文件一致；本轮没有安装或启动它。
- [旧版实现记录](reference/IMPLEMENTATION.md)与[玩法审查](reference/GAMEPLAY-AUDIT-2026-09-24.md)：历史完成和测试声明，不替代本轮验收。

原项目使用 Legacy Modding Script Hooks。部分工具引用旧工程外部的编译器或游戏目录，应先调整路径再运行；本轮只做读取、复制和完整性检查，没有执行旧安装脚本。

旧版是 32 人物数据、97 项专属技能、每战 12 人与 20／39 名册规则。当前设计为 35 名主题人物、单队后期最多 10 人出战，两者还没有完成迁移。归档目录和原版拆包参考不作为新版 Mod 的发行内容。

## 已知素材缺口

旧索引记载的 123 条外部生成原图路径本轮均不可访问，检查记录见 [external-source-status.json](external-source-status.json)。本归档完整覆盖 I:\afei-expedition 内实际存在的文件；不把外部缺失文件计作已保存。

成品技能图标、事件图、六人母图、后续修订与参考照均有副本。旧版 C32 小宁、C33 小胖、C34 蔓越莓使用原版人物图回退，其中小胖、蔓越莓的六项技能没有自定义图标；不能仅依据旧“final”总览判断素材已经覆盖当前全部角色。
