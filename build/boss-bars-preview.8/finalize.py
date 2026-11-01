from pathlib import Path
from datetime import datetime,timezone
from zipfile import ZipFile
import hashlib,json,shutil
root=Path(__file__).resolve().parents[1].parent
evidence=root/'build/boss-bars-preview.8'
stage=root/'build/publish-v0.29.0-preview.8'
validation=json.loads((root/'build/gameplay-validation.json').read_text(encoding='utf-8'))
package=root/'dist/mod_afeix_expedition v0.29.0-preview.8.zip'
installed=Path(r'F:/SteamLibrary/steamapps/common/Battle Brothers/data/mod_afeix_expedition.zip')
assert package.read_bytes()==installed.read_bytes()
save_dir=Path(r'C:/Users/25647/OneDrive/Documents/Battle Brothers/savegames')
before=json.loads((evidence/'saves-before.json').read_text(encoding='utf-8'))
for row in before:
    original=evidence/'save-backup'/row['name']
    assert hashlib.sha256(original.read_bytes()).hexdigest()==row['sha256']
    shutil.copy2(original,save_dir/row['name'])
assert all(hashlib.sha256((save_dir/r['name']).read_bytes()).hexdigest()==r['sha256'] for r in before)
published=json.loads((stage/'website-verification.json').read_text(encoding='utf-8'))
assert published['sha256']==hashlib.sha256(package.read_bytes()).hexdigest()
report={'version':'0.29.0-preview.8','internal_version':72,'completed_at':datetime.now(timezone.utc).isoformat(),
 'boss_scale':1.0,'corpse_scale':1.0,'bar_height':165,'native_brushes':True,
 'scripts':len(validation['scripts']),'offline_assertions':sum(t['assertions'] for t in validation['tests']),
 'entries':len(ZipFile(package).namelist()),'package':str(package),'installed':str(installed),
 'sha256':published['sha256'],'size':package.stat().st_size,'installed_bytes_match':True,
 'installation_backup':str(evidence/'installed-before.zip'),'saves_restored_byte_for_byte':True,
 'bar_scene_verified':['original boss size','full/half HP','zoom','stats toggle','hover','portrait excludes bars'],
 'final_scene_log':str(evidence/'final-scene-log.html'),'scene_runtime_errors':0,
 'limits':['All custom skills have offline feedback checks; per-skill battle and audio acceptance is incomplete.',
           'Blood-bar scene is a controlled tactical scenario, not a campaign or balance acceptance.',
           'An old save failed class registration under current mod set; its bytes were preserved.'],
 'published':True,'public_verification':published}
(root/'build/boss-bars-0.29-preview.8.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['gameplay-package.json','endgame-balance-package.json']:
    path=root/'build'/name
    j=json.loads(path.read_text(encoding='utf-8'))
    j.update({'installed':str(installed),'installation_verified':True,'published':True,'published_version':'0.29.0-preview.8',
              'download_url':published['download_url'],'publication_evidence':str(stage/'website-verification.json'),
              'in_game_tested':False,'in_game_scope':'Douyu bars checked in isolated scenario; full campaign and all skill audio pending.'})
    path.write_text(json.dumps(j,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
text=(root/'README.md').read_text(encoding='utf-8')
start=text.index('**v0.29.0-preview.7')
end=text.index('\n\n',start)
new='**v0.29.0-preview.8 已发布官网**：斗鱼保持原来的大体型，血条与圆框状态图标单独抬至头顶；梦境阿飞补电子烟，自制主动技能补充动画、音效与成功日志。血条位置、满血/半血、镜头缩放、显示开关和悬停已定向实测；150份脚本、46,218条离线断言及328个包文件校验通过。所有技能逐项实战和声音试听仍待完整验收。[官网下载]('+published['download_url']+') · [本地完整包](<dist/mod_afeix_expedition v0.29.0-preview.8.zip>) · [更新说明](docs/releases/v0.29.0-preview.8.md) · [发布记录](docs/releases/publication-0.29.0-preview.8.md)。'
(root/'README.md').write_text(text[:start]+new+text[end:],encoding='utf-8')
print('Installed, source/package/public bytes verified; original save files restored:',len(before))
