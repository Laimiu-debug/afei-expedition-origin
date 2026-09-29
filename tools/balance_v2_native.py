"""Read selected native resources to cross-check the Wiki snapshot."""
from pathlib import Path
from zipfile import ZipFile
import json,subprocess,hashlib,sys
sys.stdout.reconfigure(encoding='utf-8')
ROOT=Path(__file__).resolve().parents[1];CACHE=ROOT/'.cache/balance-v2/native';CACHE.mkdir(exist_ok=True,parents=True);KIT=ROOT/'.cache/afei-art/bbros-modkit-v9/bin'
names=['scripts/skills/backgrounds/'+n+'_background.cnut' for n in ['brawler','farmhand','hunter','hedge_knight','sellsword','poacher','militia','squire']]
names+=['scripts/items/armor/coat_of_plates.cnut','scripts/items/armor/leather_lamellar.cnut','scripts/items/helmets/full_helm.cnut','scripts/items/helmets/nasal_helmet.cnut','scripts/items/weapons/named/named_two_handed_hammer.cnut','scripts/entity/world/party.cnut','scripts/states/world/asset_manager.cnut','scripts/config/character.cnut','scripts/skills/perks/perk_brawny.cnut']
found={}
names+=['scripts/items/item_container.cnut','scripts/items/armor/armor.cnut','scripts/items/helmets/helmet.cnut','scripts/items/weapons/weapon.cnut']
names+=['scripts/skills/skill_container.cnut']
names+=['scripts/skills/special/bag_fatigue.cnut']
for a in sorted(Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data').glob('data_*.dat')):
    with ZipFile(a) as z:
        for n in names:
            if n in z.namelist():found[n]=(a.name,z.read(n))
manifest=[]
for n,(a,b) in found.items():
    file=CACHE/n.replace('/','__');file.write_bytes(b)
    subprocess.run([str(KIT/'bbsq.exe'),'-d',str(file)],capture_output=True,check=True)
    t=subprocess.run([str(KIT/'nutcracker.exe'),str(file)],capture_output=True,check=True).stdout.decode('utf-8-sig').replace('\r\n','\n')
    file.with_suffix('.nut').write_text(t,encoding='utf-8');manifest.append({'path':n,'archive':a,'sha256':hashlib.sha256(b).hexdigest()})
(CACHE.parent/'native-manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print('extracted',len(found),'missing',set(names)-set(found))
