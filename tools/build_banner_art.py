"""Export generated toad cloth at the native banner pivots and UI sizes."""
import hashlib
import json
import shutil
import tempfile
from pathlib import Path
from PIL import Image
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/banner-v25'
ATLAS = 'afeix_banner_v25'
SOURCES = {
    '': 'sources/toad-banner.png',
    '_front': 'variants/01-toad-front.png',
    '_profile': 'variants/02-toad-profile.png',
    '_medallion': 'variants/03-toad-medallion.png',
    '_golden': 'variants/04-golden-angel.png',
}
RECTS = {}
for suffix in SOURCES:
    RECTS['banner_afeix_toad' + suffix] = {
        'left': -28, 'right': 28, 'top': -38, 'bottom': 40,
        'width': 56, 'height': 90, 'offsetX': -3, 'offsetY': 28}
    RECTS['afeix_toad_standard' + suffix] = {
        'left': -62, 'right': 52, 'top': -32, 'bottom': 106,
        'width': 200, 'height': 300, 'offsetY': 35}


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def export_variant(suffix, relative):
    source = Image.open(BASE / relative).convert('RGBA')
    if source.getchannel('A').getextrema() != (0, 255):
        raise ValueError('Generated banner must preserve transparent alpha')
    source = source.crop(source.getchannel('A').getbbox())
    def fit(size, tilt=False):
        img = source.copy()
        if tilt:
            img = img.rotate(15, expand=True, resample=Image.Resampling.BICUBIC)
        img.thumbnail(size, Image.Resampling.LANCZOS)
        result = Image.new('RGBA', size)
        result.alpha_composite(img, ((size[0]-img.width)//2, (size[1]-img.height)//2))
        return result
    return {
        f'sprites/banner_afeix_toad{suffix}.png': fit((56, 78)),
        f'sprites/afeix_toad_standard{suffix}.png': fit((114, 138), True),
        f'gfx/ui/banners/banner_afeix_toad{suffix}.png': fit((250, 401)),
        f'gfx/ui/banners/banner_afeix_toad{suffix}s.png': fit((90, 148)),
        **{f'gfx/{folder}/weapons/{name}.png': fit(size, True)
           for folder in ('items', 'ui/items')
           for name, size in [(f'afeix_toad_banner{suffix}', (140, 140)), (f'afeix_toad_banner{suffix}_70x70', (70, 70))]},
    }


def exports():
    return {name: image for suffix, relative in SOURCES.items()
            for name, image in export_variant(suffix, relative).items()}


def build_art():
    images = exports()
    cache = ROOT / '.cache/banner-v25'
    cache.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='pack-', dir=cache) as tmp:
        stage = Path(tmp)
        (stage / 'sprites').mkdir()
        (stage / 'build').mkdir()
        (stage / 'pack/sprites').mkdir(parents=True)
        attrs = []
        for identity, rect in RECTS.items():
            path = stage / 'sprites' / (identity + '.png')
            images['sprites/' + path.name].save(path)
            shutil.copyfile(path, stage / 'pack/sprites' / path.name)
            attrs.append({'id': identity, 'img': 'sprites\\' + path.name, **{k: str(v) for k, v in rect.items()}})
        roundtrip = pack_and_verify(stage, ATLAS, stage / 'pack', attrs, ROOT / '.cache/afei-art/bbros-modkit-v9/bin/bbrusher.exe')
        roundtrip.pop('roundtrip_directory', None)
        shutil.copytree(stage / 'package', BASE / 'package', dirs_exist_ok=True)
    files = []
    for relative, img in images.items():
        path = BASE / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        img.save(path)
        if relative.startswith('gfx/'):
            dest = ROOT / 'src' / relative
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, dest)
            files.append(dest)
    for relative in [f'brushes/{ATLAS}.brush', f'gfx/{ATLAS}.png']:
        dest = ROOT / 'src' / relative
        shutil.copyfile(BASE / 'package' / relative, dest)
        files.append(dest)
    report = {'sources': {relative: sha(BASE / relative) for relative in SOURCES.values()}, 'roundtrip': roundtrip,
              'geometry': RECTS, 'files': {p.relative_to(ROOT / 'src').as_posix(): sha(p) for p in files},
              'native_art_packaged': False, 'in_game_tested': False}
    (BASE / 'report.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    return files


def validate_art():
    from check_gameplay import verify_custom_atlas, verify_sprite
    report = json.loads((BASE / 'report.json').read_text(encoding='utf-8'))
    if report['sources'] != {relative: sha(BASE / relative) for relative in SOURCES.values()}:
        raise ValueError('Banner source changed after build')
    atlas = verify_custom_atlas(BASE, ATLAS, report, set(RECTS))
    for relative, expected in exports().items():
        path = BASE / relative if relative.startswith('sprites/') else ROOT / 'src' / relative
        with Image.open(path) as img:
            if img.mode != 'RGBA' or img.size != expected.size or img.tobytes() != expected.tobytes():
                raise ValueError('Banner export mismatch: ' + relative)
    for identity, rect in RECTS.items():
        verify_sprite(atlas['sprites'][identity], BASE / 'sprites' / (identity + '.png'), rect)
    for relative, expected in report['files'].items():
        if sha(ROOT / 'src' / relative) != expected:
            raise ValueError('Banner package mismatch: ' + relative)
    return {'passed': True, 'brushes': len(RECTS), 'files': report['files']}


if __name__ == '__main__':
    build_art()
    print(validate_art())
