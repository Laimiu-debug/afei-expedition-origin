"""Render actual exported Naigai pixels with native equipment for offline review."""
import hashlib
import json
from pathlib import Path
import sys

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from build_portrait_art import export_portrait

OUT = Path(__file__).resolve().parent
BASE = ROOT / 'art/runtime/portraits-v05'
manifest = json.loads((OUT / 'manifest-before.json').read_text(encoding='utf-8'))
entry = next(p for p in manifest['characters'] if p['key'] == 'naigai')['forms'][0].copy()
entry.update(key='naigai', name='奶盖', source='art/runtime/portraits-v05/sources/user-v18/naigai.png')
entry['source_sha256'] = hashlib.sha256((ROOT / entry['source']).read_bytes()).hexdigest()
entry['review_note'] = '按四张用户照片重绘黑色短发与自然眉眼；朝右，透明底，完整下颌和颈部。'
_, report = export_portrait(entry, OUT / 'after')
(OUT / 'export.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
native = ROOT / 'art/runtime/afei/v1/build/preview'
refs = json.loads((native / 'native-reference-sources.json').read_text(encoding='utf-8'))

def piece(canvas, key, sprites=None):
    meta = manifest['geometry']['live'] if sprites else refs[key]
    source = sprites / (key + '.png') if sprites else native / meta['url']
    im = Image.open(source).convert('RGBA')
    left, right, top, bottom = (float(meta[k]) for k in ('left', 'right', 'top', 'bottom'))
    size = (round(right - left), round(bottom - top))
    if im.size != size:
        im = im.resize(size, Image.Resampling.LANCZOS)
    canvas.alpha_composite(im, (57 + round(left), 125 - round(bottom)))

def frame(sprites, armor, helmet):
    canvas = Image.new('RGBA', (114, 170))
    piece(canvas, 'afeix_p04_naigai', sprites)
    if armor:
        piece(canvas, 'bust_body_14')
    piece(canvas, 'afeix_p04_naigai_head', sprites)
    if helmet:
        piece(canvas, helmet)
    return canvas

font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 18)
small = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 14)
title = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 25)
sheet = Image.new('RGB', (1152, 940), '#282720')
d = ImageDraw.Draw(sheet)
d.text((24, 16), '奶盖 · 实际游戏资源 / 照片校正与黑色短发', font=title, fill='#eee3cc')
d.text((24, 56), '114×142 透明精灵 · 原版护甲与头盔锚点离线合成 · 非实机截图', font=font, fill='#d5c7ae')
modes = [('素装', False, None), ('穿甲', True, None), ('开面盔', True, 'bust_helmet_03'), ('全罩盔', True, 'bust_helmet_18')]
for row, phase in enumerate(('before', 'after')):
    y = 95 + row * 345
    d.text((24, y), '更新前' if row == 0 else '新版 · 黑色短发', font=font, fill='#eee3cc')
    for col, (label, armor, helmet) in enumerate(modes):
        x = 24 + col * 282
        im = frame(OUT / phase, armor, helmet)
        im.save(OUT / f'{phase}-{col}.png')
        # Crop only empty diagnostic-stage margins; no sprite pixels are edited.
        zoom = im.crop((0, 63, 114, 170)).resize((228, 214), Image.Resampling.NEAREST)
        sheet.paste(zoom, (x, y + 37), zoom)
        d.text((x + 55, y + 260), label + ' 2×', font=small, fill='#e1cfa7')
        if row == 1:
            one = im.crop((0, 63, 114, 170))
            sheet.paste(one, (x + 55, 797), one)
            d.text((x + 70, 909), '原尺寸 1×', font=small, fill='#e1cfa7')
sheet.save(OUT / 'comparison.png')

# Enlarged coordinates diagnose the jaw/neck split using actual exported pixels.
full = Image.open(OUT / 'after/afeix_p04_naigai_dead.png').convert('RGBA')
detail = Image.new('RGB', (570, 710), '#655e50')
detail.paste(full.resize(detail.size, Image.Resampling.NEAREST), (0, 0), full.resize(detail.size, Image.Resampling.NEAREST))
draw = ImageDraw.Draw(detail)
draw.line([(x * 5, y * 5) for x, y in entry['head_seam']], fill='#00ffff', width=2)
for yy in (100, 110, 120, 130):
    draw.text((5, yy * 5), str(yy), font=small, fill='#ffffff')
detail.save(OUT / 'neck-review.png')
print(json.dumps({'resized_size': report['resized_size'], 'placement': report['placement'], 'split_reconstructs_complete_portrait': report['split_reconstructs_complete_portrait'], 'comparison': str(OUT / 'comparison.png')}, ensure_ascii=False))
