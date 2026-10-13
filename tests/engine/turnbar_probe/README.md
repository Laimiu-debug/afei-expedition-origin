# 临时行动条引擎自检

在实际 Coherent 引擎中比较原版头像工厂、自动闭合标签、明确闭合标签及 `createElement`，分别检查分离和已附着节点的层次、选择器与 jQuery 数据。启动到主菜单即输出 `AFEIX_UI_PROBE`，不需要加载战役或执行战斗操作。

构建：`python tests/engine/turnbar_probe/build.py --game "实际游戏目录"`。临时 ZIP 输出到 `build/turnbar-engine-probe`；加入该游戏的 `data` 后重启。仅用于本地排查，不进入主包。结果记录在 `Documents/Battle Brothers/log.html`；这些标记使用前端 `console.error` 以确保旧引擎写日志，标记本身不是未捕获异常。采集完成后退出游戏并移除临时 ZIP。

`--combat` 自动进入独立场景，生成十二名低勇气玩家角色与三只原版怨魂，并自动结束正常玩家回合，逃跑角色由原版 AI 控制。不会加载、写入战役存档。`--combat --fault` 在两次原版首位激活完成后，第三次开始故意让画像查询返回空；日志同时记录激活次数、失败次数、回合、行动条锁定和 AI 暂停状态。该测试证明特定故障机制及恢复能力，不证明原故障存档的自然复现。

`--campaign-copy 副本文件名` 为单独的模式：只加载事先复制、校验过的指定存档，在保存的位置进入敌方遭遇，并自动结束可控玩家的回合。它禁用 `world_state.autosave/saveCampaign`；运行前备份原存档并校验 SHA-256，运行后再次核对原存档与副本。不要把此模式指向原存档，不与 `--combat/--fault` 混用。正常游戏前移除临时 ZIP 和测试副本。`summarize.py 日志 --output 报告.json` 汇总回合、激活、错误及选择器差异，同时保留原始 HTML 日志。
