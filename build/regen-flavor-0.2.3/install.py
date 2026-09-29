"""Install the verified public release through BBMOD's transactional service."""
from datetime import datetime, timezone
from pathlib import Path
from zipfile import ZipFile
import hashlib
import json
import sys

sys.path.insert(0, 'G:/CODE/bbmod/app')
from core.game import probe_game_running
from core.modmanager import ModManager
from core.online_catalog import OnlineInstaller

stage=Path(__file__).resolve().parent
publication=stage.parent/'publish-dlc-xiwen-regen-v0.2.3'
verified=json.loads((publication/'website-verification.json').read_text(encoding='utf-8'))
item=json.loads((publication/'website-catalog.json').read_text(encoding='utf-8'))
archive=publication/'mod_afeix_dlc_xiwen_regen v0.2.3.zip'
assert item['sha256']==verified['sha256'] and verified['download_bytes_match']
assert not probe_game_running(), 'Exit the game before updating installed files'
game=Path('F:/SteamLibrary/steamapps/common/Battle Brothers')
mm=ModManager(game)
installer=OnlineInstaller(mm)
name=item['file_name']
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def packages(): return {path.name:sha(path) for path in (game/'data').iterdir() if path.suffix.lower()=='.zip'}
def preload():
    with ZipFile(game/'data/zzzz_bbmod_preload.zip') as z:
        return {p:hashlib.sha256(z.read(p)).hexdigest() for p in z.namelist()}
before={'packages':packages(),'receipt':installer.state(),'preload_entries':preload()}
assert before['packages'][name]=='465300550acb13352caebf3fd34f2f987c2cab49f0a1ae0f3119e824f7ba2bc1'
(stage/'installation-before.json').write_text(json.dumps(before,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
status=installer.install('https://bbmod.site',item,archive)
after=packages()
assert after[name]==item['sha256']
assert {k:v for k,v in after.items() if k not in (name,'zzzz_bbmod_preload.zip')}=={k:v for k,v in before['packages'].items() if k not in (name,'zzzz_bbmod_preload.zip')}
assert preload()==before['preload_entries']
receipt=installer.state()
assert receipt['mods'][name]['version']=='0.2.3'
assert {k:v for k,v in receipt['mods'].items() if k!=name}=={k:v for k,v in before['receipt']['mods'].items() if k!=name}
assert sha(installer.backups/receipt['mods'][name]['backup'])==before['packages'][name]
assert not mm.transaction.journal.exists()
result={'time':datetime.now(timezone.utc).isoformat(),'status':status,'path':str(game/'data'/name),
        'sha256':after[name],'version':'0.2.3','receipt_written':True,'previous_version_backed_up':True,
        'other_mod_packages_unchanged':True,'preload_contents_unchanged':True,
        'pending_operation':False,'game_launched':False,'source':verified['download_url']}
(stage/'installation-verified.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
