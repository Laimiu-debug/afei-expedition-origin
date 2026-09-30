# 阿飞哇哇叫 DLC 0.1.2：音量增强

2026-09-30 香港时间14:01发布至BBMOD。

阿飞受伤叫声音量比0.1.0增加约6.6～7.5dB，五段叫声分别提高响度，播放系数由0.85恢复为1.0。使用已核验的0.1.0原声短片，音高、语速、时长和淡入淡出保留；0.1.1调尖试验版未作为来源。游戏音效设置继续生效。

- [作品页面](https://bbmod.site/mods/f8909336-43fa-4415-82f6-b6224a8e7340/)
- [官网下载](https://bbmod.site/files/be0dad8e-271f-4d5d-bee0-dd1c63975704/download/)
- [本地语音DLC](<../../dlc/afei-voice/dist/mod_afeix_dlc_afei_voice v0.1.2.zip>)
- [新版连播试听](../../dlc/afei-voice/audio/preview-v0.1.2.wav)
- [安装说明](../../dlc/afei-voice/README.md)

3份脚本编译、24条离线行为检查通过。ZIP包含8个文件，完整条目集合、CRC和源码字节一致性核验通过，主包源码未被修改。每段新版PCM均与旧版对应样本按恒定增益匹配，采样格式和长度相同；峰值不超过-1dBFS，无削波样本。

官网目录API和详情页确认0.1.2、作品说明、更新记录与新下载链接，返回HTTP200。按用户要求未下载公开ZIP进行本地一致性检验。

包大小：297,608字节。SHA256：`12aa12c3723591008888f8e60113d8aa538b3bd090e44c6f12ece4668176e7ab`。

发布前数据库备份：`/srv/data/backups/afeix-pre-v0.1.2-20260930T060130612511Z.sqlite3`。通过网站表单、压缩包检查与发布服务更新既有语音DLC，主包与希文DLC的发布版本保持原样。

本机已安装0.1.0，游戏仍在运行；本轮未覆盖运行中的旧包，退出游戏后才能替换。新音量、战斗播放和存读档仍待实机复测。

证据：`dlc/afei-voice/audio/source.json`、`dlc/afei-voice/report.json`、`build/publish-dlc-afei-voice-v0.1.2/audio-level-verification.json`、`website-published.json`、`website-metadata-confirmation.json`。
