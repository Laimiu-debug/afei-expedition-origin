"""Offline equipment overlays using exported custom pixels and native brush geometry."""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT=Path(__file__).resolve().parents[1]
BASE=ROOT/'art/runtime/portraits-v05'
NATIVE=ROOT/'art/runtime/afei/v1/build/preview'
OUT=ROOT/'build/blue-team-stories'

def build():
    manifest=json.loads((BASE/'manifest.json').read_text(encoding='utf-8'))
    refs=json.loads((NATIVE/'native-reference-sources.json').read_text(encoding='utf-8'))
    people=[next(p for p in manifest['characters'] if p['key']==key) for key in ['xiaohani','yanzi']]
    def piece(canvas,key,custom=False):
        meta=manifest['geometry']['live'] if custom else refs[key]
        source=BASE/'sprites'/(key+'.png') if custom else NATIVE/meta['url']
        im=Image.open(source).convert('RGBA')
        left,right,top,bottom=(float(meta[k]) for k in ['left','right','top','bottom'])
        size=(round(right-left),round(bottom-top))
        if im.size!=size:im=im.resize(size,Image.Resampling.LANCZOS)
        canvas.alpha_composite(im,(57+round(left),125-round(bottom)))
    font=ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',18)
    small=ImageFont.truetype('C:/Windows/Fonts/msyh.ttc',14)
    sheet=Image.new('RGB',(1000,552),'#302b24');draw=ImageDraw.Draw(sheet)
    draw.text((20,12),'罗一可 · 眼子｜游戏尺寸与装备叠加',font=font,fill='#f5e8cd')
    draw.text((20,42),'离线按实际画刷锚点合成，2× 最近邻显示；尚未实机验收。',font=small,fill='#cbb998')
    OUT.mkdir(parents=True,exist_ok=True)
    for row,person in enumerate(people):
        y=78+row*230;brush=person['forms'][0]['brush']
        draw.text((20,y),person['name'],font=font,fill='#f5e8cd')
        for col,(label,armor,helmet) in enumerate([('素装',False,None),('护甲',True,None),('开面盔',True,'bust_helmet_03'),('全罩盔',True,'bust_helmet_18')]):
            canvas=Image.new('RGBA',(114,156))
            piece(canvas,brush,True)
            if armor:piece(canvas,'bust_body_14')
            piece(canvas,brush+'_head',True)
            if helmet:piece(canvas,helmet)
            canvas.save(OUT/(person['key']+'-'+str(col)+'.png'))
            enlarged=canvas.crop((0,60,114,156)).resize((228,192),Image.Resampling.NEAREST)
            sheet.paste(enlarged,(18+col*247,y+16),enlarged)
            draw.text((28+col*247,y+210),label,font=small,fill='#d9cba8')
    target=OUT/'portraits-review.png';sheet.save(target)
    return target

if __name__=='__main__':print(build())
