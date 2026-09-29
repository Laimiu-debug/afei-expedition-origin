# v0.23.2 · 解网后技能回调修复

2026-09-28 已发布至 [BBMOD](https://bbmod.site/mods/d64a00f6-1d60-4d8d-8d9b-de055fc0b748/)，[安装与存档兼容说明](releases/v0.23.2.md)及[发布记录](releases/publication-0.23.2.md)可查。GitHub Release 未更新。

## 修复

`catalogAfterSkill` 原先在所有成功技能结束后先读取 `s.getContainer().getActor()`，再判断是否属于阿飞的「豪气」「飞碟」。一次性技能成功后如已被回收、容器已清空，这一步会抛出 `the index 'getActor' does not exist`，让原版 `ai_break_free.onExecute` 无法完成本次行动。

现在先筛选两项实际需要触发伙伴反应的技能，再检查容器、角色存活和在场状态。其他技能直接结束此回调，保留原版解网的成功率、失败奖励、行动点和疲劳消耗。

## 验证与边界

- 使用本机原版 `skill.use`、`break_free_skill.onUse`、`skill_container` 的移除与回收，以及 `ai_break_free.onExecute` 执行回归测试；地图、画面和角色引擎接口使用替身。
- 同时覆盖敌我双方、本起源与其他起源、原版延后回收，以及在 `onUse` 结束前执行原版容器更新的边界。旧回调在最后一项触发 `getActor` 异常，修复后正常完成 AI 行动并清空待执行技能。
- 检查解网后继续攻击、解网失败再尝试、行动点不足，以及已移除的阿飞技能；新测试 115 条断言。现有伙伴技能测试确认阿飞指令反应继续生效。
- 全量离线检查：110 个 Squirrel 文件、22,227 条行为断言，以及 JavaScript、资源与图集校验通过。
- 本机最新游戏日志没有本次解网卡死的堆栈。原版延后回收路径本身通过；本轮确认并修复的是技能提前回收后的异常边界，尚未在用户原战斗中复现和验收。

## 本机更新

使用 `dist/mod_afeix_expedition.zip` 整包替换游戏 `data` 下同名文件，不解压。原安装包和原构建包备份在 `build/net-escape-hotfix-20260928/backups/`。内部 Mod 版本递增至 28，存档 Schema 仍为 8，无需新开战役。

完全退出并重启游戏后，从卡死前的存档重新进入战斗复测。若仍卡住，需要保留当次 `Battle Brothers/log.html`，以继续定位实际触发点。
