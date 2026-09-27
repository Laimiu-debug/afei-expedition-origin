"""Make diagnostic comparisons; only crop/scale existing photos and art."""
from pathlib import Path
import html
import json
import os
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v05'
OUT = BASE / 'review'
PROMPT_FILES = ['PROMPTS-root-selected.json', 'PROMPTS-group-a-root.json', 'PROMPTS-group-b.json',
                'PROMPTS-group-missing.json', 'PROMPTS-supplement.json', 'PROMPTS-promotion.json']


def read(path):
    return json.loads(path.read_text(encoding='utf-8'))


def relative(path):
    return html.escape(os.path.relpath(path, OUT).replace('\\', '/'), quote=True)


def bust(path):
    with Image.open(path) as image:
        image = image.convert('RGBA')
        box = image.getchannel('A').point(lambda x: 255 if x >= 20 else 0).getbbox()
        if not box:
            raise ValueError('Empty source: '+str(path))
        image = image.crop(box)
        image.thumbnail((108, 124), Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA', (114, 142))
        canvas.alpha_composite(image, ((114-image.width)//2, 142-image.height))
        return canvas


def render_review():
    OUT.mkdir(parents=True, exist_ok=True)
    manifest = read(BASE/'manifest.json')
    previous = {p['key']:p for p in read(ROOT/'art/runtime/portraits-v04/manifest.json')['characters']}
    records = {}
    for file in PROMPT_FILES:
        for r in read(BASE/file)['records']:
            records[r['key']] = r
    cards = []
    images = {}
    for p in manifest['characters']:
        for form in p['forms']:
            key = p['key']+('_'+form['form'] if p['key']=='afei' else '')
            old = next(f for f in previous[p['key']]['forms'] if f['form']==form['form'])
            for version, source in [('old', ROOT/old['source']), ('new', ROOT/form['source'])]:
                target = OUT/(key+'-'+version+'.png')
                if version == 'new':
                    with Image.open(BASE / 'sprites' / (form['brush'] + '_dead.png')) as exported:
                        image = exported.convert('RGBA')
                else:
                    image = bust(source)
                image.save(target)
                images[(key, version)] = image
            record = records.get(key, {})
            refs = record.get('references', record.get('referenced_image_paths', record.get('reference_paths', [])))
            # Promotion references are artwork, not an additional person photo.
            if key=='afei_jiahao':refs = records['afei_normal']['references']
            photo = Path(refs[0]) if refs else None
            photo_html = (f'<a href="{relative(photo)}"><img class="photo" src="{relative(photo)}" alt="照片参考"></a>'
                          if photo and photo.is_file() else '<div class="unknown">未使用本人照片</div>')
            pending = p.get('likeness_status')=='awaiting_verified_photo'
            status = '待核对照片 · 旧稿' if pending else ('本轮重绘' if form['source_revision']=='v05' else '保留原创幻想形象')
            name = p['name']+(' · '+form['form'] if p['key']=='afei' else '')
            cards.append(f'''<article data-name="{html.escape(name)}" data-pending="{str(pending).lower()}">
<h2>{html.escape(name)}</h2><b class="status">{status}</b>
<div class="samples"><figure>{photo_html}<figcaption>照片仅作长相参考</figcaption></figure>
<figure><img class="sprite" src="{key}-old.png" alt="v0.4旧稿"><figcaption>v0.4 旧稿</figcaption></figure>
<figure><img class="sprite" src="{key}-new.png" alt="本次选稿"><figcaption>本次选稿 · 114×142</figcaption></figure></div>
<p>{html.escape(form['review_note'])}</p><a href="{relative(ROOT/form['source'])}">打开完整源图</a></article>''')
    doc = '''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>阿飞远征团 · 照片与旧稿对照</title>
<style>body{margin:24px;background:#292824;color:#e8e0cc;font:15px/1.6 system-ui,'Microsoft YaHei',sans-serif}h1{font-size:25px}h2{font-size:18px;margin:0}.intro{max-width:1100px;color:#cfc6ad}a{color:#bcd8c6}button,input{padding:9px 13px;margin:8px 10px 18px 0}main{display:grid;grid-template-columns:repeat(auto-fit,minmax(540px,1fr));gap:20px}article{background:#35332c;padding:18px;border:1px solid #655f50;border-radius:8px}article[data-pending=true]{border-color:#b09a58}.samples{display:flex;align-items:flex-end;gap:12px}figure{margin:10px 0}figcaption{font-size:12px;color:#bcb49f}.photo,.unknown{width:150px;height:174px;object-fit:contain;background:#24231e}.sprite{width:114px;height:142px;background:#454137}.big .sprite{width:171px;height:213px;image-rendering:pixelated}.light .sprite{background:#dacbb1}.unknown{display:grid;place-items:center}.status{color:#ccb481;font-size:13px}.reference{max-width:750px;width:100%;border:1px solid #666}p{font-size:13px}article[hidden]{display:none}@media(max-width:620px){main{grid-template-columns:1fr}.samples{flex-wrap:wrap}}</style>
<h1>阿飞远征团 · 照片、旧稿与新版胸像</h1>
<p class="intro">照片校正阶段重绘了 29 位成员、30 幅主体（含阿飞嘉豪），四位成员仍待可靠照片。v0.7 将当前源图缩到最大 88×100；这里显示头与身体合成后的完整图，进入游戏后再叠加原版装备。小龟保留原创形象，蛤蟆立绘已停用并显示正常阿飞兼容别名。实机验收范围见 v0.7 更新说明，人物辨识度仍待用户定稿。</p>
<input id="search" placeholder="搜索成员"><label><input type="checkbox" id="pending">只看待核对</label><button id="zoom">切换 1× / 1.5×</button><button id="light">切换深／浅底</button>
<details><summary>展开《战场兄弟》官方画法参考（仅供比对，不打入游戏包）</summary><img class="reference" src="../../../references/battle-brothers-style/official-brothers-busts-2016.jpg" alt="官方游戏胸像参考"></details>
<p><a href="../PROMPTS.md">实际生图提示词</a> · <a href="../../../references/2026-09-26-likeness/README.md">照片来源与排除记录</a> · <a href="../build/index.html">全员游戏尺寸检查</a></p><main>'''+''.join(cards)+'''</main>
<script>const search=document.getElementById('search'),pending=document.getElementById('pending');function filter(){for(const c of document.querySelectorAll('article'))c.hidden=!c.dataset.name.includes(search.value)||(pending.checked&&c.dataset.pending!=='true');}search.addEventListener('input',filter);pending.addEventListener('change',filter);document.getElementById('zoom').onclick=()=>document.body.classList.toggle('big');document.getElementById('light').onclick=()=>document.body.classList.toggle('light');</script></html>'''
    (OUT/'likeness.html').write_text(doc,encoding='utf-8')
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 15)
    chosen = [('afei_normal','阿飞'),('damou','王大谋'),('bottle','小酒瓶'),('lili','李李'),('laocai','老蔡'),('xiaopangxu','小胖'),('manyuemei','蔓越莓'),('suwa','苏袜')]
    sheet = Image.new('RGB', (8*136,204), '#36352e');draw=ImageDraw.Draw(sheet)
    for i,(key,name) in enumerate(chosen):
        sprite=images[(key,'new')];sheet.paste(sprite,(i*136+11,10),sprite)
        draw.text((i*136+11,165),name,font=font,fill='#e8e0cc')
    sheet.save(OUT/'sample-strip-1x.png')
    sheet.resize((sheet.width*2,sheet.height*2),Image.Resampling.NEAREST).save(OUT/'sample-strip-2x.png')
    print('Generated 36 comparison cards and 8-character diagnostic strip.')


if __name__=='__main__':
    render_review()
