"""Prepare a louder original-pitch voice update, without public ZIP downloads."""
from array import array
from pathlib import Path
from zipfile import ZipFile
import hashlib
import io
import json
import math
import shutil
import wave

stage = Path(__file__).resolve().parent
root = stage.parents[1]
dlc = root/'dlc/afei-voice'
before = json.loads((stage/'website-before.json').read_text(encoding='utf-8'))
previous = json.loads((root/'build/publish-dlc-afei-voice-v0.1.0/website-release.json').read_text(encoding='utf-8'))
report = json.loads((dlc/'report.json').read_text(encoding='utf-8'))
audio = json.loads((dlc/'audio/source.json').read_text(encoding='utf-8'))
target = before['target']
assert target['id']=='f8909336-43fa-4415-82f6-b6224a8e7340' and target['owner']==before['owner']
assert report['version']==(dlc/'VERSION').read_text().strip()=='0.1.2'
assert not any(row['version']=='0.1.2' for row in target['releases'])
assert report['scripts_compiled']==3 and report['behavior_assertions']==24
assert report['base_path_collisions']==[] and report['base_source_unchanged']
package = dlc/'dist/mod_afeix_dlc_afei_voice v0.1.2.zip'
sha = lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
source = {path.relative_to(dlc/'src').as_posix():path for path in (dlc/'src').rglob('*') if path.is_file()}
original = json.loads((dlc/'audio/archive/v0.1.0/source.json').read_text(encoding='utf-8'))
with ZipFile(package) as archive, ZipFile(dlc/'dist/mod_afeix_dlc_afei_voice v0.1.0.zip') as baseline:
    assert archive.testzip() is None and len(archive.namelist())==len(source)==8
    assert set(archive.namelist())==set(source)
    assert all(archive.read(name)==path.read_bytes() for name,path in source.items())
    for old,new in zip(original['clips'],audio['clips']):
        assert old['path']==new['path']
        old_data,new_data=baseline.read(old['path']),archive.read(new['path'])
        assert hashlib.sha256(old_data).hexdigest()==old['sha256']
        with wave.open(io.BytesIO(old_data),'rb') as old_wav, wave.open(io.BytesIO(new_data),'rb') as new_wav:
            assert old_wav.getparams()==new_wav.getparams(),old['path']
            old_pcm=array('h',old_wav.readframes(old_wav.getnframes()))
            new_pcm=array('h',new_wav.readframes(new_wav.getnframes()))
        gain=10**(new['level_increase_db']/20)
        assert all(abs(after-round(before*gain))<=1 for before,after in zip(old_pcm,new_pcm))
        assert max(abs(v) for v in new_pcm)<32767 and new['peak_dbfs']<=-0.99
        assert 6.6<new['effective_level_increase_db']<7.6
mod = {key:target['metadata'].get(key,value) for key,value in previous['mod'].items()}
for key in ('mod_ids','requires','conflicts'):
    if isinstance(mod[key],list):mod[key]='\n'.join(mod[key])
mod['summary']='0.1.2 音量增强：阿飞受伤时随机播放5段实况原声叫声，音量比0.1.0增加约7dB，保留原声音高和语速。独立可选DLC，需搭配阿飞远征团主包。'
description=target['metadata']['description']
old='0.1.0 使用原声音高与语速，每段约 0.77～0.89 秒。音效经过轻度降噪、音量统一和短淡入淡出，没有升调处理。原声取自提供的阿飞实况视频，完整视频不进入安装包。'
assert old in description
mod['description']=description.replace(old,'0.1.2 调大受伤叫声音量：在相同游戏设置下，比0.1.0增加约6.6～7.5dB；五段叫声分别提高响度，仍保留原声音高、语速、裁剪时长和淡入淡出，峰值保留余量。每段约0.77～0.89秒。原声取自提供的阿飞实况视频，完整视频不进入安装包。')
mod['description']=mod['description'].replace('推荐主包 v0.28.4','推荐主包 v0.28.7')
mod['compatibility_notes']=mod['compatibility_notes'].replace('推荐使用主包 v0.28.4','推荐使用主包 v0.28.7')
mod['compatibility_notes']+='\n\n0.1.2仅调整本语音DLC的响度，音高与语速保持原样。游戏的音效音量设置仍然生效。请退出游戏后替换旧语音DLC，仅保留一个阿飞哇哇叫DLC包。'
notes='提高阿飞哇哇叫受伤叫声音量：同一游戏音量设置下，比0.1.0增加约6.6～7.5dB，移除原有0.85播放衰减并提高五段音频响度。保留原声音高、语速、时长和淡入淡出，峰值留有余量；其他角色及其他声音仍沿用原版。3份脚本、24条离线检查和8个包文件核验通过；实机音量仍待复测。请退出游戏后替换旧语音DLC，只保留一个版本。'
spec={'owner':before['owner'],'expected_mod_id':target['id'],'expected_metadata':target['metadata'],
      'mod':mod,'version':'0.1.2','notes':notes,'package_filename':package.name,'sha256':sha(package),
      'verification':{'source_root':'dlc/afei-voice/src','mod_id':'mod_afeix_dlc_afei_voice','internal_version':3,
                      'entries':8,'voice_clips':5,'behavior_assertions':24,'pitch_and_timing_preserved':True,
                      'effective_gain_db':[row['effective_level_increase_db'] for row in audio['clips']],
                      'public_download_byte_comparison':False}}
(stage/'website-release.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(package,stage/package.name)
shutil.copy2(root/'tools/publish_bbmod_release.py',stage/'publish_bbmod_release.py')
publisher=(root/'build/publish-dlc-afei-voice-v0.1.0/publish.py').read_text(encoding='utf-8').replace('voice-010','voice-012').replace('0.1.0','0.1.2')
(stage/'publish.py').write_text(publisher,encoding='utf-8')
confirm=(root/'build/publish-v0.28.7/confirm_metadata.py').read_text(encoding='utf-8').replace('0.28.7','0.1.2')
confirm=confirm.replace("('0.1.2', '33,422', 'Esc', '飞李不可', '仅限酒馆')", "('0.1.2', '哇哇叫', '音量', '7.5dB')")
(stage/'confirm_metadata.py').write_text(confirm,encoding='utf-8')
print('Prepared voice DLC 0.1.2: louder PCM verified against 0.1.0, timing/pitch unchanged, no clipped samples.')
