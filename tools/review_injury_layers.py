"""Offline compositing review of native blood overlays on custom portraits."""
import html
import json
from pathlib import Path
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PORTRAITS = ROOT / 'art/runtime/portraits-v05'
NATIVE = ROOT / 'art/runtime/afei/v1/build/preview'
EXTRACTED = ROOT / '.cache/afei-art/vanilla-layer-audit/entity_0'
OUTPUT = ROOT / 'build/injury-review-20260930'


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    refs = json.loads((NATIVE / 'native-reference-sources.json').read_text(encoding='utf-8'))
    blood = next(dict(x.attrib) for x in ET.parse(EXTRACTED / 'metadata.xml').getroot()
                 if x.get('id') == 'bust_body_bloodied_02')
    blood['path'] = EXTRACTED / blood['img'].replace('\\', '/')
    manifest = json.loads((PORTRAITS / 'manifest.json').read_text(encoding='utf-8'))
    entries = [(p['name'], f, PORTRAITS / 'sprites') for p in manifest['characters']
               for f in p['forms'] if p['key'] != 'afei' or f['form'] == 'normal']
    entries.append(('希文（可选DLC）', {'brush': 'afeix_p04_xiwen'},
                    ROOT / 'dlc/xiwen-regen/art/sprites'))
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 14)

    def piece(canvas, path, meta):
        with Image.open(path) as source:
            size = (round(float(meta['right']) - float(meta['left'])),
                    round(float(meta['bottom']) - float(meta['top'])))
            im = source.convert('RGBA').resize(size, Image.Resampling.LANCZOS)
            canvas.alpha_composite(im, (57 + round(float(meta['left'])),
                                       125 - round(float(meta['bottom']))))

    def native(canvas, key):
        piece(canvas, NATIVE / refs[key]['url'], refs[key])

    cards = []
    sheet = Image.new('RGB', (456 * 3, 205 * 12), '#39362f')
    draw = ImageDraw.Draw(sheet)
    for i, (name, entry, sprites) in enumerate(entries):
        samples = []
        for j, (label, hp, helmet) in enumerate([
                ('健康', 100, False), ('轻伤', 90, False),
                ('重伤', 25, False), ('重伤遮脸头盔', 25, True)]):
            im = Image.new('RGBA', (114, 170))
            meta = manifest['geometry']['live']
            piece(im, sprites / (entry['brush'] + '.png'), meta)
            native(im, 'bust_body_14')
            piece(im, sprites / (entry['brush'] + '_head.png'), meta)
            if hp <= 67 and not helmet:
                native(im, 'bust_head_injured_02' if hp <= 33 else 'bust_head_injured_01')
            if helmet:
                native(im, 'bust_helmet_18')
            if hp < 100:
                piece(im, blood['path'], blood)
            filename = entry['brush'] + '-' + str(j) + '.png'
            im.save(OUTPUT / filename)
            x, y = i % 3 * 456 + j * 114, i // 3 * 205
            sheet.paste(im, (x, y + 20), im)
            draw.text((x + 2, y + 186), label, font=font, fill='white')
            samples.append(f'<figure><img src="{filename}"><figcaption>{label}</figcaption></figure>')
        draw.text((i % 3 * 456 + 4, i // 3 * 205), name, font=font, fill='white')
        cards.append('<article><h2>' + html.escape(name) + '</h2>' + ''.join(samples) + '</article>')
    sheet.save(OUTPUT / 'all-members.png')
    # A compact comparison for the chat preview, using the same rendered frames.
    focus = Image.new('RGB', (456, 410), '#39362f')
    draw_focus = ImageDraw.Draw(focus)
    for row, (key, name) in enumerate([('afei_normal', '阿飞'), ('songnuanyang', '宋暖阳')]):
        draw_focus.text((4, row * 205), name, font=font, fill='white')
        for col, label in enumerate(['健康', '轻伤', '重伤', '遮脸头盔']):
            with Image.open(OUTPUT / f'afeix_p04_{key}-{col}.png') as im:
                focus.paste(im, (col * 114, row * 205 + 20), im)
            draw_focus.text((col * 114 + 2, row * 205 + 186), label, font=font, fill='white')
    focus.save(OUTPUT / 'comparison.png')
    (OUTPUT / 'index.html').write_text('<!doctype html><meta charset="utf-8"><title>受伤血迹审阅</title>'
        '<style>body{background:#39362f;color:white;font-family:sans-serif}article{display:inline-block;'
        'margin:12px}figure{display:inline-block;margin:3px}img{width:171px;image-rendering:pixelated}'
        'figcaption{text-align:center}</style><h1>受伤血迹离线审阅</h1>'
        '<p>35人；原版图层和真实brush坐标合成。非游戏内截图；参考图不进入Mod资源包。</p>'
        + ''.join(cards), encoding='utf-8')
    print('Reviewed 34 main portraits + optional Xiwen; 140 frames. ' + str(OUTPUT / 'index.html'))


if __name__ == '__main__':
    main()
