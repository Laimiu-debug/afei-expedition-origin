"""Build the optional DLC against a read-only v0.26+ base checkout.

All scratch files live in this branch's .cache. Never install, publish, or change
the supplied base workspace. Native code is decoded locally for tests only.
"""
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED
import argparse
import hashlib
import importlib
import json
import re
import shutil
import subprocess
import sys
import tempfile

from PIL import Image, ImageDraw, ImageFont

DLC = Path(__file__).resolve().parent
ROOT = DLC.parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(command, cwd):
    result = subprocess.run([str(x) for x in command], cwd=cwd, capture_output=True)
    output = (result.stdout + result.stderr).decode('utf-8', errors='replace')
    if result.returncode or 'AN ERROR HAS OCCUR' in output:
        raise RuntimeError(output)
    return output


def review(base, sprites):
    native = base / 'art/runtime/afei/v1/build/preview'
    refs = json.loads((native / 'native-reference-sources.json').read_text(encoding='utf-8'))
    geometry = dict(left=-57, right=57, top=-51, bottom=91)
    def piece(canvas, key, custom=False):
        meta = geometry if custom else refs[key]
        source = sprites / (key + '.png') if custom else native / meta['url']
        im = Image.open(source).convert('RGBA')
        left, right, top, bottom = (float(meta[k]) for k in ['left', 'right', 'top', 'bottom'])
        size = (round(right-left), round(bottom-top))
        if im.size != size:
            im = im.resize(size, Image.Resampling.LANCZOS)
        canvas.alpha_composite(im, (57+round(left), 125-round(bottom)))
    sheet = Image.new('RGB', (1000, 350), '#302b24')
    draw = ImageDraw.Draw(sheet)
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 19)
    small = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 14)
    draw.text((20, 14), '希文 · DLC 胸像与装备叠加', font=font, fill='#f5e8cd')
    draw.text((20, 46), '按实际画刷锚点离线合成，2× 像素预览；尚未实机验收。', font=small, fill='#cbb998')
    for col, (label, armor, helmet) in enumerate([
        ('素装', False, None), ('护甲', True, None),
        ('开面盔', True, 'bust_helmet_03'), ('全罩盔', True, 'bust_helmet_18')
    ]):
        canvas = Image.new('RGBA', (114, 156))
        piece(canvas, 'afeix_p04_xiwen', True)
        if armor:
            piece(canvas, 'bust_body_14')
        piece(canvas, 'afeix_p04_xiwen_head', True)
        if helmet:
            piece(canvas, helmet)
        enlarged = canvas.crop((0, 46, 114, 156)).resize((228, 220), Image.Resampling.NEAREST)
        sheet.paste(enlarged, (18+247*col, 80), enlarged)
        draw.text((28+247*col, 310), label, font=small, fill='#f5e8cd')
    sheet.save(DLC / 'art/preview.png')


def build_art(base, kit, scratch):
    sys.path.insert(0, str(base / 'tools'))
    portrait = importlib.import_module('build_portrait_art')
    packer = importlib.import_module('build_afei_art')
    portrait.ROOT = ROOT
    portrait.ALLOWED_SOURCE_ROOTS = (DLC / 'art/sources',)
    entry = {
        'key': 'xiwen', 'name': '希文', 'form': 'default', 'brush': 'afeix_p04_xiwen',
        'source': (DLC / 'art/sources/xiwen.png').relative_to(ROOT).as_posix(),
        'source_kind': 'generated_custom',
        'head_seam': [[0, 102], [40, 102], [54, 114], [66, 114], [75, 114], [88, 102], [114, 102]],
        'neck_guard': [62, 112],
        'review_note': 'Reference-photo likeness; intact jaw and neck; native armor and helmet overlays reviewed.'
    }
    art = scratch / 'art'
    sprites = art / 'sprites'
    (art / 'build').mkdir(parents=True)
    attrs, exported = portrait.export_portrait(entry, sprites)
    if len(attrs) != 4:
        raise ValueError('v0.24 four-layer portrait exporter required')
    pack_input = art / 'build/pack-input'
    shutil.copytree(sprites, pack_input / 'sprites')
    packed = packer.pack_and_verify(art, 'afeix_dlc_xiwen_regen', pack_input, attrs, kit / 'bbrusher.exe')
    for relative in ['brushes/afeix_dlc_xiwen_regen.brush', 'gfx/afeix_dlc_xiwen_regen.png']:
        target = DLC / 'src' / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(art / 'package' / relative, target)
    shutil.copytree(sprites, DLC / 'art/sprites', dirs_exist_ok=True)
    review(base, sprites)
    packed.pop('roundtrip_directory', None)
    return {'export': exported, 'roundtrip': packed}


