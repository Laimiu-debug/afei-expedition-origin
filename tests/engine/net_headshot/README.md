# 网具与断头死亡实机测试

独立战斗场景，不读写战役存档，不进入正式主包。需要阿飞远征团主包及其 Hooks 依赖。使用游戏原版实体、投网、挣脱、攻击、死亡、掉落和回合系统；数值与失败概率由测试场景控制。

1. `python tests/engine/net_headshot/build.py` 生成临时测试 ZIP。
2. 完全退出游戏，把生成的 `mod_afeix_net_playtest.zip` 放入游戏 `data`。
3. 主菜单 → 战斗场景 → 第一项 `AFEIX NET / HEADSHOT TEST` → 开始游戏。
4. 按 **F7**：阿飞投网；敌人挣脱失败；仍被网住的敌人攻击未戴头盔、1 血的大某，强制断头概率为 100%。攻击仍保留原版命中判定，未命中时本轮不能算死亡测试通过。
5. 死亡完成后手动点击右下角“结束行动”，依次让存活队员和敌人行动，确认第 2 回合开始。
6. 退出场景再开一局，**F8** 可运行原版外观对照组。
7. 测试完成后退出游戏，移走这个临时 ZIP。

`log.html` 中检查 `THROW_END`、`ESCAPE_END result=false rooted=true`、`DEATH_BEGIN fatality=1`、`DEATH_END`、`ATTACK_END result=true victim_alive=false` 和 `Next round issued: 2`。仅出现 `NEXT_TURN_REQUESTED` 不能证明下一回合已经开始。

此场景跳过仅属于战役的统计计票回调，并使用内存中的起源标志。攻击动作由测试驱动调用，之后交回原版 AI；不替代完整战役、旧档兼容或帧耗时测试。2026-09-29 的旧包崩溃、原版外观对照与修复包通过记录见 `build/net-startup-20260929/engine-test.json`。那次实测后已从游戏目录移除临时测试模组。
