"""Local diagnostic: composite exported sprites at their real brush anchors.
Native reference pixels are never copied into the mod package.
"""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT = Path(__file__).resolve().parents[1]
base = ROOT / 'art/runtime/portraits-v05'
native = ROOT / 'art/runtime/afei/v1/build/preview'
refs = json.loads((native / 'native-reference-sources.json').read_text(encoding='utf-8'))
m = json.loads((base / 'manifest.json').read_text(encoding='utf-8'))
def piece(canvas, key, custom=False):
    meta = m['geometry']['live'] if custom else refs[key]
    p = base / 'sprites' / (key+'.png') if custom else native / meta['url']
    im = Image.open(p).convert('RGBA')
    # Native unpacked art uses the cropped brush rectangle, independent of the
    # logical width/height reported for the shared character canvas.
    rect = [float(meta.get(k, default)) for k, default in [('left',-im.width/2),('right',im.width/2),('top',-im.height/2),('bottom',im.height/2)]]
    w,h = round(rect[1]-rect[0]),round(rect[3]-rect[2])
    if im.size != (w,h): im = im.resize((w,h), Image.Resampling.LANCZOS)
    canvas.alpha_composite(im, (80+round(rect[0]),125-round(rect[3])))
font=ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',12)
out=Image.new('RGBA',(160*6,185*3),(57,54,47,255)); draw=ImageDraw.Draw(out)
for col,(key,name) in enumerate([('native','原版'),('afeix_p04_afei_normal','阿飞'),('afeix_p04_damou','大谋'),('afeix_p04_bottle','小酒瓶'),('afeix_p04_wangdazhi','王大芷'),('afeix_p04_xiaogui','小龟')]):
    for row in range(3):
        frame=Image.new('RGBA',(160,170))
        if key=='native':
            piece(frame,'bust_body_01');piece(frame,'bust_head_01');piece(frame,'hair_black_02')
        else:piece(frame,key,True)
        if row:
            piece(frame,'bust_body_14')
        if key != 'native': piece(frame,key+'_head',True)
        if row:
            piece(frame,'bust_helmet_03' if row==1 else 'bust_helmet_18')
            piece(frame,'icon_sword_01');piece(frame,'shield_round_00')
        out.alpha_composite(frame,(col*160,row*185+10))
        draw.text((col*160+8,row*185+2),name,font=font,fill='white')
target=ROOT/'build/playtest-equipment/overlay-reference.png';target.parent.mkdir(parents=True,exist_ok=True)
out.resize((1920,1110),Image.Resampling.NEAREST).save(target)
print(target)