def verify(base, kit, game, scratch):
    sandbox = scratch / 'tests'
    shutil.copytree(base / 'src', sandbox / 'src')
    shutil.copytree(base / 'tests/gameplay', sandbox / 'tests/gameplay')
    fixture = '.cache/afei-art/native-contract-fixture'
    shutil.copytree(base / fixture, sandbox / fixture)
    tests = []
    def test(name, path):
        output = run([kit / 'sq.exe', path], sandbox)
        match = re.search(r'TESTS_PASSED=(\d+)', output)
        if not match:
            raise RuntimeError(output)
        tests.append({'test': name, 'assertions': int(match[1]), 'log': output})
    # Base regression checks run on an isolated copy with no add-on preloaded.
    for name in ['test_native_recruitment', 'test_roster_groups', 'test_appearance', 'test_backgrounds', 'test_endings']:
        test(name, 'tests/gameplay/' + name + '.nut')
    collisions = []
    for p in (DLC / 'src').rglob('*'):
        if p.is_file() and (base / 'src' / p.relative_to(DLC / 'src')).exists():
            collisions.append(p.relative_to(DLC / 'src').as_posix())
    if collisions:
        raise ValueError('DLC must not replace base files: ' + repr(collisions))
    shutil.copytree(DLC / 'src', sandbox / 'src', dirs_exist_ok=True)
    # Exercise Xiwen through native background create/convert/save/load methods.
    background_test = (sandbox / 'tests/gameplay/test_backgrounds.nut').read_text(encoding='utf-8')
    marker = 'local A=::AfeixExpedition, checks=0;'
    if background_test.count(marker) != 1:
        raise ValueError('Background fixture setup changed; review the DLC adapter')
    background_test = background_test.replace(marker, marker + '\ndofile("src/scripts/mods/afeix_dlc_xiwen_regen/content.nut");', 1)
    (sandbox / 'backgrounds-dlc.nut').write_text(background_test, encoding='utf-8')
    test('dlc_native_background_persistence', 'backgrounds-dlc.nut')
    native_dir = sandbox / 'native'
    native_dir.mkdir()
    with ZipFile(game / 'data/data_001.dat') as archive:
        for key in ['wardog_item', 'unleash_wardog']:
            source = {'wardog_item': 'scripts/items/accessory/wardog_item.cnut',
                      'unleash_wardog': 'scripts/skills/actives/unleash_wardog.cnut'}[key]
            bytecode = native_dir / (key + '.cnut')
            bytecode.write_bytes(archive.read(source))
            run([kit / 'bbsq.exe', '-d', bytecode], sandbox)
            decoded = run([kit / 'nutcracker.exe', bytecode], sandbox)
            bytecode.with_suffix('.nut').write_text(decoded, encoding='utf-8')
        for path in ['weapons/shortsword', 'shields/buckler_shield', 'armor/thick_tunic', 'accessory/wardog_item']:
            if 'scripts/items/' + path + '.cnut' not in archive.namelist():
                raise ValueError('Missing native equipment: ' + path)
    source = (sandbox / 'tests/gameplay/test_native_recruitment.nut').read_text(encoding='utf-8')
    marker = 'reset();\nlocal ordinary=brother();'
    if source.count(marker) != 1:
        raise ValueError('Native recruitment fixture setup changed; review the fixture adapter')
    setup = source.split(marker)[0]
    (sandbox / 'recruitment.nut').write_text(setup + '\n' + (DLC / 'tests/recruitment.nut').read_text(encoding='utf-8'), encoding='utf-8')
    test('dlc_native_recruitment_and_start', 'recruitment.nut')
    keepsakes = (sandbox / 'tests/gameplay/test_keepsakes.nut').read_text(encoding='utf-8')
    marker = 'reset();A.ensureStoryItems();local afei='
    if keepsakes.count(marker) != 1:
        raise ValueError('Keepsake fixture setup changed; review the startup adapter')
    (sandbox / 'start.nut').write_text(keepsakes.split(marker)[0] + '\n' +
                                     (DLC / 'tests/start.nut').read_text(encoding='utf-8'), encoding='utf-8')
    test('dlc_real_origin_with_electronic_cigarette', 'start.nut')
    shutil.copy2(DLC / 'tests/pet.nut', sandbox / 'pet.nut')
    test('dlc_native_pet_lifecycle', 'pet.nut')
    # A compiler can exit zero on a Squirrel error, so also check its output.
    scripts = sorted((DLC / 'src').rglob('*.nut'))
    for p in scripts:
        run([kit / 'sq.exe', '-c', '-o', sandbox / 'compile.cnut', p], sandbox)
    return {'tests': tests, 'scripts_compiled': len(scripts), 'base_path_collisions': collisions,
            'native_equipment_paths_passed': True, 'in_game_tested': False}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--base', type=Path, required=True, help='Read-only current base mod checkout (v0.26+)')
    parser.add_argument('--kit', type=Path, help='Local bbros-modkit-v9/bin; defaults to --base/.cache/afei-art/...')
    parser.add_argument('--game', type=Path, default=Path('F:/SteamLibrary/steamapps/common/Battle Brothers'))
    args = parser.parse_args()
    base = args.base.resolve()
    kit = (args.kit or base / '.cache/afei-art/bbros-modkit-v9/bin').resolve()
    preload = base / 'src/scripts/!mods_preload/mod_afeix_expedition.nut'
    version = re.search(r'Version\s*=\s*(\d+)', preload.read_text(encoding='utf-8'))
    if not version or int(version[1]) < 36:
        raise ValueError('This DLC needs the current v0.26+ base, not the older committed main snapshot.')
    cache = ROOT / '.cache'
    cache.mkdir(exist_ok=True)
    scratch = Path(tempfile.mkdtemp(prefix='xiwen-regen-', dir=cache))
    art = build_art(base, kit, scratch)
    validation = verify(base, kit, args.game.resolve(), scratch)
    files = sorted(p for p in (DLC / 'src').rglob('*') if p.is_file())
    if any(p.suffix not in {'.nut', '.png', '.brush'} for p in files):
        raise ValueError('Unexpected package file type')
    destination = DLC / 'dist/mod_afeix_dlc_xiwen_regen v0.2.5.zip'
    destination.parent.mkdir(exist_ok=True)
    with ZipFile(destination, 'w', compression=ZIP_DEFLATED) as archive:
        for p in files:
            info = ZipInfo(p.relative_to(DLC / 'src').as_posix(), (2026, 9, 28, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            archive.writestr(info, p.read_bytes())
    with ZipFile(destination) as archive:
        if archive.testzip() or any(archive.read(p.relative_to(DLC / 'src').as_posix()) != p.read_bytes() for p in files):
            raise ValueError('DLC ZIP validation failed')
    report = {'version': '0.2.5-dlc', 'minimum_base': '0.26.2 / internal 36',
              'base_preload_sha256': sha(preload),
              'base_package_sha256': sha(base / ('dist/mod_afeix_expedition v'+(base/'VERSION').read_text().strip()+'.zip')),
              'package_sha256': sha(destination), 'crc_and_source_match': True,
              'entries': [p.relative_to(DLC / 'src').as_posix() for p in files],
              'art': art, 'validation': validation}
    (DLC / 'report.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('PASS: %d assertions, %d DLC scripts, %d package files. In-game verification pending.' % (
        sum(t['assertions'] for t in validation['tests']), validation['scripts_compiled'], len(files)))
    print(destination)


if __name__ == '__main__':
    main()
