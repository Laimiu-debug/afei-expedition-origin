from pathlib import Path
import json

stage=Path(__file__).resolve().parent
root=stage.parents[1]
dlc=root/'dlc/afei-voice'
published=json.loads((stage/'website-published.json').read_text(encoding='utf-8'))
confirmation=json.loads((stage/'website-metadata-confirmation.json').read_text(encoding='utf-8'))
audio=json.loads((dlc/'audio/source.json').read_text(encoding='utf-8'))
assert confirmation['version']=='0.1.2' and confirmation['description_and_notes_confirmed']
report=json.loads((dlc/'report.json').read_text(encoding='utf-8'))
report.update(published=True,website_release_id=published['release_id'],website_metadata_confirmed=True,
              installed=False,installation_pending_game_exit=True,prior_installed_version='0.1.0',
              public_archive_downloaded=False,public_download_byte_comparison=False,
              audio_gain_db=[row['effective_level_increase_db'] for row in audio['clips']],
              peak_ceiling_dbfs=-1,pitch_and_timing_preserved=True,clipped_samples=0,
              audio_verification='Every output sample is the original-pitch 0.1.0 sample times a constant per-clip gain, within 1 PCM unit.')
(dlc/'report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
(stage/'audio-level-verification.json').write_text(json.dumps({'version':'0.1.2','original_version':'0.1.0',
    'gain_db':report['audio_gain_db'],'peak_dbfs':[row['peak_dbfs'] for row in audio['clips']],
    'rms_dbfs':[row['rms_dbfs'] for row in audio['clips']], 'pitch_and_timing_preserved':True,
    'clipped_samples':0,'in_game_tested':False},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
doc=f'''# 阿飞哇哇叫 DLC 0.1.2：音量增强

2026-09-30 香港时间14:01发布至BBMOD。

阿飞受伤叫声音量比0.1.0增加约6.6～7.5dB，五段叫声分别提高响度，播放系数由0.85恢复为1.0。使用已核验的0.1.0原声短片，音高、语速、时长和淡入淡出保留；0.1.1调尖试验版未作为来源。游戏音效设置继续生效。

- [作品页面]({published['detail_url']})
- [官网下载](https://bbmod.site/files/{published['release_id']}/download/)
- [本地语音DLC](<../../dlc/afei-voice/dist/mod_afeix_dlc_afei_voice v0.1.2.zip>)
- [新版连播试听](../../dlc/afei-voice/audio/preview-v0.1.2.wav)
- [安装说明](../../dlc/afei-voice/README.md)

3份脚本编译、24条离线行为检查通过。ZIP包含8个文件，完整条目集合、CRC和源码字节一致性核验通过，主包源码未被修改。每段新版PCM均与旧版对应样本按恒定增益匹配，采样格式和长度相同；峰值不超过-1dBFS，无削波样本。

官网目录API和详情页确认0.1.2、作品说明、更新记录与新下载链接，返回HTTP200。按用户要求未下载公开ZIP进行本地一致性检验。

包大小：{published['size']:,}字节。SHA256：`{published['sha256']}`。

发布前数据库备份：`{published['backup']}`。通过网站表单、压缩包检查与发布服务更新既有语音DLC，主包与希文DLC的发布版本保持原样。

本机已安装0.1.0，游戏仍在运行；本轮未覆盖运行中的旧包，退出游戏后才能替换。新音量、战斗播放和存读档仍待实机复测。

证据：`dlc/afei-voice/audio/source.json`、`dlc/afei-voice/report.json`、`build/publish-dlc-afei-voice-v0.1.2/audio-level-verification.json`、`website-published.json`、`website-metadata-confirmation.json`。
'''
(root/'docs/releases/publication-dlc-afei-voice-0.1.2.md').write_text(doc,encoding='utf-8')
print(json.dumps({'version':'0.1.2','published':True,'installed':False,'effective_gain_db':report['audio_gain_db'],'public_archive_downloaded':False}))
