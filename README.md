# 阿飞远征团

《战场兄弟》的一个新起源。阿飞、大谋、抹茶三个人扛着一面黑旗起家，路上陆续招人，名册里一共 34 个熟面孔。最多 40 人在册，一场仗最多上 12 个。

支持 PC 原版和官方 DLC，需要先装 Legacy Modding Script Hooks（mod_hooks）。

## 下载

最新公开版是 **v0.29.0-preview.13**（试玩版）。

- [BBMOD 下载](https://bbmod.com/files/f3bd9a09-c0c4-47ff-a902-cafcbae2dd65/download/) · [GitHub Release](https://github.com/Laimiu-debug/afei-expedition-origin/releases/tag/v0.29.0-preview.13) · [这一版改了什么](docs/releases/v0.29.0-preview.13.md)
- 可选 DLC：[希文与里根儿 0.2.5](https://bbmod.com/mods/247b829d-8aa8-4898-a6dd-8b933c9ff1e9/)，加一名队员希文和战犬里根儿，[说明](dlc/xiwen-regen/README.md)
- 可选 DLC：[阿飞衣橱与哇哇叫 0.1.0](https://bbmod.com/mods/e554fc31-28b0-4b26-a8f5-295141ed79ef/)，六套外观、两张战败 CG 和五段受伤语音，需要主包 v0.28.12 以上

## 安装

1. 退出游戏。
2. 把下载的 zip 原样放进游戏的 `data` 目录，不用解压。
3. 把 `data` 里旧版本的本 Mod 压缩包移走。
4. 开新战役，起源选“阿飞远征团”。

每次更新都按新开战役测试，旧存档不保证能用。

## 玩什么

- **梦境开局**：开局先做一场梦。刀一十个人满级满装，连打蜘蛛、恐狼、林德虫，最后对上“斗鱼·深渊之主”。梦醒后回到现实，只剩三个人和一面黑旗。不想打可以跳过，之后在世界地图按 F8 → 再赴梦潮还能回去。
- **招人**：34 个人各有各的出场时间和条件，在酒馆、村庄的招募列表里陆续出现。新面孔优先，没招走的过几天会再来。完整条件写在[解锁条件表](docs/design/recruit-unlocks.md)里（剧透）。
- **人物**：每人有自己的背景、固定特质、7 级三选一的专属技能和 11 级精通。数值见[属性表](docs/design/character-stats.md)和[技能表](docs/design/member-skills.md)。
- **阿飞转职**：正常形态起步，可以走蛤蟆人或嘉豪两条路，六根开了以后有飞碟。见[转职设计](docs/design/afei-promotion.md)。
- **飞李不可**：在城镇酒馆里花 100 克朗给队员加 1 点基础属性。只能在酒馆用，入口在酒馆的黑旗页面，或者酒馆里按 F8 → 战团事务。
- **F8 菜单**：名册、布阵、换旗、隐藏头盔、回看剧情都在这里。Esc 关闭。
- **其他**：水友四派的随机事件、传奇武器“老马的垂直握把”、现实大陆上的“梦潮祭场”、8 种战团结局和每个人的退隐/阵亡后续。

## 开发中

本地是 v0.29.0-preview.14，还没发布，修的是 2560×1440 下黑潮只盖住四分之一屏幕的问题，见[更新说明](docs/releases/v0.29.0-preview.14.md)。完整梦境流程和战役结局还没在游戏里从头到尾打过一遍，试玩清单在[这里](docs/playtest-dream-0.29.md)。

历代版本的改动记录见 [CHANGELOG](docs/CHANGELOG.md)，每版的详细说明在 [docs/releases](docs/releases/)。

## 构建

源码在 `src/`，玩法逻辑主要在 `src/scripts/mods/afeix/`，入口是 `src/scripts/!mods_preload/mod_afeix_expedition.nut`。

```bash
python tools/check_gameplay.py
```

跑全部离线检查（Squirrel 语法、`tests/gameplay` 下的测试、JS 测试、资源核对）。默认用 `.cache/afei-art/bbros-modkit-v9/bin/sq.exe`，游戏目录默认是 `F:/SteamLibrary/steamapps/common/Battle Brothers`，可用 `--sq` / `--game` 改。

```bash
python tools/package_verified_gameplay.py
```

美术不用重新生成时用这个打包，生成 `dist/mod_afeix_expedition v<版本>.zip` 和 `.sha256`。打包前先改根目录的 `VERSION`。需要重新生成美术资源时用 `tools/build_gameplay.py`。压缩包后缀一律小写 `.zip`。

DLC 在 `dlc/` 下，各自有 `build.py`。

旧项目归档 `legacy/2026-09-25-afei-expedition/original-project.zip` 存在 Git LFS 里，克隆后只拿到指针文件的话，运行 `git lfs pull`。

## 设计文档

- [制作蓝图](docs/design/mod-blueprint.md)：核心玩法和制作顺序
- [人物名单](docs/design/character-roster.md) · [人物故事](docs/design/character-stories.md) · [人物背景](docs/design/character-backgrounds.md) · [人物配置](docs/design/member-implementation.md)
- [数值总表 V2](docs/design/balance-v2/全人物数值与招募总表.xlsx)：现行平衡以此为准
- [水友四派与六根](docs/design/supporter-factions.md) · [四派事件](docs/design/faction-events.md) · [随机事件对白](docs/design/encounter-dialogues.md)
- [梦境序章](docs/design/dream-opening.md) · [斗鱼与梦潮祭场](docs/design/douyu-world-and-trophies.md)
- [战团结局](docs/design/company-endings.md)
- [灵感手记](docs/design/idea-journal.md)：没做的点子也记在这里
- [Mod 制作研究](docs/research/battle-brothers-modding.md) · [起源美术做法](docs/research/origin-art-pipeline.md) · [旧项目复用](docs/research/legacy-project-review.md)
- [人物美术提示词](docs/art/character-art-prompts.md) · [头像资源](art/runtime/portraits-v05/README.md) · [旧素材索引](docs/art/legacy-asset-index.md)
