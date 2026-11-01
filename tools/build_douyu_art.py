"""Export reviewed Douyu artwork at native game sizes without repainting it.

Only alpha crop, uniform downsampling and transparent placement are performed.
Native monster references inform the review but are never shipped in the atlas.
"""
from pathlib import Path
import hashlib
import json
import shutil

from PIL import Image, ImageDraw
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/douyu-v01'
ATLAS = 'afeix_douyu_v01'
BBRUSHER = ROOT / '.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe'
GEOMETRY = {
    'afeix_douyu_body': {'left': -90, 'right': 90, 'top': -60, 'bottom': 130,
                         'width': 200, 'height': 240, 'offsetY': 35},
    'afeix_douyu_dead': {'left': -90, 'right': 90, 'top': -38, 'bottom': 78,
                         'width': 200, 'height': 150, 'offsetY': 10},
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source(key):
    manifest = json.loads((BASE / 'manifest.json').read_text(encoding='utf-8'))
    record = manifest['sources'][key]
    path = (BASE / record['source']).resolve()
    if not path.is_relative_to((BASE / 'sources').resolve()):
        raise ValueError('Artwork source must be under sources/')
    if not record['reviewed_for_export'] or sha(path) != record['sha256']:
        raise ValueError('Unreviewed or changed artwork: ' + key)
    with Image.open(path) as original:
        alpha = original.getchannel('A').getextrema() if original.mode == 'RGBA' else (255, 255)
        if original.mode != 'RGBA' or alpha[0] != 0 or alpha[1] < 200:
            raise ValueError('Generated source must contain genuine transparent alpha: ' + key)
        image = original.copy()
    box = image.getchannel('A').point(lambda a: 255 if a >= 20 else 0).getbbox()
    if box is None:
        raise ValueError('Empty artwork: ' + key)
    return image.crop(box)


def fit(image, size, padding=2):
    result = Image.new('RGBA', size)
    scaled = image.copy()
    scaled.thumbnail((size[0] - 2 * padding, size[1] - 2 * padding), Image.Resampling.LANCZOS)
    result.alpha_composite(scaled, ((size[0] - scaled.width) // 2, (size[1] - scaled.height) // 2))
    return result


def exports():
    for key in ('mark', 'barrage', 'rocket'):
        yield f'gfx/skills/afeix_douyu_{key}.png', fit(source(key), (56, 56), 1)
    yield 'gfx/ui/events/afeix_douyu.png', fit(source('body'), (210, 210), 3)


def build_art():
    records = []
    for relative, image in exports():
        path = ROOT / 'src' / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        image.save(path)
        records.append({'path': relative, 'sha256': sha(path), 'size': list(image.size)})
    pack = BASE / 'pack'
    (pack / 'sprites').mkdir(parents=True, exist_ok=True)
    (BASE / 'sprites').mkdir(exist_ok=True)
    (BASE / 'build').mkdir(exist_ok=True)
    attrs = []
    for identity, geometry in GEOMETRY.items():
        key = 'body' if identity.endswith('_body') else 'dead'
        size = (geometry['right'] - geometry['left'], geometry['bottom'] - geometry['top'])
        sprite = fit(source(key), size)
        sprite.save(BASE / 'sprites' / f'{identity}.png')
        sprite.save(pack / 'sprites' / f'{identity}.png')
        attrs.append({'id': identity, 'img': f'sprites\\{identity}.png',
                      **{k: str(v) for k, v in geometry.items()}})
    report = {'manifest_sha256': sha(BASE / 'manifest.json'), 'exports': records,
              'geometry': GEOMETRY, 'source_art_reviewed': True, 'in_game_tested': False,
              'roundtrip': pack_and_verify(BASE, ATLAS, pack, attrs, BBRUSHER)}
    for relative in (f'brushes/{ATLAS}.brush', f'gfx/{ATLAS}.png'):
        destination = ROOT / 'src' / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(BASE / 'package' / relative, destination)
    (BASE / 'report.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    preview = Image.new('RGB', (720, 320), '#b7ae98')
    draw = ImageDraw.Draw(preview)
    draw.text((15, 12), 'OFFLINE ART REVIEW - native sprite sizes, not an in-game screenshot', fill='#302923')
    for x, key in ((30, 'body'), (260, 'dead')):
        image = Image.open(BASE / 'sprites' / f'afeix_douyu_{key}.png').convert('RGBA')
        preview.paste(image, (x, 50), image)
        draw.text((x, 250), f'{key}: {image.width}x{image.height}px', fill='#302923')
    for index, key in enumerate(('mark', 'barrage', 'rocket')):
        image = Image.open(ROOT / 'src/gfx/skills' / f'afeix_douyu_{key}.png').convert('RGBA')
        preview.paste(image, (530, 55 + index * 75), image)
        draw.text((594, 75 + index * 75), key, fill='#302923')
    preview.save(BASE / 'preview.png')
    return report


def validate_art():
    from check_gameplay import verify_custom_atlas, verify_sprite
    report = json.loads((BASE / 'report.json').read_text(encoding='utf-8'))
    if report['manifest_sha256'] != sha(BASE / 'manifest.json'):
        raise ValueError('Douyu manifest changed after export')
    expected = dict(exports())
    if set(expected) != {row['path'] for row in report['exports']}:
        raise ValueError('Douyu export set differs')
    for row in report['exports']:
        path = ROOT / 'src' / row['path']
        with Image.open(path) as image:
            if image.mode != 'RGBA' or image.size != expected[row['path']].size or image.tobytes() != expected[row['path']].tobytes():
                raise ValueError('Douyu exported pixels differ: ' + row['path'])
        if sha(path) != row['sha256']:
            raise ValueError('Douyu export fingerprint differs')
    atlas = verify_custom_atlas(BASE, ATLAS, report, set(GEOMETRY))
    for identity, geometry in GEOMETRY.items():
        verify_sprite(atlas['sprites'][identity], BASE / 'sprites' / f'{identity}.png', geometry)
    return {'passed': True, 'files': len(expected) + 2, 'brushes': len(GEOMETRY),
            'generated_source_art': True, 'in_game_tested': False}


if __name__ == '__main__':
    build_art()
    print(validate_art())
