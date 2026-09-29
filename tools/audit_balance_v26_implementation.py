"""Verify the approved V2 inputs and the final base/DLC artifacts without editing them."""
import hashlib
import json
from pathlib import Path
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads((ROOT / path).read_text(encoding='utf-8'))


def main():
    source = read('build/balance-v26-source.json')
    base = read('build/gameplay-package.json')
    validation = read('build/gameplay-validation.json')
    dlc = read('dlc/xiwen-regen/report.json')
    proposal = read('docs/design/balance-v2/proposal.json')
    traits = read('docs/design/balance-v2/trait-design.json')
    trait_amendment = read('docs/design/balance-v2/traits-v264-amendment.json')
    latest = read('docs/design/balance-v2/v027-amendment.json')
    newest = read('docs/design/balance-v2/yanzi-v0271-amendment.json')
    song_amendment = read('docs/design/balance-v2/song-v0272-amendment.json')
    v0271_proposal = read('.cache/song-v0272/before-proposal.json')
    v0271_traits = read('.cache/song-v0272/before-trait-design.json')
    v027_proposal = read('.cache/yanzi-v0271/before-proposal.json')
    trait_proposal = read('.cache/v027/before-proposal.json')
    assert digest(ROOT / '.cache/v027/before-trait-design.json') == trait_amendment['trait_design_sha256']
    assert latest['before_trait_design_sha256'] == trait_amendment['trait_design_sha256']
    assert digest(ROOT / '.cache/yanzi-v0271/before-trait-design.json') == latest['trait_design_sha256']
    assert newest['before_trait_design_sha256'] == latest['trait_design_sha256']
    assert digest(ROOT / '.cache/song-v0272/before-trait-design.json') == newest['trait_design_sha256']
    assert song_amendment['before_trait_design_sha256'] == newest['trait_design_sha256']
    assert digest(ROOT / 'docs/design/balance-v2/trait-design.json') == song_amendment['trait_design_sha256']
    assert v0271_traits['definitions'] == read('.cache/v027/before-trait-design.json')['definitions']
    assert {k:v for k,v in traits['definitions'].items() if k!='quick'} == v0271_traits['definitions']
    assert traits['definitions']['quick']['delta']==[0,0,0,10,0,0,0,0]
    previous = read('.cache/traits-v264/before-proposal.json')
    approved_pairs = trait_amendment['fixed_traits']
    allowed_fields = {'fixed_traits', 'trait_delta', 'runtime_base_before_traits', 'trait_note'}
    for before, after in zip(previous['people'], trait_proposal['people']):
        assert before['key'] == after['key']
        key = after['key']
        assert {k: v for k, v in before.items() if k not in allowed_fields} == {k: v for k, v in after.items() if k not in allowed_fields}, key
        assert after['fixed_traits'] == approved_pairs.get(key, before['fixed_traits']), key
        delta = [sum(traits['definitions'][t]['delta'][i] for t in after['fixed_traits']) for i in range(8)]
        assert after['trait_delta'] == delta, key
        assert after['runtime_base_before_traits'] == [v-d for v,d in zip(after['attrs'],delta)], key
        if key not in approved_pairs:
            assert after['trait_note'] == before['trait_note'], key
    previous['people'] = trait_proposal['people']
    previous['status'] = previous['status'].replace('0.26.3', '0.26.4')
    assert previous == trait_proposal
    assert traits['definitions']['fat']['delta'] == [10,-10,0,0,0,0,0,0]
    replacements = {'亿口甜筒':'小虎', '眼子哥':'眼子', '小胖徐不快乐':'小胖', '小胖徐':'小胖'}
    def rename(value):
        if isinstance(value,str):
            for old,new in replacements.items(): value=value.replace(old,new)
        elif isinstance(value,list): value=[rename(x) for x in value]
        elif isinstance(value,dict): value={k:rename(x) for k,x in value.items()}
        return value
    expected = read('.cache/v027/before-proposal.json')
    jack_fields = {'attrs','stars','allocation','runtime_base_before_traits','build','role','target','perks','alternative_perks','endgame_weapon','weakness'}
    for old,new in zip(expected['people'],v027_proposal['people']):
        for key in list(old):
            if key!='current' and not key.startswith('v1_'):old[key]=rename(old[key])
        if old['key']=='xiaojie':
            assert sum(old['attrs'])==sum(new['attrs'])==409
            for field in ['attrs','stars','allocation']:assert new[field]==latest['xiaojie'][field]
            for field in jack_fields:old[field]=new[field]
        assert old==new,old['key']
    expected['skills']=rename(expected['skills'])
    expected['status']=expected['status'].replace('0.26.4','0.27.0')
    assert expected==v027_proposal
    expected = read('.cache/yanzi-v0271/before-proposal.json')
    yanzi_fields = jack_fields | {'fixed_traits','trait_delta','trait_note'}
    for old,new in zip(expected['people'],v0271_proposal['people']):
        if old['key']=='yanzi':
            for field in ['attrs','stars','allocation','fixed_traits']:
                assert new[field]==newest['yanzi'][field]
            assert new['trait_delta']==[0]*8 and new['runtime_base_before_traits']==new['attrs']
            for field in yanzi_fields:old[field]=new[field]
        assert old==new,old['key']
    expected['status']=expected['status'].replace('0.27.0','0.27.1')
    assert expected==v0271_proposal
    before_traits = read('.cache/yanzi-v0271/before-trait-design.json')
    for old,new in zip(before_traits['people'],v0271_traits['people']):
        if old['key']=='yanzi':
            assert new['traits']==['loyal','teamplayer'] and new['delta']==[0]*8
            for field in ['traits','delta','selected_votes','reason','effects']:old[field]=new[field]
        assert old==new,old['key']
    before_traits['status']=before_traits['status'].replace('0.27.0','0.27.1')
    assert before_traits==v0271_traits
    expected = read('.cache/song-v0272/before-proposal.json')
    for old,new in zip(expected['people'],proposal['people']):
        if old['key']=='songnuanyang':
            for field in ['attrs','stars','allocation','fixed_traits']:
                assert new[field]==song_amendment['songnuanyang'][field]
            assert new['trait_delta']==[0,0,0,10,0,0,0,0]
            assert new['runtime_base_before_traits']==[a-b for a,b in zip(new['attrs'],new['trait_delta'])]
            for field in yanzi_fields:old[field]=new[field]
        assert old==new,old['key']
    expected['status']=expected['status'].replace('0.27.1','0.27.2')
    assert expected==proposal
    before_traits = read('.cache/song-v0272/before-trait-design.json')
    for old,new in zip(before_traits['people'],traits['people']):
        if old['key']=='songnuanyang':
            assert new['traits']==['quick','ailing'] and new['delta']==[0,0,0,10,0,0,0,0]
            for field in ['traits','delta','selected_votes','reason','effects']:old[field]=new[field]
        assert old==new,old['key']
    before_traits['status']=before_traits['status'].replace('0.27.1','0.27.2')
    before_traits['definitions']['quick']=traits['definitions']['quick']
    assert before_traits==traits
    roster = read('build/characters.json')
    people = {p['key']: p for p in proposal['people']}
    assert len(people) == 35 and len(proposal['skills']) == 102
    assert sum(len(p['fixed_traits']) for p in people.values()) == 70
    for c in roster['characters']:
        p = people[c['key']]
        for field in ['name', 'attrs', 'stars', 'wage', 'equipment', 'bag']:
            assert c[field] == p[field], (c['key'], field)
        if not c['isCaptain']:
            assert roster['encounterRequirements'][c['key']] == {
                'days': p['day'], 'battles': p['battles'], 'jobs': p['contracts'],
                'towns': p['towns'], 'level': p['highest_level']}
    assert len(roster['characters']) == 34 and roster['version'] >= 34
    assert digest(ROOT / 'docs/design/balance-v2/全人物数值与招募总表.xlsx') == source['workbook_sha256']
    assert digest(ROOT / 'src/scripts/mods/afeix/balance_v26_data.nut') == source['runtime_data_sha256']
    for script in validation['scripts'] + validation['ui_scripts']:
        assert digest(ROOT / script['path']) == script['sha256'], script['path']

    packages = [
        (ROOT / base['package'], ROOT / 'src', base['sha256'], base['entries']),
        (ROOT / 'dlc/xiwen-regen/dist/mod_afeix_dlc_xiwen_regen v0.2.2.zip',
         ROOT / 'dlc/xiwen-regen/src', dlc['package_sha256'], dlc['entries']),
    ]
    checked = []
    for path, tree, sha, entries in packages:
        assert digest(path) == sha, path
        with ZipFile(path) as archive:
            assert archive.testzip() is None
            assert sorted(archive.namelist()) == sorted(entries)
            for name in entries:
                assert archive.read(name) == (tree / name).read_bytes(), name
        checked.append({'path': path.relative_to(ROOT).as_posix(), 'sha256': sha, 'files': len(entries)})
    assert dlc['base_package_sha256'] == base['sha256']
    assert base['behavior_assertions'] == sum(t['assertions'] for t in validation['tests'])

    unchanged = []
    amendments = []
    checkpoint = ROOT / '.cache/balance-v26/pre-implementation.zip'
    if checkpoint.exists():
        with ZipFile(checkpoint) as archive:
            for name in ['docs/design/balance-v2/全人物数值与招募总表.xlsx',
                         'docs/design/balance-v2/proposal.json',
                         'docs/design/balance-v2/current-roster.json']:
                if archive.read(name) == (ROOT / name).read_bytes():
                    unchanged.append(name)
                    continue
                amendment = read('docs/design/balance-v2/bottle-endurance-amendment.json')
                heavy = read('docs/design/balance-v2/heavy55-amendment.json')
                melee = read('docs/design/balance-v2/bottle-melee60-amendment.json')
                if name.endswith('proposal.json'):
                    original = json.loads(archive.read(name))
                    next(p for p in original['people'] if p['key'] == 'bottle')['level_bonus_per_level'][1] = 3
                    before = json.loads((ROOT / '.cache/full-table-v262/before-proposal.json').read_text(encoding='utf-8'))
                    assert original == before, 'V2.2 starts from the bottle-approved baseline'
                    assert heavy['before_proposal_sha256'] == amendment['proposal_sha256']
                    assert melee['before_proposal_sha256'] == heavy['proposal_sha256']
                    amended = read('.cache/bottle-melee-v263/before-proposal.json')
                    bottle = next(p for p in amended['people'] if p['key'] == 'bottle')
                    assert bottle['attrs'][4] == 53
                    bottle['attrs'][4] = 60
                    bottle['runtime_base_before_traits'][4] = 60 - bottle['trait_delta'][4]
                    amended['status'] = amended['status'].replace('0.26.2', '0.26.3')
                    assert amended == read('.cache/traits-v264/before-proposal.json'), 'Trait revision starts from the approved Bottle melee baseline'
                    assert trait_amendment['before_proposal_sha256'] == melee['proposal_sha256']
                    assert latest['before_proposal_sha256'] == trait_amendment['proposal_sha256']
                    assert newest['before_proposal_sha256'] == latest['proposal_sha256']
                    assert song_amendment['before_proposal_sha256'] == newest['proposal_sha256']
                    assert digest(ROOT / name) == song_amendment['proposal_sha256']
                elif name.endswith('.xlsx'):
                    assert hashlib.sha256(archive.read(name)).hexdigest() == amendment['before_workbook_sha256']
                    assert heavy['before_workbook_sha256'] == amendment['workbook_sha256']
                    assert melee['before_workbook_sha256'] == heavy['workbook_sha256']
                    assert trait_amendment['before_workbook_sha256'] == melee['workbook_sha256']
                    assert latest['before_workbook_sha256'] == trait_amendment['workbook_sha256']
                    assert newest['before_workbook_sha256'] == latest['workbook_sha256']
                    assert song_amendment['before_workbook_sha256'] == newest['workbook_sha256']
                    assert digest(ROOT / name) == song_amendment['workbook_sha256']
                else:
                    raise AssertionError(name)
                amendments.append(name)
    prior = ROOT / 'dist/mod_afeix_expedition v0.25.2.ZIP'
    assert digest(prior) == (ROOT / 'dist/mod_afeix_expedition v0.25.2.sha256').read_text().split()[0]
    report = {
        'version': base['version'], 'dlc_version': dlc['version'].removesuffix('-dlc'),
        'approved_workbook_sha256': source['workbook_sha256'],
        'unchanged_approved_inputs': unchanged,
        'approved_workbook_and_proposal_amendments': amendments,
        'current_display_names': latest['display_names'],
        'xiaojie_build': latest['xiaojie'],
        'yanzi_build': newest['yanzi'],
        'songnuanyang_build': song_amendment['songnuanyang'],
        'current_trait_assignments': {**approved_pairs,'yanzi':['loyal','teamplayer'],'songnuanyang':['quick','ailing']},
        'base_people': 34, 'combined_people': 35, 'fixed_traits': 70,
        'base_skill_choices': 99, 'combined_skill_choices': 102,
        'base_assertions': base['behavior_assertions'],
        'dlc_assertions_including_related_base_regressions': sum(t['assertions'] for t in dlc['validation']['tests']),
        'packages': checked, 'validation_script_hashes_match': True,
        'zip_crc_and_source_match': True, 'dlc_matches_final_base': True,
        'v0_25_2_archive_sha256_unchanged': digest(prior),
        'in_game_tested': False, 'real_player_save_tested': False,
        'installed_to_game': False, 'published': False,
        'acceptance_scope': 'New campaigns; native-script regressions independently verify requested trait arithmetic, Fat stamina, Huge damage, Gluttonous food, and Determined combat morale. Broader roster tests retain audited delta stand-ins.',
    }
    destination = ROOT / 'build/balance-v26-implementation.json'
    destination.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, ensure_ascii=False))


if __name__ == '__main__':
    main()
