"""Audit role-plan assumptions against executable roster data; no gameplay writes."""
import hashlib
import json
import re
from collections import Counter
from pathlib import Path
import subprocess
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'
CACHE = ROOT / '.cache/endgame-roles'
FIELDS = ['Hitpoints', 'Stamina', 'Bravery', 'Initiative', 'MeleeSkill',
          'RangedSkill', 'MeleeDefense', 'RangedDefense']


def audit():
    CACHE.mkdir(parents=True, exist_ok=True)
    exporter = (ROOT / 'tools/export_gameplay_roster.nut').read_text(encoding='utf-8')
    exporter = exporter.replace('local A=::AfeixExpedition, characters=[];',
        'dofile("dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");\n'
        'local A=::AfeixExpedition, characters=[];')
    exporter = exporter.replace('promotionTalents=A.PromotionTalents,',
                                'growth=A.MemberGrowth,promotionTalents=A.PromotionTalents,')
    temporary = CACHE / 'export.nut'
    temporary.write_text(exporter, encoding='utf-8')
    result = subprocess.run([str(KIT / 'sq.exe'), str(temporary)], cwd=ROOT,
                            capture_output=True, text=True, encoding='utf-8', check=True)
    live = json.loads(result.stdout.split('ROSTER_JSON_BEGIN\n')[1].split('\nROSTER_JSON_END')[0])
    proposal = json.loads((ROOT / 'docs/design/balance-v2/proposal.json').read_text(encoding='utf-8'))
    plans = {p['key']: p for p in proposal['people']}
    assert len(live['characters']) == len(plans) == 35
    assert {p['key'] for p in live['characters']} == set(plans)
    rows = []
    for char in live['characters']:
        plan = plans[char['key']]
        assert char['attrs'] == plan['attrs'], char['key']
        assert char['stars'] == plan['stars'], char['key']
        allocation = plan['allocation']
        assert sum(allocation) == 30 and all(0 <= x <= 10 for x in allocation)
        bonus = live['growth'][char['key']]['choices'][plan['growth_pick']]['bonuses']
        assert [bonus.get(f, 0) for f in FIELDS] == plan['growth_bonus'], char['key']
        means = []
        for i, field in enumerate(FIELDS):
            star = char['stars'].get(field, 0)
            minimum = proposal['growth_roll_min'][i] + (2 if star == 3 else star)
            maximum = proposal['growth_roll_max'][i] + (1 if star == 3 else 0)
            means.append(char['attrs'][i] + allocation[i] * (minimum + maximum) / 2
                         + bonus.get(field, 0) + 10 * plan['level_bonus_per_level'][i])
        rows.append(dict(key=char['key'], name=char['name'], optional_dlc=char['key']=='xiwen',
                         current_build=plan['build'], allocation=allocation,
                         growth_pick=plan['growth_pick'], level11_mean=means))

    # Read installed original resources without distributing their source text.
    names = ['scripts/skills/perks/perk_' + n + '.cnut' for n in
             ['nimble', 'battle_forged', 'brawny', 'pathfinder', 'colossus', 'mastery_axe']]
    names += ['scripts/skills/effects/dodge_effect.cnut',
              'scripts/skills/actives/recover_skill.cnut',
              'scripts/skills/actives/rally_the_troops.cnut',
              'scripts/skills/actives/split_man.cnut', 'scripts/config/character.cnut',
              'scripts/skills/skill.cnut', 'scripts/skills/racial/skeleton_racial.cnut',
              'scripts/skills/actives/fire_handgonne_skill.cnut',
              'scripts/skills/actives/charm_skill.cnut',
              'scripts/entity/tactical/enemies/orc_warrior.cnut',
              'scripts/entity/tactical/humans/barbarian_champion.cnut',
              'scripts/entity/tactical/actor.cnut']
    installed = Path('F:/SteamLibrary/steamapps/common/Battle Brothers/data')
    found = {}
    for archive in sorted(installed.glob('data_*.dat')):
        with ZipFile(archive) as z:
            for name in names:
                if name in z.namelist():
                    found[name] = (archive, z.read(name))
    assert set(found) == set(names), set(names) - set(found)
    native = []
    for name, (archive, raw) in found.items():
        bytecode = CACHE / name.replace('/', '__')
        bytecode.write_bytes(raw)
        subprocess.run([str(KIT / 'bbsq.exe'), '-d', str(bytecode)], capture_output=True, check=True)
        decoded = subprocess.run([str(KIT / 'nutcracker.exe'), str(bytecode)],
                                 capture_output=True, check=True).stdout.decode('utf-8-sig').replace('\r\n', '\n')
        bytecode.with_suffix('.nut').write_text(decoded, encoding='utf-8')
        if name == 'scripts/config/character.cnut':
            ranges = re.findall(r'Min\s*=\s*(\d+),\s*Max\s*=\s*(\d+)',
                                decoded.split('Const.AttributesLevelUp <- [', 1)[1].split('];', 1)[0])
            assert len(ranges) == 8
            # Native attribute indices order Bravery before Fatigue.
            ranges[1], ranges[2] = ranges[2], ranges[1]
            assert [int(x[0]) for x in ranges] == proposal['growth_roll_min']
            assert [int(x[1]) for x in ranges] == proposal['growth_roll_max']
        native.append(dict(entry=name, archive=archive.name,
                           sha256=hashlib.sha256(raw).hexdigest()))
    paths = ['src/scripts/mods/afeix/balance_v26_data.nut',
             'src/scripts/mods/afeix/story_progress.nut',
             'dlc/xiwen-regen/src/scripts/mods/afeix_dlc_xiwen_regen/content.nut',
             'docs/design/balance-v2/proposal.json']
    report = dict(date='2026-09-30', version=(ROOT / 'VERSION').read_text().strip(),
                  fields=FIELDS, assumptions='Existing allocation, selected story growth; '
                  'no perks/equipment/promotion/temporary effects; means, not guaranteed rolls.',
                  main_build_counts=dict(Counter(r['current_build'] for r in rows if not r['optional_dlc'])),
                  people=rows, native_sources=native,
                  source_hashes={p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in paths})
    output = ROOT / 'docs/design/endgame-role-audit-20260930.json'
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    document = ROOT / 'docs/design/endgame-role-plan-20260930.md'
    if document.exists():
        text = document.read_text(encoding='utf-8')
        role_section = text.split('## 4. 全员建议定位', 1)[1].split('## 5.', 1)[0]
        for row in rows:
            assert f"|{row['name']}" in role_section, row['key']
        table = ['|成员|生命|疲劳|决心|先攻|近攻|远攻|近防|远防|',
                 '|---|---:|---:|---:|---:|---:|---:|---:|---:|']
        for row in rows:
            label = row['name'] + ('（可选DLC）' if row['optional_dlc'] else '')
            table.append('|' + label + '|' + '|'.join(f'{v:g}' for v in row['level11_mean']) + '|')
        begin, end = '<!-- BEGIN AUDITED LEVEL11 TABLE -->', '<!-- END AUDITED LEVEL11 TABLE -->'
        before, after = text.split(begin, 1)[0], text.split(end, 1)[1]
        document.write_text(before + begin + '\n' + '\n'.join(table) + '\n' + end + after,
                            encoding='utf-8')
    print(f'Verified 34 main members + 1 optional DLC member; 35 allocations and story choices; {len(native)} native scripts.')
    print(json.dumps(report['main_build_counts']))
    print('Saved audit JSON and refreshed the 35-row document appendix.')


if __name__ == '__main__':
    audit()
