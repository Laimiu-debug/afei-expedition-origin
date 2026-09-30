"""Bake existing living wound layers into the same prone head transform.

This is deterministic brush conversion, not a repaint of character portraits.
Native wound pixels are reused at their original brush coordinates, clipped to
the custom head, then transformed together with it for UI and tile rendering.
"""
import hashlib
import json
from pathlib import Path
import shutil
import tempfile
import xml.etree.ElementTree as ET
from PIL import Image, ImageChops
from build_portrait_art import BASE as PORTRAITS, CORPSE_RECT, prone_head, read_manifest
from build_afei_art import pack_and_verify

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/corpse-injuries-v01'
ATLAS = 'afeix_corpse_injuries_v01'
DLC_BASE = ROOT / 'dlc/xiwen-regen/art/corpse-injuries-v01'
DLC_ATLAS = 'afeix_dlc_xiwen_corpse_injuries_v01'
NATIVE = ROOT / '.cache/afei-art/vanilla-layer-audit/entity_0'
KIT = ROOT / '.cache/afei-art/bbros-modkit-v9/bin'
SUFFIXES = ['_corpse_head_bloodied', '_corpse_head_injured_01', '_corpse_head_injured_02']


def native_layers():
    metadata = {s.get('id'): dict(s.attrib) for s in ET.parse(NATIVE / 'metadata.xml').getroot()}
    result, sources = {}, []
    for identity in ['bust_body_bloodied_02', 'bust_head_injured_01', 'bust_head_injured_02']:
        meta = metadata[identity]
        path = NATIVE / meta['img'].replace('\\', '/')
        with Image.open(path) as original:
            im = original.convert('RGBA').resize(
                (round(float(meta['right']) - float(meta['left'])),
                 round(float(meta['bottom']) - float(meta['top']))), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (114, 142))
        canvas.alpha_composite(im, (57 + round(float(meta['left'])), 91 - round(float(meta['bottom']))))
        result[identity] = canvas
        sources.append(dict(brush=identity, metadata=meta,
                            sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
    return result, sources


def wounded_head(head, overlays, level):
    # Living order: head, facial injury, body blood. Preserve the head silhouette.
    result = head.copy()
    names = ([] if level == 0 else [f'bust_head_injured_0{level}']) + ['bust_body_bloodied_02']
    for name in names:
        overlay = overlays[name].copy()
        overlay.putalpha(ImageChops.multiply(overlay.getchannel('A'), head.getchannel('A')))
        result = Image.alpha_composite(result, overlay)
    return result


def entries():
    _, ready, missing = read_manifest()
    if missing:
        raise ValueError('Incomplete source portraits')
    selected = [(entry, PORTRAITS / 'sprites') for entry in ready
                if entry['key'] != 'afei' or entry['form'] == 'normal']
    selected.append((dict(key='xiwen', brush='afeix_p04_xiwen', neck_guard=[62,112]),
                     ROOT / 'dlc/xiwen-regen/art/sprites'))
    assert len(selected) == 35 and len({e['key'] for e, _ in selected}) == 35
    return selected


def build():
    BASE.mkdir(parents=True, exist_ok=True)
    (BASE / 'build').mkdir(exist_ok=True)
    sprites = BASE / 'sprites'
    sprites.mkdir(exist_ok=True)
    overlays, sources = native_layers()
    records, attrs = [], []
    for entry, original in entries():
        path = original / (entry['brush'] + '_head.png')
        with Image.open(path) as image:
            head = image.convert('RGBA')
        with Image.open(original / (entry['brush'] + '_corpse_head.png')) as clean:
            assert clean.convert('RGBA').tobytes() == prone_head(head, entry).tobytes(), entry['key']
        for level, suffix in enumerate(SUFFIXES):
            identity = entry['brush'] + suffix
            fallen = prone_head(wounded_head(head, overlays, level), entry)
            folder = DLC_BASE / 'sprites' if entry['key'] == 'xiwen' else sprites
            folder.mkdir(parents=True, exist_ok=True)
            destination = folder / (identity + '.png')
            fallen.save(destination)
            assert fallen.tobytes() != prone_head(head, entry).tobytes(), identity
            attrs.append(dict(id=identity, img='sprites\\' + identity + '.png',
                              **{k: str(v) for k, v in CORPSE_RECT.items()}))
            records.append(dict(id=identity, key=entry['key'], level=level,
                                head_source=path.relative_to(ROOT).as_posix(),
                                head_source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                                neck_guard=entry['neck_guard'],
                                png_sha256=hashlib.sha256(destination.read_bytes()).hexdigest()))
    for optional, base, atlas, target in [(False, BASE, ATLAS, ROOT / 'src'),
            (True, DLC_BASE, DLC_ATLAS, ROOT / 'dlc/xiwen-regen/src')]:
        (base / 'build').mkdir(parents=True, exist_ok=True)
        subset = [r for r in records if (r['key'] == 'xiwen') == optional]
        ids = {r['id'] for r in subset}
        metadata = [a for a in attrs if a['id'] in ids]
        with tempfile.TemporaryDirectory(prefix='corpse-wounds-', dir=ROOT / '.cache') as temporary:
            pack_input = Path(temporary)
            (pack_input / 'sprites').mkdir()
            for identity in ids:
                shutil.copy2(base / 'sprites' / (identity + '.png'), pack_input / 'sprites')
            roundtrip = pack_and_verify(base, atlas, pack_input, metadata, KIT / 'bbrusher.exe')
        files = ['brushes/' + atlas + '.brush', 'gfx/' + atlas + '.png']
        for relative in files:
            shutil.copy2(base / 'package' / relative, target / relative)
        report = dict(atlas_name=atlas, sprite_count=len(subset), records=subset,
                      roundtrip=roundtrip, files=files, native_sources=sources,
                      uses_native_wound_pixels=True, portraits_repainted=False,
                      in_game_tested=False)
        (base / 'build/report.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    # Remove only the three obsolete generated DLC files from the initial
    # combined export; Xiwen artwork remains exclusively in its add-on.
    for suffix in SUFFIXES:
        obsolete = sprites / ('afeix_p04_xiwen' + suffix + '.png')
        if obsolete.exists():
            obsolete.unlink()
    print('35 heads x 3 wound states; 105 sprites packed and verified.')


if __name__ == '__main__':
    build()
