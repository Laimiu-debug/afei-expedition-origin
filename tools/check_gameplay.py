"""Check gameplay sources against local native resources and run isolated Squirrel tests."""
from pathlib import Path
from zipfile import ZipFile
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]


def file_hash(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_custom_atlas(base, atlas, report, expected_ids, *, root=ROOT, bbrusher=None):
    """Read and unpack shipped bytes, never rebuild or update source assets."""
    bbrusher = bbrusher or root / '.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe'
    roundtrip = report.get('roundtrip', {})
    entries = roundtrip.get('sprites', [])
    ids = [entry.get('id') for entry in entries]
    if (roundtrip.get('passed') is not True or roundtrip.get('sprite_count') != len(expected_ids)
            or len(ids) != len(expected_ids) or set(ids) != set(expected_ids)
            or any(entry.get('coordinates_identical') is not True or entry.get('pixels_identical') is not True for entry in entries)):
        raise ValueError(f'{atlas}: roundtrip report does not verify the required brush contract')
    files = {}
    for field, relative in [('brush', f'brushes/{atlas}.brush'), ('atlas', f'gfx/{atlas}.png')]:
        digest = roundtrip.get(field + '_sha256', '')
        if not re.fullmatch(r'[0-9a-f]{64}', digest):
            raise ValueError(f'{atlas}: missing {field} fingerprint in report; rebuild the art')
        if roundtrip.get(field) != 'package/' + relative:
            raise ValueError(f'{atlas}: unexpected {field} path in report')
        for path in (base / 'package' / relative, root / 'src' / relative):
            if not path.is_file() or file_hash(path) != digest:
                raise ValueError(f'{atlas}: {field} fingerprint differs or file missing: {path}')
        files[relative] = digest
    if not bbrusher.is_file():
        raise FileNotFoundError(f'Brush verifier unavailable: {bbrusher}')
    cache = root / '.cache/afei-art/gameplay-check'
    cache.mkdir(parents=True, exist_ok=True)
    decoded = {}
    with tempfile.TemporaryDirectory(prefix='art-unpack-', dir=cache) as temporary:
        output = Path(temporary)
        result = subprocess.run([str(bbrusher), 'unpack', '--gfxPath', str(root / 'src'),
                                 str(root / 'src/brushes' / (atlas + '.brush')), str(output)], capture_output=True)
        if result.returncode:
            raise RuntimeError(f'{atlas}: cannot unpack shipped atlas: ' + (result.stdout + result.stderr).decode('utf-8', errors='replace'))
        metadata = ET.parse(output / 'metadata.xml').getroot()
        actual = [entry.get('id') for entry in metadata]
        if len(actual) != len(expected_ids) or set(actual) != set(expected_ids):
            raise ValueError(f'{atlas}: actual shipped brush IDs differ from required contract')
        for entry in metadata:
            identity = entry.get('id')
            path = (output / entry.get('img').replace('\\', '/')).resolve()
            if not path.is_relative_to(output.resolve()):
                raise ValueError(f'{atlas}: invalid unpacked sprite path')
            with Image.open(path) as image:
                image = image.convert('RGBA')
                decoded[identity] = {'metadata': dict(entry.attrib), 'size': image.size,
                                     'pixels_sha256': hashlib.sha256(image.tobytes()).hexdigest()}
    return {'files': files, 'sprites': decoded}


def verify_sprite(decoded, path, metadata):
    with Image.open(path) as image:
        image = image.convert('RGBA')
        if image.size != decoded['size'] or hashlib.sha256(image.tobytes()).hexdigest() != decoded['pixels_sha256']:
            raise ValueError(f'Packed sprite pixels differ from reviewed export: {path.name}')
    actual = decoded['metadata']
    width, height = decoded['size']
    defaults = {'left': -width / 2, 'right': width / 2, 'top': -height / 2, 'bottom': height / 2,
                'width': width, 'height': height, 'offsetX': 0, 'offsetY': 0}
    for field, value in metadata.items():
        if field in defaults and float(actual.get(field, defaults[field])) != float(value):
            raise ValueError(f'Packed sprite anchor differs: {path.name} / {field}')


def validate_custom_art():
    from build_portrait_art import read_manifest, LIVE_RECT, DEAD_RECT, BASE
    from build_keepsake_art import validate_icons
    from build_member_skill_art import validate_icons as validate_member_icons

    portrait_base = BASE
    manifest_path = portrait_base / 'manifest.json'
    _, ready, missing = read_manifest(manifest_path)
    if missing or len(ready) != 36:
        raise ValueError(f'Portrait art is not complete/reviewed: {len(ready)}/36 forms')
    report = json.loads((portrait_base / 'build/report.json').read_text(encoding='utf-8'))
    expected_files = ['brushes/afeix_portraits_v04.brush', 'gfx/afeix_portraits_v04.png']
    if (report.get('schema_version') != 1 or report.get('atlas_name') != 'afeix_portraits_v04'
            or report.get('manifest') != manifest_path.relative_to(ROOT).as_posix()
            or report.get('manifest_sha256') != file_hash(manifest_path) or report.get('complete') is not True
            or report.get('published_to_src') is not True or report.get('named_characters') != 34
            or report.get('required_forms') != 36 or report.get('exported_forms') != 36 or report.get('sprite_count') != 108
            or report.get('files') != expected_files or report.get('missing')):
        raise ValueError('Portrait build report is incomplete, unpublished or stale for the current manifest')
    records = report.get('portraits', [])
    by_brush = {record['brush']: record for record in records}
    if len(records) != 36 or set(by_brush) != {entry['brush'] for entry in ready}:
        raise ValueError('Portrait report does not cover the 36 required visual forms')
    expected_ids = {entry['brush'] + suffix for entry in ready for suffix in ('', '_head', '_dead')}
    portrait = verify_custom_atlas(portrait_base, 'afeix_portraits_v04', report, expected_ids)
    for entry in ready:
        record = by_brush[entry['brush']]
        if record.get('source') != entry['source'] or record.get('source_sha256') != entry['source_sha256']:
            raise ValueError(f"Portrait report source is stale: {entry['brush']}")
        if (record.get('partition') != 'reviewed_neck_contour'
                or record.get('head_seam') != entry['head_seam'] or record.get('neck_guard') != entry['neck_guard']):
            raise ValueError(f"Portrait neck contour is stale: {entry['brush']}")
        for suffix, geometry, field in [('', LIVE_RECT, 'live_png_sha256'), ('_head', LIVE_RECT, 'head_png_sha256'), ('_dead', DEAD_RECT, 'dead_png_sha256')]:
            identity = entry['brush'] + suffix
            exported = portrait_base / 'sprites' / (identity + '.png')
            if not exported.is_file() or record.get(field) != file_hash(exported):
                raise ValueError(f'Portrait export fingerprint differs: {identity}')
            verify_sprite(portrait['sprites'][identity], exported, geometry)
        with Image.open(portrait_base / 'sprites' / (entry['brush'] + '.png')) as body, Image.open(portrait_base / 'sprites' / (entry['brush'] + '_head.png')) as head, Image.open(portrait_base / 'sprites' / (entry['brush'] + '_dead.png')) as full:
            if Image.alpha_composite(body.convert('RGBA'), head.convert('RGBA')).tobytes() != full.convert('RGBA').tobytes():
                raise ValueError(f"Body/head partition lost pixels: {entry['brush']}")
            point = tuple(entry['neck_guard'])
            if head.getpixel(point) != full.getpixel(point) or head.getpixel(point)[3] < 200:
                raise ValueError(f"Armor would hide the reviewed neck: {entry['brush']}")

    base = ROOT / 'art/runtime/gameplay-v03'
    gameplay = json.loads((base / 'build/report.json').read_text(encoding='utf-8'))
    if gameplay.get('schema_version') != 1 or gameplay.get('atlas_name') != 'afeix_gameplay_v03':
        raise ValueError('Unexpected gameplay art report version or atlas')
    layer_records = gameplay.get('layers', [])
    layer_ids = {record['id'] for record in layer_records}
    if 'afeix_g03_feidie' in layer_ids or len(layer_records) != len(layer_ids):
        raise ValueError('Retired flying saucer must not enter the gameplay atlas')
    small = verify_custom_atlas(base, 'afeix_gameplay_v03', gameplay, layer_ids)
    icons = gameplay.get('icons', [])
    if {icon.get('key') for icon in icons} != {'wawa', 'haoqi', 'quanqian', 'feidie'} or len(icons) != 4:
        raise ValueError('Gameplay art report must cover all four skill icons')
    for icon in icons:
        original = base / 'sources' / (icon['key'] + '.png')
        exported = ROOT / 'src/gfx/skills' / ('afeix_' + icon['key'] + '.png')
        if icon.get('source_sha256') != file_hash(original) or icon.get('sha256') != file_hash(exported):
            raise ValueError(f"Skill icon source/export fingerprint differs: {icon['key']}")
        with Image.open(exported) as image:
            if (image.mode != 'RGBA' or image.size != (56, 56)
                    or image.getchannel('A').getextrema()[0] != 0 or image.getchannel('A').getextrema()[1] == 0):
                raise ValueError(f"Skill icon format/alpha differs: {icon['key']}")
        small['files'][exported.relative_to(ROOT / 'src').as_posix()] = icon['sha256']
    keepsakes = validate_icons()
    return {'passed': True, 'method': 'manifest source hashes + build fingerprints + unpack actual src atlases + compare pixels/anchors',
            'keepsake_icons': keepsakes,
            'member_skill_icons': validate_member_icons(),
            'portrait_forms': 36, 'portrait_brushes': 108, 'retired_disc_absent': True, 'skill_icons': 4,
            'files': {**portrait['files'], **small['files']}}


def run_sq(sq, path, marker):
    result = subprocess.run([str(sq), str(path)], cwd=ROOT, capture_output=True)
    log = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode or marker not in log or re.search(r'AN ERROR HAS OCCUR+ED', log) or 'FAIL ' in log:
        raise RuntimeError(log or f'Squirrel runner exited {result.returncode}')
    return log


def validate(sq, game):
    art_validation = validate_custom_art()
    subprocess.run([sys.executable, str(ROOT / 'tools/render_member_growth.py'), '--check'], check=True)
    scripts = sorted((ROOT / 'src/scripts').rglob('*.nut'))
    if not scripts:
        raise ValueError('No gameplay scripts found')
    work = ROOT / '.cache/afei-art/gameplay-check'
    work.mkdir(parents=True, exist_ok=True)
    runner = work / 'syntax.nut'
    runner.write_text('local failed=0;\n' + '\n'.join(
        'try { loadfile(' + json.dumps(p.as_posix()) + ', true); } catch(e) { print("FAIL ' + p.name + ': "+e+"\\n"); failed++; }'
        for p in scripts) + '\nif(failed==0) print("SYNTAX_PASSED\\n");\n', encoding='utf-8')
    syntax_log = run_sq(sq, runner, 'SYNTAX_PASSED')

    # Export through the real preload path, so the report cannot silently omit
    # a new module or carry an out-of-date hand-maintained roster.
    roster_log = run_sq(sq, ROOT / 'tools/export_gameplay_roster.nut', 'ROSTER_JSON_END').replace('\r\n', '\n')
    roster = json.loads(roster_log.split('ROSTER_JSON_BEGIN\n', 1)[1].split('\nROSTER_JSON_END', 1)[0])
    characters = roster['characters']
    stories = json.loads((ROOT / 'data/character-stories.json').read_text(encoding='utf-8'))['characters']
    if [c['key'] for c in characters] != [s['key'] for s in stories]:
        raise ValueError('Story data must cover every active character in order')
    for character, story in zip(characters, stories):
        if character['name'] != story['name'] or character['description'] != story['description']:
            raise ValueError(f"Story prose is out of sync: {character['key']}; run tools/build_gameplay.py")
        if story['encounter'] is not None:
            encounter = story['encounter']
            if (character['encounterTitle'] != encounter['title'] or character['encounterText'] != encounter['text']
                or [c['label'] for c in character['encounterChoices']] != encounter['labels']
                or [c['outcome'] for c in character['encounterChoices']] != encounter['outcomes']):
                raise ValueError(f"Encounter prose is out of sync: {character['key']}; run tools/build_gameplay.py")
    expected_names = re.findall(r'^\|\s*\d{2}\s*\|\s*([^|]+?)\s*\|',
        (ROOT / 'docs/design/character-roster.md').read_text(encoding='utf-8-sig'), flags=re.M)
    if len(expected_names) != 34 or len(characters) != 34 or [c['name'] for c in characters] != expected_names:
        raise ValueError('Playable roster must match all 34 names in the approved production list, in order')
    if len({c['key'] for c in characters}) != 34 or sum(c['isCaptain'] for c in characters) != 3:
        raise ValueError('Duplicate character identity or incorrect captain count')
    if any(c['key'] == 'yanzi' for c in characters):
        raise ValueError('Retired character yanzi must not appear in the active recruitment catalog')
    if set(roster['encounterRequirements']) != {c['key'] for c in characters if not c['isCaptain']}:
        raise ValueError('Every recruit must have independent hidden encounter conditions')
    if roster['rosterMax'] != 40 or roster['combatMax'] != 10:
        raise ValueError('Capacity must remain forty on the roster and ten in battle')
    for character in characters:
        if len(character['attrs']) != 8 or not all(isinstance(n, int) and n >= 0 for n in character['attrs']):
            raise ValueError(f"Invalid attributes: {character['key']}")
        if not character['equipment'] or len(character['bag']) > 2:
            raise ValueError(f"Invalid starting loadout: {character['key']}")
        if character['chapter'] not in [chapter['id'] for chapter in roster['chapters']]:
            raise ValueError(f"Missing chapter: {character['key']}")
        if not character['isCaptain']:
            choices = character['encounterChoices']
            if len(choices) != 2 or not character['encounterTitle'] or not character['encounterText']:
                raise ValueError(f"Missing encounter: {character['key']}")
            if not any(choice['cost'] == 0 and choice['hireDiscount'] == 0 for choice in choices):
                raise ValueError(f"Encounter needs a no-upfront-cost path: {character['key']}")
            for choice in choices:
                if not choice['label'] or not choice['outcome'] or choice['cost'] < 0 or not 0 <= choice['hireDiscount'] < character['hireCost']:
                    raise ValueError(f"Invalid encounter choice: {character['key']}")

    archives = sorted((game / 'data').glob('data_*.dat'))
    if not archives:
        raise ValueError(f'No native data archives found under {game}')
    available = set()
    for archive in archives:
        with ZipFile(archive) as z:
            available.update(z.namelist())
    source_paths = {p.relative_to(ROOT / 'src').as_posix() for p in (ROOT / 'src').rglob('*') if p.is_file()}
    references = set()
    for path in scripts:
        source = path.read_text(encoding='utf-8-sig')
        for reference in re.findall(r'"((?:scripts|gfx)/[A-Za-z0-9_/!.]+)"', source):
            if reference.endswith('/'):
                continue
            if reference.startswith('scripts/') and not reference.endswith(('.nut', '.cnut')):
                reference += '.cnut'
            references.add(reference)
        for background in re.findall(r'background\s*=\s*"([a-z0-9_]+)"', source):
            references.add('scripts/skills/backgrounds/' + background + '.cnut')
        for item in re.findall(r'"((?:weapons|armor|helmets|shields|ammo|accessory)/[a-z0-9_/]+)"', source):
            references.add('scripts/items/' + item + '.cnut')
        for target in re.findall(r'mods_hook(?:ExactClass|NewObject|BaseClass)\("([a-z0-9_/]+)"', source):
            references.add('scripts/' + target + '.cnut')
        for ui_script in re.findall(r'mods_registerJS\("([a-zA-Z0-9_/.-]+)"', source):
            references.add('ui/mods/' + ui_script)
        for icon in re.findall(r'"((?:skills|ui/icons|ui/traits)/[a-zA-Z0-9_/.-]+\.png)"', source):
            references.add('gfx/' + icon)
    missing = []
    for reference in sorted(references):
        local = reference.removesuffix('.cnut') + '.nut' if reference.endswith('.cnut') else reference
        if reference not in available and local not in source_paths:
            missing.append(reference)
    if missing:
        raise ValueError(f'Missing native or project resource paths: {missing}')

    # Run delivery lifecycle tests against the installed game's actual base
    # contract, including its state dispatch and serialization order.
    native_dir = ROOT / '.cache/afei-art/native-contract-fixture'
    native_dir.mkdir(parents=True, exist_ok=True)
    kit = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'
    with ZipFile(game / 'data/data_001.dat') as archive:
        for source in ['scripts/contracts/contract.cnut',
                       'scripts/skills/skill.cnut',
                       'scripts/entity/world/player_party.cnut',
                       'scripts/states/world/asset_manager.cnut',
                       'scripts/events/event_manager.cnut',
                       'scripts/skills/actives/chop.cnut',
                       'scripts/skills/actives/split_man.cnut',
                       'scripts/skills/actives/rotation.cnut',
                       'scripts/skills/actives/taunt.cnut',
                       'scripts/items/item.cnut',
                       'scripts/ui/screens/world/modules/world_town_screen/town_shop_dialog_module.cnut',
                       'scripts/ui/screens/world/modules/world_town_screen/town_hire_dialog_module.cnut']:
            bytecode = native_dir / Path(source).name
            bytecode.write_bytes(archive.read(source))
            subprocess.run([str(kit / 'bbsq.exe'), '-d', str(bytecode)], check=True, capture_output=True)
            decoded = subprocess.run([str(kit / 'nutcracker.exe'), str(bytecode)], check=True, capture_output=True)
            bytecode.with_suffix('.nut').write_bytes(decoded.stdout)
    tests = []
    for path in sorted((ROOT / 'tests/gameplay').glob('test_*.nut')):
        log = run_sq(sq, path, 'TESTS_PASSED=')
        count = int(re.search(r'TESTS_PASSED=(\d+)', log).group(1))
        tests.append({'file': path.relative_to(ROOT).as_posix(), 'assertions': count, 'log': log})
    if not tests:
        raise ValueError('Gameplay behavioral tests are missing')
    node = shutil.which('node')
    if not node:
        raise ValueError('Node.js is needed to validate the reserve-slot adapter')
    js_paths = sorted((ROOT / 'src/ui').rglob('*.js'))
    for path in js_paths:
        subprocess.run([node, '--check', str(path)], check=True, capture_output=True)
    for path in sorted((ROOT / 'tests/gameplay').glob('test_*.js')):
        result = subprocess.run([node, str(path)], cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
        if result.returncode or 'TESTS_PASSED=' not in result.stdout:
            raise RuntimeError(result.stdout + result.stderr)
        tests.append({'file': path.relative_to(ROOT).as_posix(), 'assertions': int(re.search(r'TESTS_PASSED=(\d+)', result.stdout).group(1)), 'log': result.stdout})
    for path in sorted((ROOT / 'tests/gameplay').glob('test_*.py')):
        result = subprocess.run([sys.executable, str(path)], cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
        if result.returncode or 'TESTS_PASSED=' not in result.stdout:
            raise RuntimeError(result.stdout + result.stderr)
        tests.append({'file': path.relative_to(ROOT).as_posix(), 'assertions': int(re.search(r'TESTS_PASSED=(\d+)', result.stdout).group(1)), 'log': result.stdout})
    report = {
        'syntax_passed': True, 'native_resource_paths_passed': True,
        'behavior_tests_passed': True, 'in_game_tested': False,
        'custom_art': art_validation,
        'roster_matches_production_list': True, 'named_characters': len(characters),
        'roster_capacity': roster['rosterMax'], 'combat_capacity': roster['combatMax'],
        'method': 'Squirrel compile + isolated fake-engine behavior tests + native resource references + JavaScript tests',
        'scripts': [{'path': p.relative_to(ROOT).as_posix(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in scripts],
        'ui_scripts': [{'path': p.relative_to(ROOT).as_posix(), 'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in js_paths],
        'resource_references': sorted(references), 'tests': tests, 'syntax_log': syntax_log,
        'limits': ['No game was launched', 'Native save/load and screen rendering require in-game checks', 'Ten-person enemy balance is not validated'],
    }
    out = ROOT / 'build/gameplay-validation.json'
    out.parent.mkdir(exist_ok=True)
    (out.parent / 'characters.json').write_text(json.dumps(roster, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--sq', type=Path, default=ROOT / '.cache/afei-art/bbros-modkit-v9/bin/sq.exe')
    parser.add_argument('--game', type=Path, default=Path('F:/SteamLibrary/steamapps/common/Battle Brothers'))
    args = parser.parse_args()
    report = validate(args.sq.resolve(), args.game.resolve())
    print(f"PASS: {len(report['scripts'])} Squirrel files; {sum(t['assertions'] for t in report['tests'])} behavior assertions; native paths and JavaScript. In-game testing pending.")


if __name__ == '__main__':
    main()
