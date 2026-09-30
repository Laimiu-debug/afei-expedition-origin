# 首次移动卡顿临时诊断

独立诊断 ZIP，不进入正式主包。仅计时和记录日志，不写入战役标记，不改存档结构、随机数、行走速度、资源或事件规则。

运行 `python tests/engine/first_move/build.py`，将输出的 `mod_afeix_first_move_diagnostic.zip` 放到游戏 `data`。需要重启游戏加载，可用于新战役或读档。第一次移动或取消暂停后记录 12 秒，随后停止计时；提前退出大地图也会输出结果。

记录首次点击、主线程和后台世界更新、势力、野外实体、契约、事件、野心、资源、场景、绘制和环境声音，以及本模组的招募、送信寻路和小龟同步。安装 BBMOD 地图标签时，还记录标签收集、区域角度计算和界面数据比较。首次进入每个被测回调会记录开始和结束；异常保留原有传播行为，并限量记录诊断消息。

读结果：`python tests/engine/first_move/read_log.py --output build/first-move-diagnostic-20260930/capture.json`。默认读取本机游戏 `log.html`。原始计时单位不预设，解析器根据整个采集窗口的实时长度估算毫秒，嵌套回调不能相加。帧间隔还包含渲染、操作系统调度及未包装的引擎代码，所以脚本耗时很小但帧间隔很大时，需要继续检查引擎、地图标签界面或资源处理。

诊断结束后退出游戏，移除 `data/mod_afeix_first_move_diagnostic.zip` 即可恢复原有加载集合，不需要更换主包或重开存档。原版或其他模组的字节码解包结果仅保存在本机 `build`，不加入该 ZIP。

离线检查：运行 `sq.exe tests/engine/first_move/test_profiler.nut` 和 `python tests/engine/first_move/test_read_log.py`。这些检查验证包装器和日志解析，不能替代实机首次移动的耗时结果。
