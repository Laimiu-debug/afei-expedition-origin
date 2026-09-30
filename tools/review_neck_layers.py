"""Diagnostic only: show native armor against each exported head/neck boundary."""
import json
import html
import subprocess
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v05'
font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 14)
manifest = json.loads((BASE / 'manifest.json').read_text(encoding='utf-8'))
forms = [(p['name'], v) for p in manifest['characters'] for v in p['forms']
         if p['key'] != 'afei' or v['form'] == 'normal']
out = Image.new('RGB', (6 * 240, 6 * 325), '#39362f')
before = ROOT / 'build/art-review-20260930/before'
before.mkdir(parents=True, exist_ok=True)
for _, entry in forms:
    for suffix in ('', '_head'):
        filename = entry['brush'] + suffix + '.png'
        path = before / filename
        if not path.exists():
            path.write_bytes(subprocess.check_output(['git', 'show', 'HEAD:art/runtime/portraits-v05/sprites/' + filename], cwd=ROOT))
draw = ImageDraw.Draw(out)
for i, (name, entry) in enumerate(forms):
    x, y = i % 6 * 240, i // 6 * 325
    im = Image.open(BASE / 'sprites' / (entry['brush'] + '_dead.png')).convert('RGBA')
    out.paste(im.resize((228, 284), Image.Resampling.NEAREST), (x + 6, y + 25), im.resize((228, 284), Image.Resampling.NEAREST))
    draw.text((x + 6, y + 2), name + ' ' + entry['form'], font=font, fill='white')
    for line, color in [(102, '#ff7733'), (110, '#00ffff'), (118, '#ffff33')]:
        draw.line((x + 6, y + 25 + line * 2, x + 232, y + 25 + line * 2), fill=color)
        draw.text((x + 7, y + 25 + line * 2 - 14), str(line), font=font, fill=color)
target = ROOT / 'build/playtest-neck/landmark-review.png'
target.parent.mkdir(parents=True, exist_ok=True)
out.save(target)
print(target)

native = ROOT / 'art/runtime/afei/v1/build/preview'
refs = json.loads((native / 'native-reference-sources.json').read_text(encoding='utf-8'))

def piece(canvas, key, custom=False, old=False):
    if custom:
        meta = manifest['geometry']['live']
        source = (before if old else BASE / 'sprites') / (key + '.png')
    else:
        meta = refs[key]
        source = native / meta['url']
    im = Image.open(source).convert('RGBA')
    left, right, top, bottom = (float(meta[k]) for k in ('left', 'right', 'top', 'bottom'))
    size = (round(right-left), round(bottom-top))
    if im.size != size:
        im = im.resize(size, Image.Resampling.LANCZOS)
    canvas.alpha_composite(im, (57 + round(left), 125 - round(bottom)))

def frame(brush, armor=False, helmet=None, old=False):
    canvas = Image.new('RGBA', (114, 170))
    piece(canvas, brush, True, old)
    if armor:
        piece(canvas, 'bust_body_14')
    piece(canvas, brush + '_head', True, old)
    if helmet:
        piece(canvas, helmet)
    return canvas

comparison = Image.new('RGB', (4 * 348, 9 * 205), '#39362f')
draw = ImageDraw.Draw(comparison)
for i, (name, entry) in enumerate(forms):
    x, y = i % 4 * 348, i // 4 * 205
    draw.text((x+4,y+2), name + ' ' + entry['form'], font=font, fill='white')
    for col, (old, armor, label) in enumerate([(True, True, '旧版穿甲'), (False, False, '新版素装'), (False, True, '新版穿甲')]):
        im = frame(entry['brush'], armor, old=old)
        comparison.paste(im, (x+col*114,y+22), im)
        draw.text((x+col*114+5,y+183), label, font=font, fill='#e3d3ac')
comparison.save(target.parent / 'all-members-before-after.png')

focus = ['xiaoyueya','xiaogui','tiantong','yaoyaoya','meiya']
selected = [next((n,e) for n,e in forms if e['brush']=='afeix_p04_'+key) for key in focus]
sheet = Image.new('RGB', (len(focus) * 228, 445), '#39362f')
draw = ImageDraw.Draw(sheet)
for i,(name,entry) in enumerate(selected):
    draw.text((i*228+8,8), name, font=font, fill='white')
    full = Image.open(BASE / 'sprites' / (entry['brush']+'_dead.png')).convert('RGBA')
    full = full.resize((228,284),Image.Resampling.NEAREST)
    sheet.paste(full,(i*228,15),full)
    for j,(old,label) in enumerate([(True,'旧版穿甲'),(False,'新版穿甲')]):
        im=frame(entry['brush'],True,old=old)
        sheet.paste(im,(i*228+j*114,272),im)
        draw.text((i*228+j*114+5,425),label,font=font,fill='#e3d3ac')
sheet.save(target.parent / 'five-member-preview.png')
print(target.parent / 'all-members-before-after.png')
print(target.parent / 'five-member-preview.png')

# An offline review page, using the real exported sprite anchors. Reference
# equipment remains in build/, never in the distributed custom-art atlas.
frames = target.parent / 'frames'
frames.mkdir(exist_ok=True)
cards = []
for name, entry in forms:
    brush = entry['brush']
    variants = [('old', True, None, True), ('plain', False, None, False),
                ('armor', True, None, False), ('open', True, 'bust_helmet_03', False),
                ('closed', True, 'bust_helmet_18', False)]
    samples = []
    for mode, armor, helmet, old in variants:
        path = frames / (brush + '-' + mode + '.png')
        frame(brush, armor, helmet, old).save(path)
        samples.append(f'<img class="sample {mode}" src="frames/{path.name}" alt="{html.escape(name)}">')
    cards.append('<article><h2>'+html.escape(name+' '+entry['form'])+'</h2><div class="stage">'+''.join(samples)+'</div></article>')
page = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>阿飞远征团 v0.12 人物检查</title>
<style>body{background:#211e19;color:#eee5d5;font:16px/1.6 system-ui;margin:24px}h1{font-size:24px}p{max-width:1000px}.controls{position:sticky;top:0;background:#211e19;padding:12px 0;z-index:1}button{padding:9px 14px;margin:4px;background:#56432d;color:white;border:1px solid #b49868;cursor:pointer}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(230px,1fr));gap:12px}article{background:#39362f;border:1px solid #69573b;padding:12px}h2{font-size:16px;margin:0}.stage{height:340px}.sample{display:none;width:228px;height:340px;image-rendering:pixelated}body[data-mode=plain] .plain,body[data-mode=armor] .armor,body[data-mode=open] .open,body[data-mode=closed] .closed,body[data-mode=old] .old{display:block}</style>
<body data-mode="armor"><h1>2026-09-30 · 全员颈部与护甲分层修复</h1><p>离线按游戏画刷锚点合成，2× 显示方便检查；并非实机截图。武器、动画和每一种头盔的遮挡仍以实机为准。旧版按钮展示本次修改前的已提交贴图，新版维持同一游戏尺寸。</p><div class="controls">'''
for mode, label in [('old','旧版穿甲'),('plain','新版素装'),('armor','新版穿甲'),('open','开面头盔'),('closed','全罩头盔')]:
    page += f'<button onclick="document.body.dataset.mode=\'{mode}\'">{label}</button>'
page += '</div><div class="grid">'+''.join(cards)+'</div></body></html>'
(target.parent / 'index.html').write_text(page,encoding='utf-8')
