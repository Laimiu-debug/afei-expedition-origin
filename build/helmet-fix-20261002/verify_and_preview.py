"""Offline reproduction using the original game's shallow-cap sprites."""
from pathlib import Path
import importlib.util
import json
import sys
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / 'tools'))
from build_portrait_art import read_manifest, BASE as PORTRAITS
from build_helmet_layers import split_layers

spec = importlib.util.spec_from_file_location('before_masks', HERE / 'before/tools/build_helmet_layers.py')
old = importlib.util.module_from_spec(spec)
spec.loader.exec_module(old)
before = json.loads((HERE / 'before/art/runtime/helmet-layers-v01/contours.json').read_text(encoding='utf-8'))
after = json.loads((ROOT / 'art/runtime/helmet-layers-v01/contours.json').read_text(encoding='utf-8'))
_, entries, _ = read_manifest()
entries = [e for e in entries if e['key'] in after['faces'] and e['form'] not in ('jiahao', 'toad')]
native = ROOT / '.cache/afei-art/vanilla-layer-audit/entity_0'
metadata = {n.get('id'): n.attrib for n in ET.parse(native / 'metadata.xml').getroot().iter() if n.get('id')}

def piece(frame, identity, origin=125):
    meta = metadata[identity]
    image = Image.open(native / meta['img'].replace('\\', '/')).convert('RGBA')
    image = image.resize((round(float(meta['right']) - float(meta['left'])),
                          round(float(meta['bottom']) - float(meta['top']))), Image.Resampling.LANCZOS)
    frame.alpha_composite(image, (57 + round(float(meta['left'])), origin - round(float(meta['bottom']))))

def render(entry, is_old, helmet):
    body, head, hair = old.split_layers(entry, before) if is_old else split_layers(entry, after)
    frame = Image.new('RGBA', (114, 170))
    frame.alpha_composite(body, (0, 34))
    piece(frame, 'bust_body_14')
    frame.alpha_composite(head, (0, 34))
    if helmet:
        piece(frame, helmet)
    else:
        frame.alpha_composite(hair, (0, 34))
    return frame

report = {'method': 'Offline native hood/cap composition; no game launched', 'portraits': []}
for entry in entries:
    row = {'key': entry['key'], 'before_forehead_holes': 0, 'after_forehead_holes': 0}
    for is_old, field in [(True, 'before_forehead_holes'), (False, 'after_forehead_holes')]:
        frame = render(entry, is_old, 'bust_helmet_21')
        row[field] = sum(frame.getpixel((x, y + 34))[3] < 200 for x in [62, 66, 70] for y in range(63, 91))
    assert row['after_forehead_holes'] == 0, row
    report['portraits'].append(row)
report['characters_with_gap_before'] = sum(r['before_forehead_holes'] > 0 for r in report['portraits'])
report['characters_with_gap_after'] = 0
(HERE / 'shallow-cap-verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

focus = ['damou', 'yanzi', 'xiaohani', 'bottle']
font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 16)
labels = ['旧版兜帽', '新版兜帽', '旧版绗缝帽', '新版绗缝帽']
canvas = Image.new('RGB', (4 * 238, len(focus) * 260 + 34), '#596347')
draw = ImageDraw.Draw(canvas)
for column, label in enumerate(labels):
    draw.text((column * 238 + 40, 7), label, font=font, fill='white')
for row, key in enumerate(focus):
    entry = next(e for e in entries if e['key'] == key)
    for column, (is_old, helmet) in enumerate([(True, 'bust_helmet_19'), (False, 'bust_helmet_19'),
                                              (True, 'bust_helmet_21'), (False, 'bust_helmet_21')]):
        frame = render(entry, is_old, helmet).resize((228, 340), Image.Resampling.NEAREST).crop((0, 90, 228, 340))
        canvas.paste(frame, (column * 238, row * 260 + 44), frame)
    draw.text((4, row * 260 + 32), key, font=font, fill='#faf3dc')
canvas.save(HERE / 'before-after.png')
print(f"33 shallow-cap checks passed; {report['characters_with_gap_before']} old forehead gaps reproduced and removed.")
