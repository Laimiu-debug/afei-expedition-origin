"""Read-only live source snapshot for the 2026-09-29 balance proposal."""
from pathlib import Path
import hashlib, json, subprocess, zipfile, sys
sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs/design/balance-v1'
CACHE = ROOT / '.cache/balance-v1'
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'
OUT.mkdir(parents=True, exist_ok=True)
CACHE.mkdir(parents=True, exist_ok=True)

def main():
    result = subprocess.run([str(KIT/'sq.exe'), 'tools/export_gameplay_roster.nut'], cwd=ROOT, capture_output=True, encoding='utf-8', check=True)
    roster = json.loads(result.stdout.split('ROSTER_JSON_BEGIN\n')[1].split('\nROSTER_JSON_END')[0])
    (OUT/'current-roster.json').write_text(json.dumps(roster, ensure_ascii=False, indent=2), encoding='utf-8')
    manifest = {'date':'2026-09-29', 'version':roster['version'], 'files':[]}
    for p in sorted((ROOT/'src/scripts').rglob('*.nut')):
        manifest['files'].append({'path':p.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
    (OUT/'source-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
    wanted = ['scripts/entity/tactical/actor.cnut','scripts/entity/tactical/player.cnut','scripts/skills/skill.cnut','scripts/config/character.cnut',
        'scripts/skills/perks/perk_nimble.cnut','scripts/skills/perks/perk_battle_forged.cnut','scripts/skills/perks/perk_dodge.cnut',
        'scripts/skills/perks/perk_duelist.cnut','scripts/skills/perks/perk_berserk.cnut','scripts/skills/perks/perk_recover.cnut',
        'scripts/skills/perks/perk_shield_expert.cnut','scripts/skills/perks/perk_fearsome.cnut',
        'scripts/items/item.cnut','scripts/skills/backgrounds/character_background.cnut','scripts/entity/world/party.cnut']
    for p in roster['characters']:
        wanted += ['scripts/items/'+item+'.cnut' for item in p['equipment']+p['bag']]
    wanted += ['scripts/skills/actives/'+s+'.cnut' for s in ['thrust','strike','slash','shoot_bow','quick_shot','aimed_shot','shoot_bolt','reload_bolt','throw_javelin','throw_axe','smite','shieldwall','recover','rally_the_troops']]
    wanted += ['scripts/skills/perks/'+s+'.cnut' for s in ['perk_colossus','perk_gifted','perk_underdog','perk_pathfinder','perk_footwork','perk_rotation','perk_mastery_hammer','perk_mastery_spear','perk_mastery_polearm','perk_mastery_throwing']]
    game=Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data')
    archives=sorted(p for p in game.glob('data_*.dat'))
    extracted={}
    for archive in archives:
        with zipfile.ZipFile(archive) as z:
            for name in z.namelist():
                if name in wanted or (name.endswith('.cnut') and (name.startswith('scripts/config/tactical') or (name.startswith('scripts/skills/actives/') and any(e in name for e in ['smite','thrust','strike','shoot','throw_javelin','split_man'])))) or (name.startswith('scripts/items/') and name.endswith('.cnut') and any('/'+e+'.cnut' in name for e in ['militia_spear','hunting_bow','short_bow','light_crossbow','javelin','throwing_axe','pike','billhook','two_handed_hammer','wooden_shield','kite_shield','padded_leather','leather_lamellar','mail_shirt','mail_hauberk','padded_surcoat','nasal_helmet','hood','aketon_cap','sallet_helmet','greatsword','arming_sword','flail','dagger'])):
                    dest=CACHE/name.replace('/','__')
                    dest.write_bytes(z.read(name))
                    subprocess.run([str(KIT/'bbsq.exe'),'-d',str(dest)],capture_output=True,check=True)
                    decoded=subprocess.run([str(KIT/'nutcracker.exe'),str(dest)],capture_output=True,check=True)
                    dest.with_suffix('.nut').write_bytes(decoded.stdout)
                    extracted[name]={'archive':archive.name,'sha256':hashlib.sha256(z.read(name)).hexdigest(),'local':str(dest.with_suffix('.nut'))}
    (OUT/'native-manifest.json').write_text(json.dumps(extracted,ensure_ascii=False,indent=2),encoding='utf-8')
    print(json.dumps({'version':roster['version'],'characters':len(roster['characters']),'skills':len(roster['memberSkillDefs']),'native_files':len(extracted)},ensure_ascii=False))
    for p in roster['characters']:
        skills=roster['memberSkills'].get(p['key'],[])
        print(p['key'],p['name'],p['attrs'],p['stars'],'skills='+','.join(skills))

if __name__=='__main__': main()
