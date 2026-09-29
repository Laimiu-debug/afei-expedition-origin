"""Offline engine-layer diagnostic; native reference art never enters the mod."""
import json
import xml.etree.ElementTree as ET
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageEnhance, ImageOps

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / 'art/runtime/portraits-v05'
NATIVE = ROOT / '.cache/afei-art/vanilla-layer-audit/entity_0'
OUT = ROOT / 'build/playtest-corpses'


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    native = {s.attrib['id']: s.attrib for s in ET.parse(NATIVE / 'metadata.xml').getroot().iter('sprite')}
    report = json.loads((BASE / 'build/report.json').read_text(encoding='utf-8'))
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 12)

    def layer(canvas, identity):
        meta = native[identity]
        im = Image.open(NATIVE / meta['img'].replace('\\', '/')).convert('RGBA')
        w, h = round(float(meta['right'])-float(meta['left'])), round(float(meta['bottom'])-float(meta['top']))
        im = im.resize((w, h), Image.Resampling.LANCZOS)
        canvas.alpha_composite(im, (80+round(float(meta['left'])), 65-round(float(meta['bottom']))))

    def frame(record, armor=True, helmet=False, flip=False, old=False):
        canvas = Image.new('RGBA', (160,150))
        if old:
            im = Image.open(BASE / 'sprites' / (record['brush'] + '_dead.png')).convert('RGBA')
            im = im.resize((82,102), Image.Resampling.LANCZOS).rotate(-90, expand=True)
            canvas.alpha_composite(im, ((160-im.width)//2,(150-im.height)//2))
        else:
            layer(canvas, 'bust_body_01_dead')
            if armor: layer(canvas, 'bust_body_14_dead')
            im = Image.open(BASE / 'sprites' / (record['brush']+'_corpse_head.png')).convert('RGBA')
            # Reproduce the packed neck pivot, not the alpha bounding centre.
            pivot = record['corpse_neck_anchor']
            head = Image.new('RGBA', (320,320))
            head.alpha_composite(im, (160-pivot[0],160-pivot[1]))
            head = head.resize((250,250), Image.Resampling.LANCZOS)
            head = ImageEnhance.Color(head).enhance(.75).rotate(140, Image.Resampling.BICUBIC)
            canvas.alpha_composite(head, (80-125,65+6-125))
            if helmet: layer(canvas, 'bust_helmet_03_dead')
        return ImageOps.mirror(canvas) if flip else canvas

    records = [r for r in report['portraits'] if r['form'] != 'toad']
    selected = [next(r for r in records if r['key']==key) for key in ['afei','damou','keke','naigai','lili','xiaogui']]
    headers = ['旧：完整胸像横放','新：素装倒地','新：护甲倒地','新：护甲＋头盔','新：镜像朝向']
    sheet = Image.new('RGB',(160*5,175*6+36),(60,60,47)); draw = ImageDraw.Draw(sheet)
    for col,label in enumerate(headers): draw.text((col*160+7,9),label,font=font,fill='white')
    for row,record in enumerate(selected):
        for col in range(5):
            is_turtle = record['key']=='xiaogui'
            tile = frame(record, armor=col!=1,helmet=col>=3 and not is_turtle,flip=col==4,old=col==0)
            sheet.paste(tile,(col*160,row*175+48),tile)
        draw.text((8,row*175+34),record['name']+('（禁戴头盔）' if record['key']=='xiaogui' else ''),font=font,fill='#ebcf9b')
    sheet.save(OUT/'comparison.png')
    all_sheet=Image.new('RGB',(160*5,175*7),(60,60,47)); draw=ImageDraw.Draw(all_sheet)
    for i,record in enumerate(records):
        tile=frame(record,armor=True)
        all_sheet.paste(tile,(i%5*160,i//5*175+20),tile)
        draw.text((i%5*160+5,i//5*175+4),record['name']+(' 嘉豪' if record['form']=='jiahao' else ''),font=font,fill='white')
    all_sheet.save(OUT/'all-members.png')
    # Place the actual native pose beside the corrected custom neck anchors.
    close = Image.new('RGB', (160*4,175*2),(60,60,47)); draw = ImageDraw.Draw(close)
    for row in range(2):
        vanilla = Image.new('RGBA',(160,150))
        for identity in ['bust_body_01_dead','bust_body_14_dead','bust_head_01_dead']:
            layer(vanilla,identity)
        if row: layer(vanilla,'bust_helmet_03_dead')
        close.paste(vanilla,(0,row*175+20),vanilla)
        draw.text((5,row*175+4),'原版位置参考',font=font,fill='white')
        for col,record in enumerate(selected[:3],1):
            tile=frame(record,armor=True,helmet=bool(row))
            close.paste(tile,(col*160,row*175+20),tile)
            draw.text((col*160+5,row*175+4),record['name']+' · 已校正',font=font,fill='white')
    close.resize((1280,700),Image.Resampling.NEAREST).save(OUT/'corrected-neck-review.png')
    (OUT/'README.md').write_text('# 战死图层离线检查\n\n实际头像像素、原版倒地护甲与头盔按锚点合成。新图按颈部锚点仰倒、使用原版躯干，不清除装备；专属头部仅改变画刷支点与运行时姿态，没有重绘闭眼表情。\n\n这不是实机截图。引擎光照、头盔变体、动态翻转与地形仍需实机确认。原版参考图只用于本地检查，不进入安装包。\n',encoding='utf-8')
    print(OUT/'comparison.png')


if __name__ == '__main__': main()
